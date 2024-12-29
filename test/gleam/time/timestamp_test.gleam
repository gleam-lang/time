import gleam/order
import gleam/time/duration
import gleam/time/timestamp
import gleeunit/should
import qcheck

pub fn compare_0_test() {
  timestamp.compare(
    timestamp.from_unix_seconds(1),
    timestamp.from_unix_seconds(1),
  )
  |> should.equal(order.Eq)
}

pub fn compare_1_test() {
  timestamp.compare(
    timestamp.from_unix_seconds(2),
    timestamp.from_unix_seconds(1),
  )
  |> should.equal(order.Gt)
}

pub fn compare_2_test() {
  timestamp.compare(
    timestamp.from_unix_seconds(2),
    timestamp.from_unix_seconds(3),
  )
  |> should.equal(order.Lt)
}

pub fn difference_0_test() {
  timestamp.difference(
    timestamp.from_unix_seconds(1),
    timestamp.from_unix_seconds(1),
  )
  |> should.equal(duration.seconds(0))
}

pub fn difference_1_test() {
  timestamp.difference(
    timestamp.from_unix_seconds(1),
    timestamp.from_unix_seconds(5),
  )
  |> should.equal(duration.seconds(4))
}

pub fn difference_2_test() {
  timestamp.difference(
    timestamp.from_unix_seconds_and_nanoseconds(1, 10),
    timestamp.from_unix_seconds_and_nanoseconds(5, 20),
  )
  |> should.equal(duration.seconds(4) |> duration.add(duration.nanoseconds(10)))
}

pub fn add_property_test() {
  use #(x, y) <- qcheck.given(qcheck.map2(
    fn(x, y) { #(x, y) },
    qcheck.int_uniform(),
    qcheck.int_uniform(),
  ))
  let expected = timestamp.from_unix_seconds_and_nanoseconds(0, x + y)
  let actual =
    timestamp.from_unix_seconds_and_nanoseconds(0, x)
    |> timestamp.add(duration.nanoseconds(y))
  expected == actual
}

pub fn add_0_test() {
  timestamp.from_unix_seconds(0)
  |> timestamp.add(duration.seconds(1))
  |> should.equal(timestamp.from_unix_seconds(1))
}

pub fn add_1_test() {
  timestamp.from_unix_seconds(100)
  |> timestamp.add(duration.seconds(-1))
  |> should.equal(timestamp.from_unix_seconds(99))
}

pub fn add_2_test() {
  timestamp.from_unix_seconds(99)
  |> timestamp.add(duration.nanoseconds(100))
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(99, 100))
}

pub fn add_3_test() {
  timestamp.from_unix_seconds_and_nanoseconds(0, -1)
  |> timestamp.add(duration.nanoseconds(-1_000_000_000))
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(0, -1_000_000_001))
}

pub fn add_4_test() {
  timestamp.from_unix_seconds_and_nanoseconds(0, 1)
  |> timestamp.add(duration.nanoseconds(-1_000_000_000))
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(0, -999_999_999))
}

pub fn to_unix_seconds_0_test() {
  timestamp.from_unix_seconds_and_nanoseconds(1, 0)
  |> timestamp.to_unix_seconds
  |> should.equal(1.0)
}

pub fn to_unix_seconds_1_test() {
  timestamp.from_unix_seconds_and_nanoseconds(1, 500_000_000)
  |> timestamp.to_unix_seconds
  |> should.equal(1.5)
}

pub fn to_unix_seconds_and_nanoseconds_0_test() {
  timestamp.from_unix_seconds_and_nanoseconds(1, 0)
  |> timestamp.to_unix_seconds_and_nanoseconds
  |> should.equal(#(1, 0))
}

pub fn to_unix_seconds_and_nanoseconds_1_test() {
  timestamp.from_unix_seconds_and_nanoseconds(1, 2)
  |> timestamp.to_unix_seconds_and_nanoseconds
  |> should.equal(#(1, 2))
}

pub fn system_time_0_test() {
  let #(now, _) =
    timestamp.system_time() |> timestamp.to_unix_seconds_and_nanoseconds

  // This test will start to fail once enough time has passed.
  // When that happens please update these values.
  let when_this_test_was_last_updated = 1_735_307_287
  let christmas_day_2025 = 1_766_620_800

  let assert True = now > when_this_test_was_last_updated
  let assert True = now < christmas_day_2025
}

pub fn to_rfc3339_0_test() {
  timestamp.from_unix_seconds(1_735_309_467)
  |> timestamp.to_rfc3339(0)
  |> should.equal("2024-12-27T14:24:27Z")
}

pub fn to_rfc3339_1_test() {
  timestamp.from_unix_seconds(1)
  |> timestamp.to_rfc3339(0)
  |> should.equal("1970-01-01T00:00:01Z")
}

pub fn to_rfc3339_2_test() {
  timestamp.from_unix_seconds(0)
  |> timestamp.to_rfc3339(0)
  |> should.equal("1970-01-01T00:00:00Z")
}

pub fn to_rfc3339_3_test() {
  timestamp.from_unix_seconds(123_456_789)
  |> timestamp.to_rfc3339(0)
  |> should.equal("1973-11-29T21:33:09Z")
}

pub fn to_rfc3339_4_test() {
  timestamp.from_unix_seconds(31_560_000)
  |> timestamp.to_rfc3339(0)
  |> should.equal("1971-01-01T06:40:00Z")
}

pub fn to_rfc3339_5_test() {
  timestamp.from_unix_seconds(-12_345_678)
  |> timestamp.to_rfc3339(0)
  |> should.equal("1969-08-11T02:38:42Z")
}

pub fn to_rfc3339_6_test() {
  timestamp.from_unix_seconds(-1)
  |> timestamp.to_rfc3339(0)
  |> should.equal("1969-12-31T23:59:59Z")
}

pub fn to_rfc3339_7_test() {
  timestamp.from_unix_seconds(60 * 60 + 60 * 5)
  |> timestamp.to_rfc3339(65)
  |> should.equal("1970-01-01T00:00:00+01:05")
}

pub fn to_rfc3339_8_test() {
  timestamp.from_unix_seconds(0)
  |> timestamp.to_rfc3339(-120)
  |> should.equal("1970-01-01T02:00:00-02:00")
}
