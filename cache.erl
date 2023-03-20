-module(cache).
-export([run/1, main/0]).

main() ->
    register(cache, spawn(fun() -> 
        cache([]) end)).

run(N) ->
    ID = self(),
    spawn(fun() -> ID end),
    cache ! {search, N, ID},
    receive
        {runit, Val} ->
            {ok, Val}
    end.

cache(Prev) ->
    receive 
        {search, Number, ID} ->
            {Val, NewList} = 
                case lists:keyfind(Number, 1, Prev) of
                false ->
                    Res = pfib(Number),
                    {Res, [{Number, Res} | Prev]};
                {_,X} ->
                    io:format("Already got this!~n"),
                    {X, Prev}
                end,
        ID ! {runit, Val},
        cache(NewList)
    end.


fib(0) -> 1;
fib(1) -> 1;
fib(N) -> fib(N-1) + fib(N-2).

pfib(0) -> 1;
pfib(1) -> 1;
pfib(N) -> 
    Main = self(),
    spawn(fun() -> Main ! fib(N-1) end),
    spawn(fun() -> Main ! fib(N-2) end),
    receive
        Val1 ->  
           receive
                Val2 -> Val1 + Val2
           end
    end.