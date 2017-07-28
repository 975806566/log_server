
-module(log_server_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).



%% ===================================================================
%% API functions
%% ===================================================================

-include("mysql.hrl").

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, DBType} = util:get_env( log_server, db_type, ?DB_TYPE_MYSQL ),
    ChildSpecs = get_sup_specs( DBType ),
    {ok, {{one_for_one, 10, 10}, ChildSpecs}}.

% --------------------------------------------------------------------
% @doc 根据配置判断到底需要启动那个驱动
% --------------------------------------------------------------------
get_sup_specs( ?DB_TYPE_MYSQL ) ->
    PoolOptionsDefault  = [{size, 10}, {max_overflow, 20}],
    MySqlOptionsDefault = [{user, "root"}, {password, "123456"}, {database, "log_db"}],

	{ok, PoolOptions} = util:get_env(log_server,  mysql_pooloptions, PoolOptionsDefault),
	{ok, MySqlOptions} = util:get_env(log_server, mysql_options, MySqlOptionsDefault),
    [
        % MySQL pools
        mysql_poolboy:child_spec(pool1, PoolOptions, MySqlOptions),
        
        {msg_queue_svc, {mysql_msg_info_sup, start_link, []}, permanent, 10, supervisor, [mysql_msg_info_sup]}
    ];
get_sup_specs( ?DB_TYPE_MONGO ) ->
    [

		% msg_queue_server
        {msg_queue_svc, {msg_queue_svc, start_link, []}, permanent, 10, worker, [msg_queue_svc]}
    ].
