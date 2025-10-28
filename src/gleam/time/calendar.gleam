//// This module is for working with the Gregorian calendar, established by
//// Pope Gregory XIII in 1582!
////
//// ## When should you use this module?
////
//// > **tldr:** You probably want to use [`gleam/time/timestamp`](./timestamp.html)
//// > instead!
////
//// Calendar time is difficult to work with programmatically, it is the source
//// of most time-related bugs in software. Compared to _epoch time_, which the
//// `gleam/time/timestamp` module uses, there are many disadvantages to
//// calendar time:
////
//// - They are ambiguous if you don't know what time-zone is being used.
////
//// - A time-zone database is required to understand calendar time even when
////   you have the time zone. These are large and your program has to
////   continously be updated as new versions of the database are published.
////
//// - The type permits invalid states. e.g. `days` could be set to the number
////   32, but this should not be possible!
////
//// - There is not a single unique canonical value for each point in time,
////   thanks to time zones. Two different `Date` + `TimeOfDay` value pairs
////   could represent the same point in time. This means that you can't check
////   for time equality with `==` when using calendar types.
////
//// - They are computationally complex, using a more memory to represent and
////   requiring a lot more CPU time to manipulate.
////
//// There are also advantages to calendar time:
////
//// - Calendar time is how human's talk about time, so if you want to show a
////   time or take a time from a human user then calendar time will make it
////   easier for them.
////
//// - They can represent more abstract time periods such as "New Year's Day".
////   This may seem like an exact window of time at first, but really the
////   definition of "New Year's Day" is more fuzzy than that. When it starts
////   and ends will depend where in the world you are, so if you want to refer
////   to a day as a global concept instead of a fixed window of time for that
////   day in a specific location, then calendar time can represent that.
////
//// So when should you use calendar time? These are our recommendations:
////
//// - Default to `gleam/time/timestamp`, which is epoch time. It is
////   unambiguous, efficient, and significantly less likely to result in logic
////   bugs.
////
//// - When writing time to a database or other data storage use epoch time,
////   using whatever epoch format it supports. For example, PostgreSQL
////   `timestamp` and `timestampz` are both epoch time, and `timestamp` is
////   preferred as it is more straightforward to use as your application is
////   also using epoch time.
////
//// - When communicating with other computer systems continue to use epoch
////   time. For example, when sending times to another program you could
////   encode time as UNIX timestamps (seconds since 00:00:00 UTC on 1 January
////   1970).
////
//// - When communicating with humans use epoch time internally, and convert
////   to-and-from calendar time at the last moment, when iteracting with the
////   human user. It may also help the users to also show the time as a fuzzy
////   duration from the present time, such as "about 4 days ago".
////
//// - When representing "fuzzy" human time concepts that don't exact periods
////   in time, such as "one month" (varies depending on which month, which
////   year, and in which time zone) and "Christmas Day" (varies depending on
////   which year and time zone) then use calendar time.
////
//// Any time you do use calendar time you should be extra careful! It is very
//// easy to make mistake with. Avoid it where possible.
////
//// ## Time zone offsets
////
//// This package includes the `utc_offset` value and the `local_offset`
//// function, which are the offset for the UTC time zone and get the time
//// offset the computer running the program is configured to respectively.
////
//// If you need to use other offsets in your program then you will need to get
//// them from somewhere else, such as from a package which loads the
//// [IANA Time Zone Database](https://www.iana.org/time-zones), or from the
//// website visitor's web browser, which your frontend can send for you.
////
//// ## Use in APIs
////
//// If you are making an API such as a HTTP JSON API you are encouraged to use
//// Unix timestamps instead of calendar times.

import gleam/int
import gleam/order.{type Order}
import gleam/time/duration

/// The Gregorian calendar date. Ambiguous without a time zone.
///
/// Prefer to represent your time using the `Timestamp` type, and convert it
/// only to calendar types when you need to display them. See the documentation
/// for this module for more information.
///
pub type Date {
  Date(year: Int, month: Month, day: Int)
}

/// The time of day. Ambiguous without a date and time zone.
///
pub type TimeOfDay {
  TimeOfDay(hours: Int, minutes: Int, seconds: Int, nanoseconds: Int)
}

/// The 12 months of the year.
pub type Month {
  January
  February
  March
  April
  May
  June
  July
  August
  September
  October
  November
  December
}

/// The offset for the [Coordinated Universal Time (UTC)](https://en.wikipedia.org/wiki/Coordinated_Universal_Time)
/// time zone.
///
/// The utc zone has no time adjustments, it is always zero. It never observes
/// daylight-saving time and it never shifts around based on political
/// restructuring.
///
pub const utc_offset = duration.empty

