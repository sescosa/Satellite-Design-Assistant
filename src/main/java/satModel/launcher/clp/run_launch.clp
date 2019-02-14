(defmodule LAUNCH)

(deffunction run-system ()
	(focus LAUNCH)
	(run))


(defglobal ?*error* = 10)
(defglobal ?*planet* = "")
(defglobal ?*grav-param* = 2)
(defglobal ?*planet-radius* = 6378)

(batch satModel/launcher/clp/templates.clp)
(batch satModel/launcher/clp/questions-data.clp)
(reset)
(batch satModel/launcher/clp/jess_functions.clp)
(batch satModel/launcher/clp/launch_design_rules.clp)

(batch satModel/launcher/clp/orbit_rules.clp)
(batch satModel/launcher/clp/checker_rulesv2.clp)
;;(batch satModel/launcher/clp/report.clp)

(batch satModel/launcher/clp/read_attributes.clp)


(batch satModel/launcher/clp/interview.clp)
(batch satModel/launcher/clp/ask-question.clp)

;;(batch LAUNCH/clp/startup.clp)