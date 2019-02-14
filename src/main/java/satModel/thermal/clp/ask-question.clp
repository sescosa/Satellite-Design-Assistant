(defmodule ask)

(defrule ask::ask-question-by-id
	"Ask a question and assert the answer"

	(declare (auto-focus TRUE))
	;; If there is a question with ident ?id...
	(TCS::question (ident ?id) (text ?text) (type ?type))
	;; ... and there is no answer for it
	(not (TCS::answer (ident ?id)))
	;; ... and the trigger fact for this question exists
	?ask <- (TCS::ask ?id)
	=>
	;; Ask the question
	(bind ?answer (ask-user ?text ?type))
	;; Assert the answer as a fact
	(assert (TCS::answer (ident ?id) (text ?answer)))
	;; Remove the trigger
	(retract ?ask)
	;; And finally, exit this module
	(return)
)



