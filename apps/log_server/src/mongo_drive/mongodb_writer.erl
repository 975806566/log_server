% ---------------------------------------------------------------------------------------------------
% @doc 用于写入 mongodb 的工作进程
% @author 陈一鸣
% ---------------------------------------------------------------------------------------------------

-module(mongodb_writer).

-behaviour(gen_server).

%% API functions
-export([start_link/1]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-export([
        insert_data/2,
        get_server_name/1
        ]).

-include("mysql.hrl").

-record(state, {
                    name = 1,
                    status = ?MONGO_WRITER_STATUS_IDLE,
                    msg_queue = []
               }).

-define(EACH_PACKAGE_SIZE,      200).        % 每次打包给 monodb 的包size
%%%===================================================================
%%% API functions
%%%===================================================================

% ---------------------------------------------------------------------
% @doc 获取进程名
% ---------------------------------------------------------------------
get_server_name(Id) ->
    list_to_atom("mongodb_writer_" ++ util:a2l(Id)).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(Id) ->
    gen_server:start_link({local, get_server_name(Id)}, ?MODULE, [Id], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

% --------------------------------------------------------------------
% 把输入插入到写进程
% --------------------------------------------------------------------
insert_data(_Id, []) ->
    ok;
insert_data(Id, MsgList) ->
    gen_server:call(get_server_name(Id),    {insert_data, MsgList}).

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
init([Id]) ->
    msg_queue_svc:update_writer_status(Id, ?MONGO_WRITER_STATUS_IDLE),
    lager:info("start mongodb_writer ~p ok~n",[Id]),
    {ok, #state{    
                    name = Id,
                    status = ?MONGO_WRITER_STATUS_IDLE,
                    msg_queue = []
               }}.

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

handle_call({insert_data, MsgList}, _From, State) ->
    self() ! {insert_to_mongodb},
    msg_queue_svc:update_writer_status(State#state.name, ?MONGO_WRITER_STATUS_BUSY),
    {reply, {ok}, State#state{msg_queue = MsgList}};
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
handle_cast(_Msg, State) ->
    {noreply, State}.

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
handle_info({insert_to_mongodb}, State) ->
    try
        Queue = State#state.msg_queue,
        MsgLists = util:splite_lists( Queue, util:ceil(length(Queue) / ?EACH_PACKAGE_SIZE) ),
        lists:foreach(
                    fun(E) ->
                        {{true, _Num}, _OthersInfo } = mongoc:transaction(?DB_POOL , fun(Worker) -> mc_worker_api:insert(Worker, ?TABLE_NAME,  E) end)
                    end,
                 MsgLists),
        msg_queue_svc:update_writer_status(State#state.name, ?MONGO_WRITER_STATUS_IDLE),
       { noreply, State#state{msg_queue = []}}
    catch
       M: R ->
         lager:error("M:~p R:~p ~n~p ~n",[M, R, erlang:get_stacktrace()]),
         msg_queue_svc:update_writer_status(State#state.name, ?MONGO_WRITER_STATUS_IDLE),
         { noreply, State}
   end;
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
