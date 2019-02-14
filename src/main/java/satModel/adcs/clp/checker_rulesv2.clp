;*******************************************************************************************************************
;; This first two rules fire the function which compares the values with the calculations, within a range of +- error% ;;
;*******************************************************************************************************************
(defrule thruster-check
	(ADCS-designed (slew-control ?type-calculated&~nil))
	(ADCS-check (slew-control ?type-check&~nil))
	=>
	(assert (checker (thruster-check (check-type ?type-calculated ?type-check))))
)

(defrule numberRW-check
	(ADCS-check (number-RW ?num&~nil))
	(ADCS-designed (ADCS-type ?typ&:(eq ?typ three-axis)))
	(checker (type-check ?i&:(eq ?i 1)))
	=>
	(assert (checker (RW-check (check-number ?num))))
)

(defrule type-check-rule
	(ADCS-designed (ADCS-type ?type-calculated&~nil))
	(ADCS-check (ADCS-type ?type-check&~nil))
	=>
	(assert (checker (type-check (check-type ?type-calculated ?type-check))))
)

(defrule mass-check-rule
	(ADCS-designed (ADCS-mass# ?mass-calculated&~nil))
	(ADCS-designed (ADCS-type ?typ&:(eq ?typ three-axis)))
	(ADCS-check (ADCS-mass# ?mass-check&~nil))
	=>
	(assert (checker (mass-check (check-attribute ?mass-calculated ?mass-check))))
)

(defrule drag-check
	(ADCS-check (drag-coefficient ?coef&~nil))
	=>
	(assert (checker (drag-check (check-drag ?coef))))
)

;*****************************************************************************************
;; The next 6 rules assert a recommendation depending on the result of the comparation ;;
;*****************************************************************************************

(defrule mass-small
	(checker (mass-check ?i&:(eq ?i -1)))

	(ADCS-designed (ADCS-mass# ?mass&~nil))
	(ADCS-check (ADCS-mass# ?mass-check&~nil))

	=>
    (assert (recommend (correction neg) (explanation (str-cat "ADCS subsystem is too small. You should re-evaluate the mass. My calculations show the aproximate mass should be " (round ?mass) " kg. Your calcuations show the mass of the system is " (round ?mass-check) " kg. I have considered a three axis control system with 4 reaction wheels."))))

)

(defrule mass-big
	(checker (mass-check ?i&:(eq ?i 1)))

	(ADCS-designed (ADCS-mass# ?mass-calculated&~nil))
	(ADCS-check (ADCS-mass# ?mass-check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "ADCS mass is too big, you might be able to optimize it better. With " (round ?mass-calculated) " kg it might be enough for the accuracy needed. Your actual ADCS mass is of: " (round ?mass-check) " kg. I have considered a three axis control system with 4 reaction wheels."))))
)

(defrule mass-ok
	(checker (mass-check ?i&:(eq ?i 0)))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "ADCS subsystem mass is inside the range calculated. Within an error of +/- " ?*error* " %"))))
)

(defrule type-ok
	(checker (type-check ?i&:(eq ?i 1)))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "Based on the accuracy requirement, ADCS subsystem type is correctly chosen."))))
)

(defrule type-not
	(checker (type-check ?i&:(eq ?i 0)))

	(ADCS-designed (ADCS-requirement ?calculated&~nil))
	(ADCS-check (ADCS-requirement ?check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "I have chosen another type of control subsystem, based on the accuracy you need, a " ?calculated " type should work better than the " ?check " type."))))
)

(defrule thruster-ok
	(checker (thruster-check ?i&:(eq ?i 1)))
	=>
	(assert (recommend (correction pos) (explanation (str-cat "You have selected the right slew control system for the required slew angle rate."))))
)

(defrule thruster-not
	(checker (thruster-check ?i&:(eq ?i 0)))

	(ADCS-designed (slew-control ?calculated&~nil))
	(ADCS-check (slew-control ?check&~nil))
	=>
	(assert (recommend (correction neg) (explanation (str-cat "I have chosen another type of slew control subsystem, based on the slew rate you need, a " ?calculated " type should work better than the " ?check " type."))))
)

(defrule numberRW-ok
	(checker (RW-check ?i&:(eq ?i 1)))
	=>
	(assert (recommend (correction pos) (explanation "The number of reaction wheels is correct.")))
)

(defrule numberRW-not
	(checker (RW-check ?i&:(eq ?i 0)))
	=>
	(assert (recommend (correction neg) (explanation "You should put more reaction wheels in case they fail. The recommendation is to use 4 of them.")))
)


(defrule drag-not
	(checker (RW-check ?i&:(eq ?i 0)))
	=>
	(assert (recommend (correction neg) (explanation "You might want to recalculate the drag coefficient. It is too high.")))
)



;*******************************************************
;; Function to compare the values with the calculations
;*******************************************************

(deffunction check-attribute (?calculated ?check)
"Returns -1 if attribute is too small, 1 if attribute is too big, and 0 if attribute is okay"
	(if (< ?check (* ?calculated (- 1 (/ ?*error* 100)))) then
		(return -1)
	else 
		(if (> ?check (* ?calculated (+ 1 (/ ?*error* 100)))) then
		(return 1)
		else
		(return 0)
		)
	)
)

(deffunction check-type (?type-calculated ?type-check)
"Returns 1 if type is the same, and 0 if not"

		(if (eq ?type-calculated ?type-check) then
			(return 1)
		else
			(return 0))

)

(deffunction check-number (?num)
"Returns 1 if theres is at least 4 Reaction Wheels"
	(if (> ?num 3) then
		(return 1)
	else
		(return 0)
	)
)
(deffunction check-drag (?coef)
"Returns 0 if drag coefficient is too big"
	(if (> ?coef 7) then
		(return 0)
	else
		(return 1)
	)
)

;*******************************************************
;; REPORT for additional information
;*******************************************************

(defrule adcs-report-three-axis
	?d <- (ADCS-designed (ADCS-type ?typ&:(eq ?typ three-axis)) (sensors $?sens&:(> (length$ $?sens) 1)) (best-sensor ?best&~nil) (report nil))

	=>
	(assert (recommend (correction neutral) (explanation (str-cat "The ADCS subsystem depends a lot on engineering decisions that cannot be decided in the preliminary design. Taking this into account, our model has estimated that the most suitable control system is: " ?typ ". It is important to pay attention to the following elements: "))))

	(assert (recommend (correction none) (explanation (str-cat "    SENSORS: When using a three axis control system, the most common sensors to use are the following: " (nth$ 1 $?sens) ", " (nth$ 2 $?sens) ", " (nth$ 3 $?sens) " and " (nth$ 4 $?sens) ))))

	(assert (recommend (correction none) (explanation (str-cat "    TRACKING SENSOR: Based on the accuracy needed for the mission, the most suitable sensor would be the following: " ?best))))

	(assert (recommend (correction none) (explanation "    Reaction Wheels SATURATION: In most cases reaction wheels will saturate at some point of the mission. For that reason it is important to consider to add elements that damp the momentum generated by the reaction wheels.")))

	(modify ?d (report 1))
)

(defrule adcs-report-spinner
	?d <- (ADCS-designed (ADCS-type ?typ&:(eq ?typ spinner)) (sensors $?sens&:(> (length$ $?sens) 1)) (best-sensor ?best&~nil) (report nil))

	=>
	(assert (recommend (correction neutral) (explanation (str-cat "The ADCS subsystem depends a lot on engineering decisions that cannot be decided in the preliminary design. Taking this into account, our model has estimated that the most suitable control system is: " ?typ ". It is important to pay attention to the following elements: "))))

	(assert (recommend (correction none) (explanation (str-cat "    SENSORS: When using a spinner control system, the most common sensors to use are the following: " (nth$ 1 $?sens) " and " (nth$ 2 $?sens) ))))

	(assert (recommend (correction none) (explanation (str-cat "** TRACKING SENSOR: Based on the accuracy needed for the mission, the most suitable sensor would be the following: " ?best))))

	(assert (recommend (correction none) (explanation "    Payload pointing and attitude sensor operations are limited without a DESPUN platform. Thrusters may be required to reorient the momentum vector and requires a NUTATION damping system.")))

	(modify ?d (report 1))
)

(defrule adcs-report-grav
	?d <- (ADCS-designed (ADCS-type ?typ&:(eq ?typ grav-grad)) (sensors $?sens&:(> (length$ $?sens) 1)) (best-sensor ?best&~nil) (report nil))

	=>

	(assert (recommend (correction neutral) (explanation (str-cat "The ADCS subsystem depends a lot on engineering decisions that cannot be decided in the preliminary design. Taking this into account, our model has estimated that the most suitable control system is: " ?typ ". It is important to pay attention to the following elements: "))))

	(assert (recommend (correction none) (explanation (str-cat "    SENSORS: When using a gravity gradient control system, the most common sensors to use are the following: " (nth$ 1 $?sens) " ," (nth$ 2 $?sens) " and " (nth$ 3 $?sens) ))))

	(assert (recommend (correction none) (explanation (str-cat "    TRACKING SENSOR: Based on the accuracy needed for the mission, the most suitable sensor would be the following: " ?best))))

	(assert (recommend (correction none) (explanation "    Gravity gradient is nearly not used in commercial satellite and requires a design specific for the requirements of the mission")))

	(modify ?d (report 1))
)