(defrule print-report
	?r1 <- (recommend (correction ?f1) (explanation ?e))
	=>
	(printout t crlf crlf "***Explanation: " ?e crlf crlf)
	(retract ?r1)
)

(defrule comms-report
	?d <- (TTC-designed (cost-opt ?costopt&~nil) (gain-opt ?gopt&~nil) (antenna-opt ?antopt&~nil) (power-opt ?popt&~nil) (TTC-mass ?massopt&~nil) (report nil))
	(TTC-check  (gain-antenna ?gain&~nil)  (peak-power ?p&~nil) (antenna-type ?a&~nil)  (TTC-mass ?m&~nil))
	=>
	(printout t crlf "*************" )
	(printout t crlf "COMMS REPORT")
	(printout t crlf "*************" crlf)
	(printout t  crlf "YOUR DESIGN:" crlf)
	(printout t "-> POWER: " ?p crlf)
	(printout t "-> ANTENNA GAIN: " ?gain crlf)
	(printout t "-> ANTENNA TYPE: " ?a crlf)
	(printout t "-> TTC MASS: " ?m crlf)
	(printout t crlf crlf "I HAVE FOUND THE FOLLOWING OPTIMUM:" crlf)
	;;(printout t "-> COST: " ?costopt " thousand dollars" crlf)
	(printout t "-> PEAK POWER: " ?popt crlf)
	(printout t "-> ANTENNA GAIN: " ?gopt crlf)
	(printout t "-> ANTENNA TYPE: " ?antopt crlf)
	(printout t "-> TTC MASS: " ?massopt crlf crlf)
	(modify ?d (report 1))
)

(defrule margin-analysis-positive
	(TTC-designed (margin ?margin&~nil))
	(TTC-designed (margin-min ?mmin&~nil))
	(TTC-designed (margin-zero ?i&:(eq ?i 0.0)))
	(TTC-designed (margin-uhf ?muhf&~nil))
	?d <- (TTC-designed (margin-analysis nil))
	=>
	(assert (recommend (correction margin) (explanation (str-cat "The margin of the link budget equation is always positive. With a unidirectional antenna of 0 dB you could still have a margin of " ?mmin " dB. Other options could be: having a higher data rate (more data per day, or less contact time) or use a lower band such as UHF, where the margin would be " ?muhf " dB with the gain you are considering. You can run again the checker with the recommended features or stay with this margin: " ?margin " dB."))))
	(modify ?d (margin-analysis 1))
)

(defrule margin-analysis-zero
	(TTC-designed (margin ?margin&~nil))
	(TTC-designed (margin-zero ?mzero&~nil))
	(TTC-designed (margin-min ?i&:(eq ?i 0.0)))
	(TTC-designed (margin-uhf ?muhf&~nil))
	(TTC-designed (gain-opt ?gopt&~nil))
	?d <- (TTC-designed (margin-analysis nil))
	=>
	(assert (recommend (correction margin) (explanation (str-cat "The margin of the link budget equation has a minimum at " ?mzero " dB. With an antenna of " ?gopt " dB you could still have this communication. Other options could be: having a higher data rate (more data per day, or less contact time) or use a lower band such as UHF, where the margin would be " ?muhf " dB, with the gain you are considering. You can run again the checker with the recommended features or stay with this margin: " ?margin " dB."))))
	(modify ?d (margin-analysis 1))
)