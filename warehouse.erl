-module(warehouse).
-export([warehouse/1, bad_guy/1, fbi/0]).

warehouse(Password) ->
    register(guard, spawn(fun() -> 
        guard([], Password) end)).

bad_guy(MyPassword) ->
    spawn(fun() -> 
        bandit(MyPassword) end).

fbi() ->
    spawn(fun() -> 
        agent() end).

guard(Bandits, Password) ->
    receive
        {'knock_knock', ID} ->
            ID ! 'password',       
            guard(Bandits, Password);
        {password, RecivedPassword, ID} ->
            {Message, NewBandits} = if
                                RecivedPassword == Password ->
                                     io:format("Guard: ~p entered the warehouse.~n", [ID]),
                                     {'come_in', [ID | Bandits]};
                                 RecivedPassword =/= Password ->
                                     io:format("Guard: wrong password, go away!~n"),
                                     {'go_away', Bandits}
                             end,
            ID ! Message,
            guard(NewBandits, Password);
        {fbi, Fbi} ->
            Fbi ! Bandits,
            timer:sleep(rand:uniform(2000)),
            lists:map(fun(L) -> L ! {run, Fbi} end, Bandits)
    end.

bandit(Password) ->
    ID = self(),
    guard ! {'knock_knock', ID},
    receive
        'password' ->
            guard ! {password, Password, ID}
    after
        3000 ->
            exit(normal)
    end,
    receive
        'go_away' ->
            io:format("Bandit ~p: Ok I'll go away ~n", [ID]),
            exit(normal);
        'come_in' ->
            io:format("Bandit ~p: I'm in the warehouse ~n", [ID])
    end,
    receive
        {run, Fbi} ->
            io:format("Bandit ~p: The FBI got here, I'm running away~n", [ID]),
            Fbi ! run;
        {arrest, Fbi} ->
            io:format("Bandit ~p: I surrender~n", [ID]),
            Fbi ! surrender
    end.

agent() ->
    ID = self(),
    guard ! {'knock_knock', ID},
    receive
        'password' ->
            guard ! {fbi, ID}
    end,
    receive
        BadGuys ->
            timer:sleep(rand:uniform(2000))
    end,
    lists:map(fun(L) -> L ! {arrest, self()},
        receive
            surrender ->
                io:format("FBI: I arrested ~p~n", [L]);
            run ->
                io:format("FBI: ~p ran away ~n", [L])
        end
    end, BadGuys).