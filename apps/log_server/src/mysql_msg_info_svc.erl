-module(mysql_msg_info_svc).

-behaviour(gen_server).

%% API functions
-export([start_link/3]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-record(state, {
                length = 0,
                table_name = undefined,
                sql_head = undefined,
                sql_ref
        }).

-export([
         get_server_name/2,
         insert_msg/5,
         insert_login/6
        ]).

-include_lib("eunit/include/eunit.hrl").

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------

-define(MAX_QUEUE_SIZE,         50 * 10000).
-define(BLOCK_SIZE,             20).
-define(TIMER_INTERVAL,         50).
-define(FORCE_GC,               12 * 60 * 1000).

insert_msg(ServerName, FromUid, ToUid, Content, Type) ->
    gen_server:cast(ServerName, {insert_msg, [ FromUid, ToUid, Content, Type ]}).

insert_login(ServerName, Uid, Ip, Type, Cause, Remark) ->
    gen_server:cast(ServerName, {insert_msg, [ Uid, Ip, Type, Cause, Remark ]}).
    
% ---------------------------------------------------------------------
% @doc 获取进程名
% ---------------------------------------------------------------------
get_server_name(Type, Id) ->
    list_to_atom(util:a2l(Type) ++ util:a2l(Id)).

force_gc() ->
    erlang:send_after( ?FORCE_GC, self(), {force_gc}).

timer_interval() ->
    erlang:send_after( ?TIMER_INTERVAL, self(), {timer_interval}).

start_link( ServerName, SqlHead, SqlRef ) ->
    gen_server:start_link({local, ServerName }, ?MODULE, [ ServerName, SqlHead, SqlRef ], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([ ServerName, SqlHead, SqlRef ]) ->
    force_gc(),
    timer_interval(),
    my_queue:new( util:ceil( ?MAX_QUEUE_SIZE / ?BLOCK_SIZE) ),
    {ok, #state{ table_name = ServerName, sql_head = SqlHead, sql_ref = SqlRef}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast({insert_msg, Msg}, State) ->
    case State#state.length > ?MAX_QUEUE_SIZE of
        true ->
            {noreply, State};
        _NotFull ->
            my_queue:in(Msg, ?BLOCK_SIZE ),
            {noreply, State#state{length = State#state.length + 1}}
    end;
handle_cast(_Msg, State) ->
    {noreply, State}.

make_sql(SqlRefHead, SqlRef , Args) ->
    Len = length(Args),
    case get({prepare, Len}) of
        undefined ->
            [ _H | SqlRefs ] = lists:flatten(lists:duplicate(Len, SqlRef)),
            Sql0 = SqlRefHead ++ SqlRefs,
            put( {prepare, Len}, Sql0),
            Sql0;
        Sql ->
            Sql
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info({timer_interval}, State) ->
    timer_interval(),
    case my_queue:empty() of
        true ->
            {noreply, State};
        _NotEmpty ->
            NewState = 
            try
              {message_queue_len, MsgQueueLen} = erlang:process_info(self(), message_queue_len),
               case MsgQueueLen > 500 of
                    true ->
                        State;
                    _NotBusy ->
                        Fun = fun(_X, Pid) ->
                            case my_queue:empty() of
                                true ->
                                    Pid;
                                _NotEmpty  ->
                                    BlockList = my_queue:out(),
                                    NewSql = make_sql(State#state.sql_head, State#state.sql_ref, BlockList),
                                    ok = mysql:query(Pid, NewSql, lists:concat( BlockList ) ),
                                    Pid
                            end
                    end,
                    % util:print("NewSql:~p ~n, BlockList:~p ~n",[NewSql, BlockList]),
                    mysql_poolboy:with(pool1, fun (Pid) ->
                                                lists:foldl(Fun, Pid, lists:seq(1, 5) )
                                        end),
                    State#state{length = my_queue:size()}
             end
            catch
                M:R ->
                    lager:error("Insert msg error! M:~p R:~p ~n detail:~p ~n",[M, R, erlang:get_stacktrace() ]),
                    State
            end,
            {noreply, NewState}
    end;
handle_info({force_gc}, State) ->
    force_gc(),
    spawn(fun() -> erlang:garbage_collect( self() ) end),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================


make_sql_test() ->
    Sql = "insert into t(id,name) values (?,?),(?,?)",
    ?assertEqual(Sql, make_sql("insert into t(id,name) values ", ",(?,?)", [[1,2],[3,2]])).



