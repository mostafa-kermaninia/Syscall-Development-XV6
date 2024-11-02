#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  for(int i = 1; i < argc; i++)
    printf(1, argv[i]);
  exit();
}