;*******************************************************************************************************************
;; This first two rules fire the function which compares the values with the calculations, within a range of +- error% ;;
;*******************************************************************************************************************

(defrule mass-check
	(STRUC-designed (mass-main-structure ?m&~nil))
	(STRUC-check (mass-structure ?mcheck&~nil))
	=>
	(assert (checker (mass-check (check-attribute ?m ?mcheck))))
)

(defrule type-check
	(STRUC-designed (struc-type ?typ&~nil))
	(STRUC-check (struc-type ?typcheck&~nil))

	=>
	(assert (checker (type-check (check-type ?typ ?typcheck))))
)





;*****************************************************************************************
;; The next 6 rules assert a recommendation depending on the result of the comparation ;;
;*****************************************************************************************


(defrule mass-small
	(checker (mass-check ?i&:(eq ?i -1)))

	(STRUC-designed (mass-main-structure ?mass&~nil))
	(STRUC-check (mass-structure ?mass-check&~nil))

	=>
    (assert (recommend (correction neg) (explanation (str-cat "Main structure mass is too small. You should re-evaluate the mass. My calculations show the aproximate mass should be " (round ?mass) " kg. Your calcuations show the mass of the structure is " ?mass-check " kg."))))

)

(defrule mass-big
	(checker (mass-check ?i&:(eq ?i 1)))
	(STRUC-designed (mass-main-structure ?mass&~nil))
	(STRUC-check (mass-structure ?mass-check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "Main structure mass is too big, you might be able to optimize it better. With " (round ?mass) " kg might be enough. Your actual main structure mass is of: " ?mass-check " kg."))))
)

(defrule mass-ok
	(checker (mass-check ?i&:(eq ?i 0)))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "Main structure mass is inside the range calculated. Within an error of +/- " ?*error* " %"))))
)


(defrule type-ok
	(checker (type-check ?i&:(eq ?i 1)))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "Based on the ultimate loads during launch, structural design type is correctly chosen."))))
)

(defrule type-not
	(checker (type-check ?i&:(eq ?i 0)))

	(STRUC-designed (struc-type ?calculated&~nil))
	(STRUC-check (struc-type ?check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "I have chosen another design for the structure, based on the ultimate loads during launch, a " ?calculated " design should be lighter than the " ?check " type."))))
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