

(deffunction orekit (?h ?ideg ?ngs)
    (bind ?contact (new seakers.orekit.Orekit_Sergio2))
    
    (bind ?output (call ?contact getContactTime ?h ?ideg ?ngs))
 
    (return ?output)
)

(bind ?alt 600)
(bind ?ngs 2)
(bind ?ideg 30)

(bind ?contact-time (orekit (* 1000 ?alt)  ?ideg ?ngs))