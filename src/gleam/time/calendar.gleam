//// The main way that time is represented in this package is with the
//// `Timestamp` type. Timestamps are great for computers to work with but
//// they're hard for humans to understand, so this module provides some types
//// that you can convert timestamps before showing them to humans.
////
//// Calendar time data structures are error prone and are ambiguous without
//// up-to-date time zone information, so where possible only use them for
//// interacting with humans, or for times that don't corrospond with a
//// specific single point in time (e.g. 3pm on no particular day).
////
//// If you are making an API such as a HTTP JSON API you are encouraged to use
//// Unix timestamps instead of calendar times.

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

/// Calendar time information is ambiguous unless you know what time zone is
/// being used. e.g. 1pm on the 5th January 2025 is not the same time in London
/// as it is in Bratislava. Function that convert to and from calendar time
/// will take a time zone to remove the ambiguity.
///
/// This module provides the `zone_utc` time zone. If you need others then you
/// will need to get them from elsewhere, possibly community package that embed
/// the [IANA Time Zone Database](https://www.iana.org/time-zones).
///
pub type TimeZone {
  TimeZone(fixed_offset_minutes: Int, transitions: List(TimeZoneEra))
}

pub type TimeZoneEra {
  TimeZoneEra(unix_start: Int, offset_offset_minutes: Int)
}

pub const zone_utc = TimeZone(fixed_offset_minutes: 0, transitions: [])
