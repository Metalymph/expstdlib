module datetime;

import libc;
import std::io;

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
    ushort y;
    ushort m;
    ushort d;
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

/*fn void! Date.addTime(Date* date, DateUnit date_unit, uint amount) {
    switch (date_unit) {
        case YEAR:
            if (amount + date.y > 9999 ) {
                return DateError.YEAR_OUT_OF_BOUND;
            }
            date.y += amount;
        case MONTH:
            uint years = (amount + date.m) / 12;
            uint rest_mounths = (amount - date.m) % 12;
            if ((years  + date.y)  > 9999) {
                return DateError.MONTH_OUT_OF_BOUND;
            }

            //check day
            if () {

            }

            date.m += rest_mounths;
            date.y += years;
        case DAY:

    }
}*/

struct Time {
    ushort h;
    ushort m;
    ushort s;
}

fn char* Time.toStr(Time* t) {
    char[8] time_to_str;
    char hour_zero = (t.h < 10) ? '0' : hour_zero;
    char min_zero = (t.m < 10) ? '0' : min_zero;
    char sec_zero = (t.s < 10) ? '0' : sec_zero;
    libc::sprintf(time_to_str[..], "%c%hd:%c%hd:%c%hd", hour_zero, t.h, min_zero, t.m, sec_zero, t.s);
    return (char*)(time_to_str[..]);
}

struct TimeZone {
    inline Time time;
    char sign;
}

struct DateTime {
    Date date;
    Time time;
    TimeZone time_zone;
}