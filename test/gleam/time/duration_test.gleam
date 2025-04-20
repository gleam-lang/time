import gleam/int
import gleam/order
import gleam/time/duration
import gleeunit/should
import qcheck

pub fn add_property_0_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.uniform_int(),
    qcheck.uniform_int(),
  ))
  let expected = duration.nanoseconds(x + y)
  let actual = duration.nanoseconds(x) |> duration.add(duration.nanoseconds(y))
  should.equal(expected, actual)
}

pub fn add_property_1_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.uniform_int(),
    qcheck.uniform_int(),
  ))
  let expected = duration.seconds(x + y)
  let actual = duration.seconds(x) |> duration.add(duration.seconds(y))
  should.equal(expected, actual)
}

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

pub fn add_6_test() {
  duration.nanoseconds(-2)
  |> duration.add(duration.nanoseconds(-3))
  |> should.equal(duration.nanoseconds(-5))
}

pub fn add_7_test() {
  duration.nanoseconds(-1)
  |> duration.add(duration.nanoseconds(-1_000_000_000))
  |> should.equal(duration.nanoseconds(-1_000_000_001))
}

pub fn add_8_test() {
  duration.nanoseconds(1)
  |> duration.add(duration.nanoseconds(-1_000_000_000))
  |> should.equal(duration.nanoseconds(-999_999_999))
}

pub fn to_seconds_and_nanoseconds_0_test() {
  duration.seconds(1)
  |> duration.to_seconds_and_nanoseconds()
  |> should.equal(#(1, 0))
}

pub fn to_seconds_and_nanoseconds_1_test() {
  duration.milliseconds(1)
  |> duration.to_seconds_and_nanoseconds()
  |> should.equal(#(0, 1_000_000))
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

pub fn compare_property_0_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.bounded_int(0, 999_999),
    qcheck.bounded_int(0, 999_999),
  ))
  // Durations of seconds
  let tx = duration.seconds(x)
  let ty = duration.seconds(y)
  should.equal(duration.compare(tx, ty), int.compare(x, y))
}

pub fn compare_property_1_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.bounded_int(0, 999_999),
    qcheck.bounded_int(0, 999_999),
  ))
  // Durations of nanoseconds
  let tx = duration.nanoseconds(x)
  let ty = duration.nanoseconds(y)
  should.equal(duration.compare(tx, ty), int.compare(x, y))
}

pub fn compare_property_2_test() {
  use x <- qcheck.given(qcheck.uniform_int())
  let tx = duration.nanoseconds(x)
  should.equal(duration.compare(tx, tx), order.Eq)
}

pub fn compare_property_3_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.bounded_int(0, 999_999),
    qcheck.bounded_int(0, 999_999),
  ))
  let tx = duration.nanoseconds(x)
  // It doesn't matter if a duration is positive or negative, it's the amount
  // of time spanned that matters.
  //
  // Second durations
  should.equal(
    duration.compare(tx, duration.seconds(y)),
    duration.compare(tx, duration.seconds(0 - y)),
  )
}

pub fn compare_property_4_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.bounded_int(0, 999_999),
    qcheck.bounded_int(0, 999_999),
  ))
  let tx = duration.nanoseconds(x)
  // It doesn't matter if a duration is positive or negative, it's the amount
  // of time spanned that matters.
  //
  // Nanosecond durations
  should.equal(
    duration.compare(tx, duration.nanoseconds(y)),
    duration.compare(tx, duration.nanoseconds(y * -1)),
  )
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

pub fn compare_6_test() {
  duration.compare(duration.seconds(-10), duration.seconds(-20))
  |> should.equal(order.Lt)
}

