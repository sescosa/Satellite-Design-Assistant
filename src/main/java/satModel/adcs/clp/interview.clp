(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination ADCS-requirement satellite-dry-mass moments-of-inertia slew-angle satellite-dimensions slew-control number-RW planet))
(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule request-" ?e 
        " (ADCS-designed (" ?e " nil)) 
         => 
         (assert (ask " ?e ")))"
    ))
    (eval ?str)
)

