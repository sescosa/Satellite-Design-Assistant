(defmodule STRUC)

(deffunction run-system ()
	(focus STRUC)
	(run))


(defglobal ?*error* = 10)
(defglobal ?*planet* = "")
(defglobal ?*grav-param* = 2)
(defglobal ?*planet-radius* = 6378)

(batch satModel/structure/clp/templates.clp)
(batch satModel/structure/clp/questions-data.clp)
(reset)
(batch satModel/structure/clp/jess_functions.clp)
(batch satModel/structure/clp/struc_design_rules.clp)


(batch satModel/structure/clp/orbit_rules.clp)
(batch satModel/structure/clp/checker_rulesv2.clp)
;;(batch satModel/structure/clp/report.clp)

(batch satModel/structure/clp/read_attributes.clp)


(batch satModel/structure/clp/interview.clp)
(batch satModel/structure/clp/ask-question.clp)

;;(batch STRUC/clp/startup.clp)