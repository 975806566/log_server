

-module(mongo_drive_test).


-export([ 
         test/0,
         test_loop/0,
         init_connection/0,
         clear_test_table/0
         ]).

-include("common.hrl").
-include("mongo.hrl").
-include_lib("eunit/include/eunit.hrl").


-define(TAB,    <<"test">>).
-define(DATA_FILE, "data/single_test_001.data").
-define(EACH_PROCESS_SUM,   10000).
-define(CONFIG,     mongo_config).
-define(DB_POOL,    db_pool).
-define(PACK_NUM,   20).

% ----------------------------------------------------------------
% @doc 启动所有的 application
% ----------------------------------------------------------------
start_apps() ->
    mongo_count_svc:start_link(),
    application:ensure_all_started(lager),
    case mongo_config:get_drite() of
        ?MO_TYPE_OCTOPUS ->
            application:ensure_all_started(mongodb);
        ?MO_TYPE_MONGODB_1 ->
            application:ensure_all_started(mongodb);
        ?MO_TYPE_MONGODB_2 ->
            application:ensure_all_started(emongo);
        _Others ->
            io:format("can't reb the type:~p ~n",[_Others]),
            skip
    end.
% ---------------------------------------------------------------
% @doc 初始化缓冲池和连接
% ---------------------------------------------------------------
init_connection() ->
    PoolNum = ?CONFIG:get_pool_num(),
    Seed ={ rs, <<"Repset">>, [ "192.168.191.12:27017", "192.168.191.12:27017" ] },

    Options  = [
                {register, ?DB_POOL},
                {name, pool_name},
                { max_overflow, 256},
                {pool_size, PoolNum}
           ],

    WorkerOptions  = [
                        {database, <<"rep_test">>},
                        {w_mode, safe}
                    ],

    {ok, _Topology} = mongoc:connect( Seed, Options, WorkerOptions ).



clear_test_table() ->
    mongoc:transaction(?DB_POOL, fun(Worker) -> mc_worker_api:delete(Worker, util:a2b(?TAB), {}) end ).

get_insert_list() ->
    {ok, InsertList} = file:consult(?DATA_FILE),
    InsertList.

do_change_insert_data(_Flag, [], ResList) ->
    ResList;
do_change_insert_data(false, [E | List], ResList) ->
    do_change_insert_data({E}, List, ResList);
do_change_insert_data({E0}, [E | List], ResList) ->
    EChange = 
        case is_atom(E) of
            true ->
                ?A2L(E);
            _OthersCase ->
                E
        end, 
    do_change_insert_data(false, List, [{E0, EChange} | ResList]).
    
do_change_insert_data(Data) ->
    DtList = tuple_to_list(Data),
    do_change_insert_data(false, DtList, []).

get_insert_list_1() ->
    InsertList0 = get_insert_list(),
    case mongo_config:get_drite() of
        ?MO_TYPE_OCTOPUS ->
            InsertList0;
        ?MO_TYPE_MONGODB_1 ->
            InsertList0;
        ?MO_TYPE_MONGODB_2 ->
            [ do_change_insert_data(E) || E <- InsertList0 ];
        _Others ->
            lager:error("can't reb the type:~p ~n",[_Others]),
            []
    end.

% --------------------------------------------------------------
% @doc 将列表均等切分
% --------------------------------------------------------------
splite_lists(List, Num) ->
    Len = length(List),
    SubLen = Len div Num,
    do_splite_lists(SubLen, List, []).

do_splite_lists(SubLen, LeftList, AccList) ->
    case length(LeftList) < SubLen of
        true ->
            AccList;
        _Continue ->
            {Seg, LeftList1} = lists:split(SubLen, LeftList),
            do_splite_lists(SubLen, LeftList1, [Seg | AccList])
    end.

do_random_uid(Range) ->
    util:a2b(random:uniform(Range)).

do_one_loop_test(LoopTimes, _Conn, EachSum, Tab, Name) ->
    % ?WARNING("Name:~p begin running ~n",[Name]),
    BeginMs = util:longunixtime(),
    UidRange = 10 * 10000,
    Now = now(),
    Fun = fun(X, AccList) ->
        Id = util:a2b(LoopTimes * 10000 * 10000 + Name * 10000 + X),
        % util:print("ID:~p ~n",[Id]),
        [{'_id', Id, 
            <<"from_uid">>, do_random_uid(UidRange), 
            <<"to_uid">>, do_random_uid(UidRange), 
            <<"content">>, util:a2b("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" ++ util:a2l(do_random_uid(UidRange))),
            <<"type">>, 0,
            <<"date_time">>, Now,
            <<"remark">>, <<"this is a remark">>} | AccList]
    end,
    InsertList = lists:foldl(Fun, [], lists:seq(1, EachSum) ),
    % [ {{true, _Num}, _OthersInfo } = mongoc:transaction(?DB_POOL, fun(Worker) -> mc_worker_api:insert(Worker, util:a2b(Tab),  Bson) end) || Bson <- InsertList ],
    % {{true, _Num}, _OthersInfo } = mongoc:transaction(?DB_POOL, fun(Worker) -> mc_worker_api:insert(Worker, util:a2b(Tab),  InsertList) end),
    InsertList1 = splite_lists(InsertList, ?EACH_PROCESS_SUM div ?PACK_NUM),
    [ {{true, _Num}, _OthersInfo } = mongoc:transaction(?DB_POOL, fun(Worker) -> mc_worker_api:insert(Worker, util:a2b(Tab),  Bson) end) || Bson <- InsertList1 ],
    EndMs = util:longunixtime(),
    mongo_count_svc:update_end_time(Name, EndMs - BeginMs)
    .

