//// The main way that time is represented in this package is with the
//// `Timestamp` type. Timestamps are great for computers to work with but
//// they're hard for humans to understand, so this module provides some types
//// that you can convert timestamps before showing them to humans.
////
//// Calendar time data structures are error prone and are ambiguous without
//// up-to-date time zone offset information, so where possible only use them
//// for interacting with humans, or for times that don't corrospond with a
//// specific single point in time (e.g. 3pm on no particular day).
////
//// This package includes the `utc_offset` value and the `local_offset`
//// function, which get the offset for the UTC time zone and time zone the
//// computer running the program is configured to respectively. If you are
//// running a Gleam web server then the local offset is that of the server the
//// program is running on, not that of any visitor to the website.
////
//// If you need to use other offsets in your program then you will need to get
//// them from somewhere else, such as from a package which loads the
//// [IANA Time Zone Database](https://www.iana.org/time-zones), or from the
//// website visitor's web browser.
////
//// If you are making an API such as a HTTP JSON API you are encouraged to use
//// Unix timestamps instead of calendar times.

import gleam/time/duration

pub type TimeOfDay {
  // TODO: add nanoseconds
  TimeOfDay(hours: Int, minutes: Int, seconds: Int)
}

pub type Date {
  Date(year: Int, month: Month, day: Int)
}

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

// TODO: test
// TODO: document
pub fn local_offset() -> duration.Duration {
  duration.seconds(local_time_offset_seconds())
}

@external(erlang, "gleam_time_ffi", "local_time_offset_seconds")
@external(javascript, "../../gleam_time_ffi.mjs", "local_time_offset_seconds")
fn local_time_offset_seconds() -> Int
