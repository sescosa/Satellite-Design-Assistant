;*******************************************************************************************************************
;; This first two rules fire the function which compares the values with the calculations, within a range of +- error% ;;
;*******************************************************************************************************************

(defrule link-budget-check
	(TTC-designed (EbN0 ?link-calculated&~nil))
	(TTC-designed (EbN0_min ?link-min&~nil))
	(TTC-designed (EbN0_shannon ?link-shannon&~nil))
	=>
	(assert (checker (link-budget-check (check-link-budget ?link-calculated ?link-min ?link-shannon))))
)

(defrule data-rate-check
	(TTC-designed (Rb ?data-rate&~nil))
	(TTC-designed (Rb-max ?data-rate-max&~nil))

	=>
	(assert (checker (data-rate-check (check-datarate ?data-rate ?data-rate-max))))
)


;*****************************************************************************************
;; The next 6 rules assert a recommendation depending on the result of the comparation ;;
;*****************************************************************************************



(defrule data-rate-high
	(checker (data-rate-check ?i&:(eq ?i 1)))
	(TTC-designed (Rb ?data-rate&~nil))
	(TTC-designed (Rb-max ?data-rate-max&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "Data rate is too high. The maximum data rate with this modulation and band width is " (round ?data-rate-max) ". Currently, your data rate is " ?data-rate))))
)

(defrule data-rate-ok
	(checker (data-rate-check ?i&:(eq ?i 0)))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "Data rate is below the maximum. Within an error of +/- " ?*error* " %"))))
)

(defrule link-budget-shannon
	(checker (link-budget-check ?i&:(eq ?i -1)))
	=>
	(assert (recommend (correction neg) (explanation "Your link budget equation doesn't verify the shannon limit, but it is inside the Bit Error Rate and modulation limit.")))
)

(defrule link-budget-both
	(checker (link-budget-check ?i&:(eq ?i -2)))
	=>
	(assert (recommend (correction neg) (explanation "Your link budget equation doesn't verify neither the shannon limit nor the Bit Error Rate and modulation limit.")))
)

(defrule link-budget-mod
	(checker (link-budget-check ?i&:(eq ?i 1)))
	=>
	(assert (recommend (correction neg) (explanation "Your link budget equation doesn't verify the Bit Error Rate and modulation limit, but it is inside the shannon limit.")))
)

(defrule link-budget-ok
	(checker (link-budget-check ?i&:(eq ?i 0)))
	(TTC-designed (MOD ?mod&~nil))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "Your link budget equation verifies the shannon limit and the minimum value for a Modulation of " ?mod " and a Bit Error Rate of 10e-6."))))
)

;*******************************************************
;; Function to compare the values with the calculations
;*******************************************************

(deffunction check-link-budget (?link-calculated ?link-min ?link-shannon)
"Returns -1 if shannon limit fails, 1 if minimum fails, -2 if both limits fail, and 0 if attribute is okay"
	(if (< ?link-calculated (* ?link-shannon (- 1 (/ ?*error* 100)))) then
		(if (< ?link-calculated (* ?link-min (- 1 (/ ?*error* 100)))) then
			(return -2)
		else
			(return -1))
	else 
		(if (< ?link-calculated (* ?link-min (- 1 (/ ?*error* 100)))) then
		(return 1)
		else
		(return 0)
		)
	)
)

(deffunction check-datarate (?data-rate ?data-rate-max)
"Returns 1 if data rate is too high, and 0 if attribute is okay"

		(if (> ?data-rate (* ?data-rate-max (+ 1 (/ ?*error* 100)))) then
			(return 1)
		else
			(return 0))

)

;*******************************************************
;; Report rules
;*******************************************************

(defrule comms-report
	?d <- (TTC-designed (cost-opt ?costopt&~nil) (gain-opt ?gopt&~nil) (antenna-opt ?antopt&~nil) (power-opt ?popt&~nil) (TTC-mass ?massopt&~nil) (report nil))
	(TTC-check  (gain-antenna ?gain&~nil)  (peak-power ?p&~nil) (antenna-type ?a&~nil)  (TTC-mass ?m&~nil))
	=>

	(assert (recommend (correction neutral) (explanation (str-cat "YOUR DESIGN WAS THE FOLLOWING: (1) POWER: " (round ?p) " W. (2) ANTENNA GAIN: " (round ?gain) " dB. (3) ANTENNA TYPE: " ?a ". (4) TTC MASS: " (round ?m) " kg"))))

	(assert (recommend (correction none) (explanation (str-cat "... And I have found the following design minimizing the margin: (1) PEAK POWER: " (round ?popt) " W. (2) ANTENNA GAIN: " (round ?gopt) " dB. (3) ANTENNA TYPE: " ?antopt ". (4) TTC MASS: " (round ?massopt) " kg."))))

	(modify ?d (report 1))
)

(defrule margin-analysis-positive
	(TTC-designed (margin ?margin&~nil))
	(TTC-designed (margin-min ?mmin&~nil))
	(TTC-designed (margin-zero ?i&:(eq ?i 0.0)))
	(TTC-designed (margin-uhf ?muhf&~nil))
	?d <- (TTC-designed (margin-analysis nil))
	=>
	(assert (recommend (correction neutral) (explanation (str-cat "The margin of the link budget equation is always positive. With a unidirectional antenna of 0 dB you could still have a margin of " (round ?mmin) " dB. Other options could be: having a higher data rate (more data per day, or less contact time) or use a lower band such as UHF, where the margin would be " (round ?muhf) " dB with the gain you are considering. You can run again the checker with the recommended features or stay with the margin of your design: " (round ?margin) " dB."))))
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
	(assert (recommend (correction neutral) (explanation (str-cat "The margin of the link budget equation can be minimized to " (round ?mzero) " dB. With an antenna of " (round ?gopt) " dB you could still have this communication. Other options could be: having a higher data rate (more data per day, or less contact time) or use a lower band such as UHF, where the margin would be " (round ?muhf) " dB, with the gain you are considering. You can run again the checker with the recommended features or stay with the margin of your design: " (round ?margin) " dB."))))
	(modify ?d (margin-analysis 1))
)