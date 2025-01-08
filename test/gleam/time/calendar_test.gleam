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
