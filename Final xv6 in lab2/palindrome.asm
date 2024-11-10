
_palindrome:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    create_palindrome();
    asm volatile("movl %0, %%ebx" : : "r"(perv_val));
}

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    if (argc < 2)
   f:	83 39 01             	cmpl   $0x1,(%ecx)
{
  12:	8b 41 04             	mov    0x4(%ecx),%eax
    if (argc < 2)
  15:	7e 1b                	jle    32 <main+0x32>
    {
        printf(1, "Didn't enter the number\n");
        exit();
    }
    int num = atoi(argv[1]);
  17:	83 ec 0c             	sub    $0xc,%esp
  1a:	ff 70 04             	push   0x4(%eax)
  1d:	e8 1e 02 00 00       	call   240 <atoi>
    asm volatile(
  22:	89 db                	mov    %ebx,%ebx
  24:	89 c3                	mov    %eax,%ebx
    create_palindrome();
  26:	e8 28 03 00 00       	call   353 <create_palindrome>
    asm volatile("movl %0, %%ebx" : : "r"(perv_val));
  2b:	89 db                	mov    %ebx,%ebx
    create_palindrome1(num);
    exit();
  2d:	e8 81 02 00 00       	call   2b3 <exit>
        printf(1, "Didn't enter the number\n");
  32:	50                   	push   %eax
  33:	50                   	push   %eax
  34:	68 28 07 00 00       	push   $0x728
  39:	6a 01                	push   $0x1
  3b:	e8 e0 03 00 00       	call   420 <printf>
        exit();
  40:	e8 6e 02 00 00       	call   2b3 <exit>
  45:	66 90                	xchg   %ax,%ax
  47:	66 90                	xchg   %ax,%ax
  49:	66 90                	xchg   %ax,%ax
  4b:	66 90                	xchg   %ax,%ax
  4d:	66 90                	xchg   %ax,%ax
  4f:	90                   	nop

00000050 <create_palindrome1>:
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	53                   	push   %ebx
  54:	83 ec 04             	sub    $0x4,%esp
    asm volatile(
  57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  5a:	89 db                	mov    %ebx,%ebx
  5c:	89 db                	mov    %ebx,%ebx
    create_palindrome();
  5e:	e8 f0 02 00 00       	call   353 <create_palindrome>
    asm volatile("movl %0, %%ebx" : : "r"(perv_val));
  63:	89 db                	mov    %ebx,%ebx
}
  65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  68:	c9                   	leave
  69:	c3                   	ret
  6a:	66 90                	xchg   %ax,%ax
  6c:	66 90                	xchg   %ax,%ax
  6e:	66 90                	xchg   %ax,%ax

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  70:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  71:	31 c0                	xor    %eax,%eax
{
  73:	89 e5                	mov    %esp,%ebp
  75:	53                   	push   %ebx
  76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  80:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  84:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  87:	83 c0 01             	add    $0x1,%eax
  8a:	84 d2                	test   %dl,%dl
  8c:	75 f2                	jne    80 <strcpy+0x10>
    ;
  return os;
}
  8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  91:	89 c8                	mov    %ecx,%eax
  93:	c9                   	leave
  94:	c3                   	ret
  95:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  9c:	00 
  9d:	8d 76 00             	lea    0x0(%esi),%esi

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	53                   	push   %ebx
  a4:	8b 55 08             	mov    0x8(%ebp),%edx
  a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  aa:	0f b6 02             	movzbl (%edx),%eax
  ad:	84 c0                	test   %al,%al
  af:	75 17                	jne    c8 <strcmp+0x28>
  b1:	eb 3a                	jmp    ed <strcmp+0x4d>
  b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  bc:	83 c2 01             	add    $0x1,%edx
  bf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  c2:	84 c0                	test   %al,%al
  c4:	74 1a                	je     e0 <strcmp+0x40>
  c6:	89 d9                	mov    %ebx,%ecx
  c8:	0f b6 19             	movzbl (%ecx),%ebx
  cb:	38 c3                	cmp    %al,%bl
  cd:	74 e9                	je     b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  cf:	29 d8                	sub    %ebx,%eax
}
  d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d4:	c9                   	leave
  d5:	c3                   	ret
  d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  dd:	00 
  de:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
  e0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  e4:	31 c0                	xor    %eax,%eax
  e6:	29 d8                	sub    %ebx,%eax
}
  e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  eb:	c9                   	leave
  ec:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  ed:	0f b6 19             	movzbl (%ecx),%ebx
  f0:	31 c0                	xor    %eax,%eax
  f2:	eb db                	jmp    cf <strcmp+0x2f>
  f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  fb:	00 
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000100 <strlen>:

