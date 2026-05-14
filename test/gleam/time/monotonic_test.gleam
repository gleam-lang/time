import gleam/order
import gleam/time/duration
import gleam/time/monotonic

fn is_not_negative(d: duration.Duration) -> Bool {
  let #(seconds, nanoseconds) = duration.to_seconds_and_nanoseconds(d)
  seconds > 0 || { seconds == 0 && nanoseconds >= 0 }
}

pub fn now_can_be_compared_test() {
  let start = monotonic.now()
  let finish = monotonic.now()

  let is_ordered = case monotonic.compare(start, finish) {
    order.Lt | order.Eq -> True
    order.Gt -> False
  }

  assert is_ordered
}

pub fn difference_between_ordered_instants_is_not_negative_test() {
  let start = monotonic.now()
  let finish = monotonic.now()

  assert is_not_negative(monotonic.difference(start, finish))
}

pub fn elapsed_since_is_not_negative_test() {
  let start = monotonic.now()

  assert is_not_negative(monotonic.elapsed_since(start))
}
