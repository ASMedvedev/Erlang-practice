-module(bs03).
-export([split/2]).
-import(p05,[reverse/1]).

split(Bin, S)-> split(Bin, list_to_binary(S), length(S), <<>>, []).

split(Bin, S, Ln, Acc1, Acc2)->

case Bin of
	<<S:Ln/binary, Rest/binary>> -> 
		split(<<Rest/binary>>, S, Ln, <<>>, [Acc1|Acc2]);
	<<X, Rest/binary>> -> 
		split(<<Rest/binary>>, S, Ln, <<Acc1/binary, X>>, Acc2);
	<<>> -> reverse([Acc1|Acc2])
end.