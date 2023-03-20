-module(pfib).
-export([pfib5/2]).

fib(0) -> 1;
fib(1) -> 1;
fib(N) -> fib(N-1) + fib(N-2).

pfib5(N, K) ->
    register(counter_proc, spawn(fun() -> counter(0) end)),
    Result = pfib4(N, K),
    counter_proc ! stop,
    Result.

pfib4(0, _K) -> 1;
pfib4(1, _K) -> 1;
pfib4(N, K) -> 
    Main = self(),
    counter_proc ! {process_count, Main},
    receive
        Count when Count < K-2 ->
            spawn(fun() -> Main ! pfib4(N-1, K) end),
            spawn(fun() -> Main ! pfib4(N-2, K) end),
            receive
                    Val1 ->  
                       receive
                            Val2 -> Val1 + Val2
                       end
            end;
        _ -> 
            fib(N)
    end.

counter(State) ->
    receive
        stop ->
            io:format("Counter terminated...~n");
        {process_count, From} ->
            From ! {count, State},
            counter(State+2)
    end.
