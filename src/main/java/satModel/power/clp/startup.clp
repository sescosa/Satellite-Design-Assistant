(defmodule startup)
(defrule print-banner
	=>
	(printout t "Type your name and press Enter> ")
	(bind ?name (read))
	(printout t "Type the error you are willing to accept in the check [in %]> ")
	(bind ?*error* (read))


	(printout t crlf "*****************************" crlf)
	(printout t "Hello, " ?name "." crlf)
	(printout t "Welcome to the satellite design assistant" crlf)
	(printout t "Please fill the excel with the inputs you know." crlf)
	(printout t "In case I need more information," crlf)
	(printout t "I will ask it to you now:" crlf)
	(printout t "*************************" crlf crlf)
	)

