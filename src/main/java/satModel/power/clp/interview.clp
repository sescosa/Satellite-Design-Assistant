(bind ?input-list (create$ orbit-type orbit-altitude# orbit-RAAN payload-power# payload-peak-power# lifetime satellite-dry-mass solar-cell-type battery-type planet))
(foreach ?e ?input-list
    (bind ?str (str-cat "(defrule request-" ?e 
        " (Mission-designed (" ?e " nil)) 
         => 
         (assert (ask " ?e ")))"
    ))
    (eval ?str)
)

