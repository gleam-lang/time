pub type TimeOfDay {
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

pub type TimeZone {
  TimeZone(fixed_offset_minutes: Int, transitions: List(TimeZoneEra))
}

pub type TimeZoneEra {
  TimeZoneEra(unix_start: Int, offset_offset_minutes: Int)
}

pub const zone_utc = TimeZone(fixed_offset_minutes: 0, transitions: [])
