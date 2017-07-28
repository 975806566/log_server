-module(mongodb_writer_sup).

-include("mysql.hrl").

-export([
         start_link/0,
         init/1,
         start_writer_process/0
        ]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    ChildSpec = {mongodb_writer,
                 {mongodb_writer, start_link, []},
                 transient,
                 10000,
                 worker,
                 [mongodb_writer]},

    {ok, {{simple_one_for_one, 10, 3600}, [ChildSpec]}}.

start_writer_process() ->
    L = lists:seq(1, ?WRITER_NUM),
    Fun = fun(Id,_Acc) ->
        {ok, _Child} = supervisor:start_child(mongodb_writer_sup, [Id])
    end,
    lists:foldl(Fun, [], L).