uint
strlen(const char *s)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 106:	80 3a 00             	cmpb   $0x0,(%edx)
 109:	74 15                	je     120 <strlen+0x20>
 10b:	31 c0                	xor    %eax,%eax
 10d:	8d 76 00             	lea    0x0(%esi),%esi
 110:	83 c0 01             	add    $0x1,%eax
 113:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 117:	89 c1                	mov    %eax,%ecx
 119:	75 f5                	jne    110 <strlen+0x10>
    ;
  return n;
}
 11b:	89 c8                	mov    %ecx,%eax
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret
 11f:	90                   	nop
  for(n = 0; s[n]; n++)
 120:	31 c9                	xor    %ecx,%ecx
}
 122:	5d                   	pop    %ebp
 123:	89 c8                	mov    %ecx,%eax
 125:	c3                   	ret
 126:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 12d:	00 
 12e:	66 90                	xchg   %ax,%ax

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	57                   	push   %edi
 134:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 137:	8b 4d 10             	mov    0x10(%ebp),%ecx
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	89 d7                	mov    %edx,%edi
 13f:	fc                   	cld
 140:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 142:	8b 7d fc             	mov    -0x4(%ebp),%edi
 145:	89 d0                	mov    %edx,%eax
 147:	c9                   	leave
 148:	c3                   	ret
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 15a:	0f b6 10             	movzbl (%eax),%edx
 15d:	84 d2                	test   %dl,%dl
 15f:	75 12                	jne    173 <strchr+0x23>
 161:	eb 1d                	jmp    180 <strchr+0x30>
 163:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 168:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 16c:	83 c0 01             	add    $0x1,%eax
 16f:	84 d2                	test   %dl,%dl
 171:	74 0d                	je     180 <strchr+0x30>
    if(*s == c)
 173:	38 d1                	cmp    %dl,%cl
 175:	75 f1                	jne    168 <strchr+0x18>
      return (char*)s;
  return 0;
}
 177:	5d                   	pop    %ebp
 178:	c3                   	ret
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 180:	31 c0                	xor    %eax,%eax
}
 182:	5d                   	pop    %ebp
 183:	c3                   	ret
 184:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 18b:	00 
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000190 <gets>:

