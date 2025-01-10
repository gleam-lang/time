import { Error, Ok } from "./gleam.mjs";

export function rfc3339_to_system_time_in_milliseconds(timestamp) {
  try {
    const date = new Date(timestamp);

    if (isNaN(date)) {
      return new Error(undefined);
    } else {
      return new Ok(date.getTime());
    }
  } catch {
    return new Error(undefined);
  }
}
