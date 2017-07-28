-define(LOG_POOL, log_db).
-define(record_field(Table), record_info(fields, Table)).

-record(login_info, {
  login_info_id			    :: integer(),
  uid                   :: string() | binary(),
  ip                    :: string() | binary(),
  type                  :: integer(),
  cause                 :: string() | binary(),
  date_time             :: string() | binary(),
  remark                  :: string() | binary()
}).

-record(msg_info, {
  msg_info_id			      :: integer(),
  from_uid              :: string() | binary(),
  to_uid                :: string() | binary(),
  content               :: string() | binary(),
  type                  :: integer(),
  date_time             :: string() | binary(),
  remark                  :: string() | binary()
}).


-define(DB_POOL,            log_pool).
-define(TABLE_NAME,         <<"log_server">>).



-define(MONGO_WRITER_STATUS_IDLE,           0).
-define(MONGO_WRITER_STATUS_BUSY,           1).


-define(WRITER_NUM,                         14).
-define(ETS_NAME_PROCESS_STATUS,            process_status).

-record(writer_status,{
            name = 0,
            status = ?MONGO_WRITER_STATUS_IDLE
        }).

-define( DB_TYPE_MYSQL,         mysql).
-define( DB_TYPE_MONGO,         mongodb).

-define(APP_NAME,               log_server).

-define(TABLE_NUM,              10).

