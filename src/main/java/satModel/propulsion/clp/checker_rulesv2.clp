;*******************************************************************************************************************
;; This first two rules fire the function which compares the values with the calculations, within a range of +- error% ;;
;*******************************************************************************************************************

(defrule deorbit-check
	(PROP-designed (deorbiting-strategy ?stdes&~nil) (propulsion-mass# ?massdes&~nil) (planet ?planet&~nil))
	(PROP-check (deorbiting-strategy ?stcheck&~nil))
	?ch <- (checker (deorbit-check nil))
	=>
	(modify ?ch (deorbit-check (check-type ?stdes ?stcheck)))
)

(defrule propulsion-mass-check
	(PROP-designed (propulsion-mass# ?massdes&~nil))
	(PROP-check (propulsion-mass# ?masscheck&~nil))
	?ch <- (checker (mass-check nil) (dry-check nil) (deorbit-check nil))
	=>
	(modify ?ch (mass-check (check-attribute ?massdes ?masscheck)))
)

(defrule dry-mass-check
	(PROP-designed (satellite-dry-mass ?massdes&~nil) (propulsion-mass# ?prop&~nil) (deorbiting-strategy ?stdes&~nil) (planet ?planet&~nil))
	(PROP-check (satellite-dry-mass ?masscheck&~nil))
	?ch <- (checker (dry-check nil))
	=>
	(modify ?ch (dry-check (check-attribute ?massdes ?masscheck)))
)



;*****************************************************************************************
;; The next 6 rules assert a recommendation depending on the result of the comparation ;;
;*****************************************************************************************


(defrule mass-small
	(checker (mass-check ?i&:(eq ?i -1))  )

	(PROP-designed (propulsion-mass# ?mass&~nil) )
	(PROP-check (propulsion-mass# ?mass-check&~nil))

	=>
    (assert (recommend (correction neg) (explanation (str-cat "The propulsion subsystem is too small. You should re-evaluate the mass. My calculations show the aproximate mass should be " (round ?mass) " kg. Your calcuations show the mass of the system is " ?mass-check " kg."))))

)

(defrule mass-big
	(checker (mass-check ?i&:(eq ?i 1))  )

	(PROP-designed (propulsion-mass# ?mass-calculated&~nil) )
	(PROP-check (propulsion-mass# ?mass-check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "The propulsion mass is too big, you might be able to optimize it better. With " (round ?mass-calculated) " kg might be enough. Your actual propulsion mass is of: " ?mass-check " kg."))))
)

(defrule mass-ok
	(checker (mass-check ?i&:(eq ?i 0))  )
	(PROP-designed (propulsion-mass# ?mass-calculated&~nil) )
	=>
	(assert (recommend (correction pos) (explanation (str-cat "The mass of the propulsion subsystem is inside the range calculated. Within an error of +/- " ?*error* " %"))))
)

(defrule dry-mass-small
	(checker (dry-check ?i&:(eq ?i -1)) )

	(PROP-designed (satellite-dry-mass ?mass&~nil))
	(PROP-check (satellite-dry-mass ?mass-check&~nil))

	=>
    (assert (recommend (correction neg) (explanation (str-cat "Satellite dry mass might be too small. You should re-evaluate the mass. My calculations show the aproximate mass should be " (round ?mass) " kg. Your calcuations show the dry mass of the satellite is " ?mass-check " kg."))))

)

(defrule dry-mass-big
	(checker (dry-check ?i&:(eq ?i 1)) )

	(PROP-designed (satellite-dry-mass ?mass-calculated&~nil))
	(PROP-check (satellite-dry-mass ?mass-check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "Satellite dry mass is too big, you might be able to optimize it better. With " (round ?mass-calculated) " kg might be enough. Your actual satellite dry mass is of: " ?mass-check " kg."))))
)

(defrule dry-mass-ok
	(checker (dry-check ?i&:(eq ?i 0)) )
	=>
	(assert (recommend (correction pos) (explanation (str-cat "Satellite dry mass is inside the range calculated. Within an error of +/- " ?*error* " %"))))
)

(defrule deorbit-ok
	(checker (deorbit-check ?i&:(eq ?i 1)) )
	=>
	(assert (recommend (correction pos) (explanation (str-cat "Based on the altitude of your orbit, deorbiting strategy is correctly chosen."))))
)

(defrule deorbit-not
	(checker (deorbit-check ?i&:(eq ?i 0)) )

	(PROP-designed (deorbiting-strategy ?calculated&~nil))
	(PROP-check (deorbiting-strategy ?check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "I have chosen another type of deorbiting strategy, based on the type of orbit, a " ?calculated " strategy should work better than the " ?check " strategy."))))
)

;*******************************************************
;; Function to compare the values with the calculations
;*******************************************************

(deffunction check-attribute (?calculated ?check)
"Returns -1 if attribute is too small, 1 if attribute is too big, and 0 if attribute is okay"
	(if (< ?check (* ?calculated (- 1 (/ ?*error* 100)))) then
		(return -1)
	else 
		(if (> ?check (* ?calculated (+ 1 (/ ?*error* 100)))) then
		(return 1)
		else
		(return 0)
		)
	)
)

(deffunction check-type (?type-calculated ?type-check)
"Returns 1 if type is the same, and 0 if not"

		(if (eq ?type-calculated ?type-check) then
			(return 1)
		else
			(return 0))

)