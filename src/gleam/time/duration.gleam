import gleam/order

// TODO: document
pub type Duration {
  Duration(seconds: Int, nanoseconds: Int)
}

// TODO: test
/// Ensure the duration is represented with `nanoseconds` being positive and
/// less than 1 second.
///
/// This function does not change the amount of time that the duratoin refers
/// to, it only adjusts the values used to represent the time.
///
pub fn normalise(duration: Duration) -> Duration {
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
