(defmodule ADCS)

(deffunction run-system ()
	(focus ADCS)
	(run))

(defglobal ?*error* = 10)
(defglobal ?*planet* = "")
(defglobal ?*grav-param* = 3.986e14)
(defglobal ?*planet-radius* = 6378)

(batch satModel/adcs/clp/templates.clp)
(batch satModel/adcs/clp/questions-data.clp)
(reset)
(batch satModel/adcs/clp/jess_functions.clp)
(batch satModel/adcs/clp/adcs_design_rules.clp)

(batch satModel/adcs/clp/orbit_rules.clp)
(batch satModel/adcs/clp/checker_rulesv2.clp)
;;(batch satModel/adcs/clp/report.clp)

(batch satModel/adcs/clp/read_attributes.clp)


(batch satModel/adcs/clp/interview.clp)
(batch satModel/adcs/clp/ask-question.clp)

;;(batch ADCS/clp/startup.clp)