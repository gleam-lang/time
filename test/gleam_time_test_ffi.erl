-module(gleam_time_test_ffi).
-export([rfc3339_to_system_time_in_milliseconds/1]).

% WARNING: This rounds, ours truncates.
rfc3339_to_system_time_in_milliseconds(Timestamp) when is_binary(Timestamp) ->
    try
        Timestamp_list = binary:bin_to_list(Timestamp),
        Milliseconds = calendar:rfc3339_to_system_time(Timestamp_list, [{unit, millisecond}]),
        Adjusted_milliseconds = adjust_system_time(Milliseconds),
        {ok, Adjusted_milliseconds}
    catch
        error:_ ->
            {error, nil}
    end.

% TODO: this time adjustment will need to be removed once the bug is fixed
% upstream: https://github.com/erlang/otp/issues/9279.
adjust_system_time(Milliseconds) when is_integer(Milliseconds) ->
    if
        Milliseconds >= 0 ->
            Milliseconds;
        Milliseconds < 0 ->
            % Fractional_seconds will be <= 0 here
            Fractional_seconds = Milliseconds rem 1_000,
            Milliseconds - 2 * Fractional_seconds
    end.
