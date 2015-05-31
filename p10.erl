-module(p10).
-export([encode/1]).

encode([{N,E}|[E|[]]])->[{N+1,E}];

encode([{N,E}|[E|T]])->encode([{N+1,E}|T]);

encode([{N,E1}|[E2|[]]])->[{N,E1}|[{1,E2}]];

encode([{N,E1}|[E2|T]])->[{N,E1}|encode([{1,E2}|T])];

encode([H|T])->encode([{1,H}|T]);

encode([])->[].