char*
gets(char *buf, int max)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 195:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 198:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 199:	31 db                	xor    %ebx,%ebx
{
 19b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 19e:	eb 27                	jmp    1c7 <gets+0x37>
    cc = read(0, &c, 1);
 1a0:	83 ec 04             	sub    $0x4,%esp
 1a3:	6a 01                	push   $0x1
 1a5:	56                   	push   %esi
 1a6:	6a 00                	push   $0x0
 1a8:	e8 1e 01 00 00       	call   2cb <read>
    if(cc < 1)
 1ad:	83 c4 10             	add    $0x10,%esp
 1b0:	85 c0                	test   %eax,%eax
 1b2:	7e 1d                	jle    1d1 <gets+0x41>
      break;
    buf[i++] = c;
 1b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1b8:	8b 55 08             	mov    0x8(%ebp),%edx
 1bb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1bf:	3c 0a                	cmp    $0xa,%al
 1c1:	74 10                	je     1d3 <gets+0x43>
 1c3:	3c 0d                	cmp    $0xd,%al
 1c5:	74 0c                	je     1d3 <gets+0x43>
  for(i=0; i+1 < max; ){
 1c7:	89 df                	mov    %ebx,%edi
 1c9:	83 c3 01             	add    $0x1,%ebx
 1cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1cf:	7c cf                	jl     1a0 <gets+0x10>
 1d1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1dd:	5b                   	pop    %ebx
 1de:	5e                   	pop    %esi
 1df:	5f                   	pop    %edi
 1e0:	5d                   	pop    %ebp
 1e1:	c3                   	ret
 1e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1e9:	00 
 1ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	6a 00                	push   $0x0
 1fa:	ff 75 08             	push   0x8(%ebp)
 1fd:	e8 f1 00 00 00       	call   2f3 <open>
  if(fd < 0)
 202:	83 c4 10             	add    $0x10,%esp
 205:	85 c0                	test   %eax,%eax
 207:	78 27                	js     230 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 209:	83 ec 08             	sub    $0x8,%esp
 20c:	ff 75 0c             	push   0xc(%ebp)
 20f:	89 c3                	mov    %eax,%ebx
 211:	50                   	push   %eax
 212:	e8 f4 00 00 00       	call   30b <fstat>
  close(fd);
 217:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 21a:	89 c6                	mov    %eax,%esi
  close(fd);
 21c:	e8 ba 00 00 00       	call   2db <close>
  return r;
 221:	83 c4 10             	add    $0x10,%esp
}
 224:	8d 65 f8             	lea    -0x8(%ebp),%esp
 227:	89 f0                	mov    %esi,%eax
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret
 22d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 230:	be ff ff ff ff       	mov    $0xffffffff,%esi
 235:	eb ed                	jmp    224 <stat+0x34>
 237:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 23e:	00 
 23f:	90                   	nop

00000240 <atoi>:

int
atoi(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 247:	0f be 02             	movsbl (%edx),%eax
 24a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 24d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 250:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 255:	77 1e                	ja     275 <atoi+0x35>
 257:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 25e:	00 
 25f:	90                   	nop
    n = n*10 + *s++ - '0';
 260:	83 c2 01             	add    $0x1,%edx
 263:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 266:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 26a:	0f be 02             	movsbl (%edx),%eax
 26d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 270:	80 fb 09             	cmp    $0x9,%bl
 273:	76 eb                	jbe    260 <atoi+0x20>
  return n;
}
 275:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 278:	89 c8                	mov    %ecx,%eax
 27a:	c9                   	leave
 27b:	c3                   	ret
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000280 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	8b 45 10             	mov    0x10(%ebp),%eax
 287:	8b 55 08             	mov    0x8(%ebp),%edx
 28a:	56                   	push   %esi
 28b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28e:	85 c0                	test   %eax,%eax
 290:	7e 13                	jle    2a5 <memmove+0x25>
 292:	01 d0                	add    %edx,%eax
  dst = vdst;
 294:	89 d7                	mov    %edx,%edi
 296:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 29d:	00 
 29e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2a1:	39 f8                	cmp    %edi,%eax
 2a3:	75 fb                	jne    2a0 <memmove+0x20>
  return vdst;
}
 2a5:	5e                   	pop    %esi
 2a6:	89 d0                	mov    %edx,%eax
 2a8:	5f                   	pop    %edi
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret

000002ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ab:	b8 01 00 00 00       	mov    $0x1,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <exit>:
SYSCALL(exit)
 2b3:	b8 02 00 00 00       	mov    $0x2,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <wait>:
SYSCALL(wait)
 2bb:	b8 03 00 00 00       	mov    $0x3,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <pipe>:
SYSCALL(pipe)
 2c3:	b8 04 00 00 00       	mov    $0x4,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <read>:
SYSCALL(read)
 2cb:	b8 05 00 00 00       	mov    $0x5,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <write>:
SYSCALL(write)
 2d3:	b8 10 00 00 00       	mov    $0x10,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <close>:
SYSCALL(close)
 2db:	b8 15 00 00 00       	mov    $0x15,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <kill>:
SYSCALL(kill)
 2e3:	b8 06 00 00 00       	mov    $0x6,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <exec>:
SYSCALL(exec)
 2eb:	b8 07 00 00 00       	mov    $0x7,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <open>:
SYSCALL(open)
 2f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <mknod>:
SYSCALL(mknod)
 2fb:	b8 11 00 00 00       	mov    $0x11,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <unlink>:
SYSCALL(unlink)
 303:	b8 12 00 00 00       	mov    $0x12,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <fstat>:
SYSCALL(fstat)
 30b:	b8 08 00 00 00       	mov    $0x8,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <link>:
SYSCALL(link)
 313:	b8 13 00 00 00       	mov    $0x13,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <mkdir>:
SYSCALL(mkdir)
 31b:	b8 14 00 00 00       	mov    $0x14,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <chdir>:
