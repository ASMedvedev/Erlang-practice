-module(cache_server_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	io:format("start_link ~w~n", [?MODULE]),
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	io:format("init ~w~n", [?MODULE]),
	Procs = [{cache_server, {cache_server, start_link, []},
        	permanent, 3000, worker, [cache_server]}],
	{ok, {{one_for_one, 5, 10}, Procs}}.
