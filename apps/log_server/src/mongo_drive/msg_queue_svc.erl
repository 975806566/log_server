-module(msg_queue_svc).

-behaviour(gen_server).

%% API functions
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-export([
        update_writer_status/2,
        get_writer_status/1,
        insert_msg/1
        ]).

-include("mysql.hrl").

-define(QUEUE_MAX_SIZE,         200 * 10000).
-define(TIMER_INTERVAL,         1000).
-define(FORCE_GC,               2 * 60 * 1000).

-define( DEFAUT_SEED, { rs, <<"Repset">>, [ "127.0.0.1:27017" ] }).
-define( DEFAULT_DATABASE,  <<"rep_test">> ).


-record(state, {length = 0}).


timer_interval() ->
    erlang:send_after( ?TIMER_INTERVAL, self(), {timer_interval}).

force_gc() ->
    erlang:send_after( ?FORCE_GC, self(), {force_gc}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

new_ets() ->
    ets:new(?ETS_NAME_PROCESS_STATUS,       [public, named_table, {keypos, #writer_status.name}, set]).

update_writer_status( Id, Status ) ->
    ets:insert( ?ETS_NAME_PROCESS_STATUS, #writer_status{ name = Id, status = Status}).

insert_msg(Msg) ->
    gen_server:cast(?MODULE, {insert_msg, Msg}).

get_writer_status( Id ) ->
    case ets:lookup( ?ETS_NAME_PROCESS_STATUS, Id ) of
        [] ->
            ?MONGO_WRITER_STATUS_IDLE;
        [Rc] ->
            Rc#writer_status.status
    end.

start_all_mongodb_writers() ->
    {ok,  _Sup} = mongodb_writer_sup:start_link(),
    io:format("whereis mongodb writer: ~p ~n",[whereis(mongodb_writer_sup)]),
    mongodb_writer_sup:start_writer_process().

start_db_drive() ->
    {ok, DBDrive} = util:get_env( ?APP_NAME, db_type, ?DB_TYPE_MYSQL),
    {ok, List} = application:ensure_all_started( DBDrive ),
    start_mongodb_drive(),
    ensure_all_index(),
    io:format(" db drive ~p start ok.~p ~n",[DBDrive, List]),
    ok.

ensure_all_index() ->
    ok = mongoc:transaction(?DB_POOL , fun(Worker) ->  mc_worker_api:ensure_index(Worker , ?TABLE_NAME, #{<<"key">> => {<<"from_uid">>, 1}}) end),
    ok = mongoc:transaction(?DB_POOL , fun(Worker) ->  mc_worker_api:ensure_index(Worker , ?TABLE_NAME, #{<<"key">> => {<<"to_uid">>, 1}}) end),
    ok = mongoc:transaction(?DB_POOL, fun(Worker) ->  mc_worker_api:ensure_index(Worker ,  ?TABLE_NAME, #{<<"key">> => {<<"date_time">>, -1}}) end).

start_mongodb_drive() ->
    lager:info("start mongodb drive waiting........... ~n",[]),
    {ok, Seed} = util:get_env( log_server, mongodb_repset, ?DEFAUT_SEED ),

    Options  = [
           {register, ?DB_POOL},
            {name, pool_name},
            {pool_size, 32}
           ],

    {ok, Database} = util:get_env( log_server, mongodb_database, ?DEFAULT_DATABASE ),

    WorkerOptions  = [
               { database, Database },
               { w_mode, safe }
               ],

    {ok, _Topology} = mongoc:connect( Seed, Options, WorkerOptions ),
    lager:info("start mongodb dirvers ok ~n",[]).

init([]) ->
    new_ets(),
    timer_interval(),
    force_gc(),
    start_db_drive(),
    start_all_mongodb_writers(),
    my_queue:new(10000),
    {ok, #state{length = 0}}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast({insert_msg, Msg}, State) ->
    case State#state.length > ?QUEUE_MAX_SIZE of
        true ->
            {noreply, State};
        _NotFull ->
            my_queue:in(Msg),
            {noreply, State#state{length = State#state.length + 1}}
    end;
handle_cast(_Msg, State) ->
    lager:error("enter uncaut cast ~p ~n",[_Msg]),
    {noreply, State}.


handle_info({force_gc}, State) ->
    force_gc(),
    spawn(fun() -> erlang:garbage_collect( self() ) end),
    {noreply, State};
handle_info({timer_interval}, State) ->
    timer_interval(),
    case my_queue:empty() of
        true ->
            {noreply, State};
        _NotEmpty ->
            NewState = 
            try
                Fun = fun(Id) ->
                    case get_writer_status(Id) of
                        ?MONGO_WRITER_STATUS_BUSY ->
                            util:print("status busy . Id:~p ~n",[Id]);
                        ?MONGO_WRITER_STATUS_IDLE ->
                            Block = my_queue:out(),
                            mongodb_writer:insert_data(Id, Block)
                    end
                end,
                lists:foreach(Fun, lists:seq(1, ?WRITER_NUM)),
                State#state{length = my_queue:size()}
            catch
                M:R ->
                    lager:error("Insert msg error! M:~p R:~p ~n detail:~p ~n",[M, R, erlang:get_stacktrace() ]),
                    State
            end,
            {noreply, NewState}
    end;
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.



