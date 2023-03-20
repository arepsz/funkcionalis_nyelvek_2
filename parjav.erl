-module(parjav).
-export([pany/2]).

helper([]) ->
    false;
helper([H={_,_}|F]) ->
    case H of 
        {true,_} ->
            H;
        {_,_} ->
            helper(F)
    end.

pany(F,L) ->
    Main = self(),
    Calc = [spawn(fun() -> Main ! {F(E), E} end) || E <- L],
    H = [receive
            {Bool,Val} ->
                {Bool,Val} end || _ <- Calc],
    helper(H).