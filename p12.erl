-module(p12).
-export([decode_modified/1]).

decode_modified([{2,E}|[]])->[E,E];

decode_modified([{N,E}|[]])->[E|decode_modified([{N-1,E}])];

decode_modified([{2,E}|T])->[E|[E|decode_modified(T)]];

decode_modified([{N,E}|T])->[E|decode_modified([{N-1,E}|T])];

decode_modified([H|[{N,E}|T]])->[H|decode_modified([{N,E}|T])];

decode_modified([H|[]])->[H];

decode_modified([])->[].