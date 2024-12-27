import gleam/int
import gleam/order
import gleam/time/duration.{type Duration}

/// A timestamp represents a moment in time, represented as an amount of time
/// since 00:00:00 UTC on 1 January 1970, also known as the _Unix epoch_.
///
/// # Wall clock time and monotonicity
///
/// Time is very complicated, especially on computers! While they generally do
/// a good job of keeping track of what the time is, computers can get
/// out-of-sync and start to report a time that is too late or too early. Most
/// computers use "network time protocol" to tell each other what they think
/// the time is, and computers that realise they are running too fast or too
/// slow will adjust their clock to correct it. When this happens it can seem
/// to your program that the current time has changed, and it may have even
/// jumped backwards in time!
///
/// This measure of time is called _wall clock time_, and it is what people
/// commonly think of when they think of time. It is important to be aware that
/// it can go backwards, and your program must not rely on it only ever going
/// forwards at a steady rate. For example, for tracking what order events happen
/// in. 
///
/// This module uses wall clock time. If your program needs time values to always
/// increase you will need a _monotonic_ time instead.
///
/// The exact way that time works will depend on what runtime you use. The
/// Erlang documentation on time has a lot of detail about time generally as well
/// as how it works on the BEAM, it is worth reading.
/// <https://www.erlang.org/doc/apps/erts/time_correction>.
///
/// # Converting to local time
///
/// Timestamps don't take into account time zones, so a moment in time will
/// have the same timestamp value regardless of where you are in the world. To
/// convert them to local time you will need to know details about the local
/// time zone, likely from a time zone database.
///
/// The UTC time zone never has any adjustments, so you don't need a time zone
/// database to convert to UTC local time.
///
pub opaque type Timestamp {
  // When compiling to JavaScript ints have limited precision and size. This
  // means that if we were to store the the timestamp in a single int the
  // timestamp would not be able to represent times far in the future or in the
  // past, or distinguish between two times that are close together. Timestamps
  // are instead represented as a number of seconds and a number of nanoseconds.
  //
  // If you have manually adjusted the seconds and nanoseconds values the
  // `normalise` function can be used to ensure the time is represented the
  // intended way, with `nanoseconds` being positive and less than 1 second.
  Timestamp(seconds: Int, nanoseconds: Int)
}

/// Ensure the time is represented with `nanoseconds` being positive and less
/// than 1 second.
///
/// This function does not change the time that the timestamp refers to, it
/// only adjusts the values used to represent the time.
///
fn normalise(timestamp: Timestamp) -> Timestamp {
  let multiplier = 1_000_000_000
  let nanoseconds = timestamp.nanoseconds % multiplier
  let overflow = timestamp.nanoseconds - nanoseconds
  let seconds = timestamp.seconds + overflow / multiplier
  Timestamp(seconds, nanoseconds)
}

/// Compare one timestamp to another, indicating whether the first is greater or
/// smaller than the second.
///
/// # Examples
///
/// ```gleam
/// compare(from_unix_seconds(1), from_unix_seconds(2))
/// // -> order.Lt
/// ```
///
pub fn compare(left: Timestamp, right: Timestamp) -> order.Order {
  order.break_tie(
    int.compare(left.seconds, right.seconds),
    int.compare(left.nanoseconds, right.nanoseconds),
  )
}

/// Get the current system time.
///
/// Note this time is not unique or monotonic, it could change at any time or
/// even go backwards! The exact behaviour will depend on the runtime used. See
/// the module documentation for more information.
///
/// On Erlang this uses [`erlang:system_time/1`][1]. On JavaScript this uses
/// [`Date.now`][2].
///
/// [1]: https://www.erlang.org/doc/apps/erts/erlang#system_time/1
/// [2]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/now
///
pub fn system_time() -> Timestamp {
  let #(seconds, nanoseconds) = get_system_time()
  normalise(Timestamp(seconds, nanoseconds))
}

@external(erlang, "gleam_time_ffi", "system_time")
@external(javascript, "../../gleam_time_ffi.mjs", "system_time")
fn get_system_time() -> #(Int, Int)

/// Calculate the difference between two timestamps.
///
/// This is effectively substracting the first timestamp from the second.
///
/// # Examples
///
/// ```gleam
/// difference(from_unix_seconds(1), from_unix_seconds(5))
/// // -> duration.seconds(4)
/// ```
///
pub fn difference(left: Timestamp, right: Timestamp) -> Duration {
  let seconds = duration.seconds(right.seconds - left.seconds)
  let nanoseconds = duration.nanoseconds(right.nanoseconds - left.nanoseconds)
  duration.add(seconds, nanoseconds)
}

/// Add a duration to a timestamp.
///
/// # Examples
///
/// ```gleam
/// add(from_unix_seconds(1000), duration.seconds(5))
/// // -> from_unix_seconds(1005)
/// ```
///
pub fn add(timestamp: Timestamp, duration: Duration) -> Timestamp {
  let #(seconds, nanoseconds) = duration.to_seconds_and_nanoseconds(duration)
  Timestamp(timestamp.seconds + seconds, timestamp.nanoseconds + nanoseconds)
  |> normalise
}

// TODO: docs
// TODO: test
// TODO: implement
// pub fn to_rfc3339_utc_string(timestamp: Timestamp) -> String {
//   todo
// }

// TODO: docs
// TODO: test
// TODO: implement
// pub fn parse_rfc3339(input: String) -> Result(Timestamp, Nil) {
//   todo
// }

/// Create a timestamp from a number of seconds since 00:00:00 UTC on 1 January
/// 1970.
///
pub fn from_unix_seconds(seconds: Int) -> Timestamp {
  Timestamp(seconds, 0)
}

/// Create a timestamp from a number of seconds and nanoseconds since 00:00:00
/// UTC on 1 January 1970.
///
pub fn from_unix_seconds_and_nanoseconds(
  seconds seconds: Int,
  nanoseconds nanoseconds: Int,
) -> Timestamp {
  Timestamp(seconds, nanoseconds)
  |> normalise
}

/// Convert the timestamp to a number of seconds since 00:00:00 UTC on 1
/// January 1970.
///
/// There may be some small loss of precision due to `Timestamp` being
/// nanosecond accurate and `Float` not being able to represent this.
///
pub fn to_unix_seconds(timestamp: Timestamp) -> Float {
  let seconds = int.to_float(timestamp.seconds)
  let nanoseconds = int.to_float(timestamp.nanoseconds)
  seconds +. { nanoseconds /. 1_000_000_000.0 }
}

/// Convert the timestamp to a number of seconds and nanoseconds since 00:00:00
/// UTC on 1 January 1970. There is no loss of precision with this conversion
/// on any target.
pub fn to_unix_seconds_and_nanoseconds(timestamp: Timestamp) -> #(Int, Int) {
  #(timestamp.seconds, timestamp.nanoseconds)
}
