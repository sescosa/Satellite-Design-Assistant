;*******************************************************************************************************************
;; This first two rules fire the function which compares the values with the calculations, within a range of +- error% ;;
;*******************************************************************************************************************

(defrule solar-array-check
	(declare (salience 20))
	(Mission-designed (solar-array-area ?SA-calculated&~nil))
	(Mission-check (solar-array-area ?SA-check&~nil))
	;;(checker (solar-array-area-check nil))
	=>
	(assert (checker (solar-array-area-check (check-attribute ?SA-calculated ?SA-check))))
)

(defrule battery-check
	(Mission-designed (battery-mass ?bat-calculated&~nil))
	(Mission-check (battery-mass ?bat-check&~nil))
	;;(checker (battery-check nil))
	=>
	(assert (checker (battery-check (check-attribute ?bat-calculated ?bat-check))))
)

(defrule mass-check
	(Mission-designed (EPS-mass# ?m&~nil))
	(Mission-check (EPS-mass# ?mcheck&~nil))
	=>
	(assert (checker (mass-check (check-attribute ?m ?mcheck))))
)
;*****************************************************************************************
;; The next 6 rules assert a recommendation depending on the result of the comparation ;;
;*****************************************************************************************
(defrule mass-small
	(checker (mass-check ?i&:(eq ?i -1)))

	(Mission-designed (EPS-mass# ?mass&~nil) (worst-sun-angle ?w&~nil))
	(Mission-check (EPS-mass# ?mass-check&~nil))

	=>
    (assert (recommend (correction neg) (explanation (str-cat "Electrical power subsystem mass is too small. You should re-evaluate the mass. My calculations show the aproximate mass should be " (round ?mass) " kg. Your calcuations show the mass of the system is " ?mass-check " kg. Maybe you didn't consider the mass of other components such as the converter, control unit or wiring"))))

)

(defrule mass-big
	(checker (mass-check ?i&:(eq ?i 1)))

	(Mission-designed (EPS-mass# ?mass-calculated&~nil) (worst-sun-angle ?w&~nil))
	(Mission-check (EPS-mass# ?mass-check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "Electrical power subsystem mass is too big, you might be able to optimize it better. With " (round ?mass-calculated) " kg might be enough. Your actual thermal control mass is of: " ?mass-check " kg."))))
)

(defrule mass-ok
	(checker (mass-check ?i&:(eq ?i 0)))
	(Mission-designed (EPS-mass# ?mass-calculated&~nil) (worst-sun-angle ?w&~nil))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "EPS mass is inside the range calculated. Within an error of +/- " ?*error* " %"))))
)


(defrule battery-small
	(checker (battery-check ?i&:(eq ?i -1)))

	(Mission-check (battery-type ?bat&~nil))
	(Mission-designed (battery-mass ?bat-calculated&~nil))

	(batteries (name ?bat) (n ?n&~nil) (Spec_energy_density_batt ?spec_bat&~nil))
	=>

    (assert (recommend (correction neg) (explanation (str-cat "Battery is too small, it won't be able to power the payload during eclipse. I have found that you need a battery of " (round ?bat-calculated)" kg. With this battery mass you would need a battery type with a higher specific energy density. Your actual specific energy density is of: " ?spec_bat " W hr/kg."))))

)

(defrule battery-big
	(checker (battery-check ?i&:(eq ?i 1)))

	(Mission-designed (battery-mass ?bat-calculated&~nil))
	(Mission-check (battery-mass ?bat-check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "Battery is too big, you might be able to optimize it better. With " (round ?bat-calculated) " kg it might be enough for the payload used. Your actual battery mass is of: " ?bat-check " kg."))))
)

(defrule battery-ok
	(checker (battery-check ?i&:(eq ?i 0)))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "Battery capacity is inside the range calculated. Within an error of +/- " ?*error* " %"))))
)

(defrule solar-array-small
	(checker (solar-array-area-check ?i&:(eq ?i -1)))

	(Mission-check (solar-cell-type ?sa&~nil))
	(Mission-designed (solar-array-area ?Asa&~nil) (solar-array-mass ?saMass&~nil))

    (solar-cells (name ?sa) (Xe ?Xe&~nil) (Xd ?Xd&~nil) (P0 ?p0&~nil) (Id ?Id&~nil) (degradation ?degr&~nil) (Spec_power_SA ?spec_sa&~nil))
	=>

    (assert (recommend (correction neg) (explanation (str-cat "Solar array is too small, it won't be able to power the payload and the batteries. I have found that you need an area of " (round ?Asa) " squared meters, which means " (round ?saMass) " kg of your current solar cells choice. With your current solar array area you would need a solar cell type with a higher efficiency. Your are now using a solar cell with an efficiency of: " (round (/ ?p0 13.67)) " %."))))
)

(defrule solar-array-big
	(checker (solar-array-area-check ?i&:(eq ?i 1)))
	(Mission-designed (solar-array-area ?SA-calculated&~nil) (solar-array-mass ?saMass&~nil))
	(Mission-check (solar-array-area ?SA-check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "Solar array is too big, you might be able to optimize it better. With " (round ?SA-calculated) " squared meters it might be enough to power the payload and batteries. It would have a mass of " (round ?saMass) " kg. You are now using " ?SA-check " squared meters."))))
)

(defrule solar-array-ok
	(checker (solar-array-area-check ?i&:(eq ?i 0)))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "Solar array area is inside the range calculated. Within an error of +/- " ?*error* " %"))))
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