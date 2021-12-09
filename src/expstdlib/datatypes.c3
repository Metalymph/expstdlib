module datetime;

//import libc;
//import std::io;

enum DateUnit {
    YEAR,
    MONTH,
    DAY
}

enum TimeUnit {
    HOUR,
    MIN,
    SEC,
    MILLISEC,
    NANOSEC
}

enum WeekDay: ushort {
    MONDAY = 1,
    THUSDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY
}

enum Month: ushort {
    JANUARY  = 1,
    FEBRUARY,
    MARCH,
    APRIL,
    MAY,
    JUN,
    JULY,
    AUGUST,
    SEPTEMBER,
    OCTOBER,
    NOVEMBER,
    DECEMBER
}

enum CharType {
    NO_ZERO_NUM,
    NUM,
    MINUS,
    TIME,
    TIME_ZONE_SIGN,
    COLON
}

/* ERRORS */ 

errtype DateError {
    YEAR_OUT_OF_BOUND,
    MONTH_OUT_OF_BOUND,
    DAY_OUT_OF_BOUND
}

errtype DateTimeError {
    UNEXPECTED_CHAR,
    STR_LEN_MISMATCH
}

errtype ParseNumError {
    NOT_A_NUM
}

struct Date {
    uint y;
    uint m;
    uint d;
}

fn bool Date.isLeapYear(Date* date) {
    if (date.y % 4 == 0) {
        if (date.y % 100 == 0) {
            if (date.y % 400 == 0) {
                return true;
            }
            return false;
        }
        return true;
    }
    return false;
}

fn void! Date.addTime(Date* date, DateUnit date_unit, uint amount) {
    switch (date_unit) {
        case YEAR:
            if (amount + date.y > 9999 ) {
                return DateError.YEAR_OUT_OF_BOUND!;
            }
            date.y += amount;
        case MONTH:
            uint years = (amount + date.m) / 12;
            uint updated_month = amount - (12 * years) + date.m;
            if ((years + date.y) > 9999) {
                return DateError.MONTH_OUT_OF_BOUND!;
            }

            switch (date.d) {
                case 31:
                    uint[5] month_with_30days = { 2,4,6,9,11 };
                    foreach(uint month : month_with_30days) {
                        if (month == updated_month) {
                            //io::printf("31 days exceed the max supported with month %hd.\n", month);
                            return DateError.DAY_OUT_OF_BOUND!;
                        }
                    }
                case 30:
                    if (updated_month == 2) {
                        //io::println("30 days exceed the max supported with february.\n");
                        return DateError.DAY_OUT_OF_BOUND!;
                    }
                default:
                    if (date.d == 29 && date.m == 2)  {
                        if (!date.isLeapYear()) {
                            //io::println("29 days exceed the max supported with february in a not leap year.\n");
                            return DateError.DAY_OUT_OF_BOUND!;
                        }
                    }
            }
            date.m = updated_month;
            date.y += years;
        case DAY:
            Date temp_date = { date.y, date.m, date.d };

            while (amount > 0) {
                uint month_days = {|
                    switch (date.m) {
                        case 1: return 31;
                        case 2: return (date.isLeapYear() ? 29 : 28);
                        case 3: nextcase 1;
                        case 4: return 30;
                        case 5: nextcase 1;
                        case 6: nextcase 4;
                        case 7..8: nextcase 1;
                        case 9: nextcase 4;
                        case 10: nextcase 1;
                        case 11: nextcase 4;
                        case 12: nextcase 1;
                    }
                |};

                //updates only the date.d
                if (amount <= 30) {
                    temp_date.d = temp_date.d + amount;
                    if (temp_date.d <= month_days) {
                        date.d += temp_date.d;
                        break;
                    }
                }

                //date is moved one month at a time
                amount -= month_days - (temp_date.d + 1);
                temp_date.d = 1;
                temp_date.m = (temp_date.m == 12) ? 1 : (temp_date.m + 1);
                if (temp_date.m == 1) {
                    if (temp_date.y < 9999) {
                        temp_date.y += 1;
                    } else {
                        //io::println("year 10000 exceed the max supported (9999).\n");
                        return DateError.YEAR_OUT_OF_BOUND!;
                    }
                }
            }
            
            date.d = temp_date.d;
            date.m = temp_date.m;
            date.y = temp_date.y;
    }
}

struct Time {
    ushort h;
    ushort m;
    ushort s;
}

/*fn char* Time.toStr(Time* t, char[] time_str) {
    char hour_zero = (t.h < 10) ? '0' : '\0';
    char min_zero = (t.m < 10) ? '0' : '\0';
    char sec_zero = (t.s < 10) ? '0' : '\0';
    libc::sprintf(time_str, "%c%hd:%c%hd:%c%hd", hour_zero, t.h, min_zero, t.m, sec_zero, t.s);
    return time_str;
}*/

struct TimeZone {
    inline Time time;
    char sign;
}

struct DateTime {
    Date date;
    Time time;
    TimeZone time_zone;
}