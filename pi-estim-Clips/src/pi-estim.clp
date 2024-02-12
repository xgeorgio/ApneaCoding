(defrule pi-estim
    (initial-fact)
=>
	(printout t crlf "Enter N: ")
	(bind ?N (read))
	(bind ?i 2)
	(bind ?pi 2)
	(while (<= ?i ?N) do
		;(printout t "i=" ?i)
		; pi/2 = 2^2/(1*3) * 4^2/(3*5) * 6^2/(5*7) * ...
		(bind ?pi (* ?pi (/ (* ?i ?i) (* (- ?i 1) (+ ?i 1) ))))
		(bind ?i (+ ?i 2))
		;(printout t " : pi=" ?pi crlf)
	)
	(printout t "n=" ?N " : pi=" ?pi crlf)
)

(reset)

(run)

(exit)
; empty line at the end
