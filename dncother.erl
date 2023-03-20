-module(dncother).
-export([dnc/2]).

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

dnc(Problem, K) ->
    register(counter_proc, spawn(fun() -> counter(0) end)),
    Result = dnchelper(Problem, K),
    counter_proc ! stop,
    Result.

dnchelper(Problem, K) ->
    case isBase(Problem) of
        true -> base();
        false -> 
            Main = self(),
            counter_proc ! {process_count, Main},
            receive
                Count when Count < K-2 ->
                    [A,B] = divide(Problem),
                    spawn(fun() -> Main ! dnchelper(A, K) end),
                    spawn(fun() -> Main ! dnchelper(B, K) end),
                    receive
                            Val1 ->  
                            receive
                                    Val2 -> 
                                        combine([Val1, Val2])
                            end
                    end;
                _ -> 
                    fib0(Problem)
            end
    end.

counter(State) ->
    receive
        stop ->
            io:format("Counter terminated...~n");
        {process_count, From} ->
            From ! {count, State},
            counter(State+2)
    end.