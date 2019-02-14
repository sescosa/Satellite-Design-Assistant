(assert (STRUC-designed
   (orbit-type no))
)

(assert (STRUC-check

   (orbit-type no))
)

(defrule assert-STRUC-check
	?f <- (STRUC-check (full nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\structure\\xls\\structure_AttributeSet.xls")
	(bind ?list-atrib (get-values ?input))
	(foreach ?e ?list-atrib
		(bind ?value (nth$ 1 (get-limits ?e ?input)))
		(bind ?str (str-cat "(modify ?f (" ?e " " ?value "))"))
		(eval ?str)
	)
	(modify ?f (full 1))
)


(defrule assert-STRUC-design
	(STRUC-check (full 1))
	?f <- (STRUC-designed (full nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\structure\\xls\\structure_AttributeSet.xls")
	(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination orbit-eccentricity lifetime satellite-wet-mass length diameter LFaxial LFlateral LFbending NF-axial NF-lateral material number-SA solar-array-area solar-array-mass planet))
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