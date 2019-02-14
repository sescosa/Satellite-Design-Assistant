(defmodule EPS)

(deffunction run-system ()
	(focus EPS)
	(run))


(defglobal ?*error* = 10)
(defglobal ?*planet* = "")
(defglobal ?*grav-param* = 2)
(defglobal ?*planet-radius* = 6378)

(batch satModel/power/clp/templates.clp)
(batch satModel/power/clp/questions-data.clp)
(reset)
(batch satModel/power/clp/jess_functions.clp)
(batch satModel/power/clp/eps_design_rulesv2.clp)

(batch satModel/power/clp/orbit_rules.clp)
(batch satModel/power/clp/checker_rulesv2.clp)
;;(batch satModel/power/clp/report.clp)

(batch satModel/power/clp/read_attributes.clp)


(batch satModel/power/clp/interview.clp)
(batch satModel/power/clp/ask-question.clp)

;;(batch EPS/clp/startup.clp)