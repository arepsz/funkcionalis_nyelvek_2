-module(third).
-export([freq/1, freq_acc/1, incremental_update/2, freq_if/2, freqm/1, freqx/1]).

freq([H|_]=L) ->
    {Count, Rem} = helper(H, L),
    [{H, Count} | freq(Rem)];
freq([]) ->
    [].

helper(E, [E|T]) ->
    {Count, Rem} = helper(E, T),
    {Count+1, Rem};
helper(E, [H|T]) ->
    {Count, Rem} = helper(E, T),
    {Count, [H|Rem]};
helper(_, []) ->
    {0, []}.

helperc(E, L) ->
    case  L of
        [E|T] ->  
            {Count, Rem} = helperc(E, T),
            {Count+1, Rem};
        [H|T] ->
            {Count, Rem} = helperc(E, T),
            {Count, [H|Rem]};
        [] ->
            {0, []}
    end.
    
freq_acc(L) ->
    freq_acc(L, []).

freq_acc([H|T], Result) ->
    case lists:keyfind(H, 1, Result) of
        {H, _Count} -> freq_acc(T, Result);
        false -> freq_acc(T, [ {H, second:count(H, T)+1} | Result])
    end;
freq_acc([], Result) ->
    Result.



incremental_update([H|T], Result) ->
    case lists:keyfind(H, 1, Result) of
        {H, Count} -> incremental_update(T, lists:keyreplace(H, 1, Result, {H, Count+1}));
        false -> incremental_update(T, [ {H, 1} | Result])
    end;
incremental_update([], Result) ->
    Result.   

freqm(L) ->
    freqm(L, #{}).

freqm([H|T], Map) ->
    case Map of
        #{H:=Count} -> freqm(T, Map#{H=>Count+1});
        _ -> freqm(T, Map#{H=>1})
    end;
freqm([], Map) ->
    %maps:to_list(Map).
    Map.

freq_if([H|T], Result) ->
    Cond = is_tuple(lists:keyfind(H, 1, Result)),
    if 
        Cond -> freq_acc(T, Result);
        true -> freq_acc(T, [ {H, second:count(H, T)+1} | Result])
    end;
freq_if([], Result) ->
    Result.
%eleme_e(E, L) ->
%    true.

freqx(L) ->
    freqsorted(lists:sort(L), []).

freqsorted([H|T], [{H, Count} | Result]) ->
    freqsorted(T, [{H, Count+1} | Result]);
freqsorted([H|T], Result) ->
    freqsorted(T, [{H, 1} | Result]);
freqsorted([], Result) ->
    Result.