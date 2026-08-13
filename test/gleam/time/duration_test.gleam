import gleam/int
import gleam/order
import gleam/time/duration
import qcheck

pub fn add_property_0_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.uniform_int(),
    qcheck.uniform_int(),
  ))
  let expected = duration.nanoseconds(x + y)
  let actual = duration.nanoseconds(x) |> duration.add(duration.nanoseconds(y))
  assert expected == actual
}

pub fn add_property_1_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.uniform_int(),
    qcheck.uniform_int(),
  ))
  let expected = duration.seconds(x + y)
  let actual = duration.seconds(x) |> duration.add(duration.seconds(y))
  assert expected == actual
}

pub fn add_0_test() {
  assert duration.add(
      duration.nanoseconds(500_000_000),
      duration.nanoseconds(500_000_000),
    )
    == duration.seconds(1)
}

pub fn add_1_test() {
  assert duration.add(
      duration.nanoseconds(-500_000_000),
      duration.nanoseconds(-500_000_000),
    )
    == duration.seconds(-1)
}

pub fn add_2_test() {
  assert duration.add(
      duration.nanoseconds(-500_000_000),
      duration.nanoseconds(500_000_000),
    )
    == duration.seconds(0)
}

pub fn add_3_test() {
  assert duration.add(duration.seconds(4), duration.nanoseconds(4_000_000_000))
    == duration.seconds(8)
}

pub fn add_4_test() {
  assert duration.add(duration.seconds(4), duration.nanoseconds(-5_000_000_000))
    == duration.seconds(-1)
}

pub fn add_5_test() {
  assert duration.add(duration.nanoseconds(4_000_000), duration.milliseconds(4))
    == duration.milliseconds(8)
}

pub fn add_6_test() {
  assert duration.add(duration.nanoseconds(-2), duration.nanoseconds(-3))
    == duration.nanoseconds(-5)
}

pub fn add_7_test() {
  assert duration.add(
      duration.nanoseconds(-1),
      duration.nanoseconds(-1_000_000_000),
    )
    == duration.nanoseconds(-1_000_000_001)
}

pub fn add_8_test() {
  assert duration.add(
      duration.nanoseconds(1),
      duration.nanoseconds(-1_000_000_000),
    )
    == duration.nanoseconds(-999_999_999)
}

pub fn subtract_0_test() {
  assert duration.subtract(
      duration.nanoseconds(500_000_000),
      duration.nanoseconds(500_000_000),
    )
    == duration.seconds(0)
}

pub fn subtract_1_test() {
  assert duration.subtract(
      duration.nanoseconds(-500_000_000),
      duration.nanoseconds(-500_000_000),
    )
    == duration.seconds(0)
}

pub fn subtract_2_test() {
  assert duration.subtract(
      duration.nanoseconds(-500_000_000),
      duration.nanoseconds(500_000_000),
    )
    == duration.seconds(-1)
}

pub fn subtract_3_test() {
  assert duration.subtract(
      duration.seconds(8),
      duration.nanoseconds(4_000_000_000),
    )
    == duration.seconds(4)
}

pub fn subtract_4_test() {
  assert duration.subtract(
      duration.seconds(4),
      duration.nanoseconds(5_000_000_000),
    )
    == duration.seconds(-1)
}

pub fn subtract_5_test() {
  assert duration.subtract(
      duration.nanoseconds(-4_000_000),
      duration.milliseconds(4),
    )
    == duration.milliseconds(-8)
}

pub fn subtract_6_test() {
  assert duration.subtract(duration.nanoseconds(2), duration.nanoseconds(3))
    == duration.nanoseconds(-1)
}

pub fn subtract_7_test() {
  assert duration.subtract(
      duration.nanoseconds(-1_000_000_000),
      duration.nanoseconds(1),
    )
    == duration.nanoseconds(-1_000_000_001)
}

