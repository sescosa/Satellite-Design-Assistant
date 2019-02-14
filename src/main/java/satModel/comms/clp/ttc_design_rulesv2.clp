; *******************************************************
;      Telemetry, Tracking and Command Subsystem Design
;                  (1 rule)
; *******************************************************

(defrule contact-time
    ?sat <- (TTC-designed (contact-time nil) (orbit-altitude# ?alt&~nil) (orbit-inclination ?inc&~nil) (ngs ?n&~nil))
    =>
    (bind ?contact (orekit (* 1000.0 ?alt) (+ ?inc 0.0) ?n))
    (modify ?sat (contact-time ?contact))
)

(defrule design-TTC
    ?miss<- (TTC-designed (trans-power ?p&~nil) (gain-antenna ?g&~nil) (TTC-mass nil) 
        (orbit-inclination ?inc&~nil) (orbit-altitude# ?alt&~nil) 
        (redundancy ?red&~nil) (data-per-day ?dpd&~nil) 
              (satellite-dry-mass ?m&~nil) (cost-opt nil) (gain-opt nil) (antenna-opt nil) (power-opt nil) (Rb-max nil) (EbN0 nil) (lifetime ?life&~nil) (Band ?b&~nil) (MOD ?mod&~nil) (ngs ?n&~nil) (contact-time ?cont&~nil) (planet ?planet&~nil))

    =>
    (bind ?symbVar (create$ Gtx_min))
    (bind ?matlabFile "comms_design")
    (bind ?outputVars (create$ MassOpt cost Gtx_min AntennaCode power_comms_opt Rb_Max EbN0_shannon EbN0_min EbN0 Rb_DL margin_gtx margin_min margin_zero margin_uhf))

    ;; List with input names
    (bind ?key-list (create$ h inc Red dpd Gtx Ptx cost lifetime drymass Band MOD ngs ContactTimePerDayTotal))

    ;; List with input values
    (bind ?cost 30000000)
    (bind ?element-list (create$ ?alt ?inc ?red ?dpd ?g ?p ?cost ?life ?m (band-cast ?b) ?mod ?n ?cont))

    (bind ?input-hmap (hashmap ?element-list ?key-list))

    (printout t "I am evaluating your communications subsystem design..." crlf crlf)

    (bind ?output (matlabf ?input-hmap ?symbVar ?matlabFile ?outputVars))
    

    (bind ?ttcm (nth$ 1 ?output)) (bind ?costopt (nth$ 2 ?output)) (bind ?gopt (nth$ 3 ?output)) (bind ?antopt (nth$ 4 ?output)) (bind ?popt (nth$ 5 ?output))
    (bind ?rbmax (nth$ 6 ?output)) (bind ?ebn0shan (nth$ 7 ?output)) (bind ?ebn0min (nth$ 8 ?output)) (bind ?ebn0 (nth$ 9 ?output)) (bind ?rb (nth$ 10 ?output)) (bind ?marg (nth$ 11 ?output)) (bind ?mmin (nth$ 12 ?output)) (bind ?mzero (nth$ 13 ?output)) (bind ?muhf (nth$ 14 ?output))

    (modify ?miss (TTC-mass ?ttcm) (cost-opt ?costopt) (gain-opt ?gopt) (antenna-opt (antenna-cast ?antopt)) (power-opt ?popt) 
    (Rb-max ?rbmax) (EbN0_shannon ?ebn0shan) (EbN0_min ?ebn0min) (EbN0 ?ebn0) (Rb ?rb) (margin ?marg) (margin-min ?mmin) (margin-zero ?mzero) (margin-uhf ?muhf))

    (printout t (str-cat "I am checking your results within an error of +/- " ?*error* " %") crlf)
    )

; ******************************************
; FILL ANSWER FACT IF INFORMATION IS ALREADY AN INPUT
; ******************************************


(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination data-per-day redundancy trans-power gain-antenna lifetime satellite-dry-mass Band MOD ngs planet))

(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule fill-answer-" ?e 
        " (TTC-designed (" ?e " ?a&~nil)) 
        (answer (ident " ?e ") (text nil))
         => 
        (assert (answer (ident " ?e ") (text ?a))))"
    ))
    (eval ?str)
)


; ******************************************
; FILL TTC-DESIGN/CHECK FACT WHEN ANSWER IS GIVEN
; ******************************************

(foreach ?e ?input-list
    (bind ?str2 (str-cat "(defrule fill-TTC-" ?e 
        " ?sat <- (TTC-designed (" ?e " nil))
        ?sat2 <- (TTC-check (" ?e " nil))  
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
    (import satModel.matlab.matlab_TTC)
    (bind ?power (new matlab_TTC))
    (bind ?output (call ?power designTTC ?input-hmap ?symbVar ?matlabFile ?outputVars))
    (return ?output)
)

(deffunction band-cast (?band-name)
    (if (eq ?band-name UHF) then
        (return 1)
    else 
        (if (eq ?band-name Sband) then
        (return 2)
        else
            (if (eq ?band-name Xband) then
                (return 3)
            else
                (return 4)
            )
        )
    )
)

(deffunction antenna-cast (?antenna-code)
    (if (eq ?antenna-code 1.0) then
        (return Dipole)
    else 
        (if (eq ?antenna-code 2.0) then
            (return Patch)
        else
            (return Parabolic)
        )
    )
)

(deffunction orekit (?h ?ideg ?ngs)
    (import satModel.Orekit_Sergio2)
    (bind ?contact (new Orekit_Sergio2))
    
    (bind ?output (call ?contact getContactTime ?h ?ideg ?ngs))
 
    (return ?output)
)