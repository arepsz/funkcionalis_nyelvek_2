-module(taskfarm).
-export([run/2]).

run(F, L) ->
    Num = 2*erlang:system_info(logical_processors),
    Disp = spawn(fun() -> 
        dispatcher(L, Num) end),
    Col = spawn(fun() -> 
        collector([], Num) end),
    [ spawn(fun() -> 
        worker({Disp, Col, F}) end) || _ <- lists:seq(1, Num)].
                                        

dispatcher([], 0) ->  
    io:format("Dispatcher terminated~n");
dispatcher([], PN) ->
    receive
        {newlist, List} ->
            dispatcher(List, PN);
        {ready, Worker} ->   
            Worker ! stop,   
            dispatcher([], PN-1)
    end;
dispatcher([H | T], PN) ->
    receive
        {ready, Worker} ->
            Worker ! {data, H},
            dispatcher(T, PN)
    end.

collector(Acc, 0) ->
    io:format("Collector terminated. Results: ~p~n", [lists:reverse(Acc)]);
collector(Acc, PN) ->
    receive
        {result, Res} ->
            collector([Res | Acc], PN);
        {subresult, Pid} ->
            Pid ! Acc,
            collector(Acc, PN);
        worker_stopped ->
            collector(Acc, PN-1)
    end.

worker({Disp, Col, F} = State) ->
    Disp ! {ready, self()},
    receive
        {data, Data} ->
            Col ! {result, F(Data)},
            worker(State);
        stop ->
            Col ! worker_stopped
    end.