/// Get the offset for the computer's currently configured time zone.
///
/// Note this may not be the time zone that is correct to use for your user.
/// For example, if you are making a web application that runs on a server you
/// want _their_ computer's time zone, not yours.
///
/// This is the _current local_ offset, not the current local time zone. This
/// means that while it will result in the expected outcome for the current
/// time, it may result in unexpected output if used with other timestamps. For
/// example: a timestamp that would locally be during daylight savings time if
/// is it not currently daylight savings time when this function is called.
///
pub fn local_offset() -> duration.Duration {
  duration.seconds(local_time_offset_seconds())
}

@external(erlang, "gleam_time_ffi", "local_time_offset_seconds")
@external(javascript, "../../gleam_time_ffi.mjs", "local_time_offset_seconds")
fn local_time_offset_seconds() -> Int

/// Returns the English name for a month.
///
/// # Examples
///
/// ```gleam
/// month_to_string(April)
/// // -> "April"
/// ```
pub fn month_to_string(month: Month) -> String {
  case month {
    January -> "January"
    February -> "February"
    March -> "March"
    April -> "April"
    May -> "May"
    June -> "June"
    July -> "July"
    August -> "August"
    September -> "September"
    October -> "October"
    November -> "November"
    December -> "December"
  }
}

/// Returns the number for the month, where January is 1 and December is 12.
///
/// # Examples
///
/// ```gleam
/// month_to_int(January)
/// // -> 1
/// ```
pub fn month_to_int(month: Month) -> Int {
  case month {
    January -> 1
    February -> 2
    March -> 3
    April -> 4
    May -> 5
    June -> 6
    July -> 7
    August -> 8
    September -> 9
    October -> 10
    November -> 11
    December -> 12
  }
}

/// Returns the month for a given number, where January is 1 and December is 12.
///
/// # Examples
///
/// ```gleam
/// month_from_int(1)
/// // -> Ok(January)
/// ```
pub fn month_from_int(month: Int) -> Result(Month, Nil) {
  case month {
    1 -> Ok(January)
    2 -> Ok(February)
    3 -> Ok(March)
    4 -> Ok(April)
    5 -> Ok(May)
    6 -> Ok(June)
    7 -> Ok(July)
    8 -> Ok(August)
    9 -> Ok(September)
    10 -> Ok(October)
    11 -> Ok(November)
    12 -> Ok(December)
    _ -> Error(Nil)
  }
}

/// Checks if a given date is valid.
///
/// This function properly accounts for leap years when validating February days.
/// A leap year occurs every 4 years, except for years divisible by 100,
/// unless they are also divisible by 400.
///
/// # Examples
///
/// ```gleam
/// is_valid_date(Date(2023, April, 15))
/// // -> True
/// ```
///
/// ```gleam
/// is_valid_date(Date(2023, April, 31))
/// // -> False
/// ```
///
/// ```gleam
/// is_valid_date(Date(2024, February, 29))
/// // -> True (2024 is a leap year)
/// ```
///
pub fn is_valid_date(date: Date) -> Bool {
  let Date(year:, month:, day:) = date
  case day < 1 {
    True -> False
    False ->
      case month {
        January | March | May | July | August | October | December -> day <= 31
        April | June | September | November -> day <= 30
        February -> {
          let max_february_days = case is_leap_year(year) {
            True -> 29
            False -> 28
          }
          day <= max_february_days
        }
      }
  }
}

/// Determines if a given year is a leap year.
///
/// A leap year occurs every 4 years, except for years divisible by 100,
/// unless they are also divisible by 400.
///
/// # Examples
///
/// ```gleam
/// is_leap_year(2024)
/// // -> True
/// ```
///
/// ```gleam
/// is_leap_year(2023)
/// // -> False
/// ```
///
pub fn is_leap_year(year: Int) -> Bool {
  case year % 400 == 0 {
    True -> True
    False ->
      case year % 100 == 0 {
        True -> False
        False -> year % 4 == 0
      }
  }
}

/// Checks if a time of day is valid.
///
/// Validates that hours are 0-23, minutes are 0-59, seconds are 0-59,
/// and nanoseconds are 0-999,999,999.
///
/// # Examples
///
/// ```gleam
/// is_valid_time_of_day(TimeOfDay(12, 30, 45, 123456789))
/// // -> True
/// ```
///
pub fn is_valid_time_of_day(time: TimeOfDay) -> Bool {
  let TimeOfDay(hours:, minutes:, seconds:, nanoseconds:) = time

  hours >= 0
  && hours <= 23
  && minutes >= 0
  && minutes <= 59
  && seconds >= 0
  && seconds <= 59
  && nanoseconds >= 0
  && nanoseconds <= 999_999_999
}

/// Compares two dates, returning an order.
///
pub fn naive_date_compare(one: Date, other: Date) -> Order {
  int.compare(one.year, other.year)
  |> order.lazy_break_tie(fn() {
    int.compare(month_to_int(one.month), month_to_int(other.month))
  })
  |> order.lazy_break_tie(fn() { int.compare(one.day, other.day) })
}
