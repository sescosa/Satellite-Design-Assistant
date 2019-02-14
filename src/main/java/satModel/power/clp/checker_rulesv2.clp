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
;*****************************************************************************************
;; The next 6 rules assert a recommendation depending on the result of the comparation ;;
;*****************************************************************************************

(defrule battery-small
	(checker (battery-check ?i&:(eq ?i -1)))

	(Mission-check (payload-power# ?p&~nil) (payload-peak-power# ?pe&~nil) (depth-of-discharge ?dod&~nil) 
	(orbit-semimajor-axis ?a&~nil) (worst-sun-angle ?angle&~nil) (fraction-sunlight ?frac&~nil) 
	(satellite-dry-mass ?m&~nil) (lifetime ?life&~nil) (solar-cell-type ?sa&~nil) (battery-type ?bat&~nil) (battery-mass ?bat_mass&~nil) (solar-array-area ?Asa&~nil))

	(batteries (name ?bat) (n ?n&~nil) (Spec_energy_density_batt ?spec_bat&~nil))
    (solar-cells (name ?sa) (Xe ?Xe&~nil) (Xd ?Xd&~nil) (P0 ?p0&~nil) (Id ?Id&~nil) (degradation ?degr&~nil) (Spec_power_SA ?spec_sa&~nil))
	=>
	(bind ?symbVar (create$ Asa spec_energy_density_batt))
    (bind ?matlabFile "power_design")
    (bind ?outputVars (create$ spec_energy_density_batt))

    ;; List with input names
    (bind ?key-list (create$ Pavg_payload Ppeak_payload frac_sunlight worst_sun_angle period lifetime dry_mass DOD Xe Xd P0 Id degradation spec_power_sa n mass_batt))

    ;; List with input values
    (bind ?element-list (create$ ?p ?pe ?frac ?angle (orbit-period ?a) ?life ?m ?dod ?Xe ?Xd ?p0 ?Id ?degr ?spec_sa ?n ?bat_mass))

    (bind ?input-hmap (hashmap ?element-list ?key-list))

    (bind ?output (matlabf ?input-hmap ?symbVar ?matlabFile ?outputVars))


    (assert (recommend (correction neg) (explanation (str-cat "Battery is too small, it won't be able to power the payload during eclipse. With this battery mass you would need a battery type with a specific energy density of: " (round (nth$ 1 ?output)) " W hr/kg. Your actual specific energy density is of: " ?spec_bat " W hr/kg."))))

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

	(Mission-check (payload-power# ?p&~nil) (payload-peak-power# ?pe&~nil) (depth-of-discharge ?dod&~nil) 
	(orbit-semimajor-axis ?a&~nil) (worst-sun-angle ?angle&~nil) (fraction-sunlight ?frac&~nil) 
	(satellite-dry-mass ?m&~nil) (lifetime ?life&~nil) (solar-cell-type ?sa&~nil) (battery-type ?bat&~nil) (battery-mass ?bat_mass&~nil) (solar-array-area ?Asa&~nil) (solar-array-mass ?saMass&~nil))

	(batteries (name ?bat) (n ?n&~nil) (Spec_energy_density_batt ?spec_bat&~nil))
    (solar-cells (name ?sa) (Xe ?Xe&~nil) (Xd ?Xd&~nil) (P0 ?p0&~nil) (Id ?Id&~nil) (degradation ?degr&~nil) (Spec_power_SA ?spec_sa&~nil))
	=>
	(bind ?symbVar (create$ P0 spec_energy_density_batt))
    (bind ?matlabFile "power_design")
    (bind ?outputVars (create$ P0))

    ;; List with input names
    (bind ?key-list (create$ Pavg_payload Ppeak_payload frac_sunlight worst_sun_angle period lifetime dry_mass DOD Xe Xd Asa Id degradation spec_power_sa n mass_batt))

    ;; List with input values
    (bind ?element-list (create$ ?p ?pe ?frac ?angle (orbit-period ?a) ?life ?m ?dod ?Xe ?Xd ?Asa ?Id ?degr ?spec_sa ?n ?bat_mass))

    (bind ?input-hmap (hashmap ?element-list ?key-list))

    (bind ?output (matlabf ?input-hmap ?symbVar ?matlabFile ?outputVars))


    (assert (recommend (correction neg) (explanation (str-cat "Solar array is too small, it won't be able to power the payload and the batteries. I have found that you need an area of "?Asa " squared meters, which means " (round ?saMass) " kg of your current solar cells choice. With your current solar array area you would need a solar cell type with an efficiency of: " (round (/ (nth$ 1 ?output) 13.67)) " %. Your are now using a solar cell with an efficiency of: " (round (/ ?p0 13.67)) " %."))))
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