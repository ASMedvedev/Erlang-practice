-module(p06).
-export([is_palindrome/1]).
is_palindrome(List) -> p05:reverse(List) =:= List.