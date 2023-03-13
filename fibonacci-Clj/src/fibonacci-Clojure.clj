(defn fib-append [[a b]]
  [b (+ a b)]
)

(def fib-list
  (map last (iterate fib-append [0 1]))
)

(def n 15)
(println (last (take n fib-list)))
