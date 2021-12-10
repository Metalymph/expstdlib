# expstdlib
Playing around C3 about potentially useful datatypes for the stdlib

## DateTime

```
import datetime;

fn int main(int argc, char** argv){
    DateTime! dt = datetime::parseDateTime("2021-05-26T05:45:23+02:00:00");
    if (catch err = dt) {
        case ParseNumError.NOT_A_NUM:
            io::println("\n\tERR: Not a num");
        case DateTimeError.UNEXPECTED_CHAR:
            io::println("\n\tERR: Char Error");
        default:
            io::println("\n\tERR: Str Len Mismatch");
    } else {
        //using dt
    }
}

```

## Date, Time, TimeZone

You can also use `parseDate("yyyy-mm-dd")` or `parseTime("hh:mm:ss")` to obtain a `Date` or a `Time` struct.
You can add or subtract time to `Date` or `Time` with `add(DateUnit, amount)` and `sub` methods available on both. For example, accepting possible code panic:

```
import datetime;

fn int main(int argc, char** argv){
    Date date = datetime::parseData("2021-02-01")!!;
    date.add(DateUnit.MONTH, 123)!! //adds 123 months to the given data parsed

    Time time = datetime::parseTime("04:23:59")!!;
    time.add(TimeUnit.SEC, 4500)!!;
}
```

A `TimeZone` is a type composed by a `Time` and a symbol for positive-negative or zulu TZ.

```
import datetime;

fn int main(int argc, char** argv){
    DateTime! dt = datetime::parseDateTime("2021-05-26T05:45:23+02:00:00");
    if (catch err = dt) {
        case ParseNumError.NOT_A_NUM:
            io::println("\n\tERR: Not a num");
        case DateTimeError.UNEXPECTED_CHAR:
            io::println("\n\tERR: Char Error");
        default:
            io::println("\n\tERR: Str Len Mismatch");
    } else {
        dt.time_zone = TimeZone{ 5, 0, 0, '+' };
    }
}
```

Each type can be set to zero value, calling `reset()` method.