pub fn compare_7_test() {
  duration.compare(
    duration.seconds(1) |> duration.add(duration.nanoseconds(1)),
    duration.seconds(-1) |> duration.add(duration.nanoseconds(-1)),
  )
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

pub fn difference_0_test() {
  duration.difference(duration.seconds(100), duration.seconds(250))
  |> should.equal(duration.seconds(150))
}

pub fn difference_1_test() {
  duration.difference(duration.seconds(250), duration.seconds(100))
  |> should.equal(duration.seconds(-150))
}

pub fn difference_2_test() {
  duration.difference(duration.seconds(2), duration.milliseconds(3500))
  |> should.equal(duration.milliseconds(1500))
}

pub fn approximate_0_test() {
  duration.minutes(10)
  |> duration.approximate
  |> should.equal(#(10, duration.Minute))
}

pub fn approximate_1_test() {
  duration.seconds(30)
  |> duration.approximate
  |> should.equal(#(30, duration.Second))
}

pub fn approximate_2_test() {
  duration.hours(23)
  |> duration.approximate
  |> should.equal(#(23, duration.Hour))
}

pub fn approximate_3_test() {
  duration.hours(24)
  |> duration.approximate
  |> should.equal(#(1, duration.Day))
}

pub fn approximate_4_test() {
  duration.hours(48)
  |> duration.approximate
  |> should.equal(#(2, duration.Day))
}

pub fn approximate_5_test() {
  duration.hours(47)
  |> duration.approximate
  |> should.equal(#(1, duration.Day))
}

pub fn approximate_6_test() {
  duration.hours(24 * 7)
  |> duration.approximate
  |> should.equal(#(1, duration.Week))
}

pub fn approximate_7_test() {
  duration.hours(24 * 30)
  |> duration.approximate
  |> should.equal(#(4, duration.Week))
}

pub fn approximate_8_test() {
  duration.hours(24 * 31)
  |> duration.approximate
  |> should.equal(#(1, duration.Month))
}

pub fn approximate_9_test() {
  duration.hours(24 * 66)
  |> duration.approximate
  |> should.equal(#(2, duration.Month))
}

pub fn approximate_10_test() {
  duration.hours(24 * 365)
  |> duration.approximate
  |> should.equal(#(11, duration.Month))
}

pub fn approximate_11_test() {
  duration.hours(24 * 365 + 5)
  |> duration.approximate
  |> should.equal(#(11, duration.Month))
}

pub fn approximate_12_test() {
  duration.hours(24 * 365 + 6)
  |> duration.approximate
  |> should.equal(#(1, duration.Year))
}

pub fn approximate_13_test() {
  duration.hours(5 * 24 * 365 + 6)
  |> duration.approximate
  |> should.equal(#(4, duration.Year))
}

pub fn approximate_14_test() {
  duration.hours(-5 * 24 * 365 + 6)
  |> duration.approximate
  |> should.equal(#(-4, duration.Year))
}

pub fn approximate_15_test() {
  duration.milliseconds(1)
  |> duration.approximate
  |> should.equal(#(1, duration.Millisecond))
}

pub fn approximate_16_test() {
  duration.milliseconds(-1)
  |> duration.approximate
  |> should.equal(#(-1, duration.Millisecond))
}

pub fn approximate_17_test() {
  duration.milliseconds(999)
  |> duration.approximate
  |> should.equal(#(999, duration.Millisecond))
}

pub fn approximate_18_test() {
  duration.nanoseconds(1000)
  |> duration.approximate
  |> should.equal(#(1, duration.Microsecond))
}

pub fn approximate_19_test() {
  duration.nanoseconds(-1000)
  |> duration.approximate
  |> should.equal(#(-1, duration.Microsecond))
}

pub fn approximate_20_test() {
  duration.nanoseconds(23_000)
  |> duration.approximate
  |> should.equal(#(23, duration.Microsecond))
}

pub fn approximate_21_test() {
  duration.nanoseconds(999)
  |> duration.approximate
  |> should.equal(#(999, duration.Nanosecond))
}

pub fn approximate_22_test() {
  duration.nanoseconds(-999)
  |> duration.approximate
  |> should.equal(#(-999, duration.Nanosecond))
}

pub fn approximate_23_test() {
  duration.nanoseconds(0)
  |> duration.approximate
  |> should.equal(#(0, duration.Nanosecond))
}
