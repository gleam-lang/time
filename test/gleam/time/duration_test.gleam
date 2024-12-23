import gleam/order
import gleam/time/duration
import gleeunit/should

pub fn add_0_test() {
  duration.nanoseconds(500_000_000)
  |> duration.add(duration.nanoseconds(500_000_000))
  |> should.equal(duration.seconds(1))
}

pub fn add_1_test() {
  duration.nanoseconds(-500_000_000)
  |> duration.add(duration.nanoseconds(-500_000_000))
  |> should.equal(duration.seconds(-1))
}

pub fn add_2_test() {
  duration.nanoseconds(-500_000_000)
  |> duration.add(duration.nanoseconds(500_000_000))
  |> should.equal(duration.seconds(0))
}

pub fn add_3_test() {
  duration.seconds(4)
  |> duration.add(duration.nanoseconds(4_000_000_000))
  |> should.equal(duration.seconds(8))
}

pub fn add_4_test() {
  duration.seconds(4)
  |> duration.add(duration.nanoseconds(-5_000_000_000))
  |> should.equal(duration.seconds(-1))
}

pub fn add_5_test() {
  duration.nanoseconds(4_000_000)
  |> duration.add(duration.milliseconds(4))
  |> should.equal(duration.milliseconds(8))
}

pub fn to_seconds_0_test() {
  duration.seconds(1)
  |> duration.to_seconds
  |> should.equal(1.0)
}

pub fn to_seconds_1_test() {
  duration.seconds(2)
  |> duration.to_seconds
  |> should.equal(2.0)
}

pub fn to_seconds_2_test() {
  duration.milliseconds(500)
  |> duration.to_seconds
  |> should.equal(0.5)
}

pub fn to_seconds_3_test() {
  duration.milliseconds(5100)
  |> duration.to_seconds
  |> should.equal(5.1)
}

pub fn to_seconds_4_test() {
  duration.nanoseconds(500)
  |> duration.to_seconds
  |> should.equal(0.0000005)
}

pub fn compare_0_test() {
  duration.compare(duration.seconds(1), duration.seconds(1))
  |> should.equal(order.Eq)
}

pub fn compare_1_test() {
  duration.compare(duration.seconds(2), duration.seconds(1))
  |> should.equal(order.Gt)
}

pub fn compare_2_test() {
  duration.compare(duration.seconds(0), duration.seconds(1))
  |> should.equal(order.Lt)
}

pub fn compare_3_test() {
  duration.compare(duration.nanoseconds(999_999_999), duration.seconds(1))
  |> should.equal(order.Lt)
}

pub fn compare_4_test() {
  duration.compare(duration.nanoseconds(1_000_000_001), duration.seconds(1))
  |> should.equal(order.Gt)
}

pub fn compare_5_test() {
  duration.compare(duration.nanoseconds(1_000_000_000), duration.seconds(1))
  |> should.equal(order.Eq)
}

pub fn to_iso8601_string_0_test() {
  duration.seconds(42)
  |> duration.to_iso8601_string
  |> should.equal("PT42S")
}

pub fn to_iso8601_string_1_test() {
  duration.seconds(60)
  |> duration.to_iso8601_string
  |> should.equal("PT1M")
}

pub fn to_iso8601_string_2_test() {
  duration.seconds(362)
  |> duration.to_iso8601_string
  |> should.equal("PT6M2S")
}

pub fn to_iso8601_string_3_test() {
  duration.seconds(60 * 60)
  |> duration.to_iso8601_string
  |> should.equal("PT1H")
}

pub fn to_iso8601_string_4_test() {
  duration.seconds(60 * 60 * 24)
  |> duration.to_iso8601_string
  |> should.equal("P1DT")
}

pub fn to_iso8601_string_5_test() {
  duration.seconds(60 * 60 * 24 * 50)
  |> duration.to_iso8601_string
  |> should.equal("P50DT")
}

pub fn to_iso8601_string_6_test() {
  // We don't use years because you can't tell how long a year is in seconds
  // without context. _Which_ year? They have different lengths.
  duration.seconds(60 * 60 * 24 * 365)
  |> duration.to_iso8601_string
  |> should.equal("P365DT")
}

pub fn to_iso8601_string_7_test() {
  let year = 60 * 60 * 24 * 365
  let hour = 60 * 60
  duration.seconds(year + hour * 3 + 66)
  |> duration.to_iso8601_string
  |> should.equal("P365DT3H1M6S")
}

pub fn to_iso8601_string_8_test() {
  duration.milliseconds(1000)
  |> duration.to_iso8601_string
  |> should.equal("PT1S")
}

pub fn to_iso8601_string_9_test() {
  duration.milliseconds(100)
  |> duration.to_iso8601_string
  |> should.equal("PT0.1S")
}

pub fn to_iso8601_string_10_test() {
  duration.milliseconds(10)
  |> duration.to_iso8601_string
  |> should.equal("PT0.01S")
}

pub fn to_iso8601_string_11_test() {
  duration.milliseconds(1)
  |> duration.to_iso8601_string
  |> should.equal("PT0.001S")
}

pub fn to_iso8601_string_12_test() {
  duration.nanoseconds(1_000_000)
  |> duration.to_iso8601_string
  |> should.equal("PT0.001S")
}

pub fn to_iso8601_string_13_test() {
  duration.nanoseconds(100_000)
  |> duration.to_iso8601_string
  |> should.equal("PT0.0001S")
}

pub fn to_iso8601_string_14_test() {
  duration.nanoseconds(10_000)
  |> duration.to_iso8601_string
  |> should.equal("PT0.00001S")
}

pub fn to_iso8601_string_15_test() {
  duration.nanoseconds(1000)
  |> duration.to_iso8601_string
  |> should.equal("PT0.000001S")
}

pub fn to_iso8601_string_16_test() {
  duration.nanoseconds(100)
  |> duration.to_iso8601_string
  |> should.equal("PT0.0000001S")
}

pub fn to_iso8601_string_17_test() {
  duration.nanoseconds(10)
  |> duration.to_iso8601_string
  |> should.equal("PT0.00000001S")
}

pub fn to_iso8601_string_18_test() {
  duration.nanoseconds(1)
  |> duration.to_iso8601_string
  |> should.equal("PT0.000000001S")
}

pub fn to_iso8601_string_19_test() {
  duration.nanoseconds(123_456_789)
  |> duration.to_iso8601_string
  |> should.equal("PT0.123456789S")
}
