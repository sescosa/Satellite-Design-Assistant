; ***************************************
; PROPULSION SUBSYSTEM (AKM only, no ADCS)
;     (4 rules)
; ***************************************

(defrule safety-factor 
    ?miss<- (STRUC-designed (SFu nil) (SFy nil))
    =>
    (modify ?miss (SFu 1.25) (SFy 1.1))
)

(defrule design-STRUC
    ?miss<- (STRUC-designed (satellite-wet-mass ?m&~nil) (length ?L&~nil) (mass-stringers nil) (diameter ?d&~nil) (LFaxial ?LFa&~nil) (LFlateral ?LFl&~nil) (LFbending ?LFb&~nil) (NF-axial ?NFa&~nil) (NF-lateral ?NFl&~nil) (SFu ?SFu&~nil) (SFy ?SFy&~nil) (orbit-altitude# ?alt&~nil) 
              (material ?mat&~nil) (mass-monocoque nil) (lifetime ?life&~nil) (struc-type nil) (solar-array-mass ?SAmass&~nil) (solar-array-area ?SAarea&~nil) (number-SA ?nSA&~nil) (planet ?planet&~nil))
    (material (name ?mat) (young-module ?E) (poisson ?v) (density ?rho) (ultimate-strength ?Fu) (yield-strength ?Fy))
    =>
    (bind ?symbVar (create$ nil))
    (bind ?matlabFile "struc_design")
    (bind ?outputVars (create$ mass_monocoque mass_stringers mass_SA))

    ;; List with input names
    (bind ?key-list (create$ L D mass LFaxial LFlateral LFbending NF_axial NF_lateral SFu SFy E v rho Fu Fy SA_mass_total SA_area number_SA))

    ;; List with input values

    (bind ?element-list (create$ ?L ?d ?m ?LFa ?LFl ?LFb ?NFa ?NFl ?SFu ?SFy ?E ?v ?rho ?Fu ?Fy ?SAmass ?SAarea ?nSA))

    (bind ?input-hmap (hashmap ?element-list ?key-list))

    (printout t "I am evaluating the structure of the satellite..." crlf crlf)

    (bind ?output (matlabf ?input-hmap ?symbVar ?matlabFile ?outputVars))
    

    (bind ?mass-mono (nth$ 1 ?output)) (bind ?mass-s (nth$ 2 ?output)) (bind ?mass-SA (nth$ 3 ?output)) 
    (if (> ?mass-mono ?mass-s) then
        (bind ?struc-typ stringers)
    else
        (bind ?struc-typ monocoque)
    )

    (bind ?mass-total (+ ?mass-SA (min ?mass-mono ?mass-s)))
    (modify ?miss (mass-monocoque ?mass-mono) (mass-stringers ?mass-s) (struc-type ?struc-typ) (mass-SA-beam ?mass-SA) (mass-main-structure ?mass-total))

    (printout t (str-cat "I am checking your results within an error of +/- " ?*error* " %") crlf)
    )

(defrule struc-type
    ?sat <- (STRUC-designed (mass-monocoque ?mc&~nil) (mass-stringers ?ms&~nil) (struc-type nil) )
    =>
    (if (< ?mc ?ms) then
        (modify ?sat (struc-type monocoque) )
    else
        (modify ?sat (struc-type stringers) )
    )
)
; ******************************************
; FILL ANSWER FACT IF INFORMATION IS ALREADY AN INPUT
; ******************************************


(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination orbit-eccentricity lifetime satellite-wet-mass length diameter LFaxial LFlateral LFbending NF-axial NF-lateral material solar-array-area solar-array-mass number-SA planet))

(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule fill-answer-" ?e 
        " (STRUC-designed (" ?e " ?a&~nil)) 
        (answer (ident " ?e ") (text nil))
         => 
         (assert (answer (ident " ?e ") (text ?a))))"
    ))
    (eval ?str)
)


; ******************************************
; FILL STRUC-DESIGN/CHECK FACT WHEN ANSWER IS GIVEN
; ******************************************

(foreach ?e ?input-list
    (bind ?str2 (str-cat "(defrule fill-mission-" ?e 
        " ?sat <- (STRUC-designed (" ?e " nil))
        ?sat2 <- (STRUC-check (" ?e " nil))  
        (answer (ident " ?e ") (text ?a&~nil))
         => 
         (modify ?sat (" ?e " ?a))
         (modify ?sat2 (" ?e " ?a)))"
    ))
    (eval ?str2)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SUPPORTING QUERIES AND FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(deffunction hashmap (?element-list ?key-list)
    
    (bind ?hmap (new java.util.HashMap))
    (bind ?i 1)
    (foreach ?e ?element-list

        (bind ?key (nth$ ?i ?key-list))
        (call ?hmap put ?key (+ ?e 0.0))
        (bind ?i (+ ?i 1))

    )
    (return ?hmap)
)

(deffunction matlabf (?input-hmap ?symbVar ?matlabFile ?outputVars)
    (import satModel.matlab.matlab_STRUC)
    (bind ?power (new matlab_STRUC))
    (bind ?output (call ?power designSTRUC ?input-hmap ?symbVar ?matlabFile ?outputVars))
    (return ?output)
)
