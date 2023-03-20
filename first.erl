-module(first).
-export([hello/0, hello/1, foo/0, hello2/1]).

hello() ->
    "Hello".

-type mystring() :: {ok, string()}.
-spec(hello(Name::string()) -> mystring()).
hello(Name) ->
    {ok, "Hello " ++ Name ++ "!"}.

foo() -> 
    hello(12).

hello2(Name) ->
    %io_lib:format("Hello ~p, Hello ~p!~n", [Name, Name]).
    io:format("Hello ~p, Hello ~p!~n", [Name, Name]).