module hello;

import strings;
import std::io;
import datetime;

fn void test_dt(char* dt_ex) {
    DateTime! dt = datetime::parseDateTime(dt_ex);
    if (catch err = dt) {
        case ParseNumError.NOT_A_NUM:
            io::println("ERR: Not a num");
        case DateTimeError.UNEXPECTED_CHAR:
            io::println("ERR: Char Error");
        default:
            io::println("ERR: Str Len Mismatch");
    } else {
        io::println("OK");
        //io::printf("datetime.date = %s", dt.date.toStr());
        //io::printf("datetime.time = %s", dt.time.toStr());

        io::printf("\nComponents are:\nDate -> yyyy: %hd, mm: %hd, dd: %hd\n", dt.date.y, dt.date.m, dt.date.d);
        io::printf("Time -> hh: %hd, mm: %hd, ss: %hd\n", dt.time.h, dt.time.m, dt.time.s);
        io::printf("TimeZone -> hh: %hd, mm: %hd, ss: %hd, sign: %c\n", dt.time_zone.h, dt.time_zone.m, dt.time_zone.s, dt.time_zone.sign);
    }
}

fn int main(int argc, char** argv) 
{
    io::println("\nTEST LIST:");

    //TEST datetime::atoi()
    ushort err_val = 10;
    io::printf("test_1 atoi(char) of \'2\' is: %s\n", ((datetime::atoi('2') ?? err_val) == (ushort)(2)) ? "OK" : "ERR");
    io::printf("test_2 atoi(char) of \'-\' is: %s\n", ((datetime::atoi('-') ?? err_val) == (ushort)(10)) ? "OK" : "ERR");

    char* dt_ex_1 = "2021-08-03T12:34:45Z";

    //TEST strings::len()
    //io::printf("test_1 strings::len(char*) of \'%s\' is %hd and is: ", dt_ex_1, strings::len(dt_ex_1));
    //io::printf("%s\n", (strings::len(dt_ex_1) == 20) ? "OK" : "ERR");

    //TEST datetime::parseDateTime()
    io::printf("test_1 datetime::parseDateTime(char*) of %s is: ", dt_ex_1);
    test_dt(dt_ex_1); //OK

    char* dt_ex_2 = "2021-08-32T12:45:01Z"; //32 of august CHAR_ERROR
    io::printf("test_2 datetime::parseDateTime(char*) of %s is: ", dt_ex_2);
    test_dt(dt_ex_2);

    char* dt_ex_3 = "2021-08-3212:45:01Z"; //STRLEN_MISMATCH 19 instead of 20 chars (T)
    io::printf("test_3 datetime::parseDateTime(char*) of %s is: ", dt_ex_3);
    test_dt(dt_ex_3);

    char* dt_ex_4 = "2021-08-31T12:37:01+04:05:56"; //OK
    io::printf("test_4 datetime::parseDateTime(char*) of %s is: ", dt_ex_4);
    test_dt(dt_ex_4);




    /*
    char* msg = "forth";
    char[] message = "busy";

    //len
    io::printf("len of \'%s\' is %hd\n", message, strings::len(message));
    io::printf("len of \'%s\' is %hd\n", msg, strings::len(msg));

    //reverse
    //io::printf("reverse : %s\n", strings::reverse(msg));
    io::printf("reverse : %s\n", strings::reverse(message));

    //toUpper & toLower
    io::printf("toUpper : %s\n", strings::toUpper(message));
    io::printf("toLower : %s\n", strings::toLower(message));
    io::printf("toUpper : %s\n", strings::toUpper(msg));
    io::printf("toLower : %s\n", strings::toLower(msg));

    //compare
    io::printf("compare with \'%s\': %hd\n", "tko", strings::compare(message, "tko"));
    io::printf("compare with \'%s\': %hd\n", "Tko", strings::compare(message, "Tko"));
    io::printf("compare with \'%s\': %hd\n", "tkO", strings::compare(message, "tkO")); //FAIL
    */
    return 0;
}