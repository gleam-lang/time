import gleam/order
import gleam/time/duration
import gleeunit/should

pub fn add_0_test() {
  duration.nanoseconds(500_000_000)
  |> duration.add(duration.nanoseconds(500_000_000))
  |> should.equal(duration.seconds(1))
}

pub fn add_1_test() {
  duration.nanoseconds(-500_000_000)
  |> duration.add(duration.nanoseconds(-500_000_000))
  |> should.equal(duration.seconds(-1))
}

pub fn add_2_test() {
  duration.nanoseconds(-500_000_000)
  |> duration.add(duration.nanoseconds(500_000_000))
  |> should.equal(duration.seconds(0))
}

pub fn add_3_test() {
  duration.seconds(4)
  |> duration.add(duration.nanoseconds(4_000_000_000))
  |> should.equal(duration.seconds(8))
}

pub fn add_4_test() {
  duration.seconds(4)
  |> duration.add(duration.nanoseconds(-5_000_000_000))
  |> should.equal(duration.seconds(-1))
}

pub fn add_5_test() {
  duration.nanoseconds(4_000_000)
  |> duration.add(duration.milliseconds(4))
  |> should.equal(duration.milliseconds(8))
}

pub fn to_seconds_0_test() {
  duration.seconds(1)
  |> duration.to_seconds
  |> should.equal(1.0)
}

pub fn to_seconds_1_test() {
  duration.seconds(2)
  |> duration.to_seconds
  |> should.equal(2.0)
}

pub fn to_seconds_2_test() {
  duration.milliseconds(500)
  |> duration.to_seconds
  |> should.equal(0.5)
}

pub fn to_seconds_3_test() {
  duration.milliseconds(5100)
  |> duration.to_seconds
  |> should.equal(5.1)
}

pub fn to_seconds_4_test() {
  duration.nanoseconds(500)
  |> duration.to_seconds
  |> should.equal(0.0000005)
}

pub fn compare_0_test() {
  duration.compare(duration.seconds(1), duration.seconds(1))
  |> should.equal(order.Eq)
}

pub fn compare_1_test() {
  duration.compare(duration.seconds(2), duration.seconds(1))
  |> should.equal(order.Gt)
}

pub fn compare_2_test() {
  duration.compare(duration.seconds(0), duration.seconds(1))
  |> should.equal(order.Lt)
}

pub fn compare_3_test() {
  duration.compare(duration.nanoseconds(999_999_999), duration.seconds(1))
  |> should.equal(order.Lt)
}

pub fn compare_4_test() {
  duration.compare(duration.nanoseconds(1_000_000_001), duration.seconds(1))
  |> should.equal(order.Gt)
}

pub fn compare_5_test() {
  duration.compare(duration.nanoseconds(1_000_000_000), duration.seconds(1))
  |> should.equal(order.Eq)
}
