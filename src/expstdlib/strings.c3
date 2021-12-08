module strings;
import std::io;

fn uint len(char* s) {
    int i = 0;
    uint length = 0;

    while (s[i] != '\0') {
        length++;
        i++;
    }

    return length;
}

fn short compare(char* s1, char* s2) {
    //io::printf("\ncompare strings: %s & %s\n", s1, s2);
    uint s1_len = len(s1);
    uint s2_len = len(s2);

    if (s1_len == s2_len) {
        for (int i = 0; i < s1_len; i++) {
            uint s1_val = (uint)(s1[i]);
            uint s2_val = (uint)(s2[i]);

            if (s1_val < s2_val) {
                return 1; //s2_val based on ascii
            } else if (s1_val > s2_val) {
                return -1; //s1_val based on ascii
            }
        }
        return 0;
    } else if (s1_len < s2_len) {
        return 1;
    } else {
        return -1;
    }
}

fn char* reverse(char[] s) {
    io::printf("%s", s);
    uint slen = len((char*)(s));
    io::printf("%hd", slen);
    uint j = slen - 1;
    io::printf("%c", s[j]);

    for (int i = 0; i < (slen / 2); i++) {
        char temp = s[i];
        s[i] = s[j];
        s[j] = temp;
        j--;
    }

    return s;
}

fn char* toUpper(char* s) {
    ushort ch_val;
    for (int i = 0; i <= len(s); i++) {
        ch_val = (ushort)(s[i]);
        if (ch_val > 96 && ch_val < 123) {
            s[i] = (char)(ch_val - 32);
        }
    }

    return s;
}

fn char* toLower(char* s) {
    ushort ch_val;
    for (int i = 0; i <= len(s); i++) {
        ch_val = (ushort)(s[i]);
        if (ch_val > 64 && ch_val < 91) {
            s[i] = (char)(ch_val + 32);
        }
    }

    return s;
}

/*fn char** split(char* s) {
    char[][] elements;
    ushort last_found;

    for(ushort i = 0; i < len(s); i++){
        if ()
    }
}*/

/*fn char* slice(char* s, int start_index, int end_index) {
    uint slen = len(s);
    char[end_index - start_index] subs;

    for (int i = start_index; i <= end_index; i++) {
        ch
    }

}*/

/*fn bool contains(char* str, char* sub_str) {
    //every string contains infinite sub-strings
    if (sub_str[0] == '\0') {
        return true;
    }

    bool matched = false;
    uint sub_str_len = len(sub_str);
    
    int i;
    while (i < sub_str_len) {
        if (str[i] == '\0') {
            return matched;
        }

        //if the first char matches, verify sub_str
        if (str[i] == sub_str[0]) {
            for (int j = i; j < sub_str_len; j++) {
                if (str[j] != sub_str[j]) {

                    return false;
                }
            }
        }
    }
}*/

/*fn uint count(char* s, char* subs) {
    //every string contains infinite sub-strings
    if (subs[0] == '\0') {
        return len(s);
    }

    uint subs_len = len(subs);
    uint s_len = len(s);
    if (s_len < subs_len) {
        return 0;
    }

    uint end_subs_i; 

    uint occurences = 0;
    for (int i = 0; i <= (s_len - subs_len); i++) {
        if (s[i] == subs[0]) {
            end_subs_i = i + subs_len - 1;
            short res = compare(substring(s, i, end_subs_i), subs);
            io::printf("%d\n", res);
            if (res == 0) {
                occurences++;
            }
        }
    }

    return occurences;
}*/