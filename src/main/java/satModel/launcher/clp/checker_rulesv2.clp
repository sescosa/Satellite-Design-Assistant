;*******************************************************************************************************************
;; This first two rules fire the function which compares the values with the calculations, within a range of +- error% ;;
;*******************************************************************************************************************

(defrule diameter-check
	
	(LAUNCH-check (diameter ?diam-limit&~nil) (satellite-dimensions $?dim&:(> (length$ $?dim) 0)) (max-payload ?max-pay&~nil))

	=>
	;; Dimensions 
    (bind ?x (nth$ 1 $?dim)) (bind ?y (nth$ 2 $?dim))

    (bind ?diam (** (+ (* ?x ?x) (* ?y ?y)) 0.5))

	(assert (checker (diameter-check (check-attribute ?diam-limit ?diam))))
)

(defrule height-check

	(LAUNCH-check (height ?h-limit&~nil) (satellite-dimensions $?dim&:(> (length$ $?dim) 0)) (max-payload ?max-pay&~nil))
	
	=>

	;; Dimensions 
	 (bind ?z (nth$ 3 $?dim))

	(assert (checker (height-check (check-attribute ?h-limit ?z))))
)

(defrule payload-check

	(LAUNCH-check (orbit-altitude# ?altitude&~nil) (max-payload ?max-pay&~nil) (satellite-wet-mass ?payload&~nil))
	
	=>
	(assert (checker (payload-check (check-attribute ?max-pay ?payload))))
)
;*****************************************************************************************
;; The next 6 rules assert a recommendation depending on the result of the comparation ;;
;*****************************************************************************************

(defrule diameter-big
	(checker (diameter-check ?i&:(eq ?i 1)))
	(LAUNCH-check (diameter ?diam-limit&~nil) (satellite-dimensions $?dim&:(> (length$ $?dim) 0)))
	=>
	;; Dimensions 
    (bind ?x (nth$ 1 $?dim)) (bind ?y (nth$ 2 $?dim))

    (bind ?diam (** (+ (* ?x ?x) (* ?y ?y)) 0.5))

	(assert (recommend (correction neg) (explanation (str-cat "The maximum diameter of your satellite exceeds the diameter of the laucnher's fairing. Your maximum diameter is of " (round ?diam) " meters, and the diameter of the fairing is " ?diam-limit " meters."))))
)

(defrule diameter-ok
	(checker (diameter-check ?i&:(eq ?i 0)))
	(LAUNCH-check (launcher ?launcher&~nil))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "The maximum diameter of the satellite fits into the fairing of " ?launcher "."))))
)

(defrule height-big
	(checker (height-check ?i&:(eq ?i 1)))
	(LAUNCH-check (height ?h-limit&~nil) (satellite-dimensions $?dim&:(> (length$ $?dim) 0)))
	=>

	;; Dimensions 
	(bind ?z (nth$ 3 $?dim))

	(assert (recommend (correction neg) (explanation (str-cat "The height of your satellite exceeds the height of the launcher's fairing. Your height is of " ?z " meters, and the height of the fairing is " ?h-limit " meters."))))
)

(defrule height-ok
	(checker (height-check ?i&:(eq ?i 0)))
	(LAUNCH-check (launcher ?launcher&~nil))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "The height of the satellite fits into the fairing of " ?launcher "."))))
)

(defrule payload-big
	(checker (payload-check ?i&:(eq ?i 1)))
	(LAUNCH-check (max-payload ?max-pay&~nil) (satellite-wet-mass ?payload&~nil) (launcher ?launcher&~nil))
	=>


	(assert (recommend (correction neg) (explanation (str-cat "Your satellite exceeds the maximum payload that " ?launcher " can put in this orbit. The wet mass of your satellite is " (round ?payload) " kg, and the maximum payload for your orbit and launcher is " (round ?max-pay) " kg."))))
)

(defrule payload-ok
	(checker (payload-check ?i&:(eq ?i 0)))
	(LAUNCH-check (orbit-altitude# ?altitude&~nil) (max-payload ?max-pay&~nil) (satellite-wet-mass ?payload&~nil) (launcher ?launcher&~nil))
	=>
	(assert (recommend (correction pos) (explanation (str-cat ?launcher " has a capability of puting " (round ?max-pay) " kg into an orbit of " ?altitude " km of altitude. The wet mass of the satellite is " (round ?payload) " kg. Therefore, your choice of launcher is possible."))))
)

;*******************************************************
;; Function to compare the values with the calculations
;*******************************************************

(deffunction check-attribute (?calculated ?check)
"Returns 1 if attribute is too big, and 0 if attribute is okay"
	
	(if (> ?check ?calculated) then
	(return 1)
	else
	(return 0)		
	)
)