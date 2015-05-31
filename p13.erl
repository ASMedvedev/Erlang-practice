-module(p13).
-export([decode/1]).

decode([{1,E}|[]])->[E];

decode([{N,E}|[]])->[E|decode([{N-1,E}])];

decode([{1,E}|T])->[E|decode(T)];

decode([{N,E}|T])->[E|decode([{N-1,E}|T])];

decode([H|[]])->[H];

decode([])->[].