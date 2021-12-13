module datetime;

import strings;
import std::io;
import libc;

enum CharType {
    NO_ZERO_NUM,
    NUM,
    MINUS,
    TIME,
    TIME_ZONE_SIGN,
    COLON
}

errtype DTParseError {
    UNEXPECTED_CHAR,
    STR_LEN_MISMATCH,
    NOT_A_NUM
}

/**
    struct TimeZone
**/

struct TimeZone {
    inline Time time;
    char sign;
}

fn void TimeZone.reset(TimeZone* tz) {
    tz.time.reset();
    tz.sign = 'Z';
}

/**
    struct DateTime
**/

struct DateTime {
    Date date;
    Time time;
    TimeZone time_zone;
}

fn void DateTime.reset(DateTime* dt) {
    dt.time.reset();
    dt.date.reset();
    dt.time_zone.reset();
}

private fn char! verifyChar(char ch, CharType ctype, ushort pos) {
    char[] err_message;
    ushort ch_val = (ushort)(ch);
    switch (ctype) {
        case NO_ZERO_NUM:
            if (ch_val > 48 && ch_val < 58) {
                return ch;
            }
            err_message = "a no-zero number";
        case NUM:
            if (ch_val > 47 && ch_val < 58) {
                return ch;
            }
            err_message = "a number";
        case MINUS:
            if (ch == '-') {
                return ch;
            }
            err_message = "\'-\'";
        case TIME:
            if (ch == 'T') {
                return ch;
            }
            err_message = "\'T\'";
        case TIME_ZONE_SIGN:
            if ((ch == 'Z') || (ch == '-') || (ch == '+')) {
                return ch;
            }
            err_message = (pos < 8) ? "'-\'" : "\'Z\' or \'-\' or \'+\'";
        case COLON:
            if (ch == ':') {
                return ch;
            }
            err_message = "\':\'";
    }
    io::printf("Error: char \'%c\' found, expected %s instead at index %hd\n", ch, err_message, pos);
    return DTParseError.UNEXPECTED_CHAR!; 
}

private fn Date! parseDate(char* date_str) {
    Date date = Date { 0, 0, 0 };
    char ch;
    ushort ch_val;

    for (ushort i = 0; i < 10; i++) {
        ch = date_str[i];

        switch(i) {
            case 0:
                verifyChar(ch, CharType.NO_ZERO_NUM, i)?;
                ch_val = atoi(ch)?;
                date.y = ch_val * 1000;
            case 1 .. 3:
                verifyChar(ch, CharType.NUM, i)?;
                ch_val = atoi(ch)?;
                switch (i) {
                    case 1: date.y += ch_val * 100;
                    case 2: date.y += ch_val * 10;
                    case 3: date.y += ch_val;
                }
            case 4:
                verifyChar(ch, CharType.MINUS, i)?;
            case 5:
                ch_val = atoi(ch)?;
                if (ch_val == 0 || ch_val == 1) {
                    date.m = ch_val * 10;
                    continue;
                } else { 
                    io::printf("Error: char \'%c\' found, expected \'-\' instead.\n", ch);
                    return DTParseError.UNEXPECTED_CHAR!; 
                }
            case 6:
                if (date.m == 0) {
                    verifyChar(ch, CharType.NO_ZERO_NUM, i)?;
                    date.m += atoi(ch)?;
                } else {
                    ch_val = atoi(ch)?;
                    if ((ch_val == 1) || (ch_val == 2)) {
                        date.m += ch_val;
                    } else { 
                        io::printf("Error: char \'%c\' found, expected 1 or 2 instead at index %hd.\n", ch, i);
                        return DTParseError.UNEXPECTED_CHAR!; 
                    }
                }
            case 7:
                nextcase 4;
            case 8:
                ch_val = atoi(ch)?;
                if ((ch_val >= 0) && (ch_val <= 3)) {
                    if (date.m == 2 && ch_val == 3) {
                        io::printf("Error: char \'%c\' found, expected in 0..2 instead at index %hd due to month %hu given.\n", ch, i, date.m);
                        return DTParseError.UNEXPECTED_CHAR!;
                    }
                    date.d = ch_val * 10;
                } else {
                    io::printf("Error: char \'%c\' found, expected in 0..3 instead at index %hd.\n", ch, i);
                    return DTParseError.UNEXPECTED_CHAR!; 
                }
            case 9:
                ch_val = atoi(ch)?;
                if (date.d == 30) {
                    switch (date.m) {
                        case 1:
                            if (ch_val > 1) {
                                io::printf("Error: char \'%c\' found, expected 0 or 1 instead at index %hd", ch, i);
                                return DTParseError.UNEXPECTED_CHAR!;
                            }
                        //case 2: return DTParseError.UNEXPECTED_CHAR;!
                        case 3: nextcase 1;
                        case 4: 
                            if (ch_val > 0) {
                                io::printf("Error: char \'%c\' found, expected 0 instead at index %hd due to month %hu given", ch, i, date.m);
                                return DTParseError.UNEXPECTED_CHAR!; 
                            }
                        case 5: nextcase 1;
                        case 6: nextcase 4;
                        case 7..8: nextcase 1;
                        case 9: nextcase 4;
                        case 10: nextcase 1;
                        case 11: nextcase 4;
                        case 12: nextcase 1;
                    }
                    date.d += ch_val;
                } else {
                    switch (date.m) {
                        case 1:
                            verifyChar(ch, CharType.NUM, i)?;
                            date.d += ch_val;
                        case 2: 
                            if (date.isLeapYear()) {
                                nextcase 1;
                            } else {
                                if (ch > 8) {
                                    io::printf("Error: char \'%c\' found, expected in 0..8 instead at index %hd due to month %hu given", ch, i, date.m);
                                    return DTParseError.UNEXPECTED_CHAR!;
                                }
                                date.d += ch_val;
                            }
                        case 3..12: nextcase 1;
                         
                    }
                    verifyChar(ch, CharType.NUM, i)?;
                }
        }
    }

    return date;
}

