erl \
    -pa apps/*/ebin/  deps/*/ebin/  \
    -config rel/files/sys.config \
    -args_file rel/files/vm.args \
    -s main \
    -s reloader
