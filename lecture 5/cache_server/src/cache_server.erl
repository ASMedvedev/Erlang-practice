-module(cache_server).
-behaviour(gen_server).
%============================================================================
%				    API					    =
%============================================================================
-export([start_link/0,start_link/1,clear_old_records_loop/0]).
-export([init/0,insert/2,deleteData/1,lookup_by_date/2,lookup/1,
	compare_delete/4,parseDate/1]).
%============================================================================
% 			    Gen_Server functions		            =
%============================================================================
-export([handle_call/3, handle_cast/2, handle_info/2]).
-export([terminate/2, code_change/3]).
-export([init/1]).
%============================================================================

%				    API					    =
start_link() ->
    start_link([{ttl, 3600}]).

start_link([Params]) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Params, []).




init() -> 
	ets:new(ttl, [named_table, public, ordered_set]),
    	ets:new(cache, [named_table, public, ordered_set]).

insert(Key, Value) ->
	ets:insert(cache, {Key, Value, calendar:local_time()}).

deleteData(Key) -> 
	ets:delete(cache, Key).

lookup(Key) ->
	[{ _, Value, _ }] = ets:lookup(cache, Key),
    	{ok, Value}.

parseDate(Date) ->
	{ok,Bin} = tempo:parse(<<"%Y/%d/%m %H:%M:%M">>, Date, datetime),
	Bin.
	


lookup_by_date(DateTimeFrom, DateTimeTo) -> 	
	Key = ets:first(cache),	
	List = lists:reverse(compare_delete(Key,parseDate(DateTimeFrom),parseDate(DateTimeTo),false)),
	[{K, Value} || [{K, Value, _}] <- List].


clear_old_records_loop() -> 
	TTL = ets:lookup(ttl, ttl),
    	timer:sleep(1000),%sleep 1 sec
    	[{_, TTL2}] = TTL,	
	compare_delete(ets:first(cache), {{1970,01,01},{01,01,01}}, calendar:gregorian_seconds_to_datetime 		  	 
	(calendar:datetime_to_gregorian_seconds(calendar:local_time())-TTL2), true),
	clear_old_records_loop().




compare_delete(Key,DateTimeFrom,DateTimeTo,Del)-> 
    compare_delete(Key,DateTimeFrom,DateTimeTo,Del,[]).
      compare_delete(Key,DateTimeFrom,DateTimeTo,Del,Acc) ->
case Key of
'$end_of_table'->
	if
   		Del=:=true -> ok;
        true -> 
		Acc
	end;
_->
	NextKey = ets:next(cache, Key),
	Rec = ets:lookup(cache, Key),
	[{ _, _, Date}] = Rec, 

if
	Date >= DateTimeFrom, Date =< DateTimeTo ->
	if
   	   Del=:=true ->
		deleteData(Key),
		compare_delete(NextKey,DateTimeFrom,DateTimeTo,Del,[Rec|Acc]);
	   true ->
		compare_delete(NextKey,DateTimeFrom,DateTimeTo,Del,[Rec|Acc])
	end;

	true ->
		Acc
	end
end.	

% 			    Gen_Server functions		            =	
init({ttl, TTL}) ->
    ets:new(cache, [named_table, public, ordered_set]),
    ets:new(ttl, [named_table, public, ordered_set]),

    spawn_link(?MODULE, clear_old_records_loop, []), 
    ets:insert(ttl, {ttl, TTL}),
    {ok, self()}.



handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ets:delete(cache),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
