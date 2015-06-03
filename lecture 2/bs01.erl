-module(bs01).
-export([first_word/1]).

first_word(Str)->first_word(Str, <<>>).
first_word(<<" ", _/binary >>, R)-> R;
first_word(<<X ,Rest/binary>>, R)-> first_word(Rest,<<R/binary, X>>);
first_word(<<>>,R) -> R.