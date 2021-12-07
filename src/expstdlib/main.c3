module hello;

//import strings;
import std::io;
import datetime;

fn int main(int argc, char** argv) 
{
    DateTime! dt = datetime::parseDateTime("2021-08-03T12:34:45Z");
    if (catch err = dt) {
        case ParseNumError.NOT_A_NUM:
            io::println("Not a num");
        case DateTimeError.UNEXPECTED_CHAR:
            io::println("Char Error");
        default:
            io::println("Str Len Mismatch");
    } else {
        io::printf("%s", dt.time.toStr());
    }

    /*char* msg = "forth";
    char[] message = "busy";

    //reverse
    //io::printf("reverse : %s\n", strings::reverse(msg));
    io::printf("reverse : %s\n", strings::reverse(message));

    //len
    io::printf("len of \'%s\' is %hd\n", message, strings::len(message));
    io::printf("len of \'%s\' is %hd\n", msg, strings::len(msg));

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