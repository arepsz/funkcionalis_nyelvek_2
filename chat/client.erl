-module(client).
-export([start/1]).

start(Nick) -> 
    % Ref = make_ref(),
    case chatiface:login(Nick) of
        ok -> 
            Client = self(), 
            spawn(fun() -> io(Client) end),
            client();
        _ -> "Connecting to server failed"
    end.

client() ->
    receive
        {message, Msg} ->
            io:format("~p~n", [Msg]),
            client();
        {text, Msg} ->
            chatiface:send(Msg),
            client();
        stop ->
            chatiface:logout(),
            "Chat finished"
    end.

io(Client) ->
    case io:get_line("-->") of
        "exit\n" -> 
            Client ! stop;
        Msg ->
            Client ! {text, Msg} ,
            %flush(),
            io(Client)
    end.

flush() ->
    receive
        A -> 
            io:format("~p~n", [A]),
            flush()
    after 0 -> io:format("No message~n")
    end.    