import gleam/int
import gleam/option
import gleam/regexp
import gleam/string
import gleam/time/timestamp
import qcheck

/// Generate timestamps representing instants in the range `0000-01-01T00:00:00Z`
/// to `9999-12-31T23:59:59.999999999Z`.
///
pub fn timestamp() {
  // prng can only generate good integers in the range
  // [-2_147_483_648, 2_147_483_647]
  //
  // So we must get to the range we need by generating the values in parts, then
  // adding them together.
  //
  // The smallest number of milliseconds we need to generate:
  // > d=new Date("0000-01-01T00:00:00"); d.getTime()
  // -62_167_201_438_000 ms
  //     -62_167_201_438 s
  //
  // The largest number of milliseconds without leap second we need to generate:
  // > d=new Date("9999-12-31T23:59:59"); d.getTime()
  // 253_402_318_799_000 ms
  //     253_402_318_799 s
  //

  let megasecond_generator = {
    use second <- qcheck.map(qcheck.bounded_int(-62_167, 253_402))
    second * 1_000_000
  }

  let second_generator = qcheck.bounded_int(-201_438, 318_799)

  use megasecond, second, nanosecond <- qcheck.map3(
    megasecond_generator,
    second_generator,
    qcheck.bounded_int(0, 999_999_999),
  )
  let total_seconds = megasecond + second

  let assert True =
    -62_167_201_438 <= total_seconds && total_seconds <= 253_402_318_799

  timestamp.from_unix_seconds_and_nanoseconds(total_seconds, nanosecond)
}

pub fn rfc3339(
  with_leap_second with_leap_second: Bool,
  second_fraction_spec second_fraction_spec: SecondFractionSpec,
  avoid_erlang_errors avoid_erlang_errors: Bool,
) -> qcheck.Generator(String) {
  use full_date, t, full_time <- qcheck.map3(
    full_date_generator(),
    t_generator(),
    full_time_generator(with_leap_second, second_fraction_spec),
  )
  let date_time = full_date <> t <> full_time

  // There are valid timestamps that the Erlang oracle will fail to parse, but
  // that timestamp.parse_rfc3339 and the JS oracle correctly parse.  E.g.,
  // "0000-01-01T00:00:00+00:01" and greater offsets, or with
  // 9999-12-31T23:59:59-00:01 and lesser offsets.  For some of the property
  // tests, we need to account for this.
  //
  // This is a very rare occurence, but we can check it heree to avoid flaky
  // failures.
  case avoid_erlang_errors {
    True -> {
      let assert Ok(re_0000) =
        regexp.from_string(
          "(0000-[0-9]{2}-[0-9]{2}[Tt][0-9]{2}:[0-9]{2}:[0-9]{2})\\+[0-9]{2}:[0-9]{2}",
        )

      let assert Ok(re_9999) =
        regexp.from_string(
          "(9999-[0-9]{2}-[0-9]{2}[Tt][0-9]{2}:[0-9]{2}:[0-9]{2})-[0-9]{2}:[0-9]{2}",
        )

      case regexp.scan(re_0000, date_time), regexp.scan(re_9999, date_time) {
        [regexp.Match(_, submatches: [option.Some(date_time_no_offset)])], []
        | [], [regexp.Match(_, submatches: [option.Some(date_time_no_offset)])]
        -> {
          // It is one of the bad Erlang cases, so replace the offset with "Z".
          date_time_no_offset <> "Z"
        }

        _, _ -> date_time
      }
    }
    False -> date_time
  }
}

fn full_date_generator() -> qcheck.Generator(String) {
  use date_fullyear <- qcheck.bind(date_fullyear_generator())
  use date_month <- qcheck.bind(date_month_generator())
  use date_month_day <- qcheck.map(date_month_day_generator(
    year: date_fullyear,
    month: date_month,
  ))
  date_fullyear <> "-" <> date_month <> "-" <> date_month_day
}

fn date_fullyear_generator() -> qcheck.Generator(String) {
  zero_padded_digits_generator(length: 4, from: 0, to: 9999)
}

fn date_month_generator() -> qcheck.Generator(String) {
  zero_padded_digits_generator(length: 2, from: 1, to: 12)
}

fn date_month_day_generator(
  year year: String,
  month month: String,
) -> qcheck.Generator(String) {
  let is_leap_year = is_leap_year(year)

  case month {
    "01" | "03" | "05" | "07" | "08" | "10" | "12" ->
      zero_padded_digits_generator(length: 2, from: 1, to: 31)
    "04" | "06" | "09" | "11" ->
      zero_padded_digits_generator(length: 2, from: 1, to: 30)
    "02" if is_leap_year ->
      zero_padded_digits_generator(length: 2, from: 1, to: 29)
    "02" -> zero_padded_digits_generator(length: 2, from: 1, to: 28)
    _ -> panic as { "date_month_day_generator: bad month " <> month }
  }
}