pub fn subtract_8_test() {
  assert duration.subtract(
      duration.nanoseconds(1_000_000_000),
      duration.nanoseconds(1),
    )
    == duration.nanoseconds(999_999_999)
}

pub fn to_seconds_and_nanoseconds_0_test() {
  assert duration.to_seconds_and_nanoseconds(duration.seconds(1)) == #(1, 0)
}

pub fn to_seconds_and_nanoseconds_1_test() {
  assert duration.to_seconds_and_nanoseconds(duration.milliseconds(1))
    == #(0, 1_000_000)
}

pub fn to_milliseconds_0_test() {
  assert duration.to_milliseconds(duration.seconds(1)) == 1000
}

pub fn to_milliseconds_1_test() {
  assert duration.to_milliseconds(duration.milliseconds(500)) == 500
}

pub fn to_milliseconds_2_test() {
  assert duration.seconds(1)
    |> duration.add(duration.milliseconds(500))
    |> duration.to_milliseconds()
    == 1500
}

pub fn to_milliseconds_3_test() {
  assert duration.to_milliseconds(duration.milliseconds(-500)) == -500
}

pub fn to_milliseconds_4_test() {
  assert duration.to_milliseconds(duration.nanoseconds(1_500_000)) == 1
}

pub fn to_seconds_0_test() {
  assert duration.to_seconds(duration.seconds(1)) == 1.0
}

pub fn to_seconds_1_test() {
  assert duration.to_seconds(duration.seconds(2)) == 2.0
}

pub fn to_seconds_2_test() {
  assert duration.to_seconds(duration.milliseconds(500)) == 0.5
}

pub fn to_seconds_3_test() {
  assert duration.to_seconds(duration.milliseconds(5100)) == 5.1
}

pub fn to_seconds_4_test() {
  assert duration.to_seconds(duration.nanoseconds(500)) == 0.0000005
}

pub fn compare_property_0_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.bounded_int(0, 999_999),
    qcheck.bounded_int(0, 999_999),
  ))
  // Durations of seconds
  let tx = duration.seconds(x)
  let ty = duration.seconds(y)
  assert duration.compare(tx, ty) == int.compare(x, y)
}

pub fn compare_property_1_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.bounded_int(0, 999_999),
    qcheck.bounded_int(0, 999_999),
  ))
  // Durations of nanoseconds
  let tx = duration.nanoseconds(x)
  let ty = duration.nanoseconds(y)
  assert duration.compare(tx, ty) == int.compare(x, y)
}

pub fn compare_property_2_test() {
  use x <- qcheck.given(qcheck.uniform_int())
  let tx = duration.nanoseconds(x)
  assert duration.compare(tx, tx) == order.Eq
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
  assert duration.compare(tx, duration.seconds(y))
    == duration.compare(tx, duration.seconds(0 - y))
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
  assert duration.compare(tx, duration.nanoseconds(y))
    == duration.compare(tx, duration.nanoseconds(y * -1))
}

pub fn compare_0_test() {
  assert duration.compare(duration.seconds(1), duration.seconds(1)) == order.Eq
}

pub fn compare_1_test() {
  assert duration.compare(duration.seconds(2), duration.seconds(1)) == order.Gt
}

pub fn compare_2_test() {
  assert duration.compare(duration.seconds(0), duration.seconds(1)) == order.Lt
}

pub fn compare_3_test() {
  assert duration.compare(
      duration.nanoseconds(999_999_999),
      duration.seconds(1),
    )
    == order.Lt
}

pub fn compare_4_test() {
  assert duration.compare(
      duration.nanoseconds(1_000_000_001),
      duration.seconds(1),
    )
    == order.Gt
}

pub fn compare_5_test() {
  assert duration.compare(
      duration.nanoseconds(1_000_000_000),
      duration.seconds(1),
    )
    == order.Eq
}

pub fn compare_6_test() {
  assert duration.compare(duration.seconds(-10), duration.seconds(-20))
    == order.Lt
}

