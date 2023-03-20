-module(dnc).
-export([dnc/1]).

divide(N) ->
    [N-1, N-2].

combine(N) ->
    lists:sum(N).

isBase(N) ->
    if (N == 0) or (N == 1) ->
        true;
    true ->
        false
    end. 

base() ->
    1.

fib0(0) ->
    0;
fib0(1) ->
    1;
fib0(N) ->
    fib0(N-1) + fib0(N-2).


dnc(Problem) ->
    case isBase(Problem) of
        true -> base();
        false -> 
            Main = self(),
            [A,B] = divide(Problem),
            spawn(fun() -> Main ! fib0(A) end),
            spawn(fun() -> Main ! fib0(B) end),
            receive
                    Val1 ->  
                       receive
                            Val2 -> 
                                combine([Val1, Val2])
                       end
            end
    end.