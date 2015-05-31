-module(p01).
-export([last/1]).
last([_]=L) -> L;
last([_|T]) -> last(T).