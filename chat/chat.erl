-module(chat).
%% Server interface
-export([start/1, stop/0]).
%% Server callback
-export([chat/1]).

start(Max) ->
    register(chatsrv, spawn(fun() -> init(Max) end)).

stop() ->
    chatsrv ! stop.

init(Max) ->
    process_flag(trap_exit, true),
    InitState = {#{}, Max},
    %% initalize...
    chat:chat(InitState).

chat(State={Clients, MaxCl}) ->
    receive 
        {log_in, Ref, ClientPid, _Nick} when MaxCl == length(ClientPid) -> 
            ClientPid ! {deny, Ref},
            chat(State);
        {log_in, Ref, ClientPid, Nick} ->
            io:format("~p joined to the conversation.~n", [ClientPid]),
            link(ClientPid),
            ClientPid ! {ok, Ref},
            chat({Clients#{ClientPid=>Nick}, MaxCl});
        {log_out, From} -> 
            io:format("~p left the conversation.~n", [From]),
            chat({maps:remove(From, Clients), MaxCl});
        {'EXIT', Pid, _Reason} ->
            io:format("~p terminated and left the comversation.~n", [Pid]),
            chat({maps:remove(Pid, Clients), MaxCl});
        {msg, From, Msg} -> 
            #{From:=Nick} = Clients,
            NewMsg = Nick ++ ": " ++ Msg,
            maps:foreach(fun(ClPid, _Nick) -> ClPid ! {message, NewMsg} end, Clients),
            chat(State);
        upgrade ->
            chat:chat(State);
        stop ->
            io:format("Chat server is terminating... ~n")
    end.

% process(State) ->
%     %...
%     receive
%         msg1 -> 
%             handle(msg1),
%             process(State);
%         msg2 -> 
%             NewState = handle_other(msg2, State),
%             process(NewState);
%         ...
%         stop ->
%             terminate()
%     end.

