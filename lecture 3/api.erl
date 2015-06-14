-module(api).
-export([init/0,insert/2,deleteData/1,getData/2,getData/1,compare/3,test/0]).
    
init() -> 
	ets:new(cache, [public, ordered_set, named_table]).

insert(Key, Value) -> 
	ets:insert(cache, {Key, Value, calendar:local_time()}).

deleteData(Key) -> 
	ets:delete(cache, Key).

getData(Key) ->
	List = ets:lookup(cache, Key), List.

getData(DateTimeFrom, DateTimeTo) -> 
	Key = ets:first(cache),	
	List = lists:reverse(compare(Key,DateTimeFrom,DateTimeTo)),
	%io:format("List = ~w~n",[List]).
	List.

compare(Key,DateTimeFrom,DateTimeTo)->  compare(Key,DateTimeFrom,DateTimeTo,[]).
      compare(Key,DateTimeFrom,DateTimeTo, Acc) ->

case Key of
     '$end_of_table' -> Acc;
     _ ->

	Rec = ets:lookup(cache, Key),
    	%io:format("Rec = ~w~n",[Rec]),
	[{ _, _, Date}] = Rec, 

if
	Date >= DateTimeFrom, Date =< DateTimeTo ->		
		compare(ets:next(cache,Key),DateTimeFrom,DateTimeTo, [Rec|Acc]);
	Rec =/= [] ->
		compare(ets:next(cache,Key),DateTimeFrom,DateTimeTo, Acc);
	true ->
		Acc
end
end.

%тестовая функция
test()-> 
	init(),
	insert("Key", "Value"),
    	insert("Key2", "Value2"),
	getData("Key2").

