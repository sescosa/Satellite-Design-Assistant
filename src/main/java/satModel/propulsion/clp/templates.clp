
(deftemplate PROP-designed 

   ;;Orbit Slots (input)
   (slot orbit-type) 
   (slot orbit-RAAN)  
   (slot orbit-altitude#)
   (slot orbit-inclination)
   (slot orbit-eccentricity)
   (slot planet)

   ;; Orbit output
   (slot worst-sun-angle) 
   (slot orbit-period#)
   (slot fraction-sunlight) 
   (slot orbit-semimajor-axis) 

   ;; Payload Input
   (slot lifetime)
   (slot satellite-dry-mass)
   (slot propellant-injection)
   (slot propellant-ADCS)
   (slot ADCS-type)
   (multislot satellite-dimensions)
   (slot payload-power#)


   ;;Output
   (slot Isp-injection)
   (slot Isp-ADCS)
   (slot propellant-mass)
   (slot delta-V)
   (slot delta-V-injection)
   (slot delta-V-drag)
   (slot delta-V-ADCS)
   (slot deorbiting-strategy)
   (slot delta-V-deorbit)
   (slot propulsion-mass#)
   (slot satellite-wet-mass)

   (slot full)

   )

 (deftemplate PROP-check 

   ;;Orbit Slots (input)
   (slot orbit-type) 
   (slot orbit-RAAN)  
   (slot orbit-altitude#)
   (slot orbit-inclination)
   (slot orbit-eccentricity)
   (slot planet)

   ;; Orbit output
   (slot worst-sun-angle) 
   (slot orbit-period#)
   (slot fraction-sunlight) 
   (slot orbit-semimajor-axis) 

   ;; Payload Input
   (slot lifetime)
   (slot satellite-dry-mass)
   (slot propellant-injection)
   (slot propellant-ADCS)
   (slot delta-V)
   (slot propulsion-mass#)
   (slot ADCS-type)
   (slot payload-power#)
   (slot deorbiting-strategy)
   (multislot satellite-dimensions)
   (slot satellite-wet-mass)

   (slot full)
   )

(deftemplate recommend (slot correction) (slot explanation))

(deftemplate checker (slot deorbit-check) (slot mass-check) (slot dry-check) (slot active))

(deftemplate question (slot text) (slot type) (slot ident))

(deftemplate answer (slot ident) (slot text))

(deftemplate planet (slot name) (slot mu) (slot rad))

(deffacts planets-constant
   (planet (name Sun) (mu 1.327e20) (rad 695508))
   (planet (name Mercury) (mu 2.2032e13) (rad 2439))
   (planet (name Venus) (mu 3.248e14) (rad 6051))
   (planet (name Earth) (mu 3.986e14) (rad 6378))
   (planet (name Moon) (mu 4.904e12) (rad 1738))
   (planet (name Mars) (mu 4.282e13) (rad 3396))
   (planet (name Ceres) (mu 6.263e15) (rad 473))
   (planet (name Jupiter) (mu 1.266e17) (rad 71492))
   (planet (name Saturn) (mu 3.793e16) (rad 60268))
   (planet (name Uranus) (mu 5.793e15) (rad 25559))
   (planet (name Neptune) (mu 6.836e15) (rad 24764))
   (planet (name Pluto) (mu 8.719e11) (rad 1195))
)