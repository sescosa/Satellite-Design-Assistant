;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;         orbit rules
;;           7 rules
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule assign-planet-param
    (declare (salience 50))
    (TCS-designed (planet ?n&~nil))
    (planet (name ?n) (mu ?m) (rad ?rad))
    =>

    (bind ?*grav-param* ?m)
    (bind ?*planet-radius* ?rad)
)


(defrule calculate-orbit-semimajor-axis-sat
    "This rule calculates the semimajor axis of a constellation from the altitude"
    ;;(declare (salience 20))
    ?f <- (TCS-designed (orbit-altitude# ?orb-alt&~nil)
                                   (orbit-semimajor-axis nil) )
    =>
    (bind ?orb-sa (+ ?*planet-radius* ?orb-alt))
    (modify ?f (orbit-semimajor-axis (* 1000 ?orb-sa)) )
)

(defrule calculate-orbit-period
    "This rule calculates the period"
    ;;(declare (salience 20))
    ?f <- (TCS-designed (orbit-semimajor-axis ?a&~nil)
                                   (orbit-period# nil) )
    =>
    (modify ?f (orbit-period# (orbit-period ?a)))
)


(defrule estimate-sun-angle 
    "Worst sun angle set to 45 degrees"
    ;;(declare (salience 20))
    ?sat <- (TCS-designed (worst-sun-angle nil) )
    =>
    (modify ?sat (worst-sun-angle 23) )
    )

(defrule estimate-fraction-of-sunlight
    (declare (salience 20))
    ?sat <- (TCS-designed (orbit-semimajor-axis ?a&~nil) (fraction-sunlight nil))
    =>
    (modify ?sat (fraction-sunlight (estimate-fraction-sunlight ?a)))
    )

;;;; SUPPORTING QUERIES AND FUNCTIONS


(deffunction orbit-velocity (?r ?a)
    (return (sqrt (* ?*grav-param* (- (/ 2 ?r) (/ 1 ?a)))))
    )

(deffunction orbit-period (?a)
    (return (* 2 (pi) (sqrt (/ (** ?a 3) ?*grav-param*))))
    )

(deffunction r-to-h (?r)
    (return (- ?r (* ?*planet-radius* 1000)))
    )

(deffunction h-to-r (?h)
    (return (+ ?r (* ?*planet-radius* 1000)))
    )

(deffunction to-km (?m)
    (return (/ ?m 1000))
    )

(deffunction Earth-subtend-angle (?r)
    "This function returns the angle in degrees subtended by the Earth from 
    the orbit"
    (return (asin (/ (* ?*planet-radius* 1000) ?r)))
    )

(deffunction atmospheric-density (?h)
    "Calculates rho in kg/m^3 as a function of h in m"
    (return (* 1e-5 (exp (/ (- (/ ?h 1000) 85) -33.387))))
    )
(deffunction estimate-fraction-sunlight (?a)
    "Estimate fraction of sunlight based on circular orbit"
    (if (< ?a 7000000) then 
        (bind ?rho (Earth-subtend-angle ?a))
        (bind ?Bs 25)
        (bind ?phi (* 2 (acos (/ (cos ?rho) (cos ?Bs)))))
        (return (- 1 (/ ?phi 360)))
    else (return 0.99))
    )


    
(deffunction get-orbit-altitude (?orbit-str)
    (bind ?orb (new seakers.vassar.Orbit ?orbit-str))
    (return (?orb getAltitude))
    )
