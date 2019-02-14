; ***************************************
; PROPULSION SUBSYSTEM (AKM only, no ADCS)
;     (4 rules)
; ***************************************

(defrule get-Isp-injection
    "This rule estimates the Isp injection from the type of propellant"
    ?miss <- (PROP-designed (propellant-injection ?prop&~nil) (Isp-injection nil) )
    =>
    
    (modify ?miss (Isp-injection (get-prop-Isp ?prop)) )
    )

(defrule get-Isp-ADCS
    "This rule estimates the Isp ADCS from the type of propellant"
    ?miss <- (PROP-designed (propellant-ADCS ?prop&~nil) (Isp-ADCS nil) )
    =>
    
    (modify ?miss (Isp-ADCS (get-prop-Isp ?prop)) )
    )

(defrule design-propulsion
    "DeWeck's paper (See http://strategic.mit.edu/docs/2_3_JSR_parametric_NGSO.pdf): 4% of the dry mass of the satellite corresponds to the propulsion subsystem"
    
    ?miss <- (PROP-designed (propulsion-mass# nil)  (satellite-dry-mass ?m&~nil) (planet ?planet&~nil) (deorbiting-strategy ?stdes&~nil))

        =>
   	(printout t "I am evaluating your propulsion subsystem design..." crlf crlf)
    
    (modify ?miss (propulsion-mass# (* ?m 0.04)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SUPPORTING QUERIES AND FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(deffunction rocket-equation-mi-dV-to-mp (?dV ?Isp ?mi)
    ; mprop = mwet*(1-exp(-dV/V0))
    (return (* ?mi (- 1 (exp (/ ?dV (* -9.81 ?Isp))))))
    )

(deffunction rocket-equation-mf-dV-to-mp (?dV ?Isp ?mf)
    ; mprop = mdry*(-1+exp(dV/V0))
    (return (* ?mf (- (exp (/ ?dV (* 9.81 ?Isp))) 1)))
    )

(deffunction get-prop-Isp (?prop)
    (bind ?props (create$ solid hydrazine LH2))
    (bind ?Isps (create$ 210 290 450))
    
    (bind ?ind (member$ ?prop ?props))
    (if (eq ?ind FALSE) then (printout t "get-prop-Isp: propellant not found" crlf) (return FALSE)
    else (return (nth$ ?ind ?Isps)))
    )
; ******************************************
; FILL ANSWER FACT IF INFORMATION IS ALREADY AN INPUT
; ******************************************


(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination orbit-eccentricity lifetime propellant-injection propellant-ADCS ADCS-type  payload-power# satellite-dimensions deorbiting-strategy planet))
(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule fill-answer-" ?e 
        " (PROP-designed (" ?e " ?a&~nil)) 
        (answer (ident " ?e ") (text nil))
         => 
         (assert (answer (ident " ?e ") (text ?a))))"
    ))
    (eval ?str)
)


; ******************************************
; FILL PROP-DESIGN/CHECK FACT WHEN ANSWER IS GIVEN
; ******************************************

(foreach ?e ?input-list
    (bind ?str2 (str-cat "(defrule fill-PROP-" ?e 
        " ?sat <- (PROP-designed (" ?e " nil))
        ?sat2 <- (PROP-check (" ?e " nil))  
        (answer (ident " ?e ") (text ?a&~nil))
         => 
         (modify ?sat (" ?e " ?a))
         (modify ?sat2 (" ?e " ?a)))"
    ))
    (eval ?str2)
)