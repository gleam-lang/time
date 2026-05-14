import gleam/order
import gleam/time/duration
import gleam/time/monotonic

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

  let is_not_negative = case monotonic.difference(start, finish)
    |> duration.compare(duration.nanoseconds(0))
  {
    order.Lt -> False
    order.Eq | order.Gt -> True
  }

  assert is_not_negative
}

pub fn elapsed_since_is_not_negative_test() {
  let start = monotonic.now()

  let is_not_negative = case monotonic.elapsed_since(start)
    |> duration.compare(duration.nanoseconds(0))
  {
    order.Lt -> False
    order.Eq | order.Gt -> True
  }

  assert is_not_negative
}
