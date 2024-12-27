-module(gleam_time_ffi).
-export([system_time/0]).

system_time() ->
    {0, erlang:system_time(nanosecond)}.
