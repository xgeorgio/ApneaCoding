
%% The module declaration matching the filename
-module(fibonacci).

%% The export statement for exposed functions as public API
-export([fib/1]).

fib(0) -> 0;
fib(N) when N < 0 -> err_neg_val;
fib(N) when N < 3 -> 1;
fib(N) -> fib_int(N, 0, 1).

fib_int(1, _, B) -> B;
fib_int(N, A, B) -> fib_int(N-1, B, A+B).

main(_) -> io:fwrite("~B~n",[fib(15)]).
