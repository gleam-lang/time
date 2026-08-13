//// Monotonic time for measuring local elapsed time.
////
//// Monotonic instants are useful when you need to measure elapsed time between
//// events and wall-clock changes must not affect the result. For example, use
//// this module for timeouts, peer liveness checks, or benchmarking.
////
//// An `Instant` is not a timestamp. It does not represent calendar time, Unix
//// time, or any globally meaningful point in time. Do not store it, display it
//// to users, send it to other machines, or compare values created by different
//// runtime instances.
////
//// On Erlang this uses [`erlang:monotonic_time/1`][erlang]. On JavaScript this
//// uses [`performance.now`][javascript].
////
//// [erlang]: https://www.erlang.org/doc/apps/erts/erlang.html#monotonic_time/1
//// [javascript]: https://developer.mozilla.org/en-US/docs/Web/API/Performance/now

import gleam/int
import gleam/order
import gleam/time/duration.{type Duration}

/// A monotonic instant from the local runtime.
///
/// Instants are only meaningful when compared with other instants created by
/// this module in the same runtime instance.
pub opaque type Instant {
  Instant(seconds: Int, nanoseconds: Int)
}

/// Get the current monotonic instant.
///
/// The returned value is not wall-clock time. It should only be used for
/// measuring elapsed local time.
pub fn now() -> Instant {
  let #(seconds, nanoseconds) = monotonic_time()
  Instant(seconds, nanoseconds)
  |> normalise
}

@external(erlang, "gleam_time_ffi", "monotonic_time")
@external(javascript, "../../gleam_time_ffi.mjs", "monotonic_time")
fn monotonic_time() -> #(Int, Int)

/// Compare two monotonic instants.
pub fn compare(left: Instant, right: Instant) -> order.Order {
  order.break_tie(
    int.compare(left.seconds, right.seconds),
    int.compare(left.nanoseconds, right.nanoseconds),
  )
}

/// Calculate the elapsed duration between two monotonic instants.
///
/// This is effectively subtracting the first instant from the second. If the
/// second instant is earlier than the first, the returned duration will be
/// negative.
pub fn difference(left: Instant, right: Instant) -> Duration {
  let seconds = duration.seconds(right.seconds - left.seconds)
  let nanoseconds = duration.nanoseconds(right.nanoseconds - left.nanoseconds)
  duration.add(seconds, nanoseconds)
}

/// Calculate the duration elapsed since a monotonic instant.
pub fn elapsed_since(instant: Instant) -> Duration {
  difference(instant, now())
}

fn normalise(instant: Instant) -> Instant {
  let multiplier = 1_000_000_000
  let nanoseconds = instant.nanoseconds % multiplier
  let overflow = instant.nanoseconds - nanoseconds
  let seconds = instant.seconds + overflow / multiplier
  case nanoseconds >= 0 {
    True -> Instant(seconds, nanoseconds)
    False -> Instant(seconds - 1, multiplier + nanoseconds)
  }
}
