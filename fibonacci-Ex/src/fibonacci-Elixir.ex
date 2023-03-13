defmodule Fibnum do

  def fib(n) when n in [0, 1], do: n

  def fib(n), do: fib(n-2) + fib(n-1)

end

n=15
IO.puts Fibnum.fib(n)
