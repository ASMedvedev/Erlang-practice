-module(bs02).
-export([words/1]).

words(BinText) -> binary:split(BinText, <<" ">>, [global]).