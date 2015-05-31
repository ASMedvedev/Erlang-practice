-module(p05).
-export([reverse/1]).

reverse(L) -> reverse(L, []).

reverse([H|T], R) -> reverse(T,[H|R]);
reverse([],R) -> R.

