
; Estimate "pi" from the dynamic series:
;   pi = 4 * (1 - 1/3 + 1/5 - 1/7 + ...)

; core function for the series estimation via (n) iterations
(defn pi-estim [niter]
  (let [oddnum (filter odd? (iterate inc 1))]
    (*  4.0  (apply + (map / 
      (cycle [1 -1]) 
      (take niter oddnum))))) )

; define number of iterations (works for n <= 2900)
(def n 2900)

(println "estim. pi =" (pi-estim n))
(println " Math. pi =" Math/PI)
