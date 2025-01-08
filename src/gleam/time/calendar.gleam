//// This module is for working with the Gregorian calendar, established by
//// Pope Gregory XIII in 1582!
////
//// ## When should you use this module?
////
//// The types in this module type are useful when you want to communicate time
//// to a human reader, but they are not ideal for computers to work with.
//// Disadvantages of calendar time types include:
////
//// - They are ambiguous if you don't know what time-zone they are for.
//// - The type permits invalid states. e.g. `days` could be set to the number
////   32, but this should not be possible!
//// - There is not a single unique canonical value for each point in time,
////   thanks to time zones. Two different `Date` + `TimeOfDay` value pairs
////   could represent the 
////
//// Prefer to represent your time using the `Timestamp` type, and convert it
//// only to calendar types when you need to display them.
////
//// ## Time zone offsets
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
//// ## Use in APIs
////
//// If you are making an API such as a HTTP JSON API you are encouraged to use
//// Unix timestamps instead of calendar times.

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
  // TODO: add nanoseconds
  TimeOfDay(hours: Int, minutes: Int, seconds: Int)
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
pub fn local_offset() -> duration.Duration {
  duration.seconds(local_time_offset_seconds())
}

@external(erlang, "gleam_time_ffi", "local_time_offset_seconds")
@external(javascript, "../../gleam_time_ffi.mjs", "local_time_offset_seconds")
fn local_time_offset_seconds() -> Int
