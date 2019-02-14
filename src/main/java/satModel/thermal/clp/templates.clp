
(deftemplate TCS-designed 

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
   (slot Thot-max)
   (slot Tcold-min)
   (slot Qin-max)
   (slot Qin-min)
   (multislot satellite-dimensions)
   (slot payload-power#)
   (slot radiator-surface)
   (slot insulator-surface)


   ;;Output
   (slot TCS-type)
   (slot area-insulator)
   (slot area-radiator)
   (slot heater-power)
   (slot TCS-mass)
   (slot TCS-power)
   (slot T-equipement)


   (slot full)

   )

 (deftemplate TCS-check 

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
   (slot Thot-max)
   (slot Tcold-min)
   (slot Qin-max)
   (slot Qin-min)
   (multislot satellite-dimensions)
   (slot payload-power#)
   (slot radiator-surface)
   (slot insulator-surface)


   ;;Output
   (slot TCS-type)
   (slot TCS-mass)
   (slot TCS-power)


   (slot full)
   )

(deftemplate recommend (slot correction) (slot explanation))

(deftemplate checker (slot type-check) (slot mass-check) (slot power-check))

(deftemplate question (slot text) (slot type) (slot ident))

(deftemplate answer (slot ident) (slot text))

(deftemplate material (slot name) (slot alpha-tir) (slot alpha-vnir) (slot e))

(deffacts materials
   (material (name Al) (alpha-tir 0.05) (alpha-vnir 0.15) (e 0.05))
   (material (name white-paint) (alpha-tir 0.2) (alpha-vnir 0.92) (e 0.2))
   (material (name black-paint) (alpha-tir 0.92) (alpha-vnir 0.89) (e 0.92))
   (material (name Si-Teflon) (alpha-tir 0.08) (alpha-vnir 0.8) (e 0.82))
   (material (name MLI) (alpha-tir 0.02) (alpha-vnir 0.02) (e 0.02))
   (material (name Al-Kapton) (alpha-tir 0.38) (alpha-vnir 0.67) (e 0.38))
)

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
