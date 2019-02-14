(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN orbit-inclination data-per-day trans-power peak-power gain-antenna lifetime satellite-dry-mass Band MOD ngs planet))
(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule request-" ?e 
        " (TTC-designed (" ?e " nil)) 
         => 
         (assert (ask " ?e ")))"
    ))
    (eval ?str)
)

