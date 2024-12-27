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

// TODO: test
/// Ensure the time is represented with `nanoseconds` being positive and less
/// than 1 second.
///
/// This function does not change the time that the timestamp refers to, it
/// only adjusts the values used to represent the time.
///
fn normalise(timestamp: Timestamp) -> Timestamp {
  todo
}

// TODO: docs
// TODO: test
pub fn compare(left: Timestamp, right: Timestamp) -> order.Order {
  todo
}

// TODO: docs
// TODO: test
pub fn system_time() -> Timestamp {
  todo
}

// TODO: docs
// TODO: test
pub fn difference(left: Timestamp, right: Timestamp) -> Duration {
  todo
}

// TODO: docs
// TODO: test
pub fn add(timetamp: Timestamp, duration: Duration) -> Duration {
  todo
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

// TODO: docs
// TODO: test
pub fn from_unix_seconds(seconds: Int) -> Timestamp {
  todo
}

// TODO: docs
// TODO: test
pub fn from_unix_seconds_and_nanoseconds(
  seconds seconds: Int,
  nanoseconds nanoseconds: Int,
) -> Timestamp {
  todo
}

// TODO: docs
// TODO: test
pub fn to_unix_seconds(input: String) -> Float {
  todo
}

// TODO: docs
// TODO: test
pub fn to_unix_seconds_and_nanoseconds(input: String) -> #(Int, Int) {
  todo
}
