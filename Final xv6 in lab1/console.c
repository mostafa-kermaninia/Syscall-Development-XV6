// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

static void consputc(int);

static int panicked = 0;

static struct
{
  struct spinlock lock;
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do
  {
    buf[i++] = digits[x % base];
  } while ((x /= base) != 0);

  if (sign)
    buf[i++] = '-';

  while (--i >= 0)
    consputc(buf[i]);
}
// PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if (locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint *)(void *)(&fmt + 1);
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
  {
    if (c != '%')
    {
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if (c == 0)
      break;
    switch (c)
    {
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if ((s = (char *)*argp++) == 0)
        s = "(null)";
      for (; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if (locking)
    release(&cons.lock);
}

void panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for (i = 0; i < 10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for (;;)
    ;
}

// PAGEBREAK: 50
#define BACKSPACE 0x100
#define UP_ARROW 226
#define DOWN_ARROW 227
#define LEFT_ARROW 228
#define RIGHT_ARROW 229
#define CRTPORT 0x3d4
#define MAX_INDEX_HISTORY 10
static ushort *crt = (ushort *)P2V(0xb8000); // CGA memory

#define INPUT_BUF 128
struct
{
  char buf[INPUT_BUF];
  uint r; // Read index
  uint w; // Write index
  uint e; // Edit index
  uint c; // Cursor index
} input, copy_input, buf_history[MAX_INDEX_HISTORY];

int command_index = -1;
int num_saved_commands = 0;

int copying_index = 0;
int is_copying = 0;

static void
cgaputc(int c)
{
  int pos;
  int rst = input.e - input.c;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT + 1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT + 1);

  if (c == '\n')
    pos += 80 - pos % 80;
  else if (c == BACKSPACE)
  {
    if (pos > 0)
    {
      memmove(crt + pos - 1, crt + pos, sizeof(crt[0]) * rst);
      crt[--pos + rst] = ' ' | 0x0700;
    }
  }
  else if (c == LEFT_ARROW)
  {
    if (pos > 0)
      --pos;
  }
  else if (c == RIGHT_ARROW)
  {
    if (pos < 25 * 80 - 1)
      ++pos;
  }
  else
  {
    memmove(crt + pos + 1, crt + pos, sizeof(crt[0]) * rst);
    crt[pos++] = (c & 0xff) | 0x0700; // black on white
  }

  if (pos < 0 || pos > 25 * 80)
    panic("pos under/overflow");

  if ((pos / 80) >= 24)
  { // Scroll up.
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
    pos -= 80;
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT + 1, pos >> 8);
  outb(CRTPORT, 15);
  outb(CRTPORT + 1, pos);
  crt[pos] = crt[pos] | 0x0700;
}

void consputc(int c)
{
  if (panicked)
  {
    cli();
    for (;;)
      ;
  }

  if (c == BACKSPACE)
  {
    uartputc('\b');
    uartputc(' ');
    uartputc('\b');
  }
  else
    uartputc(c);
  cgaputc(c);
}

#define C(x) ((x) - '@') // Control-x

void calculator(int s_index, int end_index, char op, int op_index)
{
  int num1 = 0, num2 = 0, pos = 1, fraction = 0, int_ans = 0;
  int f_ans = 0, less_than1 = 0;
  for (int i = s_index; i < op_index; i++)
    num1 = num1 * 10 + input.buf[i % INPUT_BUF] - 48;
  for (int i = op_index + 1; i < end_index - 1; i++)
    num2 = num2 * 10 + input.buf[i % INPUT_BUF] - 48;
  switch (op)
  {
  case '%':
    f_ans = num1 % num2;
    break;
  case '-':
    f_ans = num1 - num2;
    break;
  case '+':
    f_ans = num1 + num2;
    break;
  case '/':
    f_ans = (10 * num1) / num2;
    int_ans = num1 / num2;
    break;
  case '*':
    f_ans = num1 * num2;
    break;
  default:
    break;
  }
  if (op == '/')
  {
    if (f_ans != 10 * int_ans)
    {
      fraction = 1;
      int_ans = f_ans;
      if (int_ans < 10)
        less_than1 = 1;
    }
  }
  else
    int_ans = f_ans;
  if (int_ans < 0)
  {
    int_ans = -int_ans;
    pos--;
  }
  int bias = input.c - end_index - 1;
  if (bias > 0)
    while (input.c != end_index + 1)
    {
      consputc(LEFT_ARROW);
      input.c--;
    }
  for (int i = input.c; i <= end_index; i++)
  {
    consputc(RIGHT_ARROW);
    input.c++;
  }
  for (int j = end_index + 1; j > s_index; j--)
  {
    for (uint i = input.c--; i != input.e; i++)
      input.buf[(i - 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
    input.e--;
    consputc(BACKSPACE);
  }
  if (pos == 0)
  {
    for (uint i = input.e++; i != input.c; i--)
      input.buf[i % INPUT_BUF] = input.buf[(i - 1) % INPUT_BUF];
    input.buf[input.c++ % INPUT_BUF] = '-';
    consputc('-');
  }
  int num_digits = 0;
  do
  {
    num_digits++;
    int a = int_ans % 10 + 48;
    int_ans /= 10;
    for (uint i = input.e++; i != input.c; i--)
      input.buf[i % INPUT_BUF] = input.buf[(i - 1) % INPUT_BUF];
    if (fraction == 1 && num_digits > 1)
    {
      fraction = 0;
      int_ans *= 10;
      int_ans += a - 48;
      input.buf[input.c++ % INPUT_BUF] = (int)'.';
    }
    else if (less_than1 == 1 && int_ans == 0 && a == (int)'0')
    {
      less_than1 = 0;
      input.buf[input.c++ % INPUT_BUF] = (int)'0';
    }
    else
      input.buf[input.c++ % INPUT_BUF] = a;

  } while (int_ans != 0 || less_than1);

  for (int i = 0; i < num_digits / 2; i++)
  {
    int temp = input.buf[(input.c - 1 - i) % INPUT_BUF];
    input.buf[(input.c - 1 - i) % INPUT_BUF] = input.buf[(input.c - (num_digits - i)) % INPUT_BUF];
    input.buf[(input.c - (num_digits - i)) % INPUT_BUF] = temp;
  }
  if (pos == 0)
    s_index++;
  for (int i = 0; i < num_digits; i++)
  {
    consputc(input.buf[(i + s_index) % INPUT_BUF]);
  }
  while (bias > 0)
  {
    consputc(RIGHT_ARROW);
    input.c++;
    bias--;
  }
}

void mathexp_finder(int qmark_pos)
{
  int isnt_exp = 0;
  int i = qmark_pos - 1;
  if (input.buf[i % INPUT_BUF] == '=')
  {
    i--;
    if (0 <= (int)input.buf[i % INPUT_BUF] - 48 && (int)input.buf[i % INPUT_BUF] - 48 < 10)
    {
      int flag = 0;
      while (0 <= (int)input.buf[i % INPUT_BUF] - 48 && (int)input.buf[i % INPUT_BUF] - 48 < 10)
      {
        i--;
      }
      if (i == input.e - 2)
        flag = 1;
      char op = input.buf[i % INPUT_BUF];
      if (op == '%' || op == '+' || op == '-' || op == '*' || op == '/')
        i--;
      else
        flag = 1;
      int op_index = i + 1;
      while (0 <= (int)input.buf[i % INPUT_BUF] - 48 && (int)input.buf[i % INPUT_BUF] - 48 < 10)
      {
        i--;
      }
      if (i == op_index - 1)
        flag = 1;
      if (flag == 1)
        isnt_exp = 1;
      if (isnt_exp == 0)
      {
        calculator(i + 1, qmark_pos, op, op_index);
      }
    }
  }
}

void search_buf()
{
  for (int i = input.w; i < input.e; i++)
  {
    if (input.buf[i % INPUT_BUF] == '?')
    {
      mathexp_finder(i);
    }
  }
}

void consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while ((c = getc()) >= 0)
  {
    switch (c)
    {
    case C('P'): // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'): // Kill line.
      while (input.c != input.e)
      {
        input.c++;
        consputc(RIGHT_ARROW);
      }
      while (input.e != input.w &&
             input.buf[(input.e - 1) % INPUT_BUF] != '\n')
      {
        input.c--;
        input.e--;
        consputc(BACKSPACE);
      }
      if (is_copying == 1)
        copying_index = 0;
      break;
    case C('H'):
    case '\x7f': // Backspace
      // if(input.e != input.w){
      if (input.c != input.w)
      {
        // input.e--;
        if (is_copying == 1 && copying_index > input.c)
          copying_index--;
        for (uint i = input.c--; i != input.e; i++)
          input.buf[(i - 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case LEFT_ARROW:
      if (input.c != input.w)
      {
        input.c--;
        consputc(LEFT_ARROW);
      }
      break;
    case RIGHT_ARROW:
      if (input.c != input.e)
      {
        input.c++;
        consputc(RIGHT_ARROW);
      }
      break;
    case UP_ARROW:
      if (command_index < num_saved_commands - 1)
      {
        command_index++;
        while (input.c != input.e)
        {
          input.c++;
          consputc(RIGHT_ARROW);
        }
        for (uint i = input.e; i != input.w; i--)
          consputc(BACKSPACE);
        input = buf_history[command_index];
        for (uint i = input.w; i != input.e; i++)
          if (input.buf[i % INPUT_BUF] != '\n')
            consputc(input.buf[i % INPUT_BUF]);
      }
      break;
    case DOWN_ARROW:
      if (command_index > 0)
      {
        command_index--;
        while (input.c != input.e)
        {
          input.c++;
          consputc(RIGHT_ARROW);
        }
        for (uint i = input.e; i != input.w; i--)
          consputc(BACKSPACE);
        input = buf_history[command_index];
        for (uint i = input.w; i != input.e; i++)
          if (input.buf[i % INPUT_BUF] != '\n')
            consputc(input.buf[i % INPUT_BUF]);
      }
      break;
    case C('S'):
      if (is_copying == 0)
      {
        copying_index = input.c;
        is_copying = 1;
      }
      break;
    case C('F'):
      if (is_copying == 1)
      {
        is_copying = 0;
        int end_index = input.c;
        for (int j = copying_index; j < end_index; j++)
        {
          if (input.buf[j % INPUT_BUF] != '\n')
          {
            for (uint i = input.e++; i != input.c; i--)
              input.buf[i % INPUT_BUF] = input.buf[(i - 1) % INPUT_BUF];
            input.buf[input.c++ % INPUT_BUF] = input.buf[j % INPUT_BUF];
          }
          else
            input.buf[input.e++ % INPUT_BUF] = input.buf[j % INPUT_BUF];
          consputc(input.buf[j % INPUT_BUF]);
        }
      }

      break;
    default:
      if (c != 0 && input.e - input.r < INPUT_BUF)
      {
        c = (c == '\r') ? '\n' : c;
        // input.buf[input.e++ % INPUT_BUF] = c;
        if (c != '\n')
        {
          for (uint i = input.e++; i != input.c; i--)
            input.buf[i % INPUT_BUF] = input.buf[(i - 1) % INPUT_BUF];
          input.buf[input.c++ % INPUT_BUF] = c;
          if (is_copying == 1 && copying_index >= input.c)
            copying_index++;
        }
        else
          input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF)
        {
          copy_input = input;
          copy_input.e--;
          command_index = -1;
          input.w = input.e;
          input.c = input.e;
          wakeup(&input.r);
        }
        if (c == '\n' && copy_input.e - copy_input.w != 0)
        {
          for (int i = 9; i > 0; i--)
          {
            buf_history[i] = buf_history[i - 1];
          }
          copy_input.c = copy_input.e;
          buf_history[0] = copy_input;
          if (num_saved_commands < MAX_INDEX_HISTORY)
            num_saved_commands++;
        }
      }
      break;
    }
  }
  search_buf();
  release(&cons.lock);
  if (doprocdump)
  {
    procdump(); // now call procdump() wo. cons.lock held
  }
}

int consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while (n > 0)
  {
    while (input.r == input.w)
    {
      if (myproc()->killed)
      {
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if (c == C('D'))
    { // EOF
      if (n < target)
      {
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if (c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for (i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}
