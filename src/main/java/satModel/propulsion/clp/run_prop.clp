(defmodule PROP)

(deffunction run-system ()
	(focus PROP)
	(run))

(defglobal ?*error* = 10)
(defglobal ?*planet* = "")
(defglobal ?*grav-param* = 2)
(defglobal ?*planet-radius* = 6378)

(batch satModel/propulsion/clp/templates.clp)
(batch satModel/propulsion/clp/questions-data.clp)
(reset)
(batch satModel/propulsion/clp/jess_functions.clp)
(batch satModel/propulsion/clp/propulsion_design_rules.clp)
(batch satModel/propulsion/clp/deltaV_budget_rules.clp)

(batch satModel/propulsion/clp/orbit_rules.clp)
(batch satModel/propulsion/clp/checker_rulesv2.clp)
;;(batch satModel/propulsion/clp/report.clp)

(batch satModel/propulsion/clp/read_attributes.clp)


(batch satModel/propulsion/clp/interview.clp)
(batch satModel/propulsion/clp/ask-question.clp)

;;(batch PROP/clp/startup.clp)