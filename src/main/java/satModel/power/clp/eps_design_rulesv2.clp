; ******************************************
;      ELECTRICAL POWER SUBSYSTEM DESIGN
;                  (2 rules)
; ******************************************

(defrule estimate-depth-of-discharge
    ?sat <- (Mission-designed (orbit-type ?typ&~nil) (orbit-RAAN ?raan&~nil)
        (depth-of-discharge nil) )
    =>
    (modify ?sat (depth-of-discharge (get-dod ?typ ?raan)) )
    )

(defrule design-EPS
    ?miss<- (Mission-designed (payload-power# ?p&~nil) (payload-peak-power# ?pe&~nil) (EPS-mass# nil) (depth-of-discharge ?dod&~nil) 
        (orbit-semimajor-axis ?a&~nil) (orbit-type ?typ&~nil) (solar-array-area nil) (battery-capacity nil)
        (worst-sun-angle ?angle&~nil) (fraction-sunlight ?frac&~nil) 
              (satellite-dry-mass ?m&~nil) (satellite-BOL-power# nil) (lifetime ?life&~nil) (solar-cell-type ?sa&~nil) (battery-type ?bat&~nil))
              
    (batteries (name ?bat) (n ?n&~nil) (Spec_energy_density_batt ?spec_bat&~nil))
    (solar-cells (name ?sa) (Xe ?Xe&~nil) (Xd ?Xd&~nil) (P0 ?p0&~nil) (Id ?Id&~nil) 
    (degradation ?degr&~nil) (Spec_power_SA ?spec_sa&~nil))
    =>
    (bind ?symbVar (create$ Asa mass_batt))
    (bind ?matlabFile "power_design")
    (bind ?outputVars (create$ mass_EPS P_bol Asa mass_sa Cr P_eol mass_batt))

    ;; List with input names
    (bind ?key-list (create$ Pavg_payload Ppeak_payload frac_sunlight worst_sun_angle period lifetime dry_mass DOD Xe Xd P0 Id degradation spec_power_sa n spec_energy_density_batt))

    ;; List with input values
    (bind ?element-list (create$ ?p ?pe ?frac ?angle (orbit-period ?a) ?life ?m ?dod ?Xe ?Xd ?p0 ?Id ?degr ?spec_sa ?n ?spec_bat))

    (bind ?input-hmap (hashmap ?element-list ?key-list))

    (printout t "I am evaluating your power subsystem design..." crlf crlf)

    (bind ?output (matlabf ?input-hmap ?symbVar ?matlabFile ?outputVars))
    

    (bind ?epsm (nth$ 1 ?output)) (bind ?pow (nth$ 2 ?output)) (bind ?area (nth$ 3 ?output)) (bind ?samass (nth$ 4 ?output)) (bind ?batcap (nth$ 5 ?output))
    (bind ?pow_eol (nth$ 6 ?output)) (bind ?batmass (nth$ 7 ?output))

    (modify ?miss (EPS-mass# ?epsm) (satellite-BOL-power# ?pow) (solar-array-area ?area) (solar-array-mass ?samass) (battery-capacity ?batcap) 
    (satellite-EOL-power# ?pow_eol) (battery-mass ?batmass))

    (printout t (str-cat "I am checking your results within an error of +/- " ?*error* " %") crlf)
    )
; ******************************************
; FILL ANSWER FACT IF INFORMATION IS ALREADY AN INPUT
; ******************************************


(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN payload-power# payload-peak-power# lifetime satellite-dry-mass solar-cell-type battery-type planet))
(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule fill-answer-" ?e 
        " (Mission-designed (" ?e " ?a&~nil)) 
        (answer (ident " ?e ") (text nil))
         => 
         (assert (answer (ident " ?e ") (text ?a))))"
    ))
    (eval ?str)
)


; ******************************************
; FILL MISSION-DESIGN/CHECK FACT WHEN ANSWER IS GIVEN
; ******************************************

(foreach ?e ?input-list
    (bind ?str2 (str-cat "(defrule fill-mission-" ?e 
        " ?sat <- (Mission-designed (" ?e " nil))
        ?sat2 <- (Mission-check (" ?e " nil))  
        (answer (ident " ?e ") (text ?a&~nil))
         => 
         (modify ?sat (" ?e " ?a))
         (modify ?sat2 (" ?e " ?a)))"
    ))
    (eval ?str2)
)


; ******************************************
; SUPPORTING QUERIES AND FUNCTIONS
; ******************************************

(deffunction get-dod (?type ?raan) ; see SMAD Page 422
"This function estimates the depth of discharge of an orbit"
    
    (if (eq ?type GEO) then (bind ?dod 0.8)
        elif (and (eq ?type SSO) (eq ?raan DD)) then (bind ?dod 0.6)
        else (bind ?dod 0.4)
        )
    (return ?dod)
    )

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
    (import satModel.matlab.matlab_EPS)
    (bind ?power (new matlab_EPS))
    (bind ?output (call ?power designEPS ?input-hmap ?symbVar ?matlabFile ?outputVars))
    (return ?output)
)
