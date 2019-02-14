(assert (ADCS-designed
   (orbit-type no))
)

(assert (ADCS-check

   (orbit-type no))
)

(defrule assert-ADCS-check
	?f <- (ADCS-check (full nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\adcs\\xls\\adcs_AttributeSet.xls")
	(bind ?list-atrib (get-values ?input))
	(foreach ?e ?list-atrib
		(bind ?value (nth$ 1 (get-limits ?e ?input)))
		(bind ?str (str-cat "(modify ?f (" ?e " " ?value "))"))
		(eval ?str)
	)
	(modify ?f (full 1))
)


(defrule assert-ADCS-design
	(ADCS-check (full 1))
	?f <- (ADCS-designed (full nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\adcs\\xls\\adcs_AttributeSet.xls")
	(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination ADCS-requirement satellite-dry-mass moments-of-inertia slew-angle satellite-dimensions slew-control number-RW planet))
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