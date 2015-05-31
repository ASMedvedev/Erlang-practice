-module(p11).
-export([encode_modified/1]).

encode_modified([{N,E}|[E|[]]])->[{N+1,E}];

encode_modified([{N,E}|[E|T]])->encode_modified([{N+1,E}|T]);

encode_modified([{N,E1}|[E2|[]]])->[{N,E1},E2];

encode_modified([{N,E1}|[E2,E2|T]])->[{N,E1}|encode_modified([{2,E2}|T])];

encode_modified([{N,E1}|[E2|T]])->[{N,E1}|encode_modified([E2|T])];

encode_modified([E1,E1|T])->encode_modified([{2,E1}|T]);

encode_modified([E1,E2|T])->[E1|encode_modified([E2|T])];

encode_modified([E2|[]])->[E2];

encode_modified([])->[].
