;*******************************************************************************************************************
;; This first two rules fire the function which compares the values with the calculations, within a range of +- error% ;;
;*******************************************************************************************************************

(defrule mass-check
	(TCS-designed (TCS-mass ?m&~nil))
	(TCS-check (TCS-mass ?mcheck&~nil))
	=>
	(assert (checker (mass-check (check-attribute ?m ?mcheck))))
)

(defrule type-check
	(TCS-designed (TCS-type ?typ&~nil))
	(TCS-check (TCS-type ?typcheck&~nil))

	=>
	(assert (checker (type-check (check-type ?typ ?typcheck))))
)

(defrule power-check
	(TCS-designed (TCS-power ?pow&~nil))
	(TCS-check (TCS-power ?powcheck&~nil))

	=>
	(assert (checker (power-check (check-attribute ?pow ?powcheck))))
)



;*****************************************************************************************
;; The next 6 rules assert a recommendation depending on the result of the comparation ;;
;*****************************************************************************************


(defrule mass-small
	(checker (mass-check ?i&:(eq ?i -1)))

	(TCS-designed (TCS-mass ?mass&~nil) (worst-sun-angle ?w&~nil))
	(TCS-check (TCS-mass ?mass-check&~nil))

	=>
    (assert (recommend (correction neg) (explanation (str-cat "Thermal control subsystem mass is too small. You should re-evaluate the mass. My calculations show the aproximate mass should be " (round ?mass) " kg. Your calcuations show the mass of the system is " ?mass-check " kg."))))

)

(defrule mass-big
	(checker (mass-check ?i&:(eq ?i 1)))

	(TCS-designed (TCS-mass ?mass-calculated&~nil) (worst-sun-angle ?w&~nil))
	(TCS-check (TCS-mass ?mass-check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "Thermal control mass is too big, you might be able to optimize it better. With " (round ?mass-calculated) " kg might be enough. Your actual thermal control mass is of: " ?mass-check " kg."))))
)

(defrule mass-ok
	(checker (mass-check ?i&:(eq ?i 0)))
	(TCS-designed (TCS-mass ?mass-calculated&~nil) (worst-sun-angle ?w&~nil))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "Thermal control subsystem mass is inside the range calculated. Within an error of +/- " ?*error* " %"))))
)

(defrule power-small
	(checker (power-check ?i&:(eq ?i -1)))

	(TCS-designed (TCS-power ?pow&~nil) (worst-sun-angle ?w&~nil))
	(TCS-check (TCS-power ?pow-check&~nil))

	=>
    (assert (recommend (correction neg) (explanation (str-cat "Heater power might be too small. You should re-evaluate the calculation. My calculations show the aproximate power should be " (round ?pow) " W. Your calcuations show the power of the heater is " ?pow-check " W."))))

)

(defrule power-big
	(checker (power-check ?i&:(eq ?i 1)))

	(TCS-designed (TCS-power ?pow-calculated&~nil) (worst-sun-angle ?w&~nil))
	(TCS-check (TCS-power ?pow-check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "Heater power is too big, you might be able to optimize it better. With " (round ?pow-calculated) " W might be enough. Your actual power is of: " ?pow-check " W."))))
)

(defrule power-ok
	(checker (power-check ?i&:(eq ?i 0)))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "Heater power is inside the range calculated. Within an error of +/- " ?*error* " %"))))
)

(defrule type-ok
	(checker (type-check ?i&:(eq ?i 1)))
	(TCS-designed (TCS-mass ?mass-calculated&~nil) (worst-sun-angle ?w&~nil))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "Thermal control subsystem type is correctly chosen."))))
)

(defrule type-not
	(checker (type-check ?i&:(eq ?i 0)))

	(TCS-designed (TCS-type ?calculated&~nil) (worst-sun-angle ?w&~nil))
	(TCS-check (TCS-type ?check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "I have chosen another type of thermal control system, based on temperatures during eclipse, a " ?calculated " type should work better than the " ?check " type."))))
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