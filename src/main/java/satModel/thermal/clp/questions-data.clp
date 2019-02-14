(deffacts question-data
   "The questions the system can ask."
 
   (question (ident orbit-altitude#) (type number) 
      (text "What is the altitude of the orbit? (in km)"))
   (question (ident orbit-type) (type word) 
      (text "What is the satellite's type of orbit?"))
   (question (ident orbit-RAAN) (type word) 
      (text "What is the longitude of the ascending node (RAAN) of the orbit?"))
   (question (ident orbit-inclination) (type word) 
      (text "Which inclination suits more your orbit? >"))
    (question (ident orbit-eccentricity) (type number) 
      (text "Which is the eccentricity of the orbit? ")) 
   (question (ident lifetime) (type number) 
      (text "What is the expected lifetime for the satellite? (in years)"))

   (question (ident payload-power#) (type number) 
      (text "What is the average power required by the payload? "))
   (question (ident Thot-max) (type number) 
      (text "What is the hottest temperature the payload can manage? "))
   (question (ident Tcold-max) (type number) 
      (text "What is the coldest temperature the payload can manage? "))

   (question (ident radiator-surface) (type word) 
      (text "What is the surface finish of the radiator? [Al, white-paint, black-paint, Si-Teflon or Al-Kapton] > "))
   (question (ident insulator-surface) (type word) 
      (text "What is the surface finish of the insulator? [Al, white-paint, black-paint, Si-Teflon or Al-Kapton] > "))

    (question (ident Qin-max) (type number) 
      (text "What is maximum internal power? "))
    (question (ident Qin-min) (type number) 
      (text "What is minmum internal power? "))
      
    (question (ident satellite-dimensions) (type number) 
      (text "What are the dimensions of the satellite? [x y z] >"))
    (question (ident planet) (type word) 
      (text "Which planet does your satellite orbit? [first letter must be capital (i.e. Mars)] >"))
   )