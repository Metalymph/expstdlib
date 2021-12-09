# expstdlib
Playing around C3 about potentially useful datatypes for the stdlib

## DateTime

```
import datetime;

DateTime! dt = datetime::parseDateTime("yyyy-mm-ddThh:mm:ss+hh:mm:ss"); //select the datetime you want (also with Z as TimeZone);
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

```

## Date and Time structs

You can also use `parseDate("yyyy-mm-dd")` or `parseTime("hh:mm:ss")` to obtain a `Date` or a `Time` struct.
You can add or substract time to `Date` or `Time` with `addTime(..., ...)` method available on both. For example:

```
import datetime;

Date date = datetime::parseData("yyyy-mm-dd")!!;
date.addTime(DateUnit.MONTH, 123)!! //adds 123 months to the given data parsed

```
