(defmodule TTC)

(deffunction run-system ()
	(focus TTC)
	(run))

(defglobal ?*error* = 10)
(defglobal ?*planet* = "")
(defglobal ?*grav-param* = 2)
(defglobal ?*planet-radius* = 6378)

(batch satModel/comms/clp/templates.clp)
(batch satModel/comms/clp/questions-data.clp)
(reset)
(batch satModel/comms/clp/jess_functions.clp)
(batch satModel/comms/clp/ttc_design_rulesv2.clp)

(batch satModel/comms/clp/orbit_rules.clp)
(batch satModel/comms/clp/checker_rulesv2.clp)
;;(batch satModel/comms/clp/report.clp)

(batch satModel/comms/clp/read_attributes.clp)


(batch satModel/comms/clp/interview.clp)
(batch satModel/comms/clp/ask-question.clp)

;;(batch TTC/clp/startup.clp)