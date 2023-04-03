-module(chatiface).
-export([login/1, logout/0, send/1]).
-define(Chat, {chatsrv, 'server@157.181.161.25'}).
%% -define(Add(A) , A +1).
%% ?Add(2) *10 -> 2 + 1 *10.

login(Nick) when is_list(Nick) ->
    Ref = make_ref(),
    ?Chat ! {log_in, Ref, self(), Nick},
    receive
        {ok, Ref} -> ok;
        {deny, Ref} -> deny
    after
        5000 -> timeout
    end;
login(_) -> deny.

logout() ->
    ?Chat ! {log_out, self()}.

send(Msg) ->
    ?Chat ! {msg, self(), Msg}.

    