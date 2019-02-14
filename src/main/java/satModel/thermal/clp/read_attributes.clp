(assert (TCS-designed
   (orbit-type no))
)

(assert (TCS-check

   (orbit-type no))
)

(defrule assert-TCS-check
	?f <- (TCS-check (full nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\thermal\\xls\\thermal_AttributeSet.xls")
	(bind ?list-atrib (get-values ?input))
	(foreach ?e ?list-atrib
		(bind ?value (nth$ 1 (get-limits ?e ?input)))
		(bind ?str (str-cat "(modify ?f (" ?e " " ?value "))"))
		(eval ?str)
	)
	(modify ?f (full 1))
)


(defrule assert-TCS-design
	(TCS-check (full 1))
	?f <- (TCS-designed (full nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\thermal\\xls\\thermal_AttributeSet.xls")
	(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination orbit-eccentricity lifetime satellite-dry-mass Thot-max Tcold-min payload-power# radiator-surface insulator-surface Qin-max Qin-min satellite-dimensions planet))
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