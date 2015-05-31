-module(p08).
-export([compress/1]).

compress([H|[]]) ->[H];

compress([H|[H|T]])-> compress([H|T]);

compress([H|[H1|T]])-> [H|compress([H1|T])];

compress([])->[].


