(assert (LAUNCH-check

   (orbit-type no))
)

(defrule assert-mission-check
	?f <- (LAUNCH-check (full nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\launcher\\xls\\launcher_AttributeSet.xls")
	(bind ?list-atrib (get-values ?input))
	(foreach ?e ?list-atrib
		(bind ?value (nth$ 1 (get-limits ?e ?input)))
		(bind ?str (str-cat "(modify ?f (" ?e " " ?value "))"))
		(eval ?str)
	)
	(modify ?f (full 1))
)

(defrule assert-performance
	?f <- (LAUNCH-check (performance $?perf&:(eq (length$ $?perf) 0)) (orbit-type ?orbit&~nil) (launcher ?launcher&~nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\launcher\\xls\\Launcher_DataSet.xls")
	(bind ?value (nth$ 1 (get-performance ?input ?launcher ?orbit)))
	(bind ?str (str-cat "(modify ?f (performance " ?value "))"))
	(eval ?str)
)

(defrule assert-height
	?f <- (LAUNCH-check (height nil) (launcher ?launcher&~nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\launcher\\xls\\Launcher_DataSet.xls")
	(bind ?column height)
	(bind ?value (nth$ 1 (get-performance ?input ?launcher ?column)))
	(bind ?str (str-cat "(modify ?f (height " ?value "))"))
	(eval ?str)
)

(defrule assert-diameter
	?f <- (LAUNCH-check (diameter nil) (launcher ?launcher&~nil))
	=>
	(bind ?input "C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\launcher\\xls\\Launcher_DataSet.xls")
	(bind ?column diameter)
	(bind ?value (nth$ 1 (get-performance ?input ?launcher ?column)))
	(bind ?str (str-cat "(modify ?f (diameter " ?value "))"))
	(eval ?str)
)

; ***************
; EXCEL FUNCTIONS
; ***************


(deffunction get-limits (?param ?input-file)
	(import satModel.ReadExcelLaunch)
	(bind ?read-excel (new ReadExcelLaunch))
	(call ?read-excel setInputFile ?input-file)
	(call ?read-excel read)
	(bind ?list (call ?read-excel getValues ?param))
	(return ?list)
)

(deffunction get-values (?input-file)
	(import satModel.ReadExcelLaunch)
	(bind ?read-excel (new ReadExcelLaunch))
	(call ?read-excel setInputFile ?input-file)
	(call ?read-excel read)
	(bind ?list (call ?read-excel getVars))
	(return ?list)
)

(deffunction get-performance (?input-file ?launcher ?orbit)
	(import satModel.ReadExcelLaunch)
	(bind ?read-excel (new ReadExcelLaunch))
	(call ?read-excel setInputFile ?input-file)
	(call ?read-excel read)
	(bind ?performance (call ?read-excel getPerformance ?launcher ?orbit))
)