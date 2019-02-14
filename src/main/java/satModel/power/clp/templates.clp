
(deftemplate Mission-designed "EPS Attribute Set that are calculated" 

   ;;Orbit Slots (input)
   (slot orbit-type) 
   (slot orbit-RAAN)  
   (slot orbit-altitude#)

   ;; Orbit output
   (slot worst-sun-angle) 
   (slot orbit-period#)
   (slot fraction-sunlight) 
   (slot orbit-semimajor-axis) 

   ;; Payload Input
   (slot depth-of-discharge)  
   (slot payload-power#)
   (slot payload-peak-power#)
   (slot lifetime)
   (slot satellite-dry-mass) 
   (slot solar-cell-type)
   (slot battery-type)

   ;; Payload Output
   (slot EPS-mass#)
   (slot satellite-BOL-power#) 
   (slot satellite-EOL-power#)
   (slot solar-array-area)
   (slot solar-array-mass)

   (slot battery-capacity)
   (slot battery-mass)
   (slot planet)
   (slot full)

   )

   (deftemplate Mission-check "EPS Attribute Set that need to be checked" 

   ;;Orbit Slots (input)
   (slot orbit-type) 
   (slot orbit-RAAN)  
   (slot orbit-altitude#)

   ;; Orbit output
   (slot worst-sun-angle) 
   (slot orbit-period#)
   (slot fraction-sunlight) 
   (slot orbit-semimajor-axis) 


   ;; Payload Input
   (slot depth-of-discharge)  
   (slot payload-power#)
   (slot payload-peak-power#)
   (slot lifetime)
   (slot satellite-dry-mass)
   (slot solar-cell-type)
   (slot battery-type) 

   ;; Payload Output
   (slot EPS-mass#)
   (slot satellite-BOL-power#) 
   (slot satellite-EOL-power#)
   (slot solar-array-area)
   (slot solar-array-mass)

   (slot battery-capacity)
   (slot battery-mass)
   (slot planet)
   (slot full)
   )

(deftemplate recommend (slot correction) (slot explanation))

(deftemplate checker (slot solar-array-area-check) (slot battery-check))

(deftemplate question (slot text) (slot type) (slot ident))

(deftemplate answer (slot ident) (slot text))

;*******************************************************
; SOLAR ARRAYS AND BATTERIES AVAILABLE
;*******************************************************

(deftemplate solar-cells (slot name) (slot Xe) (slot Xd) (slot P0) (slot Id) (slot degradation) (slot Spec_power_SA))

(deftemplate batteries (slot name) (slot n) (slot Spec_energy_density_batt))

(deffacts types-sa
   (solar-cells (name GaAs) (Xe 0.6) (Xd 0.8) (P0 253) (Id 0.77) (degradation 0.0275) (Spec_power_SA 25) )
   (solar-cells (name Si) (Xe 0.6) (Xd 0.8) (P0 202) (Id 0.77) (degradation 0.0375) (Spec_power_SA 25) )
   (solar-cells (name Multijunction) (Xe 0.6) (Xd 0.8) (P0 301) (Id 0.77) (degradation 0.005) (Spec_power_SA 25) )

)

(deffacts types-bat
   (batteries (name NiCd) (n 0.9) (Spec_energy_density_batt 25))
   (batteries (name NiH2) (n 0.9) (Spec_energy_density_batt 40))
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