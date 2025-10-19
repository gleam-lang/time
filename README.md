# Time 🕰️

Work with time in Gleam!

[![Package Version](https://img.shields.io/hexpm/v/gleam_time)](https://hex.pm/packages/gleam_time)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gleam_time/)

```sh
gleam add gleam_time
```

This package is the foundation of all code that works with time in Gleam. If
your program uses time then you should be using the types in this package, and
you might choose to add other packages to provide additional functionality.

## How not to have time related bugs

Time is famously difficult to work with! It's a very complex area, and there's
many approaches that seem reasonable or obvious, but then commonly result in
bugs. This package is carefully designed to help you avoid these problems, so
it is wise to read this documentation before continuing.

It is important to understand there are two main ways that time is represented:

- **Calendar time**: This is how humans commonly think and communicate about
  time. For example, "10pm on the 5th of January". This is easy for a human to
  read, but is it typically ambiguous and hard to work with! 10pm in
  Killorglin, Ireland is not the same point in time as 10pm in Harare,
  Zimbabwe. The exact meaning of calendar time depends on daylight savings
  time, leap years, leap seconds, and continuously changing national and
  political declarations. To make calendar time unambiguous you will need to
  know what time zone it is for, and to have an up-to-date time zone database.

- **Epoch time**: Epoch time is defined as an exact amount of since some fixed
  point in time. It is always unambiguous as is not impacted by geopolitics,
  time zones, etc. It is efficient for computers to work with, and it is less
  likely to result in buggy code.

In this package epoch time is provided by the `gleam/time/timestamp` module,
and calendar time is provided by the `gleam/time/calendar` module.

Time zone information has to be loaded from elsewhere, but which approch is
best will depend on your application. User interfaces may want to read current
time zone information from the user's web browser or operating system. Server
side applications may want to embed or downloads a full copy of the time zone
database and then ask clients which time zone they want to use.

For an entertaining overview of some of the problems of calendar time view this
video: ["The Problem with Time & Timezones" by Computerphile](https://www.youtube.com/watch?v=-5wpm-gesOY).

### Which time representation should you use?

> **tldr**: Use `gleam/time/timestamp`.

The longer, more detailed answer:

- Default to `gleam/time/timestamp`, which is epoch time. It is
  unambiguous, efficient, and significantly less likely to result in logic
  bugs.

- When writing time to a database or other data storage use epoch time,
  using whatever epoch format it supports. For example, PostgreSQL
  `timestamp` and `timestampz` are both epoch time, and `timestamp` is
  preferred as it is more straightforward to use as your application is
  also using epoch time.

- When communicating with other computer systems continue to use epoch
  time. For example, when sending times to another program you could
  encode time as UNIX timestamps (seconds since 00:00:00 UTC on 1 January
  1970).

- When communicating with humans use epoch time internally, and convert
  to-and-from calendar time at the last moment, when iteracting with the
  human user. It may also help the users to also show the time as a fuzzy
  duration from the present time, such as "about 4 days ago".

- When representing "fuzzy" human time concepts that don't exact periods
  in time, such as "one month" (varies depending on which month, which
  year, and in which time zone) and "Christmas Day" (varies depending on
  which year and time zone) then use calendar time.

Any time you do use calendar time you should be extra careful! It is very
easy to make mistake with. Avoid it where possible.

## Special thanks

This package was created with great help from several kind contributors. In
alphabetical order:

- [Hayleigh Thompson](https://github.com/hayleigh-dot-dev)
- [John Strunk](https://github.com/jrstrunk)
- [Ryan Moore](https://github.com/mooreryan)
- [Shayan Javani](https://github.com/massivefermion)

These non-Gleam projects where highly influential on the design of this
package:

- Elm's `elm/time` package.
- Go's `time` module.
- Rust's `std::time` module.
- Elixir's standard library time modules and `timex` package.
