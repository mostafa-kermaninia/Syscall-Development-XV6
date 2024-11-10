
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 e5 11 80       	mov    $0x8011e5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 30 10 80       	mov    $0x80103030,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 75 10 80       	push   $0x80107580
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 95 45 00 00       	call   801045f0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 75 10 80       	push   $0x80107587
80100097:	50                   	push   %eax
80100098:	e8 23 44 00 00       	call   801044c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 f7 46 00 00       	call   801047e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 19 46 00 00       	call   80104780 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 43 00 00       	call   80104500 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 3f 21 00 00       	call   801022d0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 8e 75 10 80       	push   $0x8010758e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 dd 43 00 00       	call   801045a0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 f7 20 00 00       	jmp    801022d0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 9f 75 10 80       	push   $0x8010759f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 43 00 00       	call   801045a0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 4c 43 00 00       	call   80104560 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 c0 45 00 00       	call   801047e0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 12 45 00 00       	jmp    80104780 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 a6 75 10 80       	push   $0x801075a6
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 3b 45 00 00       	call   801047e0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 5e 3d 00 00       	call   80104030 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 89 36 00 00       	call   80103970 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 85 44 00 00       	call   80104780 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 2f 44 00 00       	call   80104780 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 32 25 00 00       	call   801028d0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ad 75 10 80       	push   $0x801075ad
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 fe 7a 10 80 	movl   $0x80107afe,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 43 42 00 00       	call   80104610 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 c1 75 10 80       	push   $0x801075c1
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 ac 5c 00 00       	call   801060d0 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 e1 5b 00 00       	call   801060d0 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 d5 5b 00 00       	call   801060d0 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 c9 5b 00 00       	call   801060d0 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 0a 44 00 00       	call   80104970 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 65 43 00 00       	call   801048e0 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 c5 75 10 80       	push   $0x801075c5
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 bc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005cb:	e8 10 42 00 00       	call   801047e0 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ff 10 80       	push   $0x8010ff20
80100604:	e8 77 41 00 00       	call   80104780 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 8e 11 00 00       	call   801017a0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 50 7b 10 80 	movzbl -0x7fef84b0(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ff 10 80       	push   $0x8010ff20
801007d8:	e8 03 40 00 00       	call   801047e0 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ff 10 80       	push   $0x8010ff20
801007fb:	e8 80 3f 00 00       	call   80104780 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf d8 75 10 80       	mov    $0x801075d8,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 df 75 10 80       	push   $0x801075df
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ff 10 80       	push   $0x8010ff20
801008b3:	e8 28 3f 00 00       	call   801047e0 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 ff 10 80       	push   $0x8010ff20
801008ed:	e8 8e 3e 00 00       	call   80104780 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100914:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
80100933:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010094a:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
8010095e:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100998:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100a05:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a27:	68 00 ff 10 80       	push   $0x8010ff00
80100a2c:	e8 bf 36 00 00       	call   801040f0 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 7c 37 00 00       	jmp    801041d0 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5e:	00 
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 e8 75 10 80       	push   $0x801075e8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 7b 3b 00 00       	call   801045f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 b0 	movl   $0x801005b0,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 c2 19 00 00       	call   80102460 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 af 2e 00 00       	call   80103970 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 74 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 a9 15 00 00       	call   80102080 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 30 03 00 00    	je     80100e12 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c7                	mov    %eax,%edi
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	57                   	push   %edi
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	0f 85 01 01 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b0a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b11:	45 4c 46 
80100b14:	0f 85 f1 00 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b1a:	e8 21 67 00 00       	call   80107240 <setupkvm>
80100b1f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b25:	85 c0                	test   %eax,%eax
80100b27:	0f 84 de 00 00 00    	je     80100c0b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b34:	00 
80100b35:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b3b:	0f 84 a1 02 00 00    	je     80100de2 <exec+0x332>
  sz = 0;
80100b41:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b48:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4b:	31 db                	xor    %ebx,%ebx
80100b4d:	e9 8c 00 00 00       	jmp    80100bde <exec+0x12e>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b5f:	75 6c                	jne    80100bcd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b6d:	0f 82 87 00 00 00    	jb     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b79:	72 7f                	jb     80100bfa <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b7b:	83 ec 04             	sub    $0x4,%esp
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b85:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b8b:	e8 e0 64 00 00       	call   80107070 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	74 5d                	je     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b9d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba8:	75 50                	jne    80100bfa <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bb3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bb9:	57                   	push   %edi
80100bba:	50                   	push   %eax
80100bbb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bc1:	e8 da 63 00 00       	call   80106fa0 <loaduvm>
80100bc6:	83 c4 20             	add    $0x20,%esp
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	78 2d                	js     80100bfa <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bcd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bd4:	83 c3 01             	add    $0x1,%ebx
80100bd7:	83 c6 20             	add    $0x20,%esi
80100bda:	39 d8                	cmp    %ebx,%eax
80100bdc:	7e 52                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bde:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100be4:	6a 20                	push   $0x20
80100be6:	56                   	push   %esi
80100be7:	50                   	push   %eax
80100be8:	57                   	push   %edi
80100be9:	e8 c2 0e 00 00       	call   80101ab0 <readi>
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	83 f8 20             	cmp    $0x20,%eax
80100bf4:	0f 84 5e ff ff ff    	je     80100b58 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c03:	e8 b8 65 00 00       	call   801071c0 <freevm>
  if(ip){
80100c08:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c0b:	83 ec 0c             	sub    $0xc,%esp
80100c0e:	57                   	push   %edi
80100c0f:	e8 1c 0e 00 00       	call   80101a30 <iunlockput>
    end_op();
80100c14:	e8 97 21 00 00       	call   80102db0 <end_op>
80100c19:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c24:	5b                   	pop    %ebx
80100c25:	5e                   	pop    %esi
80100c26:	5f                   	pop    %edi
80100c27:	5d                   	pop    %ebp
80100c28:	c3                   	ret
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c30:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c36:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	57                   	push   %edi
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 5a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	56                   	push   %esi
80100c5b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c61:	56                   	push   %esi
80100c62:	e8 09 64 00 00       	call   80107070 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 86 00 00 00    	je     80100cfa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 58 66 00 00       	call   801072e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8b 10                	mov    (%eax),%edx
80100c90:	85 d2                	test   %edx,%edx
80100c92:	0f 84 56 01 00 00    	je     80100dee <exec+0x33e>
80100c98:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ca1:	eb 23                	jmp    80100cc6 <exec+0x216>
80100ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ca8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cb2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cbb:	85 d2                	test   %edx,%edx
80100cbd:	74 51                	je     80100d10 <exec+0x260>
    if(argc >= MAXARG)
80100cbf:	83 f8 20             	cmp    $0x20,%eax
80100cc2:	74 36                	je     80100cfa <exec+0x24a>
80100cc4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc6:	83 ec 0c             	sub    $0xc,%esp
80100cc9:	52                   	push   %edx
80100cca:	e8 01 3e 00 00       	call   80104ad0 <strlen>
80100ccf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd1:	58                   	pop    %eax
80100cd2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 eb 01             	sub    $0x1,%ebx
80100cd8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdb:	e8 f0 3d 00 00       	call   80104ad0 <strlen>
80100ce0:	83 c0 01             	add    $0x1,%eax
80100ce3:	50                   	push   %eax
80100ce4:	ff 34 b7             	push   (%edi,%esi,4)
80100ce7:	53                   	push   %ebx
80100ce8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cee:	e8 bd 67 00 00       	call   801074b0 <copyout>
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	79 ae                	jns    80100ca8 <exec+0x1f8>
    freevm(pgdir);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d03:	e8 b8 64 00 00       	call   801071c0 <freevm>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	e9 0c ff ff ff       	jmp    80100c1c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d10:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d17:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d1d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d23:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d26:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d29:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d30:	00 00 00 00 
  ustack[1] = argc;
80100d34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d3a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d41:	ff ff ff 
  ustack[1] = argc;
80100d44:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d4c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4e:	29 d0                	sub    %edx,%eax
80100d50:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d56:	56                   	push   %esi
80100d57:	51                   	push   %ecx
80100d58:	53                   	push   %ebx
80100d59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5f:	e8 4c 67 00 00       	call   801074b0 <copyout>
80100d64:	83 c4 10             	add    $0x10,%esp
80100d67:	85 c0                	test   %eax,%eax
80100d69:	78 8f                	js     80100cfa <exec+0x24a>
  for(last=s=path; *s; s++)
80100d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d6e:	8b 55 08             	mov    0x8(%ebp),%edx
80100d71:	0f b6 00             	movzbl (%eax),%eax
80100d74:	84 c0                	test   %al,%al
80100d76:	74 17                	je     80100d8f <exec+0x2df>
80100d78:	89 d1                	mov    %edx,%ecx
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	83 ec 04             	sub    $0x4,%esp
80100d92:	6a 10                	push   $0x10
80100d94:	52                   	push   %edx
80100d95:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d9b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d9e:	50                   	push   %eax
80100d9f:	e8 ec 3c 00 00       	call   80104a90 <safestrcpy>
  curproc->pgdir = pgdir;
80100da4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100daa:	89 f0                	mov    %esi,%eax
80100dac:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100daf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100db1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db4:	89 c1                	mov    %eax,%ecx
80100db6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbc:	8b 40 18             	mov    0x18(%eax),%eax
80100dbf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc2:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc8:	89 0c 24             	mov    %ecx,(%esp)
80100dcb:	e8 40 60 00 00       	call   80106e10 <switchuvm>
  freevm(oldpgdir);
80100dd0:	89 34 24             	mov    %esi,(%esp)
80100dd3:	e8 e8 63 00 00       	call   801071c0 <freevm>
  return 0;
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	31 c0                	xor    %eax,%eax
80100ddd:	e9 3f fe ff ff       	jmp    80100c21 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de2:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100de7:	31 f6                	xor    %esi,%esi
80100de9:	e9 5a fe ff ff       	jmp    80100c48 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100dee:	be 10 00 00 00       	mov    $0x10,%esi
80100df3:	ba 04 00 00 00       	mov    $0x4,%edx
80100df8:	b8 03 00 00 00       	mov    $0x3,%eax
80100dfd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e04:	00 00 00 
80100e07:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e0d:	e9 17 ff ff ff       	jmp    80100d29 <exec+0x279>
    end_op();
80100e12:	e8 99 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100e17:	83 ec 0c             	sub    $0xc,%esp
80100e1a:	68 f0 75 10 80       	push   $0x801075f0
80100e1f:	e8 8c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e24:	83 c4 10             	add    $0x10,%esp
80100e27:	e9 f0 fd ff ff       	jmp    80100c1c <exec+0x16c>
80100e2c:	66 90                	xchg   %ax,%ax
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 fc 75 10 80       	push   $0x801075fc
80100e3b:	68 60 ff 10 80       	push   $0x8010ff60
80100e40:	e8 ab 37 00 00       	call   801045f0 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave
80100e49:	c3                   	ret
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e5c:	68 60 ff 10 80       	push   $0x8010ff60
80100e61:	e8 7a 39 00 00       	call   801047e0 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 60 ff 10 80       	push   $0x8010ff60
80100e91:	e8 ea 38 00 00       	call   80104780 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave
80100e9f:	c3                   	ret
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 60 ff 10 80       	push   $0x8010ff60
80100eaa:	e8 d1 38 00 00       	call   80104780 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave
80100eb8:	c3                   	ret
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 60 ff 10 80       	push   $0x8010ff60
80100ecf:	e8 0c 39 00 00       	call   801047e0 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 60 ff 10 80       	push   $0x8010ff60
80100eec:	e8 8f 38 00 00       	call   80104780 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave
80100ef7:	c3                   	ret
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 03 76 10 80       	push   $0x80107603
80100f00:	e8 7b f4 ff ff       	call   80100380 <panic>
80100f05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f0c:	00 
80100f0d:	8d 76 00             	lea    0x0(%esi),%esi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 60 ff 10 80       	push   $0x8010ff60
80100f21:	e8 ba 38 00 00       	call   801047e0 <acquire>
  if(f->ref < 1)
80100f26:	8b 53 04             	mov    0x4(%ebx),%edx
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 d2                	test   %edx,%edx
80100f2e:	0f 8e a5 00 00 00    	jle    80100fd9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 ea 01             	sub    $0x1,%edx
80100f37:	89 53 04             	mov    %edx,0x4(%ebx)
80100f3a:	75 44                	jne    80100f80 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f3c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f40:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f43:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f4e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
80100f54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f57:	68 60 ff 10 80       	push   $0x8010ff60
80100f5c:	e8 1f 38 00 00       	call   80104780 <release>

  if(ff.type == FD_PIPE)
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	83 ff 01             	cmp    $0x1,%edi
80100f67:	74 57                	je     80100fc0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f69:	83 ff 02             	cmp    $0x2,%edi
80100f6c:	74 2a                	je     80100f98 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f71:	5b                   	pop    %ebx
80100f72:	5e                   	pop    %esi
80100f73:	5f                   	pop    %edi
80100f74:	5d                   	pop    %ebp
80100f75:	c3                   	ret
80100f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f7d:	00 
80100f7e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100f80:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8a:	5b                   	pop    %ebx
80100f8b:	5e                   	pop    %esi
80100f8c:	5f                   	pop    %edi
80100f8d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8e:	e9 ed 37 00 00       	jmp    80104780 <release>
80100f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100f98:	e8 a3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
80100fa0:	ff 75 e0             	push   -0x20(%ebp)
80100fa3:	e8 28 09 00 00       	call   801018d0 <iput>
    end_op();
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fae:	5b                   	pop    %ebx
80100faf:	5e                   	pop    %esi
80100fb0:	5f                   	pop    %edi
80100fb1:	5d                   	pop    %ebp
    end_op();
80100fb2:	e9 f9 1d 00 00       	jmp    80102db0 <end_op>
80100fb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fbe:	00 
80100fbf:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fc0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	53                   	push   %ebx
80100fc8:	56                   	push   %esi
80100fc9:	e8 32 25 00 00       	call   80103500 <pipeclose>
80100fce:	83 c4 10             	add    $0x10,%esp
}
80100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret
    panic("fileclose");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 0b 76 10 80       	push   $0x8010760b
80100fe1:	e8 9a f3 ff ff       	call   80100380 <panic>
80100fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fed:	00 
80100fee:	66 90                	xchg   %ax,%ax

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	push   0x10(%ebx)
80101005:	e8 96 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	push   0xc(%ebp)
8010100f:	ff 73 10             	push   0x10(%ebx)
80101012:	e8 69 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	push   0x10(%ebx)
8010101b:	e8 60 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101023:	83 c4 10             	add    $0x10,%esp
80101026:	31 c0                	xor    %eax,%eax
}
80101028:	c9                   	leave
80101029:	c3                   	ret
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101038:	c9                   	leave
80101039:	c3                   	ret
8010103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	74 60                	je     801010b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101058:	8b 03                	mov    (%ebx),%eax
8010105a:	83 f8 01             	cmp    $0x1,%eax
8010105d:	74 41                	je     801010a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105f:	83 f8 02             	cmp    $0x2,%eax
80101062:	75 5b                	jne    801010bf <fileread+0x7f>
    ilock(f->ip);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	ff 73 10             	push   0x10(%ebx)
8010106a:	e8 31 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010106f:	57                   	push   %edi
80101070:	ff 73 14             	push   0x14(%ebx)
80101073:	56                   	push   %esi
80101074:	ff 73 10             	push   0x10(%ebx)
80101077:	e8 34 0a 00 00       	call   80101ab0 <readi>
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	89 c6                	mov    %eax,%esi
80101081:	85 c0                	test   %eax,%eax
80101083:	7e 03                	jle    80101088 <fileread+0x48>
      f->off += r;
80101085:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101088:	83 ec 0c             	sub    $0xc,%esp
8010108b:	ff 73 10             	push   0x10(%ebx)
8010108e:	e8 ed 07 00 00       	call   80101880 <iunlock>
    return r;
80101093:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	89 f0                	mov    %esi,%eax
8010109b:	5b                   	pop    %ebx
8010109c:	5e                   	pop    %esi
8010109d:	5f                   	pop    %edi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a9:	5b                   	pop    %ebx
801010aa:	5e                   	pop    %esi
801010ab:	5f                   	pop    %edi
801010ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ad:	e9 0e 26 00 00       	jmp    801036c0 <piperead>
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010bd:	eb d7                	jmp    80101096 <fileread+0x56>
  panic("fileread");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 15 76 10 80       	push   $0x80107615
801010c7:	e8 b4 f2 ff ff       	call   80100380 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
801010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ec:	0f 84 bb 00 00 00    	je     801011ad <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010f2:	8b 03                	mov    (%ebx),%eax
801010f4:	83 f8 01             	cmp    $0x1,%eax
801010f7:	0f 84 bf 00 00 00    	je     801011bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	0f 85 c8 00 00 00    	jne    801011ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101109:	31 f6                	xor    %esi,%esi
    while(i < n){
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 30                	jg     8010113f <filewrite+0x6f>
8010110f:	e9 94 00 00 00       	jmp    801011a8 <filewrite+0xd8>
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101118:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010111e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101121:	ff 73 10             	push   0x10(%ebx)
80101124:	e8 57 07 00 00       	call   80101880 <iunlock>
      end_op();
80101129:	e8 82 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	39 c7                	cmp    %eax,%edi
80101136:	75 5c                	jne    80101194 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101138:	01 fe                	add    %edi,%esi
    while(i < n){
8010113a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010113d:	7e 69                	jle    801011a8 <filewrite+0xd8>
      int n1 = n - i;
8010113f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101142:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101147:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101149:	39 c7                	cmp    %eax,%edi
8010114b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010114e:	e8 ed 1b 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 73 10             	push   0x10(%ebx)
80101159:	e8 42 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010115e:	57                   	push   %edi
8010115f:	ff 73 14             	push   0x14(%ebx)
80101162:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101165:	01 f0                	add    %esi,%eax
80101167:	50                   	push   %eax
80101168:	ff 73 10             	push   0x10(%ebx)
8010116b:	e8 40 0a 00 00       	call   80101bb0 <writei>
80101170:	83 c4 20             	add    $0x20,%esp
80101173:	85 c0                	test   %eax,%eax
80101175:	7f a1                	jg     80101118 <filewrite+0x48>
80101177:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010117a:	83 ec 0c             	sub    $0xc,%esp
8010117d:	ff 73 10             	push   0x10(%ebx)
80101180:	e8 fb 06 00 00       	call   80101880 <iunlock>
      end_op();
80101185:	e8 26 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
8010118a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	85 c0                	test   %eax,%eax
80101192:	75 14                	jne    801011a8 <filewrite+0xd8>
        panic("short filewrite");
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	68 1e 76 10 80       	push   $0x8010761e
8010119c:	e8 df f1 ff ff       	call   80100380 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ab:	74 05                	je     801011b2 <filewrite+0xe2>
801011ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	89 f0                	mov    %esi,%eax
801011b7:	5b                   	pop    %ebx
801011b8:	5e                   	pop    %esi
801011b9:	5f                   	pop    %edi
801011ba:	5d                   	pop    %ebp
801011bb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011bc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c5:	5b                   	pop    %ebx
801011c6:	5e                   	pop    %esi
801011c7:	5f                   	pop    %edi
801011c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011c9:	e9 d2 23 00 00       	jmp    801035a0 <pipewrite>
  panic("filewrite");
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	68 24 76 10 80       	push   $0x80107624
801011d6:	e8 a5 f1 ff ff       	call   80100380 <panic>
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011e9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801011ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011f2:	85 c9                	test   %ecx,%ecx
801011f4:	0f 84 8c 00 00 00    	je     80101286 <balloc+0xa6>
801011fa:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801011fc:	89 f8                	mov    %edi,%eax
801011fe:	83 ec 08             	sub    $0x8,%esp
80101201:	89 fe                	mov    %edi,%esi
80101203:	c1 f8 0c             	sar    $0xc,%eax
80101206:	03 05 cc 25 11 80    	add    0x801125cc,%eax
8010120c:	50                   	push   %eax
8010120d:	ff 75 dc             	push   -0x24(%ebp)
80101210:	e8 bb ee ff ff       	call   801000d0 <bread>
80101215:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101218:	83 c4 10             	add    $0x10,%esp
8010121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121e:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101223:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101226:	31 c0                	xor    %eax,%eax
80101228:	eb 32                	jmp    8010125c <balloc+0x7c>
8010122a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101230:	89 c1                	mov    %eax,%ecx
80101232:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101237:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010123a:	83 e1 07             	and    $0x7,%ecx
8010123d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123f:	89 c1                	mov    %eax,%ecx
80101241:	c1 f9 03             	sar    $0x3,%ecx
80101244:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101249:	89 fa                	mov    %edi,%edx
8010124b:	85 df                	test   %ebx,%edi
8010124d:	74 49                	je     80101298 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124f:	83 c0 01             	add    $0x1,%eax
80101252:	83 c6 01             	add    $0x1,%esi
80101255:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010125a:	74 07                	je     80101263 <balloc+0x83>
8010125c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010125f:	39 d6                	cmp    %edx,%esi
80101261:	72 cd                	jb     80101230 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101263:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101266:	83 ec 0c             	sub    $0xc,%esp
80101269:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010126c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101272:	e8 79 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101277:	83 c4 10             	add    $0x10,%esp
8010127a:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
80101280:	0f 82 76 ff ff ff    	jb     801011fc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	68 2e 76 10 80       	push   $0x8010762e
8010128e:	e8 ed f0 ff ff       	call   80100380 <panic>
80101293:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101298:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010129b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010129e:	09 da                	or     %ebx,%edx
801012a0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012a4:	57                   	push   %edi
801012a5:	e8 76 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
801012aa:	89 3c 24             	mov    %edi,(%esp)
801012ad:	e8 3e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012b2:	58                   	pop    %eax
801012b3:	5a                   	pop    %edx
801012b4:	56                   	push   %esi
801012b5:	ff 75 dc             	push   -0x24(%ebp)
801012b8:	e8 13 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012bd:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012c0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012c2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012c5:	68 00 02 00 00       	push   $0x200
801012ca:	6a 00                	push   $0x0
801012cc:	50                   	push   %eax
801012cd:	e8 0e 36 00 00       	call   801048e0 <memset>
  log_write(bp);
801012d2:	89 1c 24             	mov    %ebx,(%esp)
801012d5:	e8 46 1c 00 00       	call   80102f20 <log_write>
  brelse(bp);
801012da:	89 1c 24             	mov    %ebx,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
}
801012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e5:	89 f0                	mov    %esi,%eax
801012e7:	5b                   	pop    %ebx
801012e8:	5e                   	pop    %esi
801012e9:	5f                   	pop    %edi
801012ea:	5d                   	pop    %ebp
801012eb:	c3                   	ret
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012f4:	31 ff                	xor    %edi,%edi
{
801012f6:	56                   	push   %esi
801012f7:	89 c6                	mov    %eax,%esi
801012f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801012ff:	83 ec 28             	sub    $0x28,%esp
80101302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101305:	68 60 09 11 80       	push   $0x80110960
8010130a:	e8 d1 34 00 00       	call   801047e0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101312:	83 c4 10             	add    $0x10,%esp
80101315:	eb 1b                	jmp    80101332 <iget+0x42>
80101317:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010131e:	00 
8010131f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101320:	39 33                	cmp    %esi,(%ebx)
80101322:	74 6c                	je     80101390 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101324:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010132a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101330:	74 26                	je     80101358 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101332:	8b 43 08             	mov    0x8(%ebx),%eax
80101335:	85 c0                	test   %eax,%eax
80101337:	7f e7                	jg     80101320 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101339:	85 ff                	test   %edi,%edi
8010133b:	75 e7                	jne    80101324 <iget+0x34>
8010133d:	85 c0                	test   %eax,%eax
8010133f:	75 76                	jne    801013b7 <iget+0xc7>
      empty = ip;
80101341:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101343:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101349:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010134f:	75 e1                	jne    80101332 <iget+0x42>
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101358:	85 ff                	test   %edi,%edi
8010135a:	74 79                	je     801013d5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010135c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010135f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101361:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101364:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010136b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101372:	68 60 09 11 80       	push   $0x80110960
80101377:	e8 04 34 00 00       	call   80104780 <release>

  return ip;
8010137c:	83 c4 10             	add    $0x10,%esp
}
8010137f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101382:	89 f8                	mov    %edi,%eax
80101384:	5b                   	pop    %ebx
80101385:	5e                   	pop    %esi
80101386:	5f                   	pop    %edi
80101387:	5d                   	pop    %ebp
80101388:	c3                   	ret
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 53 04             	cmp    %edx,0x4(%ebx)
80101393:	75 8f                	jne    80101324 <iget+0x34>
      ip->ref++;
80101395:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101398:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010139b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010139d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013a0:	68 60 09 11 80       	push   $0x80110960
801013a5:	e8 d6 33 00 00       	call   80104780 <release>
      return ip;
801013aa:	83 c4 10             	add    $0x10,%esp
}
801013ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b0:	89 f8                	mov    %edi,%eax
801013b2:	5b                   	pop    %ebx
801013b3:	5e                   	pop    %esi
801013b4:	5f                   	pop    %edi
801013b5:	5d                   	pop    %ebp
801013b6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013bd:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013c3:	74 10                	je     801013d5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c5:	8b 43 08             	mov    0x8(%ebx),%eax
801013c8:	85 c0                	test   %eax,%eax
801013ca:	0f 8f 50 ff ff ff    	jg     80101320 <iget+0x30>
801013d0:	e9 68 ff ff ff       	jmp    8010133d <iget+0x4d>
    panic("iget: no inodes");
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	68 44 76 10 80       	push   $0x80107644
801013dd:	e8 9e ef ff ff       	call   80100380 <panic>
801013e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013e9:	00 
801013ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801013f3:	89 d0                	mov    %edx,%eax
801013f5:	c1 e8 0c             	shr    $0xc,%eax
{
801013f8:	89 e5                	mov    %esp,%ebp
801013fa:	56                   	push   %esi
801013fb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801013fc:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
80101402:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101404:	83 ec 08             	sub    $0x8,%esp
80101407:	50                   	push   %eax
80101408:	51                   	push   %ecx
80101409:	e8 c2 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010140e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101410:	c1 fb 03             	sar    $0x3,%ebx
80101413:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101416:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101418:	83 e1 07             	and    $0x7,%ecx
8010141b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101420:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101426:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101428:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010142d:	85 c1                	test   %eax,%ecx
8010142f:	74 23                	je     80101454 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101431:	f7 d0                	not    %eax
  log_write(bp);
80101433:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101436:	21 c8                	and    %ecx,%eax
80101438:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010143c:	56                   	push   %esi
8010143d:	e8 de 1a 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101442:	89 34 24             	mov    %esi,(%esp)
80101445:	e8 a6 ed ff ff       	call   801001f0 <brelse>
}
8010144a:	83 c4 10             	add    $0x10,%esp
8010144d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101450:	5b                   	pop    %ebx
80101451:	5e                   	pop    %esi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret
    panic("freeing free block");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 54 76 10 80       	push   $0x80107654
8010145c:	e8 1f ef ff ff       	call   80100380 <panic>
80101461:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101468:	00 
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 8c 00 00 00    	jbe    80101510 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 a2 00 00 00    	ja     80101532 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 5e                	je     801014f8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149a:	83 ec 08             	sub    $0x8,%esp
8010149d:	50                   	push   %eax
8010149e:	ff 36                	push   (%esi)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ae:	8b 3b                	mov    (%ebx),%edi
801014b0:	85 ff                	test   %edi,%edi
801014b2:	74 1c                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	52                   	push   %edx
801014b8:	e8 33 ed ff ff       	call   801001f0 <brelse>
801014bd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c3:	89 f8                	mov    %edi,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	e8 06 fd ff ff       	call   801011e0 <balloc>
      log_write(bp);
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 03                	mov    %eax,(%ebx)
801014e2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014e4:	52                   	push   %edx
801014e5:	e8 36 1a 00 00       	call   80102f20 <log_write>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	eb c2                	jmp    801014b4 <bmap+0x44>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f8:	8b 06                	mov    (%esi),%eax
801014fa:	e8 e1 fc ff ff       	call   801011e0 <balloc>
801014ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101505:	eb 93                	jmp    8010149a <bmap+0x2a>
80101507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010150e:	00 
8010150f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101510:	8d 5a 14             	lea    0x14(%edx),%ebx
80101513:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101517:	85 ff                	test   %edi,%edi
80101519:	75 a5                	jne    801014c0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010151b:	8b 00                	mov    (%eax),%eax
8010151d:	e8 be fc ff ff       	call   801011e0 <balloc>
80101522:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101526:	89 c7                	mov    %eax,%edi
}
80101528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152b:	5b                   	pop    %ebx
8010152c:	89 f8                	mov    %edi,%eax
8010152e:	5e                   	pop    %esi
8010152f:	5f                   	pop    %edi
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret
  panic("bmap: out of range");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 67 76 10 80       	push   $0x80107667
8010153a:	e8 41 ee ff ff       	call   80100380 <panic>
8010153f:	90                   	nop

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 0a 34 00 00       	call   80104970 <memmove>
  brelse(bp);
80101566:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101569:	83 c4 10             	add    $0x10,%esp
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157e:	00 
8010157f:	90                   	nop

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 7a 76 10 80       	push   $0x8010767a
80101591:	68 60 09 11 80       	push   $0x80110960
80101596:	e8 55 30 00 00       	call   801045f0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 81 76 10 80       	push   $0x80107681
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 0c 2f 00 00       	call   801044c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 25 11 80       	push   $0x801125b4
801015dc:	e8 8f 33 00 00       	call   80104970 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc 25 11 80    	push   0x801125cc
801015ef:	ff 35 c8 25 11 80    	push   0x801125c8
801015f5:	ff 35 c4 25 11 80    	push   0x801125c4
801015fb:	ff 35 c0 25 11 80    	push   0x801125c0
80101601:	ff 35 bc 25 11 80    	push   0x801125bc
80101607:	ff 35 b8 25 11 80    	push   0x801125b8
8010160d:	ff 35 b4 25 11 80    	push   0x801125b4
80101613:	68 64 7b 10 80       	push   $0x80107b64
80101618:	e8 93 f0 ff ff       	call   801006b0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave
80101624:	c3                   	ret
80101625:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010162c:	00 
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010165d:	00 
8010165e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	6a 40                	push   $0x40
801016a8:	6a 00                	push   $0x0
801016aa:	51                   	push   %ecx
801016ab:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016ae:	e8 2d 32 00 00       	call   801048e0 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 5b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 10 fc ff ff       	jmp    801012f0 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 87 76 10 80       	push   $0x80107687
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 1a 32 00 00       	call   80104970 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 c2 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
8010175e:	89 75 08             	mov    %esi,0x8(%ebp)
80101761:	83 c4 10             	add    $0x10,%esp
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 09 11 80       	push   $0x80110960
8010177f:	e8 5c 30 00 00       	call   801047e0 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010178f:	e8 ec 2f 00 00       	call   80104780 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave
8010179a:	c3                   	ret
8010179b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 39 2d 00 00       	call   80104500 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret
801017d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017df:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 33 31 00 00       	call   80104970 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 9f 76 10 80       	push   $0x8010769f
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 99 76 10 80       	push   $0x80107699
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010187b:	00 
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 08 2d 00 00       	call   801045a0 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 ac 2c 00 00       	jmp    80104560 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 ae 76 10 80       	push   $0x801076ae
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018c8:	00 
801018c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 1b 2c 00 00       	call   80104500 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 61 2c 00 00       	call   80104560 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101906:	e8 d5 2e 00 00       	call   801047e0 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 5b 2e 00 00       	jmp    80104780 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 09 11 80       	push   $0x80110960
80101930:	e8 ab 2e 00 00       	call   801047e0 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010193f:	e8 3c 2e 00 00       	call   80104780 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 df                	mov    %ebx,%edi
8010195a:	89 cb                	mov    %ecx,%ebx
8010195c:	eb 09                	jmp    80101967 <iput+0x97>
8010195e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 de                	cmp    %ebx,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 07                	mov    (%edi),%eax
8010196f:	e8 7c fa ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	89 fb                	mov    %edi,%ebx
80101982:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101985:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010198b:	85 c0                	test   %eax,%eax
8010198d:	75 2d                	jne    801019bc <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101992:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101999:	53                   	push   %ebx
8010199a:	e8 51 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199f:	31 c0                	xor    %eax,%eax
801019a1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a5:	89 1c 24             	mov    %ebx,(%esp)
801019a8:	e8 43 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ad:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b4:	83 c4 10             	add    $0x10,%esp
801019b7:	e9 3a ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019bc:	83 ec 08             	sub    $0x8,%esp
801019bf:	50                   	push   %eax
801019c0:	ff 33                	push   (%ebx)
801019c2:	e8 09 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019c7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019ca:	83 c4 10             	add    $0x10,%esp
801019cd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019d6:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d9:	89 cf                	mov    %ecx,%edi
801019db:	eb 0a                	jmp    801019e7 <iput+0x117>
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 fe                	cmp    %edi,%esi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 fc f9 ff ff       	call   801013f0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019f9:	83 ec 0c             	sub    $0xc,%esp
801019fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ff:	50                   	push   %eax
80101a00:	e8 eb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a05:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0b:	8b 03                	mov    (%ebx),%eax
80101a0d:	e8 de f9 ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1c:	00 00 00 
80101a1f:	e9 6b ff ff ff       	jmp    8010198f <iput+0xbf>
80101a24:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a2b:	00 
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 58 2b 00 00       	call   801045a0 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 01 2b 00 00       	call   80104560 <releasesleep>
  iput(ip);
80101a5f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a62:	83 c4 10             	add    $0x10,%esp
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 ae 76 10 80       	push   $0x801076ae
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret
80101aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 75 08             	mov    0x8(%ebp),%esi
80101abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101abf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101ac7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101aca:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101acd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101ad0:	0f 84 aa 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101ad9:	8b 56 58             	mov    0x58(%esi),%edx
80101adc:	39 fa                	cmp    %edi,%edx
80101ade:	0f 82 bd 00 00 00    	jb     80101ba1 <readi+0xf1>
80101ae4:	89 f9                	mov    %edi,%ecx
80101ae6:	31 db                	xor    %ebx,%ebx
80101ae8:	01 c1                	add    %eax,%ecx
80101aea:	0f 92 c3             	setb   %bl
80101aed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101af0:	0f 82 ab 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101af6:	89 d3                	mov    %edx,%ebx
80101af8:	29 fb                	sub    %edi,%ebx
80101afa:	39 ca                	cmp    %ecx,%edx
80101afc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	85 c0                	test   %eax,%eax
80101b01:	74 73                	je     80101b76 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 fa                	mov    %edi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 51 f9 ff ff       	call   80101470 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f8                	mov    %edi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 f3                	sub    %esi,%ebx
80101b3d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b43:	39 d9                	cmp    %ebx,%ecx
80101b45:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b48:	83 c4 0c             	add    $0xc,%esp
80101b4b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4c:	01 de                	add    %ebx,%esi
80101b4e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b50:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 14 2e 00 00       	call   80104970 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	83 c4 10             	add    $0x10,%esp
80101b70:	39 de                	cmp    %ebx,%esi
80101b72:	72 9c                	jb     80101b10 <readi+0x60>
80101b74:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b79:	5b                   	pop    %ebx
80101b7a:	5e                   	pop    %esi
80101b7b:	5f                   	pop    %edi
80101b7c:	5d                   	pop    %ebp
80101b7d:	c3                   	ret
80101b7e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101b84:	66 83 fa 09          	cmp    $0x9,%dx
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80101b91:	85 d2                	test   %edx,%edx
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e2                	jmp    *%edx
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb ce                	jmp    80101b76 <readi+0xc6>
80101ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101baf:	00 

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bbf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bca:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bcd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101bd0:	0f 84 ba 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd6:	39 78 58             	cmp    %edi,0x58(%eax)
80101bd9:	0f 82 ea 00 00 00    	jb     80101cc9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bdf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101be2:	89 f2                	mov    %esi,%edx
80101be4:	01 fa                	add    %edi,%edx
80101be6:	0f 82 dd 00 00 00    	jb     80101cc9 <writei+0x119>
80101bec:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101bf2:	0f 87 d1 00 00 00    	ja     80101cc9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf8:	85 f6                	test   %esi,%esi
80101bfa:	0f 84 85 00 00 00    	je     80101c85 <writei+0xd5>
80101c00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c13:	89 fa                	mov    %edi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f0                	mov    %esi,%eax
80101c1a:	e8 51 f8 ff ff       	call   80101470 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 36                	push   (%esi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c2d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c30:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f8                	mov    %edi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 d3                	sub    %edx,%ebx
80101c40:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c42:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c46:	39 d9                	cmp    %ebx,%ecx
80101c48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c4b:	83 c4 0c             	add    $0xc,%esp
80101c4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c51:	ff 75 dc             	push   -0x24(%ebp)
80101c54:	50                   	push   %eax
80101c55:	e8 16 2d 00 00       	call   80104970 <memmove>
    log_write(bp);
80101c5a:	89 34 24             	mov    %esi,(%esp)
80101c5d:	e8 be 12 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c62:	89 34 24             	mov    %esi,(%esp)
80101c65:	e8 86 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c6a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c70:	83 c4 10             	add    $0x10,%esp
80101c73:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c76:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c79:	39 d8                	cmp    %ebx,%eax
80101c7b:	72 93                	jb     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c80:	39 78 58             	cmp    %edi,0x58(%eax)
80101c83:	72 33                	jb     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
80101c8f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 2f                	ja     80101cc9 <writei+0x119>
80101c9a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 24                	je     80101cc9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101cb8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cbe:	50                   	push   %eax
80101cbf:	e8 2c fa ff ff       	call   801016f0 <iupdate>
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	eb bc                	jmp    80101c85 <writei+0xd5>
      return -1;
80101cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cce:	eb b8                	jmp    80101c88 <writei+0xd8>

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 fd 2c 00 00       	call   801049e0 <strncmp>
}
80101ce3:	c9                   	leave
80101ce4:	c3                   	ret
80101ce5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cec:	00 
80101ced:	8d 76 00             	lea    0x0(%esi),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 8e fd ff ff       	call   80101ab0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 9e 2c 00 00       	call   801049e0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret
80101d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 79 f5 ff ff       	call   801012f0 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 c8 76 10 80       	push   $0x801076c8
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 b6 76 10 80       	push   $0x801076b6
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 9e 01 00 00    	je     80101f58 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 b1 1b 00 00       	call   80103970 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 09 11 80       	push   $0x80110960
80101dca:	e8 11 2a 00 00       	call   801047e0 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dda:	e8 a1 29 00 00       	call   80104780 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
80101e32:	89 fb                	mov    %edi,%ebx
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 34 2b 00 00       	call   80104970 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 47 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 b7 00 00 00    	jne    80101f1e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 f7 00 00 00    	je     80101f6e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	89 c7                	mov    %eax,%edi
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	0f 84 8c 00 00 00    	je     80101f1e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e92:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	51                   	push   %ecx
80101e99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101e9c:	e8 ff 26 00 00       	call   801045a0 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 02 01 00 00    	je     80101fae <namex+0x20e>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e f7 00 00 00    	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101eb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	51                   	push   %ecx
80101ebe:	e8 9d 26 00 00       	call   80104560 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101ec6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101ec8:	e8 03 fa ff ff       	call   801018d0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101edb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 80 2a 00 00       	call   80104970 <memmove>
    name[len] = 0;
80101ef0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 01 00             	movb   $0x0,(%ecx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 93 00 00 00    	jne    80101f9e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f1e:	83 ec 0c             	sub    $0xc,%esp
80101f21:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f24:	53                   	push   %ebx
80101f25:	e8 76 26 00 00       	call   801045a0 <holdingsleep>
80101f2a:	83 c4 10             	add    $0x10,%esp
80101f2d:	85 c0                	test   %eax,%eax
80101f2f:	74 7d                	je     80101fae <namex+0x20e>
80101f31:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f34:	85 c9                	test   %ecx,%ecx
80101f36:	7e 76                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f38:	83 ec 0c             	sub    $0xc,%esp
80101f3b:	53                   	push   %ebx
80101f3c:	e8 1f 26 00 00       	call   80104560 <releasesleep>
  iput(ip);
80101f41:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f44:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f46:	e8 85 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f4b:	83 c4 10             	add    $0x10,%esp
}
80101f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f51:	89 f0                	mov    %esi,%eax
80101f53:	5b                   	pop    %ebx
80101f54:	5e                   	pop    %esi
80101f55:	5f                   	pop    %edi
80101f56:	5d                   	pop    %ebp
80101f57:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101f58:	ba 01 00 00 00       	mov    $0x1,%edx
80101f5d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f62:	e8 89 f3 ff ff       	call   801012f0 <iget>
80101f67:	89 c6                	mov    %eax,%esi
80101f69:	e9 7d fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f74:	53                   	push   %ebx
80101f75:	e8 26 26 00 00       	call   801045a0 <holdingsleep>
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	85 c0                	test   %eax,%eax
80101f7f:	74 2d                	je     80101fae <namex+0x20e>
80101f81:	8b 7e 08             	mov    0x8(%esi),%edi
80101f84:	85 ff                	test   %edi,%edi
80101f86:	7e 26                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	53                   	push   %ebx
80101f8c:	e8 cf 25 00 00       	call   80104560 <releasesleep>
}
80101f91:	83 c4 10             	add    $0x10,%esp
}
80101f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f97:	89 f0                	mov    %esi,%eax
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5f                   	pop    %edi
80101f9c:	5d                   	pop    %ebp
80101f9d:	c3                   	ret
    iput(ip);
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	56                   	push   %esi
      return 0;
80101fa2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fa4:	e8 27 f9 ff ff       	call   801018d0 <iput>
    return 0;
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	eb a0                	jmp    80101f4e <namex+0x1ae>
    panic("iunlock");
80101fae:	83 ec 0c             	sub    $0xc,%esp
80101fb1:	68 ae 76 10 80       	push   $0x801076ae
80101fb6:	e8 c5 e3 ff ff       	call   80100380 <panic>
80101fbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101fc0 <dirlink>:
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 20             	sub    $0x20,%esp
80101fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fcc:	6a 00                	push   $0x0
80101fce:	ff 75 0c             	push   0xc(%ebp)
80101fd1:	53                   	push   %ebx
80101fd2:	e8 19 fd ff ff       	call   80101cf0 <dirlookup>
80101fd7:	83 c4 10             	add    $0x10,%esp
80101fda:	85 c0                	test   %eax,%eax
80101fdc:	75 67                	jne    80102045 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fde:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fe1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe4:	85 ff                	test   %edi,%edi
80101fe6:	74 29                	je     80102011 <dirlink+0x51>
80101fe8:	31 ff                	xor    %edi,%edi
80101fea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fed:	eb 09                	jmp    80101ff8 <dirlink+0x38>
80101fef:	90                   	nop
80101ff0:	83 c7 10             	add    $0x10,%edi
80101ff3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ff6:	73 19                	jae    80102011 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff8:	6a 10                	push   $0x10
80101ffa:	57                   	push   %edi
80101ffb:	56                   	push   %esi
80101ffc:	53                   	push   %ebx
80101ffd:	e8 ae fa ff ff       	call   80101ab0 <readi>
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	83 f8 10             	cmp    $0x10,%eax
80102008:	75 4e                	jne    80102058 <dirlink+0x98>
    if(de.inum == 0)
8010200a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010200f:	75 df                	jne    80101ff0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102011:	83 ec 04             	sub    $0x4,%esp
80102014:	8d 45 da             	lea    -0x26(%ebp),%eax
80102017:	6a 0e                	push   $0xe
80102019:	ff 75 0c             	push   0xc(%ebp)
8010201c:	50                   	push   %eax
8010201d:	e8 0e 2a 00 00       	call   80104a30 <strncpy>
  de.inum = inum;
80102022:	8b 45 10             	mov    0x10(%ebp),%eax
80102025:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102029:	6a 10                	push   $0x10
8010202b:	57                   	push   %edi
8010202c:	56                   	push   %esi
8010202d:	53                   	push   %ebx
8010202e:	e8 7d fb ff ff       	call   80101bb0 <writei>
80102033:	83 c4 20             	add    $0x20,%esp
80102036:	83 f8 10             	cmp    $0x10,%eax
80102039:	75 2a                	jne    80102065 <dirlink+0xa5>
  return 0;
8010203b:	31 c0                	xor    %eax,%eax
}
8010203d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102040:	5b                   	pop    %ebx
80102041:	5e                   	pop    %esi
80102042:	5f                   	pop    %edi
80102043:	5d                   	pop    %ebp
80102044:	c3                   	ret
    iput(ip);
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	50                   	push   %eax
80102049:	e8 82 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010204e:	83 c4 10             	add    $0x10,%esp
80102051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102056:	eb e5                	jmp    8010203d <dirlink+0x7d>
      panic("dirlink read");
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 d7 76 10 80       	push   $0x801076d7
80102060:	e8 1b e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	68 07 7a 10 80       	push   $0x80107a07
8010206d:	e8 0e e3 ff ff       	call   80100380 <panic>
80102072:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102079:	00 
8010207a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102080 <namei>:

struct inode*
namei(char *path)
{
80102080:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102081:	31 d2                	xor    %edx,%edx
{
80102083:	89 e5                	mov    %esp,%ebp
80102085:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010208e:	e8 0d fd ff ff       	call   80101da0 <namex>
}
80102093:	c9                   	leave
80102094:	c3                   	ret
80102095:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010209c:	00 
8010209d:	8d 76 00             	lea    0x0(%esi),%esi

801020a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020a0:	55                   	push   %ebp
  return namex(path, 1, name);
801020a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020af:	e9 ec fc ff ff       	jmp    80101da0 <namex>
801020b4:	66 90                	xchg   %ax,%ax
801020b6:	66 90                	xchg   %ax,%ax
801020b8:	66 90                	xchg   %ax,%ax
801020ba:	66 90                	xchg   %ax,%ax
801020bc:	66 90                	xchg   %ax,%ax
801020be:	66 90                	xchg   %ax,%ax

801020c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020c9:	85 c0                	test   %eax,%eax
801020cb:	0f 84 b4 00 00 00    	je     80102185 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020d1:	8b 70 08             	mov    0x8(%eax),%esi
801020d4:	89 c3                	mov    %eax,%ebx
801020d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020dc:	0f 87 96 00 00 00    	ja     80102178 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020ee:	00 
801020ef:	90                   	nop
801020f0:	89 ca                	mov    %ecx,%edx
801020f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f3:	83 e0 c0             	and    $0xffffffc0,%eax
801020f6:	3c 40                	cmp    $0x40,%al
801020f8:	75 f6                	jne    801020f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020fa:	31 ff                	xor    %edi,%edi
801020fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102101:	89 f8                	mov    %edi,%eax
80102103:	ee                   	out    %al,(%dx)
80102104:	b8 01 00 00 00       	mov    $0x1,%eax
80102109:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010210e:	ee                   	out    %al,(%dx)
8010210f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102114:	89 f0                	mov    %esi,%eax
80102116:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102117:	89 f0                	mov    %esi,%eax
80102119:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010211e:	c1 f8 08             	sar    $0x8,%eax
80102121:	ee                   	out    %al,(%dx)
80102122:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102127:	89 f8                	mov    %edi,%eax
80102129:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010212a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010212e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102133:	c1 e0 04             	shl    $0x4,%eax
80102136:	83 e0 10             	and    $0x10,%eax
80102139:	83 c8 e0             	or     $0xffffffe0,%eax
8010213c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010213d:	f6 03 04             	testb  $0x4,(%ebx)
80102140:	75 16                	jne    80102158 <idestart+0x98>
80102142:	b8 20 00 00 00       	mov    $0x20,%eax
80102147:	89 ca                	mov    %ecx,%edx
80102149:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010214a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214d:	5b                   	pop    %ebx
8010214e:	5e                   	pop    %esi
8010214f:	5f                   	pop    %edi
80102150:	5d                   	pop    %ebp
80102151:	c3                   	ret
80102152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102158:	b8 30 00 00 00       	mov    $0x30,%eax
8010215d:	89 ca                	mov    %ecx,%edx
8010215f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102160:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102165:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102168:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010216d:	fc                   	cld
8010216e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102173:	5b                   	pop    %ebx
80102174:	5e                   	pop    %esi
80102175:	5f                   	pop    %edi
80102176:	5d                   	pop    %ebp
80102177:	c3                   	ret
    panic("incorrect blockno");
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	68 ed 76 10 80       	push   $0x801076ed
80102180:	e8 fb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	68 e4 76 10 80       	push   $0x801076e4
8010218d:	e8 ee e1 ff ff       	call   80100380 <panic>
80102192:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102199:	00 
8010219a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021a0 <ideinit>:
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021a6:	68 ff 76 10 80       	push   $0x801076ff
801021ab:	68 00 26 11 80       	push   $0x80112600
801021b0:	e8 3b 24 00 00       	call   801045f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021b5:	58                   	pop    %eax
801021b6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021bb:	5a                   	pop    %edx
801021bc:	83 e8 01             	sub    $0x1,%eax
801021bf:	50                   	push   %eax
801021c0:	6a 0e                	push   $0xe
801021c2:	e8 99 02 00 00       	call   80102460 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ca:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021cf:	90                   	nop
801021d0:	89 ca                	mov    %ecx,%edx
801021d2:	ec                   	in     (%dx),%al
801021d3:	83 e0 c0             	and    $0xffffffc0,%eax
801021d6:	3c 40                	cmp    $0x40,%al
801021d8:	75 f6                	jne    801021d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021df:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e5:	89 ca                	mov    %ecx,%edx
801021e7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021e8:	84 c0                	test   %al,%al
801021ea:	75 1e                	jne    8010220a <ideinit+0x6a>
801021ec:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801021f1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021fd:	00 
801021fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102200:	83 e9 01             	sub    $0x1,%ecx
80102203:	74 0f                	je     80102214 <ideinit+0x74>
80102205:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102206:	84 c0                	test   %al,%al
80102208:	74 f6                	je     80102200 <ideinit+0x60>
      havedisk1 = 1;
8010220a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102211:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102214:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102219:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010221e:	ee                   	out    %al,(%dx)
}
8010221f:	c9                   	leave
80102220:	c3                   	ret
80102221:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102228:	00 
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102230 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102239:	68 00 26 11 80       	push   $0x80112600
8010223e:	e8 9d 25 00 00       	call   801047e0 <acquire>

  if((b = idequeue) == 0){
80102243:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102249:	83 c4 10             	add    $0x10,%esp
8010224c:	85 db                	test   %ebx,%ebx
8010224e:	74 63                	je     801022b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102250:	8b 43 58             	mov    0x58(%ebx),%eax
80102253:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102258:	8b 33                	mov    (%ebx),%esi
8010225a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102260:	75 2f                	jne    80102291 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102262:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010226e:	00 
8010226f:	90                   	nop
80102270:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	89 c1                	mov    %eax,%ecx
80102273:	83 e1 c0             	and    $0xffffffc0,%ecx
80102276:	80 f9 40             	cmp    $0x40,%cl
80102279:	75 f5                	jne    80102270 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010227b:	a8 21                	test   $0x21,%al
8010227d:	75 12                	jne    80102291 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010227f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102282:	b9 80 00 00 00       	mov    $0x80,%ecx
80102287:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010228c:	fc                   	cld
8010228d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010228f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102291:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102294:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102297:	83 ce 02             	or     $0x2,%esi
8010229a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010229c:	53                   	push   %ebx
8010229d:	e8 4e 1e 00 00       	call   801040f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022a2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	74 05                	je     801022b3 <ideintr+0x83>
    idestart(idequeue);
801022ae:	e8 0d fe ff ff       	call   801020c0 <idestart>
    release(&idelock);
801022b3:	83 ec 0c             	sub    $0xc,%esp
801022b6:	68 00 26 11 80       	push   $0x80112600
801022bb:	e8 c0 24 00 00       	call   80104780 <release>

  release(&idelock);
}
801022c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret
801022c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022cf:	00 

801022d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 10             	sub    $0x10,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022da:	8d 43 0c             	lea    0xc(%ebx),%eax
801022dd:	50                   	push   %eax
801022de:	e8 bd 22 00 00       	call   801045a0 <holdingsleep>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	85 c0                	test   %eax,%eax
801022e8:	0f 84 c3 00 00 00    	je     801023b1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022ee:	8b 03                	mov    (%ebx),%eax
801022f0:	83 e0 06             	and    $0x6,%eax
801022f3:	83 f8 02             	cmp    $0x2,%eax
801022f6:	0f 84 a8 00 00 00    	je     801023a4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022fc:	8b 53 04             	mov    0x4(%ebx),%edx
801022ff:	85 d2                	test   %edx,%edx
80102301:	74 0d                	je     80102310 <iderw+0x40>
80102303:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102308:	85 c0                	test   %eax,%eax
8010230a:	0f 84 87 00 00 00    	je     80102397 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	68 00 26 11 80       	push   $0x80112600
80102318:	e8 c3 24 00 00       	call   801047e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010231d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102322:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102329:	83 c4 10             	add    $0x10,%esp
8010232c:	85 c0                	test   %eax,%eax
8010232e:	74 60                	je     80102390 <iderw+0xc0>
80102330:	89 c2                	mov    %eax,%edx
80102332:	8b 40 58             	mov    0x58(%eax),%eax
80102335:	85 c0                	test   %eax,%eax
80102337:	75 f7                	jne    80102330 <iderw+0x60>
80102339:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010233c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010233e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102344:	74 3a                	je     80102380 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102346:	8b 03                	mov    (%ebx),%eax
80102348:	83 e0 06             	and    $0x6,%eax
8010234b:	83 f8 02             	cmp    $0x2,%eax
8010234e:	74 1b                	je     8010236b <iderw+0x9b>
    sleep(b, &idelock);
80102350:	83 ec 08             	sub    $0x8,%esp
80102353:	68 00 26 11 80       	push   $0x80112600
80102358:	53                   	push   %ebx
80102359:	e8 d2 1c 00 00       	call   80104030 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 c4 10             	add    $0x10,%esp
80102363:	83 e0 06             	and    $0x6,%eax
80102366:	83 f8 02             	cmp    $0x2,%eax
80102369:	75 e5                	jne    80102350 <iderw+0x80>
  }


  release(&idelock);
8010236b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102375:	c9                   	leave
  release(&idelock);
80102376:	e9 05 24 00 00       	jmp    80104780 <release>
8010237b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102380:	89 d8                	mov    %ebx,%eax
80102382:	e8 39 fd ff ff       	call   801020c0 <idestart>
80102387:	eb bd                	jmp    80102346 <iderw+0x76>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102390:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102395:	eb a5                	jmp    8010233c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102397:	83 ec 0c             	sub    $0xc,%esp
8010239a:	68 2e 77 10 80       	push   $0x8010772e
8010239f:	e8 dc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023a4:	83 ec 0c             	sub    $0xc,%esp
801023a7:	68 19 77 10 80       	push   $0x80107719
801023ac:	e8 cf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023b1:	83 ec 0c             	sub    $0xc,%esp
801023b4:	68 03 77 10 80       	push   $0x80107703
801023b9:	e8 c2 df ff ff       	call   80100380 <panic>
801023be:	66 90                	xchg   %ax,%ax

801023c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023c5:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023cc:	00 c0 fe 
  ioapic->reg = reg;
801023cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023d6:	00 00 00 
  return ioapic->data;
801023d9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023e8:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023ee:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023f5:	c1 ee 10             	shr    $0x10,%esi
801023f8:	89 f0                	mov    %esi,%eax
801023fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023fd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102400:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102403:	39 c2                	cmp    %eax,%edx
80102405:	74 16                	je     8010241d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 b8 7b 10 80       	push   $0x80107bb8
8010240f:	e8 9c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102414:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010241a:	83 c4 10             	add    $0x10,%esp
{
8010241d:	ba 10 00 00 00       	mov    $0x10,%edx
80102422:	31 c0                	xor    %eax,%eax
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102428:	89 13                	mov    %edx,(%ebx)
8010242a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010242d:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102433:	83 c0 01             	add    $0x1,%eax
80102436:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010243c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010243f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102442:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102445:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102447:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010244d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102454:	39 c6                	cmp    %eax,%esi
80102456:	7d d0                	jge    80102428 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102458:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245b:	5b                   	pop    %ebx
8010245c:	5e                   	pop    %esi
8010245d:	5d                   	pop    %ebp
8010245e:	c3                   	ret
8010245f:	90                   	nop

80102460 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102460:	55                   	push   %ebp
  ioapic->reg = reg;
80102461:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102467:	89 e5                	mov    %esp,%ebp
80102469:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010246c:	8d 50 20             	lea    0x20(%eax),%edx
8010246f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102473:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102475:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010247e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102481:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102484:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102486:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010248b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010248e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret
80102493:	66 90                	xchg   %ax,%ax
80102495:	66 90                	xchg   %ax,%ax
80102497:	66 90                	xchg   %ax,%ax
80102499:	66 90                	xchg   %ax,%ax
8010249b:	66 90                	xchg   %ax,%ax
8010249d:	66 90                	xchg   %ax,%ax
8010249f:	90                   	nop

801024a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 04             	sub    $0x4,%esp
801024a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024b0:	75 76                	jne    80102528 <kfree+0x88>
801024b2:	81 fb d0 e5 11 80    	cmp    $0x8011e5d0,%ebx
801024b8:	72 6e                	jb     80102528 <kfree+0x88>
801024ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024c5:	77 61                	ja     80102528 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024c7:	83 ec 04             	sub    $0x4,%esp
801024ca:	68 00 10 00 00       	push   $0x1000
801024cf:	6a 01                	push   $0x1
801024d1:	53                   	push   %ebx
801024d2:	e8 09 24 00 00       	call   801048e0 <memset>

  if(kmem.use_lock)
801024d7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	85 d2                	test   %edx,%edx
801024e2:	75 1c                	jne    80102500 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024e4:	a1 78 26 11 80       	mov    0x80112678,%eax
801024e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024eb:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801024f0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801024f6:	85 c0                	test   %eax,%eax
801024f8:	75 1e                	jne    80102518 <kfree+0x78>
    release(&kmem.lock);
}
801024fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fd:	c9                   	leave
801024fe:	c3                   	ret
801024ff:	90                   	nop
    acquire(&kmem.lock);
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 40 26 11 80       	push   $0x80112640
80102508:	e8 d3 22 00 00       	call   801047e0 <acquire>
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	eb d2                	jmp    801024e4 <kfree+0x44>
80102512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102518:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010251f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102522:	c9                   	leave
    release(&kmem.lock);
80102523:	e9 58 22 00 00       	jmp    80104780 <release>
    panic("kfree");
80102528:	83 ec 0c             	sub    $0xc,%esp
8010252b:	68 4c 77 10 80       	push   $0x8010774c
80102530:	e8 4b de ff ff       	call   80100380 <panic>
80102535:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010253c:	00 
8010253d:	8d 76 00             	lea    0x0(%esi),%esi

80102540 <freerange>:
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	56                   	push   %esi
80102544:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102545:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102548:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010254b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102551:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102557:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010255d:	39 de                	cmp    %ebx,%esi
8010255f:	72 23                	jb     80102584 <freerange+0x44>
80102561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102577:	50                   	push   %eax
80102578:	e8 23 ff ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	39 de                	cmp    %ebx,%esi
80102582:	73 e4                	jae    80102568 <freerange+0x28>
}
80102584:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102587:	5b                   	pop    %ebx
80102588:	5e                   	pop    %esi
80102589:	5d                   	pop    %ebp
8010258a:	c3                   	ret
8010258b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102590 <kinit2>:
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	56                   	push   %esi
80102594:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102595:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102598:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010259b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ad:	39 de                	cmp    %ebx,%esi
801025af:	72 23                	jb     801025d4 <kinit2+0x44>
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 d3 fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit2+0x28>
  kmem.use_lock = 1;
801025d4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025db:	00 00 00 
}
801025de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e1:	5b                   	pop    %ebx
801025e2:	5e                   	pop    %esi
801025e3:	5d                   	pop    %ebp
801025e4:	c3                   	ret
801025e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ec:	00 
801025ed:	8d 76 00             	lea    0x0(%esi),%esi

801025f0 <kinit1>:
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	56                   	push   %esi
801025f4:	53                   	push   %ebx
801025f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025f8:	83 ec 08             	sub    $0x8,%esp
801025fb:	68 52 77 10 80       	push   $0x80107752
80102600:	68 40 26 11 80       	push   $0x80112640
80102605:	e8 e6 1f 00 00       	call   801045f0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010260a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102610:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102617:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010261a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102620:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102626:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262c:	39 de                	cmp    %ebx,%esi
8010262e:	72 1c                	jb     8010264c <kinit1+0x5c>
    kfree(p);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102639:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010263f:	50                   	push   %eax
80102640:	e8 5b fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102645:	83 c4 10             	add    $0x10,%esp
80102648:	39 de                	cmp    %ebx,%esi
8010264a:	73 e4                	jae    80102630 <kinit1+0x40>
}
8010264c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010264f:	5b                   	pop    %ebx
80102650:	5e                   	pop    %esi
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret
80102653:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010265a:	00 
8010265b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102660 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	53                   	push   %ebx
80102664:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102667:	a1 74 26 11 80       	mov    0x80112674,%eax
8010266c:	85 c0                	test   %eax,%eax
8010266e:	75 20                	jne    80102690 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102670:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102676:	85 db                	test   %ebx,%ebx
80102678:	74 07                	je     80102681 <kalloc+0x21>
    kmem.freelist = r->next;
8010267a:	8b 03                	mov    (%ebx),%eax
8010267c:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102681:	89 d8                	mov    %ebx,%eax
80102683:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102686:	c9                   	leave
80102687:	c3                   	ret
80102688:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010268f:	00 
    acquire(&kmem.lock);
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	68 40 26 11 80       	push   $0x80112640
80102698:	e8 43 21 00 00       	call   801047e0 <acquire>
  r = kmem.freelist;
8010269d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(kmem.use_lock)
801026a3:	a1 74 26 11 80       	mov    0x80112674,%eax
  if(r)
801026a8:	83 c4 10             	add    $0x10,%esp
801026ab:	85 db                	test   %ebx,%ebx
801026ad:	74 08                	je     801026b7 <kalloc+0x57>
    kmem.freelist = r->next;
801026af:	8b 13                	mov    (%ebx),%edx
801026b1:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801026b7:	85 c0                	test   %eax,%eax
801026b9:	74 c6                	je     80102681 <kalloc+0x21>
    release(&kmem.lock);
801026bb:	83 ec 0c             	sub    $0xc,%esp
801026be:	68 40 26 11 80       	push   $0x80112640
801026c3:	e8 b8 20 00 00       	call   80104780 <release>
}
801026c8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801026ca:	83 c4 10             	add    $0x10,%esp
}
801026cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026d0:	c9                   	leave
801026d1:	c3                   	ret
801026d2:	66 90                	xchg   %ax,%ax
801026d4:	66 90                	xchg   %ax,%ax
801026d6:	66 90                	xchg   %ax,%ax
801026d8:	66 90                	xchg   %ax,%ax
801026da:	66 90                	xchg   %ax,%ax
801026dc:	66 90                	xchg   %ax,%ax
801026de:	66 90                	xchg   %ax,%ax

801026e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e0:	ba 64 00 00 00       	mov    $0x64,%edx
801026e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026e6:	a8 01                	test   $0x1,%al
801026e8:	0f 84 c2 00 00 00    	je     801027b0 <kbdgetc+0xd0>
{
801026ee:	55                   	push   %ebp
801026ef:	ba 60 00 00 00       	mov    $0x60,%edx
801026f4:	89 e5                	mov    %esp,%ebp
801026f6:	53                   	push   %ebx
801026f7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801026f8:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
801026fe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102701:	3c e0                	cmp    $0xe0,%al
80102703:	74 5b                	je     80102760 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102705:	89 da                	mov    %ebx,%edx
80102707:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010270a:	84 c0                	test   %al,%al
8010270c:	78 62                	js     80102770 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010270e:	85 d2                	test   %edx,%edx
80102710:	74 09                	je     8010271b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102712:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102715:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102718:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010271b:	0f b6 91 20 7e 10 80 	movzbl -0x7fef81e0(%ecx),%edx
  shift ^= togglecode[data];
80102722:	0f b6 81 20 7d 10 80 	movzbl -0x7fef82e0(%ecx),%eax
  shift |= shiftcode[data];
80102729:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010272b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010272d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010272f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102735:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102738:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273b:	8b 04 85 00 7d 10 80 	mov    -0x7fef8300(,%eax,4),%eax
80102742:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102746:	74 0b                	je     80102753 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102748:	8d 50 9f             	lea    -0x61(%eax),%edx
8010274b:	83 fa 19             	cmp    $0x19,%edx
8010274e:	77 48                	ja     80102798 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102750:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102756:	c9                   	leave
80102757:	c3                   	ret
80102758:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010275f:	00 
    shift |= E0ESC;
80102760:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102763:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102765:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010276b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010276e:	c9                   	leave
8010276f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102770:	83 e0 7f             	and    $0x7f,%eax
80102773:	85 d2                	test   %edx,%edx
80102775:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102778:	0f b6 81 20 7e 10 80 	movzbl -0x7fef81e0(%ecx),%eax
8010277f:	83 c8 40             	or     $0x40,%eax
80102782:	0f b6 c0             	movzbl %al,%eax
80102785:	f7 d0                	not    %eax
80102787:	21 d8                	and    %ebx,%eax
80102789:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
8010278e:	31 c0                	xor    %eax,%eax
80102790:	eb d9                	jmp    8010276b <kbdgetc+0x8b>
80102792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102798:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010279b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010279e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027a1:	c9                   	leave
      c += 'a' - 'A';
801027a2:	83 f9 1a             	cmp    $0x1a,%ecx
801027a5:	0f 42 c2             	cmovb  %edx,%eax
}
801027a8:	c3                   	ret
801027a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027b5:	c3                   	ret
801027b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027bd:	00 
801027be:	66 90                	xchg   %ax,%ax

801027c0 <kbdintr>:

void
kbdintr(void)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027c6:	68 e0 26 10 80       	push   $0x801026e0
801027cb:	e8 d0 e0 ff ff       	call   801008a0 <consoleintr>
}
801027d0:	83 c4 10             	add    $0x10,%esp
801027d3:	c9                   	leave
801027d4:	c3                   	ret
801027d5:	66 90                	xchg   %ax,%ax
801027d7:	66 90                	xchg   %ax,%ax
801027d9:	66 90                	xchg   %ax,%ax
801027db:	66 90                	xchg   %ax,%ax
801027dd:	66 90                	xchg   %ax,%ax
801027df:	90                   	nop

801027e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027e0:	a1 80 26 11 80       	mov    0x80112680,%eax
801027e5:	85 c0                	test   %eax,%eax
801027e7:	0f 84 c3 00 00 00    	je     801028b0 <lapicinit+0xd0>
  lapic[index] = value;
801027ed:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027f4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102801:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102807:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010280e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102811:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102814:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010281b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102828:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102835:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102838:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010283b:	8b 50 30             	mov    0x30(%eax),%edx
8010283e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102844:	75 72                	jne    801028b8 <lapicinit+0xd8>
  lapic[index] = value;
80102846:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010284d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102850:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102853:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010285a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102860:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102867:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102874:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102881:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102887:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010288e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102891:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102898:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010289e:	80 e6 10             	and    $0x10,%dh
801028a1:	75 f5                	jne    80102898 <lapicinit+0xb8>
  lapic[index] = value;
801028a3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028b0:	c3                   	ret
801028b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028b8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028bf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028c2:	8b 50 20             	mov    0x20(%eax),%edx
}
801028c5:	e9 7c ff ff ff       	jmp    80102846 <lapicinit+0x66>
801028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028d0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028d5:	85 c0                	test   %eax,%eax
801028d7:	74 07                	je     801028e0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028d9:	8b 40 20             	mov    0x20(%eax),%eax
801028dc:	c1 e8 18             	shr    $0x18,%eax
801028df:	c3                   	ret
    return 0;
801028e0:	31 c0                	xor    %eax,%eax
}
801028e2:	c3                   	ret
801028e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028ea:	00 
801028eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801028f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 0d                	je     80102906 <lapiceoi+0x16>
  lapic[index] = value;
801028f9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102900:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102903:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102906:	c3                   	ret
80102907:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010290e:	00 
8010290f:	90                   	nop

80102910 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102910:	c3                   	ret
80102911:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102918:	00 
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102920 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102920:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102921:	b8 0f 00 00 00       	mov    $0xf,%eax
80102926:	ba 70 00 00 00       	mov    $0x70,%edx
8010292b:	89 e5                	mov    %esp,%ebp
8010292d:	53                   	push   %ebx
8010292e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102931:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102934:	ee                   	out    %al,(%dx)
80102935:	b8 0a 00 00 00       	mov    $0xa,%eax
8010293a:	ba 71 00 00 00       	mov    $0x71,%edx
8010293f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102940:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102942:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102945:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010294b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010294d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102950:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102952:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102955:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102958:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010295e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102963:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102973:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102976:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102979:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102980:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102986:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102995:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102998:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ad:	c9                   	leave
801029ae:	c3                   	ret
801029af:	90                   	nop

801029b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029b0:	55                   	push   %ebp
801029b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	57                   	push   %edi
801029be:	56                   	push   %esi
801029bf:	53                   	push   %ebx
801029c0:	83 ec 4c             	sub    $0x4c,%esp
801029c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c4:	ba 71 00 00 00       	mov    $0x71,%edx
801029c9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029cd:	bf 70 00 00 00       	mov    $0x70,%edi
801029d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029d5:	8d 76 00             	lea    0x0(%esi),%esi
801029d8:	31 c0                	xor    %eax,%eax
801029da:	89 fa                	mov    %edi,%edx
801029dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029e2:	89 ca                	mov    %ecx,%edx
801029e4:	ec                   	in     (%dx),%al
801029e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e8:	89 fa                	mov    %edi,%edx
801029ea:	b8 02 00 00 00       	mov    $0x2,%eax
801029ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	89 ca                	mov    %ecx,%edx
801029f2:	ec                   	in     (%dx),%al
801029f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f6:	89 fa                	mov    %edi,%edx
801029f8:	b8 04 00 00 00       	mov    $0x4,%eax
801029fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fe:	89 ca                	mov    %ecx,%edx
80102a00:	ec                   	in     (%dx),%al
80102a01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a04:	89 fa                	mov    %edi,%edx
80102a06:	b8 07 00 00 00       	mov    $0x7,%eax
80102a0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0c:	89 ca                	mov    %ecx,%edx
80102a0e:	ec                   	in     (%dx),%al
80102a0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a12:	89 fa                	mov    %edi,%edx
80102a14:	b8 08 00 00 00       	mov    $0x8,%eax
80102a19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1a:	89 ca                	mov    %ecx,%edx
80102a1c:	ec                   	in     (%dx),%al
80102a1d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1f:	89 fa                	mov    %edi,%edx
80102a21:	b8 09 00 00 00       	mov    $0x9,%eax
80102a26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a27:	89 ca                	mov    %ecx,%edx
80102a29:	ec                   	in     (%dx),%al
80102a2a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2d:	89 fa                	mov    %edi,%edx
80102a2f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a34:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a35:	89 ca                	mov    %ecx,%edx
80102a37:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a38:	84 c0                	test   %al,%al
80102a3a:	78 9c                	js     801029d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a3c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a40:	89 f2                	mov    %esi,%edx
80102a42:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 fa                	mov    %edi,%edx
80102a4a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a4d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a51:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102a54:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a57:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a5b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a62:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a65:	31 c0                	xor    %eax,%eax
80102a67:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a68:	89 ca                	mov    %ecx,%edx
80102a6a:	ec                   	in     (%dx),%al
80102a6b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6e:	89 fa                	mov    %edi,%edx
80102a70:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a73:	b8 02 00 00 00       	mov    $0x2,%eax
80102a78:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a79:	89 ca                	mov    %ecx,%edx
80102a7b:	ec                   	in     (%dx),%al
80102a7c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7f:	89 fa                	mov    %edi,%edx
80102a81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a84:	b8 04 00 00 00       	mov    $0x4,%eax
80102a89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8a:	89 ca                	mov    %ecx,%edx
80102a8c:	ec                   	in     (%dx),%al
80102a8d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a90:	89 fa                	mov    %edi,%edx
80102a92:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a95:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9b:	89 ca                	mov    %ecx,%edx
80102a9d:	ec                   	in     (%dx),%al
80102a9e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa1:	89 fa                	mov    %edi,%edx
80102aa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa6:	b8 08 00 00 00       	mov    $0x8,%eax
80102aab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aac:	89 ca                	mov    %ecx,%edx
80102aae:	ec                   	in     (%dx),%al
80102aaf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab2:	89 fa                	mov    %edi,%edx
80102ab4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab7:	b8 09 00 00 00       	mov    $0x9,%eax
80102abc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abd:	89 ca                	mov    %ecx,%edx
80102abf:	ec                   	in     (%dx),%al
80102ac0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102acc:	6a 18                	push   $0x18
80102ace:	50                   	push   %eax
80102acf:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ad2:	50                   	push   %eax
80102ad3:	e8 48 1e 00 00       	call   80104920 <memcmp>
80102ad8:	83 c4 10             	add    $0x10,%esp
80102adb:	85 c0                	test   %eax,%eax
80102add:	0f 85 f5 fe ff ff    	jne    801029d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ae3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102aea:	89 f0                	mov    %esi,%eax
80102aec:	84 c0                	test   %al,%al
80102aee:	75 78                	jne    80102b68 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102af0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102af3:	89 c2                	mov    %eax,%edx
80102af5:	83 e0 0f             	and    $0xf,%eax
80102af8:	c1 ea 04             	shr    $0x4,%edx
80102afb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102afe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b01:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b04:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b07:	89 c2                	mov    %eax,%edx
80102b09:	83 e0 0f             	and    $0xf,%eax
80102b0c:	c1 ea 04             	shr    $0x4,%edx
80102b0f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b12:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b15:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b18:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b1b:	89 c2                	mov    %eax,%edx
80102b1d:	83 e0 0f             	and    $0xf,%eax
80102b20:	c1 ea 04             	shr    $0x4,%edx
80102b23:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b26:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b29:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b2f:	89 c2                	mov    %eax,%edx
80102b31:	83 e0 0f             	and    $0xf,%eax
80102b34:	c1 ea 04             	shr    $0x4,%edx
80102b37:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b40:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b43:	89 c2                	mov    %eax,%edx
80102b45:	83 e0 0f             	and    $0xf,%eax
80102b48:	c1 ea 04             	shr    $0x4,%edx
80102b4b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b51:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b57:	89 c2                	mov    %eax,%edx
80102b59:	83 e0 0f             	and    $0xf,%eax
80102b5c:	c1 ea 04             	shr    $0x4,%edx
80102b5f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b62:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b65:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b6b:	89 03                	mov    %eax,(%ebx)
80102b6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b70:	89 43 04             	mov    %eax,0x4(%ebx)
80102b73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b76:	89 43 08             	mov    %eax,0x8(%ebx)
80102b79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102b7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b82:	89 43 10             	mov    %eax,0x10(%ebx)
80102b85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b88:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102b8b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b95:	5b                   	pop    %ebx
80102b96:	5e                   	pop    %esi
80102b97:	5f                   	pop    %edi
80102b98:	5d                   	pop    %ebp
80102b99:	c3                   	ret
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb2:	31 ff                	xor    %edi,%edi
{
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 e4 26 11 80    	push   0x801126e4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102be4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 67 1d 00 00       	call   80104970 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 d4 26 11 80    	push   0x801126d4
80102c4d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
}
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave
80102c9a:	c3                   	ret
80102c9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102ca0 <initlog>:
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 2c             	sub    $0x2c,%esp
80102ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102caa:	68 57 77 10 80       	push   $0x80107757
80102caf:	68 a0 26 11 80       	push   $0x801126a0
80102cb4:	e8 37 19 00 00       	call   801045f0 <initlock>
  readsb(dev, &sb);
80102cb9:	58                   	pop    %eax
80102cba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 7b e8 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80102cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cc8:	59                   	pop    %ecx
  log.dev = dev;
80102cc9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102ccf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102cd7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 eb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ce8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ceb:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102cf1:	85 db                	test   %ebx,%ebx
80102cf3:	7e 1d                	jle    80102d12 <initlog+0x72>
80102cf5:	31 d2                	xor    %edx,%edx
80102cf7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102cfe:	00 
80102cff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d00:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d04:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d3                	cmp    %edx,%ebx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave
80102d36:	c3                   	ret
80102d37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d3e:	00 
80102d3f:	90                   	nop

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d46:	68 a0 26 11 80       	push   $0x801126a0
80102d4b:	e8 90 1a 00 00       	call   801047e0 <acquire>
80102d50:	83 c4 10             	add    $0x10,%esp
80102d53:	eb 18                	jmp    80102d6d <begin_op+0x2d>
80102d55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d58:	83 ec 08             	sub    $0x8,%esp
80102d5b:	68 a0 26 11 80       	push   $0x801126a0
80102d60:	68 a0 26 11 80       	push   $0x801126a0
80102d65:	e8 c6 12 00 00       	call   80104030 <sleep>
80102d6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d6d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d72:	85 c0                	test   %eax,%eax
80102d74:	75 e2                	jne    80102d58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d76:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d7b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102d81:	83 c0 01             	add    $0x1,%eax
80102d84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d8a:	83 fa 1e             	cmp    $0x1e,%edx
80102d8d:	7f c9                	jg     80102d58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d92:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102d97:	68 a0 26 11 80       	push   $0x801126a0
80102d9c:	e8 df 19 00 00       	call   80104780 <release>
      break;
    }
  }
}
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	c9                   	leave
80102da5:	c3                   	ret
80102da6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dad:	00 
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	57                   	push   %edi
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102db9:	68 a0 26 11 80       	push   $0x801126a0
80102dbe:	e8 1d 1a 00 00       	call   801047e0 <acquire>
  log.outstanding -= 1;
80102dc3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102dc8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102dda:	85 f6                	test   %esi,%esi
80102ddc:	0f 85 22 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de2:	85 db                	test   %ebx,%ebx
80102de4:	0f 85 f6 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dea:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102df1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102df4:	83 ec 0c             	sub    $0xc,%esp
80102df7:	68 a0 26 11 80       	push   $0x801126a0
80102dfc:	e8 7f 19 00 00       	call   80104780 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e01:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e07:	83 c4 10             	add    $0x10,%esp
80102e0a:	85 c9                	test   %ecx,%ecx
80102e0c:	7f 42                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e0e:	83 ec 0c             	sub    $0xc,%esp
80102e11:	68 a0 26 11 80       	push   $0x801126a0
80102e16:	e8 c5 19 00 00       	call   801047e0 <acquire>
    log.committing = 0;
80102e1b:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e22:	00 00 00 
    wakeup(&log);
80102e25:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e2c:	e8 bf 12 00 00       	call   801040f0 <wakeup>
    release(&log.lock);
80102e31:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e38:	e8 43 19 00 00       	call   80104780 <release>
80102e3d:	83 c4 10             	add    $0x10,%esp
}
80102e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e43:	5b                   	pop    %ebx
80102e44:	5e                   	pop    %esi
80102e45:	5f                   	pop    %edi
80102e46:	5d                   	pop    %ebp
80102e47:	c3                   	ret
80102e48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e4f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102e74:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 d7 1a 00 00       	call   80104970 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 34 ff ff ff       	jmp    80102e0e <end_op+0x5e>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 a0 26 11 80       	push   $0x801126a0
80102ee8:	e8 03 12 00 00       	call   801040f0 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ef4:	e8 87 18 00 00       	call   80104780 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 5b 77 10 80       	push   $0x8010775b
80102f0c:	e8 6f d4 ff ff       	call   80100380 <panic>
80102f11:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f18:	00 
80102f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f27:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f30:	83 fa 1d             	cmp    $0x1d,%edx
80102f33:	7f 7d                	jg     80102fb2 <log_write+0x92>
80102f35:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f3a:	83 e8 01             	sub    $0x1,%eax
80102f3d:	39 c2                	cmp    %eax,%edx
80102f3f:	7d 71                	jge    80102fb2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f41:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f46:	85 c0                	test   %eax,%eax
80102f48:	7e 75                	jle    80102fbf <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 a0 26 11 80       	push   $0x801126a0
80102f52:	e8 89 18 00 00       	call   801047e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f57:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f5a:	83 c4 10             	add    $0x10,%esp
80102f5d:	31 c0                	xor    %eax,%eax
80102f5f:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f65:	85 d2                	test   %edx,%edx
80102f67:	7f 0e                	jg     80102f77 <log_write+0x57>
80102f69:	eb 15                	jmp    80102f80 <log_write+0x60>
80102f6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80102f87:	39 c2                	cmp    %eax,%edx
80102f89:	74 1c                	je     80102fa7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f8b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f91:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102f98:	c9                   	leave
  release(&log.lock);
80102f99:	e9 e2 17 00 00       	jmp    80104780 <release>
80102f9e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fb0:	eb d9                	jmp    80102f8b <log_write+0x6b>
    panic("too big a transaction");
80102fb2:	83 ec 0c             	sub    $0xc,%esp
80102fb5:	68 6a 77 10 80       	push   $0x8010776a
80102fba:	e8 c1 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102fbf:	83 ec 0c             	sub    $0xc,%esp
80102fc2:	68 80 77 10 80       	push   $0x80107780
80102fc7:	e8 b4 d3 ff ff       	call   80100380 <panic>
80102fcc:	66 90                	xchg   %ax,%ax
80102fce:	66 90                	xchg   %ax,%ax

80102fd0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fd7:	e8 74 09 00 00       	call   80103950 <cpuid>
80102fdc:	89 c3                	mov    %eax,%ebx
80102fde:	e8 6d 09 00 00       	call   80103950 <cpuid>
80102fe3:	83 ec 04             	sub    $0x4,%esp
80102fe6:	53                   	push   %ebx
80102fe7:	50                   	push   %eax
80102fe8:	68 9b 77 10 80       	push   $0x8010779b
80102fed:	e8 be d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102ff2:	e8 09 2d 00 00       	call   80105d00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ff7:	e8 f4 08 00 00       	call   801038f0 <mycpu>
80102ffc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ffe:	b8 01 00 00 00       	mov    $0x1,%eax
80103003:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010300a:	e8 11 0c 00 00       	call   80103c20 <scheduler>
8010300f:	90                   	nop

80103010 <mpenter>:
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103016:	e8 e5 3d 00 00       	call   80106e00 <switchkvm>
  seginit();
8010301b:	e8 50 3d 00 00       	call   80106d70 <seginit>
  lapicinit();
80103020:	e8 bb f7 ff ff       	call   801027e0 <lapicinit>
  mpmain();
80103025:	e8 a6 ff ff ff       	call   80102fd0 <mpmain>
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <main>:
{
80103030:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103034:	83 e4 f0             	and    $0xfffffff0,%esp
80103037:	ff 71 fc             	push   -0x4(%ecx)
8010303a:	55                   	push   %ebp
8010303b:	89 e5                	mov    %esp,%ebp
8010303d:	53                   	push   %ebx
8010303e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010303f:	83 ec 08             	sub    $0x8,%esp
80103042:	68 00 00 40 80       	push   $0x80400000
80103047:	68 d0 e5 11 80       	push   $0x8011e5d0
8010304c:	e8 9f f5 ff ff       	call   801025f0 <kinit1>
  kvmalloc();      // kernel page table
80103051:	e8 6a 42 00 00       	call   801072c0 <kvmalloc>
  mpinit();        // detect other processors
80103056:	e8 85 01 00 00       	call   801031e0 <mpinit>
  lapicinit();     // interrupt controller
8010305b:	e8 80 f7 ff ff       	call   801027e0 <lapicinit>
  seginit();       // segment descriptors
80103060:	e8 0b 3d 00 00       	call   80106d70 <seginit>
  picinit();       // disable pic
80103065:	e8 86 03 00 00       	call   801033f0 <picinit>
  ioapicinit();    // another interrupt controller
8010306a:	e8 51 f3 ff ff       	call   801023c0 <ioapicinit>
  consoleinit();   // console hardware
8010306f:	e8 ec d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103074:	e8 67 2f 00 00       	call   80105fe0 <uartinit>
  pinit();         // process table
80103079:	e8 52 08 00 00       	call   801038d0 <pinit>
  tvinit();        // trap vectors
8010307e:	e8 fd 2b 00 00       	call   80105c80 <tvinit>
  binit();         // buffer cache
80103083:	e8 b8 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103088:	e8 a3 dd ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
8010308d:	e8 0e f1 ff ff       	call   801021a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103092:	83 c4 0c             	add    $0xc,%esp
80103095:	68 8a 00 00 00       	push   $0x8a
8010309a:	68 8c b4 10 80       	push   $0x8010b48c
8010309f:	68 00 70 00 80       	push   $0x80007000
801030a4:	e8 c7 18 00 00       	call   80104970 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030a9:	83 c4 10             	add    $0x10,%esp
801030ac:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030b3:	00 00 00 
801030b6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030bb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030c0:	76 7e                	jbe    80103140 <main+0x110>
801030c2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030c7:	eb 20                	jmp    801030e9 <main+0xb9>
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030d0:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030d7:	00 00 00 
801030da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030e0:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030e5:	39 c3                	cmp    %eax,%ebx
801030e7:	73 57                	jae    80103140 <main+0x110>
    if(c == mycpu())  // We've started already.
801030e9:	e8 02 08 00 00       	call   801038f0 <mycpu>
801030ee:	39 c3                	cmp    %eax,%ebx
801030f0:	74 de                	je     801030d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030f2:	e8 69 f5 ff ff       	call   80102660 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801030fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103010,0x80006ff8
80103101:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103104:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010310b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010310e:	05 00 10 00 00       	add    $0x1000,%eax
80103113:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103118:	0f b6 03             	movzbl (%ebx),%eax
8010311b:	68 00 70 00 00       	push   $0x7000
80103120:	50                   	push   %eax
80103121:	e8 fa f7 ff ff       	call   80102920 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103126:	83 c4 10             	add    $0x10,%esp
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103130:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103136:	85 c0                	test   %eax,%eax
80103138:	74 f6                	je     80103130 <main+0x100>
8010313a:	eb 94                	jmp    801030d0 <main+0xa0>
8010313c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103140:	83 ec 08             	sub    $0x8,%esp
80103143:	68 00 00 00 8e       	push   $0x8e000000
80103148:	68 00 00 40 80       	push   $0x80400000
8010314d:	e8 3e f4 ff ff       	call   80102590 <kinit2>
  userinit();      // first user process
80103152:	e8 49 08 00 00       	call   801039a0 <userinit>
  mpmain();        // finish this processor's setup
80103157:	e8 74 fe ff ff       	call   80102fd0 <mpmain>
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103165:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010316b:	53                   	push   %ebx
  e = addr+len;
8010316c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010316f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103172:	39 de                	cmp    %ebx,%esi
80103174:	72 10                	jb     80103186 <mpsearch1+0x26>
80103176:	eb 50                	jmp    801031c8 <mpsearch1+0x68>
80103178:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010317f:	00 
80103180:	89 fe                	mov    %edi,%esi
80103182:	39 df                	cmp    %ebx,%edi
80103184:	73 42                	jae    801031c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103186:	83 ec 04             	sub    $0x4,%esp
80103189:	8d 7e 10             	lea    0x10(%esi),%edi
8010318c:	6a 04                	push   $0x4
8010318e:	68 af 77 10 80       	push   $0x801077af
80103193:	56                   	push   %esi
80103194:	e8 87 17 00 00       	call   80104920 <memcmp>
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	85 c0                	test   %eax,%eax
8010319e:	75 e0                	jne    80103180 <mpsearch1+0x20>
801031a0:	89 f2                	mov    %esi,%edx
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031a8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031ab:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031b0:	39 fa                	cmp    %edi,%edx
801031b2:	75 f4                	jne    801031a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b4:	84 c0                	test   %al,%al
801031b6:	75 c8                	jne    80103180 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bb:	89 f0                	mov    %esi,%eax
801031bd:	5b                   	pop    %ebx
801031be:	5e                   	pop    %esi
801031bf:	5f                   	pop    %edi
801031c0:	5d                   	pop    %ebp
801031c1:	c3                   	ret
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031cb:	31 f6                	xor    %esi,%esi
}
801031cd:	5b                   	pop    %ebx
801031ce:	89 f0                	mov    %esi,%eax
801031d0:	5e                   	pop    %esi
801031d1:	5f                   	pop    %edi
801031d2:	5d                   	pop    %ebp
801031d3:	c3                   	ret
801031d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031db:	00 
801031dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801031e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031f7:	c1 e0 08             	shl    $0x8,%eax
801031fa:	09 d0                	or     %edx,%eax
801031fc:	c1 e0 04             	shl    $0x4,%eax
801031ff:	75 1b                	jne    8010321c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103201:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103208:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010320f:	c1 e0 08             	shl    $0x8,%eax
80103212:	09 d0                	or     %edx,%eax
80103214:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103217:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010321c:	ba 00 04 00 00       	mov    $0x400,%edx
80103221:	e8 3a ff ff ff       	call   80103160 <mpsearch1>
80103226:	89 c3                	mov    %eax,%ebx
80103228:	85 c0                	test   %eax,%eax
8010322a:	0f 84 58 01 00 00    	je     80103388 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103230:	8b 73 04             	mov    0x4(%ebx),%esi
80103233:	85 f6                	test   %esi,%esi
80103235:	0f 84 3d 01 00 00    	je     80103378 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010323b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010323e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103244:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103247:	6a 04                	push   $0x4
80103249:	68 b4 77 10 80       	push   $0x801077b4
8010324e:	50                   	push   %eax
8010324f:	e8 cc 16 00 00       	call   80104920 <memcmp>
80103254:	83 c4 10             	add    $0x10,%esp
80103257:	85 c0                	test   %eax,%eax
80103259:	0f 85 19 01 00 00    	jne    80103378 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010325f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103266:	3c 01                	cmp    $0x1,%al
80103268:	74 08                	je     80103272 <mpinit+0x92>
8010326a:	3c 04                	cmp    $0x4,%al
8010326c:	0f 85 06 01 00 00    	jne    80103378 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103272:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103279:	66 85 d2             	test   %dx,%dx
8010327c:	74 22                	je     801032a0 <mpinit+0xc0>
8010327e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103281:	89 f0                	mov    %esi,%eax
  sum = 0;
80103283:	31 d2                	xor    %edx,%edx
80103285:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103288:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010328f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103292:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103294:	39 f8                	cmp    %edi,%eax
80103296:	75 f0                	jne    80103288 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103298:	84 d2                	test   %dl,%dl
8010329a:	0f 85 d8 00 00 00    	jne    80103378 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032a0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801032a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801032ac:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032b1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032b8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801032be:	01 d7                	add    %edx,%edi
801032c0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801032c2:	bf 01 00 00 00       	mov    $0x1,%edi
801032c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032ce:	00 
801032cf:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d0:	39 d0                	cmp    %edx,%eax
801032d2:	73 19                	jae    801032ed <mpinit+0x10d>
    switch(*p){
801032d4:	0f b6 08             	movzbl (%eax),%ecx
801032d7:	80 f9 02             	cmp    $0x2,%cl
801032da:	0f 84 80 00 00 00    	je     80103360 <mpinit+0x180>
801032e0:	77 6e                	ja     80103350 <mpinit+0x170>
801032e2:	84 c9                	test   %cl,%cl
801032e4:	74 3a                	je     80103320 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032e6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e9:	39 d0                	cmp    %edx,%eax
801032eb:	72 e7                	jb     801032d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032ed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801032f0:	85 ff                	test   %edi,%edi
801032f2:	0f 84 dd 00 00 00    	je     801033d5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032f8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801032fc:	74 15                	je     80103313 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032fe:	b8 70 00 00 00       	mov    $0x70,%eax
80103303:	ba 22 00 00 00       	mov    $0x22,%edx
80103308:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103309:	ba 23 00 00 00       	mov    $0x23,%edx
8010330e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010330f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103312:	ee                   	out    %al,(%dx)
  }
}
80103313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103316:	5b                   	pop    %ebx
80103317:	5e                   	pop    %esi
80103318:	5f                   	pop    %edi
80103319:	5d                   	pop    %ebp
8010331a:	c3                   	ret
8010331b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103320:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103326:	83 f9 07             	cmp    $0x7,%ecx
80103329:	7f 19                	jg     80103344 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010332b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103331:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103335:	83 c1 01             	add    $0x1,%ecx
80103338:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010333e:	88 9e a0 27 11 80    	mov    %bl,-0x7feed860(%esi)
      p += sizeof(struct mpproc);
80103344:	83 c0 14             	add    $0x14,%eax
      continue;
80103347:	eb 87                	jmp    801032d0 <mpinit+0xf0>
80103349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 8e                	jbe    801032e6 <mpinit+0x106>
80103358:	31 ff                	xor    %edi,%edi
8010335a:	e9 71 ff ff ff       	jmp    801032d0 <mpinit+0xf0>
8010335f:	90                   	nop
      ioapicid = ioapic->apicno;
80103360:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103364:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103367:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010336d:	e9 5e ff ff ff       	jmp    801032d0 <mpinit+0xf0>
80103372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103378:	83 ec 0c             	sub    $0xc,%esp
8010337b:	68 b9 77 10 80       	push   $0x801077b9
80103380:	e8 fb cf ff ff       	call   80100380 <panic>
80103385:	8d 76 00             	lea    0x0(%esi),%esi
{
80103388:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010338d:	eb 0b                	jmp    8010339a <mpinit+0x1ba>
8010338f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103390:	89 f3                	mov    %esi,%ebx
80103392:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103398:	74 de                	je     80103378 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010339a:	83 ec 04             	sub    $0x4,%esp
8010339d:	8d 73 10             	lea    0x10(%ebx),%esi
801033a0:	6a 04                	push   $0x4
801033a2:	68 af 77 10 80       	push   $0x801077af
801033a7:	53                   	push   %ebx
801033a8:	e8 73 15 00 00       	call   80104920 <memcmp>
801033ad:	83 c4 10             	add    $0x10,%esp
801033b0:	85 c0                	test   %eax,%eax
801033b2:	75 dc                	jne    80103390 <mpinit+0x1b0>
801033b4:	89 da                	mov    %ebx,%edx
801033b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033bd:	00 
801033be:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801033c0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033c3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033c6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033c8:	39 d6                	cmp    %edx,%esi
801033ca:	75 f4                	jne    801033c0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033cc:	84 c0                	test   %al,%al
801033ce:	75 c0                	jne    80103390 <mpinit+0x1b0>
801033d0:	e9 5b fe ff ff       	jmp    80103230 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033d5:	83 ec 0c             	sub    $0xc,%esp
801033d8:	68 ec 7b 10 80       	push   $0x80107bec
801033dd:	e8 9e cf ff ff       	call   80100380 <panic>
801033e2:	66 90                	xchg   %ax,%ax
801033e4:	66 90                	xchg   %ax,%ax
801033e6:	66 90                	xchg   %ax,%ax
801033e8:	66 90                	xchg   %ax,%ax
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <picinit>:
801033f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033f5:	ba 21 00 00 00       	mov    $0x21,%edx
801033fa:	ee                   	out    %al,(%dx)
801033fb:	ba a1 00 00 00       	mov    $0xa1,%edx
80103400:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103401:	c3                   	ret
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 0c             	sub    $0xc,%esp
80103419:	8b 75 08             	mov    0x8(%ebp),%esi
8010341c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010341f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103425:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010342b:	e8 20 da ff ff       	call   80100e50 <filealloc>
80103430:	89 06                	mov    %eax,(%esi)
80103432:	85 c0                	test   %eax,%eax
80103434:	0f 84 a5 00 00 00    	je     801034df <pipealloc+0xcf>
8010343a:	e8 11 da ff ff       	call   80100e50 <filealloc>
8010343f:	89 07                	mov    %eax,(%edi)
80103441:	85 c0                	test   %eax,%eax
80103443:	0f 84 84 00 00 00    	je     801034cd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103449:	e8 12 f2 ff ff       	call   80102660 <kalloc>
8010344e:	89 c3                	mov    %eax,%ebx
80103450:	85 c0                	test   %eax,%eax
80103452:	0f 84 a0 00 00 00    	je     801034f8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103458:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010345f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103462:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103465:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010346c:	00 00 00 
  p->nwrite = 0;
8010346f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103476:	00 00 00 
  p->nread = 0;
80103479:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103480:	00 00 00 
  initlock(&p->lock, "pipe");
80103483:	68 d1 77 10 80       	push   $0x801077d1
80103488:	50                   	push   %eax
80103489:	e8 62 11 00 00       	call   801045f0 <initlock>
  (*f0)->type = FD_PIPE;
8010348e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103490:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103493:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103499:	8b 06                	mov    (%esi),%eax
8010349b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010349f:	8b 06                	mov    (%esi),%eax
801034a1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034a5:	8b 06                	mov    (%esi),%eax
801034a7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034aa:	8b 07                	mov    (%edi),%eax
801034ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034b2:	8b 07                	mov    (%edi),%eax
801034b4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034b8:	8b 07                	mov    (%edi),%eax
801034ba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034be:	8b 07                	mov    (%edi),%eax
801034c0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801034c3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034c8:	5b                   	pop    %ebx
801034c9:	5e                   	pop    %esi
801034ca:	5f                   	pop    %edi
801034cb:	5d                   	pop    %ebp
801034cc:	c3                   	ret
  if(*f0)
801034cd:	8b 06                	mov    (%esi),%eax
801034cf:	85 c0                	test   %eax,%eax
801034d1:	74 1e                	je     801034f1 <pipealloc+0xe1>
    fileclose(*f0);
801034d3:	83 ec 0c             	sub    $0xc,%esp
801034d6:	50                   	push   %eax
801034d7:	e8 34 da ff ff       	call   80100f10 <fileclose>
801034dc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034df:	8b 07                	mov    (%edi),%eax
801034e1:	85 c0                	test   %eax,%eax
801034e3:	74 0c                	je     801034f1 <pipealloc+0xe1>
    fileclose(*f1);
801034e5:	83 ec 0c             	sub    $0xc,%esp
801034e8:	50                   	push   %eax
801034e9:	e8 22 da ff ff       	call   80100f10 <fileclose>
801034ee:	83 c4 10             	add    $0x10,%esp
  return -1;
801034f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034f6:	eb cd                	jmp    801034c5 <pipealloc+0xb5>
  if(*f0)
801034f8:	8b 06                	mov    (%esi),%eax
801034fa:	85 c0                	test   %eax,%eax
801034fc:	75 d5                	jne    801034d3 <pipealloc+0xc3>
801034fe:	eb df                	jmp    801034df <pipealloc+0xcf>

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	56                   	push   %esi
80103504:	53                   	push   %ebx
80103505:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103508:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350b:	83 ec 0c             	sub    $0xc,%esp
8010350e:	53                   	push   %ebx
8010350f:	e8 cc 12 00 00       	call   801047e0 <acquire>
  if(writable){
80103514:	83 c4 10             	add    $0x10,%esp
80103517:	85 f6                	test   %esi,%esi
80103519:	74 65                	je     80103580 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351b:	83 ec 0c             	sub    $0xc,%esp
8010351e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103524:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352b:	00 00 00 
    wakeup(&p->nread);
8010352e:	50                   	push   %eax
8010352f:	e8 bc 0b 00 00       	call   801040f0 <wakeup>
80103534:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103537:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010353d:	85 d2                	test   %edx,%edx
8010353f:	75 0a                	jne    8010354b <pipeclose+0x4b>
80103541:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103547:	85 c0                	test   %eax,%eax
80103549:	74 15                	je     80103560 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010354e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103551:	5b                   	pop    %ebx
80103552:	5e                   	pop    %esi
80103553:	5d                   	pop    %ebp
    release(&p->lock);
80103554:	e9 27 12 00 00       	jmp    80104780 <release>
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	53                   	push   %ebx
80103564:	e8 17 12 00 00       	call   80104780 <release>
    kfree((char*)p);
80103569:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010356c:	83 c4 10             	add    $0x10,%esp
}
8010356f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103572:	5b                   	pop    %ebx
80103573:	5e                   	pop    %esi
80103574:	5d                   	pop    %ebp
    kfree((char*)p);
80103575:	e9 26 ef ff ff       	jmp    801024a0 <kfree>
8010357a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103589:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103590:	00 00 00 
    wakeup(&p->nwrite);
80103593:	50                   	push   %eax
80103594:	e8 57 0b 00 00       	call   801040f0 <wakeup>
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	eb 99                	jmp    80103537 <pipeclose+0x37>
8010359e:	66 90                	xchg   %ax,%ax

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	57                   	push   %edi
801035a4:	56                   	push   %esi
801035a5:	53                   	push   %ebx
801035a6:	83 ec 28             	sub    $0x28,%esp
801035a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035ac:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801035af:	53                   	push   %ebx
801035b0:	e8 2b 12 00 00       	call   801047e0 <acquire>
  for(i = 0; i < n; i++){
801035b5:	83 c4 10             	add    $0x10,%esp
801035b8:	85 ff                	test   %edi,%edi
801035ba:	0f 8e ce 00 00 00    	jle    8010368e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801035c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035c9:	89 7d 10             	mov    %edi,0x10(%ebp)
801035cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035cf:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801035d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035d5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035db:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801035ed:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801035f0:	0f 85 b6 00 00 00    	jne    801036ac <pipewrite+0x10c>
801035f6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801035f9:	eb 3b                	jmp    80103636 <pipewrite+0x96>
801035fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103600:	e8 6b 03 00 00       	call   80103970 <myproc>
80103605:	8b 48 24             	mov    0x24(%eax),%ecx
80103608:	85 c9                	test   %ecx,%ecx
8010360a:	75 34                	jne    80103640 <pipewrite+0xa0>
      wakeup(&p->nread);
8010360c:	83 ec 0c             	sub    $0xc,%esp
8010360f:	56                   	push   %esi
80103610:	e8 db 0a 00 00       	call   801040f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103615:	58                   	pop    %eax
80103616:	5a                   	pop    %edx
80103617:	53                   	push   %ebx
80103618:	57                   	push   %edi
80103619:	e8 12 0a 00 00       	call   80104030 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010361e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103624:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010362a:	83 c4 10             	add    $0x10,%esp
8010362d:	05 00 02 00 00       	add    $0x200,%eax
80103632:	39 c2                	cmp    %eax,%edx
80103634:	75 2a                	jne    80103660 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103636:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010363c:	85 c0                	test   %eax,%eax
8010363e:	75 c0                	jne    80103600 <pipewrite+0x60>
        release(&p->lock);
80103640:	83 ec 0c             	sub    $0xc,%esp
80103643:	53                   	push   %ebx
80103644:	e8 37 11 00 00       	call   80104780 <release>
        return -1;
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103651:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103654:	5b                   	pop    %ebx
80103655:	5e                   	pop    %esi
80103656:	5f                   	pop    %edi
80103657:	5d                   	pop    %ebp
80103658:	c3                   	ret
80103659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103660:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103663:	8d 42 01             	lea    0x1(%edx),%eax
80103666:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010366c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010366f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103675:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103678:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010367c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103680:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103683:	39 c1                	cmp    %eax,%ecx
80103685:	0f 85 50 ff ff ff    	jne    801035db <pipewrite+0x3b>
8010368b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010368e:	83 ec 0c             	sub    $0xc,%esp
80103691:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103697:	50                   	push   %eax
80103698:	e8 53 0a 00 00       	call   801040f0 <wakeup>
  release(&p->lock);
8010369d:	89 1c 24             	mov    %ebx,(%esp)
801036a0:	e8 db 10 00 00       	call   80104780 <release>
  return n;
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	89 f8                	mov    %edi,%eax
801036aa:	eb a5                	jmp    80103651 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801036af:	eb b2                	jmp    80103663 <pipewrite+0xc3>
801036b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801036b8:	00 
801036b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	57                   	push   %edi
801036c4:	56                   	push   %esi
801036c5:	53                   	push   %ebx
801036c6:	83 ec 18             	sub    $0x18,%esp
801036c9:	8b 75 08             	mov    0x8(%ebp),%esi
801036cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036cf:	56                   	push   %esi
801036d0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036d6:	e8 05 11 00 00       	call   801047e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036db:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036e1:	83 c4 10             	add    $0x10,%esp
801036e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801036ea:	74 2f                	je     8010371b <piperead+0x5b>
801036ec:	eb 37                	jmp    80103725 <piperead+0x65>
801036ee:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801036f0:	e8 7b 02 00 00       	call   80103970 <myproc>
801036f5:	8b 40 24             	mov    0x24(%eax),%eax
801036f8:	85 c0                	test   %eax,%eax
801036fa:	0f 85 80 00 00 00    	jne    80103780 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103700:	83 ec 08             	sub    $0x8,%esp
80103703:	56                   	push   %esi
80103704:	53                   	push   %ebx
80103705:	e8 26 09 00 00       	call   80104030 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103710:	83 c4 10             	add    $0x10,%esp
80103713:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103719:	75 0a                	jne    80103725 <piperead+0x65>
8010371b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103721:	85 d2                	test   %edx,%edx
80103723:	75 cb                	jne    801036f0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103725:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103728:	31 db                	xor    %ebx,%ebx
8010372a:	85 c9                	test   %ecx,%ecx
8010372c:	7f 26                	jg     80103754 <piperead+0x94>
8010372e:	eb 2c                	jmp    8010375c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0x9c>
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 85 09 00 00       	call   801040f0 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 0d 10 00 00       	call   80104780 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 f2 0f 00 00       	call   80104780 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 20 2d 11 80       	push   $0x80112d20
801037b1:	e8 2a 10 00 00       	call   801047e0 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 17                	jmp    801037d2 <allocproc+0x32>
801037bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	81 c3 80 02 00 00    	add    $0x280,%ebx
801037c6:	81 fb 54 cd 11 80    	cmp    $0x8011cd54,%ebx
801037cc:	0f 84 7e 00 00 00    	je     80103850 <allocproc+0xb0>
    if(p->state == UNUSED)
801037d2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037d5:	85 c0                	test   %eax,%eax
801037d7:	75 e7                	jne    801037c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801037de:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037e1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037e8:	89 43 10             	mov    %eax,0x10(%ebx)
801037eb:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037ee:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801037f3:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801037f9:	e8 82 0f 00 00       	call   80104780 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037fe:	e8 5d ee ff ff       	call   80102660 <kalloc>
80103803:	83 c4 10             	add    $0x10,%esp
80103806:	89 43 08             	mov    %eax,0x8(%ebx)
80103809:	85 c0                	test   %eax,%eax
8010380b:	74 5c                	je     80103869 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010380d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103813:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103816:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010381b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010381e:	c7 40 14 6d 5c 10 80 	movl   $0x80105c6d,0x14(%eax)
  p->context = (struct context*)sp;
80103825:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103828:	6a 14                	push   $0x14
8010382a:	6a 00                	push   $0x0
8010382c:	50                   	push   %eax
8010382d:	e8 ae 10 00 00       	call   801048e0 <memset>
  p->context->eip = (uint)forkret;
80103832:	8b 43 1c             	mov    0x1c(%ebx),%eax

  // Initialize number of system calls
  p->syscalls_count = 0;

  return p;
80103835:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103838:	c7 40 10 80 38 10 80 	movl   $0x80103880,0x10(%eax)
}
8010383f:	89 d8                	mov    %ebx,%eax
  p->syscalls_count = 0;
80103841:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
}
80103848:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010384b:	c9                   	leave
8010384c:	c3                   	ret
8010384d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103850:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103853:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103855:	68 20 2d 11 80       	push   $0x80112d20
8010385a:	e8 21 0f 00 00       	call   80104780 <release>
  return 0;
8010385f:	83 c4 10             	add    $0x10,%esp
}
80103862:	89 d8                	mov    %ebx,%eax
80103864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103867:	c9                   	leave
80103868:	c3                   	ret
    p->state = UNUSED;
80103869:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103870:	31 db                	xor    %ebx,%ebx
80103872:	eb ee                	jmp    80103862 <allocproc+0xc2>
80103874:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010387b:	00 
8010387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103880 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103886:	68 20 2d 11 80       	push   $0x80112d20
8010388b:	e8 f0 0e 00 00       	call   80104780 <release>

  if (first) {
80103890:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103895:	83 c4 10             	add    $0x10,%esp
80103898:	85 c0                	test   %eax,%eax
8010389a:	75 04                	jne    801038a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010389c:	c9                   	leave
8010389d:	c3                   	ret
8010389e:	66 90                	xchg   %ax,%ax
    first = 0;
801038a0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038a7:	00 00 00 
    iinit(ROOTDEV);
801038aa:	83 ec 0c             	sub    $0xc,%esp
801038ad:	6a 01                	push   $0x1
801038af:	e8 cc dc ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
801038b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038bb:	e8 e0 f3 ff ff       	call   80102ca0 <initlog>
}
801038c0:	83 c4 10             	add    $0x10,%esp
801038c3:	c9                   	leave
801038c4:	c3                   	ret
801038c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038cc:	00 
801038cd:	8d 76 00             	lea    0x0(%esi),%esi

801038d0 <pinit>:
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038d6:	68 d6 77 10 80       	push   $0x801077d6
801038db:	68 20 2d 11 80       	push   $0x80112d20
801038e0:	e8 0b 0d 00 00       	call   801045f0 <initlock>
}
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	c9                   	leave
801038e9:	c3                   	ret
801038ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038f0 <mycpu>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	56                   	push   %esi
801038f4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038f5:	9c                   	pushf
801038f6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038f7:	f6 c4 02             	test   $0x2,%ah
801038fa:	75 46                	jne    80103942 <mycpu+0x52>
  apicid = lapicid();
801038fc:	e8 cf ef ff ff       	call   801028d0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103901:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103907:	85 f6                	test   %esi,%esi
80103909:	7e 2a                	jle    80103935 <mycpu+0x45>
8010390b:	31 d2                	xor    %edx,%edx
8010390d:	eb 08                	jmp    80103917 <mycpu+0x27>
8010390f:	90                   	nop
80103910:	83 c2 01             	add    $0x1,%edx
80103913:	39 f2                	cmp    %esi,%edx
80103915:	74 1e                	je     80103935 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103917:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010391d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103924:	39 c3                	cmp    %eax,%ebx
80103926:	75 e8                	jne    80103910 <mycpu+0x20>
}
80103928:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010392b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103931:	5b                   	pop    %ebx
80103932:	5e                   	pop    %esi
80103933:	5d                   	pop    %ebp
80103934:	c3                   	ret
  panic("unknown apicid\n");
80103935:	83 ec 0c             	sub    $0xc,%esp
80103938:	68 dd 77 10 80       	push   $0x801077dd
8010393d:	e8 3e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103942:	83 ec 0c             	sub    $0xc,%esp
80103945:	68 0c 7c 10 80       	push   $0x80107c0c
8010394a:	e8 31 ca ff ff       	call   80100380 <panic>
8010394f:	90                   	nop

80103950 <cpuid>:
cpuid() {
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103956:	e8 95 ff ff ff       	call   801038f0 <mycpu>
}
8010395b:	c9                   	leave
  return mycpu()-cpus;
8010395c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103961:	c1 f8 04             	sar    $0x4,%eax
80103964:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010396a:	c3                   	ret
8010396b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103970 <myproc>:
myproc(void) {
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	53                   	push   %ebx
80103974:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103977:	e8 14 0d 00 00       	call   80104690 <pushcli>
  c = mycpu();
8010397c:	e8 6f ff ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103981:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103987:	e8 54 0d 00 00       	call   801046e0 <popcli>
}
8010398c:	89 d8                	mov    %ebx,%eax
8010398e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103991:	c9                   	leave
80103992:	c3                   	ret
80103993:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010399a:	00 
8010399b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039a0 <userinit>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
801039a4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039a7:	e8 f4 fd ff ff       	call   801037a0 <allocproc>
801039ac:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ae:	a3 54 cd 11 80       	mov    %eax,0x8011cd54
  if((p->pgdir = setupkvm()) == 0)
801039b3:	e8 88 38 00 00       	call   80107240 <setupkvm>
801039b8:	89 43 04             	mov    %eax,0x4(%ebx)
801039bb:	85 c0                	test   %eax,%eax
801039bd:	0f 84 bd 00 00 00    	je     80103a80 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039c3:	83 ec 04             	sub    $0x4,%esp
801039c6:	68 2c 00 00 00       	push   $0x2c
801039cb:	68 60 b4 10 80       	push   $0x8010b460
801039d0:	50                   	push   %eax
801039d1:	e8 4a 35 00 00       	call   80106f20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039d6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039d9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039df:	6a 4c                	push   $0x4c
801039e1:	6a 00                	push   $0x0
801039e3:	ff 73 18             	push   0x18(%ebx)
801039e6:	e8 f5 0e 00 00       	call   801048e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039eb:	8b 43 18             	mov    0x18(%ebx),%eax
801039ee:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039f3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039f6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103a02:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a06:	8b 43 18             	mov    0x18(%ebx),%eax
80103a09:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a0d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a11:	8b 43 18             	mov    0x18(%ebx),%eax
80103a14:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a18:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a1c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a26:	8b 43 18             	mov    0x18(%ebx),%eax
80103a29:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a30:	8b 43 18             	mov    0x18(%ebx),%eax
80103a33:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a3a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a3d:	6a 10                	push   $0x10
80103a3f:	68 06 78 10 80       	push   $0x80107806
80103a44:	50                   	push   %eax
80103a45:	e8 46 10 00 00       	call   80104a90 <safestrcpy>
  p->cwd = namei("/");
80103a4a:	c7 04 24 0f 78 10 80 	movl   $0x8010780f,(%esp)
80103a51:	e8 2a e6 ff ff       	call   80102080 <namei>
80103a56:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a59:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a60:	e8 7b 0d 00 00       	call   801047e0 <acquire>
  p->state = RUNNABLE;
80103a65:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a6c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a73:	e8 08 0d 00 00       	call   80104780 <release>
}
80103a78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a7b:	83 c4 10             	add    $0x10,%esp
80103a7e:	c9                   	leave
80103a7f:	c3                   	ret
    panic("userinit: out of memory?");
80103a80:	83 ec 0c             	sub    $0xc,%esp
80103a83:	68 ed 77 10 80       	push   $0x801077ed
80103a88:	e8 f3 c8 ff ff       	call   80100380 <panic>
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi

80103a90 <growproc>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	56                   	push   %esi
80103a94:	53                   	push   %ebx
80103a95:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a98:	e8 f3 0b 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103a9d:	e8 4e fe ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103aa2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aa8:	e8 33 0c 00 00       	call   801046e0 <popcli>
  sz = curproc->sz;
80103aad:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103aaf:	85 f6                	test   %esi,%esi
80103ab1:	7f 1d                	jg     80103ad0 <growproc+0x40>
  } else if(n < 0){
80103ab3:	75 3b                	jne    80103af0 <growproc+0x60>
  switchuvm(curproc);
80103ab5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ab8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aba:	53                   	push   %ebx
80103abb:	e8 50 33 00 00       	call   80106e10 <switchuvm>
  return 0;
80103ac0:	83 c4 10             	add    $0x10,%esp
80103ac3:	31 c0                	xor    %eax,%eax
}
80103ac5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac8:	5b                   	pop    %ebx
80103ac9:	5e                   	pop    %esi
80103aca:	5d                   	pop    %ebp
80103acb:	c3                   	ret
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ad0:	83 ec 04             	sub    $0x4,%esp
80103ad3:	01 c6                	add    %eax,%esi
80103ad5:	56                   	push   %esi
80103ad6:	50                   	push   %eax
80103ad7:	ff 73 04             	push   0x4(%ebx)
80103ada:	e8 91 35 00 00       	call   80107070 <allocuvm>
80103adf:	83 c4 10             	add    $0x10,%esp
80103ae2:	85 c0                	test   %eax,%eax
80103ae4:	75 cf                	jne    80103ab5 <growproc+0x25>
      return -1;
80103ae6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103aeb:	eb d8                	jmp    80103ac5 <growproc+0x35>
80103aed:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	push   0x4(%ebx)
80103afa:	e8 91 36 00 00       	call   80107190 <deallocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 af                	jne    80103ab5 <growproc+0x25>
80103b06:	eb de                	jmp    80103ae6 <growproc+0x56>
80103b08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b0f:	00 

80103b10 <fork>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b19:	e8 72 0b 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103b1e:	e8 cd fd ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103b23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b29:	e8 b2 0b 00 00       	call   801046e0 <popcli>
  if((np = allocproc()) == 0){
80103b2e:	e8 6d fc ff ff       	call   801037a0 <allocproc>
80103b33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b36:	85 c0                	test   %eax,%eax
80103b38:	0f 84 d6 00 00 00    	je     80103c14 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b3e:	83 ec 08             	sub    $0x8,%esp
80103b41:	ff 33                	push   (%ebx)
80103b43:	89 c7                	mov    %eax,%edi
80103b45:	ff 73 04             	push   0x4(%ebx)
80103b48:	e8 e3 37 00 00       	call   80107330 <copyuvm>
80103b4d:	83 c4 10             	add    $0x10,%esp
80103b50:	89 47 04             	mov    %eax,0x4(%edi)
80103b53:	85 c0                	test   %eax,%eax
80103b55:	0f 84 9a 00 00 00    	je     80103bf5 <fork+0xe5>
  np->sz = curproc->sz;
80103b5b:	8b 03                	mov    (%ebx),%eax
80103b5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b60:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b62:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b65:	89 c8                	mov    %ecx,%eax
80103b67:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b6a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b6f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b74:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b76:	8b 40 18             	mov    0x18(%eax),%eax
80103b79:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b80:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b84:	85 c0                	test   %eax,%eax
80103b86:	74 13                	je     80103b9b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b88:	83 ec 0c             	sub    $0xc,%esp
80103b8b:	50                   	push   %eax
80103b8c:	e8 2f d3 ff ff       	call   80100ec0 <filedup>
80103b91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b94:	83 c4 10             	add    $0x10,%esp
80103b97:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b9b:	83 c6 01             	add    $0x1,%esi
80103b9e:	83 fe 10             	cmp    $0x10,%esi
80103ba1:	75 dd                	jne    80103b80 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ba3:	83 ec 0c             	sub    $0xc,%esp
80103ba6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ba9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bac:	e8 bf db ff ff       	call   80101770 <idup>
80103bb1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bb4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bb7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bba:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bbd:	6a 10                	push   $0x10
80103bbf:	53                   	push   %ebx
80103bc0:	50                   	push   %eax
80103bc1:	e8 ca 0e 00 00       	call   80104a90 <safestrcpy>
  pid = np->pid;
80103bc6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bc9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bd0:	e8 0b 0c 00 00       	call   801047e0 <acquire>
  np->state = RUNNABLE;
80103bd5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bdc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103be3:	e8 98 0b 00 00       	call   80104780 <release>
  return pid;
80103be8:	83 c4 10             	add    $0x10,%esp
}
80103beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bee:	89 d8                	mov    %ebx,%eax
80103bf0:	5b                   	pop    %ebx
80103bf1:	5e                   	pop    %esi
80103bf2:	5f                   	pop    %edi
80103bf3:	5d                   	pop    %ebp
80103bf4:	c3                   	ret
    kfree(np->kstack);
80103bf5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bf8:	83 ec 0c             	sub    $0xc,%esp
80103bfb:	ff 73 08             	push   0x8(%ebx)
80103bfe:	e8 9d e8 ff ff       	call   801024a0 <kfree>
    np->kstack = 0;
80103c03:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c0a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c0d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c14:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c19:	eb d0                	jmp    80103beb <fork+0xdb>
80103c1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103c20 <scheduler>:
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	57                   	push   %edi
80103c24:	56                   	push   %esi
80103c25:	53                   	push   %ebx
80103c26:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c29:	e8 c2 fc ff ff       	call   801038f0 <mycpu>
  c->proc = 0;
80103c2e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c35:	00 00 00 
  struct cpu *c = mycpu();
80103c38:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c3a:	8d 78 04             	lea    0x4(%eax),%edi
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c40:	fb                   	sti
    acquire(&ptable.lock);
80103c41:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c44:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c49:	68 20 2d 11 80       	push   $0x80112d20
80103c4e:	e8 8d 0b 00 00       	call   801047e0 <acquire>
80103c53:	83 c4 10             	add    $0x10,%esp
80103c56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c5d:	00 
80103c5e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103c60:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c64:	75 33                	jne    80103c99 <scheduler+0x79>
      switchuvm(p);
80103c66:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c69:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c6f:	53                   	push   %ebx
80103c70:	e8 9b 31 00 00       	call   80106e10 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c75:	58                   	pop    %eax
80103c76:	5a                   	pop    %edx
80103c77:	ff 73 1c             	push   0x1c(%ebx)
80103c7a:	57                   	push   %edi
      p->state = RUNNING;
80103c7b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c82:	e8 64 0e 00 00       	call   80104aeb <swtch>
      switchkvm();
80103c87:	e8 74 31 00 00       	call   80106e00 <switchkvm>
      c->proc = 0;
80103c8c:	83 c4 10             	add    $0x10,%esp
80103c8f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c96:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c99:	81 c3 80 02 00 00    	add    $0x280,%ebx
80103c9f:	81 fb 54 cd 11 80    	cmp    $0x8011cd54,%ebx
80103ca5:	75 b9                	jne    80103c60 <scheduler+0x40>
    release(&ptable.lock);
80103ca7:	83 ec 0c             	sub    $0xc,%esp
80103caa:	68 20 2d 11 80       	push   $0x80112d20
80103caf:	e8 cc 0a 00 00       	call   80104780 <release>
    sti();
80103cb4:	83 c4 10             	add    $0x10,%esp
80103cb7:	eb 87                	jmp    80103c40 <scheduler+0x20>
80103cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cc0 <sched>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	56                   	push   %esi
80103cc4:	53                   	push   %ebx
  pushcli();
80103cc5:	e8 c6 09 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103cca:	e8 21 fc ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103ccf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cd5:	e8 06 0a 00 00       	call   801046e0 <popcli>
  if(!holding(&ptable.lock))
80103cda:	83 ec 0c             	sub    $0xc,%esp
80103cdd:	68 20 2d 11 80       	push   $0x80112d20
80103ce2:	e8 59 0a 00 00       	call   80104740 <holding>
80103ce7:	83 c4 10             	add    $0x10,%esp
80103cea:	85 c0                	test   %eax,%eax
80103cec:	74 4f                	je     80103d3d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103cee:	e8 fd fb ff ff       	call   801038f0 <mycpu>
80103cf3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103cfa:	75 68                	jne    80103d64 <sched+0xa4>
  if(p->state == RUNNING)
80103cfc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d00:	74 55                	je     80103d57 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d02:	9c                   	pushf
80103d03:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d04:	f6 c4 02             	test   $0x2,%ah
80103d07:	75 41                	jne    80103d4a <sched+0x8a>
  intena = mycpu()->intena;
80103d09:	e8 e2 fb ff ff       	call   801038f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d0e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d11:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d17:	e8 d4 fb ff ff       	call   801038f0 <mycpu>
80103d1c:	83 ec 08             	sub    $0x8,%esp
80103d1f:	ff 70 04             	push   0x4(%eax)
80103d22:	53                   	push   %ebx
80103d23:	e8 c3 0d 00 00       	call   80104aeb <swtch>
  mycpu()->intena = intena;
80103d28:	e8 c3 fb ff ff       	call   801038f0 <mycpu>
}
80103d2d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d30:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d39:	5b                   	pop    %ebx
80103d3a:	5e                   	pop    %esi
80103d3b:	5d                   	pop    %ebp
80103d3c:	c3                   	ret
    panic("sched ptable.lock");
80103d3d:	83 ec 0c             	sub    $0xc,%esp
80103d40:	68 11 78 10 80       	push   $0x80107811
80103d45:	e8 36 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d4a:	83 ec 0c             	sub    $0xc,%esp
80103d4d:	68 3d 78 10 80       	push   $0x8010783d
80103d52:	e8 29 c6 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d57:	83 ec 0c             	sub    $0xc,%esp
80103d5a:	68 2f 78 10 80       	push   $0x8010782f
80103d5f:	e8 1c c6 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d64:	83 ec 0c             	sub    $0xc,%esp
80103d67:	68 23 78 10 80       	push   $0x80107823
80103d6c:	e8 0f c6 ff ff       	call   80100380 <panic>
80103d71:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d78:	00 
80103d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d80 <exit>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103d89:	e8 e2 fb ff ff       	call   80103970 <myproc>
  if(curproc == initproc)
80103d8e:	39 05 54 cd 11 80    	cmp    %eax,0x8011cd54
80103d94:	0f 84 07 01 00 00    	je     80103ea1 <exit+0x121>
80103d9a:	89 c3                	mov    %eax,%ebx
80103d9c:	8d 70 28             	lea    0x28(%eax),%esi
80103d9f:	8d 78 68             	lea    0x68(%eax),%edi
80103da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103da8:	8b 06                	mov    (%esi),%eax
80103daa:	85 c0                	test   %eax,%eax
80103dac:	74 12                	je     80103dc0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dae:	83 ec 0c             	sub    $0xc,%esp
80103db1:	50                   	push   %eax
80103db2:	e8 59 d1 ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
80103db7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103dbd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103dc0:	83 c6 04             	add    $0x4,%esi
80103dc3:	39 f7                	cmp    %esi,%edi
80103dc5:	75 e1                	jne    80103da8 <exit+0x28>
  begin_op();
80103dc7:	e8 74 ef ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80103dcc:	83 ec 0c             	sub    $0xc,%esp
80103dcf:	ff 73 68             	push   0x68(%ebx)
80103dd2:	e8 f9 da ff ff       	call   801018d0 <iput>
  end_op();
80103dd7:	e8 d4 ef ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
80103ddc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103de3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dea:	e8 f1 09 00 00       	call   801047e0 <acquire>
  wakeup1(curproc->parent);
80103def:	8b 53 14             	mov    0x14(%ebx),%edx
80103df2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103df5:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dfa:	eb 10                	jmp    80103e0c <exit+0x8c>
80103dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e00:	05 80 02 00 00       	add    $0x280,%eax
80103e05:	3d 54 cd 11 80       	cmp    $0x8011cd54,%eax
80103e0a:	74 1e                	je     80103e2a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
80103e0c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e10:	75 ee                	jne    80103e00 <exit+0x80>
80103e12:	3b 50 20             	cmp    0x20(%eax),%edx
80103e15:	75 e9                	jne    80103e00 <exit+0x80>
      p->state = RUNNABLE;
80103e17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e1e:	05 80 02 00 00       	add    $0x280,%eax
80103e23:	3d 54 cd 11 80       	cmp    $0x8011cd54,%eax
80103e28:	75 e2                	jne    80103e0c <exit+0x8c>
      p->parent = initproc;
80103e2a:	8b 0d 54 cd 11 80    	mov    0x8011cd54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e30:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e35:	eb 17                	jmp    80103e4e <exit+0xce>
80103e37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e3e:	00 
80103e3f:	90                   	nop
80103e40:	81 c2 80 02 00 00    	add    $0x280,%edx
80103e46:	81 fa 54 cd 11 80    	cmp    $0x8011cd54,%edx
80103e4c:	74 3a                	je     80103e88 <exit+0x108>
    if(p->parent == curproc){
80103e4e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e51:	75 ed                	jne    80103e40 <exit+0xc0>
      if(p->state == ZOMBIE)
80103e53:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e57:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e5a:	75 e4                	jne    80103e40 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e5c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e61:	eb 11                	jmp    80103e74 <exit+0xf4>
80103e63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e68:	05 80 02 00 00       	add    $0x280,%eax
80103e6d:	3d 54 cd 11 80       	cmp    $0x8011cd54,%eax
80103e72:	74 cc                	je     80103e40 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e74:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e78:	75 ee                	jne    80103e68 <exit+0xe8>
80103e7a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e7d:	75 e9                	jne    80103e68 <exit+0xe8>
      p->state = RUNNABLE;
80103e7f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e86:	eb e0                	jmp    80103e68 <exit+0xe8>
  curproc->state = ZOMBIE;
80103e88:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103e8f:	e8 2c fe ff ff       	call   80103cc0 <sched>
  panic("zombie exit");
80103e94:	83 ec 0c             	sub    $0xc,%esp
80103e97:	68 5e 78 10 80       	push   $0x8010785e
80103e9c:	e8 df c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ea1:	83 ec 0c             	sub    $0xc,%esp
80103ea4:	68 51 78 10 80       	push   $0x80107851
80103ea9:	e8 d2 c4 ff ff       	call   80100380 <panic>
80103eae:	66 90                	xchg   %ax,%ax

80103eb0 <wait>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
  pushcli();
80103eb5:	e8 d6 07 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103eba:	e8 31 fa ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103ebf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ec5:	e8 16 08 00 00       	call   801046e0 <popcli>
  acquire(&ptable.lock);
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 20 2d 11 80       	push   $0x80112d20
80103ed2:	e8 09 09 00 00       	call   801047e0 <acquire>
80103ed7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103eda:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103edc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ee1:	eb 13                	jmp    80103ef6 <wait+0x46>
80103ee3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ee8:	81 c3 80 02 00 00    	add    $0x280,%ebx
80103eee:	81 fb 54 cd 11 80    	cmp    $0x8011cd54,%ebx
80103ef4:	74 1e                	je     80103f14 <wait+0x64>
      if(p->parent != curproc)
80103ef6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ef9:	75 ed                	jne    80103ee8 <wait+0x38>
      if(p->state == ZOMBIE){
80103efb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103eff:	74 5f                	je     80103f60 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f01:	81 c3 80 02 00 00    	add    $0x280,%ebx
      havekids = 1;
80103f07:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0c:	81 fb 54 cd 11 80    	cmp    $0x8011cd54,%ebx
80103f12:	75 e2                	jne    80103ef6 <wait+0x46>
    if(!havekids || curproc->killed){
80103f14:	85 c0                	test   %eax,%eax
80103f16:	0f 84 9a 00 00 00    	je     80103fb6 <wait+0x106>
80103f1c:	8b 46 24             	mov    0x24(%esi),%eax
80103f1f:	85 c0                	test   %eax,%eax
80103f21:	0f 85 8f 00 00 00    	jne    80103fb6 <wait+0x106>
  pushcli();
80103f27:	e8 64 07 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103f2c:	e8 bf f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103f31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f37:	e8 a4 07 00 00       	call   801046e0 <popcli>
  if(p == 0)
80103f3c:	85 db                	test   %ebx,%ebx
80103f3e:	0f 84 89 00 00 00    	je     80103fcd <wait+0x11d>
  p->chan = chan;
80103f44:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f47:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f4e:	e8 6d fd ff ff       	call   80103cc0 <sched>
  p->chan = 0;
80103f53:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f5a:	e9 7b ff ff ff       	jmp    80103eda <wait+0x2a>
80103f5f:	90                   	nop
        kfree(p->kstack);
80103f60:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103f63:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f66:	ff 73 08             	push   0x8(%ebx)
80103f69:	e8 32 e5 ff ff       	call   801024a0 <kfree>
        p->kstack = 0;
80103f6e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f75:	5a                   	pop    %edx
80103f76:	ff 73 04             	push   0x4(%ebx)
80103f79:	e8 42 32 00 00       	call   801071c0 <freevm>
        p->pid = 0;
80103f7e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f85:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f8c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f90:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f97:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f9e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fa5:	e8 d6 07 00 00       	call   80104780 <release>
        return pid;
80103faa:	83 c4 10             	add    $0x10,%esp
}
80103fad:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fb0:	89 f0                	mov    %esi,%eax
80103fb2:	5b                   	pop    %ebx
80103fb3:	5e                   	pop    %esi
80103fb4:	5d                   	pop    %ebp
80103fb5:	c3                   	ret
      release(&ptable.lock);
80103fb6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fb9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fbe:	68 20 2d 11 80       	push   $0x80112d20
80103fc3:	e8 b8 07 00 00       	call   80104780 <release>
      return -1;
80103fc8:	83 c4 10             	add    $0x10,%esp
80103fcb:	eb e0                	jmp    80103fad <wait+0xfd>
    panic("sleep");
80103fcd:	83 ec 0c             	sub    $0xc,%esp
80103fd0:	68 6a 78 10 80       	push   $0x8010786a
80103fd5:	e8 a6 c3 ff ff       	call   80100380 <panic>
80103fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103fe0 <yield>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	53                   	push   %ebx
80103fe4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103fe7:	68 20 2d 11 80       	push   $0x80112d20
80103fec:	e8 ef 07 00 00       	call   801047e0 <acquire>
  pushcli();
80103ff1:	e8 9a 06 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103ff6:	e8 f5 f8 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103ffb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104001:	e8 da 06 00 00       	call   801046e0 <popcli>
  myproc()->state = RUNNABLE;
80104006:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010400d:	e8 ae fc ff ff       	call   80103cc0 <sched>
  release(&ptable.lock);
80104012:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104019:	e8 62 07 00 00       	call   80104780 <release>
}
8010401e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104021:	83 c4 10             	add    $0x10,%esp
80104024:	c9                   	leave
80104025:	c3                   	ret
80104026:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010402d:	00 
8010402e:	66 90                	xchg   %ax,%ax

80104030 <sleep>:
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	57                   	push   %edi
80104034:	56                   	push   %esi
80104035:	53                   	push   %ebx
80104036:	83 ec 0c             	sub    $0xc,%esp
80104039:	8b 7d 08             	mov    0x8(%ebp),%edi
8010403c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010403f:	e8 4c 06 00 00       	call   80104690 <pushcli>
  c = mycpu();
80104044:	e8 a7 f8 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80104049:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010404f:	e8 8c 06 00 00       	call   801046e0 <popcli>
  if(p == 0)
80104054:	85 db                	test   %ebx,%ebx
80104056:	0f 84 87 00 00 00    	je     801040e3 <sleep+0xb3>
  if(lk == 0)
8010405c:	85 f6                	test   %esi,%esi
8010405e:	74 76                	je     801040d6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104060:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104066:	74 50                	je     801040b8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	68 20 2d 11 80       	push   $0x80112d20
80104070:	e8 6b 07 00 00       	call   801047e0 <acquire>
    release(lk);
80104075:	89 34 24             	mov    %esi,(%esp)
80104078:	e8 03 07 00 00       	call   80104780 <release>
  p->chan = chan;
8010407d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104080:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104087:	e8 34 fc ff ff       	call   80103cc0 <sched>
  p->chan = 0;
8010408c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104093:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010409a:	e8 e1 06 00 00       	call   80104780 <release>
    acquire(lk);
8010409f:	89 75 08             	mov    %esi,0x8(%ebp)
801040a2:	83 c4 10             	add    $0x10,%esp
}
801040a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040a8:	5b                   	pop    %ebx
801040a9:	5e                   	pop    %esi
801040aa:	5f                   	pop    %edi
801040ab:	5d                   	pop    %ebp
    acquire(lk);
801040ac:	e9 2f 07 00 00       	jmp    801047e0 <acquire>
801040b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040b8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040bb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040c2:	e8 f9 fb ff ff       	call   80103cc0 <sched>
  p->chan = 0;
801040c7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040d1:	5b                   	pop    %ebx
801040d2:	5e                   	pop    %esi
801040d3:	5f                   	pop    %edi
801040d4:	5d                   	pop    %ebp
801040d5:	c3                   	ret
    panic("sleep without lk");
801040d6:	83 ec 0c             	sub    $0xc,%esp
801040d9:	68 70 78 10 80       	push   $0x80107870
801040de:	e8 9d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
801040e3:	83 ec 0c             	sub    $0xc,%esp
801040e6:	68 6a 78 10 80       	push   $0x8010786a
801040eb:	e8 90 c2 ff ff       	call   80100380 <panic>

801040f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	53                   	push   %ebx
801040f4:	83 ec 10             	sub    $0x10,%esp
801040f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801040fa:	68 20 2d 11 80       	push   $0x80112d20
801040ff:	e8 dc 06 00 00       	call   801047e0 <acquire>
80104104:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104107:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010410c:	eb 0e                	jmp    8010411c <wakeup+0x2c>
8010410e:	66 90                	xchg   %ax,%ax
80104110:	05 80 02 00 00       	add    $0x280,%eax
80104115:	3d 54 cd 11 80       	cmp    $0x8011cd54,%eax
8010411a:	74 1e                	je     8010413a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010411c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104120:	75 ee                	jne    80104110 <wakeup+0x20>
80104122:	3b 58 20             	cmp    0x20(%eax),%ebx
80104125:	75 e9                	jne    80104110 <wakeup+0x20>
      p->state = RUNNABLE;
80104127:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010412e:	05 80 02 00 00       	add    $0x280,%eax
80104133:	3d 54 cd 11 80       	cmp    $0x8011cd54,%eax
80104138:	75 e2                	jne    8010411c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010413a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104141:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104144:	c9                   	leave
  release(&ptable.lock);
80104145:	e9 36 06 00 00       	jmp    80104780 <release>
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
80104157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010415a:	68 20 2d 11 80       	push   $0x80112d20
8010415f:	e8 7c 06 00 00       	call   801047e0 <acquire>
80104164:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104167:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010416c:	eb 0e                	jmp    8010417c <kill+0x2c>
8010416e:	66 90                	xchg   %ax,%ax
80104170:	05 80 02 00 00       	add    $0x280,%eax
80104175:	3d 54 cd 11 80       	cmp    $0x8011cd54,%eax
8010417a:	74 34                	je     801041b0 <kill+0x60>
    if(p->pid == pid){
8010417c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010417f:	75 ef                	jne    80104170 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104181:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104185:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010418c:	75 07                	jne    80104195 <kill+0x45>
        p->state = RUNNABLE;
8010418e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104195:	83 ec 0c             	sub    $0xc,%esp
80104198:	68 20 2d 11 80       	push   $0x80112d20
8010419d:	e8 de 05 00 00       	call   80104780 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041a5:	83 c4 10             	add    $0x10,%esp
801041a8:	31 c0                	xor    %eax,%eax
}
801041aa:	c9                   	leave
801041ab:	c3                   	ret
801041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801041b0:	83 ec 0c             	sub    $0xc,%esp
801041b3:	68 20 2d 11 80       	push   $0x80112d20
801041b8:	e8 c3 05 00 00       	call   80104780 <release>
}
801041bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041c0:	83 c4 10             	add    $0x10,%esp
801041c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041c8:	c9                   	leave
801041c9:	c3                   	ret
801041ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041d0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041d8:	53                   	push   %ebx
801041d9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801041de:	83 ec 3c             	sub    $0x3c,%esp
801041e1:	eb 27                	jmp    8010420a <procdump+0x3a>
801041e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801041e8:	83 ec 0c             	sub    $0xc,%esp
801041eb:	68 fe 7a 10 80       	push   $0x80107afe
801041f0:	e8 bb c4 ff ff       	call   801006b0 <cprintf>
801041f5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f8:	81 c3 80 02 00 00    	add    $0x280,%ebx
801041fe:	81 fb c0 cd 11 80    	cmp    $0x8011cdc0,%ebx
80104204:	0f 84 7e 00 00 00    	je     80104288 <procdump+0xb8>
    if(p->state == UNUSED)
8010420a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010420d:	85 c0                	test   %eax,%eax
8010420f:	74 e7                	je     801041f8 <procdump+0x28>
      state = "???";
80104211:	ba 81 78 10 80       	mov    $0x80107881,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104216:	83 f8 05             	cmp    $0x5,%eax
80104219:	77 11                	ja     8010422c <procdump+0x5c>
8010421b:	8b 14 85 20 7f 10 80 	mov    -0x7fef80e0(,%eax,4),%edx
      state = "???";
80104222:	b8 81 78 10 80       	mov    $0x80107881,%eax
80104227:	85 d2                	test   %edx,%edx
80104229:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010422c:	53                   	push   %ebx
8010422d:	52                   	push   %edx
8010422e:	ff 73 a4             	push   -0x5c(%ebx)
80104231:	68 85 78 10 80       	push   $0x80107885
80104236:	e8 75 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
8010423b:	83 c4 10             	add    $0x10,%esp
8010423e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104242:	75 a4                	jne    801041e8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104244:	83 ec 08             	sub    $0x8,%esp
80104247:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010424a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010424d:	50                   	push   %eax
8010424e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104251:	8b 40 0c             	mov    0xc(%eax),%eax
80104254:	83 c0 08             	add    $0x8,%eax
80104257:	50                   	push   %eax
80104258:	e8 b3 03 00 00       	call   80104610 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010425d:	83 c4 10             	add    $0x10,%esp
80104260:	8b 17                	mov    (%edi),%edx
80104262:	85 d2                	test   %edx,%edx
80104264:	74 82                	je     801041e8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104266:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104269:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010426c:	52                   	push   %edx
8010426d:	68 c1 75 10 80       	push   $0x801075c1
80104272:	e8 39 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104277:	83 c4 10             	add    $0x10,%esp
8010427a:	39 f7                	cmp    %esi,%edi
8010427c:	75 e2                	jne    80104260 <procdump+0x90>
8010427e:	e9 65 ff ff ff       	jmp    801041e8 <procdump+0x18>
80104283:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104288:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010428b:	5b                   	pop    %ebx
8010428c:	5e                   	pop    %esi
8010428d:	5f                   	pop    %edi
8010428e:	5d                   	pop    %ebp
8010428f:	c3                   	ret

80104290 <create_palindrome>:

void
create_palindrome(int num){
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	56                   	push   %esi
80104294:	53                   	push   %ebx
80104295:	8b 45 08             	mov    0x8(%ebp),%eax
  int ans = num;
  while (num != 0)
80104298:	85 c0                	test   %eax,%eax
8010429a:	74 2d                	je     801042c9 <create_palindrome+0x39>
8010429c:	89 c1                	mov    %eax,%ecx
  {
    ans = ans * 10 + num % 10;
8010429e:	be 67 66 66 66       	mov    $0x66666667,%esi
801042a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801042a8:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
801042ab:	89 c8                	mov    %ecx,%eax
801042ad:	f7 ee                	imul   %esi
801042af:	89 c8                	mov    %ecx,%eax
801042b1:	c1 f8 1f             	sar    $0x1f,%eax
801042b4:	c1 fa 02             	sar    $0x2,%edx
801042b7:	29 c2                	sub    %eax,%edx
801042b9:	8d 04 92             	lea    (%edx,%edx,4),%eax
801042bc:	01 c0                	add    %eax,%eax
801042be:	29 c1                	sub    %eax,%ecx
801042c0:	8d 04 59             	lea    (%ecx,%ebx,2),%eax
    num /= 10;
801042c3:	89 d1                	mov    %edx,%ecx
  while (num != 0)
801042c5:	85 d2                	test   %edx,%edx
801042c7:	75 df                	jne    801042a8 <create_palindrome+0x18>
  }
  cprintf("%d\n", ans);
801042c9:	83 ec 08             	sub    $0x8,%esp
801042cc:	50                   	push   %eax
801042cd:	68 ab 77 10 80       	push   $0x801077ab
801042d2:	e8 d9 c3 ff ff       	call   801006b0 <cprintf>
}
801042d7:	83 c4 10             	add    $0x10,%esp
801042da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042dd:	5b                   	pop    %ebx
801042de:	5e                   	pop    %esi
801042df:	5d                   	pop    %ebp
801042e0:	c3                   	ret
801042e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801042e8:	00 
801042e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042f0 <sort_syscalls>:

int
sort_syscalls(int pid)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	56                   	push   %esi
801042f5:	53                   	push   %ebx
  char *tmp_name;
  struct proc *p;

  // Find the process with the given PID
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042f6:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801042fb:	83 ec 28             	sub    $0x28,%esp
801042fe:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&ptable.lock);
80104301:	68 20 2d 11 80       	push   $0x80112d20
80104306:	e8 d5 04 00 00       	call   801047e0 <acquire>
8010430b:	83 c4 10             	add    $0x10,%esp
8010430e:	eb 12                	jmp    80104322 <sort_syscalls+0x32>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104310:	81 c3 80 02 00 00    	add    $0x280,%ebx
80104316:	81 fb 54 cd 11 80    	cmp    $0x8011cd54,%ebx
8010431c:	0f 84 01 01 00 00    	je     80104423 <sort_syscalls+0x133>
    if(p->pid == pid){
80104322:	39 7b 10             	cmp    %edi,0x10(%ebx)
80104325:	75 e9                	jne    80104310 <sort_syscalls+0x20>
      // Sort system calls
      for(i = 0; i < p->syscalls_count-1; i++){
80104327:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010432a:	83 f8 01             	cmp    $0x1,%eax
8010432d:	7e 6f                	jle    8010439e <sort_syscalls+0xae>
8010432f:	89 c1                	mov    %eax,%ecx
80104331:	8d 74 83 7c          	lea    0x7c(%ebx,%eax,4),%esi
80104335:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
8010433b:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010433e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for(j = 0; j < p->syscalls_count-i-1; j++){
80104348:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010434b:	83 f9 01             	cmp    $0x1,%ecx
8010434e:	0f 8e c4 00 00 00    	jle    80104418 <sort_syscalls+0x128>
80104354:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80104357:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010435e:	00 
8010435f:	90                   	nop
          if(p->syscall_num[j] > p->syscall_num[j+1]){
80104360:	8b 10                	mov    (%eax),%edx
80104362:	8b 48 04             	mov    0x4(%eax),%ecx
80104365:	39 ca                	cmp    %ecx,%edx
80104367:	7e 1d                	jle    80104386 <sort_syscalls+0x96>
            tmp_num = p->syscall_num[j];
            tmp_name = p->syscall_name[j];
            
            p->syscall_num[j] = p->syscall_num[j+1];
            p->syscall_name[j] = p->syscall_name[j+1];
80104369:	8b 98 00 01 00 00    	mov    0x100(%eax),%ebx

            p->syscall_num[j+1] = tmp_num;
8010436f:	89 50 04             	mov    %edx,0x4(%eax)
            p->syscall_name[j] = p->syscall_name[j+1];
80104372:	8b 90 04 01 00 00    	mov    0x104(%eax),%edx
            p->syscall_num[j] = p->syscall_num[j+1];
80104378:	89 08                	mov    %ecx,(%eax)
            p->syscall_name[j] = p->syscall_name[j+1];
8010437a:	89 98 04 01 00 00    	mov    %ebx,0x104(%eax)
80104380:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
        for(j = 0; j < p->syscalls_count-i-1; j++){
80104386:	83 c0 04             	add    $0x4,%eax
80104389:	39 f0                	cmp    %esi,%eax
8010438b:	75 d3                	jne    80104360 <sort_syscalls+0x70>
8010438d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      for(i = 0; i < p->syscalls_count-1; i++){
80104390:	83 ee 04             	sub    $0x4,%esi
80104393:	83 e9 01             	sub    $0x1,%ecx
80104396:	83 f9 01             	cmp    $0x1,%ecx
80104399:	75 ad                	jne    80104348 <sort_syscalls+0x58>
8010439b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
            p->syscall_name[j+1] = tmp_name;
          }
        }
      }

      cprintf("System calls for process %d:\n", pid);
8010439e:	83 ec 08             	sub    $0x8,%esp
801043a1:	57                   	push   %edi
801043a2:	68 8e 78 10 80       	push   $0x8010788e
801043a7:	e8 04 c3 ff ff       	call   801006b0 <cprintf>
      for(i = 0; i < p->syscalls_count-1; i++)
801043ac:	83 c4 10             	add    $0x10,%esp
801043af:	83 7b 7c 01          	cmpl   $0x1,0x7c(%ebx)
801043b3:	7e 42                	jle    801043f7 <sort_syscalls+0x107>
  int i, j, tmp_num, last_one = 0;
801043b5:	31 d2                	xor    %edx,%edx
      for(i = 0; i < p->syscalls_count-1; i++)
801043b7:	31 f6                	xor    %esi,%esi
801043b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(p->syscall_num[i] != last_one){
801043c0:	8b 84 b3 80 00 00 00 	mov    0x80(%ebx,%esi,4),%eax
801043c7:	39 d0                	cmp    %edx,%eax
801043c9:	74 1f                	je     801043ea <sort_syscalls+0xfa>
          cprintf("Syscall #%d: %s\n", p->syscall_num[i], p->syscall_name[i]);
801043cb:	83 ec 04             	sub    $0x4,%esp
801043ce:	ff b4 b3 80 01 00 00 	push   0x180(%ebx,%esi,4)
801043d5:	50                   	push   %eax
801043d6:	68 ac 78 10 80       	push   $0x801078ac
801043db:	e8 d0 c2 ff ff       	call   801006b0 <cprintf>
          last_one = p->syscall_num[i];
801043e0:	8b 94 b3 80 00 00 00 	mov    0x80(%ebx,%esi,4),%edx
801043e7:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < p->syscalls_count-1; i++)
801043ea:	8b 43 7c             	mov    0x7c(%ebx),%eax
801043ed:	83 c6 01             	add    $0x1,%esi
801043f0:	83 e8 01             	sub    $0x1,%eax
801043f3:	39 f0                	cmp    %esi,%eax
801043f5:	7f c9                	jg     801043c0 <sort_syscalls+0xd0>
        }

      release(&ptable.lock);
801043f7:	83 ec 0c             	sub    $0xc,%esp
801043fa:	68 20 2d 11 80       	push   $0x80112d20
801043ff:	e8 7c 03 00 00       	call   80104780 <release>
      return 0;
80104404:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
80104407:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
8010440a:	31 c0                	xor    %eax,%eax
}
8010440c:	5b                   	pop    %ebx
8010440d:	5e                   	pop    %esi
8010440e:	5f                   	pop    %edi
8010440f:	5d                   	pop    %ebp
80104410:	c3                   	ret
80104411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < p->syscalls_count-1; i++){
80104418:	83 e9 01             	sub    $0x1,%ecx
8010441b:	83 ee 04             	sub    $0x4,%esi
8010441e:	e9 25 ff ff ff       	jmp    80104348 <sort_syscalls+0x58>
  release(&ptable.lock);
80104423:	83 ec 0c             	sub    $0xc,%esp
80104426:	68 20 2d 11 80       	push   $0x80112d20
8010442b:	e8 50 03 00 00       	call   80104780 <release>
  return -1;
80104430:	83 c4 10             	add    $0x10,%esp
}
80104433:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104436:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010443b:	5b                   	pop    %ebx
8010443c:	5e                   	pop    %esi
8010443d:	5f                   	pop    %edi
8010443e:	5d                   	pop    %ebp
8010443f:	c3                   	ret

80104440 <list_all_processes>:

int
list_all_processes(){
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	56                   	push   %esi
  int p_count = 0;
80104444:	31 f6                	xor    %esi,%esi
list_all_processes(){
80104446:	53                   	push   %ebx
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104447:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
8010444c:	83 ec 0c             	sub    $0xc,%esp
8010444f:	68 20 2d 11 80       	push   $0x80112d20
80104454:	e8 87 03 00 00       	call   801047e0 <acquire>
80104459:	83 c4 10             	add    $0x10,%esp
8010445c:	eb 10                	jmp    8010446e <list_all_processes+0x2e>
8010445e:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104460:	81 c3 80 02 00 00    	add    $0x280,%ebx
80104466:	81 fb 54 cd 11 80    	cmp    $0x8011cd54,%ebx
8010446c:	74 30                	je     8010449e <list_all_processes+0x5e>
    if (p->state == RUNNING){
8010446e:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104472:	75 ec                	jne    80104460 <list_all_processes+0x20>
        p_count++;
        cprintf("Process %d with %d Syscalls\n", p->pid, p->syscalls_count);
80104474:	83 ec 04             	sub    $0x4,%esp
80104477:	ff 73 7c             	push   0x7c(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010447a:	81 c3 80 02 00 00    	add    $0x280,%ebx
        p_count++;
80104480:	83 c6 01             	add    $0x1,%esi
        cprintf("Process %d with %d Syscalls\n", p->pid, p->syscalls_count);
80104483:	ff b3 90 fd ff ff    	push   -0x270(%ebx)
80104489:	68 bd 78 10 80       	push   $0x801078bd
8010448e:	e8 1d c2 ff ff       	call   801006b0 <cprintf>
80104493:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104496:	81 fb 54 cd 11 80    	cmp    $0x8011cd54,%ebx
8010449c:	75 d0                	jne    8010446e <list_all_processes+0x2e>
      }
    }
  release(&ptable.lock);
8010449e:	83 ec 0c             	sub    $0xc,%esp
801044a1:	68 20 2d 11 80       	push   $0x80112d20
801044a6:	e8 d5 02 00 00       	call   80104780 <release>
  return (p_count == 0) ? -1 : 0;
801044ab:	83 c4 10             	add    $0x10,%esp
801044ae:	83 fe 01             	cmp    $0x1,%esi
801044b1:	19 c0                	sbb    %eax,%eax
}
801044b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044b6:	5b                   	pop    %ebx
801044b7:	5e                   	pop    %esi
801044b8:	5d                   	pop    %ebp
801044b9:	c3                   	ret
801044ba:	66 90                	xchg   %ax,%ax
801044bc:	66 90                	xchg   %ax,%ax
801044be:	66 90                	xchg   %ax,%ax

801044c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 0c             	sub    $0xc,%esp
801044c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044ca:	68 04 79 10 80       	push   $0x80107904
801044cf:	8d 43 04             	lea    0x4(%ebx),%eax
801044d2:	50                   	push   %eax
801044d3:	e8 18 01 00 00       	call   801045f0 <initlock>
  lk->name = name;
801044d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044e1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044eb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f1:	c9                   	leave
801044f2:	c3                   	ret
801044f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044fa:	00 
801044fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104500 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
80104505:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104508:	8d 73 04             	lea    0x4(%ebx),%esi
8010450b:	83 ec 0c             	sub    $0xc,%esp
8010450e:	56                   	push   %esi
8010450f:	e8 cc 02 00 00       	call   801047e0 <acquire>
  while (lk->locked) {
80104514:	8b 13                	mov    (%ebx),%edx
80104516:	83 c4 10             	add    $0x10,%esp
80104519:	85 d2                	test   %edx,%edx
8010451b:	74 16                	je     80104533 <acquiresleep+0x33>
8010451d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104520:	83 ec 08             	sub    $0x8,%esp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
80104525:	e8 06 fb ff ff       	call   80104030 <sleep>
  while (lk->locked) {
8010452a:	8b 03                	mov    (%ebx),%eax
8010452c:	83 c4 10             	add    $0x10,%esp
8010452f:	85 c0                	test   %eax,%eax
80104531:	75 ed                	jne    80104520 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104533:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104539:	e8 32 f4 ff ff       	call   80103970 <myproc>
8010453e:	8b 40 10             	mov    0x10(%eax),%eax
80104541:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104544:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104547:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010454a:	5b                   	pop    %ebx
8010454b:	5e                   	pop    %esi
8010454c:	5d                   	pop    %ebp
  release(&lk->lk);
8010454d:	e9 2e 02 00 00       	jmp    80104780 <release>
80104552:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104559:	00 
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104560 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
80104565:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104568:	8d 73 04             	lea    0x4(%ebx),%esi
8010456b:	83 ec 0c             	sub    $0xc,%esp
8010456e:	56                   	push   %esi
8010456f:	e8 6c 02 00 00       	call   801047e0 <acquire>
  lk->locked = 0;
80104574:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010457a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104581:	89 1c 24             	mov    %ebx,(%esp)
80104584:	e8 67 fb ff ff       	call   801040f0 <wakeup>
  release(&lk->lk);
80104589:	89 75 08             	mov    %esi,0x8(%ebp)
8010458c:	83 c4 10             	add    $0x10,%esp
}
8010458f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104592:	5b                   	pop    %ebx
80104593:	5e                   	pop    %esi
80104594:	5d                   	pop    %ebp
  release(&lk->lk);
80104595:	e9 e6 01 00 00       	jmp    80104780 <release>
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	31 ff                	xor    %edi,%edi
801045a6:	56                   	push   %esi
801045a7:	53                   	push   %ebx
801045a8:	83 ec 18             	sub    $0x18,%esp
801045ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045ae:	8d 73 04             	lea    0x4(%ebx),%esi
801045b1:	56                   	push   %esi
801045b2:	e8 29 02 00 00       	call   801047e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045b7:	8b 03                	mov    (%ebx),%eax
801045b9:	83 c4 10             	add    $0x10,%esp
801045bc:	85 c0                	test   %eax,%eax
801045be:	75 18                	jne    801045d8 <holdingsleep+0x38>
  release(&lk->lk);
801045c0:	83 ec 0c             	sub    $0xc,%esp
801045c3:	56                   	push   %esi
801045c4:	e8 b7 01 00 00       	call   80104780 <release>
  return r;
}
801045c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045cc:	89 f8                	mov    %edi,%eax
801045ce:	5b                   	pop    %ebx
801045cf:	5e                   	pop    %esi
801045d0:	5f                   	pop    %edi
801045d1:	5d                   	pop    %ebp
801045d2:	c3                   	ret
801045d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
801045d8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045db:	e8 90 f3 ff ff       	call   80103970 <myproc>
801045e0:	39 58 10             	cmp    %ebx,0x10(%eax)
801045e3:	0f 94 c0             	sete   %al
801045e6:	0f b6 c0             	movzbl %al,%eax
801045e9:	89 c7                	mov    %eax,%edi
801045eb:	eb d3                	jmp    801045c0 <holdingsleep+0x20>
801045ed:	66 90                	xchg   %ax,%ax
801045ef:	90                   	nop

801045f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104602:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104609:	5d                   	pop    %ebp
8010460a:	c3                   	ret
8010460b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104610 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	8b 45 08             	mov    0x8(%ebp),%eax
80104617:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010461a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010461d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104622:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104627:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010462c:	76 10                	jbe    8010463e <getcallerpcs+0x2e>
8010462e:	eb 28                	jmp    80104658 <getcallerpcs+0x48>
80104630:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104636:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010463c:	77 1a                	ja     80104658 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010463e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104641:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104644:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104647:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104649:	83 f8 0a             	cmp    $0xa,%eax
8010464c:	75 e2                	jne    80104630 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010464e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104651:	c9                   	leave
80104652:	c3                   	ret
80104653:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104658:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010465b:	83 c1 28             	add    $0x28,%ecx
8010465e:	89 ca                	mov    %ecx,%edx
80104660:	29 c2                	sub    %eax,%edx
80104662:	83 e2 04             	and    $0x4,%edx
80104665:	74 11                	je     80104678 <getcallerpcs+0x68>
    pcs[i] = 0;
80104667:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010466d:	83 c0 04             	add    $0x4,%eax
80104670:	39 c1                	cmp    %eax,%ecx
80104672:	74 da                	je     8010464e <getcallerpcs+0x3e>
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104678:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010467e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104681:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104688:	39 c1                	cmp    %eax,%ecx
8010468a:	75 ec                	jne    80104678 <getcallerpcs+0x68>
8010468c:	eb c0                	jmp    8010464e <getcallerpcs+0x3e>
8010468e:	66 90                	xchg   %ax,%ax

80104690 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	53                   	push   %ebx
80104694:	83 ec 04             	sub    $0x4,%esp
80104697:	9c                   	pushf
80104698:	5b                   	pop    %ebx
  asm volatile("cli");
80104699:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010469a:	e8 51 f2 ff ff       	call   801038f0 <mycpu>
8010469f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801046a5:	85 c0                	test   %eax,%eax
801046a7:	74 17                	je     801046c0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801046a9:	e8 42 f2 ff ff       	call   801038f0 <mycpu>
801046ae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b8:	c9                   	leave
801046b9:	c3                   	ret
801046ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801046c0:	e8 2b f2 ff ff       	call   801038f0 <mycpu>
801046c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801046d1:	eb d6                	jmp    801046a9 <pushcli+0x19>
801046d3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046da:	00 
801046db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801046e0 <popcli>:

void
popcli(void)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046e6:	9c                   	pushf
801046e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046e8:	f6 c4 02             	test   $0x2,%ah
801046eb:	75 35                	jne    80104722 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046ed:	e8 fe f1 ff ff       	call   801038f0 <mycpu>
801046f2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046f9:	78 34                	js     8010472f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046fb:	e8 f0 f1 ff ff       	call   801038f0 <mycpu>
80104700:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104706:	85 d2                	test   %edx,%edx
80104708:	74 06                	je     80104710 <popcli+0x30>
    sti();
}
8010470a:	c9                   	leave
8010470b:	c3                   	ret
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104710:	e8 db f1 ff ff       	call   801038f0 <mycpu>
80104715:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010471b:	85 c0                	test   %eax,%eax
8010471d:	74 eb                	je     8010470a <popcli+0x2a>
  asm volatile("sti");
8010471f:	fb                   	sti
}
80104720:	c9                   	leave
80104721:	c3                   	ret
    panic("popcli - interruptible");
80104722:	83 ec 0c             	sub    $0xc,%esp
80104725:	68 0f 79 10 80       	push   $0x8010790f
8010472a:	e8 51 bc ff ff       	call   80100380 <panic>
    panic("popcli");
8010472f:	83 ec 0c             	sub    $0xc,%esp
80104732:	68 26 79 10 80       	push   $0x80107926
80104737:	e8 44 bc ff ff       	call   80100380 <panic>
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104740 <holding>:
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	8b 75 08             	mov    0x8(%ebp),%esi
80104748:	31 db                	xor    %ebx,%ebx
  pushcli();
8010474a:	e8 41 ff ff ff       	call   80104690 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010474f:	8b 06                	mov    (%esi),%eax
80104751:	85 c0                	test   %eax,%eax
80104753:	75 0b                	jne    80104760 <holding+0x20>
  popcli();
80104755:	e8 86 ff ff ff       	call   801046e0 <popcli>
}
8010475a:	89 d8                	mov    %ebx,%eax
8010475c:	5b                   	pop    %ebx
8010475d:	5e                   	pop    %esi
8010475e:	5d                   	pop    %ebp
8010475f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104760:	8b 5e 08             	mov    0x8(%esi),%ebx
80104763:	e8 88 f1 ff ff       	call   801038f0 <mycpu>
80104768:	39 c3                	cmp    %eax,%ebx
8010476a:	0f 94 c3             	sete   %bl
  popcli();
8010476d:	e8 6e ff ff ff       	call   801046e0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104772:	0f b6 db             	movzbl %bl,%ebx
}
80104775:	89 d8                	mov    %ebx,%eax
80104777:	5b                   	pop    %ebx
80104778:	5e                   	pop    %esi
80104779:	5d                   	pop    %ebp
8010477a:	c3                   	ret
8010477b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104780 <release>:
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104788:	e8 03 ff ff ff       	call   80104690 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010478d:	8b 03                	mov    (%ebx),%eax
8010478f:	85 c0                	test   %eax,%eax
80104791:	75 15                	jne    801047a8 <release+0x28>
  popcli();
80104793:	e8 48 ff ff ff       	call   801046e0 <popcli>
    panic("release");
80104798:	83 ec 0c             	sub    $0xc,%esp
8010479b:	68 2d 79 10 80       	push   $0x8010792d
801047a0:	e8 db bb ff ff       	call   80100380 <panic>
801047a5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801047a8:	8b 73 08             	mov    0x8(%ebx),%esi
801047ab:	e8 40 f1 ff ff       	call   801038f0 <mycpu>
801047b0:	39 c6                	cmp    %eax,%esi
801047b2:	75 df                	jne    80104793 <release+0x13>
  popcli();
801047b4:	e8 27 ff ff ff       	call   801046e0 <popcli>
  lk->pcs[0] = 0;
801047b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801047c0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801047c7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047cc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d5:	5b                   	pop    %ebx
801047d6:	5e                   	pop    %esi
801047d7:	5d                   	pop    %ebp
  popcli();
801047d8:	e9 03 ff ff ff       	jmp    801046e0 <popcli>
801047dd:	8d 76 00             	lea    0x0(%esi),%esi

801047e0 <acquire>:
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801047e7:	e8 a4 fe ff ff       	call   80104690 <pushcli>
  if(holding(lk))
801047ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047ef:	e8 9c fe ff ff       	call   80104690 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047f4:	8b 03                	mov    (%ebx),%eax
801047f6:	85 c0                	test   %eax,%eax
801047f8:	0f 85 b2 00 00 00    	jne    801048b0 <acquire+0xd0>
  popcli();
801047fe:	e8 dd fe ff ff       	call   801046e0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104803:	b9 01 00 00 00       	mov    $0x1,%ecx
80104808:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010480f:	00 
  while(xchg(&lk->locked, 1) != 0)
80104810:	8b 55 08             	mov    0x8(%ebp),%edx
80104813:	89 c8                	mov    %ecx,%eax
80104815:	f0 87 02             	lock xchg %eax,(%edx)
80104818:	85 c0                	test   %eax,%eax
8010481a:	75 f4                	jne    80104810 <acquire+0x30>
  __sync_synchronize();
8010481c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104821:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104824:	e8 c7 f0 ff ff       	call   801038f0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104829:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010482c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010482e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104831:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104837:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010483c:	77 32                	ja     80104870 <acquire+0x90>
  ebp = (uint*)v - 2;
8010483e:	89 e8                	mov    %ebp,%eax
80104840:	eb 14                	jmp    80104856 <acquire+0x76>
80104842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104848:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010484e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104854:	77 1a                	ja     80104870 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104856:	8b 58 04             	mov    0x4(%eax),%ebx
80104859:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010485d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104860:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104862:	83 fa 0a             	cmp    $0xa,%edx
80104865:	75 e1                	jne    80104848 <acquire+0x68>
}
80104867:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010486a:	c9                   	leave
8010486b:	c3                   	ret
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104870:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104874:	83 c1 34             	add    $0x34,%ecx
80104877:	89 ca                	mov    %ecx,%edx
80104879:	29 c2                	sub    %eax,%edx
8010487b:	83 e2 04             	and    $0x4,%edx
8010487e:	74 10                	je     80104890 <acquire+0xb0>
    pcs[i] = 0;
80104880:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104886:	83 c0 04             	add    $0x4,%eax
80104889:	39 c1                	cmp    %eax,%ecx
8010488b:	74 da                	je     80104867 <acquire+0x87>
8010488d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104890:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104896:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104899:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801048a0:	39 c1                	cmp    %eax,%ecx
801048a2:	75 ec                	jne    80104890 <acquire+0xb0>
801048a4:	eb c1                	jmp    80104867 <acquire+0x87>
801048a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048ad:	00 
801048ae:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
801048b0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801048b3:	e8 38 f0 ff ff       	call   801038f0 <mycpu>
801048b8:	39 c3                	cmp    %eax,%ebx
801048ba:	0f 85 3e ff ff ff    	jne    801047fe <acquire+0x1e>
  popcli();
801048c0:	e8 1b fe ff ff       	call   801046e0 <popcli>
    panic("acquire");
801048c5:	83 ec 0c             	sub    $0xc,%esp
801048c8:	68 35 79 10 80       	push   $0x80107935
801048cd:	e8 ae ba ff ff       	call   80100380 <panic>
801048d2:	66 90                	xchg   %ax,%ax
801048d4:	66 90                	xchg   %ax,%ax
801048d6:	66 90                	xchg   %ax,%ax
801048d8:	66 90                	xchg   %ax,%ax
801048da:	66 90                	xchg   %ax,%ax
801048dc:	66 90                	xchg   %ax,%ax
801048de:	66 90                	xchg   %ax,%ax

801048e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	8b 55 08             	mov    0x8(%ebp),%edx
801048e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801048ea:	89 d0                	mov    %edx,%eax
801048ec:	09 c8                	or     %ecx,%eax
801048ee:	a8 03                	test   $0x3,%al
801048f0:	75 1e                	jne    80104910 <memset+0x30>
    c &= 0xFF;
801048f2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801048f6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
801048f9:	89 d7                	mov    %edx,%edi
801048fb:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104901:	fc                   	cld
80104902:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104904:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104907:	89 d0                	mov    %edx,%eax
80104909:	c9                   	leave
8010490a:	c3                   	ret
8010490b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104910:	8b 45 0c             	mov    0xc(%ebp),%eax
80104913:	89 d7                	mov    %edx,%edi
80104915:	fc                   	cld
80104916:	f3 aa                	rep stos %al,%es:(%edi)
80104918:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010491b:	89 d0                	mov    %edx,%eax
8010491d:	c9                   	leave
8010491e:	c3                   	ret
8010491f:	90                   	nop

80104920 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	56                   	push   %esi
80104924:	8b 75 10             	mov    0x10(%ebp),%esi
80104927:	8b 45 08             	mov    0x8(%ebp),%eax
8010492a:	53                   	push   %ebx
8010492b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010492e:	85 f6                	test   %esi,%esi
80104930:	74 2e                	je     80104960 <memcmp+0x40>
80104932:	01 c6                	add    %eax,%esi
80104934:	eb 14                	jmp    8010494a <memcmp+0x2a>
80104936:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010493d:	00 
8010493e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104940:	83 c0 01             	add    $0x1,%eax
80104943:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104946:	39 f0                	cmp    %esi,%eax
80104948:	74 16                	je     80104960 <memcmp+0x40>
    if(*s1 != *s2)
8010494a:	0f b6 08             	movzbl (%eax),%ecx
8010494d:	0f b6 1a             	movzbl (%edx),%ebx
80104950:	38 d9                	cmp    %bl,%cl
80104952:	74 ec                	je     80104940 <memcmp+0x20>
      return *s1 - *s2;
80104954:	0f b6 c1             	movzbl %cl,%eax
80104957:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104959:	5b                   	pop    %ebx
8010495a:	5e                   	pop    %esi
8010495b:	5d                   	pop    %ebp
8010495c:	c3                   	ret
8010495d:	8d 76 00             	lea    0x0(%esi),%esi
80104960:	5b                   	pop    %ebx
  return 0;
80104961:	31 c0                	xor    %eax,%eax
}
80104963:	5e                   	pop    %esi
80104964:	5d                   	pop    %ebp
80104965:	c3                   	ret
80104966:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010496d:	00 
8010496e:	66 90                	xchg   %ax,%ax

80104970 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	8b 55 08             	mov    0x8(%ebp),%edx
80104977:	8b 45 10             	mov    0x10(%ebp),%eax
8010497a:	56                   	push   %esi
8010497b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010497e:	39 d6                	cmp    %edx,%esi
80104980:	73 26                	jae    801049a8 <memmove+0x38>
80104982:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104985:	39 ca                	cmp    %ecx,%edx
80104987:	73 1f                	jae    801049a8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104989:	85 c0                	test   %eax,%eax
8010498b:	74 0f                	je     8010499c <memmove+0x2c>
8010498d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104990:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104994:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104997:	83 e8 01             	sub    $0x1,%eax
8010499a:	73 f4                	jae    80104990 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010499c:	5e                   	pop    %esi
8010499d:	89 d0                	mov    %edx,%eax
8010499f:	5f                   	pop    %edi
801049a0:	5d                   	pop    %ebp
801049a1:	c3                   	ret
801049a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801049a8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801049ab:	89 d7                	mov    %edx,%edi
801049ad:	85 c0                	test   %eax,%eax
801049af:	74 eb                	je     8010499c <memmove+0x2c>
801049b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801049b8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801049b9:	39 ce                	cmp    %ecx,%esi
801049bb:	75 fb                	jne    801049b8 <memmove+0x48>
}
801049bd:	5e                   	pop    %esi
801049be:	89 d0                	mov    %edx,%eax
801049c0:	5f                   	pop    %edi
801049c1:	5d                   	pop    %ebp
801049c2:	c3                   	ret
801049c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049ca:	00 
801049cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801049d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801049d0:	eb 9e                	jmp    80104970 <memmove>
801049d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049d9:	00 
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049e0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	53                   	push   %ebx
801049e4:	8b 55 10             	mov    0x10(%ebp),%edx
801049e7:	8b 45 08             	mov    0x8(%ebp),%eax
801049ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801049ed:	85 d2                	test   %edx,%edx
801049ef:	75 16                	jne    80104a07 <strncmp+0x27>
801049f1:	eb 2d                	jmp    80104a20 <strncmp+0x40>
801049f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801049f8:	3a 19                	cmp    (%ecx),%bl
801049fa:	75 12                	jne    80104a0e <strncmp+0x2e>
    n--, p++, q++;
801049fc:	83 c0 01             	add    $0x1,%eax
801049ff:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a02:	83 ea 01             	sub    $0x1,%edx
80104a05:	74 19                	je     80104a20 <strncmp+0x40>
80104a07:	0f b6 18             	movzbl (%eax),%ebx
80104a0a:	84 db                	test   %bl,%bl
80104a0c:	75 ea                	jne    801049f8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104a0e:	0f b6 00             	movzbl (%eax),%eax
80104a11:	0f b6 11             	movzbl (%ecx),%edx
}
80104a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a17:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104a18:	29 d0                	sub    %edx,%eax
}
80104a1a:	c3                   	ret
80104a1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104a23:	31 c0                	xor    %eax,%eax
}
80104a25:	c9                   	leave
80104a26:	c3                   	ret
80104a27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a2e:	00 
80104a2f:	90                   	nop

80104a30 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	57                   	push   %edi
80104a34:	56                   	push   %esi
80104a35:	8b 75 08             	mov    0x8(%ebp),%esi
80104a38:	53                   	push   %ebx
80104a39:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a3c:	89 f0                	mov    %esi,%eax
80104a3e:	eb 15                	jmp    80104a55 <strncpy+0x25>
80104a40:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a44:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a47:	83 c0 01             	add    $0x1,%eax
80104a4a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104a4e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104a51:	84 c9                	test   %cl,%cl
80104a53:	74 13                	je     80104a68 <strncpy+0x38>
80104a55:	89 d3                	mov    %edx,%ebx
80104a57:	83 ea 01             	sub    $0x1,%edx
80104a5a:	85 db                	test   %ebx,%ebx
80104a5c:	7f e2                	jg     80104a40 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104a5e:	5b                   	pop    %ebx
80104a5f:	89 f0                	mov    %esi,%eax
80104a61:	5e                   	pop    %esi
80104a62:	5f                   	pop    %edi
80104a63:	5d                   	pop    %ebp
80104a64:	c3                   	ret
80104a65:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104a68:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104a6b:	83 e9 01             	sub    $0x1,%ecx
80104a6e:	85 d2                	test   %edx,%edx
80104a70:	74 ec                	je     80104a5e <strncpy+0x2e>
80104a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104a78:	83 c0 01             	add    $0x1,%eax
80104a7b:	89 ca                	mov    %ecx,%edx
80104a7d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104a81:	29 c2                	sub    %eax,%edx
80104a83:	85 d2                	test   %edx,%edx
80104a85:	7f f1                	jg     80104a78 <strncpy+0x48>
}
80104a87:	5b                   	pop    %ebx
80104a88:	89 f0                	mov    %esi,%eax
80104a8a:	5e                   	pop    %esi
80104a8b:	5f                   	pop    %edi
80104a8c:	5d                   	pop    %ebp
80104a8d:	c3                   	ret
80104a8e:	66 90                	xchg   %ax,%ax

80104a90 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	8b 55 10             	mov    0x10(%ebp),%edx
80104a97:	8b 75 08             	mov    0x8(%ebp),%esi
80104a9a:	53                   	push   %ebx
80104a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a9e:	85 d2                	test   %edx,%edx
80104aa0:	7e 25                	jle    80104ac7 <safestrcpy+0x37>
80104aa2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104aa6:	89 f2                	mov    %esi,%edx
80104aa8:	eb 16                	jmp    80104ac0 <safestrcpy+0x30>
80104aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ab0:	0f b6 08             	movzbl (%eax),%ecx
80104ab3:	83 c0 01             	add    $0x1,%eax
80104ab6:	83 c2 01             	add    $0x1,%edx
80104ab9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104abc:	84 c9                	test   %cl,%cl
80104abe:	74 04                	je     80104ac4 <safestrcpy+0x34>
80104ac0:	39 d8                	cmp    %ebx,%eax
80104ac2:	75 ec                	jne    80104ab0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ac4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104ac7:	89 f0                	mov    %esi,%eax
80104ac9:	5b                   	pop    %ebx
80104aca:	5e                   	pop    %esi
80104acb:	5d                   	pop    %ebp
80104acc:	c3                   	ret
80104acd:	8d 76 00             	lea    0x0(%esi),%esi

80104ad0 <strlen>:

int
strlen(const char *s)
{
80104ad0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ad1:	31 c0                	xor    %eax,%eax
{
80104ad3:	89 e5                	mov    %esp,%ebp
80104ad5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ad8:	80 3a 00             	cmpb   $0x0,(%edx)
80104adb:	74 0c                	je     80104ae9 <strlen+0x19>
80104add:	8d 76 00             	lea    0x0(%esi),%esi
80104ae0:	83 c0 01             	add    $0x1,%eax
80104ae3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ae7:	75 f7                	jne    80104ae0 <strlen+0x10>
    ;
  return n;
}
80104ae9:	5d                   	pop    %ebp
80104aea:	c3                   	ret

80104aeb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104aeb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104aef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104af3:	55                   	push   %ebp
  pushl %ebx
80104af4:	53                   	push   %ebx
  pushl %esi
80104af5:	56                   	push   %esi
  pushl %edi
80104af6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104af7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104af9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104afb:	5f                   	pop    %edi
  popl %esi
80104afc:	5e                   	pop    %esi
  popl %ebx
80104afd:	5b                   	pop    %ebx
  popl %ebp
80104afe:	5d                   	pop    %ebp
  ret
80104aff:	c3                   	ret

80104b00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	53                   	push   %ebx
80104b04:	83 ec 04             	sub    $0x4,%esp
80104b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b0a:	e8 61 ee ff ff       	call   80103970 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b0f:	8b 00                	mov    (%eax),%eax
80104b11:	39 c3                	cmp    %eax,%ebx
80104b13:	73 1b                	jae    80104b30 <fetchint+0x30>
80104b15:	8d 53 04             	lea    0x4(%ebx),%edx
80104b18:	39 d0                	cmp    %edx,%eax
80104b1a:	72 14                	jb     80104b30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b1f:	8b 13                	mov    (%ebx),%edx
80104b21:	89 10                	mov    %edx,(%eax)
  return 0;
80104b23:	31 c0                	xor    %eax,%eax
}
80104b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b28:	c9                   	leave
80104b29:	c3                   	ret
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b35:	eb ee                	jmp    80104b25 <fetchint+0x25>
80104b37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b3e:	00 
80104b3f:	90                   	nop

80104b40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	53                   	push   %ebx
80104b44:	83 ec 04             	sub    $0x4,%esp
80104b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b4a:	e8 21 ee ff ff       	call   80103970 <myproc>

  if(addr >= curproc->sz)
80104b4f:	3b 18                	cmp    (%eax),%ebx
80104b51:	73 2d                	jae    80104b80 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b53:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b56:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b58:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b5a:	39 d3                	cmp    %edx,%ebx
80104b5c:	73 22                	jae    80104b80 <fetchstr+0x40>
80104b5e:	89 d8                	mov    %ebx,%eax
80104b60:	eb 0d                	jmp    80104b6f <fetchstr+0x2f>
80104b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b68:	83 c0 01             	add    $0x1,%eax
80104b6b:	39 d0                	cmp    %edx,%eax
80104b6d:	73 11                	jae    80104b80 <fetchstr+0x40>
    if(*s == 0)
80104b6f:	80 38 00             	cmpb   $0x0,(%eax)
80104b72:	75 f4                	jne    80104b68 <fetchstr+0x28>
      return s - *pp;
80104b74:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b79:	c9                   	leave
80104b7a:	c3                   	ret
80104b7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b88:	c9                   	leave
80104b89:	c3                   	ret
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b95:	e8 d6 ed ff ff       	call   80103970 <myproc>
80104b9a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b9d:	8b 40 18             	mov    0x18(%eax),%eax
80104ba0:	8b 40 44             	mov    0x44(%eax),%eax
80104ba3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ba6:	e8 c5 ed ff ff       	call   80103970 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bae:	8b 00                	mov    (%eax),%eax
80104bb0:	39 c6                	cmp    %eax,%esi
80104bb2:	73 1c                	jae    80104bd0 <argint+0x40>
80104bb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bb7:	39 d0                	cmp    %edx,%eax
80104bb9:	72 15                	jb     80104bd0 <argint+0x40>
  *ip = *(int*)(addr);
80104bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bbe:	8b 53 04             	mov    0x4(%ebx),%edx
80104bc1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bc3:	31 c0                	xor    %eax,%eax
}
80104bc5:	5b                   	pop    %ebx
80104bc6:	5e                   	pop    %esi
80104bc7:	5d                   	pop    %ebp
80104bc8:	c3                   	ret
80104bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd5:	eb ee                	jmp    80104bc5 <argint+0x35>
80104bd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bde:	00 
80104bdf:	90                   	nop

80104be0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	57                   	push   %edi
80104be4:	56                   	push   %esi
80104be5:	53                   	push   %ebx
80104be6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104be9:	e8 82 ed ff ff       	call   80103970 <myproc>
80104bee:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bf0:	e8 7b ed ff ff       	call   80103970 <myproc>
80104bf5:	8b 55 08             	mov    0x8(%ebp),%edx
80104bf8:	8b 40 18             	mov    0x18(%eax),%eax
80104bfb:	8b 40 44             	mov    0x44(%eax),%eax
80104bfe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c01:	e8 6a ed ff ff       	call   80103970 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c06:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c09:	8b 00                	mov    (%eax),%eax
80104c0b:	39 c7                	cmp    %eax,%edi
80104c0d:	73 31                	jae    80104c40 <argptr+0x60>
80104c0f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104c12:	39 c8                	cmp    %ecx,%eax
80104c14:	72 2a                	jb     80104c40 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c16:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104c19:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c1c:	85 d2                	test   %edx,%edx
80104c1e:	78 20                	js     80104c40 <argptr+0x60>
80104c20:	8b 16                	mov    (%esi),%edx
80104c22:	39 d0                	cmp    %edx,%eax
80104c24:	73 1a                	jae    80104c40 <argptr+0x60>
80104c26:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c29:	01 c3                	add    %eax,%ebx
80104c2b:	39 da                	cmp    %ebx,%edx
80104c2d:	72 11                	jb     80104c40 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104c2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c32:	89 02                	mov    %eax,(%edx)
  return 0;
80104c34:	31 c0                	xor    %eax,%eax
}
80104c36:	83 c4 0c             	add    $0xc,%esp
80104c39:	5b                   	pop    %ebx
80104c3a:	5e                   	pop    %esi
80104c3b:	5f                   	pop    %edi
80104c3c:	5d                   	pop    %ebp
80104c3d:	c3                   	ret
80104c3e:	66 90                	xchg   %ax,%ax
    return -1;
80104c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c45:	eb ef                	jmp    80104c36 <argptr+0x56>
80104c47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c4e:	00 
80104c4f:	90                   	nop

80104c50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	56                   	push   %esi
80104c54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c55:	e8 16 ed ff ff       	call   80103970 <myproc>
80104c5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c5d:	8b 40 18             	mov    0x18(%eax),%eax
80104c60:	8b 40 44             	mov    0x44(%eax),%eax
80104c63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c66:	e8 05 ed ff ff       	call   80103970 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c6e:	8b 00                	mov    (%eax),%eax
80104c70:	39 c6                	cmp    %eax,%esi
80104c72:	73 44                	jae    80104cb8 <argstr+0x68>
80104c74:	8d 53 08             	lea    0x8(%ebx),%edx
80104c77:	39 d0                	cmp    %edx,%eax
80104c79:	72 3d                	jb     80104cb8 <argstr+0x68>
  *ip = *(int*)(addr);
80104c7b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c7e:	e8 ed ec ff ff       	call   80103970 <myproc>
  if(addr >= curproc->sz)
80104c83:	3b 18                	cmp    (%eax),%ebx
80104c85:	73 31                	jae    80104cb8 <argstr+0x68>
  *pp = (char*)addr;
80104c87:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c8a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c8c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c8e:	39 d3                	cmp    %edx,%ebx
80104c90:	73 26                	jae    80104cb8 <argstr+0x68>
80104c92:	89 d8                	mov    %ebx,%eax
80104c94:	eb 11                	jmp    80104ca7 <argstr+0x57>
80104c96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c9d:	00 
80104c9e:	66 90                	xchg   %ax,%ax
80104ca0:	83 c0 01             	add    $0x1,%eax
80104ca3:	39 d0                	cmp    %edx,%eax
80104ca5:	73 11                	jae    80104cb8 <argstr+0x68>
    if(*s == 0)
80104ca7:	80 38 00             	cmpb   $0x0,(%eax)
80104caa:	75 f4                	jne    80104ca0 <argstr+0x50>
      return s - *pp;
80104cac:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104cae:	5b                   	pop    %ebx
80104caf:	5e                   	pop    %esi
80104cb0:	5d                   	pop    %ebp
80104cb1:	c3                   	ret
80104cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cb8:	5b                   	pop    %ebx
    return -1;
80104cb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cbe:	5e                   	pop    %esi
80104cbf:	5d                   	pop    %ebp
80104cc0:	c3                   	ret
80104cc1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cc8:	00 
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cd0 <syscall>:
  [SYS_list_all_processes]        "list_all_processes",
};

void
syscall(void)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104cd5:	e8 96 ec ff ff       	call   80103970 <myproc>
80104cda:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cdc:	8b 40 18             	mov    0x18(%eax),%eax
80104cdf:	8b 70 1c             	mov    0x1c(%eax),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ce2:	8d 46 ff             	lea    -0x1(%esi),%eax
80104ce5:	83 f8 19             	cmp    $0x19,%eax
80104ce8:	77 46                	ja     80104d30 <syscall+0x60>
80104cea:	8b 04 b5 c0 7f 10 80 	mov    -0x7fef8040(,%esi,4),%eax
80104cf1:	85 c0                	test   %eax,%eax
80104cf3:	74 3b                	je     80104d30 <syscall+0x60>
    curproc->tf->eax = syscalls[num]();
80104cf5:	ff d0                	call   *%eax
80104cf7:	8b 53 18             	mov    0x18(%ebx),%edx
80104cfa:	89 42 1c             	mov    %eax,0x1c(%edx)

    // Track the system call
    if (curproc->syscalls_count < MAX_SYSCALLS) {
80104cfd:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104d00:	83 f8 3f             	cmp    $0x3f,%eax
80104d03:	7f 4a                	jg     80104d4f <syscall+0x7f>
      curproc->syscall_num[curproc->syscalls_count] = num;
      curproc->syscall_name[curproc->syscalls_count] = syscall_names[num];
80104d05:	8b 14 b5 40 7f 10 80 	mov    -0x7fef80c0(,%esi,4),%edx
      curproc->syscall_num[curproc->syscalls_count] = num;
80104d0c:	89 b4 83 80 00 00 00 	mov    %esi,0x80(%ebx,%eax,4)
      curproc->syscall_name[curproc->syscalls_count] = syscall_names[num];
80104d13:	89 94 83 80 01 00 00 	mov    %edx,0x180(%ebx,%eax,4)
      curproc->syscalls_count++;
80104d1a:	83 c0 01             	add    $0x1,%eax
80104d1d:	89 43 7c             	mov    %eax,0x7c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d23:	5b                   	pop    %ebx
80104d24:	5e                   	pop    %esi
80104d25:	5d                   	pop    %ebp
80104d26:	c3                   	ret
80104d27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d2e:	00 
80104d2f:	90                   	nop
            curproc->pid, curproc->name, num);
80104d30:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d33:	56                   	push   %esi
80104d34:	50                   	push   %eax
80104d35:	ff 73 10             	push   0x10(%ebx)
80104d38:	68 3d 79 10 80       	push   $0x8010793d
80104d3d:	e8 6e b9 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104d42:	8b 43 18             	mov    0x18(%ebx),%eax
80104d45:	83 c4 10             	add    $0x10,%esp
80104d48:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d52:	5b                   	pop    %ebx
80104d53:	5e                   	pop    %esi
80104d54:	5d                   	pop    %ebp
80104d55:	c3                   	ret
80104d56:	66 90                	xchg   %ax,%ax
80104d58:	66 90                	xchg   %ax,%ax
80104d5a:	66 90                	xchg   %ax,%ax
80104d5c:	66 90                	xchg   %ax,%ax
80104d5e:	66 90                	xchg   %ax,%ax

80104d60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	57                   	push   %edi
80104d64:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d65:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d68:	53                   	push   %ebx
80104d69:	83 ec 34             	sub    $0x34,%esp
80104d6c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d72:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d75:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d78:	57                   	push   %edi
80104d79:	50                   	push   %eax
80104d7a:	e8 21 d3 ff ff       	call   801020a0 <nameiparent>
80104d7f:	83 c4 10             	add    $0x10,%esp
80104d82:	85 c0                	test   %eax,%eax
80104d84:	74 5e                	je     80104de4 <create+0x84>
    return 0;
  ilock(dp);
80104d86:	83 ec 0c             	sub    $0xc,%esp
80104d89:	89 c3                	mov    %eax,%ebx
80104d8b:	50                   	push   %eax
80104d8c:	e8 0f ca ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d91:	83 c4 0c             	add    $0xc,%esp
80104d94:	6a 00                	push   $0x0
80104d96:	57                   	push   %edi
80104d97:	53                   	push   %ebx
80104d98:	e8 53 cf ff ff       	call   80101cf0 <dirlookup>
80104d9d:	83 c4 10             	add    $0x10,%esp
80104da0:	89 c6                	mov    %eax,%esi
80104da2:	85 c0                	test   %eax,%eax
80104da4:	74 4a                	je     80104df0 <create+0x90>
    iunlockput(dp);
80104da6:	83 ec 0c             	sub    $0xc,%esp
80104da9:	53                   	push   %ebx
80104daa:	e8 81 cc ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80104daf:	89 34 24             	mov    %esi,(%esp)
80104db2:	e8 e9 c9 ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104db7:	83 c4 10             	add    $0x10,%esp
80104dba:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104dbf:	75 17                	jne    80104dd8 <create+0x78>
80104dc1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104dc6:	75 10                	jne    80104dd8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dcb:	89 f0                	mov    %esi,%eax
80104dcd:	5b                   	pop    %ebx
80104dce:	5e                   	pop    %esi
80104dcf:	5f                   	pop    %edi
80104dd0:	5d                   	pop    %ebp
80104dd1:	c3                   	ret
80104dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104dd8:	83 ec 0c             	sub    $0xc,%esp
80104ddb:	56                   	push   %esi
80104ddc:	e8 4f cc ff ff       	call   80101a30 <iunlockput>
    return 0;
80104de1:	83 c4 10             	add    $0x10,%esp
}
80104de4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104de7:	31 f6                	xor    %esi,%esi
}
80104de9:	5b                   	pop    %ebx
80104dea:	89 f0                	mov    %esi,%eax
80104dec:	5e                   	pop    %esi
80104ded:	5f                   	pop    %edi
80104dee:	5d                   	pop    %ebp
80104def:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104df0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104df4:	83 ec 08             	sub    $0x8,%esp
80104df7:	50                   	push   %eax
80104df8:	ff 33                	push   (%ebx)
80104dfa:	e8 31 c8 ff ff       	call   80101630 <ialloc>
80104dff:	83 c4 10             	add    $0x10,%esp
80104e02:	89 c6                	mov    %eax,%esi
80104e04:	85 c0                	test   %eax,%eax
80104e06:	0f 84 bc 00 00 00    	je     80104ec8 <create+0x168>
  ilock(ip);
80104e0c:	83 ec 0c             	sub    $0xc,%esp
80104e0f:	50                   	push   %eax
80104e10:	e8 8b c9 ff ff       	call   801017a0 <ilock>
  ip->major = major;
80104e15:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e19:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e1d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e21:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e25:	b8 01 00 00 00       	mov    $0x1,%eax
80104e2a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e2e:	89 34 24             	mov    %esi,(%esp)
80104e31:	e8 ba c8 ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e36:	83 c4 10             	add    $0x10,%esp
80104e39:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e3e:	74 30                	je     80104e70 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104e40:	83 ec 04             	sub    $0x4,%esp
80104e43:	ff 76 04             	push   0x4(%esi)
80104e46:	57                   	push   %edi
80104e47:	53                   	push   %ebx
80104e48:	e8 73 d1 ff ff       	call   80101fc0 <dirlink>
80104e4d:	83 c4 10             	add    $0x10,%esp
80104e50:	85 c0                	test   %eax,%eax
80104e52:	78 67                	js     80104ebb <create+0x15b>
  iunlockput(dp);
80104e54:	83 ec 0c             	sub    $0xc,%esp
80104e57:	53                   	push   %ebx
80104e58:	e8 d3 cb ff ff       	call   80101a30 <iunlockput>
  return ip;
80104e5d:	83 c4 10             	add    $0x10,%esp
}
80104e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e63:	89 f0                	mov    %esi,%eax
80104e65:	5b                   	pop    %ebx
80104e66:	5e                   	pop    %esi
80104e67:	5f                   	pop    %edi
80104e68:	5d                   	pop    %ebp
80104e69:	c3                   	ret
80104e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e70:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e73:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e78:	53                   	push   %ebx
80104e79:	e8 72 c8 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e7e:	83 c4 0c             	add    $0xc,%esp
80104e81:	ff 76 04             	push   0x4(%esi)
80104e84:	68 fd 79 10 80       	push   $0x801079fd
80104e89:	56                   	push   %esi
80104e8a:	e8 31 d1 ff ff       	call   80101fc0 <dirlink>
80104e8f:	83 c4 10             	add    $0x10,%esp
80104e92:	85 c0                	test   %eax,%eax
80104e94:	78 18                	js     80104eae <create+0x14e>
80104e96:	83 ec 04             	sub    $0x4,%esp
80104e99:	ff 73 04             	push   0x4(%ebx)
80104e9c:	68 fc 79 10 80       	push   $0x801079fc
80104ea1:	56                   	push   %esi
80104ea2:	e8 19 d1 ff ff       	call   80101fc0 <dirlink>
80104ea7:	83 c4 10             	add    $0x10,%esp
80104eaa:	85 c0                	test   %eax,%eax
80104eac:	79 92                	jns    80104e40 <create+0xe0>
      panic("create dots");
80104eae:	83 ec 0c             	sub    $0xc,%esp
80104eb1:	68 f0 79 10 80       	push   $0x801079f0
80104eb6:	e8 c5 b4 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104ebb:	83 ec 0c             	sub    $0xc,%esp
80104ebe:	68 ff 79 10 80       	push   $0x801079ff
80104ec3:	e8 b8 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104ec8:	83 ec 0c             	sub    $0xc,%esp
80104ecb:	68 e1 79 10 80       	push   $0x801079e1
80104ed0:	e8 ab b4 ff ff       	call   80100380 <panic>
80104ed5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104edc:	00 
80104edd:	8d 76 00             	lea    0x0(%esi),%esi

80104ee0 <sys_dup>:
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ee5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ee8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eeb:	50                   	push   %eax
80104eec:	6a 00                	push   $0x0
80104eee:	e8 9d fc ff ff       	call   80104b90 <argint>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	78 36                	js     80104f30 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104efa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104efe:	77 30                	ja     80104f30 <sys_dup+0x50>
80104f00:	e8 6b ea ff ff       	call   80103970 <myproc>
80104f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f0c:	85 f6                	test   %esi,%esi
80104f0e:	74 20                	je     80104f30 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f10:	e8 5b ea ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f15:	31 db                	xor    %ebx,%ebx
80104f17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f1e:	00 
80104f1f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104f20:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f24:	85 d2                	test   %edx,%edx
80104f26:	74 18                	je     80104f40 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f28:	83 c3 01             	add    $0x1,%ebx
80104f2b:	83 fb 10             	cmp    $0x10,%ebx
80104f2e:	75 f0                	jne    80104f20 <sys_dup+0x40>
}
80104f30:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f33:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f38:	89 d8                	mov    %ebx,%eax
80104f3a:	5b                   	pop    %ebx
80104f3b:	5e                   	pop    %esi
80104f3c:	5d                   	pop    %ebp
80104f3d:	c3                   	ret
80104f3e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f40:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f43:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f47:	56                   	push   %esi
80104f48:	e8 73 bf ff ff       	call   80100ec0 <filedup>
  return fd;
80104f4d:	83 c4 10             	add    $0x10,%esp
}
80104f50:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f53:	89 d8                	mov    %ebx,%eax
80104f55:	5b                   	pop    %ebx
80104f56:	5e                   	pop    %esi
80104f57:	5d                   	pop    %ebp
80104f58:	c3                   	ret
80104f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f60 <sys_read>:
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f6b:	53                   	push   %ebx
80104f6c:	6a 00                	push   $0x0
80104f6e:	e8 1d fc ff ff       	call   80104b90 <argint>
80104f73:	83 c4 10             	add    $0x10,%esp
80104f76:	85 c0                	test   %eax,%eax
80104f78:	78 5e                	js     80104fd8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f7e:	77 58                	ja     80104fd8 <sys_read+0x78>
80104f80:	e8 eb e9 ff ff       	call   80103970 <myproc>
80104f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f8c:	85 f6                	test   %esi,%esi
80104f8e:	74 48                	je     80104fd8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f90:	83 ec 08             	sub    $0x8,%esp
80104f93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f96:	50                   	push   %eax
80104f97:	6a 02                	push   $0x2
80104f99:	e8 f2 fb ff ff       	call   80104b90 <argint>
80104f9e:	83 c4 10             	add    $0x10,%esp
80104fa1:	85 c0                	test   %eax,%eax
80104fa3:	78 33                	js     80104fd8 <sys_read+0x78>
80104fa5:	83 ec 04             	sub    $0x4,%esp
80104fa8:	ff 75 f0             	push   -0x10(%ebp)
80104fab:	53                   	push   %ebx
80104fac:	6a 01                	push   $0x1
80104fae:	e8 2d fc ff ff       	call   80104be0 <argptr>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 1e                	js     80104fd8 <sys_read+0x78>
  return fileread(f, p, n);
80104fba:	83 ec 04             	sub    $0x4,%esp
80104fbd:	ff 75 f0             	push   -0x10(%ebp)
80104fc0:	ff 75 f4             	push   -0xc(%ebp)
80104fc3:	56                   	push   %esi
80104fc4:	e8 77 c0 ff ff       	call   80101040 <fileread>
80104fc9:	83 c4 10             	add    $0x10,%esp
}
80104fcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fcf:	5b                   	pop    %ebx
80104fd0:	5e                   	pop    %esi
80104fd1:	5d                   	pop    %ebp
80104fd2:	c3                   	ret
80104fd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdd:	eb ed                	jmp    80104fcc <sys_read+0x6c>
80104fdf:	90                   	nop

80104fe0 <sys_write>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fe5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fe8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104feb:	53                   	push   %ebx
80104fec:	6a 00                	push   $0x0
80104fee:	e8 9d fb ff ff       	call   80104b90 <argint>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 5e                	js     80105058 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ffa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ffe:	77 58                	ja     80105058 <sys_write+0x78>
80105000:	e8 6b e9 ff ff       	call   80103970 <myproc>
80105005:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105008:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010500c:	85 f6                	test   %esi,%esi
8010500e:	74 48                	je     80105058 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105010:	83 ec 08             	sub    $0x8,%esp
80105013:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105016:	50                   	push   %eax
80105017:	6a 02                	push   $0x2
80105019:	e8 72 fb ff ff       	call   80104b90 <argint>
8010501e:	83 c4 10             	add    $0x10,%esp
80105021:	85 c0                	test   %eax,%eax
80105023:	78 33                	js     80105058 <sys_write+0x78>
80105025:	83 ec 04             	sub    $0x4,%esp
80105028:	ff 75 f0             	push   -0x10(%ebp)
8010502b:	53                   	push   %ebx
8010502c:	6a 01                	push   $0x1
8010502e:	e8 ad fb ff ff       	call   80104be0 <argptr>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 1e                	js     80105058 <sys_write+0x78>
  return filewrite(f, p, n);
8010503a:	83 ec 04             	sub    $0x4,%esp
8010503d:	ff 75 f0             	push   -0x10(%ebp)
80105040:	ff 75 f4             	push   -0xc(%ebp)
80105043:	56                   	push   %esi
80105044:	e8 87 c0 ff ff       	call   801010d0 <filewrite>
80105049:	83 c4 10             	add    $0x10,%esp
}
8010504c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010504f:	5b                   	pop    %ebx
80105050:	5e                   	pop    %esi
80105051:	5d                   	pop    %ebp
80105052:	c3                   	ret
80105053:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505d:	eb ed                	jmp    8010504c <sys_write+0x6c>
8010505f:	90                   	nop

80105060 <sys_close>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105065:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105068:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010506b:	50                   	push   %eax
8010506c:	6a 00                	push   $0x0
8010506e:	e8 1d fb ff ff       	call   80104b90 <argint>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 3e                	js     801050b8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010507a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010507e:	77 38                	ja     801050b8 <sys_close+0x58>
80105080:	e8 eb e8 ff ff       	call   80103970 <myproc>
80105085:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105088:	8d 5a 08             	lea    0x8(%edx),%ebx
8010508b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010508f:	85 f6                	test   %esi,%esi
80105091:	74 25                	je     801050b8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105093:	e8 d8 e8 ff ff       	call   80103970 <myproc>
  fileclose(f);
80105098:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010509b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801050a2:	00 
  fileclose(f);
801050a3:	56                   	push   %esi
801050a4:	e8 67 be ff ff       	call   80100f10 <fileclose>
  return 0;
801050a9:	83 c4 10             	add    $0x10,%esp
801050ac:	31 c0                	xor    %eax,%eax
}
801050ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050b1:	5b                   	pop    %ebx
801050b2:	5e                   	pop    %esi
801050b3:	5d                   	pop    %ebp
801050b4:	c3                   	ret
801050b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050bd:	eb ef                	jmp    801050ae <sys_close+0x4e>
801050bf:	90                   	nop

801050c0 <sys_fstat>:
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050cb:	53                   	push   %ebx
801050cc:	6a 00                	push   $0x0
801050ce:	e8 bd fa ff ff       	call   80104b90 <argint>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	85 c0                	test   %eax,%eax
801050d8:	78 46                	js     80105120 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050de:	77 40                	ja     80105120 <sys_fstat+0x60>
801050e0:	e8 8b e8 ff ff       	call   80103970 <myproc>
801050e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050ec:	85 f6                	test   %esi,%esi
801050ee:	74 30                	je     80105120 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050f0:	83 ec 04             	sub    $0x4,%esp
801050f3:	6a 14                	push   $0x14
801050f5:	53                   	push   %ebx
801050f6:	6a 01                	push   $0x1
801050f8:	e8 e3 fa ff ff       	call   80104be0 <argptr>
801050fd:	83 c4 10             	add    $0x10,%esp
80105100:	85 c0                	test   %eax,%eax
80105102:	78 1c                	js     80105120 <sys_fstat+0x60>
  return filestat(f, st);
80105104:	83 ec 08             	sub    $0x8,%esp
80105107:	ff 75 f4             	push   -0xc(%ebp)
8010510a:	56                   	push   %esi
8010510b:	e8 e0 be ff ff       	call   80100ff0 <filestat>
80105110:	83 c4 10             	add    $0x10,%esp
}
80105113:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105116:	5b                   	pop    %ebx
80105117:	5e                   	pop    %esi
80105118:	5d                   	pop    %ebp
80105119:	c3                   	ret
8010511a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105125:	eb ec                	jmp    80105113 <sys_fstat+0x53>
80105127:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010512e:	00 
8010512f:	90                   	nop

80105130 <sys_link>:
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105135:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105138:	53                   	push   %ebx
80105139:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010513c:	50                   	push   %eax
8010513d:	6a 00                	push   $0x0
8010513f:	e8 0c fb ff ff       	call   80104c50 <argstr>
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	85 c0                	test   %eax,%eax
80105149:	0f 88 fb 00 00 00    	js     8010524a <sys_link+0x11a>
8010514f:	83 ec 08             	sub    $0x8,%esp
80105152:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105155:	50                   	push   %eax
80105156:	6a 01                	push   $0x1
80105158:	e8 f3 fa ff ff       	call   80104c50 <argstr>
8010515d:	83 c4 10             	add    $0x10,%esp
80105160:	85 c0                	test   %eax,%eax
80105162:	0f 88 e2 00 00 00    	js     8010524a <sys_link+0x11a>
  begin_op();
80105168:	e8 d3 db ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
8010516d:	83 ec 0c             	sub    $0xc,%esp
80105170:	ff 75 d4             	push   -0x2c(%ebp)
80105173:	e8 08 cf ff ff       	call   80102080 <namei>
80105178:	83 c4 10             	add    $0x10,%esp
8010517b:	89 c3                	mov    %eax,%ebx
8010517d:	85 c0                	test   %eax,%eax
8010517f:	0f 84 df 00 00 00    	je     80105264 <sys_link+0x134>
  ilock(ip);
80105185:	83 ec 0c             	sub    $0xc,%esp
80105188:	50                   	push   %eax
80105189:	e8 12 c6 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
8010518e:	83 c4 10             	add    $0x10,%esp
80105191:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105196:	0f 84 b5 00 00 00    	je     80105251 <sys_link+0x121>
  iupdate(ip);
8010519c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010519f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051a7:	53                   	push   %ebx
801051a8:	e8 43 c5 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
801051ad:	89 1c 24             	mov    %ebx,(%esp)
801051b0:	e8 cb c6 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051b5:	58                   	pop    %eax
801051b6:	5a                   	pop    %edx
801051b7:	57                   	push   %edi
801051b8:	ff 75 d0             	push   -0x30(%ebp)
801051bb:	e8 e0 ce ff ff       	call   801020a0 <nameiparent>
801051c0:	83 c4 10             	add    $0x10,%esp
801051c3:	89 c6                	mov    %eax,%esi
801051c5:	85 c0                	test   %eax,%eax
801051c7:	74 5b                	je     80105224 <sys_link+0xf4>
  ilock(dp);
801051c9:	83 ec 0c             	sub    $0xc,%esp
801051cc:	50                   	push   %eax
801051cd:	e8 ce c5 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051d2:	8b 03                	mov    (%ebx),%eax
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	39 06                	cmp    %eax,(%esi)
801051d9:	75 3d                	jne    80105218 <sys_link+0xe8>
801051db:	83 ec 04             	sub    $0x4,%esp
801051de:	ff 73 04             	push   0x4(%ebx)
801051e1:	57                   	push   %edi
801051e2:	56                   	push   %esi
801051e3:	e8 d8 cd ff ff       	call   80101fc0 <dirlink>
801051e8:	83 c4 10             	add    $0x10,%esp
801051eb:	85 c0                	test   %eax,%eax
801051ed:	78 29                	js     80105218 <sys_link+0xe8>
  iunlockput(dp);
801051ef:	83 ec 0c             	sub    $0xc,%esp
801051f2:	56                   	push   %esi
801051f3:	e8 38 c8 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
801051f8:	89 1c 24             	mov    %ebx,(%esp)
801051fb:	e8 d0 c6 ff ff       	call   801018d0 <iput>
  end_op();
80105200:	e8 ab db ff ff       	call   80102db0 <end_op>
  return 0;
80105205:	83 c4 10             	add    $0x10,%esp
80105208:	31 c0                	xor    %eax,%eax
}
8010520a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010520d:	5b                   	pop    %ebx
8010520e:	5e                   	pop    %esi
8010520f:	5f                   	pop    %edi
80105210:	5d                   	pop    %ebp
80105211:	c3                   	ret
80105212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	56                   	push   %esi
8010521c:	e8 0f c8 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105221:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105224:	83 ec 0c             	sub    $0xc,%esp
80105227:	53                   	push   %ebx
80105228:	e8 73 c5 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
8010522d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105232:	89 1c 24             	mov    %ebx,(%esp)
80105235:	e8 b6 c4 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
8010523a:	89 1c 24             	mov    %ebx,(%esp)
8010523d:	e8 ee c7 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105242:	e8 69 db ff ff       	call   80102db0 <end_op>
  return -1;
80105247:	83 c4 10             	add    $0x10,%esp
    return -1;
8010524a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524f:	eb b9                	jmp    8010520a <sys_link+0xda>
    iunlockput(ip);
80105251:	83 ec 0c             	sub    $0xc,%esp
80105254:	53                   	push   %ebx
80105255:	e8 d6 c7 ff ff       	call   80101a30 <iunlockput>
    end_op();
8010525a:	e8 51 db ff ff       	call   80102db0 <end_op>
    return -1;
8010525f:	83 c4 10             	add    $0x10,%esp
80105262:	eb e6                	jmp    8010524a <sys_link+0x11a>
    end_op();
80105264:	e8 47 db ff ff       	call   80102db0 <end_op>
    return -1;
80105269:	eb df                	jmp    8010524a <sys_link+0x11a>
8010526b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105270 <sys_unlink>:
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	57                   	push   %edi
80105274:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105275:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105278:	53                   	push   %ebx
80105279:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010527c:	50                   	push   %eax
8010527d:	6a 00                	push   $0x0
8010527f:	e8 cc f9 ff ff       	call   80104c50 <argstr>
80105284:	83 c4 10             	add    $0x10,%esp
80105287:	85 c0                	test   %eax,%eax
80105289:	0f 88 54 01 00 00    	js     801053e3 <sys_unlink+0x173>
  begin_op();
8010528f:	e8 ac da ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105294:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105297:	83 ec 08             	sub    $0x8,%esp
8010529a:	53                   	push   %ebx
8010529b:	ff 75 c0             	push   -0x40(%ebp)
8010529e:	e8 fd cd ff ff       	call   801020a0 <nameiparent>
801052a3:	83 c4 10             	add    $0x10,%esp
801052a6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801052a9:	85 c0                	test   %eax,%eax
801052ab:	0f 84 58 01 00 00    	je     80105409 <sys_unlink+0x199>
  ilock(dp);
801052b1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801052b4:	83 ec 0c             	sub    $0xc,%esp
801052b7:	57                   	push   %edi
801052b8:	e8 e3 c4 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052bd:	58                   	pop    %eax
801052be:	5a                   	pop    %edx
801052bf:	68 fd 79 10 80       	push   $0x801079fd
801052c4:	53                   	push   %ebx
801052c5:	e8 06 ca ff ff       	call   80101cd0 <namecmp>
801052ca:	83 c4 10             	add    $0x10,%esp
801052cd:	85 c0                	test   %eax,%eax
801052cf:	0f 84 fb 00 00 00    	je     801053d0 <sys_unlink+0x160>
801052d5:	83 ec 08             	sub    $0x8,%esp
801052d8:	68 fc 79 10 80       	push   $0x801079fc
801052dd:	53                   	push   %ebx
801052de:	e8 ed c9 ff ff       	call   80101cd0 <namecmp>
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	85 c0                	test   %eax,%eax
801052e8:	0f 84 e2 00 00 00    	je     801053d0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801052ee:	83 ec 04             	sub    $0x4,%esp
801052f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052f4:	50                   	push   %eax
801052f5:	53                   	push   %ebx
801052f6:	57                   	push   %edi
801052f7:	e8 f4 c9 ff ff       	call   80101cf0 <dirlookup>
801052fc:	83 c4 10             	add    $0x10,%esp
801052ff:	89 c3                	mov    %eax,%ebx
80105301:	85 c0                	test   %eax,%eax
80105303:	0f 84 c7 00 00 00    	je     801053d0 <sys_unlink+0x160>
  ilock(ip);
80105309:	83 ec 0c             	sub    $0xc,%esp
8010530c:	50                   	push   %eax
8010530d:	e8 8e c4 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
80105312:	83 c4 10             	add    $0x10,%esp
80105315:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010531a:	0f 8e 0a 01 00 00    	jle    8010542a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105320:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105325:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105328:	74 66                	je     80105390 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010532a:	83 ec 04             	sub    $0x4,%esp
8010532d:	6a 10                	push   $0x10
8010532f:	6a 00                	push   $0x0
80105331:	57                   	push   %edi
80105332:	e8 a9 f5 ff ff       	call   801048e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105337:	6a 10                	push   $0x10
80105339:	ff 75 c4             	push   -0x3c(%ebp)
8010533c:	57                   	push   %edi
8010533d:	ff 75 b4             	push   -0x4c(%ebp)
80105340:	e8 6b c8 ff ff       	call   80101bb0 <writei>
80105345:	83 c4 20             	add    $0x20,%esp
80105348:	83 f8 10             	cmp    $0x10,%eax
8010534b:	0f 85 cc 00 00 00    	jne    8010541d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105351:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105356:	0f 84 94 00 00 00    	je     801053f0 <sys_unlink+0x180>
  iunlockput(dp);
8010535c:	83 ec 0c             	sub    $0xc,%esp
8010535f:	ff 75 b4             	push   -0x4c(%ebp)
80105362:	e8 c9 c6 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
80105367:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010536c:	89 1c 24             	mov    %ebx,(%esp)
8010536f:	e8 7c c3 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80105374:	89 1c 24             	mov    %ebx,(%esp)
80105377:	e8 b4 c6 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010537c:	e8 2f da ff ff       	call   80102db0 <end_op>
  return 0;
80105381:	83 c4 10             	add    $0x10,%esp
80105384:	31 c0                	xor    %eax,%eax
}
80105386:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105389:	5b                   	pop    %ebx
8010538a:	5e                   	pop    %esi
8010538b:	5f                   	pop    %edi
8010538c:	5d                   	pop    %ebp
8010538d:	c3                   	ret
8010538e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105390:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105394:	76 94                	jbe    8010532a <sys_unlink+0xba>
80105396:	be 20 00 00 00       	mov    $0x20,%esi
8010539b:	eb 0b                	jmp    801053a8 <sys_unlink+0x138>
8010539d:	8d 76 00             	lea    0x0(%esi),%esi
801053a0:	83 c6 10             	add    $0x10,%esi
801053a3:	3b 73 58             	cmp    0x58(%ebx),%esi
801053a6:	73 82                	jae    8010532a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053a8:	6a 10                	push   $0x10
801053aa:	56                   	push   %esi
801053ab:	57                   	push   %edi
801053ac:	53                   	push   %ebx
801053ad:	e8 fe c6 ff ff       	call   80101ab0 <readi>
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	83 f8 10             	cmp    $0x10,%eax
801053b8:	75 56                	jne    80105410 <sys_unlink+0x1a0>
    if(de.inum != 0)
801053ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053bf:	74 df                	je     801053a0 <sys_unlink+0x130>
    iunlockput(ip);
801053c1:	83 ec 0c             	sub    $0xc,%esp
801053c4:	53                   	push   %ebx
801053c5:	e8 66 c6 ff ff       	call   80101a30 <iunlockput>
    goto bad;
801053ca:	83 c4 10             	add    $0x10,%esp
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801053d0:	83 ec 0c             	sub    $0xc,%esp
801053d3:	ff 75 b4             	push   -0x4c(%ebp)
801053d6:	e8 55 c6 ff ff       	call   80101a30 <iunlockput>
  end_op();
801053db:	e8 d0 d9 ff ff       	call   80102db0 <end_op>
  return -1;
801053e0:	83 c4 10             	add    $0x10,%esp
    return -1;
801053e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e8:	eb 9c                	jmp    80105386 <sys_unlink+0x116>
801053ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801053f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801053f3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801053f6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801053fb:	50                   	push   %eax
801053fc:	e8 ef c2 ff ff       	call   801016f0 <iupdate>
80105401:	83 c4 10             	add    $0x10,%esp
80105404:	e9 53 ff ff ff       	jmp    8010535c <sys_unlink+0xec>
    end_op();
80105409:	e8 a2 d9 ff ff       	call   80102db0 <end_op>
    return -1;
8010540e:	eb d3                	jmp    801053e3 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105410:	83 ec 0c             	sub    $0xc,%esp
80105413:	68 21 7a 10 80       	push   $0x80107a21
80105418:	e8 63 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010541d:	83 ec 0c             	sub    $0xc,%esp
80105420:	68 33 7a 10 80       	push   $0x80107a33
80105425:	e8 56 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010542a:	83 ec 0c             	sub    $0xc,%esp
8010542d:	68 0f 7a 10 80       	push   $0x80107a0f
80105432:	e8 49 af ff ff       	call   80100380 <panic>
80105437:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010543e:	00 
8010543f:	90                   	nop

80105440 <sys_open>:

int
sys_open(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105445:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105448:	53                   	push   %ebx
80105449:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010544c:	50                   	push   %eax
8010544d:	6a 00                	push   $0x0
8010544f:	e8 fc f7 ff ff       	call   80104c50 <argstr>
80105454:	83 c4 10             	add    $0x10,%esp
80105457:	85 c0                	test   %eax,%eax
80105459:	0f 88 8e 00 00 00    	js     801054ed <sys_open+0xad>
8010545f:	83 ec 08             	sub    $0x8,%esp
80105462:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105465:	50                   	push   %eax
80105466:	6a 01                	push   $0x1
80105468:	e8 23 f7 ff ff       	call   80104b90 <argint>
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	85 c0                	test   %eax,%eax
80105472:	78 79                	js     801054ed <sys_open+0xad>
    return -1;

  begin_op();
80105474:	e8 c7 d8 ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
80105479:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010547d:	75 79                	jne    801054f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010547f:	83 ec 0c             	sub    $0xc,%esp
80105482:	ff 75 e0             	push   -0x20(%ebp)
80105485:	e8 f6 cb ff ff       	call   80102080 <namei>
8010548a:	83 c4 10             	add    $0x10,%esp
8010548d:	89 c6                	mov    %eax,%esi
8010548f:	85 c0                	test   %eax,%eax
80105491:	0f 84 7e 00 00 00    	je     80105515 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105497:	83 ec 0c             	sub    $0xc,%esp
8010549a:	50                   	push   %eax
8010549b:	e8 00 c3 ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054a0:	83 c4 10             	add    $0x10,%esp
801054a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054a8:	0f 84 ba 00 00 00    	je     80105568 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054ae:	e8 9d b9 ff ff       	call   80100e50 <filealloc>
801054b3:	89 c7                	mov    %eax,%edi
801054b5:	85 c0                	test   %eax,%eax
801054b7:	74 23                	je     801054dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801054b9:	e8 b2 e4 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801054c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054c4:	85 d2                	test   %edx,%edx
801054c6:	74 58                	je     80105520 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801054c8:	83 c3 01             	add    $0x1,%ebx
801054cb:	83 fb 10             	cmp    $0x10,%ebx
801054ce:	75 f0                	jne    801054c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801054d0:	83 ec 0c             	sub    $0xc,%esp
801054d3:	57                   	push   %edi
801054d4:	e8 37 ba ff ff       	call   80100f10 <fileclose>
801054d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801054dc:	83 ec 0c             	sub    $0xc,%esp
801054df:	56                   	push   %esi
801054e0:	e8 4b c5 ff ff       	call   80101a30 <iunlockput>
    end_op();
801054e5:	e8 c6 d8 ff ff       	call   80102db0 <end_op>
    return -1;
801054ea:	83 c4 10             	add    $0x10,%esp
    return -1;
801054ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054f2:	eb 65                	jmp    80105559 <sys_open+0x119>
801054f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801054f8:	83 ec 0c             	sub    $0xc,%esp
801054fb:	31 c9                	xor    %ecx,%ecx
801054fd:	ba 02 00 00 00       	mov    $0x2,%edx
80105502:	6a 00                	push   $0x0
80105504:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105507:	e8 54 f8 ff ff       	call   80104d60 <create>
    if(ip == 0){
8010550c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010550f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105511:	85 c0                	test   %eax,%eax
80105513:	75 99                	jne    801054ae <sys_open+0x6e>
      end_op();
80105515:	e8 96 d8 ff ff       	call   80102db0 <end_op>
      return -1;
8010551a:	eb d1                	jmp    801054ed <sys_open+0xad>
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105520:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105523:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105527:	56                   	push   %esi
80105528:	e8 53 c3 ff ff       	call   80101880 <iunlock>
  end_op();
8010552d:	e8 7e d8 ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
80105532:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105538:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010553b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010553e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105541:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105543:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010554a:	f7 d0                	not    %eax
8010554c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010554f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105552:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105555:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105559:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010555c:	89 d8                	mov    %ebx,%eax
8010555e:	5b                   	pop    %ebx
8010555f:	5e                   	pop    %esi
80105560:	5f                   	pop    %edi
80105561:	5d                   	pop    %ebp
80105562:	c3                   	ret
80105563:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105568:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010556b:	85 c9                	test   %ecx,%ecx
8010556d:	0f 84 3b ff ff ff    	je     801054ae <sys_open+0x6e>
80105573:	e9 64 ff ff ff       	jmp    801054dc <sys_open+0x9c>
80105578:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010557f:	00 

80105580 <sys_mkdir>:

int
sys_mkdir(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105586:	e8 b5 d7 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010558b:	83 ec 08             	sub    $0x8,%esp
8010558e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105591:	50                   	push   %eax
80105592:	6a 00                	push   $0x0
80105594:	e8 b7 f6 ff ff       	call   80104c50 <argstr>
80105599:	83 c4 10             	add    $0x10,%esp
8010559c:	85 c0                	test   %eax,%eax
8010559e:	78 30                	js     801055d0 <sys_mkdir+0x50>
801055a0:	83 ec 0c             	sub    $0xc,%esp
801055a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a6:	31 c9                	xor    %ecx,%ecx
801055a8:	ba 01 00 00 00       	mov    $0x1,%edx
801055ad:	6a 00                	push   $0x0
801055af:	e8 ac f7 ff ff       	call   80104d60 <create>
801055b4:	83 c4 10             	add    $0x10,%esp
801055b7:	85 c0                	test   %eax,%eax
801055b9:	74 15                	je     801055d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055bb:	83 ec 0c             	sub    $0xc,%esp
801055be:	50                   	push   %eax
801055bf:	e8 6c c4 ff ff       	call   80101a30 <iunlockput>
  end_op();
801055c4:	e8 e7 d7 ff ff       	call   80102db0 <end_op>
  return 0;
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	31 c0                	xor    %eax,%eax
}
801055ce:	c9                   	leave
801055cf:	c3                   	ret
    end_op();
801055d0:	e8 db d7 ff ff       	call   80102db0 <end_op>
    return -1;
801055d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055da:	c9                   	leave
801055db:	c3                   	ret
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055e0 <sys_mknod>:

int
sys_mknod(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055e6:	e8 55 d7 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055eb:	83 ec 08             	sub    $0x8,%esp
801055ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055f1:	50                   	push   %eax
801055f2:	6a 00                	push   $0x0
801055f4:	e8 57 f6 ff ff       	call   80104c50 <argstr>
801055f9:	83 c4 10             	add    $0x10,%esp
801055fc:	85 c0                	test   %eax,%eax
801055fe:	78 60                	js     80105660 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105600:	83 ec 08             	sub    $0x8,%esp
80105603:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105606:	50                   	push   %eax
80105607:	6a 01                	push   $0x1
80105609:	e8 82 f5 ff ff       	call   80104b90 <argint>
  if((argstr(0, &path)) < 0 ||
8010560e:	83 c4 10             	add    $0x10,%esp
80105611:	85 c0                	test   %eax,%eax
80105613:	78 4b                	js     80105660 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105615:	83 ec 08             	sub    $0x8,%esp
80105618:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010561b:	50                   	push   %eax
8010561c:	6a 02                	push   $0x2
8010561e:	e8 6d f5 ff ff       	call   80104b90 <argint>
     argint(1, &major) < 0 ||
80105623:	83 c4 10             	add    $0x10,%esp
80105626:	85 c0                	test   %eax,%eax
80105628:	78 36                	js     80105660 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010562a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010562e:	83 ec 0c             	sub    $0xc,%esp
80105631:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105635:	ba 03 00 00 00       	mov    $0x3,%edx
8010563a:	50                   	push   %eax
8010563b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010563e:	e8 1d f7 ff ff       	call   80104d60 <create>
     argint(2, &minor) < 0 ||
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 c0                	test   %eax,%eax
80105648:	74 16                	je     80105660 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010564a:	83 ec 0c             	sub    $0xc,%esp
8010564d:	50                   	push   %eax
8010564e:	e8 dd c3 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105653:	e8 58 d7 ff ff       	call   80102db0 <end_op>
  return 0;
80105658:	83 c4 10             	add    $0x10,%esp
8010565b:	31 c0                	xor    %eax,%eax
}
8010565d:	c9                   	leave
8010565e:	c3                   	ret
8010565f:	90                   	nop
    end_op();
80105660:	e8 4b d7 ff ff       	call   80102db0 <end_op>
    return -1;
80105665:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010566a:	c9                   	leave
8010566b:	c3                   	ret
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105670 <sys_chdir>:

int
sys_chdir(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	56                   	push   %esi
80105674:	53                   	push   %ebx
80105675:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105678:	e8 f3 e2 ff ff       	call   80103970 <myproc>
8010567d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010567f:	e8 bc d6 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105684:	83 ec 08             	sub    $0x8,%esp
80105687:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010568a:	50                   	push   %eax
8010568b:	6a 00                	push   $0x0
8010568d:	e8 be f5 ff ff       	call   80104c50 <argstr>
80105692:	83 c4 10             	add    $0x10,%esp
80105695:	85 c0                	test   %eax,%eax
80105697:	78 77                	js     80105710 <sys_chdir+0xa0>
80105699:	83 ec 0c             	sub    $0xc,%esp
8010569c:	ff 75 f4             	push   -0xc(%ebp)
8010569f:	e8 dc c9 ff ff       	call   80102080 <namei>
801056a4:	83 c4 10             	add    $0x10,%esp
801056a7:	89 c3                	mov    %eax,%ebx
801056a9:	85 c0                	test   %eax,%eax
801056ab:	74 63                	je     80105710 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056ad:	83 ec 0c             	sub    $0xc,%esp
801056b0:	50                   	push   %eax
801056b1:	e8 ea c0 ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
801056b6:	83 c4 10             	add    $0x10,%esp
801056b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056be:	75 30                	jne    801056f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	53                   	push   %ebx
801056c4:	e8 b7 c1 ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
801056c9:	58                   	pop    %eax
801056ca:	ff 76 68             	push   0x68(%esi)
801056cd:	e8 fe c1 ff ff       	call   801018d0 <iput>
  end_op();
801056d2:	e8 d9 d6 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
801056d7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801056da:	83 c4 10             	add    $0x10,%esp
801056dd:	31 c0                	xor    %eax,%eax
}
801056df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056e2:	5b                   	pop    %ebx
801056e3:	5e                   	pop    %esi
801056e4:	5d                   	pop    %ebp
801056e5:	c3                   	ret
801056e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056ed:	00 
801056ee:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	53                   	push   %ebx
801056f4:	e8 37 c3 ff ff       	call   80101a30 <iunlockput>
    end_op();
801056f9:	e8 b2 d6 ff ff       	call   80102db0 <end_op>
    return -1;
801056fe:	83 c4 10             	add    $0x10,%esp
    return -1;
80105701:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105706:	eb d7                	jmp    801056df <sys_chdir+0x6f>
80105708:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010570f:	00 
    end_op();
80105710:	e8 9b d6 ff ff       	call   80102db0 <end_op>
    return -1;
80105715:	eb ea                	jmp    80105701 <sys_chdir+0x91>
80105717:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010571e:	00 
8010571f:	90                   	nop

80105720 <sys_exec>:

int
sys_exec(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	57                   	push   %edi
80105724:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105725:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010572b:	53                   	push   %ebx
8010572c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105732:	50                   	push   %eax
80105733:	6a 00                	push   $0x0
80105735:	e8 16 f5 ff ff       	call   80104c50 <argstr>
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	85 c0                	test   %eax,%eax
8010573f:	0f 88 87 00 00 00    	js     801057cc <sys_exec+0xac>
80105745:	83 ec 08             	sub    $0x8,%esp
80105748:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010574e:	50                   	push   %eax
8010574f:	6a 01                	push   $0x1
80105751:	e8 3a f4 ff ff       	call   80104b90 <argint>
80105756:	83 c4 10             	add    $0x10,%esp
80105759:	85 c0                	test   %eax,%eax
8010575b:	78 6f                	js     801057cc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010575d:	83 ec 04             	sub    $0x4,%esp
80105760:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105766:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105768:	68 80 00 00 00       	push   $0x80
8010576d:	6a 00                	push   $0x0
8010576f:	56                   	push   %esi
80105770:	e8 6b f1 ff ff       	call   801048e0 <memset>
80105775:	83 c4 10             	add    $0x10,%esp
80105778:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010577f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105780:	83 ec 08             	sub    $0x8,%esp
80105783:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105789:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105790:	50                   	push   %eax
80105791:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105797:	01 f8                	add    %edi,%eax
80105799:	50                   	push   %eax
8010579a:	e8 61 f3 ff ff       	call   80104b00 <fetchint>
8010579f:	83 c4 10             	add    $0x10,%esp
801057a2:	85 c0                	test   %eax,%eax
801057a4:	78 26                	js     801057cc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801057a6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057ac:	85 c0                	test   %eax,%eax
801057ae:	74 30                	je     801057e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057b0:	83 ec 08             	sub    $0x8,%esp
801057b3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801057b6:	52                   	push   %edx
801057b7:	50                   	push   %eax
801057b8:	e8 83 f3 ff ff       	call   80104b40 <fetchstr>
801057bd:	83 c4 10             	add    $0x10,%esp
801057c0:	85 c0                	test   %eax,%eax
801057c2:	78 08                	js     801057cc <sys_exec+0xac>
  for(i=0;; i++){
801057c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057c7:	83 fb 20             	cmp    $0x20,%ebx
801057ca:	75 b4                	jne    80105780 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057d4:	5b                   	pop    %ebx
801057d5:	5e                   	pop    %esi
801057d6:	5f                   	pop    %edi
801057d7:	5d                   	pop    %ebp
801057d8:	c3                   	ret
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801057e0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057e7:	00 00 00 00 
  return exec(path, argv);
801057eb:	83 ec 08             	sub    $0x8,%esp
801057ee:	56                   	push   %esi
801057ef:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801057f5:	e8 b6 b2 ff ff       	call   80100ab0 <exec>
801057fa:	83 c4 10             	add    $0x10,%esp
}
801057fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105800:	5b                   	pop    %ebx
80105801:	5e                   	pop    %esi
80105802:	5f                   	pop    %edi
80105803:	5d                   	pop    %ebp
80105804:	c3                   	ret
80105805:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010580c:	00 
8010580d:	8d 76 00             	lea    0x0(%esi),%esi

80105810 <sys_pipe>:

int
sys_pipe(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	57                   	push   %edi
80105814:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105815:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105818:	53                   	push   %ebx
80105819:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010581c:	6a 08                	push   $0x8
8010581e:	50                   	push   %eax
8010581f:	6a 00                	push   $0x0
80105821:	e8 ba f3 ff ff       	call   80104be0 <argptr>
80105826:	83 c4 10             	add    $0x10,%esp
80105829:	85 c0                	test   %eax,%eax
8010582b:	0f 88 8b 00 00 00    	js     801058bc <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105831:	83 ec 08             	sub    $0x8,%esp
80105834:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105837:	50                   	push   %eax
80105838:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010583b:	50                   	push   %eax
8010583c:	e8 cf db ff ff       	call   80103410 <pipealloc>
80105841:	83 c4 10             	add    $0x10,%esp
80105844:	85 c0                	test   %eax,%eax
80105846:	78 74                	js     801058bc <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105848:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010584b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010584d:	e8 1e e1 ff ff       	call   80103970 <myproc>
    if(curproc->ofile[fd] == 0){
80105852:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105856:	85 f6                	test   %esi,%esi
80105858:	74 16                	je     80105870 <sys_pipe+0x60>
8010585a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105860:	83 c3 01             	add    $0x1,%ebx
80105863:	83 fb 10             	cmp    $0x10,%ebx
80105866:	74 3d                	je     801058a5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105868:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010586c:	85 f6                	test   %esi,%esi
8010586e:	75 f0                	jne    80105860 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105870:	8d 73 08             	lea    0x8(%ebx),%esi
80105873:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105877:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010587a:	e8 f1 e0 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010587f:	31 d2                	xor    %edx,%edx
80105881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105888:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010588c:	85 c9                	test   %ecx,%ecx
8010588e:	74 38                	je     801058c8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105890:	83 c2 01             	add    $0x1,%edx
80105893:	83 fa 10             	cmp    $0x10,%edx
80105896:	75 f0                	jne    80105888 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105898:	e8 d3 e0 ff ff       	call   80103970 <myproc>
8010589d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801058a4:	00 
    fileclose(rf);
801058a5:	83 ec 0c             	sub    $0xc,%esp
801058a8:	ff 75 e0             	push   -0x20(%ebp)
801058ab:	e8 60 b6 ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
801058b0:	58                   	pop    %eax
801058b1:	ff 75 e4             	push   -0x1c(%ebp)
801058b4:	e8 57 b6 ff ff       	call   80100f10 <fileclose>
    return -1;
801058b9:	83 c4 10             	add    $0x10,%esp
    return -1;
801058bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c1:	eb 16                	jmp    801058d9 <sys_pipe+0xc9>
801058c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801058c8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801058cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058cf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058d4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058d7:	31 c0                	xor    %eax,%eax
}
801058d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058dc:	5b                   	pop    %ebx
801058dd:	5e                   	pop    %esi
801058de:	5f                   	pop    %edi
801058df:	5d                   	pop    %ebp
801058e0:	c3                   	ret
801058e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058e8:	00 
801058e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058f0 <sys_move_file>:

int sys_move_file(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	57                   	push   %edi
801058f4:	56                   	push   %esi
  struct dirent de;
  char name[DIRSIZ], *src_file, *dest_dir;
  uint off;

  // Fetch arguments from user space
  if (argstr(0, &src_file) < 0 || argstr(1, &dest_dir) < 0)
801058f5:	8d 45 bc             	lea    -0x44(%ebp),%eax
{
801058f8:	53                   	push   %ebx
801058f9:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &src_file) < 0 || argstr(1, &dest_dir) < 0)
801058fc:	50                   	push   %eax
801058fd:	6a 00                	push   $0x0
801058ff:	e8 4c f3 ff ff       	call   80104c50 <argstr>
80105904:	83 c4 10             	add    $0x10,%esp
80105907:	85 c0                	test   %eax,%eax
80105909:	0f 88 02 01 00 00    	js     80105a11 <sys_move_file+0x121>
8010590f:	83 ec 08             	sub    $0x8,%esp
80105912:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105915:	50                   	push   %eax
80105916:	6a 01                	push   $0x1
80105918:	e8 33 f3 ff ff       	call   80104c50 <argstr>
8010591d:	83 c4 10             	add    $0x10,%esp
80105920:	85 c0                	test   %eax,%eax
80105922:	0f 88 e9 00 00 00    	js     80105a11 <sys_move_file+0x121>
    return -1;

  begin_op();
80105928:	e8 13 d4 ff ff       	call   80102d40 <begin_op>
  // Look up source directory
  if ((dp_old = nameiparent(src_file, name)) == 0){
8010592d:	8d 7d ca             	lea    -0x36(%ebp),%edi
80105930:	83 ec 08             	sub    $0x8,%esp
80105933:	57                   	push   %edi
80105934:	ff 75 bc             	push   -0x44(%ebp)
80105937:	e8 64 c7 ff ff       	call   801020a0 <nameiparent>
8010593c:	83 c4 10             	add    $0x10,%esp
8010593f:	89 c3                	mov    %eax,%ebx
80105941:	85 c0                	test   %eax,%eax
80105943:	0f 84 e7 00 00 00    	je     80105a30 <sys_move_file+0x140>
    end_op();
    return -1;
  }

  // Look up source file
  if((ip = dirlookup(dp_old, name, &off)) == 0){
80105949:	83 ec 04             	sub    $0x4,%esp
8010594c:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010594f:	50                   	push   %eax
80105950:	57                   	push   %edi
80105951:	53                   	push   %ebx
80105952:	e8 99 c3 ff ff       	call   80101cf0 <dirlookup>
80105957:	83 c4 10             	add    $0x10,%esp
8010595a:	89 c6                	mov    %eax,%esi
8010595c:	85 c0                	test   %eax,%eax
8010595e:	0f 84 cc 00 00 00    	je     80105a30 <sys_move_file+0x140>
    end_op();
    return -1;
  }

  // Look up destination directory
  if((dp_new = namei(dest_dir)) == 0){
80105964:	83 ec 0c             	sub    $0xc,%esp
80105967:	ff 75 c0             	push   -0x40(%ebp)
8010596a:	e8 11 c7 ff ff       	call   80102080 <namei>
8010596f:	83 c4 10             	add    $0x10,%esp
80105972:	85 c0                	test   %eax,%eax
80105974:	0f 84 b6 00 00 00    	je     80105a30 <sys_move_file+0x140>
    end_op();
    return -1;
  }

  // Link the file in the destination directory
  ilock(dp_new);
8010597a:	83 ec 0c             	sub    $0xc,%esp
8010597d:	50                   	push   %eax
8010597e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105981:	e8 1a be ff ff       	call   801017a0 <ilock>
  if(dp_new->dev != ip->dev || dirlink(dp_new, name, ip->inum) < 0){
80105986:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105989:	8b 06                	mov    (%esi),%eax
8010598b:	83 c4 10             	add    $0x10,%esp
8010598e:	39 02                	cmp    %eax,(%edx)
80105990:	75 6e                	jne    80105a00 <sys_move_file+0x110>
80105992:	83 ec 04             	sub    $0x4,%esp
80105995:	ff 76 04             	push   0x4(%esi)
80105998:	57                   	push   %edi
80105999:	52                   	push   %edx
8010599a:	89 55 b4             	mov    %edx,-0x4c(%ebp)
8010599d:	e8 1e c6 ff ff       	call   80101fc0 <dirlink>
801059a2:	83 c4 10             	add    $0x10,%esp
801059a5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801059a8:	85 c0                	test   %eax,%eax
801059aa:	78 54                	js     80105a00 <sys_move_file+0x110>
    iunlockput(dp_new);
    end_op();
    return -1;
  }
  iunlockput(dp_new);
801059ac:	83 ec 0c             	sub    $0xc,%esp

  // Unlink the file from its original location
  memset(&de, 0, sizeof(de));
801059af:	8d 75 d8             	lea    -0x28(%ebp),%esi
  iunlockput(dp_new);
801059b2:	52                   	push   %edx
801059b3:	e8 78 c0 ff ff       	call   80101a30 <iunlockput>
  memset(&de, 0, sizeof(de));
801059b8:	83 c4 0c             	add    $0xc,%esp
801059bb:	6a 10                	push   $0x10
801059bd:	6a 00                	push   $0x0
801059bf:	56                   	push   %esi
801059c0:	e8 1b ef ff ff       	call   801048e0 <memset>
  ilock(dp_old);
801059c5:	89 1c 24             	mov    %ebx,(%esp)
801059c8:	e8 d3 bd ff ff       	call   801017a0 <ilock>
  if(writei(dp_old, (char*)&de, off, sizeof(de)) != sizeof(de)){
801059cd:	6a 10                	push   $0x10
801059cf:	ff 75 c4             	push   -0x3c(%ebp)
801059d2:	56                   	push   %esi
801059d3:	53                   	push   %ebx
801059d4:	e8 d7 c1 ff ff       	call   80101bb0 <writei>
801059d9:	83 c4 20             	add    $0x20,%esp
801059dc:	83 f8 10             	cmp    $0x10,%eax
801059df:	75 3f                	jne    80105a20 <sys_move_file+0x130>
    iunlockput(dp_old);
    return -1;
  }
  iunlockput(dp_old);
801059e1:	83 ec 0c             	sub    $0xc,%esp
801059e4:	53                   	push   %ebx
801059e5:	e8 46 c0 ff ff       	call   80101a30 <iunlockput>

  end_op();
801059ea:	e8 c1 d3 ff ff       	call   80102db0 <end_op>

  return 0;
801059ef:	83 c4 10             	add    $0x10,%esp
801059f2:	31 c0                	xor    %eax,%eax
801059f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059f7:	5b                   	pop    %ebx
801059f8:	5e                   	pop    %esi
801059f9:	5f                   	pop    %edi
801059fa:	5d                   	pop    %ebp
801059fb:	c3                   	ret
801059fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(dp_new);
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	52                   	push   %edx
80105a04:	e8 27 c0 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105a09:	e8 a2 d3 ff ff       	call   80102db0 <end_op>
    return -1;
80105a0e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105a11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a16:	eb dc                	jmp    801059f4 <sys_move_file+0x104>
80105a18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a1f:	00 
    iunlockput(dp_old);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	53                   	push   %ebx
80105a24:	e8 07 c0 ff ff       	call   80101a30 <iunlockput>
    return -1;
80105a29:	83 c4 10             	add    $0x10,%esp
80105a2c:	eb e3                	jmp    80105a11 <sys_move_file+0x121>
80105a2e:	66 90                	xchg   %ax,%ax
    end_op();
80105a30:	e8 7b d3 ff ff       	call   80102db0 <end_op>
    return -1;
80105a35:	eb da                	jmp    80105a11 <sys_move_file+0x121>
80105a37:	66 90                	xchg   %ax,%ax
80105a39:	66 90                	xchg   %ax,%ax
80105a3b:	66 90                	xchg   %ax,%ax
80105a3d:	66 90                	xchg   %ax,%ax
80105a3f:	90                   	nop

80105a40 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
  return fork();
80105a40:	e9 cb e0 ff ff       	jmp    80103b10 <fork>
80105a45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a4c:	00 
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi

80105a50 <sys_exit>:
}

int sys_exit(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a56:	e8 25 e3 ff ff       	call   80103d80 <exit>
  return 0; // not reached
}
80105a5b:	31 c0                	xor    %eax,%eax
80105a5d:	c9                   	leave
80105a5e:	c3                   	ret
80105a5f:	90                   	nop

80105a60 <sys_wait>:

int sys_wait(void)
{
  return wait();
80105a60:	e9 4b e4 ff ff       	jmp    80103eb0 <wait>
80105a65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a6c:	00 
80105a6d:	8d 76 00             	lea    0x0(%esi),%esi

80105a70 <sys_kill>:
}

int sys_kill(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80105a76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a79:	50                   	push   %eax
80105a7a:	6a 00                	push   $0x0
80105a7c:	e8 0f f1 ff ff       	call   80104b90 <argint>
80105a81:	83 c4 10             	add    $0x10,%esp
80105a84:	85 c0                	test   %eax,%eax
80105a86:	78 18                	js     80105aa0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	ff 75 f4             	push   -0xc(%ebp)
80105a8e:	e8 bd e6 ff ff       	call   80104150 <kill>
80105a93:	83 c4 10             	add    $0x10,%esp
}
80105a96:	c9                   	leave
80105a97:	c3                   	ret
80105a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a9f:	00 
80105aa0:	c9                   	leave
    return -1;
80105aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa6:	c3                   	ret
80105aa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aae:	00 
80105aaf:	90                   	nop

80105ab0 <sys_getpid>:

int sys_getpid(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ab6:	e8 b5 de ff ff       	call   80103970 <myproc>
80105abb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105abe:	c9                   	leave
80105abf:	c3                   	ret

80105ac0 <sys_sbrk>:

int sys_sbrk(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ac7:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 be f0 ff ff       	call   80104b90 <argint>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 27                	js     80105b00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ad9:	e8 92 de ff ff       	call   80103970 <myproc>
  if (growproc(n) < 0)
80105ade:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ae1:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80105ae3:	ff 75 f4             	push   -0xc(%ebp)
80105ae6:	e8 a5 df ff ff       	call   80103a90 <growproc>
80105aeb:	83 c4 10             	add    $0x10,%esp
80105aee:	85 c0                	test   %eax,%eax
80105af0:	78 0e                	js     80105b00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105af2:	89 d8                	mov    %ebx,%eax
80105af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af7:	c9                   	leave
80105af8:	c3                   	ret
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b05:	eb eb                	jmp    80105af2 <sys_sbrk+0x32>
80105b07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b0e:	00 
80105b0f:	90                   	nop

80105b10 <sys_sleep>:

int sys_sleep(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80105b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b17:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
80105b1a:	50                   	push   %eax
80105b1b:	6a 00                	push   $0x0
80105b1d:	e8 6e f0 ff ff       	call   80104b90 <argint>
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	85 c0                	test   %eax,%eax
80105b27:	78 64                	js     80105b8d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105b29:	83 ec 0c             	sub    $0xc,%esp
80105b2c:	68 80 cd 11 80       	push   $0x8011cd80
80105b31:	e8 aa ec ff ff       	call   801047e0 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
80105b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105b39:	8b 1d 60 cd 11 80    	mov    0x8011cd60,%ebx
  while (ticks - ticks0 < n)
80105b3f:	83 c4 10             	add    $0x10,%esp
80105b42:	85 d2                	test   %edx,%edx
80105b44:	75 2b                	jne    80105b71 <sys_sleep+0x61>
80105b46:	eb 58                	jmp    80105ba0 <sys_sleep+0x90>
80105b48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b4f:	00 
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b50:	83 ec 08             	sub    $0x8,%esp
80105b53:	68 80 cd 11 80       	push   $0x8011cd80
80105b58:	68 60 cd 11 80       	push   $0x8011cd60
80105b5d:	e8 ce e4 ff ff       	call   80104030 <sleep>
  while (ticks - ticks0 < n)
80105b62:	a1 60 cd 11 80       	mov    0x8011cd60,%eax
80105b67:	83 c4 10             	add    $0x10,%esp
80105b6a:	29 d8                	sub    %ebx,%eax
80105b6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b6f:	73 2f                	jae    80105ba0 <sys_sleep+0x90>
    if (myproc()->killed)
80105b71:	e8 fa dd ff ff       	call   80103970 <myproc>
80105b76:	8b 40 24             	mov    0x24(%eax),%eax
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	74 d3                	je     80105b50 <sys_sleep+0x40>
      release(&tickslock);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	68 80 cd 11 80       	push   $0x8011cd80
80105b85:	e8 f6 eb ff ff       	call   80104780 <release>
      return -1;
80105b8a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105b8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b95:	c9                   	leave
80105b96:	c3                   	ret
80105b97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b9e:	00 
80105b9f:	90                   	nop
  release(&tickslock);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	68 80 cd 11 80       	push   $0x8011cd80
80105ba8:	e8 d3 eb ff ff       	call   80104780 <release>
}
80105bad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105bb0:	83 c4 10             	add    $0x10,%esp
80105bb3:	31 c0                	xor    %eax,%eax
}
80105bb5:	c9                   	leave
80105bb6:	c3                   	ret
80105bb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bbe:	00 
80105bbf:	90                   	nop

80105bc0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	53                   	push   %ebx
80105bc4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105bc7:	68 80 cd 11 80       	push   $0x8011cd80
80105bcc:	e8 0f ec ff ff       	call   801047e0 <acquire>
  xticks = ticks;
80105bd1:	8b 1d 60 cd 11 80    	mov    0x8011cd60,%ebx
  release(&tickslock);
80105bd7:	c7 04 24 80 cd 11 80 	movl   $0x8011cd80,(%esp)
80105bde:	e8 9d eb ff ff       	call   80104780 <release>
  return xticks;
}
80105be3:	89 d8                	mov    %ebx,%eax
80105be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105be8:	c9                   	leave
80105be9:	c3                   	ret
80105bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bf0 <sys_create_palindrome>:

int sys_create_palindrome(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 08             	sub    $0x8,%esp
  int num;
  struct proc *p = myproc();
80105bf6:	e8 75 dd ff ff       	call   80103970 <myproc>
  num = p->tf->ebx;
  create_palindrome(num);
80105bfb:	83 ec 0c             	sub    $0xc,%esp
  num = p->tf->ebx;
80105bfe:	8b 40 18             	mov    0x18(%eax),%eax
  create_palindrome(num);
80105c01:	ff 70 10             	push   0x10(%eax)
80105c04:	e8 87 e6 ff ff       	call   80104290 <create_palindrome>
  return 0;
}
80105c09:	31 c0                	xor    %eax,%eax
80105c0b:	c9                   	leave
80105c0c:	c3                   	ret
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi

80105c10 <sys_sort_syscalls>:

int sys_sort_syscalls(void) {
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80105c16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c19:	50                   	push   %eax
80105c1a:	6a 00                	push   $0x0
80105c1c:	e8 6f ef ff ff       	call   80104b90 <argint>
80105c21:	83 c4 10             	add    $0x10,%esp
80105c24:	85 c0                	test   %eax,%eax
80105c26:	78 18                	js     80105c40 <sys_sort_syscalls+0x30>
    return -1;
  return sort_syscalls(pid);
80105c28:	83 ec 0c             	sub    $0xc,%esp
80105c2b:	ff 75 f4             	push   -0xc(%ebp)
80105c2e:	e8 bd e6 ff ff       	call   801042f0 <sort_syscalls>
80105c33:	83 c4 10             	add    $0x10,%esp
}
80105c36:	c9                   	leave
80105c37:	c3                   	ret
80105c38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c3f:	00 
80105c40:	c9                   	leave
    return -1;
80105c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c46:	c3                   	ret
80105c47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c4e:	00 
80105c4f:	90                   	nop

80105c50 <sys_list_all_processes>:

int sys_list_all_processes(void){
  return list_all_processes();
80105c50:	e9 eb e7 ff ff       	jmp    80104440 <list_all_processes>

80105c55 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c55:	1e                   	push   %ds
  pushl %es
80105c56:	06                   	push   %es
  pushl %fs
80105c57:	0f a0                	push   %fs
  pushl %gs
80105c59:	0f a8                	push   %gs
  pushal
80105c5b:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c5c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c60:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c62:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c64:	54                   	push   %esp
  call trap
80105c65:	e8 c6 00 00 00       	call   80105d30 <trap>
  addl $4, %esp
80105c6a:	83 c4 04             	add    $0x4,%esp

80105c6d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c6d:	61                   	popa
  popl %gs
80105c6e:	0f a9                	pop    %gs
  popl %fs
80105c70:	0f a1                	pop    %fs
  popl %es
80105c72:	07                   	pop    %es
  popl %ds
80105c73:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c74:	83 c4 08             	add    $0x8,%esp
  iret
80105c77:	cf                   	iret
80105c78:	66 90                	xchg   %ax,%ax
80105c7a:	66 90                	xchg   %ax,%ax
80105c7c:	66 90                	xchg   %ax,%ax
80105c7e:	66 90                	xchg   %ax,%ax

80105c80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c80:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c81:	31 c0                	xor    %eax,%eax
{
80105c83:	89 e5                	mov    %esp,%ebp
80105c85:	83 ec 08             	sub    $0x8,%esp
80105c88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c8f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c90:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105c97:	c7 04 c5 c2 cd 11 80 	movl   $0x8e000008,-0x7fee323e(,%eax,8)
80105c9e:	08 00 00 8e 
80105ca2:	66 89 14 c5 c0 cd 11 	mov    %dx,-0x7fee3240(,%eax,8)
80105ca9:	80 
80105caa:	c1 ea 10             	shr    $0x10,%edx
80105cad:	66 89 14 c5 c6 cd 11 	mov    %dx,-0x7fee323a(,%eax,8)
80105cb4:	80 
  for(i = 0; i < 256; i++)
80105cb5:	83 c0 01             	add    $0x1,%eax
80105cb8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105cbd:	75 d1                	jne    80105c90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105cbf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cc2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105cc7:	c7 05 c2 cf 11 80 08 	movl   $0xef000008,0x8011cfc2
80105cce:	00 00 ef 
  initlock(&tickslock, "time");
80105cd1:	68 87 79 10 80       	push   $0x80107987
80105cd6:	68 80 cd 11 80       	push   $0x8011cd80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cdb:	66 a3 c0 cf 11 80    	mov    %ax,0x8011cfc0
80105ce1:	c1 e8 10             	shr    $0x10,%eax
80105ce4:	66 a3 c6 cf 11 80    	mov    %ax,0x8011cfc6
  initlock(&tickslock, "time");
80105cea:	e8 01 e9 ff ff       	call   801045f0 <initlock>
}
80105cef:	83 c4 10             	add    $0x10,%esp
80105cf2:	c9                   	leave
80105cf3:	c3                   	ret
80105cf4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cfb:	00 
80105cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d00 <idtinit>:

void
idtinit(void)
{
80105d00:	55                   	push   %ebp
  pd[0] = size-1;
80105d01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d06:	89 e5                	mov    %esp,%ebp
80105d08:	83 ec 10             	sub    $0x10,%esp
80105d0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d0f:	b8 c0 cd 11 80       	mov    $0x8011cdc0,%eax
80105d14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d18:	c1 e8 10             	shr    $0x10,%eax
80105d1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d22:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d25:	c9                   	leave
80105d26:	c3                   	ret
80105d27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d2e:	00 
80105d2f:	90                   	nop

80105d30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	57                   	push   %edi
80105d34:	56                   	push   %esi
80105d35:	53                   	push   %ebx
80105d36:	83 ec 1c             	sub    $0x1c,%esp
80105d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105d3c:	8b 43 30             	mov    0x30(%ebx),%eax
80105d3f:	83 f8 40             	cmp    $0x40,%eax
80105d42:	0f 84 58 01 00 00    	je     80105ea0 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d48:	83 e8 20             	sub    $0x20,%eax
80105d4b:	83 f8 1f             	cmp    $0x1f,%eax
80105d4e:	0f 87 7c 00 00 00    	ja     80105dd0 <trap+0xa0>
80105d54:	ff 24 85 2c 80 10 80 	jmp    *-0x7fef7fd4(,%eax,4)
80105d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105d60:	e8 cb c4 ff ff       	call   80102230 <ideintr>
    lapiceoi();
80105d65:	e8 86 cb ff ff       	call   801028f0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d6a:	e8 01 dc ff ff       	call   80103970 <myproc>
80105d6f:	85 c0                	test   %eax,%eax
80105d71:	74 1a                	je     80105d8d <trap+0x5d>
80105d73:	e8 f8 db ff ff       	call   80103970 <myproc>
80105d78:	8b 50 24             	mov    0x24(%eax),%edx
80105d7b:	85 d2                	test   %edx,%edx
80105d7d:	74 0e                	je     80105d8d <trap+0x5d>
80105d7f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d83:	f7 d0                	not    %eax
80105d85:	a8 03                	test   $0x3,%al
80105d87:	0f 84 db 01 00 00    	je     80105f68 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d8d:	e8 de db ff ff       	call   80103970 <myproc>
80105d92:	85 c0                	test   %eax,%eax
80105d94:	74 0f                	je     80105da5 <trap+0x75>
80105d96:	e8 d5 db ff ff       	call   80103970 <myproc>
80105d9b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d9f:	0f 84 ab 00 00 00    	je     80105e50 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105da5:	e8 c6 db ff ff       	call   80103970 <myproc>
80105daa:	85 c0                	test   %eax,%eax
80105dac:	74 1a                	je     80105dc8 <trap+0x98>
80105dae:	e8 bd db ff ff       	call   80103970 <myproc>
80105db3:	8b 40 24             	mov    0x24(%eax),%eax
80105db6:	85 c0                	test   %eax,%eax
80105db8:	74 0e                	je     80105dc8 <trap+0x98>
80105dba:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105dbe:	f7 d0                	not    %eax
80105dc0:	a8 03                	test   $0x3,%al
80105dc2:	0f 84 05 01 00 00    	je     80105ecd <trap+0x19d>
    exit();
}
80105dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dcb:	5b                   	pop    %ebx
80105dcc:	5e                   	pop    %esi
80105dcd:	5f                   	pop    %edi
80105dce:	5d                   	pop    %ebp
80105dcf:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105dd0:	e8 9b db ff ff       	call   80103970 <myproc>
80105dd5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105dd8:	85 c0                	test   %eax,%eax
80105dda:	0f 84 a2 01 00 00    	je     80105f82 <trap+0x252>
80105de0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105de4:	0f 84 98 01 00 00    	je     80105f82 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105dea:	0f 20 d1             	mov    %cr2,%ecx
80105ded:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105df0:	e8 5b db ff ff       	call   80103950 <cpuid>
80105df5:	8b 73 30             	mov    0x30(%ebx),%esi
80105df8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105dfb:	8b 43 34             	mov    0x34(%ebx),%eax
80105dfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e01:	e8 6a db ff ff       	call   80103970 <myproc>
80105e06:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e09:	e8 62 db ff ff       	call   80103970 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e0e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e11:	51                   	push   %ecx
80105e12:	57                   	push   %edi
80105e13:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e16:	52                   	push   %edx
80105e17:	ff 75 e4             	push   -0x1c(%ebp)
80105e1a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e1b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105e1e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e21:	56                   	push   %esi
80105e22:	ff 70 10             	push   0x10(%eax)
80105e25:	68 8c 7c 10 80       	push   $0x80107c8c
80105e2a:	e8 81 a8 ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105e2f:	83 c4 20             	add    $0x20,%esp
80105e32:	e8 39 db ff ff       	call   80103970 <myproc>
80105e37:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e3e:	e8 2d db ff ff       	call   80103970 <myproc>
80105e43:	85 c0                	test   %eax,%eax
80105e45:	0f 85 28 ff ff ff    	jne    80105d73 <trap+0x43>
80105e4b:	e9 3d ff ff ff       	jmp    80105d8d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105e50:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e54:	0f 85 4b ff ff ff    	jne    80105da5 <trap+0x75>
    yield();
80105e5a:	e8 81 e1 ff ff       	call   80103fe0 <yield>
80105e5f:	e9 41 ff ff ff       	jmp    80105da5 <trap+0x75>
80105e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e68:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e6b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e6f:	e8 dc da ff ff       	call   80103950 <cpuid>
80105e74:	57                   	push   %edi
80105e75:	56                   	push   %esi
80105e76:	50                   	push   %eax
80105e77:	68 34 7c 10 80       	push   $0x80107c34
80105e7c:	e8 2f a8 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105e81:	e8 6a ca ff ff       	call   801028f0 <lapiceoi>
    break;
80105e86:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e89:	e8 e2 da ff ff       	call   80103970 <myproc>
80105e8e:	85 c0                	test   %eax,%eax
80105e90:	0f 85 dd fe ff ff    	jne    80105d73 <trap+0x43>
80105e96:	e9 f2 fe ff ff       	jmp    80105d8d <trap+0x5d>
80105e9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105ea0:	e8 cb da ff ff       	call   80103970 <myproc>
80105ea5:	8b 70 24             	mov    0x24(%eax),%esi
80105ea8:	85 f6                	test   %esi,%esi
80105eaa:	0f 85 c8 00 00 00    	jne    80105f78 <trap+0x248>
    myproc()->tf = tf;
80105eb0:	e8 bb da ff ff       	call   80103970 <myproc>
80105eb5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105eb8:	e8 13 ee ff ff       	call   80104cd0 <syscall>
    if(myproc()->killed)
80105ebd:	e8 ae da ff ff       	call   80103970 <myproc>
80105ec2:	8b 48 24             	mov    0x24(%eax),%ecx
80105ec5:	85 c9                	test   %ecx,%ecx
80105ec7:	0f 84 fb fe ff ff    	je     80105dc8 <trap+0x98>
}
80105ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ed0:	5b                   	pop    %ebx
80105ed1:	5e                   	pop    %esi
80105ed2:	5f                   	pop    %edi
80105ed3:	5d                   	pop    %ebp
      exit();
80105ed4:	e9 a7 de ff ff       	jmp    80103d80 <exit>
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ee0:	e8 4b 02 00 00       	call   80106130 <uartintr>
    lapiceoi();
80105ee5:	e8 06 ca ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eea:	e8 81 da ff ff       	call   80103970 <myproc>
80105eef:	85 c0                	test   %eax,%eax
80105ef1:	0f 85 7c fe ff ff    	jne    80105d73 <trap+0x43>
80105ef7:	e9 91 fe ff ff       	jmp    80105d8d <trap+0x5d>
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105f00:	e8 bb c8 ff ff       	call   801027c0 <kbdintr>
    lapiceoi();
80105f05:	e8 e6 c9 ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f0a:	e8 61 da ff ff       	call   80103970 <myproc>
80105f0f:	85 c0                	test   %eax,%eax
80105f11:	0f 85 5c fe ff ff    	jne    80105d73 <trap+0x43>
80105f17:	e9 71 fe ff ff       	jmp    80105d8d <trap+0x5d>
80105f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105f20:	e8 2b da ff ff       	call   80103950 <cpuid>
80105f25:	85 c0                	test   %eax,%eax
80105f27:	0f 85 38 fe ff ff    	jne    80105d65 <trap+0x35>
      acquire(&tickslock);
80105f2d:	83 ec 0c             	sub    $0xc,%esp
80105f30:	68 80 cd 11 80       	push   $0x8011cd80
80105f35:	e8 a6 e8 ff ff       	call   801047e0 <acquire>
      ticks++;
80105f3a:	83 05 60 cd 11 80 01 	addl   $0x1,0x8011cd60
      wakeup(&ticks);
80105f41:	c7 04 24 60 cd 11 80 	movl   $0x8011cd60,(%esp)
80105f48:	e8 a3 e1 ff ff       	call   801040f0 <wakeup>
      release(&tickslock);
80105f4d:	c7 04 24 80 cd 11 80 	movl   $0x8011cd80,(%esp)
80105f54:	e8 27 e8 ff ff       	call   80104780 <release>
80105f59:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f5c:	e9 04 fe ff ff       	jmp    80105d65 <trap+0x35>
80105f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105f68:	e8 13 de ff ff       	call   80103d80 <exit>
80105f6d:	e9 1b fe ff ff       	jmp    80105d8d <trap+0x5d>
80105f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f78:	e8 03 de ff ff       	call   80103d80 <exit>
80105f7d:	e9 2e ff ff ff       	jmp    80105eb0 <trap+0x180>
80105f82:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f85:	e8 c6 d9 ff ff       	call   80103950 <cpuid>
80105f8a:	83 ec 0c             	sub    $0xc,%esp
80105f8d:	56                   	push   %esi
80105f8e:	57                   	push   %edi
80105f8f:	50                   	push   %eax
80105f90:	ff 73 30             	push   0x30(%ebx)
80105f93:	68 58 7c 10 80       	push   $0x80107c58
80105f98:	e8 13 a7 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105f9d:	83 c4 14             	add    $0x14,%esp
80105fa0:	68 42 7a 10 80       	push   $0x80107a42
80105fa5:	e8 d6 a3 ff ff       	call   80100380 <panic>
80105faa:	66 90                	xchg   %ax,%ax
80105fac:	66 90                	xchg   %ax,%ax
80105fae:	66 90                	xchg   %ax,%ax

80105fb0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105fb0:	a1 c0 d5 11 80       	mov    0x8011d5c0,%eax
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	74 17                	je     80105fd0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fb9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fbe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fbf:	a8 01                	test   $0x1,%al
80105fc1:	74 0d                	je     80105fd0 <uartgetc+0x20>
80105fc3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fc8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fc9:	0f b6 c0             	movzbl %al,%eax
80105fcc:	c3                   	ret
80105fcd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fd5:	c3                   	ret
80105fd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105fdd:	00 
80105fde:	66 90                	xchg   %ax,%ax

80105fe0 <uartinit>:
{
80105fe0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fe1:	31 c9                	xor    %ecx,%ecx
80105fe3:	89 c8                	mov    %ecx,%eax
80105fe5:	89 e5                	mov    %esp,%ebp
80105fe7:	57                   	push   %edi
80105fe8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105fed:	56                   	push   %esi
80105fee:	89 fa                	mov    %edi,%edx
80105ff0:	53                   	push   %ebx
80105ff1:	83 ec 1c             	sub    $0x1c,%esp
80105ff4:	ee                   	out    %al,(%dx)
80105ff5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105ffa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105fff:	89 f2                	mov    %esi,%edx
80106001:	ee                   	out    %al,(%dx)
80106002:	b8 0c 00 00 00       	mov    $0xc,%eax
80106007:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010600c:	ee                   	out    %al,(%dx)
8010600d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106012:	89 c8                	mov    %ecx,%eax
80106014:	89 da                	mov    %ebx,%edx
80106016:	ee                   	out    %al,(%dx)
80106017:	b8 03 00 00 00       	mov    $0x3,%eax
8010601c:	89 f2                	mov    %esi,%edx
8010601e:	ee                   	out    %al,(%dx)
8010601f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106024:	89 c8                	mov    %ecx,%eax
80106026:	ee                   	out    %al,(%dx)
80106027:	b8 01 00 00 00       	mov    $0x1,%eax
8010602c:	89 da                	mov    %ebx,%edx
8010602e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010602f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106034:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106035:	3c ff                	cmp    $0xff,%al
80106037:	0f 84 7c 00 00 00    	je     801060b9 <uartinit+0xd9>
  uart = 1;
8010603d:	c7 05 c0 d5 11 80 01 	movl   $0x1,0x8011d5c0
80106044:	00 00 00 
80106047:	89 fa                	mov    %edi,%edx
80106049:	ec                   	in     (%dx),%al
8010604a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010604f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106050:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106053:	bf 47 7a 10 80       	mov    $0x80107a47,%edi
80106058:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010605d:	6a 00                	push   $0x0
8010605f:	6a 04                	push   $0x4
80106061:	e8 fa c3 ff ff       	call   80102460 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106066:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
8010606a:	83 c4 10             	add    $0x10,%esp
8010606d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106070:	a1 c0 d5 11 80       	mov    0x8011d5c0,%eax
80106075:	85 c0                	test   %eax,%eax
80106077:	74 32                	je     801060ab <uartinit+0xcb>
80106079:	89 f2                	mov    %esi,%edx
8010607b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010607c:	a8 20                	test   $0x20,%al
8010607e:	75 21                	jne    801060a1 <uartinit+0xc1>
80106080:	bb 80 00 00 00       	mov    $0x80,%ebx
80106085:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106088:	83 ec 0c             	sub    $0xc,%esp
8010608b:	6a 0a                	push   $0xa
8010608d:	e8 7e c8 ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106092:	83 c4 10             	add    $0x10,%esp
80106095:	83 eb 01             	sub    $0x1,%ebx
80106098:	74 07                	je     801060a1 <uartinit+0xc1>
8010609a:	89 f2                	mov    %esi,%edx
8010609c:	ec                   	in     (%dx),%al
8010609d:	a8 20                	test   $0x20,%al
8010609f:	74 e7                	je     80106088 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060a1:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060a6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801060aa:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801060ab:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801060af:	83 c7 01             	add    $0x1,%edi
801060b2:	88 45 e7             	mov    %al,-0x19(%ebp)
801060b5:	84 c0                	test   %al,%al
801060b7:	75 b7                	jne    80106070 <uartinit+0x90>
}
801060b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060bc:	5b                   	pop    %ebx
801060bd:	5e                   	pop    %esi
801060be:	5f                   	pop    %edi
801060bf:	5d                   	pop    %ebp
801060c0:	c3                   	ret
801060c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801060c8:	00 
801060c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060d0 <uartputc>:
  if(!uart)
801060d0:	a1 c0 d5 11 80       	mov    0x8011d5c0,%eax
801060d5:	85 c0                	test   %eax,%eax
801060d7:	74 4f                	je     80106128 <uartputc+0x58>
{
801060d9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060da:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060df:	89 e5                	mov    %esp,%ebp
801060e1:	56                   	push   %esi
801060e2:	53                   	push   %ebx
801060e3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060e4:	a8 20                	test   $0x20,%al
801060e6:	75 29                	jne    80106111 <uartputc+0x41>
801060e8:	bb 80 00 00 00       	mov    $0x80,%ebx
801060ed:	be fd 03 00 00       	mov    $0x3fd,%esi
801060f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801060f8:	83 ec 0c             	sub    $0xc,%esp
801060fb:	6a 0a                	push   $0xa
801060fd:	e8 0e c8 ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106102:	83 c4 10             	add    $0x10,%esp
80106105:	83 eb 01             	sub    $0x1,%ebx
80106108:	74 07                	je     80106111 <uartputc+0x41>
8010610a:	89 f2                	mov    %esi,%edx
8010610c:	ec                   	in     (%dx),%al
8010610d:	a8 20                	test   $0x20,%al
8010610f:	74 e7                	je     801060f8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106111:	8b 45 08             	mov    0x8(%ebp),%eax
80106114:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106119:	ee                   	out    %al,(%dx)
}
8010611a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010611d:	5b                   	pop    %ebx
8010611e:	5e                   	pop    %esi
8010611f:	5d                   	pop    %ebp
80106120:	c3                   	ret
80106121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106128:	c3                   	ret
80106129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106130 <uartintr>:

void
uartintr(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106136:	68 b0 5f 10 80       	push   $0x80105fb0
8010613b:	e8 60 a7 ff ff       	call   801008a0 <consoleintr>
}
80106140:	83 c4 10             	add    $0x10,%esp
80106143:	c9                   	leave
80106144:	c3                   	ret

80106145 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $0
80106147:	6a 00                	push   $0x0
  jmp alltraps
80106149:	e9 07 fb ff ff       	jmp    80105c55 <alltraps>

8010614e <vector1>:
.globl vector1
vector1:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $1
80106150:	6a 01                	push   $0x1
  jmp alltraps
80106152:	e9 fe fa ff ff       	jmp    80105c55 <alltraps>

80106157 <vector2>:
.globl vector2
vector2:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $2
80106159:	6a 02                	push   $0x2
  jmp alltraps
8010615b:	e9 f5 fa ff ff       	jmp    80105c55 <alltraps>

80106160 <vector3>:
.globl vector3
vector3:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $3
80106162:	6a 03                	push   $0x3
  jmp alltraps
80106164:	e9 ec fa ff ff       	jmp    80105c55 <alltraps>

80106169 <vector4>:
.globl vector4
vector4:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $4
8010616b:	6a 04                	push   $0x4
  jmp alltraps
8010616d:	e9 e3 fa ff ff       	jmp    80105c55 <alltraps>

80106172 <vector5>:
.globl vector5
vector5:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $5
80106174:	6a 05                	push   $0x5
  jmp alltraps
80106176:	e9 da fa ff ff       	jmp    80105c55 <alltraps>

8010617b <vector6>:
.globl vector6
vector6:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $6
8010617d:	6a 06                	push   $0x6
  jmp alltraps
8010617f:	e9 d1 fa ff ff       	jmp    80105c55 <alltraps>

80106184 <vector7>:
.globl vector7
vector7:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $7
80106186:	6a 07                	push   $0x7
  jmp alltraps
80106188:	e9 c8 fa ff ff       	jmp    80105c55 <alltraps>

8010618d <vector8>:
.globl vector8
vector8:
  pushl $8
8010618d:	6a 08                	push   $0x8
  jmp alltraps
8010618f:	e9 c1 fa ff ff       	jmp    80105c55 <alltraps>

80106194 <vector9>:
.globl vector9
vector9:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $9
80106196:	6a 09                	push   $0x9
  jmp alltraps
80106198:	e9 b8 fa ff ff       	jmp    80105c55 <alltraps>

8010619d <vector10>:
.globl vector10
vector10:
  pushl $10
8010619d:	6a 0a                	push   $0xa
  jmp alltraps
8010619f:	e9 b1 fa ff ff       	jmp    80105c55 <alltraps>

801061a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801061a4:	6a 0b                	push   $0xb
  jmp alltraps
801061a6:	e9 aa fa ff ff       	jmp    80105c55 <alltraps>

801061ab <vector12>:
.globl vector12
vector12:
  pushl $12
801061ab:	6a 0c                	push   $0xc
  jmp alltraps
801061ad:	e9 a3 fa ff ff       	jmp    80105c55 <alltraps>

801061b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801061b2:	6a 0d                	push   $0xd
  jmp alltraps
801061b4:	e9 9c fa ff ff       	jmp    80105c55 <alltraps>

801061b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801061b9:	6a 0e                	push   $0xe
  jmp alltraps
801061bb:	e9 95 fa ff ff       	jmp    80105c55 <alltraps>

801061c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801061c0:	6a 00                	push   $0x0
  pushl $15
801061c2:	6a 0f                	push   $0xf
  jmp alltraps
801061c4:	e9 8c fa ff ff       	jmp    80105c55 <alltraps>

801061c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $16
801061cb:	6a 10                	push   $0x10
  jmp alltraps
801061cd:	e9 83 fa ff ff       	jmp    80105c55 <alltraps>

801061d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801061d2:	6a 11                	push   $0x11
  jmp alltraps
801061d4:	e9 7c fa ff ff       	jmp    80105c55 <alltraps>

801061d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $18
801061db:	6a 12                	push   $0x12
  jmp alltraps
801061dd:	e9 73 fa ff ff       	jmp    80105c55 <alltraps>

801061e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $19
801061e4:	6a 13                	push   $0x13
  jmp alltraps
801061e6:	e9 6a fa ff ff       	jmp    80105c55 <alltraps>

801061eb <vector20>:
.globl vector20
vector20:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $20
801061ed:	6a 14                	push   $0x14
  jmp alltraps
801061ef:	e9 61 fa ff ff       	jmp    80105c55 <alltraps>

801061f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $21
801061f6:	6a 15                	push   $0x15
  jmp alltraps
801061f8:	e9 58 fa ff ff       	jmp    80105c55 <alltraps>

801061fd <vector22>:
.globl vector22
vector22:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $22
801061ff:	6a 16                	push   $0x16
  jmp alltraps
80106201:	e9 4f fa ff ff       	jmp    80105c55 <alltraps>

80106206 <vector23>:
.globl vector23
vector23:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $23
80106208:	6a 17                	push   $0x17
  jmp alltraps
8010620a:	e9 46 fa ff ff       	jmp    80105c55 <alltraps>

8010620f <vector24>:
.globl vector24
vector24:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $24
80106211:	6a 18                	push   $0x18
  jmp alltraps
80106213:	e9 3d fa ff ff       	jmp    80105c55 <alltraps>

80106218 <vector25>:
.globl vector25
vector25:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $25
8010621a:	6a 19                	push   $0x19
  jmp alltraps
8010621c:	e9 34 fa ff ff       	jmp    80105c55 <alltraps>

80106221 <vector26>:
.globl vector26
vector26:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $26
80106223:	6a 1a                	push   $0x1a
  jmp alltraps
80106225:	e9 2b fa ff ff       	jmp    80105c55 <alltraps>

8010622a <vector27>:
.globl vector27
vector27:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $27
8010622c:	6a 1b                	push   $0x1b
  jmp alltraps
8010622e:	e9 22 fa ff ff       	jmp    80105c55 <alltraps>

80106233 <vector28>:
.globl vector28
vector28:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $28
80106235:	6a 1c                	push   $0x1c
  jmp alltraps
80106237:	e9 19 fa ff ff       	jmp    80105c55 <alltraps>

8010623c <vector29>:
.globl vector29
vector29:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $29
8010623e:	6a 1d                	push   $0x1d
  jmp alltraps
80106240:	e9 10 fa ff ff       	jmp    80105c55 <alltraps>

80106245 <vector30>:
.globl vector30
vector30:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $30
80106247:	6a 1e                	push   $0x1e
  jmp alltraps
80106249:	e9 07 fa ff ff       	jmp    80105c55 <alltraps>

8010624e <vector31>:
.globl vector31
vector31:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $31
80106250:	6a 1f                	push   $0x1f
  jmp alltraps
80106252:	e9 fe f9 ff ff       	jmp    80105c55 <alltraps>

80106257 <vector32>:
.globl vector32
vector32:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $32
80106259:	6a 20                	push   $0x20
  jmp alltraps
8010625b:	e9 f5 f9 ff ff       	jmp    80105c55 <alltraps>

80106260 <vector33>:
.globl vector33
vector33:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $33
80106262:	6a 21                	push   $0x21
  jmp alltraps
80106264:	e9 ec f9 ff ff       	jmp    80105c55 <alltraps>

80106269 <vector34>:
.globl vector34
vector34:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $34
8010626b:	6a 22                	push   $0x22
  jmp alltraps
8010626d:	e9 e3 f9 ff ff       	jmp    80105c55 <alltraps>

80106272 <vector35>:
.globl vector35
vector35:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $35
80106274:	6a 23                	push   $0x23
  jmp alltraps
80106276:	e9 da f9 ff ff       	jmp    80105c55 <alltraps>

8010627b <vector36>:
.globl vector36
vector36:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $36
8010627d:	6a 24                	push   $0x24
  jmp alltraps
8010627f:	e9 d1 f9 ff ff       	jmp    80105c55 <alltraps>

80106284 <vector37>:
.globl vector37
vector37:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $37
80106286:	6a 25                	push   $0x25
  jmp alltraps
80106288:	e9 c8 f9 ff ff       	jmp    80105c55 <alltraps>

8010628d <vector38>:
.globl vector38
vector38:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $38
8010628f:	6a 26                	push   $0x26
  jmp alltraps
80106291:	e9 bf f9 ff ff       	jmp    80105c55 <alltraps>

80106296 <vector39>:
.globl vector39
vector39:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $39
80106298:	6a 27                	push   $0x27
  jmp alltraps
8010629a:	e9 b6 f9 ff ff       	jmp    80105c55 <alltraps>

8010629f <vector40>:
.globl vector40
vector40:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $40
801062a1:	6a 28                	push   $0x28
  jmp alltraps
801062a3:	e9 ad f9 ff ff       	jmp    80105c55 <alltraps>

801062a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $41
801062aa:	6a 29                	push   $0x29
  jmp alltraps
801062ac:	e9 a4 f9 ff ff       	jmp    80105c55 <alltraps>

801062b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $42
801062b3:	6a 2a                	push   $0x2a
  jmp alltraps
801062b5:	e9 9b f9 ff ff       	jmp    80105c55 <alltraps>

801062ba <vector43>:
.globl vector43
vector43:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $43
801062bc:	6a 2b                	push   $0x2b
  jmp alltraps
801062be:	e9 92 f9 ff ff       	jmp    80105c55 <alltraps>

801062c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $44
801062c5:	6a 2c                	push   $0x2c
  jmp alltraps
801062c7:	e9 89 f9 ff ff       	jmp    80105c55 <alltraps>

801062cc <vector45>:
.globl vector45
vector45:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $45
801062ce:	6a 2d                	push   $0x2d
  jmp alltraps
801062d0:	e9 80 f9 ff ff       	jmp    80105c55 <alltraps>

801062d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $46
801062d7:	6a 2e                	push   $0x2e
  jmp alltraps
801062d9:	e9 77 f9 ff ff       	jmp    80105c55 <alltraps>

801062de <vector47>:
.globl vector47
vector47:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $47
801062e0:	6a 2f                	push   $0x2f
  jmp alltraps
801062e2:	e9 6e f9 ff ff       	jmp    80105c55 <alltraps>

801062e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $48
801062e9:	6a 30                	push   $0x30
  jmp alltraps
801062eb:	e9 65 f9 ff ff       	jmp    80105c55 <alltraps>

801062f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $49
801062f2:	6a 31                	push   $0x31
  jmp alltraps
801062f4:	e9 5c f9 ff ff       	jmp    80105c55 <alltraps>

801062f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $50
801062fb:	6a 32                	push   $0x32
  jmp alltraps
801062fd:	e9 53 f9 ff ff       	jmp    80105c55 <alltraps>

80106302 <vector51>:
.globl vector51
vector51:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $51
80106304:	6a 33                	push   $0x33
  jmp alltraps
80106306:	e9 4a f9 ff ff       	jmp    80105c55 <alltraps>

8010630b <vector52>:
.globl vector52
vector52:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $52
8010630d:	6a 34                	push   $0x34
  jmp alltraps
8010630f:	e9 41 f9 ff ff       	jmp    80105c55 <alltraps>

80106314 <vector53>:
.globl vector53
vector53:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $53
80106316:	6a 35                	push   $0x35
  jmp alltraps
80106318:	e9 38 f9 ff ff       	jmp    80105c55 <alltraps>

8010631d <vector54>:
.globl vector54
vector54:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $54
8010631f:	6a 36                	push   $0x36
  jmp alltraps
80106321:	e9 2f f9 ff ff       	jmp    80105c55 <alltraps>

80106326 <vector55>:
.globl vector55
vector55:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $55
80106328:	6a 37                	push   $0x37
  jmp alltraps
8010632a:	e9 26 f9 ff ff       	jmp    80105c55 <alltraps>

8010632f <vector56>:
.globl vector56
vector56:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $56
80106331:	6a 38                	push   $0x38
  jmp alltraps
80106333:	e9 1d f9 ff ff       	jmp    80105c55 <alltraps>

80106338 <vector57>:
.globl vector57
vector57:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $57
8010633a:	6a 39                	push   $0x39
  jmp alltraps
8010633c:	e9 14 f9 ff ff       	jmp    80105c55 <alltraps>

80106341 <vector58>:
.globl vector58
vector58:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $58
80106343:	6a 3a                	push   $0x3a
  jmp alltraps
80106345:	e9 0b f9 ff ff       	jmp    80105c55 <alltraps>

8010634a <vector59>:
.globl vector59
vector59:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $59
8010634c:	6a 3b                	push   $0x3b
  jmp alltraps
8010634e:	e9 02 f9 ff ff       	jmp    80105c55 <alltraps>

80106353 <vector60>:
.globl vector60
vector60:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $60
80106355:	6a 3c                	push   $0x3c
  jmp alltraps
80106357:	e9 f9 f8 ff ff       	jmp    80105c55 <alltraps>

8010635c <vector61>:
.globl vector61
vector61:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $61
8010635e:	6a 3d                	push   $0x3d
  jmp alltraps
80106360:	e9 f0 f8 ff ff       	jmp    80105c55 <alltraps>

80106365 <vector62>:
.globl vector62
vector62:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $62
80106367:	6a 3e                	push   $0x3e
  jmp alltraps
80106369:	e9 e7 f8 ff ff       	jmp    80105c55 <alltraps>

8010636e <vector63>:
.globl vector63
vector63:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $63
80106370:	6a 3f                	push   $0x3f
  jmp alltraps
80106372:	e9 de f8 ff ff       	jmp    80105c55 <alltraps>

80106377 <vector64>:
.globl vector64
vector64:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $64
80106379:	6a 40                	push   $0x40
  jmp alltraps
8010637b:	e9 d5 f8 ff ff       	jmp    80105c55 <alltraps>

80106380 <vector65>:
.globl vector65
vector65:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $65
80106382:	6a 41                	push   $0x41
  jmp alltraps
80106384:	e9 cc f8 ff ff       	jmp    80105c55 <alltraps>

80106389 <vector66>:
.globl vector66
vector66:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $66
8010638b:	6a 42                	push   $0x42
  jmp alltraps
8010638d:	e9 c3 f8 ff ff       	jmp    80105c55 <alltraps>

80106392 <vector67>:
.globl vector67
vector67:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $67
80106394:	6a 43                	push   $0x43
  jmp alltraps
80106396:	e9 ba f8 ff ff       	jmp    80105c55 <alltraps>

8010639b <vector68>:
.globl vector68
vector68:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $68
8010639d:	6a 44                	push   $0x44
  jmp alltraps
8010639f:	e9 b1 f8 ff ff       	jmp    80105c55 <alltraps>

801063a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $69
801063a6:	6a 45                	push   $0x45
  jmp alltraps
801063a8:	e9 a8 f8 ff ff       	jmp    80105c55 <alltraps>

801063ad <vector70>:
.globl vector70
vector70:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $70
801063af:	6a 46                	push   $0x46
  jmp alltraps
801063b1:	e9 9f f8 ff ff       	jmp    80105c55 <alltraps>

801063b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $71
801063b8:	6a 47                	push   $0x47
  jmp alltraps
801063ba:	e9 96 f8 ff ff       	jmp    80105c55 <alltraps>

801063bf <vector72>:
.globl vector72
vector72:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $72
801063c1:	6a 48                	push   $0x48
  jmp alltraps
801063c3:	e9 8d f8 ff ff       	jmp    80105c55 <alltraps>

801063c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $73
801063ca:	6a 49                	push   $0x49
  jmp alltraps
801063cc:	e9 84 f8 ff ff       	jmp    80105c55 <alltraps>

801063d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $74
801063d3:	6a 4a                	push   $0x4a
  jmp alltraps
801063d5:	e9 7b f8 ff ff       	jmp    80105c55 <alltraps>

801063da <vector75>:
.globl vector75
vector75:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $75
801063dc:	6a 4b                	push   $0x4b
  jmp alltraps
801063de:	e9 72 f8 ff ff       	jmp    80105c55 <alltraps>

801063e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $76
801063e5:	6a 4c                	push   $0x4c
  jmp alltraps
801063e7:	e9 69 f8 ff ff       	jmp    80105c55 <alltraps>

801063ec <vector77>:
.globl vector77
vector77:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $77
801063ee:	6a 4d                	push   $0x4d
  jmp alltraps
801063f0:	e9 60 f8 ff ff       	jmp    80105c55 <alltraps>

801063f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $78
801063f7:	6a 4e                	push   $0x4e
  jmp alltraps
801063f9:	e9 57 f8 ff ff       	jmp    80105c55 <alltraps>

801063fe <vector79>:
.globl vector79
vector79:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $79
80106400:	6a 4f                	push   $0x4f
  jmp alltraps
80106402:	e9 4e f8 ff ff       	jmp    80105c55 <alltraps>

80106407 <vector80>:
.globl vector80
vector80:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $80
80106409:	6a 50                	push   $0x50
  jmp alltraps
8010640b:	e9 45 f8 ff ff       	jmp    80105c55 <alltraps>

80106410 <vector81>:
.globl vector81
vector81:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $81
80106412:	6a 51                	push   $0x51
  jmp alltraps
80106414:	e9 3c f8 ff ff       	jmp    80105c55 <alltraps>

80106419 <vector82>:
.globl vector82
vector82:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $82
8010641b:	6a 52                	push   $0x52
  jmp alltraps
8010641d:	e9 33 f8 ff ff       	jmp    80105c55 <alltraps>

80106422 <vector83>:
.globl vector83
vector83:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $83
80106424:	6a 53                	push   $0x53
  jmp alltraps
80106426:	e9 2a f8 ff ff       	jmp    80105c55 <alltraps>

8010642b <vector84>:
.globl vector84
vector84:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $84
8010642d:	6a 54                	push   $0x54
  jmp alltraps
8010642f:	e9 21 f8 ff ff       	jmp    80105c55 <alltraps>

80106434 <vector85>:
.globl vector85
vector85:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $85
80106436:	6a 55                	push   $0x55
  jmp alltraps
80106438:	e9 18 f8 ff ff       	jmp    80105c55 <alltraps>

8010643d <vector86>:
.globl vector86
vector86:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $86
8010643f:	6a 56                	push   $0x56
  jmp alltraps
80106441:	e9 0f f8 ff ff       	jmp    80105c55 <alltraps>

80106446 <vector87>:
.globl vector87
vector87:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $87
80106448:	6a 57                	push   $0x57
  jmp alltraps
8010644a:	e9 06 f8 ff ff       	jmp    80105c55 <alltraps>

8010644f <vector88>:
.globl vector88
vector88:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $88
80106451:	6a 58                	push   $0x58
  jmp alltraps
80106453:	e9 fd f7 ff ff       	jmp    80105c55 <alltraps>

80106458 <vector89>:
.globl vector89
vector89:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $89
8010645a:	6a 59                	push   $0x59
  jmp alltraps
8010645c:	e9 f4 f7 ff ff       	jmp    80105c55 <alltraps>

80106461 <vector90>:
.globl vector90
vector90:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $90
80106463:	6a 5a                	push   $0x5a
  jmp alltraps
80106465:	e9 eb f7 ff ff       	jmp    80105c55 <alltraps>

8010646a <vector91>:
.globl vector91
vector91:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $91
8010646c:	6a 5b                	push   $0x5b
  jmp alltraps
8010646e:	e9 e2 f7 ff ff       	jmp    80105c55 <alltraps>

80106473 <vector92>:
.globl vector92
vector92:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $92
80106475:	6a 5c                	push   $0x5c
  jmp alltraps
80106477:	e9 d9 f7 ff ff       	jmp    80105c55 <alltraps>

8010647c <vector93>:
.globl vector93
vector93:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $93
8010647e:	6a 5d                	push   $0x5d
  jmp alltraps
80106480:	e9 d0 f7 ff ff       	jmp    80105c55 <alltraps>

80106485 <vector94>:
.globl vector94
vector94:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $94
80106487:	6a 5e                	push   $0x5e
  jmp alltraps
80106489:	e9 c7 f7 ff ff       	jmp    80105c55 <alltraps>

8010648e <vector95>:
.globl vector95
vector95:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $95
80106490:	6a 5f                	push   $0x5f
  jmp alltraps
80106492:	e9 be f7 ff ff       	jmp    80105c55 <alltraps>

80106497 <vector96>:
.globl vector96
vector96:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $96
80106499:	6a 60                	push   $0x60
  jmp alltraps
8010649b:	e9 b5 f7 ff ff       	jmp    80105c55 <alltraps>

801064a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $97
801064a2:	6a 61                	push   $0x61
  jmp alltraps
801064a4:	e9 ac f7 ff ff       	jmp    80105c55 <alltraps>

801064a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $98
801064ab:	6a 62                	push   $0x62
  jmp alltraps
801064ad:	e9 a3 f7 ff ff       	jmp    80105c55 <alltraps>

801064b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $99
801064b4:	6a 63                	push   $0x63
  jmp alltraps
801064b6:	e9 9a f7 ff ff       	jmp    80105c55 <alltraps>

801064bb <vector100>:
.globl vector100
vector100:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $100
801064bd:	6a 64                	push   $0x64
  jmp alltraps
801064bf:	e9 91 f7 ff ff       	jmp    80105c55 <alltraps>

801064c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $101
801064c6:	6a 65                	push   $0x65
  jmp alltraps
801064c8:	e9 88 f7 ff ff       	jmp    80105c55 <alltraps>

801064cd <vector102>:
.globl vector102
vector102:
  pushl $0
801064cd:	6a 00                	push   $0x0
  pushl $102
801064cf:	6a 66                	push   $0x66
  jmp alltraps
801064d1:	e9 7f f7 ff ff       	jmp    80105c55 <alltraps>

801064d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $103
801064d8:	6a 67                	push   $0x67
  jmp alltraps
801064da:	e9 76 f7 ff ff       	jmp    80105c55 <alltraps>

801064df <vector104>:
.globl vector104
vector104:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $104
801064e1:	6a 68                	push   $0x68
  jmp alltraps
801064e3:	e9 6d f7 ff ff       	jmp    80105c55 <alltraps>

801064e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801064e8:	6a 00                	push   $0x0
  pushl $105
801064ea:	6a 69                	push   $0x69
  jmp alltraps
801064ec:	e9 64 f7 ff ff       	jmp    80105c55 <alltraps>

801064f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064f1:	6a 00                	push   $0x0
  pushl $106
801064f3:	6a 6a                	push   $0x6a
  jmp alltraps
801064f5:	e9 5b f7 ff ff       	jmp    80105c55 <alltraps>

801064fa <vector107>:
.globl vector107
vector107:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $107
801064fc:	6a 6b                	push   $0x6b
  jmp alltraps
801064fe:	e9 52 f7 ff ff       	jmp    80105c55 <alltraps>

80106503 <vector108>:
.globl vector108
vector108:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $108
80106505:	6a 6c                	push   $0x6c
  jmp alltraps
80106507:	e9 49 f7 ff ff       	jmp    80105c55 <alltraps>

8010650c <vector109>:
.globl vector109
vector109:
  pushl $0
8010650c:	6a 00                	push   $0x0
  pushl $109
8010650e:	6a 6d                	push   $0x6d
  jmp alltraps
80106510:	e9 40 f7 ff ff       	jmp    80105c55 <alltraps>

80106515 <vector110>:
.globl vector110
vector110:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $110
80106517:	6a 6e                	push   $0x6e
  jmp alltraps
80106519:	e9 37 f7 ff ff       	jmp    80105c55 <alltraps>

8010651e <vector111>:
.globl vector111
vector111:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $111
80106520:	6a 6f                	push   $0x6f
  jmp alltraps
80106522:	e9 2e f7 ff ff       	jmp    80105c55 <alltraps>

80106527 <vector112>:
.globl vector112
vector112:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $112
80106529:	6a 70                	push   $0x70
  jmp alltraps
8010652b:	e9 25 f7 ff ff       	jmp    80105c55 <alltraps>

80106530 <vector113>:
.globl vector113
vector113:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $113
80106532:	6a 71                	push   $0x71
  jmp alltraps
80106534:	e9 1c f7 ff ff       	jmp    80105c55 <alltraps>

80106539 <vector114>:
.globl vector114
vector114:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $114
8010653b:	6a 72                	push   $0x72
  jmp alltraps
8010653d:	e9 13 f7 ff ff       	jmp    80105c55 <alltraps>

80106542 <vector115>:
.globl vector115
vector115:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $115
80106544:	6a 73                	push   $0x73
  jmp alltraps
80106546:	e9 0a f7 ff ff       	jmp    80105c55 <alltraps>

8010654b <vector116>:
.globl vector116
vector116:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $116
8010654d:	6a 74                	push   $0x74
  jmp alltraps
8010654f:	e9 01 f7 ff ff       	jmp    80105c55 <alltraps>

80106554 <vector117>:
.globl vector117
vector117:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $117
80106556:	6a 75                	push   $0x75
  jmp alltraps
80106558:	e9 f8 f6 ff ff       	jmp    80105c55 <alltraps>

8010655d <vector118>:
.globl vector118
vector118:
  pushl $0
8010655d:	6a 00                	push   $0x0
  pushl $118
8010655f:	6a 76                	push   $0x76
  jmp alltraps
80106561:	e9 ef f6 ff ff       	jmp    80105c55 <alltraps>

80106566 <vector119>:
.globl vector119
vector119:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $119
80106568:	6a 77                	push   $0x77
  jmp alltraps
8010656a:	e9 e6 f6 ff ff       	jmp    80105c55 <alltraps>

8010656f <vector120>:
.globl vector120
vector120:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $120
80106571:	6a 78                	push   $0x78
  jmp alltraps
80106573:	e9 dd f6 ff ff       	jmp    80105c55 <alltraps>

80106578 <vector121>:
.globl vector121
vector121:
  pushl $0
80106578:	6a 00                	push   $0x0
  pushl $121
8010657a:	6a 79                	push   $0x79
  jmp alltraps
8010657c:	e9 d4 f6 ff ff       	jmp    80105c55 <alltraps>

80106581 <vector122>:
.globl vector122
vector122:
  pushl $0
80106581:	6a 00                	push   $0x0
  pushl $122
80106583:	6a 7a                	push   $0x7a
  jmp alltraps
80106585:	e9 cb f6 ff ff       	jmp    80105c55 <alltraps>

8010658a <vector123>:
.globl vector123
vector123:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $123
8010658c:	6a 7b                	push   $0x7b
  jmp alltraps
8010658e:	e9 c2 f6 ff ff       	jmp    80105c55 <alltraps>

80106593 <vector124>:
.globl vector124
vector124:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $124
80106595:	6a 7c                	push   $0x7c
  jmp alltraps
80106597:	e9 b9 f6 ff ff       	jmp    80105c55 <alltraps>

8010659c <vector125>:
.globl vector125
vector125:
  pushl $0
8010659c:	6a 00                	push   $0x0
  pushl $125
8010659e:	6a 7d                	push   $0x7d
  jmp alltraps
801065a0:	e9 b0 f6 ff ff       	jmp    80105c55 <alltraps>

801065a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801065a5:	6a 00                	push   $0x0
  pushl $126
801065a7:	6a 7e                	push   $0x7e
  jmp alltraps
801065a9:	e9 a7 f6 ff ff       	jmp    80105c55 <alltraps>

801065ae <vector127>:
.globl vector127
vector127:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $127
801065b0:	6a 7f                	push   $0x7f
  jmp alltraps
801065b2:	e9 9e f6 ff ff       	jmp    80105c55 <alltraps>

801065b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $128
801065b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065be:	e9 92 f6 ff ff       	jmp    80105c55 <alltraps>

801065c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $129
801065c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801065ca:	e9 86 f6 ff ff       	jmp    80105c55 <alltraps>

801065cf <vector130>:
.globl vector130
vector130:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $130
801065d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065d6:	e9 7a f6 ff ff       	jmp    80105c55 <alltraps>

801065db <vector131>:
.globl vector131
vector131:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $131
801065dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065e2:	e9 6e f6 ff ff       	jmp    80105c55 <alltraps>

801065e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $132
801065e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065ee:	e9 62 f6 ff ff       	jmp    80105c55 <alltraps>

801065f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $133
801065f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065fa:	e9 56 f6 ff ff       	jmp    80105c55 <alltraps>

801065ff <vector134>:
.globl vector134
vector134:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $134
80106601:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106606:	e9 4a f6 ff ff       	jmp    80105c55 <alltraps>

8010660b <vector135>:
.globl vector135
vector135:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $135
8010660d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106612:	e9 3e f6 ff ff       	jmp    80105c55 <alltraps>

80106617 <vector136>:
.globl vector136
vector136:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $136
80106619:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010661e:	e9 32 f6 ff ff       	jmp    80105c55 <alltraps>

80106623 <vector137>:
.globl vector137
vector137:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $137
80106625:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010662a:	e9 26 f6 ff ff       	jmp    80105c55 <alltraps>

8010662f <vector138>:
.globl vector138
vector138:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $138
80106631:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106636:	e9 1a f6 ff ff       	jmp    80105c55 <alltraps>

8010663b <vector139>:
.globl vector139
vector139:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $139
8010663d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106642:	e9 0e f6 ff ff       	jmp    80105c55 <alltraps>

80106647 <vector140>:
.globl vector140
vector140:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $140
80106649:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010664e:	e9 02 f6 ff ff       	jmp    80105c55 <alltraps>

80106653 <vector141>:
.globl vector141
vector141:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $141
80106655:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010665a:	e9 f6 f5 ff ff       	jmp    80105c55 <alltraps>

8010665f <vector142>:
.globl vector142
vector142:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $142
80106661:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106666:	e9 ea f5 ff ff       	jmp    80105c55 <alltraps>

8010666b <vector143>:
.globl vector143
vector143:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $143
8010666d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106672:	e9 de f5 ff ff       	jmp    80105c55 <alltraps>

80106677 <vector144>:
.globl vector144
vector144:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $144
80106679:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010667e:	e9 d2 f5 ff ff       	jmp    80105c55 <alltraps>

80106683 <vector145>:
.globl vector145
vector145:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $145
80106685:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010668a:	e9 c6 f5 ff ff       	jmp    80105c55 <alltraps>

8010668f <vector146>:
.globl vector146
vector146:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $146
80106691:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106696:	e9 ba f5 ff ff       	jmp    80105c55 <alltraps>

8010669b <vector147>:
.globl vector147
vector147:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $147
8010669d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801066a2:	e9 ae f5 ff ff       	jmp    80105c55 <alltraps>

801066a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $148
801066a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801066ae:	e9 a2 f5 ff ff       	jmp    80105c55 <alltraps>

801066b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $149
801066b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066ba:	e9 96 f5 ff ff       	jmp    80105c55 <alltraps>

801066bf <vector150>:
.globl vector150
vector150:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $150
801066c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801066c6:	e9 8a f5 ff ff       	jmp    80105c55 <alltraps>

801066cb <vector151>:
.globl vector151
vector151:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $151
801066cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066d2:	e9 7e f5 ff ff       	jmp    80105c55 <alltraps>

801066d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $152
801066d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066de:	e9 72 f5 ff ff       	jmp    80105c55 <alltraps>

801066e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $153
801066e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066ea:	e9 66 f5 ff ff       	jmp    80105c55 <alltraps>

801066ef <vector154>:
.globl vector154
vector154:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $154
801066f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066f6:	e9 5a f5 ff ff       	jmp    80105c55 <alltraps>

801066fb <vector155>:
.globl vector155
vector155:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $155
801066fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106702:	e9 4e f5 ff ff       	jmp    80105c55 <alltraps>

80106707 <vector156>:
.globl vector156
vector156:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $156
80106709:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010670e:	e9 42 f5 ff ff       	jmp    80105c55 <alltraps>

80106713 <vector157>:
.globl vector157
vector157:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $157
80106715:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010671a:	e9 36 f5 ff ff       	jmp    80105c55 <alltraps>

8010671f <vector158>:
.globl vector158
vector158:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $158
80106721:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106726:	e9 2a f5 ff ff       	jmp    80105c55 <alltraps>

8010672b <vector159>:
.globl vector159
vector159:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $159
8010672d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106732:	e9 1e f5 ff ff       	jmp    80105c55 <alltraps>

80106737 <vector160>:
.globl vector160
vector160:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $160
80106739:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010673e:	e9 12 f5 ff ff       	jmp    80105c55 <alltraps>

80106743 <vector161>:
.globl vector161
vector161:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $161
80106745:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010674a:	e9 06 f5 ff ff       	jmp    80105c55 <alltraps>

8010674f <vector162>:
.globl vector162
vector162:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $162
80106751:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106756:	e9 fa f4 ff ff       	jmp    80105c55 <alltraps>

8010675b <vector163>:
.globl vector163
vector163:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $163
8010675d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106762:	e9 ee f4 ff ff       	jmp    80105c55 <alltraps>

80106767 <vector164>:
.globl vector164
vector164:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $164
80106769:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010676e:	e9 e2 f4 ff ff       	jmp    80105c55 <alltraps>

80106773 <vector165>:
.globl vector165
vector165:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $165
80106775:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010677a:	e9 d6 f4 ff ff       	jmp    80105c55 <alltraps>

8010677f <vector166>:
.globl vector166
vector166:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $166
80106781:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106786:	e9 ca f4 ff ff       	jmp    80105c55 <alltraps>

8010678b <vector167>:
.globl vector167
vector167:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $167
8010678d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106792:	e9 be f4 ff ff       	jmp    80105c55 <alltraps>

80106797 <vector168>:
.globl vector168
vector168:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $168
80106799:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010679e:	e9 b2 f4 ff ff       	jmp    80105c55 <alltraps>

801067a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $169
801067a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801067aa:	e9 a6 f4 ff ff       	jmp    80105c55 <alltraps>

801067af <vector170>:
.globl vector170
vector170:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $170
801067b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067b6:	e9 9a f4 ff ff       	jmp    80105c55 <alltraps>

801067bb <vector171>:
.globl vector171
vector171:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $171
801067bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801067c2:	e9 8e f4 ff ff       	jmp    80105c55 <alltraps>

801067c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $172
801067c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801067ce:	e9 82 f4 ff ff       	jmp    80105c55 <alltraps>

801067d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $173
801067d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067da:	e9 76 f4 ff ff       	jmp    80105c55 <alltraps>

801067df <vector174>:
.globl vector174
vector174:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $174
801067e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067e6:	e9 6a f4 ff ff       	jmp    80105c55 <alltraps>

801067eb <vector175>:
.globl vector175
vector175:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $175
801067ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067f2:	e9 5e f4 ff ff       	jmp    80105c55 <alltraps>

801067f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $176
801067f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067fe:	e9 52 f4 ff ff       	jmp    80105c55 <alltraps>

80106803 <vector177>:
.globl vector177
vector177:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $177
80106805:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010680a:	e9 46 f4 ff ff       	jmp    80105c55 <alltraps>

8010680f <vector178>:
.globl vector178
vector178:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $178
80106811:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106816:	e9 3a f4 ff ff       	jmp    80105c55 <alltraps>

8010681b <vector179>:
.globl vector179
vector179:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $179
8010681d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106822:	e9 2e f4 ff ff       	jmp    80105c55 <alltraps>

80106827 <vector180>:
.globl vector180
vector180:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $180
80106829:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010682e:	e9 22 f4 ff ff       	jmp    80105c55 <alltraps>

80106833 <vector181>:
.globl vector181
vector181:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $181
80106835:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010683a:	e9 16 f4 ff ff       	jmp    80105c55 <alltraps>

8010683f <vector182>:
.globl vector182
vector182:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $182
80106841:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106846:	e9 0a f4 ff ff       	jmp    80105c55 <alltraps>

8010684b <vector183>:
.globl vector183
vector183:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $183
8010684d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106852:	e9 fe f3 ff ff       	jmp    80105c55 <alltraps>

80106857 <vector184>:
.globl vector184
vector184:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $184
80106859:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010685e:	e9 f2 f3 ff ff       	jmp    80105c55 <alltraps>

80106863 <vector185>:
.globl vector185
vector185:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $185
80106865:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010686a:	e9 e6 f3 ff ff       	jmp    80105c55 <alltraps>

8010686f <vector186>:
.globl vector186
vector186:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $186
80106871:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106876:	e9 da f3 ff ff       	jmp    80105c55 <alltraps>

8010687b <vector187>:
.globl vector187
vector187:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $187
8010687d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106882:	e9 ce f3 ff ff       	jmp    80105c55 <alltraps>

80106887 <vector188>:
.globl vector188
vector188:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $188
80106889:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010688e:	e9 c2 f3 ff ff       	jmp    80105c55 <alltraps>

80106893 <vector189>:
.globl vector189
vector189:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $189
80106895:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010689a:	e9 b6 f3 ff ff       	jmp    80105c55 <alltraps>

8010689f <vector190>:
.globl vector190
vector190:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $190
801068a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801068a6:	e9 aa f3 ff ff       	jmp    80105c55 <alltraps>

801068ab <vector191>:
.globl vector191
vector191:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $191
801068ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068b2:	e9 9e f3 ff ff       	jmp    80105c55 <alltraps>

801068b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $192
801068b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068be:	e9 92 f3 ff ff       	jmp    80105c55 <alltraps>

801068c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $193
801068c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801068ca:	e9 86 f3 ff ff       	jmp    80105c55 <alltraps>

801068cf <vector194>:
.globl vector194
vector194:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $194
801068d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068d6:	e9 7a f3 ff ff       	jmp    80105c55 <alltraps>

801068db <vector195>:
.globl vector195
vector195:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $195
801068dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068e2:	e9 6e f3 ff ff       	jmp    80105c55 <alltraps>

801068e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $196
801068e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068ee:	e9 62 f3 ff ff       	jmp    80105c55 <alltraps>

801068f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $197
801068f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068fa:	e9 56 f3 ff ff       	jmp    80105c55 <alltraps>

801068ff <vector198>:
.globl vector198
vector198:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $198
80106901:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106906:	e9 4a f3 ff ff       	jmp    80105c55 <alltraps>

8010690b <vector199>:
.globl vector199
vector199:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $199
8010690d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106912:	e9 3e f3 ff ff       	jmp    80105c55 <alltraps>

80106917 <vector200>:
.globl vector200
vector200:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $200
80106919:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010691e:	e9 32 f3 ff ff       	jmp    80105c55 <alltraps>

80106923 <vector201>:
.globl vector201
vector201:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $201
80106925:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010692a:	e9 26 f3 ff ff       	jmp    80105c55 <alltraps>

8010692f <vector202>:
.globl vector202
vector202:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $202
80106931:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106936:	e9 1a f3 ff ff       	jmp    80105c55 <alltraps>

8010693b <vector203>:
.globl vector203
vector203:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $203
8010693d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106942:	e9 0e f3 ff ff       	jmp    80105c55 <alltraps>

80106947 <vector204>:
.globl vector204
vector204:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $204
80106949:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010694e:	e9 02 f3 ff ff       	jmp    80105c55 <alltraps>

80106953 <vector205>:
.globl vector205
vector205:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $205
80106955:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010695a:	e9 f6 f2 ff ff       	jmp    80105c55 <alltraps>

8010695f <vector206>:
.globl vector206
vector206:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $206
80106961:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106966:	e9 ea f2 ff ff       	jmp    80105c55 <alltraps>

8010696b <vector207>:
.globl vector207
vector207:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $207
8010696d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106972:	e9 de f2 ff ff       	jmp    80105c55 <alltraps>

80106977 <vector208>:
.globl vector208
vector208:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $208
80106979:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010697e:	e9 d2 f2 ff ff       	jmp    80105c55 <alltraps>

80106983 <vector209>:
.globl vector209
vector209:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $209
80106985:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010698a:	e9 c6 f2 ff ff       	jmp    80105c55 <alltraps>

8010698f <vector210>:
.globl vector210
vector210:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $210
80106991:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106996:	e9 ba f2 ff ff       	jmp    80105c55 <alltraps>

8010699b <vector211>:
.globl vector211
vector211:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $211
8010699d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801069a2:	e9 ae f2 ff ff       	jmp    80105c55 <alltraps>

801069a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $212
801069a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801069ae:	e9 a2 f2 ff ff       	jmp    80105c55 <alltraps>

801069b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $213
801069b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069ba:	e9 96 f2 ff ff       	jmp    80105c55 <alltraps>

801069bf <vector214>:
.globl vector214
vector214:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $214
801069c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801069c6:	e9 8a f2 ff ff       	jmp    80105c55 <alltraps>

801069cb <vector215>:
.globl vector215
vector215:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $215
801069cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069d2:	e9 7e f2 ff ff       	jmp    80105c55 <alltraps>

801069d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $216
801069d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069de:	e9 72 f2 ff ff       	jmp    80105c55 <alltraps>

801069e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $217
801069e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069ea:	e9 66 f2 ff ff       	jmp    80105c55 <alltraps>

801069ef <vector218>:
.globl vector218
vector218:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $218
801069f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069f6:	e9 5a f2 ff ff       	jmp    80105c55 <alltraps>

801069fb <vector219>:
.globl vector219
vector219:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $219
801069fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a02:	e9 4e f2 ff ff       	jmp    80105c55 <alltraps>

80106a07 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $220
80106a09:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a0e:	e9 42 f2 ff ff       	jmp    80105c55 <alltraps>

80106a13 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $221
80106a15:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a1a:	e9 36 f2 ff ff       	jmp    80105c55 <alltraps>

80106a1f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $222
80106a21:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a26:	e9 2a f2 ff ff       	jmp    80105c55 <alltraps>

80106a2b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $223
80106a2d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a32:	e9 1e f2 ff ff       	jmp    80105c55 <alltraps>

80106a37 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $224
80106a39:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a3e:	e9 12 f2 ff ff       	jmp    80105c55 <alltraps>

80106a43 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $225
80106a45:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a4a:	e9 06 f2 ff ff       	jmp    80105c55 <alltraps>

80106a4f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $226
80106a51:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a56:	e9 fa f1 ff ff       	jmp    80105c55 <alltraps>

80106a5b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $227
80106a5d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a62:	e9 ee f1 ff ff       	jmp    80105c55 <alltraps>

80106a67 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $228
80106a69:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a6e:	e9 e2 f1 ff ff       	jmp    80105c55 <alltraps>

80106a73 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $229
80106a75:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a7a:	e9 d6 f1 ff ff       	jmp    80105c55 <alltraps>

80106a7f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $230
80106a81:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a86:	e9 ca f1 ff ff       	jmp    80105c55 <alltraps>

80106a8b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $231
80106a8d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a92:	e9 be f1 ff ff       	jmp    80105c55 <alltraps>

80106a97 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $232
80106a99:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a9e:	e9 b2 f1 ff ff       	jmp    80105c55 <alltraps>

80106aa3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $233
80106aa5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106aaa:	e9 a6 f1 ff ff       	jmp    80105c55 <alltraps>

80106aaf <vector234>:
.globl vector234
vector234:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $234
80106ab1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ab6:	e9 9a f1 ff ff       	jmp    80105c55 <alltraps>

80106abb <vector235>:
.globl vector235
vector235:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $235
80106abd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ac2:	e9 8e f1 ff ff       	jmp    80105c55 <alltraps>

80106ac7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $236
80106ac9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106ace:	e9 82 f1 ff ff       	jmp    80105c55 <alltraps>

80106ad3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $237
80106ad5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106ada:	e9 76 f1 ff ff       	jmp    80105c55 <alltraps>

80106adf <vector238>:
.globl vector238
vector238:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $238
80106ae1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ae6:	e9 6a f1 ff ff       	jmp    80105c55 <alltraps>

80106aeb <vector239>:
.globl vector239
vector239:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $239
80106aed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106af2:	e9 5e f1 ff ff       	jmp    80105c55 <alltraps>

80106af7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $240
80106af9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106afe:	e9 52 f1 ff ff       	jmp    80105c55 <alltraps>

80106b03 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $241
80106b05:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b0a:	e9 46 f1 ff ff       	jmp    80105c55 <alltraps>

80106b0f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $242
80106b11:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b16:	e9 3a f1 ff ff       	jmp    80105c55 <alltraps>

80106b1b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $243
80106b1d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b22:	e9 2e f1 ff ff       	jmp    80105c55 <alltraps>

80106b27 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $244
80106b29:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b2e:	e9 22 f1 ff ff       	jmp    80105c55 <alltraps>

80106b33 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $245
80106b35:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b3a:	e9 16 f1 ff ff       	jmp    80105c55 <alltraps>

80106b3f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $246
80106b41:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b46:	e9 0a f1 ff ff       	jmp    80105c55 <alltraps>

80106b4b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $247
80106b4d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b52:	e9 fe f0 ff ff       	jmp    80105c55 <alltraps>

80106b57 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $248
80106b59:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b5e:	e9 f2 f0 ff ff       	jmp    80105c55 <alltraps>

80106b63 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $249
80106b65:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b6a:	e9 e6 f0 ff ff       	jmp    80105c55 <alltraps>

80106b6f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $250
80106b71:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b76:	e9 da f0 ff ff       	jmp    80105c55 <alltraps>

80106b7b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $251
80106b7d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b82:	e9 ce f0 ff ff       	jmp    80105c55 <alltraps>

80106b87 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $252
80106b89:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b8e:	e9 c2 f0 ff ff       	jmp    80105c55 <alltraps>

80106b93 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $253
80106b95:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b9a:	e9 b6 f0 ff ff       	jmp    80105c55 <alltraps>

80106b9f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $254
80106ba1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ba6:	e9 aa f0 ff ff       	jmp    80105c55 <alltraps>

80106bab <vector255>:
.globl vector255
vector255:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $255
80106bad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106bb2:	e9 9e f0 ff ff       	jmp    80105c55 <alltraps>
80106bb7:	66 90                	xchg   %ax,%ax
80106bb9:	66 90                	xchg   %ax,%ax
80106bbb:	66 90                	xchg   %ax,%ax
80106bbd:	66 90                	xchg   %ax,%ax
80106bbf:	90                   	nop

80106bc0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	56                   	push   %esi
80106bc5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106bc6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106bcc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bd2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106bd5:	39 d3                	cmp    %edx,%ebx
80106bd7:	73 56                	jae    80106c2f <deallocuvm.part.0+0x6f>
80106bd9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106bdc:	89 c6                	mov    %eax,%esi
80106bde:	89 d7                	mov    %edx,%edi
80106be0:	eb 12                	jmp    80106bf4 <deallocuvm.part.0+0x34>
80106be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106be8:	83 c2 01             	add    $0x1,%edx
80106beb:	89 d3                	mov    %edx,%ebx
80106bed:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106bf0:	39 fb                	cmp    %edi,%ebx
80106bf2:	73 38                	jae    80106c2c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106bf4:	89 da                	mov    %ebx,%edx
80106bf6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106bf9:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106bfc:	a8 01                	test   $0x1,%al
80106bfe:	74 e8                	je     80106be8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106c00:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c07:	c1 e9 0a             	shr    $0xa,%ecx
80106c0a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106c10:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106c17:	85 c0                	test   %eax,%eax
80106c19:	74 cd                	je     80106be8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106c1b:	8b 10                	mov    (%eax),%edx
80106c1d:	f6 c2 01             	test   $0x1,%dl
80106c20:	75 1e                	jne    80106c40 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106c22:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c28:	39 fb                	cmp    %edi,%ebx
80106c2a:	72 c8                	jb     80106bf4 <deallocuvm.part.0+0x34>
80106c2c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c32:	89 c8                	mov    %ecx,%eax
80106c34:	5b                   	pop    %ebx
80106c35:	5e                   	pop    %esi
80106c36:	5f                   	pop    %edi
80106c37:	5d                   	pop    %ebp
80106c38:	c3                   	ret
80106c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106c40:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c46:	74 26                	je     80106c6e <deallocuvm.part.0+0xae>
      kfree(v);
80106c48:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c4b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c54:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106c5a:	52                   	push   %edx
80106c5b:	e8 40 b8 ff ff       	call   801024a0 <kfree>
      *pte = 0;
80106c60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106c63:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106c66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106c6c:	eb 82                	jmp    80106bf0 <deallocuvm.part.0+0x30>
        panic("kfree");
80106c6e:	83 ec 0c             	sub    $0xc,%esp
80106c71:	68 4c 77 10 80       	push   $0x8010774c
80106c76:	e8 05 97 ff ff       	call   80100380 <panic>
80106c7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106c80 <mappages>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106c86:	89 d3                	mov    %edx,%ebx
80106c88:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c8e:	83 ec 1c             	sub    $0x1c,%esp
80106c91:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c94:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca3:	29 d8                	sub    %ebx,%eax
80106ca5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ca8:	eb 3f                	jmp    80106ce9 <mappages+0x69>
80106caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106cb0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106cb7:	c1 ea 0a             	shr    $0xa,%edx
80106cba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106cc0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106cc7:	85 c0                	test   %eax,%eax
80106cc9:	74 75                	je     80106d40 <mappages+0xc0>
    if(*pte & PTE_P)
80106ccb:	f6 00 01             	testb  $0x1,(%eax)
80106cce:	0f 85 86 00 00 00    	jne    80106d5a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106cd4:	0b 75 0c             	or     0xc(%ebp),%esi
80106cd7:	83 ce 01             	or     $0x1,%esi
80106cda:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106cdf:	39 c3                	cmp    %eax,%ebx
80106ce1:	74 6d                	je     80106d50 <mappages+0xd0>
    a += PGSIZE;
80106ce3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106ce9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106cec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106cef:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106cf2:	89 d8                	mov    %ebx,%eax
80106cf4:	c1 e8 16             	shr    $0x16,%eax
80106cf7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106cfa:	8b 07                	mov    (%edi),%eax
80106cfc:	a8 01                	test   $0x1,%al
80106cfe:	75 b0                	jne    80106cb0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d00:	e8 5b b9 ff ff       	call   80102660 <kalloc>
80106d05:	85 c0                	test   %eax,%eax
80106d07:	74 37                	je     80106d40 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106d09:	83 ec 04             	sub    $0x4,%esp
80106d0c:	68 00 10 00 00       	push   $0x1000
80106d11:	6a 00                	push   $0x0
80106d13:	50                   	push   %eax
80106d14:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106d17:	e8 c4 db ff ff       	call   801048e0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d1c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106d1f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d22:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106d28:	83 c8 07             	or     $0x7,%eax
80106d2b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106d2d:	89 d8                	mov    %ebx,%eax
80106d2f:	c1 e8 0a             	shr    $0xa,%eax
80106d32:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d37:	01 d0                	add    %edx,%eax
80106d39:	eb 90                	jmp    80106ccb <mappages+0x4b>
80106d3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d48:	5b                   	pop    %ebx
80106d49:	5e                   	pop    %esi
80106d4a:	5f                   	pop    %edi
80106d4b:	5d                   	pop    %ebp
80106d4c:	c3                   	ret
80106d4d:	8d 76 00             	lea    0x0(%esi),%esi
80106d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d53:	31 c0                	xor    %eax,%eax
}
80106d55:	5b                   	pop    %ebx
80106d56:	5e                   	pop    %esi
80106d57:	5f                   	pop    %edi
80106d58:	5d                   	pop    %ebp
80106d59:	c3                   	ret
      panic("remap");
80106d5a:	83 ec 0c             	sub    $0xc,%esp
80106d5d:	68 4f 7a 10 80       	push   $0x80107a4f
80106d62:	e8 19 96 ff ff       	call   80100380 <panic>
80106d67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d6e:	00 
80106d6f:	90                   	nop

80106d70 <seginit>:
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d76:	e8 d5 cb ff ff       	call   80103950 <cpuid>
  pd[0] = size-1;
80106d7b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d80:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106d86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106d8a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106d91:	ff 00 00 
80106d94:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106d9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d9e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106da5:	ff 00 00 
80106da8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106daf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106db2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106db9:	ff 00 00 
80106dbc:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106dc3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106dc6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106dcd:	ff 00 00 
80106dd0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106dd7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106dda:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106ddf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106de3:	c1 e8 10             	shr    $0x10,%eax
80106de6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106dea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ded:	0f 01 10             	lgdtl  (%eax)
}
80106df0:	c9                   	leave
80106df1:	c3                   	ret
80106df2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106df9:	00 
80106dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e00:	a1 c4 d5 11 80       	mov    0x8011d5c4,%eax
80106e05:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e0a:	0f 22 d8             	mov    %eax,%cr3
}
80106e0d:	c3                   	ret
80106e0e:	66 90                	xchg   %ax,%ax

80106e10 <switchuvm>:
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
80106e16:	83 ec 1c             	sub    $0x1c,%esp
80106e19:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106e1c:	85 f6                	test   %esi,%esi
80106e1e:	0f 84 cb 00 00 00    	je     80106eef <switchuvm+0xdf>
  if(p->kstack == 0)
80106e24:	8b 46 08             	mov    0x8(%esi),%eax
80106e27:	85 c0                	test   %eax,%eax
80106e29:	0f 84 da 00 00 00    	je     80106f09 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106e2f:	8b 46 04             	mov    0x4(%esi),%eax
80106e32:	85 c0                	test   %eax,%eax
80106e34:	0f 84 c2 00 00 00    	je     80106efc <switchuvm+0xec>
  pushcli();
80106e3a:	e8 51 d8 ff ff       	call   80104690 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e3f:	e8 ac ca ff ff       	call   801038f0 <mycpu>
80106e44:	89 c3                	mov    %eax,%ebx
80106e46:	e8 a5 ca ff ff       	call   801038f0 <mycpu>
80106e4b:	89 c7                	mov    %eax,%edi
80106e4d:	e8 9e ca ff ff       	call   801038f0 <mycpu>
80106e52:	83 c7 08             	add    $0x8,%edi
80106e55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e58:	e8 93 ca ff ff       	call   801038f0 <mycpu>
80106e5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e60:	ba 67 00 00 00       	mov    $0x67,%edx
80106e65:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106e6c:	83 c0 08             	add    $0x8,%eax
80106e6f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e76:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e7b:	83 c1 08             	add    $0x8,%ecx
80106e7e:	c1 e8 18             	shr    $0x18,%eax
80106e81:	c1 e9 10             	shr    $0x10,%ecx
80106e84:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106e8a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106e90:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e95:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e9c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ea1:	e8 4a ca ff ff       	call   801038f0 <mycpu>
80106ea6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ead:	e8 3e ca ff ff       	call   801038f0 <mycpu>
80106eb2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106eb6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106eb9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ebf:	e8 2c ca ff ff       	call   801038f0 <mycpu>
80106ec4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ec7:	e8 24 ca ff ff       	call   801038f0 <mycpu>
80106ecc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ed0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ed5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ed8:	8b 46 04             	mov    0x4(%esi),%eax
80106edb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ee0:	0f 22 d8             	mov    %eax,%cr3
}
80106ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ee6:	5b                   	pop    %ebx
80106ee7:	5e                   	pop    %esi
80106ee8:	5f                   	pop    %edi
80106ee9:	5d                   	pop    %ebp
  popcli();
80106eea:	e9 f1 d7 ff ff       	jmp    801046e0 <popcli>
    panic("switchuvm: no process");
80106eef:	83 ec 0c             	sub    $0xc,%esp
80106ef2:	68 55 7a 10 80       	push   $0x80107a55
80106ef7:	e8 84 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106efc:	83 ec 0c             	sub    $0xc,%esp
80106eff:	68 80 7a 10 80       	push   $0x80107a80
80106f04:	e8 77 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106f09:	83 ec 0c             	sub    $0xc,%esp
80106f0c:	68 6b 7a 10 80       	push   $0x80107a6b
80106f11:	e8 6a 94 ff ff       	call   80100380 <panic>
80106f16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f1d:	00 
80106f1e:	66 90                	xchg   %ax,%ax

80106f20 <inituvm>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 1c             	sub    $0x1c,%esp
80106f29:	8b 45 08             	mov    0x8(%ebp),%eax
80106f2c:	8b 75 10             	mov    0x10(%ebp),%esi
80106f2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106f32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f35:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f3b:	77 49                	ja     80106f86 <inituvm+0x66>
  mem = kalloc();
80106f3d:	e8 1e b7 ff ff       	call   80102660 <kalloc>
  memset(mem, 0, PGSIZE);
80106f42:	83 ec 04             	sub    $0x4,%esp
80106f45:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106f4a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f4c:	6a 00                	push   $0x0
80106f4e:	50                   	push   %eax
80106f4f:	e8 8c d9 ff ff       	call   801048e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f54:	58                   	pop    %eax
80106f55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f5b:	5a                   	pop    %edx
80106f5c:	6a 06                	push   $0x6
80106f5e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f63:	31 d2                	xor    %edx,%edx
80106f65:	50                   	push   %eax
80106f66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f69:	e8 12 fd ff ff       	call   80106c80 <mappages>
  memmove(mem, init, sz);
80106f6e:	89 75 10             	mov    %esi,0x10(%ebp)
80106f71:	83 c4 10             	add    $0x10,%esp
80106f74:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f77:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f7d:	5b                   	pop    %ebx
80106f7e:	5e                   	pop    %esi
80106f7f:	5f                   	pop    %edi
80106f80:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f81:	e9 ea d9 ff ff       	jmp    80104970 <memmove>
    panic("inituvm: more than a page");
80106f86:	83 ec 0c             	sub    $0xc,%esp
80106f89:	68 94 7a 10 80       	push   $0x80107a94
80106f8e:	e8 ed 93 ff ff       	call   80100380 <panic>
80106f93:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f9a:	00 
80106f9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106fa0 <loaduvm>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	53                   	push   %ebx
80106fa6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106fa9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106fac:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106faf:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106fb5:	0f 85 a2 00 00 00    	jne    8010705d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106fbb:	85 ff                	test   %edi,%edi
80106fbd:	74 7d                	je     8010703c <loaduvm+0x9c>
80106fbf:	90                   	nop
  pde = &pgdir[PDX(va)];
80106fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106fc3:	8b 55 08             	mov    0x8(%ebp),%edx
80106fc6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106fc8:	89 c1                	mov    %eax,%ecx
80106fca:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106fcd:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106fd0:	f6 c1 01             	test   $0x1,%cl
80106fd3:	75 13                	jne    80106fe8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106fd5:	83 ec 0c             	sub    $0xc,%esp
80106fd8:	68 ae 7a 10 80       	push   $0x80107aae
80106fdd:	e8 9e 93 ff ff       	call   80100380 <panic>
80106fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106fe8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106feb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106ff1:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ff6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ffd:	85 c9                	test   %ecx,%ecx
80106fff:	74 d4                	je     80106fd5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80107001:	89 fb                	mov    %edi,%ebx
80107003:	b8 00 10 00 00       	mov    $0x1000,%eax
80107008:	29 f3                	sub    %esi,%ebx
8010700a:	39 c3                	cmp    %eax,%ebx
8010700c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010700f:	53                   	push   %ebx
80107010:	8b 45 14             	mov    0x14(%ebp),%eax
80107013:	01 f0                	add    %esi,%eax
80107015:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80107016:	8b 01                	mov    (%ecx),%eax
80107018:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010701d:	05 00 00 00 80       	add    $0x80000000,%eax
80107022:	50                   	push   %eax
80107023:	ff 75 10             	push   0x10(%ebp)
80107026:	e8 85 aa ff ff       	call   80101ab0 <readi>
8010702b:	83 c4 10             	add    $0x10,%esp
8010702e:	39 d8                	cmp    %ebx,%eax
80107030:	75 1e                	jne    80107050 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107032:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107038:	39 fe                	cmp    %edi,%esi
8010703a:	72 84                	jb     80106fc0 <loaduvm+0x20>
}
8010703c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010703f:	31 c0                	xor    %eax,%eax
}
80107041:	5b                   	pop    %ebx
80107042:	5e                   	pop    %esi
80107043:	5f                   	pop    %edi
80107044:	5d                   	pop    %ebp
80107045:	c3                   	ret
80107046:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010704d:	00 
8010704e:	66 90                	xchg   %ax,%ax
80107050:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107053:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107058:	5b                   	pop    %ebx
80107059:	5e                   	pop    %esi
8010705a:	5f                   	pop    %edi
8010705b:	5d                   	pop    %ebp
8010705c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010705d:	83 ec 0c             	sub    $0xc,%esp
80107060:	68 d0 7c 10 80       	push   $0x80107cd0
80107065:	e8 16 93 ff ff       	call   80100380 <panic>
8010706a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107070 <allocuvm>:
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	83 ec 1c             	sub    $0x1c,%esp
80107079:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010707c:	85 f6                	test   %esi,%esi
8010707e:	0f 88 98 00 00 00    	js     8010711c <allocuvm+0xac>
80107084:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107086:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107089:	0f 82 a1 00 00 00    	jb     80107130 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010708f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107092:	05 ff 0f 00 00       	add    $0xfff,%eax
80107097:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010709c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010709e:	39 f0                	cmp    %esi,%eax
801070a0:	0f 83 8d 00 00 00    	jae    80107133 <allocuvm+0xc3>
801070a6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801070a9:	eb 44                	jmp    801070ef <allocuvm+0x7f>
801070ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801070b0:	83 ec 04             	sub    $0x4,%esp
801070b3:	68 00 10 00 00       	push   $0x1000
801070b8:	6a 00                	push   $0x0
801070ba:	50                   	push   %eax
801070bb:	e8 20 d8 ff ff       	call   801048e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801070c0:	58                   	pop    %eax
801070c1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070c7:	5a                   	pop    %edx
801070c8:	6a 06                	push   $0x6
801070ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070cf:	89 fa                	mov    %edi,%edx
801070d1:	50                   	push   %eax
801070d2:	8b 45 08             	mov    0x8(%ebp),%eax
801070d5:	e8 a6 fb ff ff       	call   80106c80 <mappages>
801070da:	83 c4 10             	add    $0x10,%esp
801070dd:	85 c0                	test   %eax,%eax
801070df:	78 5f                	js     80107140 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
801070e1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801070e7:	39 f7                	cmp    %esi,%edi
801070e9:	0f 83 89 00 00 00    	jae    80107178 <allocuvm+0x108>
    mem = kalloc();
801070ef:	e8 6c b5 ff ff       	call   80102660 <kalloc>
801070f4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801070f6:	85 c0                	test   %eax,%eax
801070f8:	75 b6                	jne    801070b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801070fa:	83 ec 0c             	sub    $0xc,%esp
801070fd:	68 cc 7a 10 80       	push   $0x80107acc
80107102:	e8 a9 95 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107107:	83 c4 10             	add    $0x10,%esp
8010710a:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010710d:	74 0d                	je     8010711c <allocuvm+0xac>
8010710f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107112:	8b 45 08             	mov    0x8(%ebp),%eax
80107115:	89 f2                	mov    %esi,%edx
80107117:	e8 a4 fa ff ff       	call   80106bc0 <deallocuvm.part.0>
    return 0;
8010711c:	31 d2                	xor    %edx,%edx
}
8010711e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107121:	89 d0                	mov    %edx,%eax
80107123:	5b                   	pop    %ebx
80107124:	5e                   	pop    %esi
80107125:	5f                   	pop    %edi
80107126:	5d                   	pop    %ebp
80107127:	c3                   	ret
80107128:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010712f:	00 
    return oldsz;
80107130:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80107133:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107136:	89 d0                	mov    %edx,%eax
80107138:	5b                   	pop    %ebx
80107139:	5e                   	pop    %esi
8010713a:	5f                   	pop    %edi
8010713b:	5d                   	pop    %ebp
8010713c:	c3                   	ret
8010713d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107140:	83 ec 0c             	sub    $0xc,%esp
80107143:	68 e4 7a 10 80       	push   $0x80107ae4
80107148:	e8 63 95 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
8010714d:	83 c4 10             	add    $0x10,%esp
80107150:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107153:	74 0d                	je     80107162 <allocuvm+0xf2>
80107155:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107158:	8b 45 08             	mov    0x8(%ebp),%eax
8010715b:	89 f2                	mov    %esi,%edx
8010715d:	e8 5e fa ff ff       	call   80106bc0 <deallocuvm.part.0>
      kfree(mem);
80107162:	83 ec 0c             	sub    $0xc,%esp
80107165:	53                   	push   %ebx
80107166:	e8 35 b3 ff ff       	call   801024a0 <kfree>
      return 0;
8010716b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010716e:	31 d2                	xor    %edx,%edx
80107170:	eb ac                	jmp    8010711e <allocuvm+0xae>
80107172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107178:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010717b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010717e:	5b                   	pop    %ebx
8010717f:	5e                   	pop    %esi
80107180:	89 d0                	mov    %edx,%eax
80107182:	5f                   	pop    %edi
80107183:	5d                   	pop    %ebp
80107184:	c3                   	ret
80107185:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010718c:	00 
8010718d:	8d 76 00             	lea    0x0(%esi),%esi

80107190 <deallocuvm>:
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	8b 55 0c             	mov    0xc(%ebp),%edx
80107196:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107199:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010719c:	39 d1                	cmp    %edx,%ecx
8010719e:	73 10                	jae    801071b0 <deallocuvm+0x20>
}
801071a0:	5d                   	pop    %ebp
801071a1:	e9 1a fa ff ff       	jmp    80106bc0 <deallocuvm.part.0>
801071a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071ad:	00 
801071ae:	66 90                	xchg   %ax,%ax
801071b0:	89 d0                	mov    %edx,%eax
801071b2:	5d                   	pop    %ebp
801071b3:	c3                   	ret
801071b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071bb:	00 
801071bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801071c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	53                   	push   %ebx
801071c6:	83 ec 0c             	sub    $0xc,%esp
801071c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801071cc:	85 f6                	test   %esi,%esi
801071ce:	74 59                	je     80107229 <freevm+0x69>
  if(newsz >= oldsz)
801071d0:	31 c9                	xor    %ecx,%ecx
801071d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071d7:	89 f0                	mov    %esi,%eax
801071d9:	89 f3                	mov    %esi,%ebx
801071db:	e8 e0 f9 ff ff       	call   80106bc0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801071e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071e6:	eb 0f                	jmp    801071f7 <freevm+0x37>
801071e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071ef:	00 
801071f0:	83 c3 04             	add    $0x4,%ebx
801071f3:	39 fb                	cmp    %edi,%ebx
801071f5:	74 23                	je     8010721a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801071f7:	8b 03                	mov    (%ebx),%eax
801071f9:	a8 01                	test   $0x1,%al
801071fb:	74 f3                	je     801071f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107202:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107205:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107208:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010720d:	50                   	push   %eax
8010720e:	e8 8d b2 ff ff       	call   801024a0 <kfree>
80107213:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107216:	39 fb                	cmp    %edi,%ebx
80107218:	75 dd                	jne    801071f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010721a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010721d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107220:	5b                   	pop    %ebx
80107221:	5e                   	pop    %esi
80107222:	5f                   	pop    %edi
80107223:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107224:	e9 77 b2 ff ff       	jmp    801024a0 <kfree>
    panic("freevm: no pgdir");
80107229:	83 ec 0c             	sub    $0xc,%esp
8010722c:	68 00 7b 10 80       	push   $0x80107b00
80107231:	e8 4a 91 ff ff       	call   80100380 <panic>
80107236:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010723d:	00 
8010723e:	66 90                	xchg   %ax,%ax

80107240 <setupkvm>:
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	56                   	push   %esi
80107244:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107245:	e8 16 b4 ff ff       	call   80102660 <kalloc>
8010724a:	85 c0                	test   %eax,%eax
8010724c:	74 5e                	je     801072ac <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010724e:	83 ec 04             	sub    $0x4,%esp
80107251:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107253:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107258:	68 00 10 00 00       	push   $0x1000
8010725d:	6a 00                	push   $0x0
8010725f:	50                   	push   %eax
80107260:	e8 7b d6 ff ff       	call   801048e0 <memset>
80107265:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107268:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010726b:	83 ec 08             	sub    $0x8,%esp
8010726e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107271:	8b 13                	mov    (%ebx),%edx
80107273:	ff 73 0c             	push   0xc(%ebx)
80107276:	50                   	push   %eax
80107277:	29 c1                	sub    %eax,%ecx
80107279:	89 f0                	mov    %esi,%eax
8010727b:	e8 00 fa ff ff       	call   80106c80 <mappages>
80107280:	83 c4 10             	add    $0x10,%esp
80107283:	85 c0                	test   %eax,%eax
80107285:	78 19                	js     801072a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107287:	83 c3 10             	add    $0x10,%ebx
8010728a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107290:	75 d6                	jne    80107268 <setupkvm+0x28>
}
80107292:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107295:	89 f0                	mov    %esi,%eax
80107297:	5b                   	pop    %ebx
80107298:	5e                   	pop    %esi
80107299:	5d                   	pop    %ebp
8010729a:	c3                   	ret
8010729b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801072a0:	83 ec 0c             	sub    $0xc,%esp
801072a3:	56                   	push   %esi
801072a4:	e8 17 ff ff ff       	call   801071c0 <freevm>
      return 0;
801072a9:	83 c4 10             	add    $0x10,%esp
}
801072ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801072af:	31 f6                	xor    %esi,%esi
}
801072b1:	89 f0                	mov    %esi,%eax
801072b3:	5b                   	pop    %ebx
801072b4:	5e                   	pop    %esi
801072b5:	5d                   	pop    %ebp
801072b6:	c3                   	ret
801072b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072be:	00 
801072bf:	90                   	nop

801072c0 <kvmalloc>:
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801072c6:	e8 75 ff ff ff       	call   80107240 <setupkvm>
801072cb:	a3 c4 d5 11 80       	mov    %eax,0x8011d5c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072d0:	05 00 00 00 80       	add    $0x80000000,%eax
801072d5:	0f 22 d8             	mov    %eax,%cr3
}
801072d8:	c9                   	leave
801072d9:	c3                   	ret
801072da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	83 ec 08             	sub    $0x8,%esp
801072e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801072e9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801072ec:	89 c1                	mov    %eax,%ecx
801072ee:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801072f1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801072f4:	f6 c2 01             	test   $0x1,%dl
801072f7:	75 17                	jne    80107310 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801072f9:	83 ec 0c             	sub    $0xc,%esp
801072fc:	68 11 7b 10 80       	push   $0x80107b11
80107301:	e8 7a 90 ff ff       	call   80100380 <panic>
80107306:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010730d:	00 
8010730e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107310:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107313:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107319:	25 fc 0f 00 00       	and    $0xffc,%eax
8010731e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107325:	85 c0                	test   %eax,%eax
80107327:	74 d0                	je     801072f9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107329:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010732c:	c9                   	leave
8010732d:	c3                   	ret
8010732e:	66 90                	xchg   %ax,%ax

80107330 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107339:	e8 02 ff ff ff       	call   80107240 <setupkvm>
8010733e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107341:	85 c0                	test   %eax,%eax
80107343:	0f 84 e9 00 00 00    	je     80107432 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107349:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010734c:	85 c9                	test   %ecx,%ecx
8010734e:	0f 84 b2 00 00 00    	je     80107406 <copyuvm+0xd6>
80107354:	31 f6                	xor    %esi,%esi
80107356:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010735d:	00 
8010735e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107360:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107363:	89 f0                	mov    %esi,%eax
80107365:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107368:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010736b:	a8 01                	test   $0x1,%al
8010736d:	75 11                	jne    80107380 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010736f:	83 ec 0c             	sub    $0xc,%esp
80107372:	68 1b 7b 10 80       	push   $0x80107b1b
80107377:	e8 04 90 ff ff       	call   80100380 <panic>
8010737c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107380:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107382:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107387:	c1 ea 0a             	shr    $0xa,%edx
8010738a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107390:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107397:	85 c0                	test   %eax,%eax
80107399:	74 d4                	je     8010736f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010739b:	8b 00                	mov    (%eax),%eax
8010739d:	a8 01                	test   $0x1,%al
8010739f:	0f 84 9f 00 00 00    	je     80107444 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801073a5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801073a7:	25 ff 0f 00 00       	and    $0xfff,%eax
801073ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801073af:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801073b5:	e8 a6 b2 ff ff       	call   80102660 <kalloc>
801073ba:	89 c3                	mov    %eax,%ebx
801073bc:	85 c0                	test   %eax,%eax
801073be:	74 64                	je     80107424 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801073c0:	83 ec 04             	sub    $0x4,%esp
801073c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801073c9:	68 00 10 00 00       	push   $0x1000
801073ce:	57                   	push   %edi
801073cf:	50                   	push   %eax
801073d0:	e8 9b d5 ff ff       	call   80104970 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801073d5:	58                   	pop    %eax
801073d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073dc:	5a                   	pop    %edx
801073dd:	ff 75 e4             	push   -0x1c(%ebp)
801073e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073e5:	89 f2                	mov    %esi,%edx
801073e7:	50                   	push   %eax
801073e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073eb:	e8 90 f8 ff ff       	call   80106c80 <mappages>
801073f0:	83 c4 10             	add    $0x10,%esp
801073f3:	85 c0                	test   %eax,%eax
801073f5:	78 21                	js     80107418 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801073f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073fd:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107400:	0f 82 5a ff ff ff    	jb     80107360 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107406:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107409:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010740c:	5b                   	pop    %ebx
8010740d:	5e                   	pop    %esi
8010740e:	5f                   	pop    %edi
8010740f:	5d                   	pop    %ebp
80107410:	c3                   	ret
80107411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107418:	83 ec 0c             	sub    $0xc,%esp
8010741b:	53                   	push   %ebx
8010741c:	e8 7f b0 ff ff       	call   801024a0 <kfree>
      goto bad;
80107421:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107424:	83 ec 0c             	sub    $0xc,%esp
80107427:	ff 75 e0             	push   -0x20(%ebp)
8010742a:	e8 91 fd ff ff       	call   801071c0 <freevm>
  return 0;
8010742f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107432:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107439:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010743c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010743f:	5b                   	pop    %ebx
80107440:	5e                   	pop    %esi
80107441:	5f                   	pop    %edi
80107442:	5d                   	pop    %ebp
80107443:	c3                   	ret
      panic("copyuvm: page not present");
80107444:	83 ec 0c             	sub    $0xc,%esp
80107447:	68 35 7b 10 80       	push   $0x80107b35
8010744c:	e8 2f 8f ff ff       	call   80100380 <panic>
80107451:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107458:	00 
80107459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107460 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107466:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107469:	89 c1                	mov    %eax,%ecx
8010746b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010746e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107471:	f6 c2 01             	test   $0x1,%dl
80107474:	0f 84 f8 00 00 00    	je     80107572 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010747a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010747d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107483:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107484:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107489:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107490:	89 d0                	mov    %edx,%eax
80107492:	f7 d2                	not    %edx
80107494:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107499:	05 00 00 00 80       	add    $0x80000000,%eax
8010749e:	83 e2 05             	and    $0x5,%edx
801074a1:	ba 00 00 00 00       	mov    $0x0,%edx
801074a6:	0f 45 c2             	cmovne %edx,%eax
}
801074a9:	c3                   	ret
801074aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
801074b6:	83 ec 0c             	sub    $0xc,%esp
801074b9:	8b 75 14             	mov    0x14(%ebp),%esi
801074bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801074bf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801074c2:	85 f6                	test   %esi,%esi
801074c4:	75 51                	jne    80107517 <copyout+0x67>
801074c6:	e9 9d 00 00 00       	jmp    80107568 <copyout+0xb8>
801074cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
801074d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801074d6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801074dc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801074e2:	74 74                	je     80107558 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
801074e4:	89 fb                	mov    %edi,%ebx
801074e6:	29 c3                	sub    %eax,%ebx
801074e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801074ee:	39 f3                	cmp    %esi,%ebx
801074f0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801074f3:	29 f8                	sub    %edi,%eax
801074f5:	83 ec 04             	sub    $0x4,%esp
801074f8:	01 c1                	add    %eax,%ecx
801074fa:	53                   	push   %ebx
801074fb:	52                   	push   %edx
801074fc:	89 55 10             	mov    %edx,0x10(%ebp)
801074ff:	51                   	push   %ecx
80107500:	e8 6b d4 ff ff       	call   80104970 <memmove>
    len -= n;
    buf += n;
80107505:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107508:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010750e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107511:	01 da                	add    %ebx,%edx
  while(len > 0){
80107513:	29 de                	sub    %ebx,%esi
80107515:	74 51                	je     80107568 <copyout+0xb8>
  if(*pde & PTE_P){
80107517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010751a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010751c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010751e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107521:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107527:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010752a:	f6 c1 01             	test   $0x1,%cl
8010752d:	0f 84 46 00 00 00    	je     80107579 <copyout.cold>
  return &pgtab[PTX(va)];
80107533:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107535:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010753b:	c1 eb 0c             	shr    $0xc,%ebx
8010753e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107544:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010754b:	89 d9                	mov    %ebx,%ecx
8010754d:	f7 d1                	not    %ecx
8010754f:	83 e1 05             	and    $0x5,%ecx
80107552:	0f 84 78 ff ff ff    	je     801074d0 <copyout+0x20>
  }
  return 0;
}
80107558:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010755b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107560:	5b                   	pop    %ebx
80107561:	5e                   	pop    %esi
80107562:	5f                   	pop    %edi
80107563:	5d                   	pop    %ebp
80107564:	c3                   	ret
80107565:	8d 76 00             	lea    0x0(%esi),%esi
80107568:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010756b:	31 c0                	xor    %eax,%eax
}
8010756d:	5b                   	pop    %ebx
8010756e:	5e                   	pop    %esi
8010756f:	5f                   	pop    %edi
80107570:	5d                   	pop    %ebp
80107571:	c3                   	ret

80107572 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107572:	a1 00 00 00 00       	mov    0x0,%eax
80107577:	0f 0b                	ud2

80107579 <copyout.cold>:
80107579:	a1 00 00 00 00       	mov    0x0,%eax
8010757e:	0f 0b                	ud2
