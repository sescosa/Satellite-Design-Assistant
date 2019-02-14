
; ******************************************
;                  ADCS DESIGN
;                    (4 rules)
; ******************************************

(defrule set-thrusters
    ?sat <- (ADCS-designed (slew-control nil) (slew-angle ?s&~nil) (planet ?planet&~nil))
    =>
    (printout t "I am evaluating your ADCS subsystem design..." crlf crlf)
    
    (if (eq ?s 0) then (bind ?th none)
        elif (< ?s 0.5) then (bind ?th thrusters)
        else (bind ?th two-force-thrusters)
    )
    (modify ?sat (slew-control ?th))
)

(defrule set-ADCS-type
    ?sat <- (ADCS-designed (ADCS-requirement ?adcs&~nil) (ADCS-type nil) (planet ?planet&~nil))
    =>

    (if (< ?adcs 1) then (bind ?typ three-axis)
        elif (< ?adcs 5) then (bind ?typ spinner)
        else (bind ?typ grav-grad))
    (modify ?sat (ADCS-type ?typ))
    )

(defrule set-sensors
    ?sat <- (ADCS-designed (sensors nil) (ADCS-type ?typ&~nil))
    =>
    (if (eq ?typ three-axis) then (bind ?sen (create$ horizon sun star inertial))
        elif (eq ?typ grav-grad) then (bind ?sen (create$ sun horizon magnetometer))
        else (bind ?sen (create$ payload-pointing inertial))
    )
    (modify ?sat (sensors ?sen))
)

(defrule set-best-sensor
    ?sat <- (ADCS-designed (best-sensor nil) (ADCS-requirement ?adcs&~nil))
    =>
    (if (< ?adcs 0.01) then (bind ?sen star-sensor)
        elif (< ?adcs 0.25) then (bind ?sen horizon)
        else then (bind ?sen sun)
    )
    (modify ?sat (best-sensor ?sen))
)

(defrule estimate-drag-coefficient
    ?sat <- (ADCS-designed (drag-coefficient nil) (satellite-dimensions $?dim&:(> (length$ $?dim) 0)))
    =>
    (modify ?sat (drag-coefficient (estimate-drag-coeff $?dim)))
    )

(defrule estimate-residual-dipole
    " Anywhere between 0.1 and 20Am^2, 1Am2 for small satellite"
    ?sat <- (ADCS-designed (residual-dipole nil))
    =>
    (modify ?sat (residual-dipole 5.0))
    )

