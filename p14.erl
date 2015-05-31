-module(p14).
-export([duplicate/1]).

duplicate([H|T])->[H|[H|duplicate(T)]];
duplicate([])->[].