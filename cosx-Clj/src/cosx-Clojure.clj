
; Estimation of cos(x) via dynamic series:
;   cos(x) = 1 -(x^2)/2! +(x^4)/4! -(x^6)/6! + ...
;   cos(x) = 1 + sum{(x),k=2:2:n} -1^(k/2) * (x^k)/k!


; define factorial = n!
(defn fact [n]
  (reduce * (range 1 (inc n))))

; define pow(x,n) = x^n 
(defn pow [x n]
  ;(if (zero? n) 1
  (if (> n 0) (* x (pow x (dec n)))  1 ) )
         
; define the sign of an element in the series
(defn elem-sign [n]
  (pow -1 (/ n 2)))

; calculate combined item in the series
(defn elem-full [x n]
  (/ (* (elem-sign n) (pow x n)) (fact n)))


; ..... main routine for testing .....

; Input: define (x) angle, (n) for upper item
;        works for n <= 20 (even), x is in radians
(def pi 3.141592653589793)
(def n 20)
(def x (/ pi 4))

; some individual outputs for tracing
;(println (elem-sign n))
;(println (pow x n))
;(println (fact n))
;(println (elem-full x n))
;(println (repeat (/ n 2) x))
;(println (range 2 (+ n 2) 2))

; Estimation: cos(x) up to n, i.e., (n/2) series length
; 1) create a list of (x) values
; 2) create a list of k={2,4,6,..,n}
; 3) apply the item function for each matching pair
; 4) sum (+1) all items in the resulting list
(println (+ 1 (reduce + (map elem-full 
    (repeat (/ n 2) x)
    (range 2 (+ n 2) 2) ))) )
