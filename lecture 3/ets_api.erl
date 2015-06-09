-module(ets_api).
-include_lib("eunit/include/eunit.hrl").
-export([insertData/0,init/0,put/3,compare/3,getData/2]).
    
init() -> ets:new(persons, [public, ordered_set, named_table, {keypos, 3}]).

put(FirstName, LastName,DateTime) -> 
	ets:insert(persons, {FirstName, LastName,DateTime}),{FirstName, LastName, DateTime}.

insertData() ->
    init(),
    put("Ivan", "Ivanov",{{2015,6,8},{13,44,29}}),
    put("Petr", "Petrov",{{2015,6,8},{13,45,29}}),
    put("Boris", "Borisov",{{2015,6,8},{13,46,29}}),
    put("Julius", "Caesar",{{2015,6,8},{13,50,29}}).


getData(DateTimeFrom, DateTimeTo) -> 
	Key = ets:first(persons),	
	lists:reverse(compare(Key,DateTimeFrom,DateTimeTo)).
	

compare(Key,DateTimeFrom,DateTimeTo)->  compare(Key,DateTimeFrom,DateTimeTo,[]).

compare(Key,DateTimeFrom,DateTimeTo, Acc) ->
  if
	Key >= DateTimeFrom, Key =< DateTimeTo, Key =/= '$end_of_table' ->		
		compare(ets:next(persons,Key),DateTimeFrom,DateTimeTo, [ets:lookup(persons, Key)|Acc]);
	Key =/= '$end_of_table' ->
		compare(ets:next(persons,Key),DateTimeFrom,DateTimeTo, Acc);
	true ->
		Acc
  end.

%Tests!
getData_test_() ->[

?_assert( getData( {{2015,6,8},{13,43,29}}, {{2015,6,8},{13,44,40}} ) == 

[[{"Ivan","Ivanov",{{2015,6,8},{13,44,29}}}]]),

?_assert( getData( {{2015,6,4},{13,43,29}}, {{2015,6,9},{13,44,40}} ) ==
	
[[{"Ivan","Ivanov",{{2015,6,8},{13,44,29}}}],
 [{"Petr","Petrov",{{2015,6,8},{13,45,29}}}],
 [{"Boris","Borisov",{{2015,6,8},{13,46,29}}}],
 [{"Julius","Caesar",{{2015,6,8},{13,50,29}}}]])

].







	

