-module(p15).
-export([replicate/2]).

replicate([],_,_)->[];
replicate([_|T],0,Times)->replicate(T,Times,Times);
replicate([H|T],N,Times)->[H|replicate([H|T],N-1,Times)].

replicate([],_)->[];
replicate([H|T],Times)->replicate([H|T],Times,Times).