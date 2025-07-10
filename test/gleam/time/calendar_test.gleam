import gleam/float
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
  assert calendar.is_valid_date(31, of: calendar.January, in: 2023)
  assert !calendar.is_valid_date(32, of: calendar.January, in: 2023)
  assert !calendar.is_valid_date(0, of: calendar.January, in: 2023)
}

pub fn is_valid_day_february_test() {
  // Test leap year (2024)
  assert calendar.is_valid_date(29, of: calendar.February, in: 2024)
  assert !calendar.is_valid_date(30, of: calendar.February, in: 2024)

  // Test non-leap year (2023)
  assert calendar.is_valid_date(28, of: calendar.February, in: 2023)
  assert !calendar.is_valid_date(29, of: calendar.February, in: 2023)

  // Test edge cases
  assert !calendar.is_valid_date(0, of: calendar.February, in: 2023)
}

pub fn is_valid_day_march_test() {
  assert calendar.is_valid_date(31, of: calendar.March, in: 2023)
  assert !calendar.is_valid_date(32, of: calendar.March, in: 2023)
  assert !calendar.is_valid_date(0, of: calendar.March, in: 2023)
}

pub fn is_valid_day_april_test() {
  assert calendar.is_valid_date(30, of: calendar.April, in: 2023)
  assert !calendar.is_valid_date(31, of: calendar.April, in: 2023)
  assert !calendar.is_valid_date(0, of: calendar.April, in: 2023)
}

pub fn is_valid_day_may_test() {
  assert calendar.is_valid_date(31, of: calendar.May, in: 2023)
  assert !calendar.is_valid_date(32, of: calendar.May, in: 2023)
  assert !calendar.is_valid_date(0, of: calendar.May, in: 2023)
}

pub fn is_valid_day_june_test() {
  assert calendar.is_valid_date(30, of: calendar.June, in: 2023)
  assert !calendar.is_valid_date(31, of: calendar.June, in: 2023)
  assert !calendar.is_valid_date(0, of: calendar.June, in: 2023)
}

pub fn is_valid_day_july_test() {
  assert calendar.is_valid_date(31, of: calendar.July, in: 2023)
  assert !calendar.is_valid_date(32, of: calendar.July, in: 2023)
  assert !calendar.is_valid_date(0, of: calendar.July, in: 2023)
}

pub fn is_valid_day_august_test() {
  assert calendar.is_valid_date(31, of: calendar.August, in: 2023)
  assert !calendar.is_valid_date(32, of: calendar.August, in: 2023)
  assert !calendar.is_valid_date(0, of: calendar.August, in: 2023)
}

pub fn is_valid_day_september_test() {
  assert calendar.is_valid_date(30, of: calendar.September, in: 2023)
  assert !calendar.is_valid_date(31, of: calendar.September, in: 2023)
  assert !calendar.is_valid_date(0, of: calendar.September, in: 2023)
}

pub fn is_valid_day_october_test() {
  assert calendar.is_valid_date(31, of: calendar.October, in: 2023)
  assert !calendar.is_valid_date(32, of: calendar.October, in: 2023)
  assert !calendar.is_valid_date(0, of: calendar.October, in: 2023)
}

pub fn is_valid_day_november_test() {
  assert calendar.is_valid_date(30, of: calendar.November, in: 2023)
  assert !calendar.is_valid_date(31, of: calendar.November, in: 2023)
  assert !calendar.is_valid_date(0, of: calendar.November, in: 2023)
}

pub fn is_valid_day_december_test() {
  assert calendar.is_valid_date(31, of: calendar.December, in: 2023)
  assert !calendar.is_valid_date(32, of: calendar.December, in: 2023)
  assert !calendar.is_valid_date(0, of: calendar.December, in: 2023)
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
