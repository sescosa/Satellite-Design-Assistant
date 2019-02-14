
(deftemplate TTC-designed "EPS Attribute Set that are calculated" 

   ;;Orbit Slots (input)
   (slot orbit-type) 
   (slot orbit-RAAN)  
   (slot orbit-altitude#)
   (slot orbit-inclination)
   (slot planet)

   ;; Orbit output
   (slot worst-sun-angle) 
   (slot orbit-period#)
   (slot fraction-sunlight) 
   (slot orbit-semimajor-axis) 

   ;; Payload Input
   (slot redundancy)  
   (slot data-per-day)
   (slot gain-antenna)
   (slot peak-power)
   (slot trans-power)
   (slot lifetime)
   (slot satellite-dry-mass)
   (slot Band) 
   (slot MOD)
   (slot ngs)

   (slot TTC-mass)
   (slot cost-opt)
   (slot gain-opt)
   (slot antenna-opt)
   (slot power-opt)
   (slot full)
   (slot report)
   (slot margin-analysis)
   (slot contact-time)

   ;;Checker
   (slot Rb-max)
   (slot EbN0_shannon)
   (slot EbN0_min)
   (slot EbN0)
   (slot Rb)
   (slot margin)
   (slot margin-min)
   (slot margin-zero)
   (slot margin-uhf)

   )

 (deftemplate TTC-check "EPS Attribute Set that need to be checked" 

   ;;Orbit Slots (input)
   (slot orbit-type) 
   (slot orbit-RAAN)  
   (slot orbit-altitude#)
   (slot orbit-inclination)
   (slot planet)

   ;; Orbit output
   (slot worst-sun-angle) 
   (slot orbit-period#)
   (slot fraction-sunlight) 
   (slot orbit-semimajor-axis) 

   ;; Payload Input
   (slot redundancy)  
   (slot data-per-day)
   (slot lifetime)
   (slot satellite-dry-mass)
   (slot Band) 
   (slot MOD)
   (slot ngs)
   (slot full)

   (slot gain-antenna)
   (slot peak-power) 
   (slot TTC-mass)
   (slot antenna-type)
   (slot trans-power)
   )

(deftemplate recommend (slot correction) (slot explanation))

(deftemplate checker (slot link-budget-check) (slot shannon-check) (slot data-rate-check))

(deftemplate question (slot text) (slot type) (slot ident))

(deftemplate answer (slot ident) (slot text))

(deftemplate planet (slot name) (slot mu) (slot rad) (slot au) (slot magField) (slot albedo))

(deffacts planets-constant
"Data from National Space Science Data Center: Nick Strobel"
   (planet (name Mercury) (mu 2.2032e13) (rad 2439) (au 0.39) (magField 0.006) (albedo 0.056))
   (planet (name Venus) (mu 3.248e14) (rad 6051) (au 0.72) (magField 0) (albedo 0.72))
   (planet (name Earth) (mu 3.986e14) (rad 6378) (au 1) (magField 1) (albedo 0.38))
   (planet (name Moon) (mu 4.904e12) (rad 1738) (au 1) (magField 0) (albedo 0.12))
   (planet (name Mars) (mu 4.282e13) (rad 3396) (au 1.52) (magField 0) (albedo 0.16))
   (planet (name Jupiter) (mu 1.266e17) (rad 71492) (au 5.2) (magField 19.52) (albedo 0.70))
   (planet (name Saturn) (mu 3.793e16) (rad 60268) (au 9.5) (magField 578) (albedo 0.75))
   (planet (name Uranus) (mu 5.793e15) (rad 25559) (au 19.18) (magField 47.9) (albedo 0.90))
   (planet (name Neptune) (mu 6.836e15) (rad 24764) (au 30.06) (magField 27) (albedo 0.82))
   (planet (name Pluto) (mu 8.719e11) (rad 1195) (au 39.53) (magField 0) (albedo 0.14))
)