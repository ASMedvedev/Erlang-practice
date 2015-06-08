-module(ets_storage).
-export([insertData/0,init/0,put/3,compare/3,getData/2]).
    
init() -> ets:new(persons, [public, ordered_set, named_table, {keypos, 3}]).

put(FirstName, LastName,DateTime) -> ets:insert(persons, {FirstName, LastName,DateTime}),{FirstName, LastName, DateTime}.

insertData() ->
    init(),
    put("Ivan", "Ivanov",{{2015,6,8},{13,44,29}}),
    put("Petr", "Petrov",{{2015,6,8},{13,45,29}}),
    put("Boris", "Borisov",{{2015,6,8},{13,46,29}}),
    put("Julius", "Caesar",{{2015,6,8},{13,50,29}}),
    ok.


getData(DateTimeFrom, DateTimeTo) -> 
	Key = ets:first(persons),
	%io:format("Key= ~w~n",[Key]),	
	ListOfKeys = compare(Key,DateTimeFrom,DateTimeTo),ListOfKeys.

compare(Key,DateTimeFrom,DateTimeTo)-> compare(Key,DateTimeFrom,DateTimeTo,[]).
	compare(Key,DateTimeFrom,DateTimeTo, Acc) ->
if
Key > DateTimeFrom, Key < DateTimeTo, Key =/= '$end_of_table' ->
	compare(ets:next(persons,Key),DateTimeFrom,DateTimeTo, [Key|Acc]);
Key =/= '$end_of_table' ->
	compare(ets:next(persons,Key),DateTimeFrom,DateTimeTo, Acc);
true ->
	Acc
end.


	

