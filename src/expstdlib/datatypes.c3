module datetime;

import libc;

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

struct Time {
    ushort h;
    ushort m;
    ushort s;
}

fn char* Time.toStr(Time* t) {
    char[] time_to_str;
    libc::sprintf(time_to_str, "%hu:%hu:%hu", t.h, t.m, t.s);
    return time_to_str;
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