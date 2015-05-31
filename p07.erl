-module(p07).
-export([flatten/1]).

flatten([[]|T])->flatten(T);
flatten([[H|T]|T2])->flatten([H|[T|T2]]);
flatten([H|T])->[H|flatten(T)];
flatten([])->[].


