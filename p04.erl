-module(p04).
-export([len/1]).
len([]) -> 0;
len([_|T]) -> X = len(T), X + 1.