SYSCALL(chdir)
 323:	b8 09 00 00 00       	mov    $0x9,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <dup>:
SYSCALL(dup)
 32b:	b8 0a 00 00 00       	mov    $0xa,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <getpid>:
SYSCALL(getpid)
 333:	b8 0b 00 00 00       	mov    $0xb,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <sbrk>:
SYSCALL(sbrk)
 33b:	b8 0c 00 00 00       	mov    $0xc,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <sleep>:
SYSCALL(sleep)
 343:	b8 0d 00 00 00       	mov    $0xd,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <uptime>:
SYSCALL(uptime)
 34b:	b8 0e 00 00 00       	mov    $0xe,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <create_palindrome>:
SYSCALL(create_palindrome)
 353:	b8 16 00 00 00       	mov    $0x16,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <move_file>:
SYSCALL(move_file)
 35b:	b8 17 00 00 00       	mov    $0x17,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <sort_syscalls>:
SYSCALL(sort_syscalls)
 363:	b8 18 00 00 00       	mov    $0x18,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <list_all_processes>:
SYSCALL(list_all_processes)
 36b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret
 373:	66 90                	xchg   %ax,%ax
 375:	66 90                	xchg   %ax,%ax
 377:	66 90                	xchg   %ax,%ax
 379:	66 90                	xchg   %ax,%ax
 37b:	66 90                	xchg   %ax,%ax
 37d:	66 90                	xchg   %ax,%ax
 37f:	90                   	nop

