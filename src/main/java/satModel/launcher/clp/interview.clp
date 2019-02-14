(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination orbit-eccentricity planet launcher satellite-dimensions satellite-wet-mass))
(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule request-" ?e 
        " (LAUNCH-check (" ?e " nil) (full 1)) 
         => 
         (assert (ask " ?e ")))"
    ))
    (eval ?str)
)

