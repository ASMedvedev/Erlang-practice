-module(bs03).
-export([split/2]).

split(BinText, S) -> binary:split(BinText, list_to_binary(S), [global]).