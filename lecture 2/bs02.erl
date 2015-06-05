-module(bs02).
-export([words/1]).
-import(p05,[reverse/1]).

words(Bin) -> words(Bin, <<>>, []).
words(<<" ", Rest/binary>>, Word,Acc) -> words(Rest,<<>>,[Word|Acc]);
words(<<X,Rest/binary>>, Word,Acc)->words(Rest,<<Word/binary,X>>,Acc);
words(<<>>,Word,Acc)->reverse([Word|Acc]).