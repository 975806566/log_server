-module(log_server_app).

-define(PRINT_MSG(Msg), io:format(Msg)).

-define(PRINT(Format, Args), io:format(Format, Args)).

-behaviour(application).

%% Application callbacks
-export([start/0,start/2, stop/1]).

-include("mysql.hrl").

%%%=============================================================================
%%% Application callbacks
%%%=============================================================================

%%------------------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application is started using
%% application:start/[1,2], and should start the processes of the
%% application. If the application is structured according to the OTP
%% design principles as a supervision tree, this means starting the
%% top supervisor of the tree.
%%
%% @end
%%------------------------------------------------------------------------------
start() ->
    start([],[]).

-spec start(StartType, StartArgs) -> {ok, pid()} | {ok, pid(), State} | {error, Reason} when 
    StartType :: normal | {takeover, node()} | {failover, node()},
    StartArgs :: term(),
    State     :: term(),
    Reason    :: term().
start(_StartType, _StartArgs) ->
  print_banner(),
  {ok, Sup} = log_server_sup:start_link(),
  start_servers(Sup),
  print_vsn(),
  {ok, Sup}.

new_kv_ets() ->
    ets:new(log_server_kv, [named_table,public,set]),
    {ok, DBType} = util:get_env( log_server, db_type, ?DB_TYPE_MYSQL),
    ets:insert(log_server_kv, {db_type, DBType}).
    
start_servers(_Sup) ->
  {ok,Im} = application:get_env(log_server,emqttd),
  net_adm:ping(Im),
  new_kv_ets(),
  start_others_supers(),
  erlang:system_monitor(whereis(dets),[{large_heap,120000}]).

start_others_supers() ->
    case ets:lookup( log_server_kv, db_type ) of
        [{db_type, ?DB_TYPE_MYSQL}] ->
            mysql_msg_info_sup:start_writer_process();
        _OthersServer ->
            skip
    end.

print_banner() ->
	?PRINT("starting et-clould log collection on node '~s'~n", [node()]).

print_vsn() ->
	{ok, Vsn} = application:get_key(vsn),
	{ok, Desc} = application:get_key(description),
	?PRINT("~s ~s is running now~n", [Desc, Vsn]).



%%------------------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application has stopped. It
%% is intended to be the opposite of Module:start/2 and should do
%% any necessary cleaning up. The return value is ignored.
%%
%% @end
%%------------------------------------------------------------------------------
-spec stop(State :: term()) -> term().
stop(_State) ->
    ok.



