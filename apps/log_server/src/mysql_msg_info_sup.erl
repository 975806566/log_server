
-module(mysql_msg_info_sup).

-include("mysql.hrl").

-export([
         start_link/0,
         init/1,
         start_writer_process/0
        ]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    ChildSpec = {mysql_msg_info_svc,
                 {mysql_msg_info_svc, start_link, []},
                 transient,
                 10000,
                 worker,
                 [mysql_msg_info_svc]},

    {ok, {{simple_one_for_one, 10, 3600}, [ChildSpec]}}.

do_get_msg_info_sql( Id ) ->
    SqlHead = "insert into msg_info" ++ util:a2l(Id - 1) ++ "(from_uid,to_uid,content,type,date_time) values ",
    SqlRef = ",(?,?,?,?,now())",
    { mysql_msg_info_svc:get_server_name(msg_info, Id - 1) , SqlHead, SqlRef}. 

do_get_login_sql( Id ) ->
    SqlHead = "insert into login_info" ++ util:a2l( Id - 1) ++ "(uid,ip,type,cause,date_time,remark) values ",
    SqlRef = ",(?,?,?,?,now(),?)",
    {mysql_msg_info_svc:get_server_name(login_info, Id - 1), SqlHead, SqlRef}.

start_writer_process() ->
    L = lists:seq(1, ?TABLE_NUM),
    Fun = fun(Id,_Acc) ->
        {NameMsg, HMsg, RMsg} = do_get_msg_info_sql( Id ),  
        {ok, _ChildMsg} = supervisor:start_child(?MODULE, [ NameMsg, HMsg, RMsg ]),
        {NameLogin, HLogin, RLogin} = do_get_login_sql( Id ),
        {ok, _Child} = supervisor:start_child(mysql_msg_info_sup, [ NameLogin, HLogin, RLogin  ])
    end,
    lists:foldl(Fun, [], L).



