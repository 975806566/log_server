-module(tools).
-author("hpj").
-compile(export_all).

get_tablename(UID,TableName) when is_binary(UID) ->
  Tail = integer_to_list(lists:last(binary_to_list(UID))),
  Tail1 = string:sub_string(Tail,length(Tail),length(Tail)),
  atom_to_list(TableName)++Tail1;

get_tablename(UID,TableName) when is_list(UID) ->
  Tail = integer_to_list(lists:last(UID)),
  Tail1 = string:sub_string(Tail,length(Tail),length(Tail)),
  atom_to_list(TableName)++Tail1.

timestamp_to_datetime(undefined) ->
    <<>>;
timestamp_to_datetime(Timestamp) when is_integer(Timestamp) ->
    {{YYYY,MM,DD},{HH,SS,Mm}} = calendar:gregorian_seconds_to_datetime(Timestamp +calendar:datetime_to_gregorian_seconds({{1970,1,1}, {8,0,0}})),
    list_to_binary(lists:concat([YYYY,"-",MM,"-",DD," ",HH,":",SS,":",Mm]));    
timestamp_to_datetime(Timestamp) when is_list(Timestamp) ->
    {{YYYY,MM,DD},{HH,SS,Mm}} = calendar:gregorian_seconds_to_datetime(list_to_integer(Timestamp) +calendar:datetime_to_gregorian_seconds({{1970,1,1}, {8,0,0}})),
    list_to_binary(lists:concat([YYYY,"-",MM,"-",DD," ",HH,":",SS,":",Mm]));

timestamp_to_datetime(Timestamp) when is_binary(Timestamp) ->
    {{YYYY,MM,DD},{HH,SS,Mm}} = calendar:gregorian_seconds_to_datetime(binary_to_integer(Timestamp) +calendar:datetime_to_gregorian_seconds({{1970,1,1}, {8,0,0}})),
    list_to_binary(lists:concat([YYYY,"-",MM,"-",DD," ",HH,":",SS,":",Mm])).


datetime_to_timestamp(undefined) ->
    <<>>;
datetime_to_timestamp(DateTime) when is_list(DateTime) ->
  [A,B] = string:tokens(DateTime," "),
  [YYYY,MM,DD] = string:tokens(A,"-"),
  [HH,SS,Mm] = string:tokens(B,":"),
  Now = {{list_to_integer(YYYY),list_to_integer(MM),list_to_integer(DD)},{list_to_integer(HH),list_to_integer(SS),list_to_integer(Mm)}},
  calendar:datetime_to_gregorian_seconds(Now) - calendar:datetime_to_gregorian_seconds({{1970,1,1}, {8,0,0}});

datetime_to_timestamp(DateTime) when is_binary(DateTime) ->
  [A,B] = string:tokens(binary_to_list(DateTime)," "),
  [YYYY,MM,DD] = string:tokens(A,"-"),
  [HH,SS,Mm] = string:tokens(B,":"),
  Now = {{list_to_integer(YYYY),list_to_integer(MM),list_to_integer(DD)},{list_to_integer(HH),list_to_integer(SS),list_to_integer(Mm)}},
  calendar:datetime_to_gregorian_seconds(Now) - calendar:datetime_to_gregorian_seconds({{1970,1,1}, {8,0,0}}).

to_16string(Content) when is_binary(Content) ->
  to_16string(binary_to_list(Content));


to_16string(Content) when is_list(Content) ->
    parse_16string(Content,"").

parse_16string([],Value) ->
  Value;
parse_16string([Content|H],Value) ->
  Content1 = integer_to_list(Content,16),
  Value1 = Value ++ Content1,
  parse_16string(H,Value1).

parse_cause(undefined) ->
  0;
parse_cause(conn_closed) ->
  1;
parse_cause(timeout) ->
  2;  
parse_cause(duplicate_id) ->
  3;  
parse_cause(keepalive_timeout) ->
  4;  
parse_cause(normal) ->
  5;
parse_cause(_) ->
  6.

parse_messagetype(chat) ->
  1;    
parse_messagetype(sfile) ->
  2; 
parse_messagetype(svideo) ->
  3; 
parse_messagetype(chat_ex) ->
  4; 
parse_messagetype(publish) ->
  5; 
parse_messagetype(_) ->
  6.      
