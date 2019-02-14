(deffacts question-data
   "The questions the system can ask."
   (question (ident ADCS-requirement) (type number) 
      (text "Which is the accuracy required for the ADCS subsystem? [in degrees] > "))
   (question (ident slew-angle) (type number) 
      (text "Which is the maximum slew angle required in the mission? "))
   (question (ident orbit-altitude#) (type number) 
      (text "What is the altitude of the orbit? (in km)"))
   (question (ident orbit-type) (type word) 
      (text "What is the satellite's type of orbit?"))
   (question (ident orbit-RAAN) (type word) 
      (text "What is the longitude of the ascending node (RAAN) of the orbit?"))
   (question (ident orbit-inclination) (type word) 
      (text "Which inclination suits more your orbit? [30, 51.6, 75, 100] >"))
   (question (ident lifetime) (type number) 
      (text "What is the expected lifetime for the satellite? (in years)"))
   (question (ident satellite-dry-mass) (type number) 
      (text "What is the dry mass of the satellite? (in kg)"))
   (question (ident slew-control) (type number) 
      (text "Which system do you use to slew the satellite? [none, thrusters, two-force-thursters] >"))
   (question (ident number-RW) (type number) 
      (text "How many reaction wheels does your system use ? "))
   (question (ident planet) (type word) 
      (text "Which planet does your satellite orbit? [first letter must be capital (i.e. Mars)] >"))
   )