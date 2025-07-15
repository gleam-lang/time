# Changelog

## v1.4.0 - 2025-07-15

- RFC3339 timestamps with a space between the date and the time can now be
  parsed.

## v1.3.0 - 2025-07-10

- The `calendar` module gains the `is_leap_year`, `is_valid_time_of_day` and
  `is_valid_date` functions.

## v1.2.0 - 2025-04-20

- Fixed a bug where the `milliseconds` function could return an incorrect value
  for negative numbers.
- The `duration` module gains the `Unit` type and the `approximate`, `minutes`
  and `hours` functions.
- The `calendar` module gains the `month_to_int` and `month_from_int`
  functions.

## v1.1.0 - 2025-03-29

- The `calendar` module gains the `month_to_string` function.

## v1.0.0 - 2025-03-05

## v1.0.0-rc2 - 2025-02-05

- Fixed 2 bugs with time-zone offset handling.

## v1.0.0-rc1 - 2025-02-03

- Initial release, with the timestamp, calendar, and duration modules.
