(defrule print-report
	?r1 <- (recommend (correction ?f1) (explanation ?e))
	=>
	(printout t crlf crlf "***Explanation: " ?e crlf crlf)
	(retract ?r1)
)

