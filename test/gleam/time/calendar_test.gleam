import gleam/float
import gleam/order
import gleam/time/calendar
import gleam/time/duration
import gleeunit/should

pub fn local_offset_test() {
  let hours =
    float.round(duration.to_seconds(calendar.local_offset())) / 60 / 60
  should.be_true(hours > -24)
  should.be_true(hours < 24)
  should.be_true(calendar.local_offset() == calendar.local_offset())
}

pub fn utc_offset_test() {
  calendar.utc_offset
  |> should.equal(duration.seconds(0))
}

pub fn month_to_string_test() {
  calendar.April
  |> calendar.month_to_string
  |> should.equal("April")
}

pub fn is_valid_day_january_test() {
  assert calendar.is_valid_date(calendar.Date(2023, calendar.January, 31))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.January, 32))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.January, 0))
}

pub fn is_valid_day_february_test() {
  // Test leap year (2024)
  assert calendar.is_valid_date(calendar.Date(2024, calendar.February, 29))
  assert !calendar.is_valid_date(calendar.Date(2024, calendar.February, 30))

  // Test non-leap year (2023)
  assert calendar.is_valid_date(calendar.Date(2023, calendar.February, 28))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.February, 29))

  // Test edge cases
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.February, 0))
}

pub fn is_valid_day_march_test() {
  assert calendar.is_valid_date(calendar.Date(2023, calendar.March, 31))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.March, 32))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.March, 0))
}

pub fn is_valid_day_april_test() {
  assert calendar.is_valid_date(calendar.Date(2023, calendar.April, 30))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.April, 31))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.April, 0))
}

pub fn is_valid_day_may_test() {
  assert calendar.is_valid_date(calendar.Date(2023, calendar.May, 31))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.May, 32))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.May, 0))
}

pub fn is_valid_day_june_test() {
  assert calendar.is_valid_date(calendar.Date(2023, calendar.June, 30))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.June, 31))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.June, 0))
}

pub fn is_valid_day_july_test() {
  assert calendar.is_valid_date(calendar.Date(2023, calendar.July, 31))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.July, 32))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.July, 0))
}

pub fn is_valid_day_august_test() {
  assert calendar.is_valid_date(calendar.Date(2023, calendar.August, 31))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.August, 32))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.August, 0))
}

pub fn is_valid_day_september_test() {
  assert calendar.is_valid_date(calendar.Date(2023, calendar.September, 30))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.September, 31))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.September, 0))
}

pub fn is_valid_day_october_test() {
  assert calendar.is_valid_date(calendar.Date(2023, calendar.October, 31))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.October, 32))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.October, 0))
}

pub fn is_valid_day_november_test() {
  assert calendar.is_valid_date(calendar.Date(2023, calendar.November, 30))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.November, 31))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.November, 0))
}

pub fn is_valid_day_december_test() {
  assert calendar.is_valid_date(calendar.Date(2023, calendar.December, 31))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.December, 32))
  assert !calendar.is_valid_date(calendar.Date(2023, calendar.December, 0))
}

pub fn is_leap_year_test() {
  // Regular leap years (divisible by 4)
  assert calendar.is_leap_year(2024)
  assert calendar.is_leap_year(2020)
  assert calendar.is_leap_year(2016)

  // Non-leap years (not divisible by 4)
  assert !calendar.is_leap_year(2023)
  assert !calendar.is_leap_year(2021)
  assert !calendar.is_leap_year(2019)

  // Century years that are NOT leap years (divisible by 100 but not 400)
  assert !calendar.is_leap_year(1900)
  assert !calendar.is_leap_year(1800)
  assert !calendar.is_leap_year(1700)

  // Century years that ARE leap years (divisible by 400)
  assert calendar.is_leap_year(2000)
  assert calendar.is_leap_year(1600)
  assert calendar.is_leap_year(2400)
}

pub fn is_valid_time_of_day_valid_test() {
  // Valid times
  assert calendar.is_valid_time_of_day(calendar.TimeOfDay(0, 0, 0, 0))
  assert calendar.is_valid_time_of_day(calendar.TimeOfDay(
    12,
    30,
    45,
    123_456_789,
  ))
  assert calendar.is_valid_time_of_day(calendar.TimeOfDay(
    23,
    59,
    59,
    999_999_999,
  ))
}