00000380 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
 386:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 388:	89 d1                	mov    %edx,%ecx
{
 38a:	83 ec 3c             	sub    $0x3c,%esp
 38d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 390:	85 d2                	test   %edx,%edx
 392:	0f 89 80 00 00 00    	jns    418 <printint+0x98>
 398:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 39c:	74 7a                	je     418 <printint+0x98>
    x = -xx;
 39e:	f7 d9                	neg    %ecx
    neg = 1;
 3a0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 3a5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3a8:	31 f6                	xor    %esi,%esi
 3aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3b0:	89 c8                	mov    %ecx,%eax
 3b2:	31 d2                	xor    %edx,%edx
 3b4:	89 f7                	mov    %esi,%edi
 3b6:	f7 f3                	div    %ebx
 3b8:	8d 76 01             	lea    0x1(%esi),%esi
 3bb:	0f b6 92 a0 07 00 00 	movzbl 0x7a0(%edx),%edx
 3c2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 3c6:	89 ca                	mov    %ecx,%edx
 3c8:	89 c1                	mov    %eax,%ecx
 3ca:	39 da                	cmp    %ebx,%edx
 3cc:	73 e2                	jae    3b0 <printint+0x30>
  if(neg)
 3ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3d1:	85 c0                	test   %eax,%eax
 3d3:	74 07                	je     3dc <printint+0x5c>
    buf[i++] = '-';
 3d5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 3da:	89 f7                	mov    %esi,%edi
 3dc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3df:	8b 75 c0             	mov    -0x40(%ebp),%esi
 3e2:	01 df                	add    %ebx,%edi
 3e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 3e8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 3eb:	83 ec 04             	sub    $0x4,%esp
 3ee:	88 45 d7             	mov    %al,-0x29(%ebp)
 3f1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 3f4:	6a 01                	push   $0x1
 3f6:	50                   	push   %eax
 3f7:	56                   	push   %esi
 3f8:	e8 d6 fe ff ff       	call   2d3 <write>
  while(--i >= 0)
 3fd:	89 f8                	mov    %edi,%eax
 3ff:	83 c4 10             	add    $0x10,%esp
 402:	83 ef 01             	sub    $0x1,%edi
 405:	39 c3                	cmp    %eax,%ebx
 407:	75 df                	jne    3e8 <printint+0x68>
}
 409:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40c:	5b                   	pop    %ebx
 40d:	5e                   	pop    %esi
 40e:	5f                   	pop    %edi
 40f:	5d                   	pop    %ebp
 410:	c3                   	ret
 411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 418:	31 c0                	xor    %eax,%eax
 41a:	eb 89                	jmp    3a5 <printint+0x25>
 41c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000420 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
 426:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 429:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 42c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 42f:	0f b6 1e             	movzbl (%esi),%ebx
 432:	83 c6 01             	add    $0x1,%esi
 435:	84 db                	test   %bl,%bl
 437:	74 67                	je     4a0 <printf+0x80>
 439:	8d 4d 10             	lea    0x10(%ebp),%ecx
 43c:	31 d2                	xor    %edx,%edx
 43e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 441:	eb 34                	jmp    477 <printf+0x57>
 443:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 448:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 44b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 450:	83 f8 25             	cmp    $0x25,%eax
 453:	74 18                	je     46d <printf+0x4d>
  write(fd, &c, 1);
 455:	83 ec 04             	sub    $0x4,%esp
 458:	8d 45 e7             	lea    -0x19(%ebp),%eax
 45b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 45e:	6a 01                	push   $0x1
 460:	50                   	push   %eax
 461:	57                   	push   %edi
 462:	e8 6c fe ff ff       	call   2d3 <write>
 467:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 46a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 46d:	0f b6 1e             	movzbl (%esi),%ebx
 470:	83 c6 01             	add    $0x1,%esi
 473:	84 db                	test   %bl,%bl
 475:	74 29                	je     4a0 <printf+0x80>
    c = fmt[i] & 0xff;
 477:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 47a:	85 d2                	test   %edx,%edx
 47c:	74 ca                	je     448 <printf+0x28>
      }
    } else if(state == '%'){
 47e:	83 fa 25             	cmp    $0x25,%edx
 481:	75 ea                	jne    46d <printf+0x4d>
      if(c == 'd'){
 483:	83 f8 25             	cmp    $0x25,%eax
 486:	0f 84 04 01 00 00    	je     590 <printf+0x170>
 48c:	83 e8 63             	sub    $0x63,%eax
 48f:	83 f8 15             	cmp    $0x15,%eax
 492:	77 1c                	ja     4b0 <printf+0x90>
 494:	ff 24 85 48 07 00 00 	jmp    *0x748(,%eax,4)
 49b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a3:	5b                   	pop    %ebx
 4a4:	5e                   	pop    %esi
 4a5:	5f                   	pop    %edi
 4a6:	5d                   	pop    %ebp
 4a7:	c3                   	ret
 4a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4af:	00 
  write(fd, &c, 1);
 4b0:	83 ec 04             	sub    $0x4,%esp
 4b3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4b6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4ba:	6a 01                	push   $0x1
 4bc:	52                   	push   %edx
 4bd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4c0:	57                   	push   %edi
 4c1:	e8 0d fe ff ff       	call   2d3 <write>
 4c6:	83 c4 0c             	add    $0xc,%esp
 4c9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4cc:	6a 01                	push   $0x1
 4ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4d1:	52                   	push   %edx
 4d2:	57                   	push   %edi
 4d3:	e8 fb fd ff ff       	call   2d3 <write>
        putc(fd, c);
 4d8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4db:	31 d2                	xor    %edx,%edx
 4dd:	eb 8e                	jmp    46d <printf+0x4d>
 4df:	90                   	nop
        printint(fd, *ap, 16, 0);
 4e0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4e3:	83 ec 0c             	sub    $0xc,%esp
 4e6:	b9 10 00 00 00       	mov    $0x10,%ecx
 4eb:	8b 13                	mov    (%ebx),%edx
 4ed:	6a 00                	push   $0x0
 4ef:	89 f8                	mov    %edi,%eax
        ap++;
 4f1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 4f4:	e8 87 fe ff ff       	call   380 <printint>
        ap++;
 4f9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4fc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ff:	31 d2                	xor    %edx,%edx
 501:	e9 67 ff ff ff       	jmp    46d <printf+0x4d>
        s = (char*)*ap;
 506:	8b 45 d0             	mov    -0x30(%ebp),%eax
 509:	8b 18                	mov    (%eax),%ebx
        ap++;
 50b:	83 c0 04             	add    $0x4,%eax
 50e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 511:	85 db                	test   %ebx,%ebx
 513:	0f 84 87 00 00 00    	je     5a0 <printf+0x180>
        while(*s != 0){
 519:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 51c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 51e:	84 c0                	test   %al,%al
 520:	0f 84 47 ff ff ff    	je     46d <printf+0x4d>
 526:	8d 55 e7             	lea    -0x19(%ebp),%edx
 529:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 52c:	89 de                	mov    %ebx,%esi
 52e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 530:	83 ec 04             	sub    $0x4,%esp
 533:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 536:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 539:	6a 01                	push   $0x1
 53b:	53                   	push   %ebx
 53c:	57                   	push   %edi
 53d:	e8 91 fd ff ff       	call   2d3 <write>
        while(*s != 0){
 542:	0f b6 06             	movzbl (%esi),%eax
 545:	83 c4 10             	add    $0x10,%esp
 548:	84 c0                	test   %al,%al
 54a:	75 e4                	jne    530 <printf+0x110>
      state = 0;
 54c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 54f:	31 d2                	xor    %edx,%edx
 551:	e9 17 ff ff ff       	jmp    46d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 556:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 559:	83 ec 0c             	sub    $0xc,%esp
 55c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 561:	8b 13                	mov    (%ebx),%edx
 563:	6a 01                	push   $0x1
 565:	eb 88                	jmp    4ef <printf+0xcf>
        putc(fd, *ap);
 567:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 56a:	83 ec 04             	sub    $0x4,%esp
 56d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 570:	8b 03                	mov    (%ebx),%eax
        ap++;
 572:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 575:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 578:	6a 01                	push   $0x1
 57a:	52                   	push   %edx
 57b:	57                   	push   %edi
 57c:	e8 52 fd ff ff       	call   2d3 <write>
        ap++;
 581:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 584:	83 c4 10             	add    $0x10,%esp
      state = 0;
 587:	31 d2                	xor    %edx,%edx
 589:	e9 df fe ff ff       	jmp    46d <printf+0x4d>
 58e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 590:	83 ec 04             	sub    $0x4,%esp
 593:	88 5d e7             	mov    %bl,-0x19(%ebp)
 596:	8d 55 e7             	lea    -0x19(%ebp),%edx
 599:	6a 01                	push   $0x1
 59b:	e9 31 ff ff ff       	jmp    4d1 <printf+0xb1>
 5a0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 5a5:	bb 41 07 00 00       	mov    $0x741,%ebx
 5aa:	e9 77 ff ff ff       	jmp    526 <printf+0x106>
 5af:	90                   	nop

000005b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b1:	a1 64 0a 00 00       	mov    0xa64,%eax
{
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	57                   	push   %edi
 5b9:	56                   	push   %esi
 5ba:	53                   	push   %ebx
 5bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ca:	39 c8                	cmp    %ecx,%eax
 5cc:	73 32                	jae    600 <free+0x50>
 5ce:	39 d1                	cmp    %edx,%ecx
 5d0:	72 04                	jb     5d6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d2:	39 d0                	cmp    %edx,%eax
 5d4:	72 32                	jb     608 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5d9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5dc:	39 fa                	cmp    %edi,%edx
 5de:	74 30                	je     610 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5e0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5e3:	8b 50 04             	mov    0x4(%eax),%edx
 5e6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5e9:	39 f1                	cmp    %esi,%ecx
 5eb:	74 3a                	je     627 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5ed:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 5ef:	5b                   	pop    %ebx
  freep = p;
 5f0:	a3 64 0a 00 00       	mov    %eax,0xa64
}
 5f5:	5e                   	pop    %esi
 5f6:	5f                   	pop    %edi
 5f7:	5d                   	pop    %ebp
 5f8:	c3                   	ret
 5f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 600:	39 d0                	cmp    %edx,%eax
 602:	72 04                	jb     608 <free+0x58>
 604:	39 d1                	cmp    %edx,%ecx
 606:	72 ce                	jb     5d6 <free+0x26>
{
 608:	89 d0                	mov    %edx,%eax
 60a:	eb bc                	jmp    5c8 <free+0x18>
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 610:	03 72 04             	add    0x4(%edx),%esi
 613:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 616:	8b 10                	mov    (%eax),%edx
 618:	8b 12                	mov    (%edx),%edx
 61a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 61d:	8b 50 04             	mov    0x4(%eax),%edx
 620:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 623:	39 f1                	cmp    %esi,%ecx
 625:	75 c6                	jne    5ed <free+0x3d>
    p->s.size += bp->s.size;
 627:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 62a:	a3 64 0a 00 00       	mov    %eax,0xa64
    p->s.size += bp->s.size;
 62f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 632:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 635:	89 08                	mov    %ecx,(%eax)
}
 637:	5b                   	pop    %ebx
 638:	5e                   	pop    %esi
 639:	5f                   	pop    %edi
 63a:	5d                   	pop    %ebp
 63b:	c3                   	ret
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000640 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 649:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 64c:	8b 15 64 0a 00 00    	mov    0xa64,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 652:	8d 78 07             	lea    0x7(%eax),%edi
 655:	c1 ef 03             	shr    $0x3,%edi
 658:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 65b:	85 d2                	test   %edx,%edx
 65d:	0f 84 8d 00 00 00    	je     6f0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 663:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 665:	8b 48 04             	mov    0x4(%eax),%ecx
 668:	39 f9                	cmp    %edi,%ecx
 66a:	73 64                	jae    6d0 <malloc+0x90>
  if(nu < 4096)
 66c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 671:	39 df                	cmp    %ebx,%edi
 673:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 676:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 67d:	eb 0a                	jmp    689 <malloc+0x49>
 67f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 680:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 682:	8b 48 04             	mov    0x4(%eax),%ecx
 685:	39 f9                	cmp    %edi,%ecx
 687:	73 47                	jae    6d0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 689:	89 c2                	mov    %eax,%edx
 68b:	3b 05 64 0a 00 00    	cmp    0xa64,%eax
 691:	75 ed                	jne    680 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 693:	83 ec 0c             	sub    $0xc,%esp
 696:	56                   	push   %esi
 697:	e8 9f fc ff ff       	call   33b <sbrk>
  if(p == (char*)-1)
 69c:	83 c4 10             	add    $0x10,%esp
 69f:	83 f8 ff             	cmp    $0xffffffff,%eax
 6a2:	74 1c                	je     6c0 <malloc+0x80>
  hp->s.size = nu;
 6a4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6a7:	83 ec 0c             	sub    $0xc,%esp
 6aa:	83 c0 08             	add    $0x8,%eax
 6ad:	50                   	push   %eax
 6ae:	e8 fd fe ff ff       	call   5b0 <free>
  return freep;
 6b3:	8b 15 64 0a 00 00    	mov    0xa64,%edx
      if((p = morecore(nunits)) == 0)
 6b9:	83 c4 10             	add    $0x10,%esp
 6bc:	85 d2                	test   %edx,%edx
 6be:	75 c0                	jne    680 <malloc+0x40>
        return 0;
  }
}
 6c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6c3:	31 c0                	xor    %eax,%eax
}
 6c5:	5b                   	pop    %ebx
 6c6:	5e                   	pop    %esi
 6c7:	5f                   	pop    %edi
 6c8:	5d                   	pop    %ebp
 6c9:	c3                   	ret
 6ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6d0:	39 cf                	cmp    %ecx,%edi
 6d2:	74 4c                	je     720 <malloc+0xe0>
        p->s.size -= nunits;
 6d4:	29 f9                	sub    %edi,%ecx
 6d6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6d9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6dc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6df:	89 15 64 0a 00 00    	mov    %edx,0xa64
}
 6e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 6e8:	83 c0 08             	add    $0x8,%eax
}
 6eb:	5b                   	pop    %ebx
 6ec:	5e                   	pop    %esi
 6ed:	5f                   	pop    %edi
 6ee:	5d                   	pop    %ebp
 6ef:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 6f0:	c7 05 64 0a 00 00 68 	movl   $0xa68,0xa64
 6f7:	0a 00 00 
    base.s.size = 0;
 6fa:	b8 68 0a 00 00       	mov    $0xa68,%eax
    base.s.ptr = freep = prevp = &base;
 6ff:	c7 05 68 0a 00 00 68 	movl   $0xa68,0xa68
 706:	0a 00 00 
    base.s.size = 0;
 709:	c7 05 6c 0a 00 00 00 	movl   $0x0,0xa6c
 710:	00 00 00 
    if(p->s.size >= nunits){
 713:	e9 54 ff ff ff       	jmp    66c <malloc+0x2c>
 718:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 71f:	00 
        prevp->s.ptr = p->s.ptr;
 720:	8b 08                	mov    (%eax),%ecx
 722:	89 0a                	mov    %ecx,(%edx)
 724:	eb b9                	jmp    6df <malloc+0x9f>