do_get_all_sum_loop() ->
     ?EACH_PROCESS_SUM * ?CONFIG:get_process_num().

ensure_all_index() ->
    mongoc:transaction(?DB_POOL , fun(Worker) ->  mc_worker_api:ensure_index(Worker , <<"test">>, #{<<"key">> => {<<"from_uid">>, 1}}) end),
    mongoc:transaction(?DB_POOL , fun(Worker) ->  mc_worker_api:ensure_index(Worker , <<"test">>, #{<<"key">> => {<<"to_uid">>, 1}}) end),
    mongoc:transaction(?DB_POOL, fun(Worker) ->  mc_worker_api:ensure_index(Worker , <<"test">>, #{<<"key">> => {<<"date_time">>, -1}}) end).

test_loop() ->
    random:seed(erlang:now()),
    start_apps(),
    lager:error("mongo drive test begin ~n",[]),
    ?PRINT("============ init test is ok ~n"),
    init_connection(),
    ?PRINT("============ init connection is ok ~n",[]),
    ensure_all_index(),

    L = lists:seq(1, 400),
    Fun = fun(X, _Acc) ->
        test_loop(X),
        timer:sleep(do_get_all_sum_loop() div 10 + 200)
    end,
    FunLoopAll =
        fun(_X, _AccList) ->
            lists:foldl(Fun, [], L)
        end,
    lists:foldl( FunLoopAll, [], lists:seq(1, 1000) ).

test_loop( LoopTimes ) ->

    LoopTimesBin = util:a2b(LoopTimes),
    file:write_file("./record_all.txt", <<"--------- loop times ", LoopTimesBin/binary, "\n">>, [ append ]),

    SubLen = ?CONFIG:get_process_num(),
    AllNums = ?EACH_PROCESS_SUM * SubLen,
    mongo_count_svc:set_wait_process_num( SubLen, AllNums ),
    ?PRINT("loopTimes:~p eachSum:~p ~n",[ LoopTimes, AllNums ]),    

    Fun = fun( _E , Num ) ->
        ?PRINT("GetConn:~p ~n",[Num]),
        spawn(fun() -> do_one_loop_test( LoopTimes, ok, ?EACH_PROCESS_SUM, ?TAB, Num) end),
        Num + 1
    end,
    lists:foldl(Fun, 0, lists:seq( 1, SubLen ) ).

test() ->
    start_apps(),
    lager:error("mongo drive test begin ~n",[]),
    ?PRINT("============ init test is ok ~n"),
    init_connection(),
    ?PRINT("============ init connection is ok ~n",[]),
    clear_test_table(),
    ?PRINT("============ clear all datas~n",[]),
    BeginTime = util:longunixtime(),
    InsertList = get_insert_list_1(),
    [ {{true, _Num}, _OthersInfo } = mongoc:transaction(?DB_POOL, fun(Worker) -> mc_worker_api:insert(Worker, util:a2b(?TAB),  Bson) end) || Bson <- InsertList ],
    EndTime = util:longunixtime(),
    AllTime = 
        case EndTime - BeginTime of
            0 ->
               1;
            Time ->
                Time
    end,
    util:print("AllTime:~p Rate: ~p ~n",[AllTime, (length(InsertList) * 1000) div AllTime]),
    ok.

change_insert_data_test() ->
    Exp0 = [{a, 1}, {b, 2}, {c, 3}, {d, 4}],
    Exp = lists:sort(Exp0),
    Data = {a, 1, b, 2, c, 3, d, 4},
    Erl0 = do_change_insert_data(Data),
    Erl = lists:sort(Erl0),
    Exp = Erl,
    
    Seg0 = splite_lists([1,2,3,4,5,6,7,8,9,10], 3),
    Seg = lists:sort(Seg0),
    ExpSeg0 = [[1, 2 ,3],[4, 5, 6],[7, 8, 9]],
    ExpSeg = lists:sort(ExpSeg0),
    Seg = ExpSeg,
    ok.




