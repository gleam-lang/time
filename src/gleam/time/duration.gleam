import gleam/order

// TODO: document
pub opaque type Duration {
  // When compiling to JavaScript ints have limited precision and size. This
  // means that if we were to store the the timestamp in a single int the
  // duration would not be able to represent very large or small durations.
  // Durations are instead represented as a number of seconds and a number of
  // nanoseconds.
  //
  // If you have manually adjusted the seconds and nanoseconds values the
  // `normalise` function can be used to ensure the time is represented the
  // intended way, with `nanoseconds` being positive and less than 1 second.
  Duration(seconds: Int, nanoseconds: Int)
}

// TODO: test
/// Ensure the duration is represented with `nanoseconds` being positive and
/// less than 1 second.
///
/// This function does not change the amount of time that the duratoin refers
/// to, it only adjusts the values used to represent the time.
///
fn normalise(duration: Duration) -> Duration {
  todo
}

// TODO: docs
// TODO: test
pub fn compare(left: Duration, right: Duration) -> order.Order {
  todo
}

// TODO: docs
// TODO: test
pub fn difference(left: Duration, right: Duration) -> Duration {
  todo
}

// TODO: docs
// TODO: test
pub fn add(left: Duration, right: Duration) -> Duration {
  todo
}

// TODO: docs
// TODO: test
pub fn to_iso8601_string(duration: Duration) -> String {
  todo
}

// TODO: docs
// TODO: test
pub fn minutes(amount: Int) -> Duration {
  todo
}

// TODO: docs
// TODO: test
pub fn seconds(amount: Int) -> Duration {
  todo
}

// TODO: docs
// TODO: test
pub fn milliseconds(amount: Int) -> Duration {
  todo
}