pub fn is_valid_time_of_day_invalid_hours_test() {
  // Invalid hours
  assert !calendar.is_valid_time_of_day(calendar.TimeOfDay(24, 0, 0, 0))
  assert !calendar.is_valid_time_of_day(calendar.TimeOfDay(25, 0, 0, 0))
  assert !calendar.is_valid_time_of_day(calendar.TimeOfDay(-1, 0, 0, 0))
}

pub fn is_valid_time_of_day_invalid_minutes_test() {
  // Invalid minutes
  assert !calendar.is_valid_time_of_day(calendar.TimeOfDay(12, 60, 0, 0))
  assert !calendar.is_valid_time_of_day(calendar.TimeOfDay(12, 61, 0, 0))
  assert !calendar.is_valid_time_of_day(calendar.TimeOfDay(12, -1, 0, 0))
}

pub fn is_valid_time_of_day_invalid_seconds_test() {
  // Invalid seconds
  assert !calendar.is_valid_time_of_day(calendar.TimeOfDay(12, 30, 60, 0))
  assert !calendar.is_valid_time_of_day(calendar.TimeOfDay(12, 30, 61, 0))
  assert !calendar.is_valid_time_of_day(calendar.TimeOfDay(12, 30, -1, 0))
}

pub fn is_valid_time_of_day_invalid_nanoseconds_test() {
  assert !calendar.is_valid_time_of_day(calendar.TimeOfDay(
    12,
    30,
    45,
    1_000_000_000,
  ))
  assert !calendar.is_valid_time_of_day(calendar.TimeOfDay(
    12,
    30,
    45,
    1_000_000_001,
  ))
  assert !calendar.is_valid_time_of_day(calendar.TimeOfDay(12, 30, 45, -1))
}

pub fn is_valid_time_of_day_edge_cases_test() {
  // Maximum valid values
  assert calendar.is_valid_time_of_day(calendar.TimeOfDay(23, 0, 0, 0))
  assert calendar.is_valid_time_of_day(calendar.TimeOfDay(0, 59, 0, 0))
  assert calendar.is_valid_time_of_day(calendar.TimeOfDay(0, 0, 59, 0))
  assert calendar.is_valid_time_of_day(calendar.TimeOfDay(0, 0, 0, 999_999_999))

  // Minimum valid values
  assert calendar.is_valid_time_of_day(calendar.TimeOfDay(0, 0, 0, 0))
}

pub fn compare_date_with_smaller_year_test() {
  assert order.Lt
    == calendar.naive_date_compare(
      calendar.Date(1998, calendar.October, 11),
      calendar.Date(1999, calendar.October, 11),
    )
}

pub fn compares_date_with_smaller_month_test() {
  assert order.Lt
    == calendar.naive_date_compare(
      calendar.Date(1998, calendar.October, 11),
      calendar.Date(1998, calendar.November, 11),
    )
}

pub fn compare_date_with_smaller_day_test() {
  assert order.Lt
    == calendar.naive_date_compare(
      calendar.Date(1998, calendar.October, 11),
      calendar.Date(1998, calendar.October, 12),
    )
}

pub fn compare_equal_dates_test() {
  assert order.Eq
    == calendar.naive_date_compare(
      calendar.Date(1998, calendar.October, 11),
      calendar.Date(1998, calendar.October, 11),
    )
}

pub fn compare_date_with_bigger_year_test() {
  assert order.Gt
    == calendar.naive_date_compare(
      calendar.Date(1999, calendar.October, 11),
      calendar.Date(1998, calendar.October, 11),
    )
}

pub fn compare_date_with_bigger_month_test() {
  assert order.Gt
    == calendar.naive_date_compare(
      calendar.Date(1998, calendar.November, 11),
      calendar.Date(1998, calendar.October, 11),
    )
}

pub fn compare_date_with_bigger_day_test() {
  assert order.Gt
    == calendar.naive_date_compare(
      calendar.Date(1998, calendar.October, 12),
      calendar.Date(1998, calendar.October, 11),
    )
}
