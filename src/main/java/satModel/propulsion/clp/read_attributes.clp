(assert (PROP-designed
   (orbit-type no))
)

(assert (PROP-check

   (orbit-type no))
)

(assert (checker 
	(active y))
)

(defrule assert-PROP-check
	?f <- (PROP-check (full nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\propulsion\\xls\\propulsion_AttributeSet.xls")
	(bind ?list-atrib (get-values ?input))
	(foreach ?e ?list-atrib
		(bind ?value (nth$ 1 (get-limits ?e ?input)))
		(bind ?str (str-cat "(modify ?f (" ?e " " ?value "))"))
		(eval ?str)
	)
	(modify ?f (full 1))
)


(defrule assert-PROP-design
	(PROP-check (full 1))
	?f <- (PROP-designed (full nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\propulsion\\xls\\propulsion_AttributeSet.xls")
	(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination orbit-eccentricity lifetime propellant-injection propellant-ADCS ADCS-type payload-power# satellite-dimensions deorbiting-strategy planet))
	(foreach ?e ?input-list
		(bind ?value (nth$ 1 (get-limits ?e ?input)))
		(bind ?str (str-cat "(modify ?f (" ?e " " ?value "))"))
		(eval ?str)
	)
	(modify ?f (full 1))
)

; ***************
; EXCEL FUNCTIONS
; ***************


(deffunction get-limits (?param ?input-file)
	(import satModel.ReadExcel)
	(bind ?read-excel (new ReadExcel))
	(call ?read-excel setInputFile ?input-file)
	(call ?read-excel read)
	(bind ?list (call ?read-excel getValues ?param))
	(return ?list)
)

(deffunction get-values (?input-file)
	(import satModel.ReadExcel)
	(bind ?read-excel (new ReadExcel))
	(call ?read-excel setInputFile ?input-file)
	(call ?read-excel read)
	(bind ?list (call ?read-excel getVars))
	(return ?list)
)