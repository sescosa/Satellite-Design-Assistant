; 6 RULES to compute total deltaV

(defrule compute-deltaV-injection
    "This rule computes the delta-V required for injection for GEO or MEO assuming a transfer orbit with a perigee 
    of 150km and an apogee at the desired orbit, as suggested in De Weck's paper found in 
    http://strategic.mit.edu/docs/2_3_JSR_parametric_NGSO.pdf. For LEO/SSO, no injection is required."
    
    ?miss <- (PROP-designed (orbit-type ?typ) (orbit-semimajor-axis ?a&~nil) 
         (delta-V-injection nil) (planet ?planet&~nil))
    =>
	(if (or (eq ?typ GEO) (eq ?typ MEO)) then (bind ?dV (compute-dV-injection (+ 6378000 150000) ?a))
	else (bind ?dV 0.0))  
    
    (modify ?miss (delta-V-injection ?dV) )
    )

(defrule compute-deltaV-drag
    "This rule computes the delta-V required to overcome drag. The data comes from 
    De Weck's paper found in http://strategic.mit.edu/docs/2_3_JSR_parametric_NGSO.pdf"
    
    ?miss <- (PROP-designed (orbit-semimajor-axis ?a&~nil) (orbit-eccentricity ?e&~nil) 
        (delta-V-drag nil) (lifetime ?life&~nil) (planet ?planet&~nil))
    =>
    
    (bind ?hp (/ (- (* ?a (- 1 ?e)) 6378000) 1000)); dV for station-keeping (m/s/yr)
    (if (< ?hp 500) then (bind ?dV 12)
        elif (< ?hp 600) then (bind ?dV 5)
        elif(< ?hp 1000) then (bind ?dV 2)
        elif (> ?hp 1000) then (bind ?dV 0)
        ) 

    (modify ?miss (delta-V-drag (* ?dV ?life)) )
    )

(defrule compute-deltaV-ADCS
    "This rule computes the delta-V required for attitude control. The data comes from 
    De Weck's paper found in http://strategic.mit.edu/docs/2_3_JSR_parametric_NGSO.pdf"
    
    ?miss <- (PROP-designed (ADCS-type ?adcs) (delta-V-ADCS nil) 
        (lifetime ?life&~nil) (planet ?planet&~nil))
    =>
    
    (if (eq ?adcs three-axis) then (bind ?dV 20)
        elif (eq ?adcs grav-gradient) then (bind ?dV 0))
    
    (modify ?miss (delta-V-ADCS (* ?life ?dV)) )
    )

(defrule drag-based-deorbiting-mode
    "This rule sets the deorbiting mode to drag-based"
    ?miss <- (PROP-designed  (deorbiting-strategy nil) (orbit-type ?typ&:(or (eq ?typ LEO) (eq ?typ SSO))) (planet ?planet&~nil)  )
    =>
    (modify ?miss (deorbiting-strategy drag-based) )
    )

(defrule graveyard-deorbiting-mode
    "This rule sets the deorbiting mode to graveyard"
    ?miss <- (PROP-designed  (deorbiting-strategy nil) (orbit-type ?typ&:(or (eq ?typ GEO) (eq ?typ MEO))) (planet ?planet&~nil))
    =>
    (modify ?miss (deorbiting-strategy graveyard) )
    )
	
(defrule compute-deltaV-deorbiting-drag-based
    "This rule computes the delta-V required for deorbiting assuming a change of semimajor axis
    so that the perigee is the surface of the earth"
    
    ?miss <- (PROP-designed (orbit-semimajor-axis ?a&~nil) 
        (delta-V-deorbit nil) (deorbiting-strategy drag-based) (planet ?planet&~nil))
    =>
    
    (bind ?dV (compute-dV-deorbit ?a 6378000))
    (modify ?miss (delta-V-deorbit ?dV) )
    )

(defrule compute-deltaV-deorbiting-graveyard
    "This rule computes the delta-V required for deorbiting to a graveyard orbit. 
    This is calculated as a change of semimajor axis to raise perigee by a certain amount
    given in http://www.iadc-online.org/Documents/IADC-UNCOPUOS-final.pdf"
    
    ?miss <- (PROP-designed (orbit-type GEO) (satellite-dry-mass ?m&~nil) 
        (orbit-semimajor-axis ?a&~nil) (satellite-dimensions $?dim)
        (delta-V-deorbit nil) (deorbiting-strategy graveyard) (planet ?planet&~nil))
    =>
    (bind ?A (* (nth$ 1 $?dim) (nth$ 2 $?dim)))
    (bind ?dV (compute-dV-graveyard ?a 1.5 ?A ?m))
    (modify ?miss (delta-V-deorbit ?dV) )
    )