// Implementation from RFC 3339 Appendix C
fn is_leap_year(year_input: String) -> Bool {
  let assert 4 = string.length(year_input)
  let assert Ok(year) = int.parse(year_input)

  let result = year % 4 == 0 && { year % 100 != 0 || year % 400 == 0 }

  result
}

fn t_generator() {
  qcheck.from_generators(qcheck.constant("T"), [qcheck.constant("t")])
}

fn full_time_generator(
  with_leap_second with_leap_second: Bool,
  second_fraction_spec second_fraction_spec: SecondFractionSpec,
) -> qcheck.Generator(String) {
  use partial_time, time_offset <- qcheck.map2(
    partial_time_generator(with_leap_second, second_fraction_spec),
    time_offset_generator(),
  )
  partial_time <> time_offset
}

fn partial_time_generator(
  with_leap_second with_leap_second: Bool,
  second_fraction_spec second_fraction_spec: SecondFractionSpec,
) -> qcheck.Generator(String) {
  qcheck.constant({
    use time_hour <- qcheck.parameter
    use time_minute <- qcheck.parameter
    use time_second <- qcheck.parameter
    use optional_time_second_fraction <- qcheck.parameter
    time_hour
    <> ":"
    <> time_minute
    <> ":"
    <> time_second
    <> unwrap_optional_string(optional_time_second_fraction)
  })
  |> qcheck.apply(time_hour_generator())
  |> qcheck.apply(time_minute_generator())
  |> qcheck.apply(time_second_generator(with_leap_second))
  |> qcheck.apply(
    qcheck.option_from(time_second_fraction_generator(second_fraction_spec)),
  )
}

fn time_hour_generator() -> qcheck.Generator(String) {
  zero_padded_digits_generator(length: 2, from: 0, to: 23)
}

fn time_minute_generator() -> qcheck.Generator(String) {
  zero_padded_digits_generator(length: 2, from: 0, to: 59)
}

fn time_second_generator(
  with_leap_second with_leap_second: Bool,
) -> qcheck.Generator(String) {
  let max_second = case with_leap_second {
    True -> 60
    False -> 59
  }
  zero_padded_digits_generator(length: 2, from: 0, to: max_second)
}

fn zero_padded_digits_generator(
  length length: Int,
  from min: Int,
  to max: Int,
) -> qcheck.Generator(String) {
  use n <- qcheck.map(qcheck.bounded_int(min, max))
  int.to_string(n) |> string.pad_start(to: length, with: "0")
}

pub type SecondFractionSpec {
  Default
  WithMaxLength(Int)
}

fn time_second_fraction_generator(
  second_fraction_spec: SecondFractionSpec,
) -> qcheck.Generator(String) {
  let generator = case second_fraction_spec {
    Default -> one_or_more_digits_generator()
    WithMaxLength(max_count) -> digits_generator(min_count: 1, max_count:)
  }

  use digits <- qcheck.map(generator)
  "." <> digits
}

fn one_or_more_digits_generator() -> qcheck.Generator(String) {
  qcheck.non_empty_string_from(qcheck.ascii_digit_codepoint())
}

fn digits_generator(
  min_count min_count: Int,
  max_count max_count: Int,
) -> qcheck.Generator(String) {
  qcheck.generic_string(
    qcheck.ascii_digit_codepoint(),
    qcheck.bounded_int(min_count, max_count),
  )
}

fn time_offset_generator() -> qcheck.Generator(String) {
  qcheck.from_generators(z_generator(), [time_numoffset_generator()])
}

fn z_generator() {
  qcheck.from_generators(qcheck.constant("Z"), [qcheck.constant("z")])
}

fn time_numoffset_generator() -> qcheck.Generator(String) {
  use plus_or_minus, time_hour, time_minute <- qcheck.map3(
    plus_or_minus_generator(),
    time_hour_generator(),
    time_minute_generator(),
  )

  plus_or_minus <> time_hour <> ":" <> time_minute
}

fn plus_or_minus_generator() -> qcheck.Generator(String) {
  qcheck.from_generators(qcheck.constant("+"), [qcheck.constant("-")])
}

fn unwrap_optional_string(optional_string: option.Option(String)) -> String {
  case optional_string {
    option.None -> ""
    option.Some(string) -> string
  }
}
