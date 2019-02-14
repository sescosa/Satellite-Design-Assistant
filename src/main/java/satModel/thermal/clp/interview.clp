(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination orbit-eccentricity lifetime satellite-dry-mass Thot-max Tcold-min payload-power# radiator-surface insulator-surface Qin-max Qin-min satellite-dimensions planet))
(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule request-" ?e 
        " (TCS-designed (" ?e " nil)) 
         => 
         (assert (ask " ?e ")))"
    ))
    (eval ?str)
)

