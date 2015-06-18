-module(cache_handler).

-export([init/3, handle/2, terminate/3]).

init(_Transport, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
	{Method, Req2} = cowboy_req:method(Req),
	HasBody = cowboy_req:has_body(Req2),
	{ok, Req3} = parse_req(Method, HasBody, Req2),
	{ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
	ok.

parse_req(<<"POST">>, true, Req) ->
	{ok, PostVals, Req2} = cowboy_req:body_qs(Req),		
		[{BinJson, true}] = PostVals,
		Json = jsx:decode(BinJson),
		Action = proplists:get_value(<<"action">>, Json),
		Res = parse_command(Action, Json),
		cowboy_req:reply(200, [{<<"content-type">>, <<"application/json; charset=utf-8">>}],jsx:encode(Res), Req2);


parse_req(<<"POST">>, false, Req) ->
	io:format("parse_req POST Missing body ~n",  []),
	cowboy_req:reply(400, [], <<"Missing body.">>, Req);

parse_req(_, _, Req) ->
	%% Method not allowed.
	cowboy_req:reply(405, Req).

parse_command(<<"insert">>, Json) ->
	Key = proplists:get_value(<<"key">>, Json),
	Value = proplists:get_value(<<"value">>, Json),
	cache_server:insert(Key, Value);

parse_command(<<"lookup">>, Json) ->
	Key = proplists:get_value(<<"key">>, Json),
	cache_server:lookup(Key);

parse_command(<<"lookup_by_date">>, Json) ->
	DateTimeFrom = proplists:get_value(<<"date_from">>, Json),
	DateTimeTo = proplists:get_value(<<"date_to">>, Json),
	cache_server:lookup_by_date(DateTimeFrom, DateTimeTo);

parse_command(Com1,Com2) ->
	io:format("parse_command = ~n",  []),
	io:format("Com1 = ~w~n",  [Com1]),
	io:format("Com2 = ~w~n",  [Com2]),

	<<"wrong_comand">>.
