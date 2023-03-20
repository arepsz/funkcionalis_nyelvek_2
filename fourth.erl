-module(fourth).
-export([apply_twice/2, freq/1, safe_apply_twice/2, apply_fun/3]).

apply_twice(F, Arg) ->
    F(F(Arg)).
%    {F(F(Arg)), fun apply_twice/2, fun fourth:apply_twice/2}.

freq([H|_]=L) ->
    {Count, Rem} = helper(H, L),
    Count = lists:foldl(fun(E, Acc) when E == H -> Acc + 1;
                           (_, Acc) -> Acc
                        end, 0, L),
    Rem = lists:filter(fun(E) -> E /= H end, L),
    {Count, Rem} = lists:foldr(fun(E, {CountAcc, RemAcc}) when E == H -> {CountAcc+1, RemAcc};
                                  (E, {Count, Rem}) -> {Count, [E | Rem]}
                    end, {0, []}, L),
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

safe_apply_twice(F, Arg) ->
    case catch apply_twice(F, Arg) of
        {'EXIT', {_, _Stack}} -> "Bad function application";
        Value -> {return_value, Value}
    end.

apply_fun(M, F, Arg) ->
    A = try
        X = M:F(Arg),
        X + 1
    of
        0 -> "Negativ value";
        Value -> {return_value, Value}
    catch
        error:function_clause -> "Bad input value";
        _:undef -> "Function is not defined";
        throw:alma -> "Something went wrong"%;
%        _:_:Stack -> {"Bad function application", Stack}
    after
        io:format("After clause~n")
    end,
    io:format("After try~n"),
    A.