pub fn compare_7_test() {
  assert duration.compare(
      duration.seconds(1) |> duration.add(duration.nanoseconds(1)),
      duration.seconds(-1) |> duration.add(duration.nanoseconds(-1)),
    )
    == order.Eq
}

pub fn to_iso8601_string_0_nanoseconds_test() {
  assert duration.to_iso8601_string(duration.nanoseconds(0)) == "PT0S"
}

pub fn to_iso8601_string_0_milliseconds_test() {
  assert duration.to_iso8601_string(duration.milliseconds(0)) == "PT0S"
}

pub fn to_iso8601_string_0_seconds_test() {
  assert duration.to_iso8601_string(duration.seconds(0)) == "PT0S"
}

pub fn to_iso8601_string_0_minutes_test() {
  assert duration.to_iso8601_string(duration.minutes(0)) == "PT0S"
}

pub fn to_iso8601_string_0_hours_test() {
  assert duration.to_iso8601_string(duration.hours(0)) == "PT0S"
}

pub fn to_iso8601_string_0_test() {
  assert duration.to_iso8601_string(duration.seconds(42)) == "PT42S"
}

pub fn to_iso8601_string_1_test() {
  assert duration.to_iso8601_string(duration.seconds(60)) == "PT1M"
}

pub fn to_iso8601_string_2_test() {
  assert duration.to_iso8601_string(duration.seconds(362)) == "PT6M2S"
}

pub fn to_iso8601_string_3_test() {
  assert duration.to_iso8601_string(duration.seconds(60 * 60)) == "PT1H"
}

pub fn to_iso8601_string_4_test() {
  assert duration.to_iso8601_string(duration.seconds(60 * 60 * 24)) == "P1DT"
}

pub fn to_iso8601_string_5_test() {
  assert duration.to_iso8601_string(duration.seconds(60 * 60 * 24 * 50))
    == "P50DT"
}

pub fn to_iso8601_string_6_test() {
  // We don't use years because you can't tell how long a year is in seconds
  // without context. _Which_ year? They have different lengths.
  assert duration.to_iso8601_string(duration.seconds(60 * 60 * 24 * 365))
    == "P365DT"
}

pub fn to_iso8601_string_7_test() {
  let year = 60 * 60 * 24 * 365
  let hour = 60 * 60
  assert duration.to_iso8601_string(duration.seconds(year + hour * 3 + 66))
    == "P365DT3H1M6S"
}

pub fn to_iso8601_string_8_test() {
  assert duration.to_iso8601_string(duration.milliseconds(1000)) == "PT1S"
}

pub fn to_iso8601_string_9_test() {
  assert duration.to_iso8601_string(duration.milliseconds(100)) == "PT0.1S"
}

pub fn to_iso8601_string_10_test() {
  assert duration.to_iso8601_string(duration.milliseconds(10)) == "PT0.01S"
}

pub fn to_iso8601_string_11_test() {
  assert duration.to_iso8601_string(duration.milliseconds(1)) == "PT0.001S"
}

pub fn to_iso8601_string_12_test() {
  assert duration.to_iso8601_string(duration.nanoseconds(1_000_000))
    == "PT0.001S"
}

pub fn to_iso8601_string_13_test() {
  assert duration.to_iso8601_string(duration.nanoseconds(100_000))
    == "PT0.0001S"
}

pub fn to_iso8601_string_14_test() {
  assert duration.to_iso8601_string(duration.nanoseconds(10_000))
    == "PT0.00001S"
}

pub fn to_iso8601_string_15_test() {
  assert duration.to_iso8601_string(duration.nanoseconds(1000)) == "PT0.000001S"
}

pub fn to_iso8601_string_16_test() {
  assert duration.to_iso8601_string(duration.nanoseconds(100)) == "PT0.0000001S"
}

pub fn to_iso8601_string_17_test() {
  assert duration.to_iso8601_string(duration.nanoseconds(10)) == "PT0.00000001S"
}

