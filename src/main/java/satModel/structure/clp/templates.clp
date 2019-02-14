
(deftemplate STRUC-designed 

   ;;Orbit Slots (input)
   (slot orbit-type) 
   (slot orbit-RAAN)  
   (slot orbit-altitude#)
   (slot orbit-inclination)
   (slot orbit-eccentricity)


   ;; Orbit output
   (slot worst-sun-angle) 
   (slot orbit-period#)
   (slot fraction-sunlight) 
   (slot orbit-semimajor-axis) 

   ;; Payload Input
   (slot lifetime)
   (slot satellite-wet-mass)
   (slot length)
   (slot diameter)
   (slot LFaxial)
   (slot LFlateral)
   (slot LFbending)
   (slot NF-axial)
   (slot solar-array-area)
   (slot solar-array-mass)
   (slot NF-lateral)
   (slot SFu)
   (slot SFy)
   (slot number-SA)


   (slot material)

   ;;Output
   (slot mass-monocoque)
   (slot mass-stringers)
   (slot mass-main-structure)
   (slot mass-SA-beam)
   (slot struc-type)
   (slot planet)

   (slot full)

   )

 (deftemplate STRUC-check 

   ;;Orbit Slots (input)
   (slot orbit-type) 
   (slot orbit-RAAN)  
   (slot orbit-altitude#)
   (slot orbit-inclination)
   (slot orbit-eccentricity)


   ;; Orbit output
   (slot worst-sun-angle) 
   (slot orbit-period#)
   (slot fraction-sunlight) 
   (slot orbit-semimajor-axis) 

   ;; Payload Input
   (slot lifetime)
   (slot satellite-wet-mass)
   (slot length)
   (slot diameter)
   (slot LFaxial)
   (slot LFlateral)
   (slot LFbending)
   (slot NF-axial)
   (slot NF-lateral)
   (slot solar-array-area)
   (slot solar-array-mass)
   (slot SFu)
   (slot SFy)
   (slot number-SA)

   (slot material)

   ;;Output

   (slot mass-structure)
   (slot struc-type)


   (slot planet)
   (slot full)

   )

(deftemplate recommend (slot correction) (slot explanation))

(deftemplate checker (slot type-check) (slot mass-check) (slot mass-SA-check))

(deftemplate question (slot text) (slot type) (slot ident))

(deftemplate answer (slot ident) (slot text))

(deftemplate material (slot name) (slot young-module) (slot poisson) (slot density) (slot ultimate-strength) (slot yield-strength))

(deffacts materials
   (material (name Al7075) (young-module 71e9) (poisson 0.33) (density 2.8e3) (ultimate-strength 524e6) (yield-strength 448e6))
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