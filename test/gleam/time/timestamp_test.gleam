import gleam/int
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/rfc3339_generator
import gleam/time/timestamp
import gleeunit/should
import qcheck
import simplifile

pub fn compare_property_0_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.int_uniform(),
    qcheck.int_uniform(),
  ))
  let tx = timestamp.from_unix_seconds(x)
  let ty = timestamp.from_unix_seconds(y)
  timestamp.compare(tx, ty) == int.compare(x, y)
}

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

pub fn add_property_0_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.int_uniform(),
    qcheck.int_uniform(),
  ))
  let expected = timestamp.from_unix_seconds_and_nanoseconds(0, x + y)
  let actual =
    timestamp.from_unix_seconds_and_nanoseconds(0, x)
    |> timestamp.add(duration.nanoseconds(y))
  expected == actual
}

pub fn add_property_1_test() {
  use #(x, y) <- qcheck.given(qcheck.tuple2(
    qcheck.int_uniform(),
    qcheck.int_uniform(),
  ))
  let expected = timestamp.from_unix_seconds_and_nanoseconds(x + y, 0)
  let actual =
    timestamp.from_unix_seconds_and_nanoseconds(x, 0)
    |> timestamp.add(duration.seconds(y))
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

pub fn to_rfc3339_9_test() {
  timestamp.from_unix_seconds(-62_167_219_200)
  |> timestamp.to_rfc3339(0)
  |> should.equal("0000-01-01T00:00:00Z")
}

pub fn to_rfc3339_10_test() {
  timestamp.from_unix_seconds(-62_135_596_800)
  |> timestamp.to_rfc3339(0)
  |> should.equal("0001-01-01T00:00:00Z")
}

pub fn to_rfc3339_11_test() {
  timestamp.from_unix_seconds(-61_851_600_000)
  |> timestamp.to_rfc3339(0)
  |> should.equal("0010-01-01T00:00:00Z")
}

pub fn to_rfc3339_12_test() {
  timestamp.from_unix_seconds(-59_011_459_200)
  |> timestamp.to_rfc3339(0)
  |> should.equal("0100-01-01T00:00:00Z")
}

// RFC 3339 Parsing

