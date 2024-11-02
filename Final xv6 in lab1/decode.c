#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char uc_alphabet[26] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
                        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
char lc_alphabet[26] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p',
                        'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};

char *decode(char *c)
{
    // key = (40 + 75 + 1) mod 26 = 12
    int key = 12;
    for (int i = 0; i < strlen(c); i++)
        if ((int)c[i] >= (int)'a' && (int)c[i] <= (int)'z')
            c[i] = lc_alphabet[((int)c[i] - (int)'a' + 26 - key) % 26];
        else if ((int)c[i] >= (int)'A' && (int)c[i] <= (int)'Z')
            c[i] = uc_alphabet[((int)c[i] - (int)'A' + 26 - key) % 26];
    return c;
}

int main(int argc, char *argv[])
{
    if (argc <= 1)
    {
        printf(1, "There is no text\n");
        exit();
    }
    int fd = 0;
    if ((fd = open("result.txt", O_CREATE | O_RDWR)) < 0)
        printf(1, "Couldn't open the file");
    for (int i = 1; i < argc; i++)
    {
        char *c = decode(argv[i]);
        write(fd, c, strlen(argv[i]));
        if (i != argc - 1)
            write(fd, " ", 1);

        else
            write(fd, "\n", 1);
    }
    close(fd);
    exit();
}
