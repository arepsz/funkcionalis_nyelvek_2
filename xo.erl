-module(xo).
-export([toBitString/1,
         charToBitString/1,
         bitStringToChar/1,
         xOr/2,
         encrypt/2,
         decrypt/2,
         isCycledIn/2,
         getKey/2,
         decodeMessage/2
        ]).

-type bitString() :: list(0|1).

-spec toBitString(N :: number()) -> bitString().
toBitString(N) -> 
    if
        N == 0 ->
            [];
        N == 1 ->
            [1];
        N rem 2 == 0 ->
            [0] ++ toBitString(N div 2);
        N rem 2 == 1 ->
            [1] ++ toBitString(N div 2)
    end.

-spec charToBitString(A :: char()) -> bitString().
charToBitString(A) -> addZeros(toBitString(A), 8).

-spec addZeros(Num :: bitString(), Len :: number()) -> bitString().
addZeros(Num, Len) ->
    if 
        length(Num) == Len ->
            Num;
        length(Num) < Len ->
            addZeros(Num ++ [0], Len)
    end.

-spec bitStringToChar(BitStr :: bitString()) -> char().
bitStringToChar(BitStr) -> 
    lists:foldr(fun(X, Result)-> 2*Result + X end, 0 , BitStr).

-spec xOr(A :: bitString(), B :: bitString()) -> bitString().
    xOr([],B)->
        B;
    xOr(A,[])->
        A;
    xOr([],[])->
        [];
    xOr([H|A],[E|B])-> case H == E of
        true ->
            [0] ++ xOr(A,B);
        false ->
            [1] ++ xOr(A,B)
        end.
    
-spec encrypt(Text :: string(), Key :: string()) -> string().
encrypt(Text, Key) ->
    LongKey = getLongKey(Key, length(Text), [], 1),
    TextBit = lists:map(fun(L) -> charToBitString(L) end, Text),
    KeyBit = lists:map(fun(L) -> charToBitString(L) end, LongKey),
    Result = [xOr(lists:nth(Ind, TextBit), lists:nth(Ind, KeyBit)) || Ind<-lists:seq(1, length(Text))],
    lists:map(fun(L) -> bitStringToChar(L) end, Result).

-spec getLongKey(OriginalKey :: string(), ReqLen :: number(), Acc :: string(), Index :: number()) -> string().
getLongKey(OriginalKey, ReqLen, Acc, Index) ->
    if
        length(Acc) == ReqLen -> 
            lists:reverse(Acc);
        length(Acc) =/= ReqLen ->
            getLongKey(OriginalKey, ReqLen, [lists:nth(Index, OriginalKey) | Acc], (Index rem length(OriginalKey)) + 1)
    end.

-spec decrypt(Cipher :: string(), Key :: string()) -> string().
decrypt(Cipher, Key) -> 
    encrypt(Cipher, Key).

-spec isCycledIn(A :: string(), B :: string()) -> true | false.
isCycledIn(A, B) -> 
    search(A, B, 1).

-spec search(ToFind :: string(), ToSearch :: string(), Index :: number()) -> true | false.
search(ToFind, ToSearch, Index) when Index > length(ToSearch) ->
    not (Index =< length(ToFind));

search(ToFind, ToSearch, Index) ->
    FindInd = if
        (Index rem length(ToFind)) == 0 ->
            length(ToFind);
        (Index rem length(ToFind)) =/= 0 ->
            (Index rem length(ToFind))
        end,
    case lists:nth(Index, ToSearch) == lists:nth(FindInd, ToFind) of
        true ->
            search(ToFind, ToSearch, Index + 1);
        false -> 
            false
    end.

-spec getKey(Text::string(), Cipher::string()) -> Key::string().
    getKey(Text,Cipher)->
        Val = decrypt(Text,Cipher),
        case lists:filter(fun(X)-> isCycledIn(X,Val) end, [lists:sublist(Val, T) ||  T <- lists:seq(1,length(Val))]) of
            [] -> no_solution;
            [X | _] -> X
        end.
            
-spec decodeMessage(Cipher :: string(), TextPart :: string()) -> string().
decodeMessage(Cipher, TextPart) ->
    decrypt(Cipher, getKey(TextPart, Cipher)).