pub fn to_iso8601_string_18_test() {
  assert duration.to_iso8601_string(duration.nanoseconds(1)) == "PT0.000000001S"
}

pub fn to_iso8601_string_19_test() {
  assert duration.to_iso8601_string(duration.nanoseconds(123_456_789))
    == "PT0.123456789S"
}

pub fn difference_0_test() {
  assert duration.difference(duration.seconds(100), duration.seconds(250))
    == duration.seconds(150)
}

pub fn difference_1_test() {
  assert duration.difference(duration.seconds(250), duration.seconds(100))
    == duration.seconds(-150)
}

pub fn difference_2_test() {
  assert duration.difference(duration.seconds(2), duration.milliseconds(3500))
    == duration.milliseconds(1500)
}

pub fn approximate_0_test() {
  assert duration.approximate(duration.minutes(10)) == #(10, duration.Minute)
}

pub fn approximate_1_test() {
  assert duration.approximate(duration.seconds(30)) == #(30, duration.Second)
}

pub fn approximate_2_test() {
  assert duration.approximate(duration.hours(23)) == #(23, duration.Hour)
}

pub fn approximate_3_test() {
  assert duration.approximate(duration.hours(24)) == #(1, duration.Day)
}

pub fn approximate_4_test() {
  assert duration.approximate(duration.hours(48)) == #(2, duration.Day)
}

pub fn approximate_5_test() {
  assert duration.approximate(duration.hours(47)) == #(1, duration.Day)
}

pub fn approximate_6_test() {
  assert duration.approximate(duration.hours(24 * 7)) == #(1, duration.Week)
}

pub fn approximate_7_test() {
  assert duration.approximate(duration.hours(24 * 30)) == #(4, duration.Week)
}

pub fn approximate_8_test() {
  assert duration.approximate(duration.hours(24 * 31)) == #(1, duration.Month)
}

pub fn approximate_9_test() {
  assert duration.approximate(duration.hours(24 * 66)) == #(2, duration.Month)
}

pub fn approximate_10_test() {
  assert duration.approximate(duration.hours(24 * 365)) == #(11, duration.Month)
}

pub fn approximate_11_test() {
  assert duration.approximate(duration.hours(24 * 365 + 5))
    == #(11, duration.Month)
}

pub fn approximate_12_test() {
  assert duration.approximate(duration.hours(24 * 365 + 6))
    == #(1, duration.Year)
}

pub fn approximate_13_test() {
  assert duration.approximate(duration.hours(5 * 24 * 365 + 6))
    == #(4, duration.Year)
}

pub fn approximate_14_test() {
  assert duration.approximate(duration.hours(-5 * 24 * 365 + 6))
    == #(-4, duration.Year)
}

pub fn approximate_15_test() {
  assert duration.approximate(duration.milliseconds(1))
    == #(1, duration.Millisecond)
}

pub fn approximate_16_test() {
  assert duration.approximate(duration.milliseconds(-1))
    == #(-1, duration.Millisecond)
}

pub fn approximate_17_test() {
  assert duration.approximate(duration.milliseconds(999))
    == #(999, duration.Millisecond)
}

pub fn approximate_18_test() {
  assert duration.approximate(duration.nanoseconds(1000))
    == #(1, duration.Microsecond)
}

pub fn approximate_19_test() {
  assert duration.approximate(duration.nanoseconds(-1000))
    == #(-1, duration.Microsecond)
}

pub fn approximate_20_test() {
  assert duration.approximate(duration.nanoseconds(23_000))
    == #(23, duration.Microsecond)
}

pub fn approximate_21_test() {
  assert duration.approximate(duration.nanoseconds(999))
    == #(999, duration.Nanosecond)
}

pub fn approximate_22_test() {
  assert duration.approximate(duration.nanoseconds(-999))
    == #(-999, duration.Nanosecond)
}

pub fn approximate_23_test() {
  assert duration.approximate(duration.nanoseconds(0))
    == #(0, duration.Nanosecond)
}
