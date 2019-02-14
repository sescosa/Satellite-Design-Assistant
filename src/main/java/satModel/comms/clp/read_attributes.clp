(assert (TTC-designed
   (orbit-type no))
)

(assert (TTC-check

   (orbit-type no))
)

(defrule assert-TTC-check
	?f <- (TTC-check (full nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\comms\\xls\\comms_AttributeSet.xls")
	(bind ?list-atrib (get-values ?input))
	(foreach ?e ?list-atrib
		(bind ?value (nth$ 1 (get-limits ?e ?input)))
		(bind ?str (str-cat "(modify ?f (" ?e " " ?value "))"))
		(eval ?str)
	)
	(modify ?f (full 1))
)


(defrule assert-TTC-design
	(TTC-check (full 1))
	?f <- (TTC-designed (full nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\comms\\xls\\comms_AttributeSet.xls")
	(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination data-per-day redundancy trans-power peak-power gain-antenna lifetime satellite-dry-mass Band MOD ngs planet))
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