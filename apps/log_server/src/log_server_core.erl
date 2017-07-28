-module(log_server_core).

-include("mysql.hrl").

-export([
            login_info/4, 
            msg_info/4,
            my_cast/1
        ]).


login_info(Uid, Ip, Type, Cause) ->
    {ok, DBDrive} = util:get_env( log_server, db_type, ?DB_TYPE_MYSQL),
    do_login_info( DBDrive, Uid, Ip, Type, Cause).

do_get_server_name(Type, Uid ) ->
    Tail = lists:last(util:a2l(Uid)) rem 10,
	mysql_msg_info_svc:get_server_name(Type, Tail).
    

do_login_info(?DB_TYPE_MYSQL, Uid,Ip,Type,Cause) when is_binary(Ip)->
	login_info(Uid,binary_to_list(Ip),Type,Cause);
do_login_info(?DB_TYPE_MYSQL, Uid,Ip,Type,Cause) ->
	ServerName = do_get_server_name(login_info, Uid ),
	Cause1 = tools:parse_cause(Cause),
	mysql_msg_info_svc:insert_login(ServerName, Uid, Ip, Type, Cause1, <<"">> ) ;
do_login_info(?DB_TYPE_MONGO, _Uid, _Ip, _Type, _Case) ->
    ok.
	
msg_info(From, To, Content, Type) ->
    NewDBDrive = 
    case ets:lookup( log_server_kv, db_type) of
        [{db_type, DBDrive}] ->
            DBDrive;
        _NoThisContent ->
            {ok, DBDrive1} = util:get_env( log_server, db_type, ?DB_TYPE_MYSQL),
            DBDrive1
    end,
    do_msg_info( NewDBDrive, From, To, Content, Type).
    
do_msg_info(?DB_TYPE_MYSQL, From,To,Content,Type) ->
	ServerName = do_get_server_name(msg_info, From ),
	Type1 = tools:parse_messagetype(Type),  
	mysql_msg_info_svc:insert_msg( ServerName, From, To, Content, Type1);
do_msg_info(?DB_TYPE_MONGO, From , To, Content, Type) ->
    Type1 = tools:parse_messagetype(Type),
    Msg = { <<"type">>, Type1, <<"date_time">>, os:timestamp(), <<"from_uid">>, util:a2b(From), <<"to_uid">>, util:a2b(To), <<"remark">>, <<"">>, <<"content">>, util:a2b(Content)},
    msg_queue_svc:insert_msg(Msg).


my_cast( ZipBin ) ->
    % util:print("~p ~n",[ZipBin]),
    MsgList = erlang:binary_to_term(zlib:unzip( ZipBin )),
    Fun = fun({From, To, Con, Type}, _Acc) ->
        do_msg_info(?DB_TYPE_MONGO, From, To, Con, Type)
    end,
    lists:foldl(Fun, 0, MsgList).