(defrule design-ADCS-3axis
    ?sat <- (ADCS-designed (ADCS-requirement ?req&~nil) (ADCS-type ?typ&:(eq ?typ three-axis)) (satellite-dry-mass ?dry-mass&~nil) 
        (moments-of-inertia $?mom&:(> (length$ $?mom) 0)) (orbit-semimajor-axis ?a&~nil)
        (drag-coefficient ?Cd&~nil) (worst-sun-angle ?sun-angle&~nil)  
        (residual-dipole ?D&~nil) (slew-angle ?off-nadir&~nil)
        (satellite-dimensions $?dim&:(> (length$ $?dim) 0))
        (ADCS-mass# nil) (planet ?n&~nil))
    (planet (name ?n) (mu ?mu) (au ?au) (magField ?magF))
    =>
    (bind ?Iy (nth$ 2 $?mom)) (bind ?Iz (nth$ 3 $?mom))
    (bind ?x (nth$ 1 $?dim)) (bind ?y (nth$ 2 $?dim)) (bind ?z (nth$ 3 $?dim))
    (bind ?As (* ?x ?y))
    (bind ?cpscg (* 0.2 ?x)) (bind ?cpacg (* 0.2 ?x))
    (bind ?q 0.6)
    (bind ?torque (max-disturbance-torque 
            ?a ?off-nadir ?Iy ?Iz ?Cd ?As ?cpacg ?cpscg ?sun-angle ?D ?q ?au ?magF))
    (bind ?ctrl-mass (estimate-att-ctrl-mass (compute-RW-momentum ?torque ?a)))
    (bind ?det-mass (estimate-att-det-mass ?req))
    (bind ?el-mass (+ (* 4 ?ctrl-mass) (* 3 ?det-mass))) ;; 4 control wheels and 3 sensors
    (bind ?str-mass (* 0.01 ?dry-mass))
    (bind ?adcs-mass (+ ?el-mass ?str-mass))
    (modify ?sat (ADCS-mass# ?adcs-mass))
)

(defrule design-ADCS-gravgrad
    ?sat <- (ADCS-designed (ADCS-requirement ?req&~nil) (ADCS-type ?typ&:(eq ?typ grav-grad)) (ADCS-mass# nil) (planet ?planet&~nil))
    =>
    (modify ?sat (ADCS-mass# 0))
)

(defrule design-ADCS-spinner
    ?sat <- (ADCS-designed (ADCS-requirement ?req&~nil) (ADCS-type ?typ&:(eq ?typ spinner)) (ADCS-mass# nil) (planet ?planet&~nil))
    =>
    (modify ?sat (ADCS-mass# 1))
)

;;*********************************
;; SUPPORTING QUERIES AND FUNCTIONS
;;**********************************

(deffunction gravity-gradient-torque (?Iy ?Iz ?a ?off-nadir)
    "This function computes the gravity gradient disturbance torque.
    See SMAD page 367. Verified OK 9/18/12. "
    ; Tg = 3/2.*muE.*(1./R.^3).*(Iz-Iy).*sin(2.*theta.*Rad);
    
    (return (* 1.5 ?mu (/ 1 (** ?a 3)) (- ?Iz ?Iy) (sin ?off-nadir)))
    )

(deffunction aero-torque (?Cd ?As ?a ?cpacg)
    "This function computes the aerodynamic disturbance torque.
    See SMAD page 367. Verified OK 9/18/12."
    ; 
    (bind ?V (orbit-velocity ?a ?a))
    (bind ?rho (atmospheric-density (r-to-h ?a)))
    (return (* 0.5 ?rho ?As ?V ?V ?Cd ?cpacg))
    )

(deffunction solar-pressure-torque (?As ?q ?sun-angle ?cpscg ?au)
    "This function computes the solar pressure disturbance torque.
    See SMAD page 367. Verified OK 9/18/12."
    (bind ?solar-rad 64000000)
    (bind ?distance (* ?au 149597870))
    (bind ?solar-constant (* (/ (* 695508 695508) (* ?au ?au)) ?solar-rad))
    (return (* (/ ?solar-constant 3e8) ?As (+ 1 ?q) (cos ?sun-angle) ?cpscg))
    )

(deffunction magnetic-field-torque (?D ?a ?magF)
    "This function computes the magnetic field disturbance torque.
    See SMAD page 367. Verified OK 9/18/12."
    (return (* 2 (* ?magF 7.96e15) ?D (** ?a -3)))
    )

(deffunction estimate-drag-coeff (?list)
    "This function estimates the drag coefficient from the 
    dimensions of the satellite based on the article by Wallace et al
    Refinements in the Determination of Satellite Drag Coefficients: 
    Method for Resolving Density Discrepancies"
    
    (bind ?L-over-D (/ (max$ ?list) (min$ ?list)))
    (if (> ?L-over-D 3.0) then (return 3.3)
        else (return 2.2))
    )

(deffunction compute-disturbances (?a ?off-nadir ?Iy ?Iz ?Cd ?As ?cpacg ?cpscg ?sun-angle ?D ?q ?au ?magF)
    (bind ?Tg (gravity-gradient-torque ?Iy ?Iz ?a ?off-nadir))
    (bind ?Ta (aero-torque ?Cd ?As ?a ?cpacg))
    (bind ?Tsp (solar-pressure-torque ?As ?q ?sun-angle ?cpscg ?au))
    (bind ?Tm (magnetic-field-torque ?D ?a ?magF))
    (return (create$ ?Tg ?Ta ?Tsp ?Tm))
    )

(deffunction max-disturbance-torque (?a ?off-nadir ?Iy ?Iz ?Cd  ?As ?cpacg ?cpscg ?sun-angle ?D ?q ?au ?magF)
    (return (max$ 
            (compute-disturbances ?a ?off-nadir ?Iy ?Iz ?Cd ?As ?cpacg ?cpscg ?sun-angle ?D ?q ?au ?magF)))
    )

(deffunction compute-RW-momentum (?Td ?a)
    "This function computes the momentum storage capacity that a RW
    needs to have to compensate for a permanent sinusoidal disturbance torque
    that accumulates over a 1/4 period"
    
    (return (* (/ 1 (sqrt 2)) ?Td 0.25 (orbit-period ?a)))
    )

(deffunction estimate-att-ctrl-mass (?h)
    "This function estimates the mass of a RW from its momentum storage capacity.
    It can also be used to estimate the mass of an attitude control system"
    (return (* 1.5 (** ?h 0.6)))
    )

(deffunction estimate-RW-power (?T)
    "This function estimates the power of a RW from its torque authority"
    (return (* 200 ?T))
    )

(deffunction moment-of-inertia (?k ?m ?r)
    (return (* ?k ?m (** ?r 2)))
    )

(deffunction box-moment-of-inertia (?m ?dims)
    (return (map (lambda (?r) (return (moment-of-inertia (/ 1 6) ?m ?r))) ?dims))
    )

(deffunction estimate-att-det-mass (?acc)
    " This function estimates the mass of the sensor required for attitude determination
    from its knowledge accuracy requirement. It is based on data from BAll Aerospace, 
    Honeywell, and SMAD chapter 10 page 327"
    
    (return (* 10 (** ?acc -0.316)))
    )

(deffunction get-star-tracker-mass (?req)
    (if (< ?req 0.1) then (return 24.5)); Ball HAST 
    (if (< ?req 3) then (return 9.5)); Ball CT-602 
    (if (< ?req 5) then (return 6.5)); Ball CT-633
    (if (< ?req 52) then (return 3.2)); Ball HAST 
    )

; ******************************************
; FILL ANSWER FACT IF INFORMATION IS ALREADY AN INPUT
; ******************************************


(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination ADCS-requirement satellite-dry-mass moments-of-inertia slew-angle satellite-dimensions slew-control number-RW planet))
(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule fill-answer-" ?e 
        " (ADCS-designed (" ?e " ?a&~nil)) 
        (answer (ident " ?e ") (text nil))
         => 
         (assert (answer (ident " ?e ") (text ?a))))"
    ))
    (eval ?str)
)


; ******************************************
; FILL ADCS-DESIGN/CHECK FACT WHEN ANSWER IS GIVEN
; ******************************************

(foreach ?e ?input-list
    (bind ?str2 (str-cat "(defrule fill-adcs-" ?e 
        " ?sat <- (ADCS-designed (" ?e " nil))
        ?sat2 <- (ADCS-check (" ?e " nil))  
        (answer (ident " ?e ") (text ?a&~nil))
         => 
         (modify ?sat (" ?e " ?a))
         (modify ?sat2 (" ?e " ?a)))"
    ))
    (eval ?str2)
)
