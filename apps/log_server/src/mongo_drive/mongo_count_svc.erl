-module(mongo_count_svc).

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

-record(state, {
                begin_time = 0,
                max_end_time = 0,
                total_time = 0,
                wait_num = 0,
                sum = 0,
                count_list = maps:new()
               }).

-include("common.hrl").
-include_lib("eunit/include/eunit.hrl").

-export([
         show/0,
         set_begin_time/1,
         set_wait_process_num/2,
         update_end_time/2
        ]).

% ---------------------------------------------------------------
% @doc 
% Num:: 本次处理总程序的数量
% Sum:: 本次处理总的条数
% ---------------------------------------------------------------
set_wait_process_num(Num, Sum) ->
    gen_server:call(?MODULE, {wait_num, Num, Sum}).

show() ->
    gen_server:cast(?MODULE, {show}).

set_begin_time(BeginTime) ->
    gen_server:call(?MODULE, {set_begin_time, BeginTime}).

update_end_time(Pid, EndTime) ->
    gen_server:call(?MODULE, {update_end_time, Pid, EndTime}).


start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).


init([]) ->
    {ok, #state{}}.

do_show_report(MaxTime, TotalTime, AvgProc, AvgProcOne) ->
    ?PRINT("MaxTime:~p TotalTime:~p AvgProc:~p AvgProcOneProcess:~p ~n",[MaxTime, TotalTime, AvgProc, AvgProcOne]),
    Bin = io_lib:format("MaxTime ~p TotalTime ~p AvgProc ~p AvgProcOneProcess ~p ~n",[MaxTime, TotalTime, AvgProc, AvgProcOne]),
    file:write_file("./record_all.txt", Bin, [ append ]).

do_sub_num(State) ->
    ?PRINT("do sub num: ~p~n",[State#state.wait_num]),
    NewNum =
    case State#state.wait_num of
        1 ->
            MaxTime = State#state.max_end_time,
            TotalTime = State#state.total_time,
            Sum = State#state.sum,
            AvgProc = Sum * 1000 div MaxTime,
            AvgProcOne = Sum * 1000 div TotalTime,
            do_show_report(MaxTime, TotalTime, AvgProc, AvgProcOne),
            0;
        Num ->
            Num - 1
    end,
    State#state{wait_num = NewNum}. 


handle_call({wait_num, Num, Sum}, _From, _State) ->
    Reply = ok,
    State0 = #state{},
    {reply, Reply, State0#state{wait_num = Num, sum = Sum}};

handle_call({update_end_time, Pid, EndTime}, _From, State) ->
    NewEndTime = max(State#state.max_end_time, EndTime),
    Reply = ok,
    OldMaps = State#state.count_list,
    NewMaps = maps:put(Pid, EndTime, OldMaps),
    OldTotalTime = State#state.total_time,
    NewTotalTime = OldTotalTime + EndTime,
    State1 = State#state{max_end_time = NewEndTime, count_list = NewMaps, total_time = NewTotalTime},
    State2 = do_sub_num(State1),
    {reply, Reply, State2};

handle_call({set_begin_time,BeginTime}, _From, State) ->
    Reply = ok,
    {reply, Reply, State#state{begin_time = BeginTime}}.

handle_cast({show}, State) ->
    ?PRINT("State: ~p ~n",[State]),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


