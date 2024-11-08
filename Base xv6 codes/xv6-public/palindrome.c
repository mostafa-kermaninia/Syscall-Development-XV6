#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf(1, "Didn't enter the number\n");
        exit();
    }
    int num = atoi(argv[1]);
    create_palindrome(num);
    exit();
}