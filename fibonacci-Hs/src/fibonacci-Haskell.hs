fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

-- fibs = 1 : 1 : [a+b | (a, b) <- zip fibs (tail fibs)]

n = 15
main = print(fib n)