pub fn parse_rfc3339_0_test() {
  let assert Ok(timestamp) = timestamp.parse_rfc3339("1970-01-01T00:00:00.6Z")

  timestamp
  |> timestamp.to_unix_seconds_and_nanoseconds
  |> should.equal(#(0, 600_000_000))
}

pub fn parse_rfc3339_1_test() {
  let assert Ok(timestamp) = timestamp.parse_rfc3339("1969-12-31T23:59:59.6Z")

  timestamp
  |> timestamp.to_unix_seconds_and_nanoseconds
  |> should.equal(#(-1, 600_000_000))
}

pub fn parse_rfc3339_2_test() {
  let assert Ok(timestamp) =
    timestamp.parse_rfc3339("1970-01-01t00:00:00.55+00:01")

  timestamp
  |> timestamp.to_unix_seconds_and_nanoseconds
  |> should.equal(#(-60, 550_000_000))
}

pub fn parse_rfc3339_3_test() {
  let assert Ok(timestamp) =
    timestamp.parse_rfc3339("1970-01-01T00:00:00.55-00:01")

  timestamp
  |> timestamp.to_unix_seconds_and_nanoseconds
  |> should.equal(#(60, 550_000_000))
}

pub fn timestamp_rfc3339_timestamp_roundtrip_property_test() {
  use timestamp <- qcheck.given(
    rfc3339_generator.timestamp_with_zero_nanoseconds_generator(),
  )

  let assert Ok(parsed_timestamp) =
    timestamp
    |> timestamp.to_rfc3339(0)
    |> timestamp.parse_rfc3339

  timestamp.compare(timestamp, parsed_timestamp) == order.Eq
}

pub fn rfc3339_string_timestamp_rfc3339_string_round_tripping_test() {
  use timestamp <- qcheck.given(
    // TODO: switch to generator with nanoseconds once to_rfc3339 handles
    // fractional seconds.
    rfc3339_generator.timestamp_with_zero_nanoseconds_generator(),
  )
  let assert Ok(parsed_timestamp) =
    timestamp.to_rfc3339(timestamp, 0) |> timestamp.parse_rfc3339()

  timestamp == parsed_timestamp
}

// Check against OCaml Ptime reference implementation.
//
// These test cases include leap seconds.
pub fn parse_rfc3339_examples_from_file_test() {
  let assert Ok(data) = simplifile.read("test/gleam/time/timestamps_parsed.tsv")
  data
  |> string.split(on: "\n")
  |> list.drop(1)
  |> list.each(fn(line) {
    case string.split(line, on: "\t") {
      [ts, seconds, nanos, _, _] -> {
        let assert Ok(expected_seconds) = int.parse(seconds)
        let assert Ok(expected_nanos) = int.parse(nanos)

        let assert Ok(parsed_ts) = timestamp.parse_rfc3339(ts)
        let #(parsed_seconds, parsed_nanos) =
          timestamp.to_unix_seconds_and_nanoseconds(parsed_ts)

        should.equal(expected_seconds, parsed_seconds)
        should.equal(expected_nanos, parsed_nanos)
      }
      // No more to parse.
      [""] -> Nil
      _ -> panic as "bad input line"
    }
  })
}

@external(erlang, "gleam_time_test_ffi", "rfc3339_to_system_time_in_milliseconds")
@external(javascript, "../../gleam_time_test_ffi.mjs", "rfc3339_to_system_time_in_milliseconds")
fn rfc3339_to_system_time_in_milliseconds(input: String) -> Result(Int, Nil)

// WARNING: This can give different values on Erlang and JS targets if you pass
// in a timestamp that has more than 3 fractional digits.  Erlang will give you
// nanosecond precision, but will round to nearest nanosecond.  JavaScript will
// give you millisecond precision and trucate to the nearest millisecond.  So,
// the caller must ensure good values are passed in.
fn parse_rfc3339_oracle(input: String) -> Result(timestamp.Timestamp, Nil) {
  use total_milliseconds <- result.map(rfc3339_to_system_time_in_milliseconds(
    input,
  ))
  // Break out the millisecond fraction first so that the conversion to
  // nanoseconds doesn't overflow for JS in the normalise function.
  let millisecond_fraction = total_milliseconds % 1000
  let whole_seconds = { total_milliseconds - millisecond_fraction } / 1000
  timestamp.from_unix_seconds_and_nanoseconds(
    seconds: whole_seconds,
    nanoseconds: millisecond_fraction * 1_000_000,
  )
}

pub fn parse_rfc3339_matches_oracle_example_0_test() {
  let date_time = "9999-12-31T23:59:59.999Z"

  should.equal(
    timestamp.parse_rfc3339(date_time),
    parse_rfc3339_oracle(date_time),
  )
}

pub fn parse_rfc3339_matches_oracle_example_1_test() {
  let date_time = "1970-01-01T00:00:00.111Z"

  should.equal(
    timestamp.parse_rfc3339(date_time),
    parse_rfc3339_oracle(date_time),
  )
}

pub fn parse_rfc3339_matches_oracle_example_2_test() {
  let date_time = "1970-01-01T00:00:00.000Z"

  should.equal(
    timestamp.parse_rfc3339(date_time),
    parse_rfc3339_oracle(date_time),
  )
}

pub fn parse_rfc3339_matches_oracle_example_3_test() {
  let date_time = "1969-12-31T23:59:59.444Z"

  should.equal(
    timestamp.parse_rfc3339(date_time),
    parse_rfc3339_oracle(date_time),
  )
}

pub fn parse_rfc3339_matches_oracle_example_4_test() {
  let date_time = "1969-12-31T23:59:58.666Z"

  should.equal(
    timestamp.parse_rfc3339(date_time),
    parse_rfc3339_oracle(date_time),
  )
}

pub fn parse_rfc3339_matches_oracle_example_5_test() {
  let date_time = "0000-01-01T00:00:00Z"

  should.equal(
    timestamp.parse_rfc3339(date_time),
    parse_rfc3339_oracle(date_time),
  )
}

// The oracle gives badarg on Erlang as it is beyond the range of the
// 0000-01-01T00:00:00Z limit.
@target(javascript)
pub fn parse_rfc3339_matches_oracle_example_6_test() {
  let date_time = "0000-01-01T00:00:00+00:01"

  should.equal(
    timestamp.parse_rfc3339(date_time),
    parse_rfc3339_oracle(date_time),
  )
}

pub fn parse_rfc3339_matches_oracle_example_7_test() {
  let date_time = "0000-01-01T00:00:00-00:01"

  should.equal(
    timestamp.parse_rfc3339(date_time),
    parse_rfc3339_oracle(date_time),
  )
}

pub fn parse_rfc3339_matches_oracle_example_8_test() {
  let date_time = "9999-12-31T23:59:59.999+00:01"

  should.equal(
    timestamp.parse_rfc3339(date_time),
    parse_rfc3339_oracle(date_time),
  )
}

// This oracle gives badarg on Erlang as it is beyond the range of the
// 9999-12-31T23:59:59.999Z limit.
@target(javascript)
pub fn parse_rfc3339_matches_oracle_example_9_test() {
  let date_time = "9999-12-31T23:59:59.999-00:01"

  should.equal(
    timestamp.parse_rfc3339(date_time),
    parse_rfc3339_oracle(date_time),
  )
}

// JS returns NaN for any leap seconds, so skip this test in JS.
@target(erlang)
pub fn parse_rfc3339_matches_oracle_example_10_test() {
  let date_time = "1970-01-01T23:59:60Z"

  should.equal(
    timestamp.parse_rfc3339(date_time),
    parse_rfc3339_oracle(date_time),
  )
}

pub fn parse_rfc3339_matches_oracle_property_test() {
  use date_time <- qcheck.given(rfc3339_generator.date_time_generator(
    // JavaScript oracle cannot handle leap-seconds.
    with_leap_second: False,
    // JavaScript oracle has max precision of milliseconds.
    second_fraction_spec: rfc3339_generator.WithMaxLength(3),
    // Some valid timestamps cannot be parsed by the Erlang oracle.
    avoid_erlang_errors: True,
  ))

  timestamp.parse_rfc3339(date_time) == parse_rfc3339_oracle(date_time)
}

pub fn parse_rfc3339_succeeds_for_valid_inputs_property_test() {
  use date_time <- qcheck.given_result(rfc3339_generator.date_time_generator(
    with_leap_second: True,
    second_fraction_spec: rfc3339_generator.Default,
    avoid_erlang_errors: False,
  ))
  timestamp.parse_rfc3339(date_time)
}

pub fn parse_rfc3339_fails_for_invalid_inputs_test() {
  // The chance of randomly generating a valid RFC 3339 string is quite low....
  use string <- qcheck.given_result(qcheck.string())
  case timestamp.parse_rfc3339(string) {
    Error(Nil) -> Ok(Nil)
    Ok(x) -> Error(x)
  }
}

pub fn parse_rfc3339_bad_leapyear_test() {
  // 29 days in February in a non-leap year is an error.
  timestamp.parse_rfc3339("2023-02-29T00:00:00Z")
  |> should.equal(Error(Nil))
}

pub fn parse_rfc3339_truncates_too_many_fractional_seconds_0_test() {
  let assert Ok(ts) = timestamp.parse_rfc3339("1970-01-01T00:00:00.1234567899Z")

  let #(_, nanoseconds) = timestamp.to_unix_seconds_and_nanoseconds(ts)

  should.equal(nanoseconds, 123_456_789)
}

pub fn parse_rfc3339_truncates_too_many_fractional_seconds_1_test() {
  let assert Ok(ts) = timestamp.parse_rfc3339("1970-01-01T00:00:00.1234567891Z")

  let #(_, nanoseconds) = timestamp.to_unix_seconds_and_nanoseconds(ts)

  should.equal(nanoseconds, 123_456_789)
}

// Examples from the docs

pub fn parse_rfc3339_docs_example_0_test() {
  let assert Ok(ts) =
    timestamp.parse_rfc3339("1970-01-01T00:00:01.12345678999Z")
  timestamp.to_unix_seconds_and_nanoseconds(ts)
  |> should.equal(#(1, 123_456_789))
}

pub fn parse_rfc3339_docs_example_1_test() {
  let assert Ok(ts) = timestamp.parse_rfc3339("2025-01-10t15:54:30-05:15")
  timestamp.to_unix_seconds_and_nanoseconds(ts)
  |> should.equal(#(1_736_543_370, 0))
}

pub fn parse_rfc3339_docs_example_2_test() {
  let assert Error(Nil) = timestamp.parse_rfc3339("1995-10-31")
}

// Checking the normalising.

pub fn normalise_negative_millis_test() {
  timestamp.from_unix_seconds_and_nanoseconds(1, -1_000_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(0, 0))

  timestamp.from_unix_seconds_and_nanoseconds(1, -1_400_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(-1, 600_000_000))

  timestamp.from_unix_seconds_and_nanoseconds(1, -2_600_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(-2, 400_000_000))

  timestamp.from_unix_seconds_and_nanoseconds(0, -1_000_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(-1, 0))

  timestamp.from_unix_seconds_and_nanoseconds(0, -1_400_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(-2, 600_000_000))

  timestamp.from_unix_seconds_and_nanoseconds(0, -2_600_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(-3, 400_000_000))

  timestamp.from_unix_seconds_and_nanoseconds(-1, -1_000_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(-2, 0))

  timestamp.from_unix_seconds_and_nanoseconds(-1, -1_400_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(-3, 600_000_000))

  timestamp.from_unix_seconds_and_nanoseconds(-1, -2_600_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(-4, 400_000_000))
}

pub fn normalise_positive_millis_test() {
  timestamp.from_unix_seconds_and_nanoseconds(1, 1_000_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(2, 0))

  timestamp.from_unix_seconds_and_nanoseconds(1, 1_400_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(2, 400_000_000))

  timestamp.from_unix_seconds_and_nanoseconds(1, 2_600_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(3, 600_000_000))

  timestamp.from_unix_seconds_and_nanoseconds(0, 1_000_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(1, 0))

  timestamp.from_unix_seconds_and_nanoseconds(0, 1_400_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(1, 400_000_000))

  timestamp.from_unix_seconds_and_nanoseconds(0, 2_600_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(2, 600_000_000))

  timestamp.from_unix_seconds_and_nanoseconds(-1, 1_000_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(0, 0))

  timestamp.from_unix_seconds_and_nanoseconds(-1, 1_400_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(0, 400_000_000))

  timestamp.from_unix_seconds_and_nanoseconds(-1, 2_600_000_000)
  |> should.equal(timestamp.from_unix_seconds_and_nanoseconds(1, 600_000_000))
}
