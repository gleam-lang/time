import gleam/int
import gleam/order
import gleam/string

/// An amount of time, with up to nanosecond precision.
///
/// This type does not represent calendar periods such as "1 month" or "2
/// days". Those periods will be different lengths of time depending on which
/// month or day they apply to. For example, January is longer than February.
/// A different type should be used for calendar periods.
///
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
  //
  // The duration is the sum of the seconds and the nanoseconds.
  Duration(seconds: Int, nanoseconds: Int)
}

/// Ensure the duration is represented with `nanoseconds` being positive and
/// less than 1 second.
///
/// This function does not change the amount of time that the duratoin refers
/// to, it only adjusts the values used to represent the time.
///
fn normalise(duration: Duration) -> Duration {
  let multiplier = 1_000_000_000
  let nanoseconds = duration.nanoseconds % multiplier
  let overflow = duration.nanoseconds - nanoseconds
  let seconds = duration.seconds + overflow / multiplier
  case nanoseconds >= 0 {
    True -> Duration(seconds, nanoseconds)
    False -> Duration(seconds - 1, multiplier + nanoseconds)
  }
}

/// Compare one duration to another, indicating whether the first spans a
/// larger amount of time (and so is greater) or smaller amount of time (and so
/// is lesser) than the second.
///
/// # Examples
///
/// ```gleam
/// compare(seconds(1), seconds(2))
/// // -> order.Lt
/// ```
///
/// Whether a duration is negative or positive doesn't matter for comparing
/// them, only the amount of time spanned matters.
///
/// ```gleam
/// compare(seconds(-2), seconds(1))
/// // -> order.Gt
/// ```
///
pub fn compare(left: Duration, right: Duration) -> order.Order {
  let parts = fn(x: Duration) {
    case x.seconds >= 0 {
      True -> #(x.seconds, x.nanoseconds)
      False -> #(x.seconds * -1 - 1, 1_000_000_000 - x.nanoseconds)
    }
  }
  let #(ls, lns) = parts(left)
  let #(rs, rns) = parts(right)
  int.compare(ls, rs)
  |> order.break_tie(int.compare(lns, rns))
}

/// Calculate the difference between two durations.
///
/// This is effectively substracting the first duration from the second.
///
/// # Examples
///
/// ```gleam
/// difference(seconds(1), seconds(5))
/// // -> seconds(4)
/// ```
///
pub fn difference(left: Duration, right: Duration) -> Duration {
  Duration(right.seconds - left.seconds, right.nanoseconds - left.nanoseconds)
  |> normalise
}

/// Add two durations together.
///
/// # Examples
///
/// ```gleam
/// add(seconds(1), seconds(5))
/// // -> seconds(6)
/// ```
///
pub fn add(left: Duration, right: Duration) -> Duration {
  Duration(left.seconds + right.seconds, left.nanoseconds + right.nanoseconds)
  |> normalise
}

/// Convert the duration to an [ISO8601][1] formatted duration string.
///
/// The ISO8601 duration format is ambiguous without context due to months and
/// years having different lengths, and because of leap seconds. This function
/// encodes the duration as days, hours, and seconds without any leap seconds.
/// Be sure to take this into account when using the duration strings.
///
/// [1]: https://en.wikipedia.org/wiki/ISO_8601#Durations
///
pub fn to_iso8601_string(duration: Duration) -> String {
  let split = fn(total, limit) {
    let amount = total % limit
    let remainder = { total - amount } / limit
    #(amount, remainder)
  }
  let #(seconds, rest) = split(duration.seconds, 60)
  let #(minutes, rest) = split(rest, 60)
  let #(hours, rest) = split(rest, 24)
  let days = rest
  let add = fn(out, value, unit) {
    case value {
      0 -> out
      _ -> out <> int.to_string(value) <> unit
    }
  }
  let output =
    "P"
    |> add(days, "D")
    |> string.append("T")
    |> add(hours, "H")
    |> add(minutes, "M")
  case seconds, duration.nanoseconds {
    0, 0 -> output
    _, 0 -> output <> int.to_string(seconds) <> "S"
    _, _ -> {
      let f = nanosecond_digits(duration.nanoseconds, 0, "")
      output <> int.to_string(seconds) <> "." <> f <> "S"
    }
  }
}

fn nanosecond_digits(n: Int, position: Int, acc: String) -> String {
  case position {
    9 -> acc
    _ if acc == "" && n % 10 == 0 -> {
      nanosecond_digits(n / 10, position + 1, acc)
    }
    _ -> {
      let acc = int.to_string(n % 10) <> acc
      nanosecond_digits(n / 10, position + 1, acc)
    }
  }
}

/// Create a duration of a number of seconds.
pub fn seconds(amount: Int) -> Duration {
  Duration(amount, 0)
}

/// Create a duration of a number of milliseconds.
pub fn milliseconds(amount: Int) -> Duration {
  let remainder = amount % 1000
  let overflow = amount - remainder
  let nanoseconds = remainder * 1_000_000
  let seconds = overflow / 1000
  Duration(seconds, nanoseconds)
}

/// Create a duration of a number of nanoseconds.
///
/// # JavaScript int limitations
///
/// Remember that JavaScript can only perfectly represent ints between positive
/// and negative 9,007,199,254,740,991! If you use a single call to this
/// function to create durations larger than that number of nanoseconds then
/// you will likely not get exactly the value you expect. Use `seconds` and
/// `milliseconds` as much as possible for large durations.
///
pub fn nanoseconds(amount: Int) -> Duration {
  Duration(0, amount)
  |> normalise
}

/// Convert the duration to a number of seconds.
///
/// There may be some small loss of precision due to `Duration` being
/// nanosecond accurate and `Float` not being able to represent this.
///
pub fn to_seconds(duration: Duration) -> Float {
  let seconds = int.to_float(duration.seconds)
  let nanoseconds = int.to_float(duration.nanoseconds)
  seconds +. { nanoseconds /. 1_000_000_000.0 }
}

/// Convert the duration to a number of seconds and nanoseconds. There is no
/// loss of precision with this conversion on any target.
///
pub fn to_seconds_and_nanoseconds(duration: Duration) -> #(Int, Int) {
  #(duration.seconds, duration.nanoseconds)
}

@internal
pub const empty = Duration(0, 0)
