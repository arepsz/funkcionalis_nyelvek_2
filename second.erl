-module(second).
-export([inc/1, inc_tail/1, count/2, freq/1, freq2/1]).

-spec(inc(list()) -> list()).
inc([Head|Tail]) ->
    [ Head + 1 | inc(Tail)];
inc([]) ->
    [].

inc_tail(L) ->
    inc_tail(L, []).

inc_tail([H|T], Res) ->
    inc_tail(T, [H+1 | Res]); %% Res ++ [H+1]
inc_tail([], Res) ->
    lists:reverse(Res).

-spec(count(any(), list()) -> integer()).
%count(E, [H|T]) when E == H ->
count(E, [E|T]) ->
    1 + count(E, T);
count(E, [_H | T]) ->
    count(E, T);
count(_, []) ->
    0.

freq(L) ->
    lists:usort(freq(L, L)).

freq1(L) ->
    freq(lists:usort(L), L). 

freq([H|T], Orig) ->
    [{H, count(H, Orig)} | freq(T, Orig)];
freq([], _) ->
    [].

freq2([H|T]) ->
    Rem = [ E || E  <- T, E /= H],
    [{H, count(H, T) +1} | freq2(Rem)];
freq2([]) ->
    [].
%foo(_H, _H)
%foo(_,_)