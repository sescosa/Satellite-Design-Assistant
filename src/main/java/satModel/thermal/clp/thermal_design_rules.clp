; ***************************************
; THERMAL SUBSYSTEM 
;     (4 rules)
; ***************************************

(defrule design-TCS
    ?miss<- (TCS-designed (Thot-max ?Tmax&~nil) (Tcold-min ?Tcold&~nil) (TCS-mass nil) (Qin-max ?qmax&~nil) (Qin-min ?qmin&~nil) 
        (satellite-dimensions $?dim&:(> (length$ $?dim) 0)) (orbit-altitude# ?alt&~nil) 
              (radiator-surface ?rad&~nil) (TCS-power nil) (lifetime ?life&~nil) (insulator-surface ?ins&~nil) (planet ?planet&~nil) )
    (material (name ?rad) (alpha-tir ?alphatirR&~nil) (alpha-vnir ?alphavnirR&~nil) (e ?er&~nil))
    (material (name ?ins) (alpha-tir ?alphatirI&~nil) (alpha-vnir ?alphavnirI&~nil) (e ?ei&~nil))
    =>
    (bind ?symbVar (create$ nil))
    (bind ?matlabFile "tcs_design")
    (bind ?outputVars (create$ mass_TCS power_TCS TCS_type))

    ;; List with input names
    (bind ?key-list (create$ alphaVNIRi alphaTIRi ei alphaVNIR alphaTIR e h Tmin Tmax Qmax Qmin dim1 dim2 dim3))

    ;; List with input values
    (bind ?x (nth$ 1 $?dim)) (bind ?y (nth$ 2 $?dim)) (bind ?z (nth$ 3 $?dim))

    (bind ?element-list (create$ ?alphavnirI ?alphatirI ?ei ?alphavnirR ?alphatirR ?er ?alt ?Tcold ?Tmax ?qmax ?qmin ?x ?y ?z))

    (bind ?input-hmap (hashmap ?element-list ?key-list))

    (printout t "I am evaluating your thermal control subsystem design..." crlf crlf)

    (bind ?output (matlabf ?input-hmap ?symbVar ?matlabFile ?outputVars))
    

    (bind ?mass (nth$ 1 ?output)) (bind ?pow (nth$ 2 ?output)) (bind ?typ (nth$ 3 ?output)) 

    (if (eq ?typ 1.0) then
    	(bind ?type passive)
    else
    	(bind ?type active)
    )
    (modify ?miss (TCS-mass ?mass) (TCS-power ?pow) (TCS-type ?type) )

    (printout t (str-cat "I am checking your results within an error of +/- " ?*error* " %") crlf)
    )

; ******************************************
; FILL ANSWER FACT IF INFORMATION IS ALREADY AN INPUT
; ******************************************


(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination orbit-eccentricity lifetime satellite-dry-mass Thot-max Tcold-min payload-power# radiator-surface insulator-surface Qin-max Qin-min satellite-dimensions planet))
(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule fill-answer-" ?e 
        " (TCS-designed (" ?e " ?a&~nil)) 
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
    (bind ?str2 (str-cat "(defrule fill-thermal-" ?e 
        " ?sat <- (TCS-designed (" ?e " nil))
        ?sat2 <- (TCS-check (" ?e " nil))  
        (answer (ident " ?e ") (text ?a&~nil))
         => 
         (modify ?sat (" ?e " ?a))
         (modify ?sat2 (" ?e " ?a)))"
    ))
    (eval ?str2)
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
    (import satModel.matlab.matlab_TCS)
    (bind ?power (new matlab_TCS))
    (bind ?output (call ?power designTCS ?input-hmap ?symbVar ?matlabFile ?outputVars))
    (return ?output)
)