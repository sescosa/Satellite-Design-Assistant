; ******************************************
;            LAUNCHER FITTING RULES
;                  
; ******************************************

(defrule read-LAUNCHER

"calculates the max payload for that orbit and launcher"

    ?miss<- (LAUNCH-check (orbit-type ?type&~nil) (orbit-altitude# ?alt&~nil) (orbit-inclination ?inc&~nil) (orbit-eccentricity ?ecc&~nil) (orbit-RAAN ?raan&~nil) (launcher ?launch&~nil) (satellite-dimensions $?dim&:(> (length$ $?dim) 0)) (performance $?perf&:(> (length$ $?perf) 0)) (planet ?planet&~nil) (diameter ?d&~nil) (height ?h&~nil) (max-payload nil))
    =>

    (printout t "I am evaluating the performance of the launcher..." crlf crlf)
    (bind ?alfa1 (nth$ 1 ?perf)) (bind ?alfa2 (nth$ 2 ?perf)) (bind ?alfa3 (nth$ 3 ?perf))

    (bind ?max-payload (+ (+ ?alfa1 (* ?alfa2 ?alt)) (* ?alfa3 (* ?alt ?alt))))

    (modify ?miss (max-payload ?max-payload))
    )

; ******************************************
; FILL ANSWER FACT IF INFORMATION IS ALREADY AN INPUT
; ******************************************


(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination orbit-eccentricity planet launcher satellite-dimensions satellite-wet-mass))
(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule fill-answer-" ?e 
        " (LAUNCH-check (" ?e " ?a&~nil) (full 1)) 
        (answer (ident " ?e ") (text nil))
         => 
         (assert (answer (ident " ?e ") (text ?a))))"
    ))
    (eval ?str)
)


; ******************************************
; FILL LAUNCH-DESIGN/CHECK FACT WHEN ANSWER IS GIVEN
; ******************************************

(foreach ?e ?input-list
    (bind ?str2 (str-cat "(defrule fill-LAUNCH-" ?e 
        " ?sat <- (LAUNCH-check (" ?e " nil))  
        (answer (ident " ?e ") (text ?a&~nil))
         => 
         (modify ?sat (" ?e " ?a)))"
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
    (bind ?power (new matlab_EPS))
    (bind ?output (call ?power designEPS ?input-hmap ?symbVar ?matlabFile ?outputVars))
    (return ?output)
)
