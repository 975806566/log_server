
-ifndef(COMMON_HRL).

-define(COMMON_HRL, true).

-define(ERL_HEAD_TYPE, "application/x-www-form-urlencoded").

-define(INFO(A,B),
        lager:info(A,B)).
 
-define(ERROR(A,B),
        lager:error(A,B)).

-define(DEBUG(A,B),
        lager:debug(A,B)).

-define(WARNING(A,B),
        lager:warning(A,B)).

-define(INFO(A),?INFO(A,[])).
-define(ERROR(A),?ERROR(A,[])).
-define(DEBUG(A),?DEBUG(A,[])).
-define(WARNING(A),?WARNING(A,[])).


-define(M_POST,         post).
-define(M_GET,          get).
-define(M_PUT,          put).
-define(M_HEAD,         head).
-define(M_DELETE,       delete).

% 定义Header的数据类型
-define(CONENTTYPE_FORM, "application/x-www-form-urlencoded;charset=UTF-8").
-define(CONENTTYPE_JSON, "application/json;charset=UTF-8").
-define(CONENTTYPE_TEXT, "text/xml;charset=UTF-8").


-define(TEST_BEGIN(),?INFO("=================== [~p begin] ===========~n~n~n~n~n",[?MODULE])).

-define(TEST_SUCC(),?INFO("=================== [~p sucess] ==========~n~n~n~n~n",[?MODULE])).

% 用于打印
-define(PRINT(A, B), util:print(A, B)).

-define(PRINT(A),   ?PRINT(A,[])).

-define(A2L(X),     util:a2l(X)).

-define(A2B(X),     util:a2b(X)).

% 一些常用宏的宏定义。以免敲错代码敲错。
-define(FALSE,                  false).
-define(TRUE,                   true).
-define(UNDEFINED,              undefined).
-define(NULL,                   <<"">>).

% ------------------------------------------------
% 多语言宏定义
% ------------------------------------------------
-define(LOCALE_ZH,      "zh").  % 中文 
-define(LOCALE_EN,      "en").  % 英文

-endif.
