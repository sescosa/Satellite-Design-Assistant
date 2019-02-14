(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination orbit-eccentricity lifetime satellite-wet-mass length diameter LFaxial LFlateral LFbending NF-axial NF-lateral material number-SA planet))
(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule request-" ?e 
        " (STRUC-designed (" ?e " nil)) 
         => 
         (assert (ask " ?e ")))"
    ))
    (eval ?str)
)