(defrule compute-deltaV-total
    "This rule computes the delta-V as the sum of all deltaVs"
    
    ?miss <- (PROP-designed (delta-V-injection ?inj&~nil) 
        (delta-V-ADCS ?adcs&~nil) 
        (delta-V-drag ?drag&~nil) (delta-V-deorbit ?deorbit&~nil) (delta-V nil)  (planet ?planet&~nil)  )
    =>
    
    (modify ?miss (delta-V (+ ?inj ?adcs ?drag ?deorbit)) )
    )




; *** De weck's algorithm
; *** See http://strategic.mit.edu/docs/2_3_JSR_parametric_NGSO.pdf
; ****

(deffunction estim-prop-wet-mass (?M0 ?dV-i ?dV-a ?Isp-i ?Ispa ?pow)
" Estimation of the wet mass."
    (bind ?mw ?M0) (bind ?err 1000)
    (while (> ?err 0.1)
        (bind ?mp (+ (rocket-equation-mi-dV-to-mp ?dV-i ?Isp-i ?mw) (rocket-equation-mi-dV-to-mp ?dV-a ?Isp-a ?mw)))
        (bind ?mw1 (* 38 (** (+ ?mp (* 0.14 ?pow)) 0.51)) ) ;38*(0.14*$B$5+M7)^0.51
        (bind ?err (abs (- ?mw1 ?mw)))
        (bind ?mw ?mw1)
        )
    (return (create$ ?mp ?mw))
)

(defrule compute-propellant-wet-mass-deweck
    "This rule computes the propellant mass necessary for the DeltaV 
    using the rocket equation and assuming a certain Isp. 
    It also fills out the satellite dry mass"
    
    ?miss <- (PROP-designed (satellite-dry-mass nil) (propellant-mass nil) (payload-power# ?pow&~nil) (delta-V-injection ?dV-inj&~nil) (delta-V ?dV&~nil)
        (Isp-injection ?Isp-i&~nil) (Isp-ADCS ?Isp-a&~nil) (satellite-wet-mass nil) (deorbiting-strategy ?stdes&~nil) )
    =>
    
    (bind ?M0 (+ 140 (* 4.6 (** ?pow 0.73)))) ;first estimate of wet mass from De Weck: 4.6*payload power^0.73+140
    (bind ?list (estim-prop-wet-mass ?M0 ?dV-inj (- ?dV ?dV-inj) ?Isp-i ?Isp-a ?pow))
    (bind ?mp (nth$ 1 ?list)) (bind ?mw (nth$ 2 ?list))
    (modify ?miss (propellant-mass ?mp) (satellite-wet-mass ?mw) (satellite-dry-mass (- ?mw ?mp))) ;wet mass
)


;; SUPPORTING QUERIES AND FUNCTIONS

(deffunction compute-dV (?rp1 ?ra1 ?rp2 ?ra2 ?r)
    (bind ?a1 (/ (+ ?rp1 ?ra1) 2)) (bind ?a2 (/ (+ ?rp2 ?ra2) 2))
    (return (abs (-  (orbit-velocity ?r ?a2) (orbit-velocity  ?r ?a1))))
    )

(deffunction compute-dV-injection (?ainj ?a)
    ; from eliptical orbit with perigee ?ainj and apogee ?a2 to circular orbit ?a2
    ; burn at current apogee ?a2
    (return (compute-dV ?ainj ?a ?a ?a ?a))
    )

(deffunction compute-dV-deorbit (?a ?adeorbit)
    ; from circular orbit ?a to eliptical orbit perigee ?adeorbit apogee ?a
    ; burn at future apogee ?a
    (return (compute-dV ?a ?a ?adeorbit ?a ?a))
    )

(deffunction compute-dV-graveyard (?a ?Cr ?A ?m)
    (bind ?dh (+ 235000 (* 1e6 ?Cr (/ ?A ?m))))
    (return (compute-dV ?a ?a ?a (+ ?a ?dh) ?a))
    )