private fn Time! parseTime(char* time_str) {
    Time time;

    char ch;
    ushort ch_val;

    for (ushort i = 0; i < 8; i++) {
        ch = time_str[i];

        switch(i) {
            case 0:
                ch_val = atoi(ch)?;
                if (ch_val > 3) {
                    io::printf("Error: char \'%c\' found, expected in 0..2 instead at index %hd", ch, i);
                    return DTParseError.UNEXPECTED_CHAR!;
                }
                time.h = ch_val * 10;
            case 1:
                ch_val = atoi(ch)?;
                if (time.h < 20) {
                    verifyChar(ch, CharType.NUM, i)?;
                } else if (ch_val > 3) {
                    io::printf("Error: char \'%c\' found, expected in 0..3 instead at index %hd", ch, i);
                    return DTParseError.UNEXPECTED_CHAR!;
                }
                time.h += ch_val;
            case 2:
                verifyChar(ch, CharType.COLON, i)?;
            case 3:
                ch_val = atoi(ch)?;
                if (ch_val > 5) {
                    io::printf("Error: char \'%c\' found, expected in 0..5 instead at index %hd", ch, i);
                    return DTParseError.UNEXPECTED_CHAR!;
                }
                time.m = ch_val * 10;
            case 4:
                verifyChar(ch, CharType.NUM, i)?;
                time.m += atoi(ch)?;
            case 5:
                nextcase 2;
            case 6:
                ch_val = atoi(ch)?;
                if (ch_val > 5) {
                    io::printf("Error: char \'%c\' found, expected in 0..5 instead at index %hd", ch, i);
                    return DTParseError.UNEXPECTED_CHAR!;
                }
                time.s = ch_val * 10;
            case 7:
                verifyChar(ch, CharType.NUM, i)?;
                time.s += atoi(ch)?;
        }
    }

    return time;
}

fn DateTime! parseDateTime(char* datetime_str) {
    //usize strlen = libc::strlen(datetime_str);
    uint strlen = strings::len(datetime_str);
    if (strlen < 20) {
        io::printf("Error: string given has not the minimum lenght of 20 chars.");
        return DTParseError.STR_LEN_MISMATCH!;
    }

    verifyChar(datetime_str[10], CharType.TIME, 10)?;
    
    DateTime datetime;
    datetime.time_zone.sign = verifyChar(datetime_str[19], CharType.TIME_ZONE_SIGN, 19)?;

    switch (datetime.time_zone.sign) {
        case 'Z':
            //Default UTC TimeZone is used
            datetime.time_zone.time = Time { 0, 0, 0 };
        case '+':
            if (strlen != 28) {
                io::printf("Error: string given has not the lenght of 28 chars.");
                return DTParseError.STR_LEN_MISMATCH!; 
            }
            datetime.time_zone.time = parseTime(datetime_str[20..27])?;
        case '-':
            nextcase '+';
    }

    datetime.date = parseDate(datetime_str)?;
    datetime.time = parseTime(datetime_str[11..18])?;

    return datetime;
}

fn void! DateTime.addDate(DateTime* dt, DateUnit d_unit, uint amount) {
    dt.date.add(d_unit, amount)?;
}

fn void! DateTime.addTime(DateTime* dt, TimeUnit t_unit, uint amount) {
    uint days_ahead = dt.time.add(t_unit, amount);
    if(days_ahead == 0) { return; }
    dt.date.add(DateUnit.DAY, days_ahead)?;
}

