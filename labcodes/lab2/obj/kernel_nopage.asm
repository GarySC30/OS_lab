
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 80 11 40       	mov    $0x40118000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 80 11 00       	mov    %eax,0x118000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	ba 28 af 11 00       	mov    $0x11af28,%edx
  100041:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  10005d:	e8 60 5e 00 00       	call   105ec2 <memset>

    cons_init();                // init the console
  100062:	e8 90 15 00 00       	call   1015f7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 60 60 10 00 	movl   $0x106060,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 7c 60 10 00 	movl   $0x10607c,(%esp)
  10007c:	e8 c7 02 00 00       	call   100348 <cprintf>

    print_kerninfo();
  100081:	e8 f6 07 00 00       	call   10087c <print_kerninfo>

    grade_backtrace();
  100086:	e8 86 00 00 00       	call   100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 9d 43 00 00       	call   10442d <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 cb 16 00 00       	call   101760 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 43 18 00 00       	call   1018dd <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 0e 0d 00 00       	call   100dad <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 2a 16 00 00       	call   1016ce <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	55                   	push   %ebp
  1000a7:	89 e5                	mov    %esp,%ebp
  1000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b3:	00 
  1000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bb:	00 
  1000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c3:	e8 06 0c 00 00       	call   100cce <mon_backtrace>
}
  1000c8:	c9                   	leave  
  1000c9:	c3                   	ret    

001000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000ca:	55                   	push   %ebp
  1000cb:	89 e5                	mov    %esp,%ebp
  1000cd:	53                   	push   %ebx
  1000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000d7:	8d 55 08             	lea    0x8(%ebp),%edx
  1000da:	8b 45 08             	mov    0x8(%ebp),%eax
  1000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000e9:	89 04 24             	mov    %eax,(%esp)
  1000ec:	e8 b5 ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000f1:	83 c4 14             	add    $0x14,%esp
  1000f4:	5b                   	pop    %ebx
  1000f5:	5d                   	pop    %ebp
  1000f6:	c3                   	ret    

001000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000f7:	55                   	push   %ebp
  1000f8:	89 e5                	mov    %esp,%ebp
  1000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000fd:	8b 45 10             	mov    0x10(%ebp),%eax
  100100:	89 44 24 04          	mov    %eax,0x4(%esp)
  100104:	8b 45 08             	mov    0x8(%ebp),%eax
  100107:	89 04 24             	mov    %eax,(%esp)
  10010a:	e8 bb ff ff ff       	call   1000ca <grade_backtrace1>
}
  10010f:	c9                   	leave  
  100110:	c3                   	ret    

00100111 <grade_backtrace>:

void
grade_backtrace(void) {
  100111:	55                   	push   %ebp
  100112:	89 e5                	mov    %esp,%ebp
  100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100117:	b8 36 00 10 00       	mov    $0x100036,%eax
  10011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100123:	ff 
  100124:	89 44 24 04          	mov    %eax,0x4(%esp)
  100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10012f:	e8 c3 ff ff ff       	call   1000f7 <grade_backtrace0>
}
  100134:	c9                   	leave  
  100135:	c3                   	ret    

00100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100136:	55                   	push   %ebp
  100137:	89 e5                	mov    %esp,%ebp
  100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10014c:	0f b7 c0             	movzwl %ax,%eax
  10014f:	83 e0 03             	and    $0x3,%eax
  100152:	89 c2                	mov    %eax,%edx
  100154:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100159:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100161:	c7 04 24 81 60 10 00 	movl   $0x106081,(%esp)
  100168:	e8 db 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100171:	0f b7 d0             	movzwl %ax,%edx
  100174:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100179:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100181:	c7 04 24 8f 60 10 00 	movl   $0x10608f,(%esp)
  100188:	e8 bb 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100191:	0f b7 d0             	movzwl %ax,%edx
  100194:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100199:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a1:	c7 04 24 9d 60 10 00 	movl   $0x10609d,(%esp)
  1001a8:	e8 9b 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b1:	0f b7 d0             	movzwl %ax,%edx
  1001b4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 ab 60 10 00 	movl   $0x1060ab,(%esp)
  1001c8:	e8 7b 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d1:	0f b7 d0             	movzwl %ax,%edx
  1001d4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e1:	c7 04 24 b9 60 10 00 	movl   $0x1060b9,(%esp)
  1001e8:	e8 5b 01 00 00       	call   100348 <cprintf>
    round ++;
  1001ed:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001f2:	83 c0 01             	add    $0x1,%eax
  1001f5:	a3 00 a0 11 00       	mov    %eax,0x11a000
}
  1001fa:	c9                   	leave  
  1001fb:	c3                   	ret    

001001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001ff:	5d                   	pop    %ebp
  100200:	c3                   	ret    

00100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100201:	55                   	push   %ebp
  100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  100204:	5d                   	pop    %ebp
  100205:	c3                   	ret    

00100206 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100206:	55                   	push   %ebp
  100207:	89 e5                	mov    %esp,%ebp
  100209:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10020c:	e8 25 ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100211:	c7 04 24 c8 60 10 00 	movl   $0x1060c8,(%esp)
  100218:	e8 2b 01 00 00       	call   100348 <cprintf>
    lab1_switch_to_user();
  10021d:	e8 da ff ff ff       	call   1001fc <lab1_switch_to_user>
    lab1_print_cur_status();
  100222:	e8 0f ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100227:	c7 04 24 e8 60 10 00 	movl   $0x1060e8,(%esp)
  10022e:	e8 15 01 00 00       	call   100348 <cprintf>
    lab1_switch_to_kernel();
  100233:	e8 c9 ff ff ff       	call   100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100238:	e8 f9 fe ff ff       	call   100136 <lab1_print_cur_status>
}
  10023d:	c9                   	leave  
  10023e:	c3                   	ret    

0010023f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10023f:	55                   	push   %ebp
  100240:	89 e5                	mov    %esp,%ebp
  100242:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100249:	74 13                	je     10025e <readline+0x1f>
        cprintf("%s", prompt);
  10024b:	8b 45 08             	mov    0x8(%ebp),%eax
  10024e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100252:	c7 04 24 07 61 10 00 	movl   $0x106107,(%esp)
  100259:	e8 ea 00 00 00       	call   100348 <cprintf>
    }
    int i = 0, c;
  10025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100265:	e8 66 01 00 00       	call   1003d0 <getchar>
  10026a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10026d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100271:	79 07                	jns    10027a <readline+0x3b>
            return NULL;
  100273:	b8 00 00 00 00       	mov    $0x0,%eax
  100278:	eb 79                	jmp    1002f3 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10027a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10027e:	7e 28                	jle    1002a8 <readline+0x69>
  100280:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100287:	7f 1f                	jg     1002a8 <readline+0x69>
            cputchar(c);
  100289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10028c:	89 04 24             	mov    %eax,(%esp)
  10028f:	e8 da 00 00 00       	call   10036e <cputchar>
            buf[i ++] = c;
  100294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100297:	8d 50 01             	lea    0x1(%eax),%edx
  10029a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10029d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002a0:	88 90 20 a0 11 00    	mov    %dl,0x11a020(%eax)
  1002a6:	eb 46                	jmp    1002ee <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  1002a8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002ac:	75 17                	jne    1002c5 <readline+0x86>
  1002ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002b2:	7e 11                	jle    1002c5 <readline+0x86>
            cputchar(c);
  1002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b7:	89 04 24             	mov    %eax,(%esp)
  1002ba:	e8 af 00 00 00       	call   10036e <cputchar>
            i --;
  1002bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002c3:	eb 29                	jmp    1002ee <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002c5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002c9:	74 06                	je     1002d1 <readline+0x92>
  1002cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002cf:	75 1d                	jne    1002ee <readline+0xaf>
            cputchar(c);
  1002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d4:	89 04 24             	mov    %eax,(%esp)
  1002d7:	e8 92 00 00 00       	call   10036e <cputchar>
            buf[i] = '\0';
  1002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002df:	05 20 a0 11 00       	add    $0x11a020,%eax
  1002e4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002e7:	b8 20 a0 11 00       	mov    $0x11a020,%eax
  1002ec:	eb 05                	jmp    1002f3 <readline+0xb4>
        }
    }
  1002ee:	e9 72 ff ff ff       	jmp    100265 <readline+0x26>
}
  1002f3:	c9                   	leave  
  1002f4:	c3                   	ret    

001002f5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f5:	55                   	push   %ebp
  1002f6:	89 e5                	mov    %esp,%ebp
  1002f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fe:	89 04 24             	mov    %eax,(%esp)
  100301:	e8 1d 13 00 00       	call   101623 <cons_putc>
    (*cnt) ++;
  100306:	8b 45 0c             	mov    0xc(%ebp),%eax
  100309:	8b 00                	mov    (%eax),%eax
  10030b:	8d 50 01             	lea    0x1(%eax),%edx
  10030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100311:	89 10                	mov    %edx,(%eax)
}
  100313:	c9                   	leave  
  100314:	c3                   	ret    

00100315 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100315:	55                   	push   %ebp
  100316:	89 e5                	mov    %esp,%ebp
  100318:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100322:	8b 45 0c             	mov    0xc(%ebp),%eax
  100325:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100329:	8b 45 08             	mov    0x8(%ebp),%eax
  10032c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100330:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100333:	89 44 24 04          	mov    %eax,0x4(%esp)
  100337:	c7 04 24 f5 02 10 00 	movl   $0x1002f5,(%esp)
  10033e:	e8 98 53 00 00       	call   1056db <vprintfmt>
    return cnt;
  100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100346:	c9                   	leave  
  100347:	c3                   	ret    

00100348 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10034e:	8d 45 0c             	lea    0xc(%ebp),%eax
  100351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100357:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035b:	8b 45 08             	mov    0x8(%ebp),%eax
  10035e:	89 04 24             	mov    %eax,(%esp)
  100361:	e8 af ff ff ff       	call   100315 <vcprintf>
  100366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100369:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036c:	c9                   	leave  
  10036d:	c3                   	ret    

0010036e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10036e:	55                   	push   %ebp
  10036f:	89 e5                	mov    %esp,%ebp
  100371:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100374:	8b 45 08             	mov    0x8(%ebp),%eax
  100377:	89 04 24             	mov    %eax,(%esp)
  10037a:	e8 a4 12 00 00       	call   101623 <cons_putc>
}
  10037f:	c9                   	leave  
  100380:	c3                   	ret    

00100381 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100381:	55                   	push   %ebp
  100382:	89 e5                	mov    %esp,%ebp
  100384:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10038e:	eb 13                	jmp    1003a3 <cputs+0x22>
        cputch(c, &cnt);
  100390:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100397:	89 54 24 04          	mov    %edx,0x4(%esp)
  10039b:	89 04 24             	mov    %eax,(%esp)
  10039e:	e8 52 ff ff ff       	call   1002f5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a6:	8d 50 01             	lea    0x1(%eax),%edx
  1003a9:	89 55 08             	mov    %edx,0x8(%ebp)
  1003ac:	0f b6 00             	movzbl (%eax),%eax
  1003af:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b6:	75 d8                	jne    100390 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003bf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003c6:	e8 2a ff ff ff       	call   1002f5 <cputch>
    return cnt;
  1003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ce:	c9                   	leave  
  1003cf:	c3                   	ret    

001003d0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003d0:	55                   	push   %ebp
  1003d1:	89 e5                	mov    %esp,%ebp
  1003d3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003d6:	e8 84 12 00 00       	call   10165f <cons_getc>
  1003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e2:	74 f2                	je     1003d6 <getchar+0x6>
        /* do nothing */;
    return c;
  1003e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003e7:	c9                   	leave  
  1003e8:	c3                   	ret    

001003e9 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003e9:	55                   	push   %ebp
  1003ea:	89 e5                	mov    %esp,%ebp
  1003ec:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f2:	8b 00                	mov    (%eax),%eax
  1003f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1003fa:	8b 00                	mov    (%eax),%eax
  1003fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100406:	e9 d2 00 00 00       	jmp    1004dd <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10040b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10040e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100411:	01 d0                	add    %edx,%eax
  100413:	89 c2                	mov    %eax,%edx
  100415:	c1 ea 1f             	shr    $0x1f,%edx
  100418:	01 d0                	add    %edx,%eax
  10041a:	d1 f8                	sar    %eax
  10041c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100422:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100425:	eb 04                	jmp    10042b <stab_binsearch+0x42>
            m --;
  100427:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100431:	7c 1f                	jl     100452 <stab_binsearch+0x69>
  100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100436:	89 d0                	mov    %edx,%eax
  100438:	01 c0                	add    %eax,%eax
  10043a:	01 d0                	add    %edx,%eax
  10043c:	c1 e0 02             	shl    $0x2,%eax
  10043f:	89 c2                	mov    %eax,%edx
  100441:	8b 45 08             	mov    0x8(%ebp),%eax
  100444:	01 d0                	add    %edx,%eax
  100446:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10044a:	0f b6 c0             	movzbl %al,%eax
  10044d:	3b 45 14             	cmp    0x14(%ebp),%eax
  100450:	75 d5                	jne    100427 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100455:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100458:	7d 0b                	jge    100465 <stab_binsearch+0x7c>
            l = true_m + 1;
  10045a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045d:	83 c0 01             	add    $0x1,%eax
  100460:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100463:	eb 78                	jmp    1004dd <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100465:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10046c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046f:	89 d0                	mov    %edx,%eax
  100471:	01 c0                	add    %eax,%eax
  100473:	01 d0                	add    %edx,%eax
  100475:	c1 e0 02             	shl    $0x2,%eax
  100478:	89 c2                	mov    %eax,%edx
  10047a:	8b 45 08             	mov    0x8(%ebp),%eax
  10047d:	01 d0                	add    %edx,%eax
  10047f:	8b 40 08             	mov    0x8(%eax),%eax
  100482:	3b 45 18             	cmp    0x18(%ebp),%eax
  100485:	73 13                	jae    10049a <stab_binsearch+0xb1>
            *region_left = m;
  100487:	8b 45 0c             	mov    0xc(%ebp),%eax
  10048a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10048f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100492:	83 c0 01             	add    $0x1,%eax
  100495:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100498:	eb 43                	jmp    1004dd <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10049a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049d:	89 d0                	mov    %edx,%eax
  10049f:	01 c0                	add    %eax,%eax
  1004a1:	01 d0                	add    %edx,%eax
  1004a3:	c1 e0 02             	shl    $0x2,%eax
  1004a6:	89 c2                	mov    %eax,%edx
  1004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ab:	01 d0                	add    %edx,%eax
  1004ad:	8b 40 08             	mov    0x8(%eax),%eax
  1004b0:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004b3:	76 16                	jbe    1004cb <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004be:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c3:	83 e8 01             	sub    $0x1,%eax
  1004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c9:	eb 12                	jmp    1004dd <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d1:	89 10                	mov    %edx,(%eax)
            l = m;
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004d9:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004e3:	0f 8e 22 ff ff ff    	jle    10040b <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004ed:	75 0f                	jne    1004fe <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f2:	8b 00                	mov    (%eax),%eax
  1004f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1004fa:	89 10                	mov    %edx,(%eax)
  1004fc:	eb 3f                	jmp    10053d <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004fe:	8b 45 10             	mov    0x10(%ebp),%eax
  100501:	8b 00                	mov    (%eax),%eax
  100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100506:	eb 04                	jmp    10050c <stab_binsearch+0x123>
  100508:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050f:	8b 00                	mov    (%eax),%eax
  100511:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100514:	7d 1f                	jge    100535 <stab_binsearch+0x14c>
  100516:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100519:	89 d0                	mov    %edx,%eax
  10051b:	01 c0                	add    %eax,%eax
  10051d:	01 d0                	add    %edx,%eax
  10051f:	c1 e0 02             	shl    $0x2,%eax
  100522:	89 c2                	mov    %eax,%edx
  100524:	8b 45 08             	mov    0x8(%ebp),%eax
  100527:	01 d0                	add    %edx,%eax
  100529:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10052d:	0f b6 c0             	movzbl %al,%eax
  100530:	3b 45 14             	cmp    0x14(%ebp),%eax
  100533:	75 d3                	jne    100508 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100535:	8b 45 0c             	mov    0xc(%ebp),%eax
  100538:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10053b:	89 10                	mov    %edx,(%eax)
    }
}
  10053d:	c9                   	leave  
  10053e:	c3                   	ret    

0010053f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10053f:	55                   	push   %ebp
  100540:	89 e5                	mov    %esp,%ebp
  100542:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100545:	8b 45 0c             	mov    0xc(%ebp),%eax
  100548:	c7 00 0c 61 10 00    	movl   $0x10610c,(%eax)
    info->eip_line = 0;
  10054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100558:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055b:	c7 40 08 0c 61 10 00 	movl   $0x10610c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100562:	8b 45 0c             	mov    0xc(%ebp),%eax
  100565:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056f:	8b 55 08             	mov    0x8(%ebp),%edx
  100572:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100575:	8b 45 0c             	mov    0xc(%ebp),%eax
  100578:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10057f:	c7 45 f4 d0 73 10 00 	movl   $0x1073d0,-0xc(%ebp)
    stab_end = __STAB_END__;
  100586:	c7 45 f0 e4 1f 11 00 	movl   $0x111fe4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10058d:	c7 45 ec e5 1f 11 00 	movl   $0x111fe5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100594:	c7 45 e8 1d 4a 11 00 	movl   $0x114a1d,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005a1:	76 0d                	jbe    1005b0 <debuginfo_eip+0x71>
  1005a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005a6:	83 e8 01             	sub    $0x1,%eax
  1005a9:	0f b6 00             	movzbl (%eax),%eax
  1005ac:	84 c0                	test   %al,%al
  1005ae:	74 0a                	je     1005ba <debuginfo_eip+0x7b>
        return -1;
  1005b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005b5:	e9 c0 02 00 00       	jmp    10087a <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c7:	29 c2                	sub    %eax,%edx
  1005c9:	89 d0                	mov    %edx,%eax
  1005cb:	c1 f8 02             	sar    $0x2,%eax
  1005ce:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005d4:	83 e8 01             	sub    $0x1,%eax
  1005d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005da:	8b 45 08             	mov    0x8(%ebp),%eax
  1005dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005e1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005e8:	00 
  1005e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005fa:	89 04 24             	mov    %eax,(%esp)
  1005fd:	e8 e7 fd ff ff       	call   1003e9 <stab_binsearch>
    if (lfile == 0)
  100602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100605:	85 c0                	test   %eax,%eax
  100607:	75 0a                	jne    100613 <debuginfo_eip+0xd4>
        return -1;
  100609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10060e:	e9 67 02 00 00       	jmp    10087a <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100616:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10061f:	8b 45 08             	mov    0x8(%ebp),%eax
  100622:	89 44 24 10          	mov    %eax,0x10(%esp)
  100626:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10062d:	00 
  10062e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100631:	89 44 24 08          	mov    %eax,0x8(%esp)
  100635:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100638:	89 44 24 04          	mov    %eax,0x4(%esp)
  10063c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063f:	89 04 24             	mov    %eax,(%esp)
  100642:	e8 a2 fd ff ff       	call   1003e9 <stab_binsearch>

    if (lfun <= rfun) {
  100647:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10064a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10064d:	39 c2                	cmp    %eax,%edx
  10064f:	7f 7c                	jg     1006cd <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100651:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100654:	89 c2                	mov    %eax,%edx
  100656:	89 d0                	mov    %edx,%eax
  100658:	01 c0                	add    %eax,%eax
  10065a:	01 d0                	add    %edx,%eax
  10065c:	c1 e0 02             	shl    $0x2,%eax
  10065f:	89 c2                	mov    %eax,%edx
  100661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100664:	01 d0                	add    %edx,%eax
  100666:	8b 10                	mov    (%eax),%edx
  100668:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066e:	29 c1                	sub    %eax,%ecx
  100670:	89 c8                	mov    %ecx,%eax
  100672:	39 c2                	cmp    %eax,%edx
  100674:	73 22                	jae    100698 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100676:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100679:	89 c2                	mov    %eax,%edx
  10067b:	89 d0                	mov    %edx,%eax
  10067d:	01 c0                	add    %eax,%eax
  10067f:	01 d0                	add    %edx,%eax
  100681:	c1 e0 02             	shl    $0x2,%eax
  100684:	89 c2                	mov    %eax,%edx
  100686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100689:	01 d0                	add    %edx,%eax
  10068b:	8b 10                	mov    (%eax),%edx
  10068d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100690:	01 c2                	add    %eax,%edx
  100692:	8b 45 0c             	mov    0xc(%ebp),%eax
  100695:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100698:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069b:	89 c2                	mov    %eax,%edx
  10069d:	89 d0                	mov    %edx,%eax
  10069f:	01 c0                	add    %eax,%eax
  1006a1:	01 d0                	add    %edx,%eax
  1006a3:	c1 e0 02             	shl    $0x2,%eax
  1006a6:	89 c2                	mov    %eax,%edx
  1006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ab:	01 d0                	add    %edx,%eax
  1006ad:	8b 50 08             	mov    0x8(%eax),%edx
  1006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b9:	8b 40 10             	mov    0x10(%eax),%eax
  1006bc:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006cb:	eb 15                	jmp    1006e2 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e5:	8b 40 08             	mov    0x8(%eax),%eax
  1006e8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006ef:	00 
  1006f0:	89 04 24             	mov    %eax,(%esp)
  1006f3:	e8 3e 56 00 00       	call   105d36 <strfind>
  1006f8:	89 c2                	mov    %eax,%edx
  1006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006fd:	8b 40 08             	mov    0x8(%eax),%eax
  100700:	29 c2                	sub    %eax,%edx
  100702:	8b 45 0c             	mov    0xc(%ebp),%eax
  100705:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100708:	8b 45 08             	mov    0x8(%ebp),%eax
  10070b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10070f:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100716:	00 
  100717:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10071a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100721:	89 44 24 04          	mov    %eax,0x4(%esp)
  100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100728:	89 04 24             	mov    %eax,(%esp)
  10072b:	e8 b9 fc ff ff       	call   1003e9 <stab_binsearch>
    if (lline <= rline) {
  100730:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100733:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100736:	39 c2                	cmp    %eax,%edx
  100738:	7f 24                	jg     10075e <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073d:	89 c2                	mov    %eax,%edx
  10073f:	89 d0                	mov    %edx,%eax
  100741:	01 c0                	add    %eax,%eax
  100743:	01 d0                	add    %edx,%eax
  100745:	c1 e0 02             	shl    $0x2,%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074d:	01 d0                	add    %edx,%eax
  10074f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100753:	0f b7 d0             	movzwl %ax,%edx
  100756:	8b 45 0c             	mov    0xc(%ebp),%eax
  100759:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10075c:	eb 13                	jmp    100771 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10075e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100763:	e9 12 01 00 00       	jmp    10087a <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076b:	83 e8 01             	sub    $0x1,%eax
  10076e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100777:	39 c2                	cmp    %eax,%edx
  100779:	7c 56                	jl     1007d1 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077e:	89 c2                	mov    %eax,%edx
  100780:	89 d0                	mov    %edx,%eax
  100782:	01 c0                	add    %eax,%eax
  100784:	01 d0                	add    %edx,%eax
  100786:	c1 e0 02             	shl    $0x2,%eax
  100789:	89 c2                	mov    %eax,%edx
  10078b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10078e:	01 d0                	add    %edx,%eax
  100790:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100794:	3c 84                	cmp    $0x84,%al
  100796:	74 39                	je     1007d1 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079b:	89 c2                	mov    %eax,%edx
  10079d:	89 d0                	mov    %edx,%eax
  10079f:	01 c0                	add    %eax,%eax
  1007a1:	01 d0                	add    %edx,%eax
  1007a3:	c1 e0 02             	shl    $0x2,%eax
  1007a6:	89 c2                	mov    %eax,%edx
  1007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ab:	01 d0                	add    %edx,%eax
  1007ad:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b1:	3c 64                	cmp    $0x64,%al
  1007b3:	75 b3                	jne    100768 <debuginfo_eip+0x229>
  1007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	89 d0                	mov    %edx,%eax
  1007bc:	01 c0                	add    %eax,%eax
  1007be:	01 d0                	add    %edx,%eax
  1007c0:	c1 e0 02             	shl    $0x2,%eax
  1007c3:	89 c2                	mov    %eax,%edx
  1007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c8:	01 d0                	add    %edx,%eax
  1007ca:	8b 40 08             	mov    0x8(%eax),%eax
  1007cd:	85 c0                	test   %eax,%eax
  1007cf:	74 97                	je     100768 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d7:	39 c2                	cmp    %eax,%edx
  1007d9:	7c 46                	jl     100821 <debuginfo_eip+0x2e2>
  1007db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007de:	89 c2                	mov    %eax,%edx
  1007e0:	89 d0                	mov    %edx,%eax
  1007e2:	01 c0                	add    %eax,%eax
  1007e4:	01 d0                	add    %edx,%eax
  1007e6:	c1 e0 02             	shl    $0x2,%eax
  1007e9:	89 c2                	mov    %eax,%edx
  1007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ee:	01 d0                	add    %edx,%eax
  1007f0:	8b 10                	mov    (%eax),%edx
  1007f2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f8:	29 c1                	sub    %eax,%ecx
  1007fa:	89 c8                	mov    %ecx,%eax
  1007fc:	39 c2                	cmp    %eax,%edx
  1007fe:	73 21                	jae    100821 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	89 d0                	mov    %edx,%eax
  100807:	01 c0                	add    %eax,%eax
  100809:	01 d0                	add    %edx,%eax
  10080b:	c1 e0 02             	shl    $0x2,%eax
  10080e:	89 c2                	mov    %eax,%edx
  100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	8b 10                	mov    (%eax),%edx
  100817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10081a:	01 c2                	add    %eax,%edx
  10081c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100821:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100824:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100827:	39 c2                	cmp    %eax,%edx
  100829:	7d 4a                	jge    100875 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10082b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10082e:	83 c0 01             	add    $0x1,%eax
  100831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100834:	eb 18                	jmp    10084e <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100836:	8b 45 0c             	mov    0xc(%ebp),%eax
  100839:	8b 40 14             	mov    0x14(%eax),%eax
  10083c:	8d 50 01             	lea    0x1(%eax),%edx
  10083f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100842:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100848:	83 c0 01             	add    $0x1,%eax
  10084b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100851:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100854:	39 c2                	cmp    %eax,%edx
  100856:	7d 1d                	jge    100875 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	89 d0                	mov    %edx,%eax
  10085f:	01 c0                	add    %eax,%eax
  100861:	01 d0                	add    %edx,%eax
  100863:	c1 e0 02             	shl    $0x2,%eax
  100866:	89 c2                	mov    %eax,%edx
  100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086b:	01 d0                	add    %edx,%eax
  10086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100871:	3c a0                	cmp    $0xa0,%al
  100873:	74 c1                	je     100836 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10087a:	c9                   	leave  
  10087b:	c3                   	ret    

0010087c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10087c:	55                   	push   %ebp
  10087d:	89 e5                	mov    %esp,%ebp
  10087f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100882:	c7 04 24 16 61 10 00 	movl   $0x106116,(%esp)
  100889:	e8 ba fa ff ff       	call   100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088e:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100895:	00 
  100896:	c7 04 24 2f 61 10 00 	movl   $0x10612f,(%esp)
  10089d:	e8 a6 fa ff ff       	call   100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008a2:	c7 44 24 04 4b 60 10 	movl   $0x10604b,0x4(%esp)
  1008a9:	00 
  1008aa:	c7 04 24 47 61 10 00 	movl   $0x106147,(%esp)
  1008b1:	e8 92 fa ff ff       	call   100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b6:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008bd:	00 
  1008be:	c7 04 24 5f 61 10 00 	movl   $0x10615f,(%esp)
  1008c5:	e8 7e fa ff ff       	call   100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008ca:	c7 44 24 04 28 af 11 	movl   $0x11af28,0x4(%esp)
  1008d1:	00 
  1008d2:	c7 04 24 77 61 10 00 	movl   $0x106177,(%esp)
  1008d9:	e8 6a fa ff ff       	call   100348 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008de:	b8 28 af 11 00       	mov    $0x11af28,%eax
  1008e3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008e9:	b8 36 00 10 00       	mov    $0x100036,%eax
  1008ee:	29 c2                	sub    %eax,%edx
  1008f0:	89 d0                	mov    %edx,%eax
  1008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f8:	85 c0                	test   %eax,%eax
  1008fa:	0f 48 c2             	cmovs  %edx,%eax
  1008fd:	c1 f8 0a             	sar    $0xa,%eax
  100900:	89 44 24 04          	mov    %eax,0x4(%esp)
  100904:	c7 04 24 90 61 10 00 	movl   $0x106190,(%esp)
  10090b:	e8 38 fa ff ff       	call   100348 <cprintf>
}
  100910:	c9                   	leave  
  100911:	c3                   	ret    

00100912 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100912:	55                   	push   %ebp
  100913:	89 e5                	mov    %esp,%ebp
  100915:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10091b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10091e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100922:	8b 45 08             	mov    0x8(%ebp),%eax
  100925:	89 04 24             	mov    %eax,(%esp)
  100928:	e8 12 fc ff ff       	call   10053f <debuginfo_eip>
  10092d:	85 c0                	test   %eax,%eax
  10092f:	74 15                	je     100946 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100931:	8b 45 08             	mov    0x8(%ebp),%eax
  100934:	89 44 24 04          	mov    %eax,0x4(%esp)
  100938:	c7 04 24 ba 61 10 00 	movl   $0x1061ba,(%esp)
  10093f:	e8 04 fa ff ff       	call   100348 <cprintf>
  100944:	eb 6d                	jmp    1009b3 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10094d:	eb 1c                	jmp    10096b <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  10094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100955:	01 d0                	add    %edx,%eax
  100957:	0f b6 00             	movzbl (%eax),%eax
  10095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100963:	01 ca                	add    %ecx,%edx
  100965:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100971:	7f dc                	jg     10094f <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10097c:	01 d0                	add    %edx,%eax
  10097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100984:	8b 55 08             	mov    0x8(%ebp),%edx
  100987:	89 d1                	mov    %edx,%ecx
  100989:	29 c1                	sub    %eax,%ecx
  10098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10099f:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a7:	c7 04 24 d6 61 10 00 	movl   $0x1061d6,(%esp)
  1009ae:	e8 95 f9 ff ff       	call   100348 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009b3:	c9                   	leave  
  1009b4:	c3                   	ret    

001009b5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b5:	55                   	push   %ebp
  1009b6:	89 e5                	mov    %esp,%ebp
  1009b8:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009bb:	8b 45 04             	mov    0x4(%ebp),%eax
  1009be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c4:	c9                   	leave  
  1009c5:	c3                   	ret    

001009c6 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009c6:	55                   	push   %ebp
  1009c7:	89 e5                	mov    %esp,%ebp
  1009c9:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009cc:	89 e8                	mov    %ebp,%eax
  1009ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	// 读取当前栈帧的ebp和eip
	uint32_t ebp = read_ebp();
  1009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
   	uint32_t eip = read_eip();
  1009d7:	e8 d9 ff ff ff       	call   1009b5 <read_eip>
  1009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32_t i = 0, j = 0;
  1009df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009e6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  1009ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009f4:	e9 88 00 00 00       	jmp    100a81 <print_stackframe+0xbb>
	{
        // 读取
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a07:	c7 04 24 e8 61 10 00 	movl   $0x1061e8,(%esp)
  100a0e:	e8 35 f9 ff ff       	call   100348 <cprintf>
        uint32_t* args = (uint32_t*)ebp + 2 ;
  100a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a16:	83 c0 08             	add    $0x8,%eax
  100a19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for(j = 0; j < 4; j++)
  100a1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a23:	eb 25                	jmp    100a4a <print_stackframe+0x84>
            cprintf("0x%08x ", args[j]);
  100a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a32:	01 d0                	add    %edx,%eax
  100a34:	8b 00                	mov    (%eax),%eax
  100a36:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3a:	c7 04 24 04 62 10 00 	movl   $0x106204,(%esp)
  100a41:	e8 02 f9 ff ff       	call   100348 <cprintf>
    	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
	{
        // 读取
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t* args = (uint32_t*)ebp + 2 ;
        for(j = 0; j < 4; j++)
  100a46:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a4a:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a4e:	76 d5                	jbe    100a25 <print_stackframe+0x5f>
            cprintf("0x%08x ", args[j]);
        cprintf("\n");
  100a50:	c7 04 24 0c 62 10 00 	movl   $0x10620c,(%esp)
  100a57:	e8 ec f8 ff ff       	call   100348 <cprintf>
        // eip指向异常指令的下一条指令，所以要减1
        print_debuginfo(eip-1);
  100a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a5f:	83 e8 01             	sub    $0x1,%eax
  100a62:	89 04 24             	mov    %eax,(%esp)
  100a65:	e8 a8 fe ff ff       	call   100912 <print_debuginfo>
        // 将ebp 和eip设置为上一个栈帧的ebp和eip
        //  注意要先设置eip后设置ebp，否则当ebp被修改后，eip就无法找到正确的位置
        eip = *((uint32_t*)ebp + 1);
  100a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a6d:	83 c0 04             	add    $0x4,%eax
  100a70:	8b 00                	mov    (%eax),%eax
  100a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *(uint32_t*)ebp;
  100a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a78:	8b 00                	mov    (%eax),%eax
  100a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */
	// 读取当前栈帧的ebp和eip
	uint32_t ebp = read_ebp();
   	uint32_t eip = read_eip();
	uint32_t i = 0, j = 0;
    	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  100a7d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a85:	74 0a                	je     100a91 <print_stackframe+0xcb>
  100a87:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a8b:	0f 86 68 ff ff ff    	jbe    1009f9 <print_stackframe+0x33>
        // 将ebp 和eip设置为上一个栈帧的ebp和eip
        //  注意要先设置eip后设置ebp，否则当ebp被修改后，eip就无法找到正确的位置
        eip = *((uint32_t*)ebp + 1);
        ebp = *(uint32_t*)ebp;
    }
}
  100a91:	c9                   	leave  
  100a92:	c3                   	ret    

00100a93 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a93:	55                   	push   %ebp
  100a94:	89 e5                	mov    %esp,%ebp
  100a96:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aa0:	eb 0c                	jmp    100aae <parse+0x1b>
            *buf ++ = '\0';
  100aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa5:	8d 50 01             	lea    0x1(%eax),%edx
  100aa8:	89 55 08             	mov    %edx,0x8(%ebp)
  100aab:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aae:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab1:	0f b6 00             	movzbl (%eax),%eax
  100ab4:	84 c0                	test   %al,%al
  100ab6:	74 1d                	je     100ad5 <parse+0x42>
  100ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  100abb:	0f b6 00             	movzbl (%eax),%eax
  100abe:	0f be c0             	movsbl %al,%eax
  100ac1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ac5:	c7 04 24 90 62 10 00 	movl   $0x106290,(%esp)
  100acc:	e8 32 52 00 00       	call   105d03 <strchr>
  100ad1:	85 c0                	test   %eax,%eax
  100ad3:	75 cd                	jne    100aa2 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad8:	0f b6 00             	movzbl (%eax),%eax
  100adb:	84 c0                	test   %al,%al
  100add:	75 02                	jne    100ae1 <parse+0x4e>
            break;
  100adf:	eb 67                	jmp    100b48 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ae1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ae5:	75 14                	jne    100afb <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ae7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aee:	00 
  100aef:	c7 04 24 95 62 10 00 	movl   $0x106295,(%esp)
  100af6:	e8 4d f8 ff ff       	call   100348 <cprintf>
        }
        argv[argc ++] = buf;
  100afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100afe:	8d 50 01             	lea    0x1(%eax),%edx
  100b01:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b0e:	01 c2                	add    %eax,%edx
  100b10:	8b 45 08             	mov    0x8(%ebp),%eax
  100b13:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b15:	eb 04                	jmp    100b1b <parse+0x88>
            buf ++;
  100b17:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1e:	0f b6 00             	movzbl (%eax),%eax
  100b21:	84 c0                	test   %al,%al
  100b23:	74 1d                	je     100b42 <parse+0xaf>
  100b25:	8b 45 08             	mov    0x8(%ebp),%eax
  100b28:	0f b6 00             	movzbl (%eax),%eax
  100b2b:	0f be c0             	movsbl %al,%eax
  100b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b32:	c7 04 24 90 62 10 00 	movl   $0x106290,(%esp)
  100b39:	e8 c5 51 00 00       	call   105d03 <strchr>
  100b3e:	85 c0                	test   %eax,%eax
  100b40:	74 d5                	je     100b17 <parse+0x84>
            buf ++;
        }
    }
  100b42:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b43:	e9 66 ff ff ff       	jmp    100aae <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b4b:	c9                   	leave  
  100b4c:	c3                   	ret    

00100b4d <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b4d:	55                   	push   %ebp
  100b4e:	89 e5                	mov    %esp,%ebp
  100b50:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b53:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b56:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b5d:	89 04 24             	mov    %eax,(%esp)
  100b60:	e8 2e ff ff ff       	call   100a93 <parse>
  100b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b6c:	75 0a                	jne    100b78 <runcmd+0x2b>
        return 0;
  100b6e:	b8 00 00 00 00       	mov    $0x0,%eax
  100b73:	e9 85 00 00 00       	jmp    100bfd <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b7f:	eb 5c                	jmp    100bdd <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b81:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b87:	89 d0                	mov    %edx,%eax
  100b89:	01 c0                	add    %eax,%eax
  100b8b:	01 d0                	add    %edx,%eax
  100b8d:	c1 e0 02             	shl    $0x2,%eax
  100b90:	05 00 70 11 00       	add    $0x117000,%eax
  100b95:	8b 00                	mov    (%eax),%eax
  100b97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b9b:	89 04 24             	mov    %eax,(%esp)
  100b9e:	e8 c1 50 00 00       	call   105c64 <strcmp>
  100ba3:	85 c0                	test   %eax,%eax
  100ba5:	75 32                	jne    100bd9 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100ba7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100baa:	89 d0                	mov    %edx,%eax
  100bac:	01 c0                	add    %eax,%eax
  100bae:	01 d0                	add    %edx,%eax
  100bb0:	c1 e0 02             	shl    $0x2,%eax
  100bb3:	05 00 70 11 00       	add    $0x117000,%eax
  100bb8:	8b 40 08             	mov    0x8(%eax),%eax
  100bbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bbe:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bc4:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bc8:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bcb:	83 c2 04             	add    $0x4,%edx
  100bce:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bd2:	89 0c 24             	mov    %ecx,(%esp)
  100bd5:	ff d0                	call   *%eax
  100bd7:	eb 24                	jmp    100bfd <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100be0:	83 f8 02             	cmp    $0x2,%eax
  100be3:	76 9c                	jbe    100b81 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100be5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bec:	c7 04 24 b3 62 10 00 	movl   $0x1062b3,(%esp)
  100bf3:	e8 50 f7 ff ff       	call   100348 <cprintf>
    return 0;
  100bf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bfd:	c9                   	leave  
  100bfe:	c3                   	ret    

00100bff <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bff:	55                   	push   %ebp
  100c00:	89 e5                	mov    %esp,%ebp
  100c02:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c05:	c7 04 24 cc 62 10 00 	movl   $0x1062cc,(%esp)
  100c0c:	e8 37 f7 ff ff       	call   100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c11:	c7 04 24 f4 62 10 00 	movl   $0x1062f4,(%esp)
  100c18:	e8 2b f7 ff ff       	call   100348 <cprintf>

    if (tf != NULL) {
  100c1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c21:	74 0b                	je     100c2e <kmonitor+0x2f>
        print_trapframe(tf);
  100c23:	8b 45 08             	mov    0x8(%ebp),%eax
  100c26:	89 04 24             	mov    %eax,(%esp)
  100c29:	e8 67 0e 00 00       	call   101a95 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c2e:	c7 04 24 19 63 10 00 	movl   $0x106319,(%esp)
  100c35:	e8 05 f6 ff ff       	call   10023f <readline>
  100c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c41:	74 18                	je     100c5b <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c43:	8b 45 08             	mov    0x8(%ebp),%eax
  100c46:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c4d:	89 04 24             	mov    %eax,(%esp)
  100c50:	e8 f8 fe ff ff       	call   100b4d <runcmd>
  100c55:	85 c0                	test   %eax,%eax
  100c57:	79 02                	jns    100c5b <kmonitor+0x5c>
                break;
  100c59:	eb 02                	jmp    100c5d <kmonitor+0x5e>
            }
        }
    }
  100c5b:	eb d1                	jmp    100c2e <kmonitor+0x2f>
}
  100c5d:	c9                   	leave  
  100c5e:	c3                   	ret    

00100c5f <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c5f:	55                   	push   %ebp
  100c60:	89 e5                	mov    %esp,%ebp
  100c62:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c6c:	eb 3f                	jmp    100cad <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c71:	89 d0                	mov    %edx,%eax
  100c73:	01 c0                	add    %eax,%eax
  100c75:	01 d0                	add    %edx,%eax
  100c77:	c1 e0 02             	shl    $0x2,%eax
  100c7a:	05 00 70 11 00       	add    $0x117000,%eax
  100c7f:	8b 48 04             	mov    0x4(%eax),%ecx
  100c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c85:	89 d0                	mov    %edx,%eax
  100c87:	01 c0                	add    %eax,%eax
  100c89:	01 d0                	add    %edx,%eax
  100c8b:	c1 e0 02             	shl    $0x2,%eax
  100c8e:	05 00 70 11 00       	add    $0x117000,%eax
  100c93:	8b 00                	mov    (%eax),%eax
  100c95:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c9d:	c7 04 24 1d 63 10 00 	movl   $0x10631d,(%esp)
  100ca4:	e8 9f f6 ff ff       	call   100348 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ca9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cb0:	83 f8 02             	cmp    $0x2,%eax
  100cb3:	76 b9                	jbe    100c6e <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cba:	c9                   	leave  
  100cbb:	c3                   	ret    

00100cbc <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cbc:	55                   	push   %ebp
  100cbd:	89 e5                	mov    %esp,%ebp
  100cbf:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cc2:	e8 b5 fb ff ff       	call   10087c <print_kerninfo>
    return 0;
  100cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccc:	c9                   	leave  
  100ccd:	c3                   	ret    

00100cce <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cce:	55                   	push   %ebp
  100ccf:	89 e5                	mov    %esp,%ebp
  100cd1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cd4:	e8 ed fc ff ff       	call   1009c6 <print_stackframe>
    return 0;
  100cd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cde:	c9                   	leave  
  100cdf:	c3                   	ret    

00100ce0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ce0:	55                   	push   %ebp
  100ce1:	89 e5                	mov    %esp,%ebp
  100ce3:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ce6:	a1 20 a4 11 00       	mov    0x11a420,%eax
  100ceb:	85 c0                	test   %eax,%eax
  100ced:	74 02                	je     100cf1 <__panic+0x11>
        goto panic_dead;
  100cef:	eb 59                	jmp    100d4a <__panic+0x6a>
    }
    is_panic = 1;
  100cf1:	c7 05 20 a4 11 00 01 	movl   $0x1,0x11a420
  100cf8:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cfb:	8d 45 14             	lea    0x14(%ebp),%eax
  100cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d04:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d08:	8b 45 08             	mov    0x8(%ebp),%eax
  100d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d0f:	c7 04 24 26 63 10 00 	movl   $0x106326,(%esp)
  100d16:	e8 2d f6 ff ff       	call   100348 <cprintf>
    vcprintf(fmt, ap);
  100d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d22:	8b 45 10             	mov    0x10(%ebp),%eax
  100d25:	89 04 24             	mov    %eax,(%esp)
  100d28:	e8 e8 f5 ff ff       	call   100315 <vcprintf>
    cprintf("\n");
  100d2d:	c7 04 24 42 63 10 00 	movl   $0x106342,(%esp)
  100d34:	e8 0f f6 ff ff       	call   100348 <cprintf>
    
    cprintf("stack trackback:\n");
  100d39:	c7 04 24 44 63 10 00 	movl   $0x106344,(%esp)
  100d40:	e8 03 f6 ff ff       	call   100348 <cprintf>
    print_stackframe();
  100d45:	e8 7c fc ff ff       	call   1009c6 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d4a:	e8 85 09 00 00       	call   1016d4 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d56:	e8 a4 fe ff ff       	call   100bff <kmonitor>
    }
  100d5b:	eb f2                	jmp    100d4f <__panic+0x6f>

00100d5d <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d5d:	55                   	push   %ebp
  100d5e:	89 e5                	mov    %esp,%ebp
  100d60:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d63:	8d 45 14             	lea    0x14(%ebp),%eax
  100d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d70:	8b 45 08             	mov    0x8(%ebp),%eax
  100d73:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d77:	c7 04 24 56 63 10 00 	movl   $0x106356,(%esp)
  100d7e:	e8 c5 f5 ff ff       	call   100348 <cprintf>
    vcprintf(fmt, ap);
  100d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d86:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d8a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d8d:	89 04 24             	mov    %eax,(%esp)
  100d90:	e8 80 f5 ff ff       	call   100315 <vcprintf>
    cprintf("\n");
  100d95:	c7 04 24 42 63 10 00 	movl   $0x106342,(%esp)
  100d9c:	e8 a7 f5 ff ff       	call   100348 <cprintf>
    va_end(ap);
}
  100da1:	c9                   	leave  
  100da2:	c3                   	ret    

00100da3 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100da3:	55                   	push   %ebp
  100da4:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100da6:	a1 20 a4 11 00       	mov    0x11a420,%eax
}
  100dab:	5d                   	pop    %ebp
  100dac:	c3                   	ret    

00100dad <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dad:	55                   	push   %ebp
  100dae:	89 e5                	mov    %esp,%ebp
  100db0:	83 ec 28             	sub    $0x28,%esp
  100db3:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100db9:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dbd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dc1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dc5:	ee                   	out    %al,(%dx)
  100dc6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dcc:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dd0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dd4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dd8:	ee                   	out    %al,(%dx)
  100dd9:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100ddf:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100de3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100de7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100deb:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dec:	c7 05 0c af 11 00 00 	movl   $0x0,0x11af0c
  100df3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100df6:	c7 04 24 74 63 10 00 	movl   $0x106374,(%esp)
  100dfd:	e8 46 f5 ff ff       	call   100348 <cprintf>
    pic_enable(IRQ_TIMER);
  100e02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e09:	e8 24 09 00 00       	call   101732 <pic_enable>
}
  100e0e:	c9                   	leave  
  100e0f:	c3                   	ret    

00100e10 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e10:	55                   	push   %ebp
  100e11:	89 e5                	mov    %esp,%ebp
  100e13:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e16:	9c                   	pushf  
  100e17:	58                   	pop    %eax
  100e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e1e:	25 00 02 00 00       	and    $0x200,%eax
  100e23:	85 c0                	test   %eax,%eax
  100e25:	74 0c                	je     100e33 <__intr_save+0x23>
        intr_disable();
  100e27:	e8 a8 08 00 00       	call   1016d4 <intr_disable>
        return 1;
  100e2c:	b8 01 00 00 00       	mov    $0x1,%eax
  100e31:	eb 05                	jmp    100e38 <__intr_save+0x28>
    }
    return 0;
  100e33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e38:	c9                   	leave  
  100e39:	c3                   	ret    

00100e3a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e3a:	55                   	push   %ebp
  100e3b:	89 e5                	mov    %esp,%ebp
  100e3d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e44:	74 05                	je     100e4b <__intr_restore+0x11>
        intr_enable();
  100e46:	e8 83 08 00 00       	call   1016ce <intr_enable>
    }
}
  100e4b:	c9                   	leave  
  100e4c:	c3                   	ret    

00100e4d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e4d:	55                   	push   %ebp
  100e4e:	89 e5                	mov    %esp,%ebp
  100e50:	83 ec 10             	sub    $0x10,%esp
  100e53:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e59:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e5d:	89 c2                	mov    %eax,%edx
  100e5f:	ec                   	in     (%dx),%al
  100e60:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e63:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e69:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e6d:	89 c2                	mov    %eax,%edx
  100e6f:	ec                   	in     (%dx),%al
  100e70:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e73:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e79:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e7d:	89 c2                	mov    %eax,%edx
  100e7f:	ec                   	in     (%dx),%al
  100e80:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e83:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e89:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e8d:	89 c2                	mov    %eax,%edx
  100e8f:	ec                   	in     (%dx),%al
  100e90:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e93:	c9                   	leave  
  100e94:	c3                   	ret    

00100e95 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e95:	55                   	push   %ebp
  100e96:	89 e5                	mov    %esp,%ebp
  100e98:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e9b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea5:	0f b7 00             	movzwl (%eax),%eax
  100ea8:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaf:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb7:	0f b7 00             	movzwl (%eax),%eax
  100eba:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100ebe:	74 12                	je     100ed2 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ec0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ec7:	66 c7 05 46 a4 11 00 	movw   $0x3b4,0x11a446
  100ece:	b4 03 
  100ed0:	eb 13                	jmp    100ee5 <cga_init+0x50>
    } else {
        *cp = was;
  100ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ed9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100edc:	66 c7 05 46 a4 11 00 	movw   $0x3d4,0x11a446
  100ee3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ee5:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100eec:	0f b7 c0             	movzwl %ax,%eax
  100eef:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ef3:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ef7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100efb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100eff:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100f00:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f07:	83 c0 01             	add    $0x1,%eax
  100f0a:	0f b7 c0             	movzwl %ax,%eax
  100f0d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f11:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f15:	89 c2                	mov    %eax,%edx
  100f17:	ec                   	in     (%dx),%al
  100f18:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f1b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f1f:	0f b6 c0             	movzbl %al,%eax
  100f22:	c1 e0 08             	shl    $0x8,%eax
  100f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f28:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f2f:	0f b7 c0             	movzwl %ax,%eax
  100f32:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f36:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f3a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f3e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f42:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f43:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f4a:	83 c0 01             	add    $0x1,%eax
  100f4d:	0f b7 c0             	movzwl %ax,%eax
  100f50:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f54:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f58:	89 c2                	mov    %eax,%edx
  100f5a:	ec                   	in     (%dx),%al
  100f5b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f5e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f62:	0f b6 c0             	movzbl %al,%eax
  100f65:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f6b:	a3 40 a4 11 00       	mov    %eax,0x11a440
    crt_pos = pos;
  100f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f73:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
}
  100f79:	c9                   	leave  
  100f7a:	c3                   	ret    

00100f7b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f7b:	55                   	push   %ebp
  100f7c:	89 e5                	mov    %esp,%ebp
  100f7e:	83 ec 48             	sub    $0x48,%esp
  100f81:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f87:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f8b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f8f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f93:	ee                   	out    %al,(%dx)
  100f94:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f9a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f9e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fa2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100fa6:	ee                   	out    %al,(%dx)
  100fa7:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100fad:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100fb1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fb5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fb9:	ee                   	out    %al,(%dx)
  100fba:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fc0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fc4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fc8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fcc:	ee                   	out    %al,(%dx)
  100fcd:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fd3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fd7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fdb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fdf:	ee                   	out    %al,(%dx)
  100fe0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fe6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fea:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fee:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100ff2:	ee                   	out    %al,(%dx)
  100ff3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100ff9:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100ffd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101001:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101005:	ee                   	out    %al,(%dx)
  101006:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10100c:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  101010:	89 c2                	mov    %eax,%edx
  101012:	ec                   	in     (%dx),%al
  101013:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  101016:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10101a:	3c ff                	cmp    $0xff,%al
  10101c:	0f 95 c0             	setne  %al
  10101f:	0f b6 c0             	movzbl %al,%eax
  101022:	a3 48 a4 11 00       	mov    %eax,0x11a448
  101027:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10102d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101031:	89 c2                	mov    %eax,%edx
  101033:	ec                   	in     (%dx),%al
  101034:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101037:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  10103d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101041:	89 c2                	mov    %eax,%edx
  101043:	ec                   	in     (%dx),%al
  101044:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101047:	a1 48 a4 11 00       	mov    0x11a448,%eax
  10104c:	85 c0                	test   %eax,%eax
  10104e:	74 0c                	je     10105c <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101050:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101057:	e8 d6 06 00 00       	call   101732 <pic_enable>
    }
}
  10105c:	c9                   	leave  
  10105d:	c3                   	ret    

0010105e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10105e:	55                   	push   %ebp
  10105f:	89 e5                	mov    %esp,%ebp
  101061:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10106b:	eb 09                	jmp    101076 <lpt_putc_sub+0x18>
        delay();
  10106d:	e8 db fd ff ff       	call   100e4d <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101072:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101076:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10107c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101080:	89 c2                	mov    %eax,%edx
  101082:	ec                   	in     (%dx),%al
  101083:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101086:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10108a:	84 c0                	test   %al,%al
  10108c:	78 09                	js     101097 <lpt_putc_sub+0x39>
  10108e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101095:	7e d6                	jle    10106d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101097:	8b 45 08             	mov    0x8(%ebp),%eax
  10109a:	0f b6 c0             	movzbl %al,%eax
  10109d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  1010a3:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010a6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010aa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010ae:	ee                   	out    %al,(%dx)
  1010af:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010b5:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1010b9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010bd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010c1:	ee                   	out    %al,(%dx)
  1010c2:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010c8:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010cc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010d0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010d4:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010d5:	c9                   	leave  
  1010d6:	c3                   	ret    

001010d7 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010d7:	55                   	push   %ebp
  1010d8:	89 e5                	mov    %esp,%ebp
  1010da:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010dd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010e1:	74 0d                	je     1010f0 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e6:	89 04 24             	mov    %eax,(%esp)
  1010e9:	e8 70 ff ff ff       	call   10105e <lpt_putc_sub>
  1010ee:	eb 24                	jmp    101114 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010f0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010f7:	e8 62 ff ff ff       	call   10105e <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010fc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101103:	e8 56 ff ff ff       	call   10105e <lpt_putc_sub>
        lpt_putc_sub('\b');
  101108:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10110f:	e8 4a ff ff ff       	call   10105e <lpt_putc_sub>
    }
}
  101114:	c9                   	leave  
  101115:	c3                   	ret    

00101116 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101116:	55                   	push   %ebp
  101117:	89 e5                	mov    %esp,%ebp
  101119:	53                   	push   %ebx
  10111a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10111d:	8b 45 08             	mov    0x8(%ebp),%eax
  101120:	b0 00                	mov    $0x0,%al
  101122:	85 c0                	test   %eax,%eax
  101124:	75 07                	jne    10112d <cga_putc+0x17>
        c |= 0x0700;
  101126:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10112d:	8b 45 08             	mov    0x8(%ebp),%eax
  101130:	0f b6 c0             	movzbl %al,%eax
  101133:	83 f8 0a             	cmp    $0xa,%eax
  101136:	74 4c                	je     101184 <cga_putc+0x6e>
  101138:	83 f8 0d             	cmp    $0xd,%eax
  10113b:	74 57                	je     101194 <cga_putc+0x7e>
  10113d:	83 f8 08             	cmp    $0x8,%eax
  101140:	0f 85 88 00 00 00    	jne    1011ce <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101146:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10114d:	66 85 c0             	test   %ax,%ax
  101150:	74 30                	je     101182 <cga_putc+0x6c>
            crt_pos --;
  101152:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101159:	83 e8 01             	sub    $0x1,%eax
  10115c:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101162:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101167:	0f b7 15 44 a4 11 00 	movzwl 0x11a444,%edx
  10116e:	0f b7 d2             	movzwl %dx,%edx
  101171:	01 d2                	add    %edx,%edx
  101173:	01 c2                	add    %eax,%edx
  101175:	8b 45 08             	mov    0x8(%ebp),%eax
  101178:	b0 00                	mov    $0x0,%al
  10117a:	83 c8 20             	or     $0x20,%eax
  10117d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101180:	eb 72                	jmp    1011f4 <cga_putc+0xde>
  101182:	eb 70                	jmp    1011f4 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101184:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10118b:	83 c0 50             	add    $0x50,%eax
  10118e:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101194:	0f b7 1d 44 a4 11 00 	movzwl 0x11a444,%ebx
  10119b:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  1011a2:	0f b7 c1             	movzwl %cx,%eax
  1011a5:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1011ab:	c1 e8 10             	shr    $0x10,%eax
  1011ae:	89 c2                	mov    %eax,%edx
  1011b0:	66 c1 ea 06          	shr    $0x6,%dx
  1011b4:	89 d0                	mov    %edx,%eax
  1011b6:	c1 e0 02             	shl    $0x2,%eax
  1011b9:	01 d0                	add    %edx,%eax
  1011bb:	c1 e0 04             	shl    $0x4,%eax
  1011be:	29 c1                	sub    %eax,%ecx
  1011c0:	89 ca                	mov    %ecx,%edx
  1011c2:	89 d8                	mov    %ebx,%eax
  1011c4:	29 d0                	sub    %edx,%eax
  1011c6:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
        break;
  1011cc:	eb 26                	jmp    1011f4 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011ce:	8b 0d 40 a4 11 00    	mov    0x11a440,%ecx
  1011d4:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011db:	8d 50 01             	lea    0x1(%eax),%edx
  1011de:	66 89 15 44 a4 11 00 	mov    %dx,0x11a444
  1011e5:	0f b7 c0             	movzwl %ax,%eax
  1011e8:	01 c0                	add    %eax,%eax
  1011ea:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1011f0:	66 89 02             	mov    %ax,(%edx)
        break;
  1011f3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011f4:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011fb:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011ff:	76 5b                	jbe    10125c <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101201:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101206:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10120c:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101211:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101218:	00 
  101219:	89 54 24 04          	mov    %edx,0x4(%esp)
  10121d:	89 04 24             	mov    %eax,(%esp)
  101220:	e8 dc 4c 00 00       	call   105f01 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101225:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10122c:	eb 15                	jmp    101243 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10122e:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101233:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101236:	01 d2                	add    %edx,%edx
  101238:	01 d0                	add    %edx,%eax
  10123a:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10123f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101243:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10124a:	7e e2                	jle    10122e <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10124c:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101253:	83 e8 50             	sub    $0x50,%eax
  101256:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10125c:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  101263:	0f b7 c0             	movzwl %ax,%eax
  101266:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10126a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10126e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101272:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101276:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101277:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10127e:	66 c1 e8 08          	shr    $0x8,%ax
  101282:	0f b6 c0             	movzbl %al,%eax
  101285:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  10128c:	83 c2 01             	add    $0x1,%edx
  10128f:	0f b7 d2             	movzwl %dx,%edx
  101292:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101296:	88 45 ed             	mov    %al,-0x13(%ebp)
  101299:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10129d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012a1:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1012a2:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  1012a9:	0f b7 c0             	movzwl %ax,%eax
  1012ac:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1012b0:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1012b4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012b8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012bc:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012bd:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1012c4:	0f b6 c0             	movzbl %al,%eax
  1012c7:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  1012ce:	83 c2 01             	add    $0x1,%edx
  1012d1:	0f b7 d2             	movzwl %dx,%edx
  1012d4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012d8:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012db:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012df:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012e3:	ee                   	out    %al,(%dx)
}
  1012e4:	83 c4 34             	add    $0x34,%esp
  1012e7:	5b                   	pop    %ebx
  1012e8:	5d                   	pop    %ebp
  1012e9:	c3                   	ret    

001012ea <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012ea:	55                   	push   %ebp
  1012eb:	89 e5                	mov    %esp,%ebp
  1012ed:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012f7:	eb 09                	jmp    101302 <serial_putc_sub+0x18>
        delay();
  1012f9:	e8 4f fb ff ff       	call   100e4d <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101302:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101308:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10130c:	89 c2                	mov    %eax,%edx
  10130e:	ec                   	in     (%dx),%al
  10130f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101312:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101316:	0f b6 c0             	movzbl %al,%eax
  101319:	83 e0 20             	and    $0x20,%eax
  10131c:	85 c0                	test   %eax,%eax
  10131e:	75 09                	jne    101329 <serial_putc_sub+0x3f>
  101320:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101327:	7e d0                	jle    1012f9 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101329:	8b 45 08             	mov    0x8(%ebp),%eax
  10132c:	0f b6 c0             	movzbl %al,%eax
  10132f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101335:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101338:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10133c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101340:	ee                   	out    %al,(%dx)
}
  101341:	c9                   	leave  
  101342:	c3                   	ret    

00101343 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101343:	55                   	push   %ebp
  101344:	89 e5                	mov    %esp,%ebp
  101346:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101349:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10134d:	74 0d                	je     10135c <serial_putc+0x19>
        serial_putc_sub(c);
  10134f:	8b 45 08             	mov    0x8(%ebp),%eax
  101352:	89 04 24             	mov    %eax,(%esp)
  101355:	e8 90 ff ff ff       	call   1012ea <serial_putc_sub>
  10135a:	eb 24                	jmp    101380 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10135c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101363:	e8 82 ff ff ff       	call   1012ea <serial_putc_sub>
        serial_putc_sub(' ');
  101368:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10136f:	e8 76 ff ff ff       	call   1012ea <serial_putc_sub>
        serial_putc_sub('\b');
  101374:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10137b:	e8 6a ff ff ff       	call   1012ea <serial_putc_sub>
    }
}
  101380:	c9                   	leave  
  101381:	c3                   	ret    

00101382 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101382:	55                   	push   %ebp
  101383:	89 e5                	mov    %esp,%ebp
  101385:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101388:	eb 33                	jmp    1013bd <cons_intr+0x3b>
        if (c != 0) {
  10138a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10138e:	74 2d                	je     1013bd <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101390:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101395:	8d 50 01             	lea    0x1(%eax),%edx
  101398:	89 15 64 a6 11 00    	mov    %edx,0x11a664
  10139e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013a1:	88 90 60 a4 11 00    	mov    %dl,0x11a460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013a7:	a1 64 a6 11 00       	mov    0x11a664,%eax
  1013ac:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013b1:	75 0a                	jne    1013bd <cons_intr+0x3b>
                cons.wpos = 0;
  1013b3:	c7 05 64 a6 11 00 00 	movl   $0x0,0x11a664
  1013ba:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1013c0:	ff d0                	call   *%eax
  1013c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013c5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013c9:	75 bf                	jne    10138a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013cb:	c9                   	leave  
  1013cc:	c3                   	ret    

001013cd <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013cd:	55                   	push   %ebp
  1013ce:	89 e5                	mov    %esp,%ebp
  1013d0:	83 ec 10             	sub    $0x10,%esp
  1013d3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013dd:	89 c2                	mov    %eax,%edx
  1013df:	ec                   	in     (%dx),%al
  1013e0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013e3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013e7:	0f b6 c0             	movzbl %al,%eax
  1013ea:	83 e0 01             	and    $0x1,%eax
  1013ed:	85 c0                	test   %eax,%eax
  1013ef:	75 07                	jne    1013f8 <serial_proc_data+0x2b>
        return -1;
  1013f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013f6:	eb 2a                	jmp    101422 <serial_proc_data+0x55>
  1013f8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013fe:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101402:	89 c2                	mov    %eax,%edx
  101404:	ec                   	in     (%dx),%al
  101405:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101408:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10140c:	0f b6 c0             	movzbl %al,%eax
  10140f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101412:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101416:	75 07                	jne    10141f <serial_proc_data+0x52>
        c = '\b';
  101418:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10141f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101422:	c9                   	leave  
  101423:	c3                   	ret    

00101424 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101424:	55                   	push   %ebp
  101425:	89 e5                	mov    %esp,%ebp
  101427:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10142a:	a1 48 a4 11 00       	mov    0x11a448,%eax
  10142f:	85 c0                	test   %eax,%eax
  101431:	74 0c                	je     10143f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101433:	c7 04 24 cd 13 10 00 	movl   $0x1013cd,(%esp)
  10143a:	e8 43 ff ff ff       	call   101382 <cons_intr>
    }
}
  10143f:	c9                   	leave  
  101440:	c3                   	ret    

00101441 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101441:	55                   	push   %ebp
  101442:	89 e5                	mov    %esp,%ebp
  101444:	83 ec 38             	sub    $0x38,%esp
  101447:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101451:	89 c2                	mov    %eax,%edx
  101453:	ec                   	in     (%dx),%al
  101454:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101457:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10145b:	0f b6 c0             	movzbl %al,%eax
  10145e:	83 e0 01             	and    $0x1,%eax
  101461:	85 c0                	test   %eax,%eax
  101463:	75 0a                	jne    10146f <kbd_proc_data+0x2e>
        return -1;
  101465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10146a:	e9 59 01 00 00       	jmp    1015c8 <kbd_proc_data+0x187>
  10146f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101475:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101479:	89 c2                	mov    %eax,%edx
  10147b:	ec                   	in     (%dx),%al
  10147c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10147f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101483:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101486:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10148a:	75 17                	jne    1014a3 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10148c:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101491:	83 c8 40             	or     $0x40,%eax
  101494:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  101499:	b8 00 00 00 00       	mov    $0x0,%eax
  10149e:	e9 25 01 00 00       	jmp    1015c8 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a7:	84 c0                	test   %al,%al
  1014a9:	79 47                	jns    1014f2 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014ab:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014b0:	83 e0 40             	and    $0x40,%eax
  1014b3:	85 c0                	test   %eax,%eax
  1014b5:	75 09                	jne    1014c0 <kbd_proc_data+0x7f>
  1014b7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014bb:	83 e0 7f             	and    $0x7f,%eax
  1014be:	eb 04                	jmp    1014c4 <kbd_proc_data+0x83>
  1014c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014c7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014cb:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  1014d2:	83 c8 40             	or     $0x40,%eax
  1014d5:	0f b6 c0             	movzbl %al,%eax
  1014d8:	f7 d0                	not    %eax
  1014da:	89 c2                	mov    %eax,%edx
  1014dc:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014e1:	21 d0                	and    %edx,%eax
  1014e3:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1014e8:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ed:	e9 d6 00 00 00       	jmp    1015c8 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014f2:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014f7:	83 e0 40             	and    $0x40,%eax
  1014fa:	85 c0                	test   %eax,%eax
  1014fc:	74 11                	je     10150f <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014fe:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101502:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101507:	83 e0 bf             	and    $0xffffffbf,%eax
  10150a:	a3 68 a6 11 00       	mov    %eax,0x11a668
    }

    shift |= shiftcode[data];
  10150f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101513:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  10151a:	0f b6 d0             	movzbl %al,%edx
  10151d:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101522:	09 d0                	or     %edx,%eax
  101524:	a3 68 a6 11 00       	mov    %eax,0x11a668
    shift ^= togglecode[data];
  101529:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152d:	0f b6 80 40 71 11 00 	movzbl 0x117140(%eax),%eax
  101534:	0f b6 d0             	movzbl %al,%edx
  101537:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10153c:	31 d0                	xor    %edx,%eax
  10153e:	a3 68 a6 11 00       	mov    %eax,0x11a668

    c = charcode[shift & (CTL | SHIFT)][data];
  101543:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101548:	83 e0 03             	and    $0x3,%eax
  10154b:	8b 14 85 40 75 11 00 	mov    0x117540(,%eax,4),%edx
  101552:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101556:	01 d0                	add    %edx,%eax
  101558:	0f b6 00             	movzbl (%eax),%eax
  10155b:	0f b6 c0             	movzbl %al,%eax
  10155e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101561:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101566:	83 e0 08             	and    $0x8,%eax
  101569:	85 c0                	test   %eax,%eax
  10156b:	74 22                	je     10158f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10156d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101571:	7e 0c                	jle    10157f <kbd_proc_data+0x13e>
  101573:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101577:	7f 06                	jg     10157f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101579:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10157d:	eb 10                	jmp    10158f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10157f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101583:	7e 0a                	jle    10158f <kbd_proc_data+0x14e>
  101585:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101589:	7f 04                	jg     10158f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10158b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10158f:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101594:	f7 d0                	not    %eax
  101596:	83 e0 06             	and    $0x6,%eax
  101599:	85 c0                	test   %eax,%eax
  10159b:	75 28                	jne    1015c5 <kbd_proc_data+0x184>
  10159d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015a4:	75 1f                	jne    1015c5 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015a6:	c7 04 24 8f 63 10 00 	movl   $0x10638f,(%esp)
  1015ad:	e8 96 ed ff ff       	call   100348 <cprintf>
  1015b2:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015b8:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015bc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015c0:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015c4:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015c8:	c9                   	leave  
  1015c9:	c3                   	ret    

001015ca <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015ca:	55                   	push   %ebp
  1015cb:	89 e5                	mov    %esp,%ebp
  1015cd:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015d0:	c7 04 24 41 14 10 00 	movl   $0x101441,(%esp)
  1015d7:	e8 a6 fd ff ff       	call   101382 <cons_intr>
}
  1015dc:	c9                   	leave  
  1015dd:	c3                   	ret    

001015de <kbd_init>:

static void
kbd_init(void) {
  1015de:	55                   	push   %ebp
  1015df:	89 e5                	mov    %esp,%ebp
  1015e1:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015e4:	e8 e1 ff ff ff       	call   1015ca <kbd_intr>
    pic_enable(IRQ_KBD);
  1015e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015f0:	e8 3d 01 00 00       	call   101732 <pic_enable>
}
  1015f5:	c9                   	leave  
  1015f6:	c3                   	ret    

001015f7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015f7:	55                   	push   %ebp
  1015f8:	89 e5                	mov    %esp,%ebp
  1015fa:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015fd:	e8 93 f8 ff ff       	call   100e95 <cga_init>
    serial_init();
  101602:	e8 74 f9 ff ff       	call   100f7b <serial_init>
    kbd_init();
  101607:	e8 d2 ff ff ff       	call   1015de <kbd_init>
    if (!serial_exists) {
  10160c:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101611:	85 c0                	test   %eax,%eax
  101613:	75 0c                	jne    101621 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101615:	c7 04 24 9b 63 10 00 	movl   $0x10639b,(%esp)
  10161c:	e8 27 ed ff ff       	call   100348 <cprintf>
    }
}
  101621:	c9                   	leave  
  101622:	c3                   	ret    

00101623 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101623:	55                   	push   %ebp
  101624:	89 e5                	mov    %esp,%ebp
  101626:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101629:	e8 e2 f7 ff ff       	call   100e10 <__intr_save>
  10162e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101631:	8b 45 08             	mov    0x8(%ebp),%eax
  101634:	89 04 24             	mov    %eax,(%esp)
  101637:	e8 9b fa ff ff       	call   1010d7 <lpt_putc>
        cga_putc(c);
  10163c:	8b 45 08             	mov    0x8(%ebp),%eax
  10163f:	89 04 24             	mov    %eax,(%esp)
  101642:	e8 cf fa ff ff       	call   101116 <cga_putc>
        serial_putc(c);
  101647:	8b 45 08             	mov    0x8(%ebp),%eax
  10164a:	89 04 24             	mov    %eax,(%esp)
  10164d:	e8 f1 fc ff ff       	call   101343 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101655:	89 04 24             	mov    %eax,(%esp)
  101658:	e8 dd f7 ff ff       	call   100e3a <__intr_restore>
}
  10165d:	c9                   	leave  
  10165e:	c3                   	ret    

0010165f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10165f:	55                   	push   %ebp
  101660:	89 e5                	mov    %esp,%ebp
  101662:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101665:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10166c:	e8 9f f7 ff ff       	call   100e10 <__intr_save>
  101671:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101674:	e8 ab fd ff ff       	call   101424 <serial_intr>
        kbd_intr();
  101679:	e8 4c ff ff ff       	call   1015ca <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10167e:	8b 15 60 a6 11 00    	mov    0x11a660,%edx
  101684:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101689:	39 c2                	cmp    %eax,%edx
  10168b:	74 31                	je     1016be <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10168d:	a1 60 a6 11 00       	mov    0x11a660,%eax
  101692:	8d 50 01             	lea    0x1(%eax),%edx
  101695:	89 15 60 a6 11 00    	mov    %edx,0x11a660
  10169b:	0f b6 80 60 a4 11 00 	movzbl 0x11a460(%eax),%eax
  1016a2:	0f b6 c0             	movzbl %al,%eax
  1016a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1016a8:	a1 60 a6 11 00       	mov    0x11a660,%eax
  1016ad:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016b2:	75 0a                	jne    1016be <cons_getc+0x5f>
                cons.rpos = 0;
  1016b4:	c7 05 60 a6 11 00 00 	movl   $0x0,0x11a660
  1016bb:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016c1:	89 04 24             	mov    %eax,(%esp)
  1016c4:	e8 71 f7 ff ff       	call   100e3a <__intr_restore>
    return c;
  1016c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016cc:	c9                   	leave  
  1016cd:	c3                   	ret    

001016ce <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016ce:	55                   	push   %ebp
  1016cf:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016d1:	fb                   	sti    
    sti();
}
  1016d2:	5d                   	pop    %ebp
  1016d3:	c3                   	ret    

001016d4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016d4:	55                   	push   %ebp
  1016d5:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016d7:	fa                   	cli    
    cli();
}
  1016d8:	5d                   	pop    %ebp
  1016d9:	c3                   	ret    

001016da <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016da:	55                   	push   %ebp
  1016db:	89 e5                	mov    %esp,%ebp
  1016dd:	83 ec 14             	sub    $0x14,%esp
  1016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1016e3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016e7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016eb:	66 a3 50 75 11 00    	mov    %ax,0x117550
    if (did_init) {
  1016f1:	a1 6c a6 11 00       	mov    0x11a66c,%eax
  1016f6:	85 c0                	test   %eax,%eax
  1016f8:	74 36                	je     101730 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016fa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016fe:	0f b6 c0             	movzbl %al,%eax
  101701:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101707:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10170a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10170e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101712:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101713:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101717:	66 c1 e8 08          	shr    $0x8,%ax
  10171b:	0f b6 c0             	movzbl %al,%eax
  10171e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101724:	88 45 f9             	mov    %al,-0x7(%ebp)
  101727:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10172b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10172f:	ee                   	out    %al,(%dx)
    }
}
  101730:	c9                   	leave  
  101731:	c3                   	ret    

00101732 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101732:	55                   	push   %ebp
  101733:	89 e5                	mov    %esp,%ebp
  101735:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101738:	8b 45 08             	mov    0x8(%ebp),%eax
  10173b:	ba 01 00 00 00       	mov    $0x1,%edx
  101740:	89 c1                	mov    %eax,%ecx
  101742:	d3 e2                	shl    %cl,%edx
  101744:	89 d0                	mov    %edx,%eax
  101746:	f7 d0                	not    %eax
  101748:	89 c2                	mov    %eax,%edx
  10174a:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101751:	21 d0                	and    %edx,%eax
  101753:	0f b7 c0             	movzwl %ax,%eax
  101756:	89 04 24             	mov    %eax,(%esp)
  101759:	e8 7c ff ff ff       	call   1016da <pic_setmask>
}
  10175e:	c9                   	leave  
  10175f:	c3                   	ret    

00101760 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101760:	55                   	push   %ebp
  101761:	89 e5                	mov    %esp,%ebp
  101763:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101766:	c7 05 6c a6 11 00 01 	movl   $0x1,0x11a66c
  10176d:	00 00 00 
  101770:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101776:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10177a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10177e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101782:	ee                   	out    %al,(%dx)
  101783:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101789:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  10178d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101791:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101795:	ee                   	out    %al,(%dx)
  101796:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10179c:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1017a0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017a4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017a8:	ee                   	out    %al,(%dx)
  1017a9:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1017af:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1017b3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017b7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017bb:	ee                   	out    %al,(%dx)
  1017bc:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017c2:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017c6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017ca:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ce:	ee                   	out    %al,(%dx)
  1017cf:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017d5:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017d9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017dd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017e1:	ee                   	out    %al,(%dx)
  1017e2:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017e8:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017ec:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017f0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017f4:	ee                   	out    %al,(%dx)
  1017f5:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017fb:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017ff:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101803:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101807:	ee                   	out    %al,(%dx)
  101808:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10180e:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101812:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101816:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10181a:	ee                   	out    %al,(%dx)
  10181b:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101821:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101825:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101829:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10182d:	ee                   	out    %al,(%dx)
  10182e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101834:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101838:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10183c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101840:	ee                   	out    %al,(%dx)
  101841:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101847:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10184b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10184f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101853:	ee                   	out    %al,(%dx)
  101854:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10185a:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10185e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101862:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101866:	ee                   	out    %al,(%dx)
  101867:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10186d:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101871:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101875:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101879:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10187a:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101881:	66 83 f8 ff          	cmp    $0xffff,%ax
  101885:	74 12                	je     101899 <pic_init+0x139>
        pic_setmask(irq_mask);
  101887:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  10188e:	0f b7 c0             	movzwl %ax,%eax
  101891:	89 04 24             	mov    %eax,(%esp)
  101894:	e8 41 fe ff ff       	call   1016da <pic_setmask>
    }
}
  101899:	c9                   	leave  
  10189a:	c3                   	ret    

0010189b <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10189b:	55                   	push   %ebp
  10189c:	89 e5                	mov    %esp,%ebp
  10189e:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018a1:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018a8:	00 
  1018a9:	c7 04 24 c0 63 10 00 	movl   $0x1063c0,(%esp)
  1018b0:	e8 93 ea ff ff       	call   100348 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018b5:	c7 04 24 ca 63 10 00 	movl   $0x1063ca,(%esp)
  1018bc:	e8 87 ea ff ff       	call   100348 <cprintf>
    panic("EOT: kernel seems ok.");
  1018c1:	c7 44 24 08 d8 63 10 	movl   $0x1063d8,0x8(%esp)
  1018c8:	00 
  1018c9:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018d0:	00 
  1018d1:	c7 04 24 ee 63 10 00 	movl   $0x1063ee,(%esp)
  1018d8:	e8 03 f4 ff ff       	call   100ce0 <__panic>

001018dd <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018dd:	55                   	push   %ebp
  1018de:	89 e5                	mov    %esp,%ebp
  1018e0:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	// __vectors定义于vector.S中
	extern uintptr_t __vectors[];
  	int i;
  	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++)
  1018e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018ea:	e9 c3 00 00 00       	jmp    1019b2 <idt_init+0xd5>
      	// 目标idt项为idt[i]
      	// 该idt项为内核代码，所以使用GD_KTEXT段选择子
      	// 中断处理程序的入口地址存放于__vectors[i]
      	// 特权级为DPL_KERNEL
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f2:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1018f9:	89 c2                	mov    %eax,%edx
  1018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fe:	66 89 14 c5 80 a6 11 	mov    %dx,0x11a680(,%eax,8)
  101905:	00 
  101906:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101909:	66 c7 04 c5 82 a6 11 	movw   $0x8,0x11a682(,%eax,8)
  101910:	00 08 00 
  101913:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101916:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  10191d:	00 
  10191e:	83 e2 e0             	and    $0xffffffe0,%edx
  101921:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101928:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192b:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101932:	00 
  101933:	83 e2 1f             	and    $0x1f,%edx
  101936:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  10193d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101940:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101947:	00 
  101948:	83 e2 f0             	and    $0xfffffff0,%edx
  10194b:	83 ca 0e             	or     $0xe,%edx
  10194e:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101955:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101958:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10195f:	00 
  101960:	83 e2 ef             	and    $0xffffffef,%edx
  101963:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10196a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196d:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101974:	00 
  101975:	83 e2 9f             	and    $0xffffff9f,%edx
  101978:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10197f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101982:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101989:	00 
  10198a:	83 ca 80             	or     $0xffffff80,%edx
  10198d:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101994:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101997:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  10199e:	c1 e8 10             	shr    $0x10,%eax
  1019a1:	89 c2                	mov    %eax,%edx
  1019a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a6:	66 89 14 c5 86 a6 11 	mov    %dx,0x11a686(,%eax,8)
  1019ad:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	// __vectors定义于vector.S中
	extern uintptr_t __vectors[];
  	int i;
  	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++)
  1019ae:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  1019ba:	0f 86 2f ff ff ff    	jbe    1018ef <idt_init+0x12>
      	// 该idt项为内核代码，所以使用GD_KTEXT段选择子
      	// 中断处理程序的入口地址存放于__vectors[i]
      	// 特权级为DPL_KERNEL
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  	// 设置从用户态转为内核态的中断的特权级为DPL_USER
  	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019c0:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  1019c5:	66 a3 48 aa 11 00    	mov    %ax,0x11aa48
  1019cb:	66 c7 05 4a aa 11 00 	movw   $0x8,0x11aa4a
  1019d2:	08 00 
  1019d4:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  1019db:	83 e0 e0             	and    $0xffffffe0,%eax
  1019de:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  1019e3:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  1019ea:	83 e0 1f             	and    $0x1f,%eax
  1019ed:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  1019f2:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019f9:	83 e0 f0             	and    $0xfffffff0,%eax
  1019fc:	83 c8 0e             	or     $0xe,%eax
  1019ff:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a04:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a0b:	83 e0 ef             	and    $0xffffffef,%eax
  101a0e:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a13:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a1a:	83 c8 60             	or     $0x60,%eax
  101a1d:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a22:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a29:	83 c8 80             	or     $0xffffff80,%eax
  101a2c:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a31:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  101a36:	c1 e8 10             	shr    $0x10,%eax
  101a39:	66 a3 4e aa 11 00    	mov    %ax,0x11aa4e
  101a3f:	c7 45 f8 60 75 11 00 	movl   $0x117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a49:	0f 01 18             	lidtl  (%eax)
	// 加载该IDT
  	lidt(&idt_pd);
	
}
  101a4c:	c9                   	leave  
  101a4d:	c3                   	ret    

00101a4e <trapname>:

static const char *
trapname(int trapno) {
  101a4e:	55                   	push   %ebp
  101a4f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a51:	8b 45 08             	mov    0x8(%ebp),%eax
  101a54:	83 f8 13             	cmp    $0x13,%eax
  101a57:	77 0c                	ja     101a65 <trapname+0x17>
        return excnames[trapno];
  101a59:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5c:	8b 04 85 40 67 10 00 	mov    0x106740(,%eax,4),%eax
  101a63:	eb 18                	jmp    101a7d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a65:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a69:	7e 0d                	jle    101a78 <trapname+0x2a>
  101a6b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a6f:	7f 07                	jg     101a78 <trapname+0x2a>
        return "Hardware Interrupt";
  101a71:	b8 ff 63 10 00       	mov    $0x1063ff,%eax
  101a76:	eb 05                	jmp    101a7d <trapname+0x2f>
    }
    return "(unknown trap)";
  101a78:	b8 12 64 10 00       	mov    $0x106412,%eax
}
  101a7d:	5d                   	pop    %ebp
  101a7e:	c3                   	ret    

00101a7f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a7f:	55                   	push   %ebp
  101a80:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a82:	8b 45 08             	mov    0x8(%ebp),%eax
  101a85:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a89:	66 83 f8 08          	cmp    $0x8,%ax
  101a8d:	0f 94 c0             	sete   %al
  101a90:	0f b6 c0             	movzbl %al,%eax
}
  101a93:	5d                   	pop    %ebp
  101a94:	c3                   	ret    

00101a95 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a95:	55                   	push   %ebp
  101a96:	89 e5                	mov    %esp,%ebp
  101a98:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa2:	c7 04 24 53 64 10 00 	movl   $0x106453,(%esp)
  101aa9:	e8 9a e8 ff ff       	call   100348 <cprintf>
    print_regs(&tf->tf_regs);
  101aae:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab1:	89 04 24             	mov    %eax,(%esp)
  101ab4:	e8 a1 01 00 00       	call   101c5a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  101abc:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101ac0:	0f b7 c0             	movzwl %ax,%eax
  101ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac7:	c7 04 24 64 64 10 00 	movl   $0x106464,(%esp)
  101ace:	e8 75 e8 ff ff       	call   100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ada:	0f b7 c0             	movzwl %ax,%eax
  101add:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae1:	c7 04 24 77 64 10 00 	movl   $0x106477,(%esp)
  101ae8:	e8 5b e8 ff ff       	call   100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101aed:	8b 45 08             	mov    0x8(%ebp),%eax
  101af0:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101af4:	0f b7 c0             	movzwl %ax,%eax
  101af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101afb:	c7 04 24 8a 64 10 00 	movl   $0x10648a,(%esp)
  101b02:	e8 41 e8 ff ff       	call   100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b07:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b0e:	0f b7 c0             	movzwl %ax,%eax
  101b11:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b15:	c7 04 24 9d 64 10 00 	movl   $0x10649d,(%esp)
  101b1c:	e8 27 e8 ff ff       	call   100348 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b21:	8b 45 08             	mov    0x8(%ebp),%eax
  101b24:	8b 40 30             	mov    0x30(%eax),%eax
  101b27:	89 04 24             	mov    %eax,(%esp)
  101b2a:	e8 1f ff ff ff       	call   101a4e <trapname>
  101b2f:	8b 55 08             	mov    0x8(%ebp),%edx
  101b32:	8b 52 30             	mov    0x30(%edx),%edx
  101b35:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b39:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b3d:	c7 04 24 b0 64 10 00 	movl   $0x1064b0,(%esp)
  101b44:	e8 ff e7 ff ff       	call   100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b49:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4c:	8b 40 34             	mov    0x34(%eax),%eax
  101b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b53:	c7 04 24 c2 64 10 00 	movl   $0x1064c2,(%esp)
  101b5a:	e8 e9 e7 ff ff       	call   100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b62:	8b 40 38             	mov    0x38(%eax),%eax
  101b65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b69:	c7 04 24 d1 64 10 00 	movl   $0x1064d1,(%esp)
  101b70:	e8 d3 e7 ff ff       	call   100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b75:	8b 45 08             	mov    0x8(%ebp),%eax
  101b78:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b7c:	0f b7 c0             	movzwl %ax,%eax
  101b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b83:	c7 04 24 e0 64 10 00 	movl   $0x1064e0,(%esp)
  101b8a:	e8 b9 e7 ff ff       	call   100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b92:	8b 40 40             	mov    0x40(%eax),%eax
  101b95:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b99:	c7 04 24 f3 64 10 00 	movl   $0x1064f3,(%esp)
  101ba0:	e8 a3 e7 ff ff       	call   100348 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ba5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101bac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bb3:	eb 3e                	jmp    101bf3 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb8:	8b 50 40             	mov    0x40(%eax),%edx
  101bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bbe:	21 d0                	and    %edx,%eax
  101bc0:	85 c0                	test   %eax,%eax
  101bc2:	74 28                	je     101bec <print_trapframe+0x157>
  101bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc7:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101bce:	85 c0                	test   %eax,%eax
  101bd0:	74 1a                	je     101bec <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd5:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be0:	c7 04 24 02 65 10 00 	movl   $0x106502,(%esp)
  101be7:	e8 5c e7 ff ff       	call   100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bf0:	d1 65 f0             	shll   -0x10(%ebp)
  101bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bf6:	83 f8 17             	cmp    $0x17,%eax
  101bf9:	76 ba                	jbe    101bb5 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfe:	8b 40 40             	mov    0x40(%eax),%eax
  101c01:	25 00 30 00 00       	and    $0x3000,%eax
  101c06:	c1 e8 0c             	shr    $0xc,%eax
  101c09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0d:	c7 04 24 06 65 10 00 	movl   $0x106506,(%esp)
  101c14:	e8 2f e7 ff ff       	call   100348 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c19:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1c:	89 04 24             	mov    %eax,(%esp)
  101c1f:	e8 5b fe ff ff       	call   101a7f <trap_in_kernel>
  101c24:	85 c0                	test   %eax,%eax
  101c26:	75 30                	jne    101c58 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c28:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2b:	8b 40 44             	mov    0x44(%eax),%eax
  101c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c32:	c7 04 24 0f 65 10 00 	movl   $0x10650f,(%esp)
  101c39:	e8 0a e7 ff ff       	call   100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c41:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c45:	0f b7 c0             	movzwl %ax,%eax
  101c48:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4c:	c7 04 24 1e 65 10 00 	movl   $0x10651e,(%esp)
  101c53:	e8 f0 e6 ff ff       	call   100348 <cprintf>
    }
}
  101c58:	c9                   	leave  
  101c59:	c3                   	ret    

00101c5a <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c5a:	55                   	push   %ebp
  101c5b:	89 e5                	mov    %esp,%ebp
  101c5d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c60:	8b 45 08             	mov    0x8(%ebp),%eax
  101c63:	8b 00                	mov    (%eax),%eax
  101c65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c69:	c7 04 24 31 65 10 00 	movl   $0x106531,(%esp)
  101c70:	e8 d3 e6 ff ff       	call   100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c75:	8b 45 08             	mov    0x8(%ebp),%eax
  101c78:	8b 40 04             	mov    0x4(%eax),%eax
  101c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7f:	c7 04 24 40 65 10 00 	movl   $0x106540,(%esp)
  101c86:	e8 bd e6 ff ff       	call   100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8e:	8b 40 08             	mov    0x8(%eax),%eax
  101c91:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c95:	c7 04 24 4f 65 10 00 	movl   $0x10654f,(%esp)
  101c9c:	e8 a7 e6 ff ff       	call   100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca4:	8b 40 0c             	mov    0xc(%eax),%eax
  101ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cab:	c7 04 24 5e 65 10 00 	movl   $0x10655e,(%esp)
  101cb2:	e8 91 e6 ff ff       	call   100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  101cba:	8b 40 10             	mov    0x10(%eax),%eax
  101cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc1:	c7 04 24 6d 65 10 00 	movl   $0x10656d,(%esp)
  101cc8:	e8 7b e6 ff ff       	call   100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd0:	8b 40 14             	mov    0x14(%eax),%eax
  101cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd7:	c7 04 24 7c 65 10 00 	movl   $0x10657c,(%esp)
  101cde:	e8 65 e6 ff ff       	call   100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce6:	8b 40 18             	mov    0x18(%eax),%eax
  101ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ced:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  101cf4:	e8 4f e6 ff ff       	call   100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfc:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d03:	c7 04 24 9a 65 10 00 	movl   $0x10659a,(%esp)
  101d0a:	e8 39 e6 ff ff       	call   100348 <cprintf>
}
  101d0f:	c9                   	leave  
  101d10:	c3                   	ret    

00101d11 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d11:	55                   	push   %ebp
  101d12:	89 e5                	mov    %esp,%ebp
  101d14:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d17:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1a:	8b 40 30             	mov    0x30(%eax),%eax
  101d1d:	83 f8 2f             	cmp    $0x2f,%eax
  101d20:	77 21                	ja     101d43 <trap_dispatch+0x32>
  101d22:	83 f8 2e             	cmp    $0x2e,%eax
  101d25:	0f 83 04 01 00 00    	jae    101e2f <trap_dispatch+0x11e>
  101d2b:	83 f8 21             	cmp    $0x21,%eax
  101d2e:	0f 84 81 00 00 00    	je     101db5 <trap_dispatch+0xa4>
  101d34:	83 f8 24             	cmp    $0x24,%eax
  101d37:	74 56                	je     101d8f <trap_dispatch+0x7e>
  101d39:	83 f8 20             	cmp    $0x20,%eax
  101d3c:	74 16                	je     101d54 <trap_dispatch+0x43>
  101d3e:	e9 b4 00 00 00       	jmp    101df7 <trap_dispatch+0xe6>
  101d43:	83 e8 78             	sub    $0x78,%eax
  101d46:	83 f8 01             	cmp    $0x1,%eax
  101d49:	0f 87 a8 00 00 00    	ja     101df7 <trap_dispatch+0xe6>
  101d4f:	e9 87 00 00 00       	jmp    101ddb <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
  101d54:	a1 0c af 11 00       	mov    0x11af0c,%eax
  101d59:	83 c0 01             	add    $0x1,%eax
  101d5c:	a3 0c af 11 00       	mov    %eax,0x11af0c
        if(ticks % TICK_NUM == 0)
  101d61:	8b 0d 0c af 11 00    	mov    0x11af0c,%ecx
  101d67:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d6c:	89 c8                	mov    %ecx,%eax
  101d6e:	f7 e2                	mul    %edx
  101d70:	89 d0                	mov    %edx,%eax
  101d72:	c1 e8 05             	shr    $0x5,%eax
  101d75:	6b c0 64             	imul   $0x64,%eax,%eax
  101d78:	29 c1                	sub    %eax,%ecx
  101d7a:	89 c8                	mov    %ecx,%eax
  101d7c:	85 c0                	test   %eax,%eax
  101d7e:	75 0a                	jne    101d8a <trap_dispatch+0x79>
            print_ticks();
  101d80:	e8 16 fb ff ff       	call   10189b <print_ticks>
        break;
  101d85:	e9 a6 00 00 00       	jmp    101e30 <trap_dispatch+0x11f>
  101d8a:	e9 a1 00 00 00       	jmp    101e30 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d8f:	e8 cb f8 ff ff       	call   10165f <cons_getc>
  101d94:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d97:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d9b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d9f:	89 54 24 08          	mov    %edx,0x8(%esp)
  101da3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da7:	c7 04 24 a9 65 10 00 	movl   $0x1065a9,(%esp)
  101dae:	e8 95 e5 ff ff       	call   100348 <cprintf>
        break;
  101db3:	eb 7b                	jmp    101e30 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101db5:	e8 a5 f8 ff ff       	call   10165f <cons_getc>
  101dba:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dbd:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dc1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dc5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dcd:	c7 04 24 bb 65 10 00 	movl   $0x1065bb,(%esp)
  101dd4:	e8 6f e5 ff ff       	call   100348 <cprintf>
        break;
  101dd9:	eb 55                	jmp    101e30 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101ddb:	c7 44 24 08 ca 65 10 	movl   $0x1065ca,0x8(%esp)
  101de2:	00 
  101de3:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  101dea:	00 
  101deb:	c7 04 24 ee 63 10 00 	movl   $0x1063ee,(%esp)
  101df2:	e8 e9 ee ff ff       	call   100ce0 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101df7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dfe:	0f b7 c0             	movzwl %ax,%eax
  101e01:	83 e0 03             	and    $0x3,%eax
  101e04:	85 c0                	test   %eax,%eax
  101e06:	75 28                	jne    101e30 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101e08:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0b:	89 04 24             	mov    %eax,(%esp)
  101e0e:	e8 82 fc ff ff       	call   101a95 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e13:	c7 44 24 08 da 65 10 	movl   $0x1065da,0x8(%esp)
  101e1a:	00 
  101e1b:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  101e22:	00 
  101e23:	c7 04 24 ee 63 10 00 	movl   $0x1063ee,(%esp)
  101e2a:	e8 b1 ee ff ff       	call   100ce0 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e2f:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e30:	c9                   	leave  
  101e31:	c3                   	ret    

00101e32 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e32:	55                   	push   %ebp
  101e33:	89 e5                	mov    %esp,%ebp
  101e35:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e38:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3b:	89 04 24             	mov    %eax,(%esp)
  101e3e:	e8 ce fe ff ff       	call   101d11 <trap_dispatch>
}
  101e43:	c9                   	leave  
  101e44:	c3                   	ret    

00101e45 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e45:	1e                   	push   %ds
    pushl %es
  101e46:	06                   	push   %es
    pushl %fs
  101e47:	0f a0                	push   %fs
    pushl %gs
  101e49:	0f a8                	push   %gs
    pushal
  101e4b:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e4c:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e51:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e53:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e55:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e56:	e8 d7 ff ff ff       	call   101e32 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e5b:	5c                   	pop    %esp

00101e5c <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e5c:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e5d:	0f a9                	pop    %gs
    popl %fs
  101e5f:	0f a1                	pop    %fs
    popl %es
  101e61:	07                   	pop    %es
    popl %ds
  101e62:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e63:	83 c4 08             	add    $0x8,%esp
    iret
  101e66:	cf                   	iret   

00101e67 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e67:	6a 00                	push   $0x0
  pushl $0
  101e69:	6a 00                	push   $0x0
  jmp __alltraps
  101e6b:	e9 d5 ff ff ff       	jmp    101e45 <__alltraps>

00101e70 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e70:	6a 00                	push   $0x0
  pushl $1
  101e72:	6a 01                	push   $0x1
  jmp __alltraps
  101e74:	e9 cc ff ff ff       	jmp    101e45 <__alltraps>

00101e79 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e79:	6a 00                	push   $0x0
  pushl $2
  101e7b:	6a 02                	push   $0x2
  jmp __alltraps
  101e7d:	e9 c3 ff ff ff       	jmp    101e45 <__alltraps>

00101e82 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e82:	6a 00                	push   $0x0
  pushl $3
  101e84:	6a 03                	push   $0x3
  jmp __alltraps
  101e86:	e9 ba ff ff ff       	jmp    101e45 <__alltraps>

00101e8b <vector4>:
.globl vector4
vector4:
  pushl $0
  101e8b:	6a 00                	push   $0x0
  pushl $4
  101e8d:	6a 04                	push   $0x4
  jmp __alltraps
  101e8f:	e9 b1 ff ff ff       	jmp    101e45 <__alltraps>

00101e94 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e94:	6a 00                	push   $0x0
  pushl $5
  101e96:	6a 05                	push   $0x5
  jmp __alltraps
  101e98:	e9 a8 ff ff ff       	jmp    101e45 <__alltraps>

00101e9d <vector6>:
.globl vector6
vector6:
  pushl $0
  101e9d:	6a 00                	push   $0x0
  pushl $6
  101e9f:	6a 06                	push   $0x6
  jmp __alltraps
  101ea1:	e9 9f ff ff ff       	jmp    101e45 <__alltraps>

00101ea6 <vector7>:
.globl vector7
vector7:
  pushl $0
  101ea6:	6a 00                	push   $0x0
  pushl $7
  101ea8:	6a 07                	push   $0x7
  jmp __alltraps
  101eaa:	e9 96 ff ff ff       	jmp    101e45 <__alltraps>

00101eaf <vector8>:
.globl vector8
vector8:
  pushl $8
  101eaf:	6a 08                	push   $0x8
  jmp __alltraps
  101eb1:	e9 8f ff ff ff       	jmp    101e45 <__alltraps>

00101eb6 <vector9>:
.globl vector9
vector9:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $9
  101eb8:	6a 09                	push   $0x9
  jmp __alltraps
  101eba:	e9 86 ff ff ff       	jmp    101e45 <__alltraps>

00101ebf <vector10>:
.globl vector10
vector10:
  pushl $10
  101ebf:	6a 0a                	push   $0xa
  jmp __alltraps
  101ec1:	e9 7f ff ff ff       	jmp    101e45 <__alltraps>

00101ec6 <vector11>:
.globl vector11
vector11:
  pushl $11
  101ec6:	6a 0b                	push   $0xb
  jmp __alltraps
  101ec8:	e9 78 ff ff ff       	jmp    101e45 <__alltraps>

00101ecd <vector12>:
.globl vector12
vector12:
  pushl $12
  101ecd:	6a 0c                	push   $0xc
  jmp __alltraps
  101ecf:	e9 71 ff ff ff       	jmp    101e45 <__alltraps>

00101ed4 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ed4:	6a 0d                	push   $0xd
  jmp __alltraps
  101ed6:	e9 6a ff ff ff       	jmp    101e45 <__alltraps>

00101edb <vector14>:
.globl vector14
vector14:
  pushl $14
  101edb:	6a 0e                	push   $0xe
  jmp __alltraps
  101edd:	e9 63 ff ff ff       	jmp    101e45 <__alltraps>

00101ee2 <vector15>:
.globl vector15
vector15:
  pushl $0
  101ee2:	6a 00                	push   $0x0
  pushl $15
  101ee4:	6a 0f                	push   $0xf
  jmp __alltraps
  101ee6:	e9 5a ff ff ff       	jmp    101e45 <__alltraps>

00101eeb <vector16>:
.globl vector16
vector16:
  pushl $0
  101eeb:	6a 00                	push   $0x0
  pushl $16
  101eed:	6a 10                	push   $0x10
  jmp __alltraps
  101eef:	e9 51 ff ff ff       	jmp    101e45 <__alltraps>

00101ef4 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ef4:	6a 11                	push   $0x11
  jmp __alltraps
  101ef6:	e9 4a ff ff ff       	jmp    101e45 <__alltraps>

00101efb <vector18>:
.globl vector18
vector18:
  pushl $0
  101efb:	6a 00                	push   $0x0
  pushl $18
  101efd:	6a 12                	push   $0x12
  jmp __alltraps
  101eff:	e9 41 ff ff ff       	jmp    101e45 <__alltraps>

00101f04 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f04:	6a 00                	push   $0x0
  pushl $19
  101f06:	6a 13                	push   $0x13
  jmp __alltraps
  101f08:	e9 38 ff ff ff       	jmp    101e45 <__alltraps>

00101f0d <vector20>:
.globl vector20
vector20:
  pushl $0
  101f0d:	6a 00                	push   $0x0
  pushl $20
  101f0f:	6a 14                	push   $0x14
  jmp __alltraps
  101f11:	e9 2f ff ff ff       	jmp    101e45 <__alltraps>

00101f16 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f16:	6a 00                	push   $0x0
  pushl $21
  101f18:	6a 15                	push   $0x15
  jmp __alltraps
  101f1a:	e9 26 ff ff ff       	jmp    101e45 <__alltraps>

00101f1f <vector22>:
.globl vector22
vector22:
  pushl $0
  101f1f:	6a 00                	push   $0x0
  pushl $22
  101f21:	6a 16                	push   $0x16
  jmp __alltraps
  101f23:	e9 1d ff ff ff       	jmp    101e45 <__alltraps>

00101f28 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f28:	6a 00                	push   $0x0
  pushl $23
  101f2a:	6a 17                	push   $0x17
  jmp __alltraps
  101f2c:	e9 14 ff ff ff       	jmp    101e45 <__alltraps>

00101f31 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $24
  101f33:	6a 18                	push   $0x18
  jmp __alltraps
  101f35:	e9 0b ff ff ff       	jmp    101e45 <__alltraps>

00101f3a <vector25>:
.globl vector25
vector25:
  pushl $0
  101f3a:	6a 00                	push   $0x0
  pushl $25
  101f3c:	6a 19                	push   $0x19
  jmp __alltraps
  101f3e:	e9 02 ff ff ff       	jmp    101e45 <__alltraps>

00101f43 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f43:	6a 00                	push   $0x0
  pushl $26
  101f45:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f47:	e9 f9 fe ff ff       	jmp    101e45 <__alltraps>

00101f4c <vector27>:
.globl vector27
vector27:
  pushl $0
  101f4c:	6a 00                	push   $0x0
  pushl $27
  101f4e:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f50:	e9 f0 fe ff ff       	jmp    101e45 <__alltraps>

00101f55 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f55:	6a 00                	push   $0x0
  pushl $28
  101f57:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f59:	e9 e7 fe ff ff       	jmp    101e45 <__alltraps>

00101f5e <vector29>:
.globl vector29
vector29:
  pushl $0
  101f5e:	6a 00                	push   $0x0
  pushl $29
  101f60:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f62:	e9 de fe ff ff       	jmp    101e45 <__alltraps>

00101f67 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f67:	6a 00                	push   $0x0
  pushl $30
  101f69:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f6b:	e9 d5 fe ff ff       	jmp    101e45 <__alltraps>

00101f70 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f70:	6a 00                	push   $0x0
  pushl $31
  101f72:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f74:	e9 cc fe ff ff       	jmp    101e45 <__alltraps>

00101f79 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f79:	6a 00                	push   $0x0
  pushl $32
  101f7b:	6a 20                	push   $0x20
  jmp __alltraps
  101f7d:	e9 c3 fe ff ff       	jmp    101e45 <__alltraps>

00101f82 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f82:	6a 00                	push   $0x0
  pushl $33
  101f84:	6a 21                	push   $0x21
  jmp __alltraps
  101f86:	e9 ba fe ff ff       	jmp    101e45 <__alltraps>

00101f8b <vector34>:
.globl vector34
vector34:
  pushl $0
  101f8b:	6a 00                	push   $0x0
  pushl $34
  101f8d:	6a 22                	push   $0x22
  jmp __alltraps
  101f8f:	e9 b1 fe ff ff       	jmp    101e45 <__alltraps>

00101f94 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f94:	6a 00                	push   $0x0
  pushl $35
  101f96:	6a 23                	push   $0x23
  jmp __alltraps
  101f98:	e9 a8 fe ff ff       	jmp    101e45 <__alltraps>

00101f9d <vector36>:
.globl vector36
vector36:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $36
  101f9f:	6a 24                	push   $0x24
  jmp __alltraps
  101fa1:	e9 9f fe ff ff       	jmp    101e45 <__alltraps>

00101fa6 <vector37>:
.globl vector37
vector37:
  pushl $0
  101fa6:	6a 00                	push   $0x0
  pushl $37
  101fa8:	6a 25                	push   $0x25
  jmp __alltraps
  101faa:	e9 96 fe ff ff       	jmp    101e45 <__alltraps>

00101faf <vector38>:
.globl vector38
vector38:
  pushl $0
  101faf:	6a 00                	push   $0x0
  pushl $38
  101fb1:	6a 26                	push   $0x26
  jmp __alltraps
  101fb3:	e9 8d fe ff ff       	jmp    101e45 <__alltraps>

00101fb8 <vector39>:
.globl vector39
vector39:
  pushl $0
  101fb8:	6a 00                	push   $0x0
  pushl $39
  101fba:	6a 27                	push   $0x27
  jmp __alltraps
  101fbc:	e9 84 fe ff ff       	jmp    101e45 <__alltraps>

00101fc1 <vector40>:
.globl vector40
vector40:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $40
  101fc3:	6a 28                	push   $0x28
  jmp __alltraps
  101fc5:	e9 7b fe ff ff       	jmp    101e45 <__alltraps>

00101fca <vector41>:
.globl vector41
vector41:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $41
  101fcc:	6a 29                	push   $0x29
  jmp __alltraps
  101fce:	e9 72 fe ff ff       	jmp    101e45 <__alltraps>

00101fd3 <vector42>:
.globl vector42
vector42:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $42
  101fd5:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fd7:	e9 69 fe ff ff       	jmp    101e45 <__alltraps>

00101fdc <vector43>:
.globl vector43
vector43:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $43
  101fde:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fe0:	e9 60 fe ff ff       	jmp    101e45 <__alltraps>

00101fe5 <vector44>:
.globl vector44
vector44:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $44
  101fe7:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fe9:	e9 57 fe ff ff       	jmp    101e45 <__alltraps>

00101fee <vector45>:
.globl vector45
vector45:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $45
  101ff0:	6a 2d                	push   $0x2d
  jmp __alltraps
  101ff2:	e9 4e fe ff ff       	jmp    101e45 <__alltraps>

00101ff7 <vector46>:
.globl vector46
vector46:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $46
  101ff9:	6a 2e                	push   $0x2e
  jmp __alltraps
  101ffb:	e9 45 fe ff ff       	jmp    101e45 <__alltraps>

00102000 <vector47>:
.globl vector47
vector47:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $47
  102002:	6a 2f                	push   $0x2f
  jmp __alltraps
  102004:	e9 3c fe ff ff       	jmp    101e45 <__alltraps>

00102009 <vector48>:
.globl vector48
vector48:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $48
  10200b:	6a 30                	push   $0x30
  jmp __alltraps
  10200d:	e9 33 fe ff ff       	jmp    101e45 <__alltraps>

00102012 <vector49>:
.globl vector49
vector49:
  pushl $0
  102012:	6a 00                	push   $0x0
  pushl $49
  102014:	6a 31                	push   $0x31
  jmp __alltraps
  102016:	e9 2a fe ff ff       	jmp    101e45 <__alltraps>

0010201b <vector50>:
.globl vector50
vector50:
  pushl $0
  10201b:	6a 00                	push   $0x0
  pushl $50
  10201d:	6a 32                	push   $0x32
  jmp __alltraps
  10201f:	e9 21 fe ff ff       	jmp    101e45 <__alltraps>

00102024 <vector51>:
.globl vector51
vector51:
  pushl $0
  102024:	6a 00                	push   $0x0
  pushl $51
  102026:	6a 33                	push   $0x33
  jmp __alltraps
  102028:	e9 18 fe ff ff       	jmp    101e45 <__alltraps>

0010202d <vector52>:
.globl vector52
vector52:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $52
  10202f:	6a 34                	push   $0x34
  jmp __alltraps
  102031:	e9 0f fe ff ff       	jmp    101e45 <__alltraps>

00102036 <vector53>:
.globl vector53
vector53:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $53
  102038:	6a 35                	push   $0x35
  jmp __alltraps
  10203a:	e9 06 fe ff ff       	jmp    101e45 <__alltraps>

0010203f <vector54>:
.globl vector54
vector54:
  pushl $0
  10203f:	6a 00                	push   $0x0
  pushl $54
  102041:	6a 36                	push   $0x36
  jmp __alltraps
  102043:	e9 fd fd ff ff       	jmp    101e45 <__alltraps>

00102048 <vector55>:
.globl vector55
vector55:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $55
  10204a:	6a 37                	push   $0x37
  jmp __alltraps
  10204c:	e9 f4 fd ff ff       	jmp    101e45 <__alltraps>

00102051 <vector56>:
.globl vector56
vector56:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $56
  102053:	6a 38                	push   $0x38
  jmp __alltraps
  102055:	e9 eb fd ff ff       	jmp    101e45 <__alltraps>

0010205a <vector57>:
.globl vector57
vector57:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $57
  10205c:	6a 39                	push   $0x39
  jmp __alltraps
  10205e:	e9 e2 fd ff ff       	jmp    101e45 <__alltraps>

00102063 <vector58>:
.globl vector58
vector58:
  pushl $0
  102063:	6a 00                	push   $0x0
  pushl $58
  102065:	6a 3a                	push   $0x3a
  jmp __alltraps
  102067:	e9 d9 fd ff ff       	jmp    101e45 <__alltraps>

0010206c <vector59>:
.globl vector59
vector59:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $59
  10206e:	6a 3b                	push   $0x3b
  jmp __alltraps
  102070:	e9 d0 fd ff ff       	jmp    101e45 <__alltraps>

00102075 <vector60>:
.globl vector60
vector60:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $60
  102077:	6a 3c                	push   $0x3c
  jmp __alltraps
  102079:	e9 c7 fd ff ff       	jmp    101e45 <__alltraps>

0010207e <vector61>:
.globl vector61
vector61:
  pushl $0
  10207e:	6a 00                	push   $0x0
  pushl $61
  102080:	6a 3d                	push   $0x3d
  jmp __alltraps
  102082:	e9 be fd ff ff       	jmp    101e45 <__alltraps>

00102087 <vector62>:
.globl vector62
vector62:
  pushl $0
  102087:	6a 00                	push   $0x0
  pushl $62
  102089:	6a 3e                	push   $0x3e
  jmp __alltraps
  10208b:	e9 b5 fd ff ff       	jmp    101e45 <__alltraps>

00102090 <vector63>:
.globl vector63
vector63:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $63
  102092:	6a 3f                	push   $0x3f
  jmp __alltraps
  102094:	e9 ac fd ff ff       	jmp    101e45 <__alltraps>

00102099 <vector64>:
.globl vector64
vector64:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $64
  10209b:	6a 40                	push   $0x40
  jmp __alltraps
  10209d:	e9 a3 fd ff ff       	jmp    101e45 <__alltraps>

001020a2 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $65
  1020a4:	6a 41                	push   $0x41
  jmp __alltraps
  1020a6:	e9 9a fd ff ff       	jmp    101e45 <__alltraps>

001020ab <vector66>:
.globl vector66
vector66:
  pushl $0
  1020ab:	6a 00                	push   $0x0
  pushl $66
  1020ad:	6a 42                	push   $0x42
  jmp __alltraps
  1020af:	e9 91 fd ff ff       	jmp    101e45 <__alltraps>

001020b4 <vector67>:
.globl vector67
vector67:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $67
  1020b6:	6a 43                	push   $0x43
  jmp __alltraps
  1020b8:	e9 88 fd ff ff       	jmp    101e45 <__alltraps>

001020bd <vector68>:
.globl vector68
vector68:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $68
  1020bf:	6a 44                	push   $0x44
  jmp __alltraps
  1020c1:	e9 7f fd ff ff       	jmp    101e45 <__alltraps>

001020c6 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $69
  1020c8:	6a 45                	push   $0x45
  jmp __alltraps
  1020ca:	e9 76 fd ff ff       	jmp    101e45 <__alltraps>

001020cf <vector70>:
.globl vector70
vector70:
  pushl $0
  1020cf:	6a 00                	push   $0x0
  pushl $70
  1020d1:	6a 46                	push   $0x46
  jmp __alltraps
  1020d3:	e9 6d fd ff ff       	jmp    101e45 <__alltraps>

001020d8 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $71
  1020da:	6a 47                	push   $0x47
  jmp __alltraps
  1020dc:	e9 64 fd ff ff       	jmp    101e45 <__alltraps>

001020e1 <vector72>:
.globl vector72
vector72:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $72
  1020e3:	6a 48                	push   $0x48
  jmp __alltraps
  1020e5:	e9 5b fd ff ff       	jmp    101e45 <__alltraps>

001020ea <vector73>:
.globl vector73
vector73:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $73
  1020ec:	6a 49                	push   $0x49
  jmp __alltraps
  1020ee:	e9 52 fd ff ff       	jmp    101e45 <__alltraps>

001020f3 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $74
  1020f5:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020f7:	e9 49 fd ff ff       	jmp    101e45 <__alltraps>

001020fc <vector75>:
.globl vector75
vector75:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $75
  1020fe:	6a 4b                	push   $0x4b
  jmp __alltraps
  102100:	e9 40 fd ff ff       	jmp    101e45 <__alltraps>

00102105 <vector76>:
.globl vector76
vector76:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $76
  102107:	6a 4c                	push   $0x4c
  jmp __alltraps
  102109:	e9 37 fd ff ff       	jmp    101e45 <__alltraps>

0010210e <vector77>:
.globl vector77
vector77:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $77
  102110:	6a 4d                	push   $0x4d
  jmp __alltraps
  102112:	e9 2e fd ff ff       	jmp    101e45 <__alltraps>

00102117 <vector78>:
.globl vector78
vector78:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $78
  102119:	6a 4e                	push   $0x4e
  jmp __alltraps
  10211b:	e9 25 fd ff ff       	jmp    101e45 <__alltraps>

00102120 <vector79>:
.globl vector79
vector79:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $79
  102122:	6a 4f                	push   $0x4f
  jmp __alltraps
  102124:	e9 1c fd ff ff       	jmp    101e45 <__alltraps>

00102129 <vector80>:
.globl vector80
vector80:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $80
  10212b:	6a 50                	push   $0x50
  jmp __alltraps
  10212d:	e9 13 fd ff ff       	jmp    101e45 <__alltraps>

00102132 <vector81>:
.globl vector81
vector81:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $81
  102134:	6a 51                	push   $0x51
  jmp __alltraps
  102136:	e9 0a fd ff ff       	jmp    101e45 <__alltraps>

0010213b <vector82>:
.globl vector82
vector82:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $82
  10213d:	6a 52                	push   $0x52
  jmp __alltraps
  10213f:	e9 01 fd ff ff       	jmp    101e45 <__alltraps>

00102144 <vector83>:
.globl vector83
vector83:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $83
  102146:	6a 53                	push   $0x53
  jmp __alltraps
  102148:	e9 f8 fc ff ff       	jmp    101e45 <__alltraps>

0010214d <vector84>:
.globl vector84
vector84:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $84
  10214f:	6a 54                	push   $0x54
  jmp __alltraps
  102151:	e9 ef fc ff ff       	jmp    101e45 <__alltraps>

00102156 <vector85>:
.globl vector85
vector85:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $85
  102158:	6a 55                	push   $0x55
  jmp __alltraps
  10215a:	e9 e6 fc ff ff       	jmp    101e45 <__alltraps>

0010215f <vector86>:
.globl vector86
vector86:
  pushl $0
  10215f:	6a 00                	push   $0x0
  pushl $86
  102161:	6a 56                	push   $0x56
  jmp __alltraps
  102163:	e9 dd fc ff ff       	jmp    101e45 <__alltraps>

00102168 <vector87>:
.globl vector87
vector87:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $87
  10216a:	6a 57                	push   $0x57
  jmp __alltraps
  10216c:	e9 d4 fc ff ff       	jmp    101e45 <__alltraps>

00102171 <vector88>:
.globl vector88
vector88:
  pushl $0
  102171:	6a 00                	push   $0x0
  pushl $88
  102173:	6a 58                	push   $0x58
  jmp __alltraps
  102175:	e9 cb fc ff ff       	jmp    101e45 <__alltraps>

0010217a <vector89>:
.globl vector89
vector89:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $89
  10217c:	6a 59                	push   $0x59
  jmp __alltraps
  10217e:	e9 c2 fc ff ff       	jmp    101e45 <__alltraps>

00102183 <vector90>:
.globl vector90
vector90:
  pushl $0
  102183:	6a 00                	push   $0x0
  pushl $90
  102185:	6a 5a                	push   $0x5a
  jmp __alltraps
  102187:	e9 b9 fc ff ff       	jmp    101e45 <__alltraps>

0010218c <vector91>:
.globl vector91
vector91:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $91
  10218e:	6a 5b                	push   $0x5b
  jmp __alltraps
  102190:	e9 b0 fc ff ff       	jmp    101e45 <__alltraps>

00102195 <vector92>:
.globl vector92
vector92:
  pushl $0
  102195:	6a 00                	push   $0x0
  pushl $92
  102197:	6a 5c                	push   $0x5c
  jmp __alltraps
  102199:	e9 a7 fc ff ff       	jmp    101e45 <__alltraps>

0010219e <vector93>:
.globl vector93
vector93:
  pushl $0
  10219e:	6a 00                	push   $0x0
  pushl $93
  1021a0:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021a2:	e9 9e fc ff ff       	jmp    101e45 <__alltraps>

001021a7 <vector94>:
.globl vector94
vector94:
  pushl $0
  1021a7:	6a 00                	push   $0x0
  pushl $94
  1021a9:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021ab:	e9 95 fc ff ff       	jmp    101e45 <__alltraps>

001021b0 <vector95>:
.globl vector95
vector95:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $95
  1021b2:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021b4:	e9 8c fc ff ff       	jmp    101e45 <__alltraps>

001021b9 <vector96>:
.globl vector96
vector96:
  pushl $0
  1021b9:	6a 00                	push   $0x0
  pushl $96
  1021bb:	6a 60                	push   $0x60
  jmp __alltraps
  1021bd:	e9 83 fc ff ff       	jmp    101e45 <__alltraps>

001021c2 <vector97>:
.globl vector97
vector97:
  pushl $0
  1021c2:	6a 00                	push   $0x0
  pushl $97
  1021c4:	6a 61                	push   $0x61
  jmp __alltraps
  1021c6:	e9 7a fc ff ff       	jmp    101e45 <__alltraps>

001021cb <vector98>:
.globl vector98
vector98:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $98
  1021cd:	6a 62                	push   $0x62
  jmp __alltraps
  1021cf:	e9 71 fc ff ff       	jmp    101e45 <__alltraps>

001021d4 <vector99>:
.globl vector99
vector99:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $99
  1021d6:	6a 63                	push   $0x63
  jmp __alltraps
  1021d8:	e9 68 fc ff ff       	jmp    101e45 <__alltraps>

001021dd <vector100>:
.globl vector100
vector100:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $100
  1021df:	6a 64                	push   $0x64
  jmp __alltraps
  1021e1:	e9 5f fc ff ff       	jmp    101e45 <__alltraps>

001021e6 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $101
  1021e8:	6a 65                	push   $0x65
  jmp __alltraps
  1021ea:	e9 56 fc ff ff       	jmp    101e45 <__alltraps>

001021ef <vector102>:
.globl vector102
vector102:
  pushl $0
  1021ef:	6a 00                	push   $0x0
  pushl $102
  1021f1:	6a 66                	push   $0x66
  jmp __alltraps
  1021f3:	e9 4d fc ff ff       	jmp    101e45 <__alltraps>

001021f8 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $103
  1021fa:	6a 67                	push   $0x67
  jmp __alltraps
  1021fc:	e9 44 fc ff ff       	jmp    101e45 <__alltraps>

00102201 <vector104>:
.globl vector104
vector104:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $104
  102203:	6a 68                	push   $0x68
  jmp __alltraps
  102205:	e9 3b fc ff ff       	jmp    101e45 <__alltraps>

0010220a <vector105>:
.globl vector105
vector105:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $105
  10220c:	6a 69                	push   $0x69
  jmp __alltraps
  10220e:	e9 32 fc ff ff       	jmp    101e45 <__alltraps>

00102213 <vector106>:
.globl vector106
vector106:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $106
  102215:	6a 6a                	push   $0x6a
  jmp __alltraps
  102217:	e9 29 fc ff ff       	jmp    101e45 <__alltraps>

0010221c <vector107>:
.globl vector107
vector107:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $107
  10221e:	6a 6b                	push   $0x6b
  jmp __alltraps
  102220:	e9 20 fc ff ff       	jmp    101e45 <__alltraps>

00102225 <vector108>:
.globl vector108
vector108:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $108
  102227:	6a 6c                	push   $0x6c
  jmp __alltraps
  102229:	e9 17 fc ff ff       	jmp    101e45 <__alltraps>

0010222e <vector109>:
.globl vector109
vector109:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $109
  102230:	6a 6d                	push   $0x6d
  jmp __alltraps
  102232:	e9 0e fc ff ff       	jmp    101e45 <__alltraps>

00102237 <vector110>:
.globl vector110
vector110:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $110
  102239:	6a 6e                	push   $0x6e
  jmp __alltraps
  10223b:	e9 05 fc ff ff       	jmp    101e45 <__alltraps>

00102240 <vector111>:
.globl vector111
vector111:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $111
  102242:	6a 6f                	push   $0x6f
  jmp __alltraps
  102244:	e9 fc fb ff ff       	jmp    101e45 <__alltraps>

00102249 <vector112>:
.globl vector112
vector112:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $112
  10224b:	6a 70                	push   $0x70
  jmp __alltraps
  10224d:	e9 f3 fb ff ff       	jmp    101e45 <__alltraps>

00102252 <vector113>:
.globl vector113
vector113:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $113
  102254:	6a 71                	push   $0x71
  jmp __alltraps
  102256:	e9 ea fb ff ff       	jmp    101e45 <__alltraps>

0010225b <vector114>:
.globl vector114
vector114:
  pushl $0
  10225b:	6a 00                	push   $0x0
  pushl $114
  10225d:	6a 72                	push   $0x72
  jmp __alltraps
  10225f:	e9 e1 fb ff ff       	jmp    101e45 <__alltraps>

00102264 <vector115>:
.globl vector115
vector115:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $115
  102266:	6a 73                	push   $0x73
  jmp __alltraps
  102268:	e9 d8 fb ff ff       	jmp    101e45 <__alltraps>

0010226d <vector116>:
.globl vector116
vector116:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $116
  10226f:	6a 74                	push   $0x74
  jmp __alltraps
  102271:	e9 cf fb ff ff       	jmp    101e45 <__alltraps>

00102276 <vector117>:
.globl vector117
vector117:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $117
  102278:	6a 75                	push   $0x75
  jmp __alltraps
  10227a:	e9 c6 fb ff ff       	jmp    101e45 <__alltraps>

0010227f <vector118>:
.globl vector118
vector118:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $118
  102281:	6a 76                	push   $0x76
  jmp __alltraps
  102283:	e9 bd fb ff ff       	jmp    101e45 <__alltraps>

00102288 <vector119>:
.globl vector119
vector119:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $119
  10228a:	6a 77                	push   $0x77
  jmp __alltraps
  10228c:	e9 b4 fb ff ff       	jmp    101e45 <__alltraps>

00102291 <vector120>:
.globl vector120
vector120:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $120
  102293:	6a 78                	push   $0x78
  jmp __alltraps
  102295:	e9 ab fb ff ff       	jmp    101e45 <__alltraps>

0010229a <vector121>:
.globl vector121
vector121:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $121
  10229c:	6a 79                	push   $0x79
  jmp __alltraps
  10229e:	e9 a2 fb ff ff       	jmp    101e45 <__alltraps>

001022a3 <vector122>:
.globl vector122
vector122:
  pushl $0
  1022a3:	6a 00                	push   $0x0
  pushl $122
  1022a5:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022a7:	e9 99 fb ff ff       	jmp    101e45 <__alltraps>

001022ac <vector123>:
.globl vector123
vector123:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $123
  1022ae:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022b0:	e9 90 fb ff ff       	jmp    101e45 <__alltraps>

001022b5 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $124
  1022b7:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022b9:	e9 87 fb ff ff       	jmp    101e45 <__alltraps>

001022be <vector125>:
.globl vector125
vector125:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $125
  1022c0:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022c2:	e9 7e fb ff ff       	jmp    101e45 <__alltraps>

001022c7 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022c7:	6a 00                	push   $0x0
  pushl $126
  1022c9:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022cb:	e9 75 fb ff ff       	jmp    101e45 <__alltraps>

001022d0 <vector127>:
.globl vector127
vector127:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $127
  1022d2:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022d4:	e9 6c fb ff ff       	jmp    101e45 <__alltraps>

001022d9 <vector128>:
.globl vector128
vector128:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $128
  1022db:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022e0:	e9 60 fb ff ff       	jmp    101e45 <__alltraps>

001022e5 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $129
  1022e7:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022ec:	e9 54 fb ff ff       	jmp    101e45 <__alltraps>

001022f1 <vector130>:
.globl vector130
vector130:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $130
  1022f3:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022f8:	e9 48 fb ff ff       	jmp    101e45 <__alltraps>

001022fd <vector131>:
.globl vector131
vector131:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $131
  1022ff:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102304:	e9 3c fb ff ff       	jmp    101e45 <__alltraps>

00102309 <vector132>:
.globl vector132
vector132:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $132
  10230b:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102310:	e9 30 fb ff ff       	jmp    101e45 <__alltraps>

00102315 <vector133>:
.globl vector133
vector133:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $133
  102317:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10231c:	e9 24 fb ff ff       	jmp    101e45 <__alltraps>

00102321 <vector134>:
.globl vector134
vector134:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $134
  102323:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102328:	e9 18 fb ff ff       	jmp    101e45 <__alltraps>

0010232d <vector135>:
.globl vector135
vector135:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $135
  10232f:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102334:	e9 0c fb ff ff       	jmp    101e45 <__alltraps>

00102339 <vector136>:
.globl vector136
vector136:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $136
  10233b:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102340:	e9 00 fb ff ff       	jmp    101e45 <__alltraps>

00102345 <vector137>:
.globl vector137
vector137:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $137
  102347:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10234c:	e9 f4 fa ff ff       	jmp    101e45 <__alltraps>

00102351 <vector138>:
.globl vector138
vector138:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $138
  102353:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102358:	e9 e8 fa ff ff       	jmp    101e45 <__alltraps>

0010235d <vector139>:
.globl vector139
vector139:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $139
  10235f:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102364:	e9 dc fa ff ff       	jmp    101e45 <__alltraps>

00102369 <vector140>:
.globl vector140
vector140:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $140
  10236b:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102370:	e9 d0 fa ff ff       	jmp    101e45 <__alltraps>

00102375 <vector141>:
.globl vector141
vector141:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $141
  102377:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10237c:	e9 c4 fa ff ff       	jmp    101e45 <__alltraps>

00102381 <vector142>:
.globl vector142
vector142:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $142
  102383:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102388:	e9 b8 fa ff ff       	jmp    101e45 <__alltraps>

0010238d <vector143>:
.globl vector143
vector143:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $143
  10238f:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102394:	e9 ac fa ff ff       	jmp    101e45 <__alltraps>

00102399 <vector144>:
.globl vector144
vector144:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $144
  10239b:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023a0:	e9 a0 fa ff ff       	jmp    101e45 <__alltraps>

001023a5 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $145
  1023a7:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023ac:	e9 94 fa ff ff       	jmp    101e45 <__alltraps>

001023b1 <vector146>:
.globl vector146
vector146:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $146
  1023b3:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023b8:	e9 88 fa ff ff       	jmp    101e45 <__alltraps>

001023bd <vector147>:
.globl vector147
vector147:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $147
  1023bf:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023c4:	e9 7c fa ff ff       	jmp    101e45 <__alltraps>

001023c9 <vector148>:
.globl vector148
vector148:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $148
  1023cb:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023d0:	e9 70 fa ff ff       	jmp    101e45 <__alltraps>

001023d5 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $149
  1023d7:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023dc:	e9 64 fa ff ff       	jmp    101e45 <__alltraps>

001023e1 <vector150>:
.globl vector150
vector150:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $150
  1023e3:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023e8:	e9 58 fa ff ff       	jmp    101e45 <__alltraps>

001023ed <vector151>:
.globl vector151
vector151:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $151
  1023ef:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023f4:	e9 4c fa ff ff       	jmp    101e45 <__alltraps>

001023f9 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $152
  1023fb:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102400:	e9 40 fa ff ff       	jmp    101e45 <__alltraps>

00102405 <vector153>:
.globl vector153
vector153:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $153
  102407:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10240c:	e9 34 fa ff ff       	jmp    101e45 <__alltraps>

00102411 <vector154>:
.globl vector154
vector154:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $154
  102413:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102418:	e9 28 fa ff ff       	jmp    101e45 <__alltraps>

0010241d <vector155>:
.globl vector155
vector155:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $155
  10241f:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102424:	e9 1c fa ff ff       	jmp    101e45 <__alltraps>

00102429 <vector156>:
.globl vector156
vector156:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $156
  10242b:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102430:	e9 10 fa ff ff       	jmp    101e45 <__alltraps>

00102435 <vector157>:
.globl vector157
vector157:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $157
  102437:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10243c:	e9 04 fa ff ff       	jmp    101e45 <__alltraps>

00102441 <vector158>:
.globl vector158
vector158:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $158
  102443:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102448:	e9 f8 f9 ff ff       	jmp    101e45 <__alltraps>

0010244d <vector159>:
.globl vector159
vector159:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $159
  10244f:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102454:	e9 ec f9 ff ff       	jmp    101e45 <__alltraps>

00102459 <vector160>:
.globl vector160
vector160:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $160
  10245b:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102460:	e9 e0 f9 ff ff       	jmp    101e45 <__alltraps>

00102465 <vector161>:
.globl vector161
vector161:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $161
  102467:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10246c:	e9 d4 f9 ff ff       	jmp    101e45 <__alltraps>

00102471 <vector162>:
.globl vector162
vector162:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $162
  102473:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102478:	e9 c8 f9 ff ff       	jmp    101e45 <__alltraps>

0010247d <vector163>:
.globl vector163
vector163:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $163
  10247f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102484:	e9 bc f9 ff ff       	jmp    101e45 <__alltraps>

00102489 <vector164>:
.globl vector164
vector164:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $164
  10248b:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102490:	e9 b0 f9 ff ff       	jmp    101e45 <__alltraps>

00102495 <vector165>:
.globl vector165
vector165:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $165
  102497:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10249c:	e9 a4 f9 ff ff       	jmp    101e45 <__alltraps>

001024a1 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $166
  1024a3:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024a8:	e9 98 f9 ff ff       	jmp    101e45 <__alltraps>

001024ad <vector167>:
.globl vector167
vector167:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $167
  1024af:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024b4:	e9 8c f9 ff ff       	jmp    101e45 <__alltraps>

001024b9 <vector168>:
.globl vector168
vector168:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $168
  1024bb:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024c0:	e9 80 f9 ff ff       	jmp    101e45 <__alltraps>

001024c5 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $169
  1024c7:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024cc:	e9 74 f9 ff ff       	jmp    101e45 <__alltraps>

001024d1 <vector170>:
.globl vector170
vector170:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $170
  1024d3:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024d8:	e9 68 f9 ff ff       	jmp    101e45 <__alltraps>

001024dd <vector171>:
.globl vector171
vector171:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $171
  1024df:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024e4:	e9 5c f9 ff ff       	jmp    101e45 <__alltraps>

001024e9 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $172
  1024eb:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024f0:	e9 50 f9 ff ff       	jmp    101e45 <__alltraps>

001024f5 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $173
  1024f7:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024fc:	e9 44 f9 ff ff       	jmp    101e45 <__alltraps>

00102501 <vector174>:
.globl vector174
vector174:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $174
  102503:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102508:	e9 38 f9 ff ff       	jmp    101e45 <__alltraps>

0010250d <vector175>:
.globl vector175
vector175:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $175
  10250f:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102514:	e9 2c f9 ff ff       	jmp    101e45 <__alltraps>

00102519 <vector176>:
.globl vector176
vector176:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $176
  10251b:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102520:	e9 20 f9 ff ff       	jmp    101e45 <__alltraps>

00102525 <vector177>:
.globl vector177
vector177:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $177
  102527:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10252c:	e9 14 f9 ff ff       	jmp    101e45 <__alltraps>

00102531 <vector178>:
.globl vector178
vector178:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $178
  102533:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102538:	e9 08 f9 ff ff       	jmp    101e45 <__alltraps>

0010253d <vector179>:
.globl vector179
vector179:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $179
  10253f:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102544:	e9 fc f8 ff ff       	jmp    101e45 <__alltraps>

00102549 <vector180>:
.globl vector180
vector180:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $180
  10254b:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102550:	e9 f0 f8 ff ff       	jmp    101e45 <__alltraps>

00102555 <vector181>:
.globl vector181
vector181:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $181
  102557:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10255c:	e9 e4 f8 ff ff       	jmp    101e45 <__alltraps>

00102561 <vector182>:
.globl vector182
vector182:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $182
  102563:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102568:	e9 d8 f8 ff ff       	jmp    101e45 <__alltraps>

0010256d <vector183>:
.globl vector183
vector183:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $183
  10256f:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102574:	e9 cc f8 ff ff       	jmp    101e45 <__alltraps>

00102579 <vector184>:
.globl vector184
vector184:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $184
  10257b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102580:	e9 c0 f8 ff ff       	jmp    101e45 <__alltraps>

00102585 <vector185>:
.globl vector185
vector185:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $185
  102587:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10258c:	e9 b4 f8 ff ff       	jmp    101e45 <__alltraps>

00102591 <vector186>:
.globl vector186
vector186:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $186
  102593:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102598:	e9 a8 f8 ff ff       	jmp    101e45 <__alltraps>

0010259d <vector187>:
.globl vector187
vector187:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $187
  10259f:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025a4:	e9 9c f8 ff ff       	jmp    101e45 <__alltraps>

001025a9 <vector188>:
.globl vector188
vector188:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $188
  1025ab:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025b0:	e9 90 f8 ff ff       	jmp    101e45 <__alltraps>

001025b5 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $189
  1025b7:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025bc:	e9 84 f8 ff ff       	jmp    101e45 <__alltraps>

001025c1 <vector190>:
.globl vector190
vector190:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $190
  1025c3:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025c8:	e9 78 f8 ff ff       	jmp    101e45 <__alltraps>

001025cd <vector191>:
.globl vector191
vector191:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $191
  1025cf:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025d4:	e9 6c f8 ff ff       	jmp    101e45 <__alltraps>

001025d9 <vector192>:
.globl vector192
vector192:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $192
  1025db:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025e0:	e9 60 f8 ff ff       	jmp    101e45 <__alltraps>

001025e5 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $193
  1025e7:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025ec:	e9 54 f8 ff ff       	jmp    101e45 <__alltraps>

001025f1 <vector194>:
.globl vector194
vector194:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $194
  1025f3:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025f8:	e9 48 f8 ff ff       	jmp    101e45 <__alltraps>

001025fd <vector195>:
.globl vector195
vector195:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $195
  1025ff:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102604:	e9 3c f8 ff ff       	jmp    101e45 <__alltraps>

00102609 <vector196>:
.globl vector196
vector196:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $196
  10260b:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102610:	e9 30 f8 ff ff       	jmp    101e45 <__alltraps>

00102615 <vector197>:
.globl vector197
vector197:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $197
  102617:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10261c:	e9 24 f8 ff ff       	jmp    101e45 <__alltraps>

00102621 <vector198>:
.globl vector198
vector198:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $198
  102623:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102628:	e9 18 f8 ff ff       	jmp    101e45 <__alltraps>

0010262d <vector199>:
.globl vector199
vector199:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $199
  10262f:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102634:	e9 0c f8 ff ff       	jmp    101e45 <__alltraps>

00102639 <vector200>:
.globl vector200
vector200:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $200
  10263b:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102640:	e9 00 f8 ff ff       	jmp    101e45 <__alltraps>

00102645 <vector201>:
.globl vector201
vector201:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $201
  102647:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10264c:	e9 f4 f7 ff ff       	jmp    101e45 <__alltraps>

00102651 <vector202>:
.globl vector202
vector202:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $202
  102653:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102658:	e9 e8 f7 ff ff       	jmp    101e45 <__alltraps>

0010265d <vector203>:
.globl vector203
vector203:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $203
  10265f:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102664:	e9 dc f7 ff ff       	jmp    101e45 <__alltraps>

00102669 <vector204>:
.globl vector204
vector204:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $204
  10266b:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102670:	e9 d0 f7 ff ff       	jmp    101e45 <__alltraps>

00102675 <vector205>:
.globl vector205
vector205:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $205
  102677:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10267c:	e9 c4 f7 ff ff       	jmp    101e45 <__alltraps>

00102681 <vector206>:
.globl vector206
vector206:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $206
  102683:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102688:	e9 b8 f7 ff ff       	jmp    101e45 <__alltraps>

0010268d <vector207>:
.globl vector207
vector207:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $207
  10268f:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102694:	e9 ac f7 ff ff       	jmp    101e45 <__alltraps>

00102699 <vector208>:
.globl vector208
vector208:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $208
  10269b:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026a0:	e9 a0 f7 ff ff       	jmp    101e45 <__alltraps>

001026a5 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $209
  1026a7:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026ac:	e9 94 f7 ff ff       	jmp    101e45 <__alltraps>

001026b1 <vector210>:
.globl vector210
vector210:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $210
  1026b3:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026b8:	e9 88 f7 ff ff       	jmp    101e45 <__alltraps>

001026bd <vector211>:
.globl vector211
vector211:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $211
  1026bf:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026c4:	e9 7c f7 ff ff       	jmp    101e45 <__alltraps>

001026c9 <vector212>:
.globl vector212
vector212:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $212
  1026cb:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026d0:	e9 70 f7 ff ff       	jmp    101e45 <__alltraps>

001026d5 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $213
  1026d7:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026dc:	e9 64 f7 ff ff       	jmp    101e45 <__alltraps>

001026e1 <vector214>:
.globl vector214
vector214:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $214
  1026e3:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026e8:	e9 58 f7 ff ff       	jmp    101e45 <__alltraps>

001026ed <vector215>:
.globl vector215
vector215:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $215
  1026ef:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026f4:	e9 4c f7 ff ff       	jmp    101e45 <__alltraps>

001026f9 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $216
  1026fb:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102700:	e9 40 f7 ff ff       	jmp    101e45 <__alltraps>

00102705 <vector217>:
.globl vector217
vector217:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $217
  102707:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10270c:	e9 34 f7 ff ff       	jmp    101e45 <__alltraps>

00102711 <vector218>:
.globl vector218
vector218:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $218
  102713:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102718:	e9 28 f7 ff ff       	jmp    101e45 <__alltraps>

0010271d <vector219>:
.globl vector219
vector219:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $219
  10271f:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102724:	e9 1c f7 ff ff       	jmp    101e45 <__alltraps>

00102729 <vector220>:
.globl vector220
vector220:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $220
  10272b:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102730:	e9 10 f7 ff ff       	jmp    101e45 <__alltraps>

00102735 <vector221>:
.globl vector221
vector221:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $221
  102737:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10273c:	e9 04 f7 ff ff       	jmp    101e45 <__alltraps>

00102741 <vector222>:
.globl vector222
vector222:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $222
  102743:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102748:	e9 f8 f6 ff ff       	jmp    101e45 <__alltraps>

0010274d <vector223>:
.globl vector223
vector223:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $223
  10274f:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102754:	e9 ec f6 ff ff       	jmp    101e45 <__alltraps>

00102759 <vector224>:
.globl vector224
vector224:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $224
  10275b:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102760:	e9 e0 f6 ff ff       	jmp    101e45 <__alltraps>

00102765 <vector225>:
.globl vector225
vector225:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $225
  102767:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10276c:	e9 d4 f6 ff ff       	jmp    101e45 <__alltraps>

00102771 <vector226>:
.globl vector226
vector226:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $226
  102773:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102778:	e9 c8 f6 ff ff       	jmp    101e45 <__alltraps>

0010277d <vector227>:
.globl vector227
vector227:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $227
  10277f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102784:	e9 bc f6 ff ff       	jmp    101e45 <__alltraps>

00102789 <vector228>:
.globl vector228
vector228:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $228
  10278b:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102790:	e9 b0 f6 ff ff       	jmp    101e45 <__alltraps>

00102795 <vector229>:
.globl vector229
vector229:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $229
  102797:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10279c:	e9 a4 f6 ff ff       	jmp    101e45 <__alltraps>

001027a1 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $230
  1027a3:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027a8:	e9 98 f6 ff ff       	jmp    101e45 <__alltraps>

001027ad <vector231>:
.globl vector231
vector231:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $231
  1027af:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027b4:	e9 8c f6 ff ff       	jmp    101e45 <__alltraps>

001027b9 <vector232>:
.globl vector232
vector232:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $232
  1027bb:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027c0:	e9 80 f6 ff ff       	jmp    101e45 <__alltraps>

001027c5 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $233
  1027c7:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027cc:	e9 74 f6 ff ff       	jmp    101e45 <__alltraps>

001027d1 <vector234>:
.globl vector234
vector234:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $234
  1027d3:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027d8:	e9 68 f6 ff ff       	jmp    101e45 <__alltraps>

001027dd <vector235>:
.globl vector235
vector235:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $235
  1027df:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027e4:	e9 5c f6 ff ff       	jmp    101e45 <__alltraps>

001027e9 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $236
  1027eb:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027f0:	e9 50 f6 ff ff       	jmp    101e45 <__alltraps>

001027f5 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $237
  1027f7:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027fc:	e9 44 f6 ff ff       	jmp    101e45 <__alltraps>

00102801 <vector238>:
.globl vector238
vector238:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $238
  102803:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102808:	e9 38 f6 ff ff       	jmp    101e45 <__alltraps>

0010280d <vector239>:
.globl vector239
vector239:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $239
  10280f:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102814:	e9 2c f6 ff ff       	jmp    101e45 <__alltraps>

00102819 <vector240>:
.globl vector240
vector240:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $240
  10281b:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102820:	e9 20 f6 ff ff       	jmp    101e45 <__alltraps>

00102825 <vector241>:
.globl vector241
vector241:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $241
  102827:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10282c:	e9 14 f6 ff ff       	jmp    101e45 <__alltraps>

00102831 <vector242>:
.globl vector242
vector242:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $242
  102833:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102838:	e9 08 f6 ff ff       	jmp    101e45 <__alltraps>

0010283d <vector243>:
.globl vector243
vector243:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $243
  10283f:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102844:	e9 fc f5 ff ff       	jmp    101e45 <__alltraps>

00102849 <vector244>:
.globl vector244
vector244:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $244
  10284b:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102850:	e9 f0 f5 ff ff       	jmp    101e45 <__alltraps>

00102855 <vector245>:
.globl vector245
vector245:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $245
  102857:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10285c:	e9 e4 f5 ff ff       	jmp    101e45 <__alltraps>

00102861 <vector246>:
.globl vector246
vector246:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $246
  102863:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102868:	e9 d8 f5 ff ff       	jmp    101e45 <__alltraps>

0010286d <vector247>:
.globl vector247
vector247:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $247
  10286f:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102874:	e9 cc f5 ff ff       	jmp    101e45 <__alltraps>

00102879 <vector248>:
.globl vector248
vector248:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $248
  10287b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102880:	e9 c0 f5 ff ff       	jmp    101e45 <__alltraps>

00102885 <vector249>:
.globl vector249
vector249:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $249
  102887:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10288c:	e9 b4 f5 ff ff       	jmp    101e45 <__alltraps>

00102891 <vector250>:
.globl vector250
vector250:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $250
  102893:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102898:	e9 a8 f5 ff ff       	jmp    101e45 <__alltraps>

0010289d <vector251>:
.globl vector251
vector251:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $251
  10289f:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028a4:	e9 9c f5 ff ff       	jmp    101e45 <__alltraps>

001028a9 <vector252>:
.globl vector252
vector252:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $252
  1028ab:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028b0:	e9 90 f5 ff ff       	jmp    101e45 <__alltraps>

001028b5 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $253
  1028b7:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028bc:	e9 84 f5 ff ff       	jmp    101e45 <__alltraps>

001028c1 <vector254>:
.globl vector254
vector254:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $254
  1028c3:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028c8:	e9 78 f5 ff ff       	jmp    101e45 <__alltraps>

001028cd <vector255>:
.globl vector255
vector255:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $255
  1028cf:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028d4:	e9 6c f5 ff ff       	jmp    101e45 <__alltraps>

001028d9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028d9:	55                   	push   %ebp
  1028da:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028dc:	8b 55 08             	mov    0x8(%ebp),%edx
  1028df:	a1 24 af 11 00       	mov    0x11af24,%eax
  1028e4:	29 c2                	sub    %eax,%edx
  1028e6:	89 d0                	mov    %edx,%eax
  1028e8:	c1 f8 02             	sar    $0x2,%eax
  1028eb:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028f1:	5d                   	pop    %ebp
  1028f2:	c3                   	ret    

001028f3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028f3:	55                   	push   %ebp
  1028f4:	89 e5                	mov    %esp,%ebp
  1028f6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1028fc:	89 04 24             	mov    %eax,(%esp)
  1028ff:	e8 d5 ff ff ff       	call   1028d9 <page2ppn>
  102904:	c1 e0 0c             	shl    $0xc,%eax
}
  102907:	c9                   	leave  
  102908:	c3                   	ret    

00102909 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102909:	55                   	push   %ebp
  10290a:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10290c:	8b 45 08             	mov    0x8(%ebp),%eax
  10290f:	8b 00                	mov    (%eax),%eax
}
  102911:	5d                   	pop    %ebp
  102912:	c3                   	ret    

00102913 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102913:	55                   	push   %ebp
  102914:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102916:	8b 45 08             	mov    0x8(%ebp),%eax
  102919:	8b 55 0c             	mov    0xc(%ebp),%edx
  10291c:	89 10                	mov    %edx,(%eax)
}
  10291e:	5d                   	pop    %ebp
  10291f:	c3                   	ret    

00102920 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  102920:	55                   	push   %ebp
  102921:	89 e5                	mov    %esp,%ebp
  102923:	83 ec 10             	sub    $0x10,%esp
  102926:	c7 45 fc 10 af 11 00 	movl   $0x11af10,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10292d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102930:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102933:	89 50 04             	mov    %edx,0x4(%eax)
  102936:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102939:	8b 50 04             	mov    0x4(%eax),%edx
  10293c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10293f:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102941:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  102948:	00 00 00 
}
  10294b:	c9                   	leave  
  10294c:	c3                   	ret    

0010294d <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  10294d:	55                   	push   %ebp
  10294e:	89 e5                	mov    %esp,%ebp
  102950:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102953:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102957:	75 24                	jne    10297d <default_init_memmap+0x30>
  102959:	c7 44 24 0c 90 67 10 	movl   $0x106790,0xc(%esp)
  102960:	00 
  102961:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  102968:	00 
  102969:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  102970:	00 
  102971:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  102978:	e8 63 e3 ff ff       	call   100ce0 <__panic>
// 设置当前页向后的n个页
    struct Page *p = base;
  10297d:	8b 45 08             	mov    0x8(%ebp),%eax
  102980:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102983:	eb 7d                	jmp    102a02 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  102985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102988:	83 c0 04             	add    $0x4,%eax
  10298b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102992:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102998:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10299b:	0f a3 10             	bt     %edx,(%eax)
  10299e:	19 c0                	sbb    %eax,%eax
  1029a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1029a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1029a7:	0f 95 c0             	setne  %al
  1029aa:	0f b6 c0             	movzbl %al,%eax
  1029ad:	85 c0                	test   %eax,%eax
  1029af:	75 24                	jne    1029d5 <default_init_memmap+0x88>
  1029b1:	c7 44 24 0c c1 67 10 	movl   $0x1067c1,0xc(%esp)
  1029b8:	00 
  1029b9:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1029c0:	00 
  1029c1:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  1029c8:	00 
  1029c9:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1029d0:	e8 0b e3 ff ff       	call   100ce0 <__panic>
        p->flags = p->property = 0;
  1029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029e2:	8b 50 08             	mov    0x8(%eax),%edx
  1029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029e8:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1029eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029f2:	00 
  1029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029f6:	89 04 24             	mov    %eax,(%esp)
  1029f9:	e8 15 ff ff ff       	call   102913 <set_page_ref>
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
// 设置当前页向后的n个页
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1029fe:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a05:	89 d0                	mov    %edx,%eax
  102a07:	c1 e0 02             	shl    $0x2,%eax
  102a0a:	01 d0                	add    %edx,%eax
  102a0c:	c1 e0 02             	shl    $0x2,%eax
  102a0f:	89 c2                	mov    %eax,%edx
  102a11:	8b 45 08             	mov    0x8(%ebp),%eax
  102a14:	01 d0                	add    %edx,%eax
  102a16:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a19:	0f 85 66 ff ff ff    	jne    102985 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
 // 设置free pages的数量
    base->property = n;
  102a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a22:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a25:	89 50 08             	mov    %edx,0x8(%eax)
// 设置当前页为可用
    SetPageProperty(base);
  102a28:	8b 45 08             	mov    0x8(%ebp),%eax
  102a2b:	83 c0 04             	add    $0x4,%eax
  102a2e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102a35:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102a3e:	0f ab 10             	bts    %edx,(%eax)
// 设置总共的空闲内存页面
    nr_free += n;
  102a41:	8b 15 18 af 11 00    	mov    0x11af18,%edx
  102a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a4a:	01 d0                	add    %edx,%eax
  102a4c:	a3 18 af 11 00       	mov    %eax,0x11af18
    list_add_before(&free_list, &(base->page_link));
  102a51:	8b 45 08             	mov    0x8(%ebp),%eax
  102a54:	83 c0 0c             	add    $0xc,%eax
  102a57:	c7 45 dc 10 af 11 00 	movl   $0x11af10,-0x24(%ebp)
  102a5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a64:	8b 00                	mov    (%eax),%eax
  102a66:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102a69:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102a6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a72:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a75:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a78:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a7b:	89 10                	mov    %edx,(%eax)
  102a7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a80:	8b 10                	mov    (%eax),%edx
  102a82:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a85:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a8b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a8e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a94:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a97:	89 10                	mov    %edx,(%eax)
}
  102a99:	c9                   	leave  
  102a9a:	c3                   	ret    

00102a9b <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a9b:	55                   	push   %ebp
  102a9c:	89 e5                	mov    %esp,%ebp
  102a9e:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102aa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102aa5:	75 24                	jne    102acb <default_alloc_pages+0x30>
  102aa7:	c7 44 24 0c 90 67 10 	movl   $0x106790,0xc(%esp)
  102aae:	00 
  102aaf:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  102ab6:	00 
  102ab7:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  102abe:	00 
  102abf:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  102ac6:	e8 15 e2 ff ff       	call   100ce0 <__panic>
// 如果待分配的空闲页面数量小于所需的内存数量
    if (n > nr_free) {
  102acb:	a1 18 af 11 00       	mov    0x11af18,%eax
  102ad0:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ad3:	73 0a                	jae    102adf <default_alloc_pages+0x44>
        return NULL;
  102ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  102ada:	e9 3d 01 00 00       	jmp    102c1c <default_alloc_pages+0x181>
    }
 // 查找符合要求的连续页
    struct Page *page = NULL;
  102adf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102ae6:	c7 45 f0 10 af 11 00 	movl   $0x11af10,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102aed:	eb 1c                	jmp    102b0b <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102af2:	83 e8 0c             	sub    $0xc,%eax
  102af5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102afb:	8b 40 08             	mov    0x8(%eax),%eax
  102afe:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b01:	72 08                	jb     102b0b <default_alloc_pages+0x70>
            page = p;
  102b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102b09:	eb 18                	jmp    102b23 <default_alloc_pages+0x88>
  102b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b14:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
 // 查找符合要求的连续页
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b1a:	81 7d f0 10 af 11 00 	cmpl   $0x11af10,-0x10(%ebp)
  102b21:	75 cc                	jne    102aef <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102b23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102b27:	0f 84 ec 00 00 00    	je     102c19 <default_alloc_pages+0x17e>
    	if (page->property > n) {
  102b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b30:	8b 40 08             	mov    0x8(%eax),%eax
  102b33:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b36:	0f 86 8c 00 00 00    	jbe    102bc8 <default_alloc_pages+0x12d>
       		struct Page *p = page + n;
  102b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  102b3f:	89 d0                	mov    %edx,%eax
  102b41:	c1 e0 02             	shl    $0x2,%eax
  102b44:	01 d0                	add    %edx,%eax
  102b46:	c1 e0 02             	shl    $0x2,%eax
  102b49:	89 c2                	mov    %eax,%edx
  102b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b4e:	01 d0                	add    %edx,%eax
  102b50:	89 45 e8             	mov    %eax,-0x18(%ebp)
       		p->property = page->property - n;
  102b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b56:	8b 40 08             	mov    0x8(%eax),%eax
  102b59:	2b 45 08             	sub    0x8(%ebp),%eax
  102b5c:	89 c2                	mov    %eax,%edx
  102b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b61:	89 50 08             	mov    %edx,0x8(%eax)
       		SetPageProperty(p);
  102b64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b67:	83 c0 04             	add    $0x4,%eax
  102b6a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102b71:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102b74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b77:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102b7a:	0f ab 10             	bts    %edx,(%eax)
       		// 注意这一步add after
        	list_add_after(&(page->page_link), &(p->page_link));
  102b7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b80:	83 c0 0c             	add    $0xc,%eax
  102b83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b86:	83 c2 0c             	add    $0xc,%edx
  102b89:	89 55 d8             	mov    %edx,-0x28(%ebp)
  102b8c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102b8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b92:	8b 40 04             	mov    0x4(%eax),%eax
  102b95:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b98:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102b9b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b9e:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102ba1:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ba4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102ba7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102baa:	89 10                	mov    %edx,(%eax)
  102bac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102baf:	8b 10                	mov    (%eax),%edx
  102bb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102bb4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102bb7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102bba:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102bbd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102bc0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102bc3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102bc6:	89 10                	mov    %edx,(%eax)
   	    }
    	    list_del(&(page->page_link));
  102bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bcb:	83 c0 0c             	add    $0xc,%eax
  102bce:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102bd1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102bd4:	8b 40 04             	mov    0x4(%eax),%eax
  102bd7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102bda:	8b 12                	mov    (%edx),%edx
  102bdc:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102bdf:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102be2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102be5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102be8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102beb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102bee:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102bf1:	89 10                	mov    %edx,(%eax)
    	    nr_free -= n;
  102bf3:	a1 18 af 11 00       	mov    0x11af18,%eax
  102bf8:	2b 45 08             	sub    0x8(%ebp),%eax
  102bfb:	a3 18 af 11 00       	mov    %eax,0x11af18
    	    ClearPageProperty(page);
  102c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c03:	83 c0 04             	add    $0x4,%eax
  102c06:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102c0d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c10:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102c13:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102c16:	0f b3 10             	btr    %edx,(%eax)
	}
    return page;
  102c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102c1c:	c9                   	leave  
  102c1d:	c3                   	ret    

00102c1e <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102c1e:	55                   	push   %ebp
  102c1f:	89 e5                	mov    %esp,%ebp
  102c21:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c2b:	75 24                	jne    102c51 <default_free_pages+0x33>
  102c2d:	c7 44 24 0c 90 67 10 	movl   $0x106790,0xc(%esp)
  102c34:	00 
  102c35:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  102c3c:	00 
  102c3d:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
  102c44:	00 
  102c45:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  102c4c:	e8 8f e0 ff ff       	call   100ce0 <__panic>
    struct Page *p = base;
  102c51:	8b 45 08             	mov    0x8(%ebp),%eax
  102c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102c57:	e9 9d 00 00 00       	jmp    102cf9 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c5f:	83 c0 04             	add    $0x4,%eax
  102c62:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102c69:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c72:	0f a3 10             	bt     %edx,(%eax)
  102c75:	19 c0                	sbb    %eax,%eax
  102c77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102c7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c7e:	0f 95 c0             	setne  %al
  102c81:	0f b6 c0             	movzbl %al,%eax
  102c84:	85 c0                	test   %eax,%eax
  102c86:	75 2c                	jne    102cb4 <default_free_pages+0x96>
  102c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c8b:	83 c0 04             	add    $0x4,%eax
  102c8e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102c95:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102c9e:	0f a3 10             	bt     %edx,(%eax)
  102ca1:	19 c0                	sbb    %eax,%eax
  102ca3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102ca6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102caa:	0f 95 c0             	setne  %al
  102cad:	0f b6 c0             	movzbl %al,%eax
  102cb0:	85 c0                	test   %eax,%eax
  102cb2:	74 24                	je     102cd8 <default_free_pages+0xba>
  102cb4:	c7 44 24 0c d4 67 10 	movl   $0x1067d4,0xc(%esp)
  102cbb:	00 
  102cbc:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  102cc3:	00 
  102cc4:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  102ccb:	00 
  102ccc:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  102cd3:	e8 08 e0 ff ff       	call   100ce0 <__panic>
        p->flags = 0;
  102cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102ce2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102ce9:	00 
  102cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ced:	89 04 24             	mov    %eax,(%esp)
  102cf0:	e8 1e fc ff ff       	call   102913 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102cf5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cfc:	89 d0                	mov    %edx,%eax
  102cfe:	c1 e0 02             	shl    $0x2,%eax
  102d01:	01 d0                	add    %edx,%eax
  102d03:	c1 e0 02             	shl    $0x2,%eax
  102d06:	89 c2                	mov    %eax,%edx
  102d08:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0b:	01 d0                	add    %edx,%eax
  102d0d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d10:	0f 85 46 ff ff ff    	jne    102c5c <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102d16:	8b 45 08             	mov    0x8(%ebp),%eax
  102d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d1c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d22:	83 c0 04             	add    $0x4,%eax
  102d25:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102d2c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d32:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102d35:	0f ab 10             	bts    %edx,(%eax)
  102d38:	c7 45 cc 10 af 11 00 	movl   $0x11af10,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102d3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d42:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102d48:	e9 08 01 00 00       	jmp    102e55 <default_free_pages+0x237>
        p = le2page(le, page_link);
  102d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d50:	83 e8 0c             	sub    $0xc,%eax
  102d53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d59:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102d5c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d5f:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102d62:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102d65:	8b 45 08             	mov    0x8(%ebp),%eax
  102d68:	8b 50 08             	mov    0x8(%eax),%edx
  102d6b:	89 d0                	mov    %edx,%eax
  102d6d:	c1 e0 02             	shl    $0x2,%eax
  102d70:	01 d0                	add    %edx,%eax
  102d72:	c1 e0 02             	shl    $0x2,%eax
  102d75:	89 c2                	mov    %eax,%edx
  102d77:	8b 45 08             	mov    0x8(%ebp),%eax
  102d7a:	01 d0                	add    %edx,%eax
  102d7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d7f:	75 5a                	jne    102ddb <default_free_pages+0x1bd>
            base->property += p->property;
  102d81:	8b 45 08             	mov    0x8(%ebp),%eax
  102d84:	8b 50 08             	mov    0x8(%eax),%edx
  102d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d8a:	8b 40 08             	mov    0x8(%eax),%eax
  102d8d:	01 c2                	add    %eax,%edx
  102d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d92:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d98:	83 c0 04             	add    $0x4,%eax
  102d9b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102da2:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102da5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102da8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102dab:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  102dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102db1:	83 c0 0c             	add    $0xc,%eax
  102db4:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102db7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102dba:	8b 40 04             	mov    0x4(%eax),%eax
  102dbd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102dc0:	8b 12                	mov    (%edx),%edx
  102dc2:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102dc5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102dc8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102dcb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102dce:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102dd1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102dd4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102dd7:	89 10                	mov    %edx,(%eax)
  102dd9:	eb 7a                	jmp    102e55 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  102ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dde:	8b 50 08             	mov    0x8(%eax),%edx
  102de1:	89 d0                	mov    %edx,%eax
  102de3:	c1 e0 02             	shl    $0x2,%eax
  102de6:	01 d0                	add    %edx,%eax
  102de8:	c1 e0 02             	shl    $0x2,%eax
  102deb:	89 c2                	mov    %eax,%edx
  102ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102df0:	01 d0                	add    %edx,%eax
  102df2:	3b 45 08             	cmp    0x8(%ebp),%eax
  102df5:	75 5e                	jne    102e55 <default_free_pages+0x237>
            p->property += base->property;
  102df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dfa:	8b 50 08             	mov    0x8(%eax),%edx
  102dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  102e00:	8b 40 08             	mov    0x8(%eax),%eax
  102e03:	01 c2                	add    %eax,%edx
  102e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e08:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0e:	83 c0 04             	add    $0x4,%eax
  102e11:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102e18:	89 45 ac             	mov    %eax,-0x54(%ebp)
  102e1b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102e1e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102e21:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  102e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e27:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e2d:	83 c0 0c             	add    $0xc,%eax
  102e30:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102e33:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102e36:	8b 40 04             	mov    0x4(%eax),%eax
  102e39:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102e3c:	8b 12                	mov    (%edx),%edx
  102e3e:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102e41:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102e44:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102e47:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102e4a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e4d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102e50:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e53:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  102e55:	81 7d f0 10 af 11 00 	cmpl   $0x11af10,-0x10(%ebp)
  102e5c:	0f 85 eb fe ff ff    	jne    102d4d <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
  102e62:	8b 15 18 af 11 00    	mov    0x11af18,%edx
  102e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e6b:	01 d0                	add    %edx,%eax
  102e6d:	a3 18 af 11 00       	mov    %eax,0x11af18
  102e72:	c7 45 9c 10 af 11 00 	movl   $0x11af10,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102e79:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102e7c:	8b 40 04             	mov    0x4(%eax),%eax
#if 0
    list_add(&free_list, &(base->page_link));
#else
    // myLAB2 链表按照低地址到高地址的顺序排列，因此要查找插入点
    for(le = list_next(&free_list); le != &free_list; le = list_next(le))
  102e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e82:	eb 76                	jmp    102efa <default_free_pages+0x2dc>
    {
        p = le2page(le, page_link);
  102e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e87:	83 e8 0c             	sub    $0xc,%eax
  102e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  102e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e90:	8b 50 08             	mov    0x8(%eax),%edx
  102e93:	89 d0                	mov    %edx,%eax
  102e95:	c1 e0 02             	shl    $0x2,%eax
  102e98:	01 d0                	add    %edx,%eax
  102e9a:	c1 e0 02             	shl    $0x2,%eax
  102e9d:	89 c2                	mov    %eax,%edx
  102e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea2:	01 d0                	add    %edx,%eax
  102ea4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ea7:	77 42                	ja     102eeb <default_free_pages+0x2cd>
            assert(base + base->property != p);
  102ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  102eac:	8b 50 08             	mov    0x8(%eax),%edx
  102eaf:	89 d0                	mov    %edx,%eax
  102eb1:	c1 e0 02             	shl    $0x2,%eax
  102eb4:	01 d0                	add    %edx,%eax
  102eb6:	c1 e0 02             	shl    $0x2,%eax
  102eb9:	89 c2                	mov    %eax,%edx
  102ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebe:	01 d0                	add    %edx,%eax
  102ec0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ec3:	75 24                	jne    102ee9 <default_free_pages+0x2cb>
  102ec5:	c7 44 24 0c f9 67 10 	movl   $0x1067f9,0xc(%esp)
  102ecc:	00 
  102ecd:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  102ed4:	00 
  102ed5:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  102edc:	00 
  102edd:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  102ee4:	e8 f7 dd ff ff       	call   100ce0 <__panic>
            break;
  102ee9:	eb 18                	jmp    102f03 <default_free_pages+0x2e5>
  102eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eee:	89 45 98             	mov    %eax,-0x68(%ebp)
  102ef1:	8b 45 98             	mov    -0x68(%ebp),%eax
  102ef4:	8b 40 04             	mov    0x4(%eax),%eax
    nr_free += n;
#if 0
    list_add(&free_list, &(base->page_link));
#else
    // myLAB2 链表按照低地址到高地址的顺序排列，因此要查找插入点
    for(le = list_next(&free_list); le != &free_list; le = list_next(le))
  102ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102efa:	81 7d f0 10 af 11 00 	cmpl   $0x11af10,-0x10(%ebp)
  102f01:	75 81                	jne    102e84 <default_free_pages+0x266>
        if (base + base->property <= p) {
            assert(base + base->property != p);
            break;
        }
    }
    list_add_before(le, &(base->page_link));
  102f03:	8b 45 08             	mov    0x8(%ebp),%eax
  102f06:	8d 50 0c             	lea    0xc(%eax),%edx
  102f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f0c:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102f0f:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102f12:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f15:	8b 00                	mov    (%eax),%eax
  102f17:	8b 55 90             	mov    -0x70(%ebp),%edx
  102f1a:	89 55 8c             	mov    %edx,-0x74(%ebp)
  102f1d:	89 45 88             	mov    %eax,-0x78(%ebp)
  102f20:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f23:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102f26:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102f29:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102f2c:	89 10                	mov    %edx,(%eax)
  102f2e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102f31:	8b 10                	mov    (%eax),%edx
  102f33:	8b 45 88             	mov    -0x78(%ebp),%eax
  102f36:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102f39:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102f3c:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102f3f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102f42:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102f45:	8b 55 88             	mov    -0x78(%ebp),%edx
  102f48:	89 10                	mov    %edx,(%eax)
#endif
}
  102f4a:	c9                   	leave  
  102f4b:	c3                   	ret    

00102f4c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102f4c:	55                   	push   %ebp
  102f4d:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102f4f:	a1 18 af 11 00       	mov    0x11af18,%eax
}
  102f54:	5d                   	pop    %ebp
  102f55:	c3                   	ret    

00102f56 <basic_check>:

static void
basic_check(void) {
  102f56:	55                   	push   %ebp
  102f57:	89 e5                	mov    %esp,%ebp
  102f59:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102f5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102f6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f76:	e8 db 0e 00 00       	call   103e56 <alloc_pages>
  102f7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102f82:	75 24                	jne    102fa8 <basic_check+0x52>
  102f84:	c7 44 24 0c 14 68 10 	movl   $0x106814,0xc(%esp)
  102f8b:	00 
  102f8c:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  102f93:	00 
  102f94:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  102f9b:	00 
  102f9c:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  102fa3:	e8 38 dd ff ff       	call   100ce0 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102fa8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102faf:	e8 a2 0e 00 00       	call   103e56 <alloc_pages>
  102fb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102fbb:	75 24                	jne    102fe1 <basic_check+0x8b>
  102fbd:	c7 44 24 0c 30 68 10 	movl   $0x106830,0xc(%esp)
  102fc4:	00 
  102fc5:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  102fcc:	00 
  102fcd:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  102fd4:	00 
  102fd5:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  102fdc:	e8 ff dc ff ff       	call   100ce0 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102fe1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102fe8:	e8 69 0e 00 00       	call   103e56 <alloc_pages>
  102fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ff0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102ff4:	75 24                	jne    10301a <basic_check+0xc4>
  102ff6:	c7 44 24 0c 4c 68 10 	movl   $0x10684c,0xc(%esp)
  102ffd:	00 
  102ffe:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103005:	00 
  103006:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  10300d:	00 
  10300e:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103015:	e8 c6 dc ff ff       	call   100ce0 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  10301a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10301d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103020:	74 10                	je     103032 <basic_check+0xdc>
  103022:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103025:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103028:	74 08                	je     103032 <basic_check+0xdc>
  10302a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10302d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103030:	75 24                	jne    103056 <basic_check+0x100>
  103032:	c7 44 24 0c 68 68 10 	movl   $0x106868,0xc(%esp)
  103039:	00 
  10303a:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103041:	00 
  103042:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  103049:	00 
  10304a:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103051:	e8 8a dc ff ff       	call   100ce0 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  103056:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103059:	89 04 24             	mov    %eax,(%esp)
  10305c:	e8 a8 f8 ff ff       	call   102909 <page_ref>
  103061:	85 c0                	test   %eax,%eax
  103063:	75 1e                	jne    103083 <basic_check+0x12d>
  103065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103068:	89 04 24             	mov    %eax,(%esp)
  10306b:	e8 99 f8 ff ff       	call   102909 <page_ref>
  103070:	85 c0                	test   %eax,%eax
  103072:	75 0f                	jne    103083 <basic_check+0x12d>
  103074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103077:	89 04 24             	mov    %eax,(%esp)
  10307a:	e8 8a f8 ff ff       	call   102909 <page_ref>
  10307f:	85 c0                	test   %eax,%eax
  103081:	74 24                	je     1030a7 <basic_check+0x151>
  103083:	c7 44 24 0c 8c 68 10 	movl   $0x10688c,0xc(%esp)
  10308a:	00 
  10308b:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103092:	00 
  103093:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  10309a:	00 
  10309b:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1030a2:	e8 39 dc ff ff       	call   100ce0 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1030a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030aa:	89 04 24             	mov    %eax,(%esp)
  1030ad:	e8 41 f8 ff ff       	call   1028f3 <page2pa>
  1030b2:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  1030b8:	c1 e2 0c             	shl    $0xc,%edx
  1030bb:	39 d0                	cmp    %edx,%eax
  1030bd:	72 24                	jb     1030e3 <basic_check+0x18d>
  1030bf:	c7 44 24 0c c8 68 10 	movl   $0x1068c8,0xc(%esp)
  1030c6:	00 
  1030c7:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1030ce:	00 
  1030cf:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  1030d6:	00 
  1030d7:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1030de:	e8 fd db ff ff       	call   100ce0 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1030e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030e6:	89 04 24             	mov    %eax,(%esp)
  1030e9:	e8 05 f8 ff ff       	call   1028f3 <page2pa>
  1030ee:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  1030f4:	c1 e2 0c             	shl    $0xc,%edx
  1030f7:	39 d0                	cmp    %edx,%eax
  1030f9:	72 24                	jb     10311f <basic_check+0x1c9>
  1030fb:	c7 44 24 0c e5 68 10 	movl   $0x1068e5,0xc(%esp)
  103102:	00 
  103103:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  10310a:	00 
  10310b:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103112:	00 
  103113:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  10311a:	e8 c1 db ff ff       	call   100ce0 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103122:	89 04 24             	mov    %eax,(%esp)
  103125:	e8 c9 f7 ff ff       	call   1028f3 <page2pa>
  10312a:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  103130:	c1 e2 0c             	shl    $0xc,%edx
  103133:	39 d0                	cmp    %edx,%eax
  103135:	72 24                	jb     10315b <basic_check+0x205>
  103137:	c7 44 24 0c 02 69 10 	movl   $0x106902,0xc(%esp)
  10313e:	00 
  10313f:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103146:	00 
  103147:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  10314e:	00 
  10314f:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103156:	e8 85 db ff ff       	call   100ce0 <__panic>

    list_entry_t free_list_store = free_list;
  10315b:	a1 10 af 11 00       	mov    0x11af10,%eax
  103160:	8b 15 14 af 11 00    	mov    0x11af14,%edx
  103166:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103169:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10316c:	c7 45 e0 10 af 11 00 	movl   $0x11af10,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103173:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103176:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103179:	89 50 04             	mov    %edx,0x4(%eax)
  10317c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10317f:	8b 50 04             	mov    0x4(%eax),%edx
  103182:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103185:	89 10                	mov    %edx,(%eax)
  103187:	c7 45 dc 10 af 11 00 	movl   $0x11af10,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10318e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103191:	8b 40 04             	mov    0x4(%eax),%eax
  103194:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103197:	0f 94 c0             	sete   %al
  10319a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10319d:	85 c0                	test   %eax,%eax
  10319f:	75 24                	jne    1031c5 <basic_check+0x26f>
  1031a1:	c7 44 24 0c 1f 69 10 	movl   $0x10691f,0xc(%esp)
  1031a8:	00 
  1031a9:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1031b0:	00 
  1031b1:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  1031b8:	00 
  1031b9:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1031c0:	e8 1b db ff ff       	call   100ce0 <__panic>

    unsigned int nr_free_store = nr_free;
  1031c5:	a1 18 af 11 00       	mov    0x11af18,%eax
  1031ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1031cd:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  1031d4:	00 00 00 

    assert(alloc_page() == NULL);
  1031d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031de:	e8 73 0c 00 00       	call   103e56 <alloc_pages>
  1031e3:	85 c0                	test   %eax,%eax
  1031e5:	74 24                	je     10320b <basic_check+0x2b5>
  1031e7:	c7 44 24 0c 36 69 10 	movl   $0x106936,0xc(%esp)
  1031ee:	00 
  1031ef:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1031f6:	00 
  1031f7:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  1031fe:	00 
  1031ff:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103206:	e8 d5 da ff ff       	call   100ce0 <__panic>

    free_page(p0);
  10320b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103212:	00 
  103213:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103216:	89 04 24             	mov    %eax,(%esp)
  103219:	e8 70 0c 00 00       	call   103e8e <free_pages>
    free_page(p1);
  10321e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103225:	00 
  103226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103229:	89 04 24             	mov    %eax,(%esp)
  10322c:	e8 5d 0c 00 00       	call   103e8e <free_pages>
    free_page(p2);
  103231:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103238:	00 
  103239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10323c:	89 04 24             	mov    %eax,(%esp)
  10323f:	e8 4a 0c 00 00       	call   103e8e <free_pages>
    assert(nr_free == 3);
  103244:	a1 18 af 11 00       	mov    0x11af18,%eax
  103249:	83 f8 03             	cmp    $0x3,%eax
  10324c:	74 24                	je     103272 <basic_check+0x31c>
  10324e:	c7 44 24 0c 4b 69 10 	movl   $0x10694b,0xc(%esp)
  103255:	00 
  103256:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  10325d:	00 
  10325e:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  103265:	00 
  103266:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  10326d:	e8 6e da ff ff       	call   100ce0 <__panic>

    assert((p0 = alloc_page()) != NULL);
  103272:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103279:	e8 d8 0b 00 00       	call   103e56 <alloc_pages>
  10327e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103281:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103285:	75 24                	jne    1032ab <basic_check+0x355>
  103287:	c7 44 24 0c 14 68 10 	movl   $0x106814,0xc(%esp)
  10328e:	00 
  10328f:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103296:	00 
  103297:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  10329e:	00 
  10329f:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1032a6:	e8 35 da ff ff       	call   100ce0 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1032ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032b2:	e8 9f 0b 00 00       	call   103e56 <alloc_pages>
  1032b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1032be:	75 24                	jne    1032e4 <basic_check+0x38e>
  1032c0:	c7 44 24 0c 30 68 10 	movl   $0x106830,0xc(%esp)
  1032c7:	00 
  1032c8:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1032cf:	00 
  1032d0:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  1032d7:	00 
  1032d8:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1032df:	e8 fc d9 ff ff       	call   100ce0 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1032e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032eb:	e8 66 0b 00 00       	call   103e56 <alloc_pages>
  1032f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032f7:	75 24                	jne    10331d <basic_check+0x3c7>
  1032f9:	c7 44 24 0c 4c 68 10 	movl   $0x10684c,0xc(%esp)
  103300:	00 
  103301:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103308:	00 
  103309:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  103310:	00 
  103311:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103318:	e8 c3 d9 ff ff       	call   100ce0 <__panic>

    assert(alloc_page() == NULL);
  10331d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103324:	e8 2d 0b 00 00       	call   103e56 <alloc_pages>
  103329:	85 c0                	test   %eax,%eax
  10332b:	74 24                	je     103351 <basic_check+0x3fb>
  10332d:	c7 44 24 0c 36 69 10 	movl   $0x106936,0xc(%esp)
  103334:	00 
  103335:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  10333c:	00 
  10333d:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  103344:	00 
  103345:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  10334c:	e8 8f d9 ff ff       	call   100ce0 <__panic>

    free_page(p0);
  103351:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103358:	00 
  103359:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10335c:	89 04 24             	mov    %eax,(%esp)
  10335f:	e8 2a 0b 00 00       	call   103e8e <free_pages>
  103364:	c7 45 d8 10 af 11 00 	movl   $0x11af10,-0x28(%ebp)
  10336b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10336e:	8b 40 04             	mov    0x4(%eax),%eax
  103371:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103374:	0f 94 c0             	sete   %al
  103377:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10337a:	85 c0                	test   %eax,%eax
  10337c:	74 24                	je     1033a2 <basic_check+0x44c>
  10337e:	c7 44 24 0c 58 69 10 	movl   $0x106958,0xc(%esp)
  103385:	00 
  103386:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  10338d:	00 
  10338e:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  103395:	00 
  103396:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  10339d:	e8 3e d9 ff ff       	call   100ce0 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1033a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033a9:	e8 a8 0a 00 00       	call   103e56 <alloc_pages>
  1033ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1033b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1033b7:	74 24                	je     1033dd <basic_check+0x487>
  1033b9:	c7 44 24 0c 70 69 10 	movl   $0x106970,0xc(%esp)
  1033c0:	00 
  1033c1:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1033c8:	00 
  1033c9:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  1033d0:	00 
  1033d1:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1033d8:	e8 03 d9 ff ff       	call   100ce0 <__panic>
    assert(alloc_page() == NULL);
  1033dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033e4:	e8 6d 0a 00 00       	call   103e56 <alloc_pages>
  1033e9:	85 c0                	test   %eax,%eax
  1033eb:	74 24                	je     103411 <basic_check+0x4bb>
  1033ed:	c7 44 24 0c 36 69 10 	movl   $0x106936,0xc(%esp)
  1033f4:	00 
  1033f5:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1033fc:	00 
  1033fd:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  103404:	00 
  103405:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  10340c:	e8 cf d8 ff ff       	call   100ce0 <__panic>

    assert(nr_free == 0);
  103411:	a1 18 af 11 00       	mov    0x11af18,%eax
  103416:	85 c0                	test   %eax,%eax
  103418:	74 24                	je     10343e <basic_check+0x4e8>
  10341a:	c7 44 24 0c 89 69 10 	movl   $0x106989,0xc(%esp)
  103421:	00 
  103422:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103429:	00 
  10342a:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  103431:	00 
  103432:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103439:	e8 a2 d8 ff ff       	call   100ce0 <__panic>
    free_list = free_list_store;
  10343e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103441:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103444:	a3 10 af 11 00       	mov    %eax,0x11af10
  103449:	89 15 14 af 11 00    	mov    %edx,0x11af14
    nr_free = nr_free_store;
  10344f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103452:	a3 18 af 11 00       	mov    %eax,0x11af18

    free_page(p);
  103457:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10345e:	00 
  10345f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103462:	89 04 24             	mov    %eax,(%esp)
  103465:	e8 24 0a 00 00       	call   103e8e <free_pages>
    free_page(p1);
  10346a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103471:	00 
  103472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103475:	89 04 24             	mov    %eax,(%esp)
  103478:	e8 11 0a 00 00       	call   103e8e <free_pages>
    free_page(p2);
  10347d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103484:	00 
  103485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103488:	89 04 24             	mov    %eax,(%esp)
  10348b:	e8 fe 09 00 00       	call   103e8e <free_pages>
}
  103490:	c9                   	leave  
  103491:	c3                   	ret    

00103492 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103492:	55                   	push   %ebp
  103493:	89 e5                	mov    %esp,%ebp
  103495:	53                   	push   %ebx
  103496:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  10349c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1034a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1034aa:	c7 45 ec 10 af 11 00 	movl   $0x11af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1034b1:	eb 6b                	jmp    10351e <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1034b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034b6:	83 e8 0c             	sub    $0xc,%eax
  1034b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1034bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034bf:	83 c0 04             	add    $0x4,%eax
  1034c2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1034c9:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1034cf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1034d2:	0f a3 10             	bt     %edx,(%eax)
  1034d5:	19 c0                	sbb    %eax,%eax
  1034d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1034da:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1034de:	0f 95 c0             	setne  %al
  1034e1:	0f b6 c0             	movzbl %al,%eax
  1034e4:	85 c0                	test   %eax,%eax
  1034e6:	75 24                	jne    10350c <default_check+0x7a>
  1034e8:	c7 44 24 0c 96 69 10 	movl   $0x106996,0xc(%esp)
  1034ef:	00 
  1034f0:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1034f7:	00 
  1034f8:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1034ff:	00 
  103500:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103507:	e8 d4 d7 ff ff       	call   100ce0 <__panic>
        count ++, total += p->property;
  10350c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103510:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103513:	8b 50 08             	mov    0x8(%eax),%edx
  103516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103519:	01 d0                	add    %edx,%eax
  10351b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10351e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103521:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103524:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103527:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10352a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10352d:	81 7d ec 10 af 11 00 	cmpl   $0x11af10,-0x14(%ebp)
  103534:	0f 85 79 ff ff ff    	jne    1034b3 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10353a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  10353d:	e8 7e 09 00 00       	call   103ec0 <nr_free_pages>
  103542:	39 c3                	cmp    %eax,%ebx
  103544:	74 24                	je     10356a <default_check+0xd8>
  103546:	c7 44 24 0c a6 69 10 	movl   $0x1069a6,0xc(%esp)
  10354d:	00 
  10354e:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103555:	00 
  103556:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  10355d:	00 
  10355e:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103565:	e8 76 d7 ff ff       	call   100ce0 <__panic>

    basic_check();
  10356a:	e8 e7 f9 ff ff       	call   102f56 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10356f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103576:	e8 db 08 00 00       	call   103e56 <alloc_pages>
  10357b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  10357e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103582:	75 24                	jne    1035a8 <default_check+0x116>
  103584:	c7 44 24 0c bf 69 10 	movl   $0x1069bf,0xc(%esp)
  10358b:	00 
  10358c:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103593:	00 
  103594:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  10359b:	00 
  10359c:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1035a3:	e8 38 d7 ff ff       	call   100ce0 <__panic>
    assert(!PageProperty(p0));
  1035a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035ab:	83 c0 04             	add    $0x4,%eax
  1035ae:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1035b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035b8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1035bb:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1035be:	0f a3 10             	bt     %edx,(%eax)
  1035c1:	19 c0                	sbb    %eax,%eax
  1035c3:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1035c6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1035ca:	0f 95 c0             	setne  %al
  1035cd:	0f b6 c0             	movzbl %al,%eax
  1035d0:	85 c0                	test   %eax,%eax
  1035d2:	74 24                	je     1035f8 <default_check+0x166>
  1035d4:	c7 44 24 0c ca 69 10 	movl   $0x1069ca,0xc(%esp)
  1035db:	00 
  1035dc:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1035e3:	00 
  1035e4:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  1035eb:	00 
  1035ec:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1035f3:	e8 e8 d6 ff ff       	call   100ce0 <__panic>

    list_entry_t free_list_store = free_list;
  1035f8:	a1 10 af 11 00       	mov    0x11af10,%eax
  1035fd:	8b 15 14 af 11 00    	mov    0x11af14,%edx
  103603:	89 45 80             	mov    %eax,-0x80(%ebp)
  103606:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103609:	c7 45 b4 10 af 11 00 	movl   $0x11af10,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103610:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103613:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103616:	89 50 04             	mov    %edx,0x4(%eax)
  103619:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10361c:	8b 50 04             	mov    0x4(%eax),%edx
  10361f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103622:	89 10                	mov    %edx,(%eax)
  103624:	c7 45 b0 10 af 11 00 	movl   $0x11af10,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10362b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10362e:	8b 40 04             	mov    0x4(%eax),%eax
  103631:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103634:	0f 94 c0             	sete   %al
  103637:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10363a:	85 c0                	test   %eax,%eax
  10363c:	75 24                	jne    103662 <default_check+0x1d0>
  10363e:	c7 44 24 0c 1f 69 10 	movl   $0x10691f,0xc(%esp)
  103645:	00 
  103646:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  10364d:	00 
  10364e:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  103655:	00 
  103656:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  10365d:	e8 7e d6 ff ff       	call   100ce0 <__panic>
    assert(alloc_page() == NULL);
  103662:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103669:	e8 e8 07 00 00       	call   103e56 <alloc_pages>
  10366e:	85 c0                	test   %eax,%eax
  103670:	74 24                	je     103696 <default_check+0x204>
  103672:	c7 44 24 0c 36 69 10 	movl   $0x106936,0xc(%esp)
  103679:	00 
  10367a:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103681:	00 
  103682:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  103689:	00 
  10368a:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103691:	e8 4a d6 ff ff       	call   100ce0 <__panic>

    unsigned int nr_free_store = nr_free;
  103696:	a1 18 af 11 00       	mov    0x11af18,%eax
  10369b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  10369e:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  1036a5:	00 00 00 

    free_pages(p0 + 2, 3);
  1036a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036ab:	83 c0 28             	add    $0x28,%eax
  1036ae:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1036b5:	00 
  1036b6:	89 04 24             	mov    %eax,(%esp)
  1036b9:	e8 d0 07 00 00       	call   103e8e <free_pages>
    assert(alloc_pages(4) == NULL);
  1036be:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1036c5:	e8 8c 07 00 00       	call   103e56 <alloc_pages>
  1036ca:	85 c0                	test   %eax,%eax
  1036cc:	74 24                	je     1036f2 <default_check+0x260>
  1036ce:	c7 44 24 0c dc 69 10 	movl   $0x1069dc,0xc(%esp)
  1036d5:	00 
  1036d6:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1036dd:	00 
  1036de:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  1036e5:	00 
  1036e6:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1036ed:	e8 ee d5 ff ff       	call   100ce0 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1036f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036f5:	83 c0 28             	add    $0x28,%eax
  1036f8:	83 c0 04             	add    $0x4,%eax
  1036fb:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103702:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103705:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103708:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10370b:	0f a3 10             	bt     %edx,(%eax)
  10370e:	19 c0                	sbb    %eax,%eax
  103710:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103713:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103717:	0f 95 c0             	setne  %al
  10371a:	0f b6 c0             	movzbl %al,%eax
  10371d:	85 c0                	test   %eax,%eax
  10371f:	74 0e                	je     10372f <default_check+0x29d>
  103721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103724:	83 c0 28             	add    $0x28,%eax
  103727:	8b 40 08             	mov    0x8(%eax),%eax
  10372a:	83 f8 03             	cmp    $0x3,%eax
  10372d:	74 24                	je     103753 <default_check+0x2c1>
  10372f:	c7 44 24 0c f4 69 10 	movl   $0x1069f4,0xc(%esp)
  103736:	00 
  103737:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  10373e:	00 
  10373f:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  103746:	00 
  103747:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  10374e:	e8 8d d5 ff ff       	call   100ce0 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103753:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10375a:	e8 f7 06 00 00       	call   103e56 <alloc_pages>
  10375f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103762:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103766:	75 24                	jne    10378c <default_check+0x2fa>
  103768:	c7 44 24 0c 20 6a 10 	movl   $0x106a20,0xc(%esp)
  10376f:	00 
  103770:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103777:	00 
  103778:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  10377f:	00 
  103780:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103787:	e8 54 d5 ff ff       	call   100ce0 <__panic>
    assert(alloc_page() == NULL);
  10378c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103793:	e8 be 06 00 00       	call   103e56 <alloc_pages>
  103798:	85 c0                	test   %eax,%eax
  10379a:	74 24                	je     1037c0 <default_check+0x32e>
  10379c:	c7 44 24 0c 36 69 10 	movl   $0x106936,0xc(%esp)
  1037a3:	00 
  1037a4:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1037ab:	00 
  1037ac:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  1037b3:	00 
  1037b4:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1037bb:	e8 20 d5 ff ff       	call   100ce0 <__panic>
    assert(p0 + 2 == p1);
  1037c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037c3:	83 c0 28             	add    $0x28,%eax
  1037c6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1037c9:	74 24                	je     1037ef <default_check+0x35d>
  1037cb:	c7 44 24 0c 3e 6a 10 	movl   $0x106a3e,0xc(%esp)
  1037d2:	00 
  1037d3:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1037da:	00 
  1037db:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  1037e2:	00 
  1037e3:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1037ea:	e8 f1 d4 ff ff       	call   100ce0 <__panic>

    p2 = p0 + 1;
  1037ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037f2:	83 c0 14             	add    $0x14,%eax
  1037f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1037f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037ff:	00 
  103800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103803:	89 04 24             	mov    %eax,(%esp)
  103806:	e8 83 06 00 00       	call   103e8e <free_pages>
    free_pages(p1, 3);
  10380b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103812:	00 
  103813:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103816:	89 04 24             	mov    %eax,(%esp)
  103819:	e8 70 06 00 00       	call   103e8e <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10381e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103821:	83 c0 04             	add    $0x4,%eax
  103824:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10382b:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10382e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103831:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103834:	0f a3 10             	bt     %edx,(%eax)
  103837:	19 c0                	sbb    %eax,%eax
  103839:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10383c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103840:	0f 95 c0             	setne  %al
  103843:	0f b6 c0             	movzbl %al,%eax
  103846:	85 c0                	test   %eax,%eax
  103848:	74 0b                	je     103855 <default_check+0x3c3>
  10384a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10384d:	8b 40 08             	mov    0x8(%eax),%eax
  103850:	83 f8 01             	cmp    $0x1,%eax
  103853:	74 24                	je     103879 <default_check+0x3e7>
  103855:	c7 44 24 0c 4c 6a 10 	movl   $0x106a4c,0xc(%esp)
  10385c:	00 
  10385d:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103864:	00 
  103865:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  10386c:	00 
  10386d:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103874:	e8 67 d4 ff ff       	call   100ce0 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103879:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10387c:	83 c0 04             	add    $0x4,%eax
  10387f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103886:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103889:	8b 45 90             	mov    -0x70(%ebp),%eax
  10388c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10388f:	0f a3 10             	bt     %edx,(%eax)
  103892:	19 c0                	sbb    %eax,%eax
  103894:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103897:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10389b:	0f 95 c0             	setne  %al
  10389e:	0f b6 c0             	movzbl %al,%eax
  1038a1:	85 c0                	test   %eax,%eax
  1038a3:	74 0b                	je     1038b0 <default_check+0x41e>
  1038a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1038a8:	8b 40 08             	mov    0x8(%eax),%eax
  1038ab:	83 f8 03             	cmp    $0x3,%eax
  1038ae:	74 24                	je     1038d4 <default_check+0x442>
  1038b0:	c7 44 24 0c 74 6a 10 	movl   $0x106a74,0xc(%esp)
  1038b7:	00 
  1038b8:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1038bf:	00 
  1038c0:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  1038c7:	00 
  1038c8:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1038cf:	e8 0c d4 ff ff       	call   100ce0 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1038d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038db:	e8 76 05 00 00       	call   103e56 <alloc_pages>
  1038e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038e6:	83 e8 14             	sub    $0x14,%eax
  1038e9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1038ec:	74 24                	je     103912 <default_check+0x480>
  1038ee:	c7 44 24 0c 9a 6a 10 	movl   $0x106a9a,0xc(%esp)
  1038f5:	00 
  1038f6:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1038fd:	00 
  1038fe:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  103905:	00 
  103906:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  10390d:	e8 ce d3 ff ff       	call   100ce0 <__panic>
    free_page(p0);
  103912:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103919:	00 
  10391a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10391d:	89 04 24             	mov    %eax,(%esp)
  103920:	e8 69 05 00 00       	call   103e8e <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103925:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10392c:	e8 25 05 00 00       	call   103e56 <alloc_pages>
  103931:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103934:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103937:	83 c0 14             	add    $0x14,%eax
  10393a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10393d:	74 24                	je     103963 <default_check+0x4d1>
  10393f:	c7 44 24 0c b8 6a 10 	movl   $0x106ab8,0xc(%esp)
  103946:	00 
  103947:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  10394e:	00 
  10394f:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  103956:	00 
  103957:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  10395e:	e8 7d d3 ff ff       	call   100ce0 <__panic>

    free_pages(p0, 2);
  103963:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10396a:	00 
  10396b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10396e:	89 04 24             	mov    %eax,(%esp)
  103971:	e8 18 05 00 00       	call   103e8e <free_pages>
    free_page(p2);
  103976:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10397d:	00 
  10397e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103981:	89 04 24             	mov    %eax,(%esp)
  103984:	e8 05 05 00 00       	call   103e8e <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103989:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103990:	e8 c1 04 00 00       	call   103e56 <alloc_pages>
  103995:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103998:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10399c:	75 24                	jne    1039c2 <default_check+0x530>
  10399e:	c7 44 24 0c d8 6a 10 	movl   $0x106ad8,0xc(%esp)
  1039a5:	00 
  1039a6:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1039ad:	00 
  1039ae:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  1039b5:	00 
  1039b6:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1039bd:	e8 1e d3 ff ff       	call   100ce0 <__panic>
    assert(alloc_page() == NULL);
  1039c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039c9:	e8 88 04 00 00       	call   103e56 <alloc_pages>
  1039ce:	85 c0                	test   %eax,%eax
  1039d0:	74 24                	je     1039f6 <default_check+0x564>
  1039d2:	c7 44 24 0c 36 69 10 	movl   $0x106936,0xc(%esp)
  1039d9:	00 
  1039da:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  1039e1:	00 
  1039e2:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  1039e9:	00 
  1039ea:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  1039f1:	e8 ea d2 ff ff       	call   100ce0 <__panic>

    assert(nr_free == 0);
  1039f6:	a1 18 af 11 00       	mov    0x11af18,%eax
  1039fb:	85 c0                	test   %eax,%eax
  1039fd:	74 24                	je     103a23 <default_check+0x591>
  1039ff:	c7 44 24 0c 89 69 10 	movl   $0x106989,0xc(%esp)
  103a06:	00 
  103a07:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103a0e:	00 
  103a0f:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  103a16:	00 
  103a17:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103a1e:	e8 bd d2 ff ff       	call   100ce0 <__panic>
    nr_free = nr_free_store;
  103a23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103a26:	a3 18 af 11 00       	mov    %eax,0x11af18

    free_list = free_list_store;
  103a2b:	8b 45 80             	mov    -0x80(%ebp),%eax
  103a2e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103a31:	a3 10 af 11 00       	mov    %eax,0x11af10
  103a36:	89 15 14 af 11 00    	mov    %edx,0x11af14
    free_pages(p0, 5);
  103a3c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103a43:	00 
  103a44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a47:	89 04 24             	mov    %eax,(%esp)
  103a4a:	e8 3f 04 00 00       	call   103e8e <free_pages>

    le = &free_list;
  103a4f:	c7 45 ec 10 af 11 00 	movl   $0x11af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103a56:	eb 5b                	jmp    103ab3 <default_check+0x621>
        assert(le->next->prev == le && le->prev->next == le);
  103a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a5b:	8b 40 04             	mov    0x4(%eax),%eax
  103a5e:	8b 00                	mov    (%eax),%eax
  103a60:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103a63:	75 0d                	jne    103a72 <default_check+0x5e0>
  103a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a68:	8b 00                	mov    (%eax),%eax
  103a6a:	8b 40 04             	mov    0x4(%eax),%eax
  103a6d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103a70:	74 24                	je     103a96 <default_check+0x604>
  103a72:	c7 44 24 0c f8 6a 10 	movl   $0x106af8,0xc(%esp)
  103a79:	00 
  103a7a:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103a81:	00 
  103a82:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
  103a89:	00 
  103a8a:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103a91:	e8 4a d2 ff ff       	call   100ce0 <__panic>
        struct Page *p = le2page(le, page_link);
  103a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a99:	83 e8 0c             	sub    $0xc,%eax
  103a9c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103a9f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103aa3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103aa6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103aa9:	8b 40 08             	mov    0x8(%eax),%eax
  103aac:	29 c2                	sub    %eax,%edx
  103aae:	89 d0                	mov    %edx,%eax
  103ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ab6:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103ab9:	8b 45 88             	mov    -0x78(%ebp),%eax
  103abc:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103abf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103ac2:	81 7d ec 10 af 11 00 	cmpl   $0x11af10,-0x14(%ebp)
  103ac9:	75 8d                	jne    103a58 <default_check+0x5c6>
        assert(le->next->prev == le && le->prev->next == le);
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103acb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103acf:	74 24                	je     103af5 <default_check+0x663>
  103ad1:	c7 44 24 0c 25 6b 10 	movl   $0x106b25,0xc(%esp)
  103ad8:	00 
  103ad9:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103ae0:	00 
  103ae1:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
  103ae8:	00 
  103ae9:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103af0:	e8 eb d1 ff ff       	call   100ce0 <__panic>
    assert(total == 0);
  103af5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103af9:	74 24                	je     103b1f <default_check+0x68d>
  103afb:	c7 44 24 0c 30 6b 10 	movl   $0x106b30,0xc(%esp)
  103b02:	00 
  103b03:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  103b0a:	00 
  103b0b:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
  103b12:	00 
  103b13:	c7 04 24 ab 67 10 00 	movl   $0x1067ab,(%esp)
  103b1a:	e8 c1 d1 ff ff       	call   100ce0 <__panic>
}
  103b1f:	81 c4 94 00 00 00    	add    $0x94,%esp
  103b25:	5b                   	pop    %ebx
  103b26:	5d                   	pop    %ebp
  103b27:	c3                   	ret    

00103b28 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103b28:	55                   	push   %ebp
  103b29:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  103b2e:	a1 24 af 11 00       	mov    0x11af24,%eax
  103b33:	29 c2                	sub    %eax,%edx
  103b35:	89 d0                	mov    %edx,%eax
  103b37:	c1 f8 02             	sar    $0x2,%eax
  103b3a:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103b40:	5d                   	pop    %ebp
  103b41:	c3                   	ret    

00103b42 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103b42:	55                   	push   %ebp
  103b43:	89 e5                	mov    %esp,%ebp
  103b45:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103b48:	8b 45 08             	mov    0x8(%ebp),%eax
  103b4b:	89 04 24             	mov    %eax,(%esp)
  103b4e:	e8 d5 ff ff ff       	call   103b28 <page2ppn>
  103b53:	c1 e0 0c             	shl    $0xc,%eax
}
  103b56:	c9                   	leave  
  103b57:	c3                   	ret    

00103b58 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103b58:	55                   	push   %ebp
  103b59:	89 e5                	mov    %esp,%ebp
  103b5b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  103b61:	c1 e8 0c             	shr    $0xc,%eax
  103b64:	89 c2                	mov    %eax,%edx
  103b66:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103b6b:	39 c2                	cmp    %eax,%edx
  103b6d:	72 1c                	jb     103b8b <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103b6f:	c7 44 24 08 6c 6b 10 	movl   $0x106b6c,0x8(%esp)
  103b76:	00 
  103b77:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103b7e:	00 
  103b7f:	c7 04 24 8b 6b 10 00 	movl   $0x106b8b,(%esp)
  103b86:	e8 55 d1 ff ff       	call   100ce0 <__panic>
    }
    return &pages[PPN(pa)];
  103b8b:	8b 0d 24 af 11 00    	mov    0x11af24,%ecx
  103b91:	8b 45 08             	mov    0x8(%ebp),%eax
  103b94:	c1 e8 0c             	shr    $0xc,%eax
  103b97:	89 c2                	mov    %eax,%edx
  103b99:	89 d0                	mov    %edx,%eax
  103b9b:	c1 e0 02             	shl    $0x2,%eax
  103b9e:	01 d0                	add    %edx,%eax
  103ba0:	c1 e0 02             	shl    $0x2,%eax
  103ba3:	01 c8                	add    %ecx,%eax
}
  103ba5:	c9                   	leave  
  103ba6:	c3                   	ret    

00103ba7 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103ba7:	55                   	push   %ebp
  103ba8:	89 e5                	mov    %esp,%ebp
  103baa:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103bad:	8b 45 08             	mov    0x8(%ebp),%eax
  103bb0:	89 04 24             	mov    %eax,(%esp)
  103bb3:	e8 8a ff ff ff       	call   103b42 <page2pa>
  103bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103bbe:	c1 e8 0c             	shr    $0xc,%eax
  103bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103bc4:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103bc9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103bcc:	72 23                	jb     103bf1 <page2kva+0x4a>
  103bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103bd1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103bd5:	c7 44 24 08 9c 6b 10 	movl   $0x106b9c,0x8(%esp)
  103bdc:	00 
  103bdd:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103be4:	00 
  103be5:	c7 04 24 8b 6b 10 00 	movl   $0x106b8b,(%esp)
  103bec:	e8 ef d0 ff ff       	call   100ce0 <__panic>
  103bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103bf4:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103bf9:	c9                   	leave  
  103bfa:	c3                   	ret    

00103bfb <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103bfb:	55                   	push   %ebp
  103bfc:	89 e5                	mov    %esp,%ebp
  103bfe:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103c01:	8b 45 08             	mov    0x8(%ebp),%eax
  103c04:	83 e0 01             	and    $0x1,%eax
  103c07:	85 c0                	test   %eax,%eax
  103c09:	75 1c                	jne    103c27 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103c0b:	c7 44 24 08 c0 6b 10 	movl   $0x106bc0,0x8(%esp)
  103c12:	00 
  103c13:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103c1a:	00 
  103c1b:	c7 04 24 8b 6b 10 00 	movl   $0x106b8b,(%esp)
  103c22:	e8 b9 d0 ff ff       	call   100ce0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103c27:	8b 45 08             	mov    0x8(%ebp),%eax
  103c2a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103c2f:	89 04 24             	mov    %eax,(%esp)
  103c32:	e8 21 ff ff ff       	call   103b58 <pa2page>
}
  103c37:	c9                   	leave  
  103c38:	c3                   	ret    

00103c39 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  103c39:	55                   	push   %ebp
  103c3a:	89 e5                	mov    %esp,%ebp
  103c3c:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  103c42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103c47:	89 04 24             	mov    %eax,(%esp)
  103c4a:	e8 09 ff ff ff       	call   103b58 <pa2page>
}
  103c4f:	c9                   	leave  
  103c50:	c3                   	ret    

00103c51 <page_ref>:

static inline int
page_ref(struct Page *page) {
  103c51:	55                   	push   %ebp
  103c52:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103c54:	8b 45 08             	mov    0x8(%ebp),%eax
  103c57:	8b 00                	mov    (%eax),%eax
}
  103c59:	5d                   	pop    %ebp
  103c5a:	c3                   	ret    

00103c5b <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103c5b:	55                   	push   %ebp
  103c5c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  103c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  103c64:	89 10                	mov    %edx,(%eax)
}
  103c66:	5d                   	pop    %ebp
  103c67:	c3                   	ret    

00103c68 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103c68:	55                   	push   %ebp
  103c69:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  103c6e:	8b 00                	mov    (%eax),%eax
  103c70:	8d 50 01             	lea    0x1(%eax),%edx
  103c73:	8b 45 08             	mov    0x8(%ebp),%eax
  103c76:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103c78:	8b 45 08             	mov    0x8(%ebp),%eax
  103c7b:	8b 00                	mov    (%eax),%eax
}
  103c7d:	5d                   	pop    %ebp
  103c7e:	c3                   	ret    

00103c7f <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103c7f:	55                   	push   %ebp
  103c80:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103c82:	8b 45 08             	mov    0x8(%ebp),%eax
  103c85:	8b 00                	mov    (%eax),%eax
  103c87:	8d 50 ff             	lea    -0x1(%eax),%edx
  103c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  103c8d:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  103c92:	8b 00                	mov    (%eax),%eax
}
  103c94:	5d                   	pop    %ebp
  103c95:	c3                   	ret    

00103c96 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103c96:	55                   	push   %ebp
  103c97:	89 e5                	mov    %esp,%ebp
  103c99:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103c9c:	9c                   	pushf  
  103c9d:	58                   	pop    %eax
  103c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103ca4:	25 00 02 00 00       	and    $0x200,%eax
  103ca9:	85 c0                	test   %eax,%eax
  103cab:	74 0c                	je     103cb9 <__intr_save+0x23>
        intr_disable();
  103cad:	e8 22 da ff ff       	call   1016d4 <intr_disable>
        return 1;
  103cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  103cb7:	eb 05                	jmp    103cbe <__intr_save+0x28>
    }
    return 0;
  103cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103cbe:	c9                   	leave  
  103cbf:	c3                   	ret    

00103cc0 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103cc0:	55                   	push   %ebp
  103cc1:	89 e5                	mov    %esp,%ebp
  103cc3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103cc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103cca:	74 05                	je     103cd1 <__intr_restore+0x11>
        intr_enable();
  103ccc:	e8 fd d9 ff ff       	call   1016ce <intr_enable>
    }
}
  103cd1:	c9                   	leave  
  103cd2:	c3                   	ret    

00103cd3 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103cd3:	55                   	push   %ebp
  103cd4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  103cd9:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103cdc:	b8 23 00 00 00       	mov    $0x23,%eax
  103ce1:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103ce3:	b8 23 00 00 00       	mov    $0x23,%eax
  103ce8:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103cea:	b8 10 00 00 00       	mov    $0x10,%eax
  103cef:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103cf1:	b8 10 00 00 00       	mov    $0x10,%eax
  103cf6:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103cf8:	b8 10 00 00 00       	mov    $0x10,%eax
  103cfd:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103cff:	ea 06 3d 10 00 08 00 	ljmp   $0x8,$0x103d06
}
  103d06:	5d                   	pop    %ebp
  103d07:	c3                   	ret    

00103d08 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103d08:	55                   	push   %ebp
  103d09:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  103d0e:	a3 a4 ae 11 00       	mov    %eax,0x11aea4
}
  103d13:	5d                   	pop    %ebp
  103d14:	c3                   	ret    

00103d15 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103d15:	55                   	push   %ebp
  103d16:	89 e5                	mov    %esp,%ebp
  103d18:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103d1b:	b8 00 70 11 00       	mov    $0x117000,%eax
  103d20:	89 04 24             	mov    %eax,(%esp)
  103d23:	e8 e0 ff ff ff       	call   103d08 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103d28:	66 c7 05 a8 ae 11 00 	movw   $0x10,0x11aea8
  103d2f:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103d31:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103d38:	68 00 
  103d3a:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103d3f:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103d45:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103d4a:	c1 e8 10             	shr    $0x10,%eax
  103d4d:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103d52:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103d59:	83 e0 f0             	and    $0xfffffff0,%eax
  103d5c:	83 c8 09             	or     $0x9,%eax
  103d5f:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103d64:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103d6b:	83 e0 ef             	and    $0xffffffef,%eax
  103d6e:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103d73:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103d7a:	83 e0 9f             	and    $0xffffff9f,%eax
  103d7d:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103d82:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103d89:	83 c8 80             	or     $0xffffff80,%eax
  103d8c:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103d91:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d98:	83 e0 f0             	and    $0xfffffff0,%eax
  103d9b:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103da0:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103da7:	83 e0 ef             	and    $0xffffffef,%eax
  103daa:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103daf:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103db6:	83 e0 df             	and    $0xffffffdf,%eax
  103db9:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103dbe:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103dc5:	83 c8 40             	or     $0x40,%eax
  103dc8:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103dcd:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103dd4:	83 e0 7f             	and    $0x7f,%eax
  103dd7:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103ddc:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103de1:	c1 e8 18             	shr    $0x18,%eax
  103de4:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103de9:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103df0:	e8 de fe ff ff       	call   103cd3 <lgdt>
  103df5:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103dfb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103dff:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103e02:	c9                   	leave  
  103e03:	c3                   	ret    

00103e04 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103e04:	55                   	push   %ebp
  103e05:	89 e5                	mov    %esp,%ebp
  103e07:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103e0a:	c7 05 1c af 11 00 50 	movl   $0x106b50,0x11af1c
  103e11:	6b 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103e14:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103e19:	8b 00                	mov    (%eax),%eax
  103e1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  103e1f:	c7 04 24 ec 6b 10 00 	movl   $0x106bec,(%esp)
  103e26:	e8 1d c5 ff ff       	call   100348 <cprintf>
    pmm_manager->init();
  103e2b:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103e30:	8b 40 04             	mov    0x4(%eax),%eax
  103e33:	ff d0                	call   *%eax
}
  103e35:	c9                   	leave  
  103e36:	c3                   	ret    

00103e37 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103e37:	55                   	push   %ebp
  103e38:	89 e5                	mov    %esp,%ebp
  103e3a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103e3d:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103e42:	8b 40 08             	mov    0x8(%eax),%eax
  103e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  103e48:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  103e4f:	89 14 24             	mov    %edx,(%esp)
  103e52:	ff d0                	call   *%eax
}
  103e54:	c9                   	leave  
  103e55:	c3                   	ret    

00103e56 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103e56:	55                   	push   %ebp
  103e57:	89 e5                	mov    %esp,%ebp
  103e59:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103e5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103e63:	e8 2e fe ff ff       	call   103c96 <__intr_save>
  103e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103e6b:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103e70:	8b 40 0c             	mov    0xc(%eax),%eax
  103e73:	8b 55 08             	mov    0x8(%ebp),%edx
  103e76:	89 14 24             	mov    %edx,(%esp)
  103e79:	ff d0                	call   *%eax
  103e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e81:	89 04 24             	mov    %eax,(%esp)
  103e84:	e8 37 fe ff ff       	call   103cc0 <__intr_restore>
    return page;
  103e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103e8c:	c9                   	leave  
  103e8d:	c3                   	ret    

00103e8e <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103e8e:	55                   	push   %ebp
  103e8f:	89 e5                	mov    %esp,%ebp
  103e91:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103e94:	e8 fd fd ff ff       	call   103c96 <__intr_save>
  103e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103e9c:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103ea1:	8b 40 10             	mov    0x10(%eax),%eax
  103ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
  103ea7:	89 54 24 04          	mov    %edx,0x4(%esp)
  103eab:	8b 55 08             	mov    0x8(%ebp),%edx
  103eae:	89 14 24             	mov    %edx,(%esp)
  103eb1:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103eb6:	89 04 24             	mov    %eax,(%esp)
  103eb9:	e8 02 fe ff ff       	call   103cc0 <__intr_restore>
}
  103ebe:	c9                   	leave  
  103ebf:	c3                   	ret    

00103ec0 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103ec0:	55                   	push   %ebp
  103ec1:	89 e5                	mov    %esp,%ebp
  103ec3:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103ec6:	e8 cb fd ff ff       	call   103c96 <__intr_save>
  103ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103ece:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103ed3:	8b 40 14             	mov    0x14(%eax),%eax
  103ed6:	ff d0                	call   *%eax
  103ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ede:	89 04 24             	mov    %eax,(%esp)
  103ee1:	e8 da fd ff ff       	call   103cc0 <__intr_restore>
    return ret;
  103ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103ee9:	c9                   	leave  
  103eea:	c3                   	ret    

00103eeb <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103eeb:	55                   	push   %ebp
  103eec:	89 e5                	mov    %esp,%ebp
  103eee:	57                   	push   %edi
  103eef:	56                   	push   %esi
  103ef0:	53                   	push   %ebx
  103ef1:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103ef7:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103efe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103f05:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103f0c:	c7 04 24 03 6c 10 00 	movl   $0x106c03,(%esp)
  103f13:	e8 30 c4 ff ff       	call   100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103f18:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f1f:	e9 15 01 00 00       	jmp    104039 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103f24:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f27:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f2a:	89 d0                	mov    %edx,%eax
  103f2c:	c1 e0 02             	shl    $0x2,%eax
  103f2f:	01 d0                	add    %edx,%eax
  103f31:	c1 e0 02             	shl    $0x2,%eax
  103f34:	01 c8                	add    %ecx,%eax
  103f36:	8b 50 08             	mov    0x8(%eax),%edx
  103f39:	8b 40 04             	mov    0x4(%eax),%eax
  103f3c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103f3f:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103f42:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f45:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f48:	89 d0                	mov    %edx,%eax
  103f4a:	c1 e0 02             	shl    $0x2,%eax
  103f4d:	01 d0                	add    %edx,%eax
  103f4f:	c1 e0 02             	shl    $0x2,%eax
  103f52:	01 c8                	add    %ecx,%eax
  103f54:	8b 48 0c             	mov    0xc(%eax),%ecx
  103f57:	8b 58 10             	mov    0x10(%eax),%ebx
  103f5a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103f5d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103f60:	01 c8                	add    %ecx,%eax
  103f62:	11 da                	adc    %ebx,%edx
  103f64:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103f67:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103f6a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f70:	89 d0                	mov    %edx,%eax
  103f72:	c1 e0 02             	shl    $0x2,%eax
  103f75:	01 d0                	add    %edx,%eax
  103f77:	c1 e0 02             	shl    $0x2,%eax
  103f7a:	01 c8                	add    %ecx,%eax
  103f7c:	83 c0 14             	add    $0x14,%eax
  103f7f:	8b 00                	mov    (%eax),%eax
  103f81:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103f87:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103f8a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103f8d:	83 c0 ff             	add    $0xffffffff,%eax
  103f90:	83 d2 ff             	adc    $0xffffffff,%edx
  103f93:	89 c6                	mov    %eax,%esi
  103f95:	89 d7                	mov    %edx,%edi
  103f97:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f9d:	89 d0                	mov    %edx,%eax
  103f9f:	c1 e0 02             	shl    $0x2,%eax
  103fa2:	01 d0                	add    %edx,%eax
  103fa4:	c1 e0 02             	shl    $0x2,%eax
  103fa7:	01 c8                	add    %ecx,%eax
  103fa9:	8b 48 0c             	mov    0xc(%eax),%ecx
  103fac:	8b 58 10             	mov    0x10(%eax),%ebx
  103faf:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103fb5:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103fb9:	89 74 24 14          	mov    %esi,0x14(%esp)
  103fbd:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103fc1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103fc4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103fc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103fcb:	89 54 24 10          	mov    %edx,0x10(%esp)
  103fcf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103fd3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103fd7:	c7 04 24 10 6c 10 00 	movl   $0x106c10,(%esp)
  103fde:	e8 65 c3 ff ff       	call   100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103fe3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fe6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fe9:	89 d0                	mov    %edx,%eax
  103feb:	c1 e0 02             	shl    $0x2,%eax
  103fee:	01 d0                	add    %edx,%eax
  103ff0:	c1 e0 02             	shl    $0x2,%eax
  103ff3:	01 c8                	add    %ecx,%eax
  103ff5:	83 c0 14             	add    $0x14,%eax
  103ff8:	8b 00                	mov    (%eax),%eax
  103ffa:	83 f8 01             	cmp    $0x1,%eax
  103ffd:	75 36                	jne    104035 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103fff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104002:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104005:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  104008:	77 2b                	ja     104035 <page_init+0x14a>
  10400a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  10400d:	72 05                	jb     104014 <page_init+0x129>
  10400f:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  104012:	73 21                	jae    104035 <page_init+0x14a>
  104014:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  104018:	77 1b                	ja     104035 <page_init+0x14a>
  10401a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  10401e:	72 09                	jb     104029 <page_init+0x13e>
  104020:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  104027:	77 0c                	ja     104035 <page_init+0x14a>
                maxpa = end;
  104029:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10402c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10402f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104032:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  104035:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104039:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10403c:	8b 00                	mov    (%eax),%eax
  10403e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104041:	0f 8f dd fe ff ff    	jg     103f24 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  104047:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10404b:	72 1d                	jb     10406a <page_init+0x17f>
  10404d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104051:	77 09                	ja     10405c <page_init+0x171>
  104053:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  10405a:	76 0e                	jbe    10406a <page_init+0x17f>
        maxpa = KMEMSIZE;
  10405c:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104063:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  10406a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10406d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104070:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104074:	c1 ea 0c             	shr    $0xc,%edx
  104077:	a3 80 ae 11 00       	mov    %eax,0x11ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  10407c:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  104083:	b8 28 af 11 00       	mov    $0x11af28,%eax
  104088:	8d 50 ff             	lea    -0x1(%eax),%edx
  10408b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10408e:	01 d0                	add    %edx,%eax
  104090:	89 45 a8             	mov    %eax,-0x58(%ebp)
  104093:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104096:	ba 00 00 00 00       	mov    $0x0,%edx
  10409b:	f7 75 ac             	divl   -0x54(%ebp)
  10409e:	89 d0                	mov    %edx,%eax
  1040a0:	8b 55 a8             	mov    -0x58(%ebp),%edx
  1040a3:	29 c2                	sub    %eax,%edx
  1040a5:	89 d0                	mov    %edx,%eax
  1040a7:	a3 24 af 11 00       	mov    %eax,0x11af24

    for (i = 0; i < npage; i ++) {
  1040ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1040b3:	eb 2f                	jmp    1040e4 <page_init+0x1f9>
        SetPageReserved(pages + i);
  1040b5:	8b 0d 24 af 11 00    	mov    0x11af24,%ecx
  1040bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040be:	89 d0                	mov    %edx,%eax
  1040c0:	c1 e0 02             	shl    $0x2,%eax
  1040c3:	01 d0                	add    %edx,%eax
  1040c5:	c1 e0 02             	shl    $0x2,%eax
  1040c8:	01 c8                	add    %ecx,%eax
  1040ca:	83 c0 04             	add    $0x4,%eax
  1040cd:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  1040d4:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1040d7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1040da:	8b 55 90             	mov    -0x70(%ebp),%edx
  1040dd:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  1040e0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1040e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040e7:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1040ec:	39 c2                	cmp    %eax,%edx
  1040ee:	72 c5                	jb     1040b5 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1040f0:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  1040f6:	89 d0                	mov    %edx,%eax
  1040f8:	c1 e0 02             	shl    $0x2,%eax
  1040fb:	01 d0                	add    %edx,%eax
  1040fd:	c1 e0 02             	shl    $0x2,%eax
  104100:	89 c2                	mov    %eax,%edx
  104102:	a1 24 af 11 00       	mov    0x11af24,%eax
  104107:	01 d0                	add    %edx,%eax
  104109:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  10410c:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  104113:	77 23                	ja     104138 <page_init+0x24d>
  104115:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104118:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10411c:	c7 44 24 08 40 6c 10 	movl   $0x106c40,0x8(%esp)
  104123:	00 
  104124:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  10412b:	00 
  10412c:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104133:	e8 a8 cb ff ff       	call   100ce0 <__panic>
  104138:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10413b:	05 00 00 00 40       	add    $0x40000000,%eax
  104140:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  104143:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10414a:	e9 74 01 00 00       	jmp    1042c3 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10414f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104152:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104155:	89 d0                	mov    %edx,%eax
  104157:	c1 e0 02             	shl    $0x2,%eax
  10415a:	01 d0                	add    %edx,%eax
  10415c:	c1 e0 02             	shl    $0x2,%eax
  10415f:	01 c8                	add    %ecx,%eax
  104161:	8b 50 08             	mov    0x8(%eax),%edx
  104164:	8b 40 04             	mov    0x4(%eax),%eax
  104167:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10416a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10416d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104170:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104173:	89 d0                	mov    %edx,%eax
  104175:	c1 e0 02             	shl    $0x2,%eax
  104178:	01 d0                	add    %edx,%eax
  10417a:	c1 e0 02             	shl    $0x2,%eax
  10417d:	01 c8                	add    %ecx,%eax
  10417f:	8b 48 0c             	mov    0xc(%eax),%ecx
  104182:	8b 58 10             	mov    0x10(%eax),%ebx
  104185:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104188:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10418b:	01 c8                	add    %ecx,%eax
  10418d:	11 da                	adc    %ebx,%edx
  10418f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104192:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104195:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104198:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10419b:	89 d0                	mov    %edx,%eax
  10419d:	c1 e0 02             	shl    $0x2,%eax
  1041a0:	01 d0                	add    %edx,%eax
  1041a2:	c1 e0 02             	shl    $0x2,%eax
  1041a5:	01 c8                	add    %ecx,%eax
  1041a7:	83 c0 14             	add    $0x14,%eax
  1041aa:	8b 00                	mov    (%eax),%eax
  1041ac:	83 f8 01             	cmp    $0x1,%eax
  1041af:	0f 85 0a 01 00 00    	jne    1042bf <page_init+0x3d4>
            if (begin < freemem) {
  1041b5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1041b8:	ba 00 00 00 00       	mov    $0x0,%edx
  1041bd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1041c0:	72 17                	jb     1041d9 <page_init+0x2ee>
  1041c2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1041c5:	77 05                	ja     1041cc <page_init+0x2e1>
  1041c7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1041ca:	76 0d                	jbe    1041d9 <page_init+0x2ee>
                begin = freemem;
  1041cc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1041cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1041d2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1041d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1041dd:	72 1d                	jb     1041fc <page_init+0x311>
  1041df:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1041e3:	77 09                	ja     1041ee <page_init+0x303>
  1041e5:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1041ec:	76 0e                	jbe    1041fc <page_init+0x311>
                end = KMEMSIZE;
  1041ee:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1041f5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1041fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104202:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104205:	0f 87 b4 00 00 00    	ja     1042bf <page_init+0x3d4>
  10420b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10420e:	72 09                	jb     104219 <page_init+0x32e>
  104210:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104213:	0f 83 a6 00 00 00    	jae    1042bf <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104219:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104220:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104223:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104226:	01 d0                	add    %edx,%eax
  104228:	83 e8 01             	sub    $0x1,%eax
  10422b:	89 45 98             	mov    %eax,-0x68(%ebp)
  10422e:	8b 45 98             	mov    -0x68(%ebp),%eax
  104231:	ba 00 00 00 00       	mov    $0x0,%edx
  104236:	f7 75 9c             	divl   -0x64(%ebp)
  104239:	89 d0                	mov    %edx,%eax
  10423b:	8b 55 98             	mov    -0x68(%ebp),%edx
  10423e:	29 c2                	sub    %eax,%edx
  104240:	89 d0                	mov    %edx,%eax
  104242:	ba 00 00 00 00       	mov    $0x0,%edx
  104247:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10424a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10424d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104250:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104253:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104256:	ba 00 00 00 00       	mov    $0x0,%edx
  10425b:	89 c7                	mov    %eax,%edi
  10425d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104263:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104266:	89 d0                	mov    %edx,%eax
  104268:	83 e0 00             	and    $0x0,%eax
  10426b:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10426e:	8b 45 80             	mov    -0x80(%ebp),%eax
  104271:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104274:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104277:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  10427a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10427d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104280:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104283:	77 3a                	ja     1042bf <page_init+0x3d4>
  104285:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104288:	72 05                	jb     10428f <page_init+0x3a4>
  10428a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10428d:	73 30                	jae    1042bf <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10428f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104292:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  104295:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104298:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10429b:	29 c8                	sub    %ecx,%eax
  10429d:	19 da                	sbb    %ebx,%edx
  10429f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1042a3:	c1 ea 0c             	shr    $0xc,%edx
  1042a6:	89 c3                	mov    %eax,%ebx
  1042a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042ab:	89 04 24             	mov    %eax,(%esp)
  1042ae:	e8 a5 f8 ff ff       	call   103b58 <pa2page>
  1042b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1042b7:	89 04 24             	mov    %eax,(%esp)
  1042ba:	e8 78 fb ff ff       	call   103e37 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  1042bf:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1042c3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1042c6:	8b 00                	mov    (%eax),%eax
  1042c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1042cb:	0f 8f 7e fe ff ff    	jg     10414f <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  1042d1:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1042d7:	5b                   	pop    %ebx
  1042d8:	5e                   	pop    %esi
  1042d9:	5f                   	pop    %edi
  1042da:	5d                   	pop    %ebp
  1042db:	c3                   	ret    

001042dc <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1042dc:	55                   	push   %ebp
  1042dd:	89 e5                	mov    %esp,%ebp
  1042df:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1042e2:	8b 45 14             	mov    0x14(%ebp),%eax
  1042e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1042e8:	31 d0                	xor    %edx,%eax
  1042ea:	25 ff 0f 00 00       	and    $0xfff,%eax
  1042ef:	85 c0                	test   %eax,%eax
  1042f1:	74 24                	je     104317 <boot_map_segment+0x3b>
  1042f3:	c7 44 24 0c 72 6c 10 	movl   $0x106c72,0xc(%esp)
  1042fa:	00 
  1042fb:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104302:	00 
  104303:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  10430a:	00 
  10430b:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104312:	e8 c9 c9 ff ff       	call   100ce0 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104317:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10431e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104321:	25 ff 0f 00 00       	and    $0xfff,%eax
  104326:	89 c2                	mov    %eax,%edx
  104328:	8b 45 10             	mov    0x10(%ebp),%eax
  10432b:	01 c2                	add    %eax,%edx
  10432d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104330:	01 d0                	add    %edx,%eax
  104332:	83 e8 01             	sub    $0x1,%eax
  104335:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10433b:	ba 00 00 00 00       	mov    $0x0,%edx
  104340:	f7 75 f0             	divl   -0x10(%ebp)
  104343:	89 d0                	mov    %edx,%eax
  104345:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104348:	29 c2                	sub    %eax,%edx
  10434a:	89 d0                	mov    %edx,%eax
  10434c:	c1 e8 0c             	shr    $0xc,%eax
  10434f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104352:	8b 45 0c             	mov    0xc(%ebp),%eax
  104355:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10435b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104360:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104363:	8b 45 14             	mov    0x14(%ebp),%eax
  104366:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10436c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104371:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104374:	eb 6b                	jmp    1043e1 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104376:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10437d:	00 
  10437e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104381:	89 44 24 04          	mov    %eax,0x4(%esp)
  104385:	8b 45 08             	mov    0x8(%ebp),%eax
  104388:	89 04 24             	mov    %eax,(%esp)
  10438b:	e8 82 01 00 00       	call   104512 <get_pte>
  104390:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104393:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104397:	75 24                	jne    1043bd <boot_map_segment+0xe1>
  104399:	c7 44 24 0c 9e 6c 10 	movl   $0x106c9e,0xc(%esp)
  1043a0:	00 
  1043a1:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  1043a8:	00 
  1043a9:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1043b0:	00 
  1043b1:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  1043b8:	e8 23 c9 ff ff       	call   100ce0 <__panic>
        *ptep = pa | PTE_P | perm;
  1043bd:	8b 45 18             	mov    0x18(%ebp),%eax
  1043c0:	8b 55 14             	mov    0x14(%ebp),%edx
  1043c3:	09 d0                	or     %edx,%eax
  1043c5:	83 c8 01             	or     $0x1,%eax
  1043c8:	89 c2                	mov    %eax,%edx
  1043ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1043cd:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1043cf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1043d3:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1043da:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1043e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1043e5:	75 8f                	jne    104376 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1043e7:	c9                   	leave  
  1043e8:	c3                   	ret    

001043e9 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1043e9:	55                   	push   %ebp
  1043ea:	89 e5                	mov    %esp,%ebp
  1043ec:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1043ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1043f6:	e8 5b fa ff ff       	call   103e56 <alloc_pages>
  1043fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1043fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104402:	75 1c                	jne    104420 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104404:	c7 44 24 08 ab 6c 10 	movl   $0x106cab,0x8(%esp)
  10440b:	00 
  10440c:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  104413:	00 
  104414:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  10441b:	e8 c0 c8 ff ff       	call   100ce0 <__panic>
    }
    return page2kva(p);
  104420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104423:	89 04 24             	mov    %eax,(%esp)
  104426:	e8 7c f7 ff ff       	call   103ba7 <page2kva>
}
  10442b:	c9                   	leave  
  10442c:	c3                   	ret    

0010442d <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10442d:	55                   	push   %ebp
  10442e:	89 e5                	mov    %esp,%ebp
  104430:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  104433:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10443b:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104442:	77 23                	ja     104467 <pmm_init+0x3a>
  104444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104447:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10444b:	c7 44 24 08 40 6c 10 	movl   $0x106c40,0x8(%esp)
  104452:	00 
  104453:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10445a:	00 
  10445b:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104462:	e8 79 c8 ff ff       	call   100ce0 <__panic>
  104467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10446a:	05 00 00 00 40       	add    $0x40000000,%eax
  10446f:	a3 20 af 11 00       	mov    %eax,0x11af20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104474:	e8 8b f9 ff ff       	call   103e04 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104479:	e8 6d fa ff ff       	call   103eeb <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10447e:	e8 db 03 00 00       	call   10485e <check_alloc_page>

    check_pgdir();
  104483:	e8 f4 03 00 00       	call   10487c <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104488:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10448d:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104493:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104498:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10449b:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1044a2:	77 23                	ja     1044c7 <pmm_init+0x9a>
  1044a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1044ab:	c7 44 24 08 40 6c 10 	movl   $0x106c40,0x8(%esp)
  1044b2:	00 
  1044b3:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1044ba:	00 
  1044bb:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  1044c2:	e8 19 c8 ff ff       	call   100ce0 <__panic>
  1044c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044ca:	05 00 00 00 40       	add    $0x40000000,%eax
  1044cf:	83 c8 03             	or     $0x3,%eax
  1044d2:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1044d4:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1044d9:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1044e0:	00 
  1044e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1044e8:	00 
  1044e9:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1044f0:	38 
  1044f1:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1044f8:	c0 
  1044f9:	89 04 24             	mov    %eax,(%esp)
  1044fc:	e8 db fd ff ff       	call   1042dc <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104501:	e8 0f f8 ff ff       	call   103d15 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104506:	e8 0c 0a 00 00       	call   104f17 <check_boot_pgdir>

    print_pgdir();
  10450b:	e8 94 0e 00 00       	call   1053a4 <print_pgdir>

}
  104510:	c9                   	leave  
  104511:	c3                   	ret    

00104512 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  104512:	55                   	push   %ebp
  104513:	89 e5                	mov    %esp,%ebp
  104515:	83 ec 38             	sub    $0x38,%esp
    }

    // 返回在pgdir中对应于la的二级页表项
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
*/
    pde_t *pdep = &pgdir[PDX(la)];
  104518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10451b:	c1 e8 16             	shr    $0x16,%eax
  10451e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104525:	8b 45 08             	mov    0x8(%ebp),%eax
  104528:	01 d0                	add    %edx,%eax
  10452a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
  10452d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104530:	8b 00                	mov    (%eax),%eax
  104532:	83 e0 01             	and    $0x1,%eax
  104535:	85 c0                	test   %eax,%eax
  104537:	0f 85 af 00 00 00    	jne    1045ec <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
  10453d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104541:	74 15                	je     104558 <get_pte+0x46>
  104543:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10454a:	e8 07 f9 ff ff       	call   103e56 <alloc_pages>
  10454f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104552:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104556:	75 0a                	jne    104562 <get_pte+0x50>
            return NULL;
  104558:	b8 00 00 00 00       	mov    $0x0,%eax
  10455d:	e9 e6 00 00 00       	jmp    104648 <get_pte+0x136>
        }
        set_page_ref(page, 1);
  104562:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104569:	00 
  10456a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10456d:	89 04 24             	mov    %eax,(%esp)
  104570:	e8 e6 f6 ff ff       	call   103c5b <set_page_ref>
        uintptr_t pa = page2pa(page);
  104575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104578:	89 04 24             	mov    %eax,(%esp)
  10457b:	e8 c2 f5 ff ff       	call   103b42 <page2pa>
  104580:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  104583:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104586:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104589:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10458c:	c1 e8 0c             	shr    $0xc,%eax
  10458f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104592:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104597:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10459a:	72 23                	jb     1045bf <get_pte+0xad>
  10459c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10459f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045a3:	c7 44 24 08 9c 6b 10 	movl   $0x106b9c,0x8(%esp)
  1045aa:	00 
  1045ab:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
  1045b2:	00 
  1045b3:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  1045ba:	e8 21 c7 ff ff       	call   100ce0 <__panic>
  1045bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045c2:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1045c7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1045ce:	00 
  1045cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1045d6:	00 
  1045d7:	89 04 24             	mov    %eax,(%esp)
  1045da:	e8 e3 18 00 00       	call   105ec2 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  1045df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045e2:	83 c8 07             	or     $0x7,%eax
  1045e5:	89 c2                	mov    %eax,%edx
  1045e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045ea:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  1045ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045ef:	8b 00                	mov    (%eax),%eax
  1045f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1045f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1045f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045fc:	c1 e8 0c             	shr    $0xc,%eax
  1045ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104602:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104607:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10460a:	72 23                	jb     10462f <get_pte+0x11d>
  10460c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10460f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104613:	c7 44 24 08 9c 6b 10 	movl   $0x106b9c,0x8(%esp)
  10461a:	00 
  10461b:	c7 44 24 04 82 01 00 	movl   $0x182,0x4(%esp)
  104622:	00 
  104623:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  10462a:	e8 b1 c6 ff ff       	call   100ce0 <__panic>
  10462f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104632:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104637:	8b 55 0c             	mov    0xc(%ebp),%edx
  10463a:	c1 ea 0c             	shr    $0xc,%edx
  10463d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104643:	c1 e2 02             	shl    $0x2,%edx
  104646:	01 d0                	add    %edx,%eax
}
  104648:	c9                   	leave  
  104649:	c3                   	ret    

0010464a <get_page>:


//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10464a:	55                   	push   %ebp
  10464b:	89 e5                	mov    %esp,%ebp
  10464d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104650:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104657:	00 
  104658:	8b 45 0c             	mov    0xc(%ebp),%eax
  10465b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10465f:	8b 45 08             	mov    0x8(%ebp),%eax
  104662:	89 04 24             	mov    %eax,(%esp)
  104665:	e8 a8 fe ff ff       	call   104512 <get_pte>
  10466a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10466d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104671:	74 08                	je     10467b <get_page+0x31>
        *ptep_store = ptep;
  104673:	8b 45 10             	mov    0x10(%ebp),%eax
  104676:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104679:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10467b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10467f:	74 1b                	je     10469c <get_page+0x52>
  104681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104684:	8b 00                	mov    (%eax),%eax
  104686:	83 e0 01             	and    $0x1,%eax
  104689:	85 c0                	test   %eax,%eax
  10468b:	74 0f                	je     10469c <get_page+0x52>
        return pte2page(*ptep);
  10468d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104690:	8b 00                	mov    (%eax),%eax
  104692:	89 04 24             	mov    %eax,(%esp)
  104695:	e8 61 f5 ff ff       	call   103bfb <pte2page>
  10469a:	eb 05                	jmp    1046a1 <get_page+0x57>
    }
    return NULL;
  10469c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1046a1:	c9                   	leave  
  1046a2:	c3                   	ret    

001046a3 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1046a3:	55                   	push   %ebp
  1046a4:	89 e5                	mov    %esp,%ebp
  1046a6:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    // 如果传入的页表条目是可用的
    if (*ptep & PTE_P) {
  1046a9:	8b 45 10             	mov    0x10(%ebp),%eax
  1046ac:	8b 00                	mov    (%eax),%eax
  1046ae:	83 e0 01             	and    $0x1,%eax
  1046b1:	85 c0                	test   %eax,%eax
  1046b3:	74 4d                	je     104702 <page_remove_pte+0x5f>
        // 获取该页表条目所对应的地址
        struct Page *page = pte2page(*ptep);
  1046b5:	8b 45 10             	mov    0x10(%ebp),%eax
  1046b8:	8b 00                	mov    (%eax),%eax
  1046ba:	89 04 24             	mov    %eax,(%esp)
  1046bd:	e8 39 f5 ff ff       	call   103bfb <pte2page>
  1046c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 如果该页的引用次数在减1后为0
        if (page_ref_dec(page) == 0)
  1046c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046c8:	89 04 24             	mov    %eax,(%esp)
  1046cb:	e8 af f5 ff ff       	call   103c7f <page_ref_dec>
  1046d0:	85 c0                	test   %eax,%eax
  1046d2:	75 13                	jne    1046e7 <page_remove_pte+0x44>
            // 释放当前页
            free_page(page);
  1046d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1046db:	00 
  1046dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046df:	89 04 24             	mov    %eax,(%esp)
  1046e2:	e8 a7 f7 ff ff       	call   103e8e <free_pages>
        // 清空PTE
        *ptep = 0;
  1046e7:	8b 45 10             	mov    0x10(%ebp),%eax
  1046ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        // 刷新TLB内的数据
        tlb_invalidate(pgdir, la);
  1046f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1046fa:	89 04 24             	mov    %eax,(%esp)
  1046fd:	e8 ff 00 00 00       	call   104801 <tlb_invalidate>
    }
}
  104702:	c9                   	leave  
  104703:	c3                   	ret    

00104704 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104704:	55                   	push   %ebp
  104705:	89 e5                	mov    %esp,%ebp
  104707:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10470a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104711:	00 
  104712:	8b 45 0c             	mov    0xc(%ebp),%eax
  104715:	89 44 24 04          	mov    %eax,0x4(%esp)
  104719:	8b 45 08             	mov    0x8(%ebp),%eax
  10471c:	89 04 24             	mov    %eax,(%esp)
  10471f:	e8 ee fd ff ff       	call   104512 <get_pte>
  104724:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  104727:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10472b:	74 19                	je     104746 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10472d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104730:	89 44 24 08          	mov    %eax,0x8(%esp)
  104734:	8b 45 0c             	mov    0xc(%ebp),%eax
  104737:	89 44 24 04          	mov    %eax,0x4(%esp)
  10473b:	8b 45 08             	mov    0x8(%ebp),%eax
  10473e:	89 04 24             	mov    %eax,(%esp)
  104741:	e8 5d ff ff ff       	call   1046a3 <page_remove_pte>
    }
}
  104746:	c9                   	leave  
  104747:	c3                   	ret    

00104748 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104748:	55                   	push   %ebp
  104749:	89 e5                	mov    %esp,%ebp
  10474b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10474e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104755:	00 
  104756:	8b 45 10             	mov    0x10(%ebp),%eax
  104759:	89 44 24 04          	mov    %eax,0x4(%esp)
  10475d:	8b 45 08             	mov    0x8(%ebp),%eax
  104760:	89 04 24             	mov    %eax,(%esp)
  104763:	e8 aa fd ff ff       	call   104512 <get_pte>
  104768:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10476b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10476f:	75 0a                	jne    10477b <page_insert+0x33>
        return -E_NO_MEM;
  104771:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104776:	e9 84 00 00 00       	jmp    1047ff <page_insert+0xb7>
    }
    page_ref_inc(page);
  10477b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10477e:	89 04 24             	mov    %eax,(%esp)
  104781:	e8 e2 f4 ff ff       	call   103c68 <page_ref_inc>
    if (*ptep & PTE_P) {
  104786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104789:	8b 00                	mov    (%eax),%eax
  10478b:	83 e0 01             	and    $0x1,%eax
  10478e:	85 c0                	test   %eax,%eax
  104790:	74 3e                	je     1047d0 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104795:	8b 00                	mov    (%eax),%eax
  104797:	89 04 24             	mov    %eax,(%esp)
  10479a:	e8 5c f4 ff ff       	call   103bfb <pte2page>
  10479f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1047a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1047a8:	75 0d                	jne    1047b7 <page_insert+0x6f>
            page_ref_dec(page);
  1047aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047ad:	89 04 24             	mov    %eax,(%esp)
  1047b0:	e8 ca f4 ff ff       	call   103c7f <page_ref_dec>
  1047b5:	eb 19                	jmp    1047d0 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1047b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047be:	8b 45 10             	mov    0x10(%ebp),%eax
  1047c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1047c8:	89 04 24             	mov    %eax,(%esp)
  1047cb:	e8 d3 fe ff ff       	call   1046a3 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1047d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047d3:	89 04 24             	mov    %eax,(%esp)
  1047d6:	e8 67 f3 ff ff       	call   103b42 <page2pa>
  1047db:	0b 45 14             	or     0x14(%ebp),%eax
  1047de:	83 c8 01             	or     $0x1,%eax
  1047e1:	89 c2                	mov    %eax,%edx
  1047e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047e6:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1047e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1047eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1047f2:	89 04 24             	mov    %eax,(%esp)
  1047f5:	e8 07 00 00 00       	call   104801 <tlb_invalidate>
    return 0;
  1047fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1047ff:	c9                   	leave  
  104800:	c3                   	ret    

00104801 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104801:	55                   	push   %ebp
  104802:	89 e5                	mov    %esp,%ebp
  104804:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104807:	0f 20 d8             	mov    %cr3,%eax
  10480a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10480d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104810:	89 c2                	mov    %eax,%edx
  104812:	8b 45 08             	mov    0x8(%ebp),%eax
  104815:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104818:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10481f:	77 23                	ja     104844 <tlb_invalidate+0x43>
  104821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104824:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104828:	c7 44 24 08 40 6c 10 	movl   $0x106c40,0x8(%esp)
  10482f:	00 
  104830:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  104837:	00 
  104838:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  10483f:	e8 9c c4 ff ff       	call   100ce0 <__panic>
  104844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104847:	05 00 00 00 40       	add    $0x40000000,%eax
  10484c:	39 c2                	cmp    %eax,%edx
  10484e:	75 0c                	jne    10485c <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104850:	8b 45 0c             	mov    0xc(%ebp),%eax
  104853:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104859:	0f 01 38             	invlpg (%eax)
    }
}
  10485c:	c9                   	leave  
  10485d:	c3                   	ret    

0010485e <check_alloc_page>:

static void
check_alloc_page(void) {
  10485e:	55                   	push   %ebp
  10485f:	89 e5                	mov    %esp,%ebp
  104861:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104864:	a1 1c af 11 00       	mov    0x11af1c,%eax
  104869:	8b 40 18             	mov    0x18(%eax),%eax
  10486c:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10486e:	c7 04 24 c4 6c 10 00 	movl   $0x106cc4,(%esp)
  104875:	e8 ce ba ff ff       	call   100348 <cprintf>
}
  10487a:	c9                   	leave  
  10487b:	c3                   	ret    

0010487c <check_pgdir>:

static void
check_pgdir(void) {
  10487c:	55                   	push   %ebp
  10487d:	89 e5                	mov    %esp,%ebp
  10487f:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104882:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104887:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10488c:	76 24                	jbe    1048b2 <check_pgdir+0x36>
  10488e:	c7 44 24 0c e3 6c 10 	movl   $0x106ce3,0xc(%esp)
  104895:	00 
  104896:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  10489d:	00 
  10489e:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  1048a5:	00 
  1048a6:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  1048ad:	e8 2e c4 ff ff       	call   100ce0 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1048b2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1048b7:	85 c0                	test   %eax,%eax
  1048b9:	74 0e                	je     1048c9 <check_pgdir+0x4d>
  1048bb:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1048c0:	25 ff 0f 00 00       	and    $0xfff,%eax
  1048c5:	85 c0                	test   %eax,%eax
  1048c7:	74 24                	je     1048ed <check_pgdir+0x71>
  1048c9:	c7 44 24 0c 00 6d 10 	movl   $0x106d00,0xc(%esp)
  1048d0:	00 
  1048d1:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  1048d8:	00 
  1048d9:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  1048e0:	00 
  1048e1:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  1048e8:	e8 f3 c3 ff ff       	call   100ce0 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1048ed:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1048f2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048f9:	00 
  1048fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104901:	00 
  104902:	89 04 24             	mov    %eax,(%esp)
  104905:	e8 40 fd ff ff       	call   10464a <get_page>
  10490a:	85 c0                	test   %eax,%eax
  10490c:	74 24                	je     104932 <check_pgdir+0xb6>
  10490e:	c7 44 24 0c 38 6d 10 	movl   $0x106d38,0xc(%esp)
  104915:	00 
  104916:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  10491d:	00 
  10491e:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  104925:	00 
  104926:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  10492d:	e8 ae c3 ff ff       	call   100ce0 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104932:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104939:	e8 18 f5 ff ff       	call   103e56 <alloc_pages>
  10493e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104941:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104946:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10494d:	00 
  10494e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104955:	00 
  104956:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104959:	89 54 24 04          	mov    %edx,0x4(%esp)
  10495d:	89 04 24             	mov    %eax,(%esp)
  104960:	e8 e3 fd ff ff       	call   104748 <page_insert>
  104965:	85 c0                	test   %eax,%eax
  104967:	74 24                	je     10498d <check_pgdir+0x111>
  104969:	c7 44 24 0c 60 6d 10 	movl   $0x106d60,0xc(%esp)
  104970:	00 
  104971:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104978:	00 
  104979:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  104980:	00 
  104981:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104988:	e8 53 c3 ff ff       	call   100ce0 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  10498d:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104992:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104999:	00 
  10499a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1049a1:	00 
  1049a2:	89 04 24             	mov    %eax,(%esp)
  1049a5:	e8 68 fb ff ff       	call   104512 <get_pte>
  1049aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1049ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1049b1:	75 24                	jne    1049d7 <check_pgdir+0x15b>
  1049b3:	c7 44 24 0c 8c 6d 10 	movl   $0x106d8c,0xc(%esp)
  1049ba:	00 
  1049bb:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  1049c2:	00 
  1049c3:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  1049ca:	00 
  1049cb:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  1049d2:	e8 09 c3 ff ff       	call   100ce0 <__panic>
    assert(pte2page(*ptep) == p1);
  1049d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049da:	8b 00                	mov    (%eax),%eax
  1049dc:	89 04 24             	mov    %eax,(%esp)
  1049df:	e8 17 f2 ff ff       	call   103bfb <pte2page>
  1049e4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1049e7:	74 24                	je     104a0d <check_pgdir+0x191>
  1049e9:	c7 44 24 0c b9 6d 10 	movl   $0x106db9,0xc(%esp)
  1049f0:	00 
  1049f1:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  1049f8:	00 
  1049f9:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  104a00:	00 
  104a01:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104a08:	e8 d3 c2 ff ff       	call   100ce0 <__panic>
    assert(page_ref(p1) == 1);
  104a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a10:	89 04 24             	mov    %eax,(%esp)
  104a13:	e8 39 f2 ff ff       	call   103c51 <page_ref>
  104a18:	83 f8 01             	cmp    $0x1,%eax
  104a1b:	74 24                	je     104a41 <check_pgdir+0x1c5>
  104a1d:	c7 44 24 0c cf 6d 10 	movl   $0x106dcf,0xc(%esp)
  104a24:	00 
  104a25:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104a2c:	00 
  104a2d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  104a34:	00 
  104a35:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104a3c:	e8 9f c2 ff ff       	call   100ce0 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104a41:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104a46:	8b 00                	mov    (%eax),%eax
  104a48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104a4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a53:	c1 e8 0c             	shr    $0xc,%eax
  104a56:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104a59:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104a5e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104a61:	72 23                	jb     104a86 <check_pgdir+0x20a>
  104a63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a66:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104a6a:	c7 44 24 08 9c 6b 10 	movl   $0x106b9c,0x8(%esp)
  104a71:	00 
  104a72:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104a79:	00 
  104a7a:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104a81:	e8 5a c2 ff ff       	call   100ce0 <__panic>
  104a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a89:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104a8e:	83 c0 04             	add    $0x4,%eax
  104a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104a94:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104a99:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104aa0:	00 
  104aa1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104aa8:	00 
  104aa9:	89 04 24             	mov    %eax,(%esp)
  104aac:	e8 61 fa ff ff       	call   104512 <get_pte>
  104ab1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104ab4:	74 24                	je     104ada <check_pgdir+0x25e>
  104ab6:	c7 44 24 0c e4 6d 10 	movl   $0x106de4,0xc(%esp)
  104abd:	00 
  104abe:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104ac5:	00 
  104ac6:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104acd:	00 
  104ace:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104ad5:	e8 06 c2 ff ff       	call   100ce0 <__panic>

    p2 = alloc_page();
  104ada:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ae1:	e8 70 f3 ff ff       	call   103e56 <alloc_pages>
  104ae6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104ae9:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104aee:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104af5:	00 
  104af6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104afd:	00 
  104afe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104b01:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b05:	89 04 24             	mov    %eax,(%esp)
  104b08:	e8 3b fc ff ff       	call   104748 <page_insert>
  104b0d:	85 c0                	test   %eax,%eax
  104b0f:	74 24                	je     104b35 <check_pgdir+0x2b9>
  104b11:	c7 44 24 0c 0c 6e 10 	movl   $0x106e0c,0xc(%esp)
  104b18:	00 
  104b19:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104b20:	00 
  104b21:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104b28:	00 
  104b29:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104b30:	e8 ab c1 ff ff       	call   100ce0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104b35:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104b3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b41:	00 
  104b42:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b49:	00 
  104b4a:	89 04 24             	mov    %eax,(%esp)
  104b4d:	e8 c0 f9 ff ff       	call   104512 <get_pte>
  104b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b59:	75 24                	jne    104b7f <check_pgdir+0x303>
  104b5b:	c7 44 24 0c 44 6e 10 	movl   $0x106e44,0xc(%esp)
  104b62:	00 
  104b63:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104b6a:	00 
  104b6b:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104b72:	00 
  104b73:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104b7a:	e8 61 c1 ff ff       	call   100ce0 <__panic>
    assert(*ptep & PTE_U);
  104b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b82:	8b 00                	mov    (%eax),%eax
  104b84:	83 e0 04             	and    $0x4,%eax
  104b87:	85 c0                	test   %eax,%eax
  104b89:	75 24                	jne    104baf <check_pgdir+0x333>
  104b8b:	c7 44 24 0c 74 6e 10 	movl   $0x106e74,0xc(%esp)
  104b92:	00 
  104b93:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104b9a:	00 
  104b9b:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104ba2:	00 
  104ba3:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104baa:	e8 31 c1 ff ff       	call   100ce0 <__panic>
    assert(*ptep & PTE_W);
  104baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bb2:	8b 00                	mov    (%eax),%eax
  104bb4:	83 e0 02             	and    $0x2,%eax
  104bb7:	85 c0                	test   %eax,%eax
  104bb9:	75 24                	jne    104bdf <check_pgdir+0x363>
  104bbb:	c7 44 24 0c 82 6e 10 	movl   $0x106e82,0xc(%esp)
  104bc2:	00 
  104bc3:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104bca:	00 
  104bcb:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104bd2:	00 
  104bd3:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104bda:	e8 01 c1 ff ff       	call   100ce0 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104bdf:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104be4:	8b 00                	mov    (%eax),%eax
  104be6:	83 e0 04             	and    $0x4,%eax
  104be9:	85 c0                	test   %eax,%eax
  104beb:	75 24                	jne    104c11 <check_pgdir+0x395>
  104bed:	c7 44 24 0c 90 6e 10 	movl   $0x106e90,0xc(%esp)
  104bf4:	00 
  104bf5:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104bfc:	00 
  104bfd:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104c04:	00 
  104c05:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104c0c:	e8 cf c0 ff ff       	call   100ce0 <__panic>
    assert(page_ref(p2) == 1);
  104c11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c14:	89 04 24             	mov    %eax,(%esp)
  104c17:	e8 35 f0 ff ff       	call   103c51 <page_ref>
  104c1c:	83 f8 01             	cmp    $0x1,%eax
  104c1f:	74 24                	je     104c45 <check_pgdir+0x3c9>
  104c21:	c7 44 24 0c a6 6e 10 	movl   $0x106ea6,0xc(%esp)
  104c28:	00 
  104c29:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104c30:	00 
  104c31:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104c38:	00 
  104c39:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104c40:	e8 9b c0 ff ff       	call   100ce0 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104c45:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104c4a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104c51:	00 
  104c52:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104c59:	00 
  104c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104c5d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c61:	89 04 24             	mov    %eax,(%esp)
  104c64:	e8 df fa ff ff       	call   104748 <page_insert>
  104c69:	85 c0                	test   %eax,%eax
  104c6b:	74 24                	je     104c91 <check_pgdir+0x415>
  104c6d:	c7 44 24 0c b8 6e 10 	movl   $0x106eb8,0xc(%esp)
  104c74:	00 
  104c75:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104c7c:	00 
  104c7d:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104c84:	00 
  104c85:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104c8c:	e8 4f c0 ff ff       	call   100ce0 <__panic>
    assert(page_ref(p1) == 2);
  104c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c94:	89 04 24             	mov    %eax,(%esp)
  104c97:	e8 b5 ef ff ff       	call   103c51 <page_ref>
  104c9c:	83 f8 02             	cmp    $0x2,%eax
  104c9f:	74 24                	je     104cc5 <check_pgdir+0x449>
  104ca1:	c7 44 24 0c e4 6e 10 	movl   $0x106ee4,0xc(%esp)
  104ca8:	00 
  104ca9:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104cb0:	00 
  104cb1:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104cb8:	00 
  104cb9:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104cc0:	e8 1b c0 ff ff       	call   100ce0 <__panic>
    assert(page_ref(p2) == 0);
  104cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cc8:	89 04 24             	mov    %eax,(%esp)
  104ccb:	e8 81 ef ff ff       	call   103c51 <page_ref>
  104cd0:	85 c0                	test   %eax,%eax
  104cd2:	74 24                	je     104cf8 <check_pgdir+0x47c>
  104cd4:	c7 44 24 0c f6 6e 10 	movl   $0x106ef6,0xc(%esp)
  104cdb:	00 
  104cdc:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104ce3:	00 
  104ce4:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104ceb:	00 
  104cec:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104cf3:	e8 e8 bf ff ff       	call   100ce0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104cf8:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104cfd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104d04:	00 
  104d05:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d0c:	00 
  104d0d:	89 04 24             	mov    %eax,(%esp)
  104d10:	e8 fd f7 ff ff       	call   104512 <get_pte>
  104d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104d1c:	75 24                	jne    104d42 <check_pgdir+0x4c6>
  104d1e:	c7 44 24 0c 44 6e 10 	movl   $0x106e44,0xc(%esp)
  104d25:	00 
  104d26:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104d2d:	00 
  104d2e:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104d35:	00 
  104d36:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104d3d:	e8 9e bf ff ff       	call   100ce0 <__panic>
    assert(pte2page(*ptep) == p1);
  104d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d45:	8b 00                	mov    (%eax),%eax
  104d47:	89 04 24             	mov    %eax,(%esp)
  104d4a:	e8 ac ee ff ff       	call   103bfb <pte2page>
  104d4f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104d52:	74 24                	je     104d78 <check_pgdir+0x4fc>
  104d54:	c7 44 24 0c b9 6d 10 	movl   $0x106db9,0xc(%esp)
  104d5b:	00 
  104d5c:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104d63:	00 
  104d64:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104d6b:	00 
  104d6c:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104d73:	e8 68 bf ff ff       	call   100ce0 <__panic>
    assert((*ptep & PTE_U) == 0);
  104d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d7b:	8b 00                	mov    (%eax),%eax
  104d7d:	83 e0 04             	and    $0x4,%eax
  104d80:	85 c0                	test   %eax,%eax
  104d82:	74 24                	je     104da8 <check_pgdir+0x52c>
  104d84:	c7 44 24 0c 08 6f 10 	movl   $0x106f08,0xc(%esp)
  104d8b:	00 
  104d8c:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104d93:	00 
  104d94:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104d9b:	00 
  104d9c:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104da3:	e8 38 bf ff ff       	call   100ce0 <__panic>

    page_remove(boot_pgdir, 0x0);
  104da8:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104dad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104db4:	00 
  104db5:	89 04 24             	mov    %eax,(%esp)
  104db8:	e8 47 f9 ff ff       	call   104704 <page_remove>
    assert(page_ref(p1) == 1);
  104dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dc0:	89 04 24             	mov    %eax,(%esp)
  104dc3:	e8 89 ee ff ff       	call   103c51 <page_ref>
  104dc8:	83 f8 01             	cmp    $0x1,%eax
  104dcb:	74 24                	je     104df1 <check_pgdir+0x575>
  104dcd:	c7 44 24 0c cf 6d 10 	movl   $0x106dcf,0xc(%esp)
  104dd4:	00 
  104dd5:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104ddc:	00 
  104ddd:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104de4:	00 
  104de5:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104dec:	e8 ef be ff ff       	call   100ce0 <__panic>
    assert(page_ref(p2) == 0);
  104df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104df4:	89 04 24             	mov    %eax,(%esp)
  104df7:	e8 55 ee ff ff       	call   103c51 <page_ref>
  104dfc:	85 c0                	test   %eax,%eax
  104dfe:	74 24                	je     104e24 <check_pgdir+0x5a8>
  104e00:	c7 44 24 0c f6 6e 10 	movl   $0x106ef6,0xc(%esp)
  104e07:	00 
  104e08:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104e0f:	00 
  104e10:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104e17:	00 
  104e18:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104e1f:	e8 bc be ff ff       	call   100ce0 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104e24:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104e29:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104e30:	00 
  104e31:	89 04 24             	mov    %eax,(%esp)
  104e34:	e8 cb f8 ff ff       	call   104704 <page_remove>
    assert(page_ref(p1) == 0);
  104e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e3c:	89 04 24             	mov    %eax,(%esp)
  104e3f:	e8 0d ee ff ff       	call   103c51 <page_ref>
  104e44:	85 c0                	test   %eax,%eax
  104e46:	74 24                	je     104e6c <check_pgdir+0x5f0>
  104e48:	c7 44 24 0c 1d 6f 10 	movl   $0x106f1d,0xc(%esp)
  104e4f:	00 
  104e50:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104e57:	00 
  104e58:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104e5f:	00 
  104e60:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104e67:	e8 74 be ff ff       	call   100ce0 <__panic>
    assert(page_ref(p2) == 0);
  104e6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e6f:	89 04 24             	mov    %eax,(%esp)
  104e72:	e8 da ed ff ff       	call   103c51 <page_ref>
  104e77:	85 c0                	test   %eax,%eax
  104e79:	74 24                	je     104e9f <check_pgdir+0x623>
  104e7b:	c7 44 24 0c f6 6e 10 	movl   $0x106ef6,0xc(%esp)
  104e82:	00 
  104e83:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104e8a:	00 
  104e8b:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104e92:	00 
  104e93:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104e9a:	e8 41 be ff ff       	call   100ce0 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104e9f:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104ea4:	8b 00                	mov    (%eax),%eax
  104ea6:	89 04 24             	mov    %eax,(%esp)
  104ea9:	e8 8b ed ff ff       	call   103c39 <pde2page>
  104eae:	89 04 24             	mov    %eax,(%esp)
  104eb1:	e8 9b ed ff ff       	call   103c51 <page_ref>
  104eb6:	83 f8 01             	cmp    $0x1,%eax
  104eb9:	74 24                	je     104edf <check_pgdir+0x663>
  104ebb:	c7 44 24 0c 30 6f 10 	movl   $0x106f30,0xc(%esp)
  104ec2:	00 
  104ec3:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104eca:	00 
  104ecb:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104ed2:	00 
  104ed3:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104eda:	e8 01 be ff ff       	call   100ce0 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104edf:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104ee4:	8b 00                	mov    (%eax),%eax
  104ee6:	89 04 24             	mov    %eax,(%esp)
  104ee9:	e8 4b ed ff ff       	call   103c39 <pde2page>
  104eee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ef5:	00 
  104ef6:	89 04 24             	mov    %eax,(%esp)
  104ef9:	e8 90 ef ff ff       	call   103e8e <free_pages>
    boot_pgdir[0] = 0;
  104efe:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104f03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104f09:	c7 04 24 57 6f 10 00 	movl   $0x106f57,(%esp)
  104f10:	e8 33 b4 ff ff       	call   100348 <cprintf>
}
  104f15:	c9                   	leave  
  104f16:	c3                   	ret    

00104f17 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104f17:	55                   	push   %ebp
  104f18:	89 e5                	mov    %esp,%ebp
  104f1a:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104f1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104f24:	e9 ca 00 00 00       	jmp    104ff3 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f32:	c1 e8 0c             	shr    $0xc,%eax
  104f35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104f38:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104f3d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104f40:	72 23                	jb     104f65 <check_boot_pgdir+0x4e>
  104f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f45:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f49:	c7 44 24 08 9c 6b 10 	movl   $0x106b9c,0x8(%esp)
  104f50:	00 
  104f51:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  104f58:	00 
  104f59:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104f60:	e8 7b bd ff ff       	call   100ce0 <__panic>
  104f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f68:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104f6d:	89 c2                	mov    %eax,%edx
  104f6f:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104f74:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104f7b:	00 
  104f7c:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f80:	89 04 24             	mov    %eax,(%esp)
  104f83:	e8 8a f5 ff ff       	call   104512 <get_pte>
  104f88:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104f8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104f8f:	75 24                	jne    104fb5 <check_boot_pgdir+0x9e>
  104f91:	c7 44 24 0c 74 6f 10 	movl   $0x106f74,0xc(%esp)
  104f98:	00 
  104f99:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104fa0:	00 
  104fa1:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  104fa8:	00 
  104fa9:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104fb0:	e8 2b bd ff ff       	call   100ce0 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fb8:	8b 00                	mov    (%eax),%eax
  104fba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104fbf:	89 c2                	mov    %eax,%edx
  104fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104fc4:	39 c2                	cmp    %eax,%edx
  104fc6:	74 24                	je     104fec <check_boot_pgdir+0xd5>
  104fc8:	c7 44 24 0c b1 6f 10 	movl   $0x106fb1,0xc(%esp)
  104fcf:	00 
  104fd0:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  104fd7:	00 
  104fd8:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  104fdf:	00 
  104fe0:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  104fe7:	e8 f4 bc ff ff       	call   100ce0 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104fec:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104ff3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104ff6:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104ffb:	39 c2                	cmp    %eax,%edx
  104ffd:	0f 82 26 ff ff ff    	jb     104f29 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  105003:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  105008:	05 ac 0f 00 00       	add    $0xfac,%eax
  10500d:	8b 00                	mov    (%eax),%eax
  10500f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105014:	89 c2                	mov    %eax,%edx
  105016:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10501b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10501e:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  105025:	77 23                	ja     10504a <check_boot_pgdir+0x133>
  105027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10502a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10502e:	c7 44 24 08 40 6c 10 	movl   $0x106c40,0x8(%esp)
  105035:	00 
  105036:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  10503d:	00 
  10503e:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  105045:	e8 96 bc ff ff       	call   100ce0 <__panic>
  10504a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10504d:	05 00 00 00 40       	add    $0x40000000,%eax
  105052:	39 c2                	cmp    %eax,%edx
  105054:	74 24                	je     10507a <check_boot_pgdir+0x163>
  105056:	c7 44 24 0c c8 6f 10 	movl   $0x106fc8,0xc(%esp)
  10505d:	00 
  10505e:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  105065:	00 
  105066:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  10506d:	00 
  10506e:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  105075:	e8 66 bc ff ff       	call   100ce0 <__panic>

    assert(boot_pgdir[0] == 0);
  10507a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10507f:	8b 00                	mov    (%eax),%eax
  105081:	85 c0                	test   %eax,%eax
  105083:	74 24                	je     1050a9 <check_boot_pgdir+0x192>
  105085:	c7 44 24 0c fc 6f 10 	movl   $0x106ffc,0xc(%esp)
  10508c:	00 
  10508d:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  105094:	00 
  105095:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  10509c:	00 
  10509d:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  1050a4:	e8 37 bc ff ff       	call   100ce0 <__panic>

    struct Page *p;
    p = alloc_page();
  1050a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1050b0:	e8 a1 ed ff ff       	call   103e56 <alloc_pages>
  1050b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  1050b8:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1050bd:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1050c4:	00 
  1050c5:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  1050cc:	00 
  1050cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1050d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050d4:	89 04 24             	mov    %eax,(%esp)
  1050d7:	e8 6c f6 ff ff       	call   104748 <page_insert>
  1050dc:	85 c0                	test   %eax,%eax
  1050de:	74 24                	je     105104 <check_boot_pgdir+0x1ed>
  1050e0:	c7 44 24 0c 10 70 10 	movl   $0x107010,0xc(%esp)
  1050e7:	00 
  1050e8:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  1050ef:	00 
  1050f0:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  1050f7:	00 
  1050f8:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  1050ff:	e8 dc bb ff ff       	call   100ce0 <__panic>
    assert(page_ref(p) == 1);
  105104:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105107:	89 04 24             	mov    %eax,(%esp)
  10510a:	e8 42 eb ff ff       	call   103c51 <page_ref>
  10510f:	83 f8 01             	cmp    $0x1,%eax
  105112:	74 24                	je     105138 <check_boot_pgdir+0x221>
  105114:	c7 44 24 0c 3e 70 10 	movl   $0x10703e,0xc(%esp)
  10511b:	00 
  10511c:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  105123:	00 
  105124:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  10512b:	00 
  10512c:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  105133:	e8 a8 bb ff ff       	call   100ce0 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105138:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10513d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105144:	00 
  105145:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  10514c:	00 
  10514d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105150:	89 54 24 04          	mov    %edx,0x4(%esp)
  105154:	89 04 24             	mov    %eax,(%esp)
  105157:	e8 ec f5 ff ff       	call   104748 <page_insert>
  10515c:	85 c0                	test   %eax,%eax
  10515e:	74 24                	je     105184 <check_boot_pgdir+0x26d>
  105160:	c7 44 24 0c 50 70 10 	movl   $0x107050,0xc(%esp)
  105167:	00 
  105168:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  10516f:	00 
  105170:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  105177:	00 
  105178:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  10517f:	e8 5c bb ff ff       	call   100ce0 <__panic>
    assert(page_ref(p) == 2);
  105184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105187:	89 04 24             	mov    %eax,(%esp)
  10518a:	e8 c2 ea ff ff       	call   103c51 <page_ref>
  10518f:	83 f8 02             	cmp    $0x2,%eax
  105192:	74 24                	je     1051b8 <check_boot_pgdir+0x2a1>
  105194:	c7 44 24 0c 87 70 10 	movl   $0x107087,0xc(%esp)
  10519b:	00 
  10519c:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  1051a3:	00 
  1051a4:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  1051ab:	00 
  1051ac:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  1051b3:	e8 28 bb ff ff       	call   100ce0 <__panic>

    const char *str = "ucore: Hello world!!";
  1051b8:	c7 45 dc 98 70 10 00 	movl   $0x107098,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1051bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1051c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051c6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051cd:	e8 19 0a 00 00       	call   105beb <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1051d2:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1051d9:	00 
  1051da:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051e1:	e8 7e 0a 00 00       	call   105c64 <strcmp>
  1051e6:	85 c0                	test   %eax,%eax
  1051e8:	74 24                	je     10520e <check_boot_pgdir+0x2f7>
  1051ea:	c7 44 24 0c b0 70 10 	movl   $0x1070b0,0xc(%esp)
  1051f1:	00 
  1051f2:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  1051f9:	00 
  1051fa:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  105201:	00 
  105202:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  105209:	e8 d2 ba ff ff       	call   100ce0 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  10520e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105211:	89 04 24             	mov    %eax,(%esp)
  105214:	e8 8e e9 ff ff       	call   103ba7 <page2kva>
  105219:	05 00 01 00 00       	add    $0x100,%eax
  10521e:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105221:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105228:	e8 66 09 00 00       	call   105b93 <strlen>
  10522d:	85 c0                	test   %eax,%eax
  10522f:	74 24                	je     105255 <check_boot_pgdir+0x33e>
  105231:	c7 44 24 0c e8 70 10 	movl   $0x1070e8,0xc(%esp)
  105238:	00 
  105239:	c7 44 24 08 89 6c 10 	movl   $0x106c89,0x8(%esp)
  105240:	00 
  105241:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
  105248:	00 
  105249:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  105250:	e8 8b ba ff ff       	call   100ce0 <__panic>

    free_page(p);
  105255:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10525c:	00 
  10525d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105260:	89 04 24             	mov    %eax,(%esp)
  105263:	e8 26 ec ff ff       	call   103e8e <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  105268:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10526d:	8b 00                	mov    (%eax),%eax
  10526f:	89 04 24             	mov    %eax,(%esp)
  105272:	e8 c2 e9 ff ff       	call   103c39 <pde2page>
  105277:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10527e:	00 
  10527f:	89 04 24             	mov    %eax,(%esp)
  105282:	e8 07 ec ff ff       	call   103e8e <free_pages>
    boot_pgdir[0] = 0;
  105287:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10528c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105292:	c7 04 24 0c 71 10 00 	movl   $0x10710c,(%esp)
  105299:	e8 aa b0 ff ff       	call   100348 <cprintf>
}
  10529e:	c9                   	leave  
  10529f:	c3                   	ret    

001052a0 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1052a0:	55                   	push   %ebp
  1052a1:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1052a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1052a6:	83 e0 04             	and    $0x4,%eax
  1052a9:	85 c0                	test   %eax,%eax
  1052ab:	74 07                	je     1052b4 <perm2str+0x14>
  1052ad:	b8 75 00 00 00       	mov    $0x75,%eax
  1052b2:	eb 05                	jmp    1052b9 <perm2str+0x19>
  1052b4:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1052b9:	a2 08 af 11 00       	mov    %al,0x11af08
    str[1] = 'r';
  1052be:	c6 05 09 af 11 00 72 	movb   $0x72,0x11af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1052c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1052c8:	83 e0 02             	and    $0x2,%eax
  1052cb:	85 c0                	test   %eax,%eax
  1052cd:	74 07                	je     1052d6 <perm2str+0x36>
  1052cf:	b8 77 00 00 00       	mov    $0x77,%eax
  1052d4:	eb 05                	jmp    1052db <perm2str+0x3b>
  1052d6:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1052db:	a2 0a af 11 00       	mov    %al,0x11af0a
    str[3] = '\0';
  1052e0:	c6 05 0b af 11 00 00 	movb   $0x0,0x11af0b
    return str;
  1052e7:	b8 08 af 11 00       	mov    $0x11af08,%eax
}
  1052ec:	5d                   	pop    %ebp
  1052ed:	c3                   	ret    

001052ee <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1052ee:	55                   	push   %ebp
  1052ef:	89 e5                	mov    %esp,%ebp
  1052f1:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1052f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1052f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052fa:	72 0a                	jb     105306 <get_pgtable_items+0x18>
        return 0;
  1052fc:	b8 00 00 00 00       	mov    $0x0,%eax
  105301:	e9 9c 00 00 00       	jmp    1053a2 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105306:	eb 04                	jmp    10530c <get_pgtable_items+0x1e>
        start ++;
  105308:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  10530c:	8b 45 10             	mov    0x10(%ebp),%eax
  10530f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105312:	73 18                	jae    10532c <get_pgtable_items+0x3e>
  105314:	8b 45 10             	mov    0x10(%ebp),%eax
  105317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10531e:	8b 45 14             	mov    0x14(%ebp),%eax
  105321:	01 d0                	add    %edx,%eax
  105323:	8b 00                	mov    (%eax),%eax
  105325:	83 e0 01             	and    $0x1,%eax
  105328:	85 c0                	test   %eax,%eax
  10532a:	74 dc                	je     105308 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  10532c:	8b 45 10             	mov    0x10(%ebp),%eax
  10532f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105332:	73 69                	jae    10539d <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105334:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105338:	74 08                	je     105342 <get_pgtable_items+0x54>
            *left_store = start;
  10533a:	8b 45 18             	mov    0x18(%ebp),%eax
  10533d:	8b 55 10             	mov    0x10(%ebp),%edx
  105340:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105342:	8b 45 10             	mov    0x10(%ebp),%eax
  105345:	8d 50 01             	lea    0x1(%eax),%edx
  105348:	89 55 10             	mov    %edx,0x10(%ebp)
  10534b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105352:	8b 45 14             	mov    0x14(%ebp),%eax
  105355:	01 d0                	add    %edx,%eax
  105357:	8b 00                	mov    (%eax),%eax
  105359:	83 e0 07             	and    $0x7,%eax
  10535c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10535f:	eb 04                	jmp    105365 <get_pgtable_items+0x77>
            start ++;
  105361:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105365:	8b 45 10             	mov    0x10(%ebp),%eax
  105368:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10536b:	73 1d                	jae    10538a <get_pgtable_items+0x9c>
  10536d:	8b 45 10             	mov    0x10(%ebp),%eax
  105370:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105377:	8b 45 14             	mov    0x14(%ebp),%eax
  10537a:	01 d0                	add    %edx,%eax
  10537c:	8b 00                	mov    (%eax),%eax
  10537e:	83 e0 07             	and    $0x7,%eax
  105381:	89 c2                	mov    %eax,%edx
  105383:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105386:	39 c2                	cmp    %eax,%edx
  105388:	74 d7                	je     105361 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  10538a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10538e:	74 08                	je     105398 <get_pgtable_items+0xaa>
            *right_store = start;
  105390:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105393:	8b 55 10             	mov    0x10(%ebp),%edx
  105396:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105398:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10539b:	eb 05                	jmp    1053a2 <get_pgtable_items+0xb4>
    }
    return 0;
  10539d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1053a2:	c9                   	leave  
  1053a3:	c3                   	ret    

001053a4 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1053a4:	55                   	push   %ebp
  1053a5:	89 e5                	mov    %esp,%ebp
  1053a7:	57                   	push   %edi
  1053a8:	56                   	push   %esi
  1053a9:	53                   	push   %ebx
  1053aa:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1053ad:	c7 04 24 2c 71 10 00 	movl   $0x10712c,(%esp)
  1053b4:	e8 8f af ff ff       	call   100348 <cprintf>
    size_t left, right = 0, perm;
  1053b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1053c0:	e9 fa 00 00 00       	jmp    1054bf <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1053c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053c8:	89 04 24             	mov    %eax,(%esp)
  1053cb:	e8 d0 fe ff ff       	call   1052a0 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1053d0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1053d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1053d6:	29 d1                	sub    %edx,%ecx
  1053d8:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1053da:	89 d6                	mov    %edx,%esi
  1053dc:	c1 e6 16             	shl    $0x16,%esi
  1053df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1053e2:	89 d3                	mov    %edx,%ebx
  1053e4:	c1 e3 16             	shl    $0x16,%ebx
  1053e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1053ea:	89 d1                	mov    %edx,%ecx
  1053ec:	c1 e1 16             	shl    $0x16,%ecx
  1053ef:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1053f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1053f5:	29 d7                	sub    %edx,%edi
  1053f7:	89 fa                	mov    %edi,%edx
  1053f9:	89 44 24 14          	mov    %eax,0x14(%esp)
  1053fd:	89 74 24 10          	mov    %esi,0x10(%esp)
  105401:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105405:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105409:	89 54 24 04          	mov    %edx,0x4(%esp)
  10540d:	c7 04 24 5d 71 10 00 	movl   $0x10715d,(%esp)
  105414:	e8 2f af ff ff       	call   100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  105419:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10541c:	c1 e0 0a             	shl    $0xa,%eax
  10541f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105422:	eb 54                	jmp    105478 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105427:	89 04 24             	mov    %eax,(%esp)
  10542a:	e8 71 fe ff ff       	call   1052a0 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10542f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105432:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105435:	29 d1                	sub    %edx,%ecx
  105437:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105439:	89 d6                	mov    %edx,%esi
  10543b:	c1 e6 0c             	shl    $0xc,%esi
  10543e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105441:	89 d3                	mov    %edx,%ebx
  105443:	c1 e3 0c             	shl    $0xc,%ebx
  105446:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105449:	c1 e2 0c             	shl    $0xc,%edx
  10544c:	89 d1                	mov    %edx,%ecx
  10544e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105451:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105454:	29 d7                	sub    %edx,%edi
  105456:	89 fa                	mov    %edi,%edx
  105458:	89 44 24 14          	mov    %eax,0x14(%esp)
  10545c:	89 74 24 10          	mov    %esi,0x10(%esp)
  105460:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105464:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105468:	89 54 24 04          	mov    %edx,0x4(%esp)
  10546c:	c7 04 24 7c 71 10 00 	movl   $0x10717c,(%esp)
  105473:	e8 d0 ae ff ff       	call   100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105478:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  10547d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105480:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105483:	89 ce                	mov    %ecx,%esi
  105485:	c1 e6 0a             	shl    $0xa,%esi
  105488:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10548b:	89 cb                	mov    %ecx,%ebx
  10548d:	c1 e3 0a             	shl    $0xa,%ebx
  105490:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105493:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105497:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  10549a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10549e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1054a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  1054aa:	89 1c 24             	mov    %ebx,(%esp)
  1054ad:	e8 3c fe ff ff       	call   1052ee <get_pgtable_items>
  1054b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1054b9:	0f 85 65 ff ff ff    	jne    105424 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1054bf:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1054c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054c7:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1054ca:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1054ce:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1054d1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1054d5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1054d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054dd:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1054e4:	00 
  1054e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1054ec:	e8 fd fd ff ff       	call   1052ee <get_pgtable_items>
  1054f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1054f8:	0f 85 c7 fe ff ff    	jne    1053c5 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1054fe:	c7 04 24 a0 71 10 00 	movl   $0x1071a0,(%esp)
  105505:	e8 3e ae ff ff       	call   100348 <cprintf>
}
  10550a:	83 c4 4c             	add    $0x4c,%esp
  10550d:	5b                   	pop    %ebx
  10550e:	5e                   	pop    %esi
  10550f:	5f                   	pop    %edi
  105510:	5d                   	pop    %ebp
  105511:	c3                   	ret    

00105512 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105512:	55                   	push   %ebp
  105513:	89 e5                	mov    %esp,%ebp
  105515:	83 ec 58             	sub    $0x58,%esp
  105518:	8b 45 10             	mov    0x10(%ebp),%eax
  10551b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10551e:	8b 45 14             	mov    0x14(%ebp),%eax
  105521:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105524:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105527:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10552a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10552d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105530:	8b 45 18             	mov    0x18(%ebp),%eax
  105533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105536:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105539:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10553c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10553f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105545:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105548:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10554c:	74 1c                	je     10556a <printnum+0x58>
  10554e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105551:	ba 00 00 00 00       	mov    $0x0,%edx
  105556:	f7 75 e4             	divl   -0x1c(%ebp)
  105559:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10555c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10555f:	ba 00 00 00 00       	mov    $0x0,%edx
  105564:	f7 75 e4             	divl   -0x1c(%ebp)
  105567:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10556a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10556d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105570:	f7 75 e4             	divl   -0x1c(%ebp)
  105573:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105576:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10557c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10557f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105582:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105585:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105588:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10558b:	8b 45 18             	mov    0x18(%ebp),%eax
  10558e:	ba 00 00 00 00       	mov    $0x0,%edx
  105593:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105596:	77 56                	ja     1055ee <printnum+0xdc>
  105598:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10559b:	72 05                	jb     1055a2 <printnum+0x90>
  10559d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1055a0:	77 4c                	ja     1055ee <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1055a2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1055a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1055a8:	8b 45 20             	mov    0x20(%ebp),%eax
  1055ab:	89 44 24 18          	mov    %eax,0x18(%esp)
  1055af:	89 54 24 14          	mov    %edx,0x14(%esp)
  1055b3:	8b 45 18             	mov    0x18(%ebp),%eax
  1055b6:	89 44 24 10          	mov    %eax,0x10(%esp)
  1055ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1055c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1055c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d2:	89 04 24             	mov    %eax,(%esp)
  1055d5:	e8 38 ff ff ff       	call   105512 <printnum>
  1055da:	eb 1c                	jmp    1055f8 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1055dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055e3:	8b 45 20             	mov    0x20(%ebp),%eax
  1055e6:	89 04 24             	mov    %eax,(%esp)
  1055e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ec:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1055ee:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1055f2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1055f6:	7f e4                	jg     1055dc <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1055f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1055fb:	05 54 72 10 00       	add    $0x107254,%eax
  105600:	0f b6 00             	movzbl (%eax),%eax
  105603:	0f be c0             	movsbl %al,%eax
  105606:	8b 55 0c             	mov    0xc(%ebp),%edx
  105609:	89 54 24 04          	mov    %edx,0x4(%esp)
  10560d:	89 04 24             	mov    %eax,(%esp)
  105610:	8b 45 08             	mov    0x8(%ebp),%eax
  105613:	ff d0                	call   *%eax
}
  105615:	c9                   	leave  
  105616:	c3                   	ret    

00105617 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105617:	55                   	push   %ebp
  105618:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10561a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10561e:	7e 14                	jle    105634 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105620:	8b 45 08             	mov    0x8(%ebp),%eax
  105623:	8b 00                	mov    (%eax),%eax
  105625:	8d 48 08             	lea    0x8(%eax),%ecx
  105628:	8b 55 08             	mov    0x8(%ebp),%edx
  10562b:	89 0a                	mov    %ecx,(%edx)
  10562d:	8b 50 04             	mov    0x4(%eax),%edx
  105630:	8b 00                	mov    (%eax),%eax
  105632:	eb 30                	jmp    105664 <getuint+0x4d>
    }
    else if (lflag) {
  105634:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105638:	74 16                	je     105650 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10563a:	8b 45 08             	mov    0x8(%ebp),%eax
  10563d:	8b 00                	mov    (%eax),%eax
  10563f:	8d 48 04             	lea    0x4(%eax),%ecx
  105642:	8b 55 08             	mov    0x8(%ebp),%edx
  105645:	89 0a                	mov    %ecx,(%edx)
  105647:	8b 00                	mov    (%eax),%eax
  105649:	ba 00 00 00 00       	mov    $0x0,%edx
  10564e:	eb 14                	jmp    105664 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105650:	8b 45 08             	mov    0x8(%ebp),%eax
  105653:	8b 00                	mov    (%eax),%eax
  105655:	8d 48 04             	lea    0x4(%eax),%ecx
  105658:	8b 55 08             	mov    0x8(%ebp),%edx
  10565b:	89 0a                	mov    %ecx,(%edx)
  10565d:	8b 00                	mov    (%eax),%eax
  10565f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105664:	5d                   	pop    %ebp
  105665:	c3                   	ret    

00105666 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105666:	55                   	push   %ebp
  105667:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105669:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10566d:	7e 14                	jle    105683 <getint+0x1d>
        return va_arg(*ap, long long);
  10566f:	8b 45 08             	mov    0x8(%ebp),%eax
  105672:	8b 00                	mov    (%eax),%eax
  105674:	8d 48 08             	lea    0x8(%eax),%ecx
  105677:	8b 55 08             	mov    0x8(%ebp),%edx
  10567a:	89 0a                	mov    %ecx,(%edx)
  10567c:	8b 50 04             	mov    0x4(%eax),%edx
  10567f:	8b 00                	mov    (%eax),%eax
  105681:	eb 28                	jmp    1056ab <getint+0x45>
    }
    else if (lflag) {
  105683:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105687:	74 12                	je     10569b <getint+0x35>
        return va_arg(*ap, long);
  105689:	8b 45 08             	mov    0x8(%ebp),%eax
  10568c:	8b 00                	mov    (%eax),%eax
  10568e:	8d 48 04             	lea    0x4(%eax),%ecx
  105691:	8b 55 08             	mov    0x8(%ebp),%edx
  105694:	89 0a                	mov    %ecx,(%edx)
  105696:	8b 00                	mov    (%eax),%eax
  105698:	99                   	cltd   
  105699:	eb 10                	jmp    1056ab <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10569b:	8b 45 08             	mov    0x8(%ebp),%eax
  10569e:	8b 00                	mov    (%eax),%eax
  1056a0:	8d 48 04             	lea    0x4(%eax),%ecx
  1056a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1056a6:	89 0a                	mov    %ecx,(%edx)
  1056a8:	8b 00                	mov    (%eax),%eax
  1056aa:	99                   	cltd   
    }
}
  1056ab:	5d                   	pop    %ebp
  1056ac:	c3                   	ret    

001056ad <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1056ad:	55                   	push   %ebp
  1056ae:	89 e5                	mov    %esp,%ebp
  1056b0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1056b3:	8d 45 14             	lea    0x14(%ebp),%eax
  1056b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1056b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1056c0:	8b 45 10             	mov    0x10(%ebp),%eax
  1056c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1056c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1056d1:	89 04 24             	mov    %eax,(%esp)
  1056d4:	e8 02 00 00 00       	call   1056db <vprintfmt>
    va_end(ap);
}
  1056d9:	c9                   	leave  
  1056da:	c3                   	ret    

001056db <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1056db:	55                   	push   %ebp
  1056dc:	89 e5                	mov    %esp,%ebp
  1056de:	56                   	push   %esi
  1056df:	53                   	push   %ebx
  1056e0:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1056e3:	eb 18                	jmp    1056fd <vprintfmt+0x22>
            if (ch == '\0') {
  1056e5:	85 db                	test   %ebx,%ebx
  1056e7:	75 05                	jne    1056ee <vprintfmt+0x13>
                return;
  1056e9:	e9 d1 03 00 00       	jmp    105abf <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1056ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056f5:	89 1c 24             	mov    %ebx,(%esp)
  1056f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1056fb:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1056fd:	8b 45 10             	mov    0x10(%ebp),%eax
  105700:	8d 50 01             	lea    0x1(%eax),%edx
  105703:	89 55 10             	mov    %edx,0x10(%ebp)
  105706:	0f b6 00             	movzbl (%eax),%eax
  105709:	0f b6 d8             	movzbl %al,%ebx
  10570c:	83 fb 25             	cmp    $0x25,%ebx
  10570f:	75 d4                	jne    1056e5 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105711:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105715:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10571c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10571f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105722:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105729:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10572c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10572f:	8b 45 10             	mov    0x10(%ebp),%eax
  105732:	8d 50 01             	lea    0x1(%eax),%edx
  105735:	89 55 10             	mov    %edx,0x10(%ebp)
  105738:	0f b6 00             	movzbl (%eax),%eax
  10573b:	0f b6 d8             	movzbl %al,%ebx
  10573e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105741:	83 f8 55             	cmp    $0x55,%eax
  105744:	0f 87 44 03 00 00    	ja     105a8e <vprintfmt+0x3b3>
  10574a:	8b 04 85 78 72 10 00 	mov    0x107278(,%eax,4),%eax
  105751:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105753:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105757:	eb d6                	jmp    10572f <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105759:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10575d:	eb d0                	jmp    10572f <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10575f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105766:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105769:	89 d0                	mov    %edx,%eax
  10576b:	c1 e0 02             	shl    $0x2,%eax
  10576e:	01 d0                	add    %edx,%eax
  105770:	01 c0                	add    %eax,%eax
  105772:	01 d8                	add    %ebx,%eax
  105774:	83 e8 30             	sub    $0x30,%eax
  105777:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10577a:	8b 45 10             	mov    0x10(%ebp),%eax
  10577d:	0f b6 00             	movzbl (%eax),%eax
  105780:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105783:	83 fb 2f             	cmp    $0x2f,%ebx
  105786:	7e 0b                	jle    105793 <vprintfmt+0xb8>
  105788:	83 fb 39             	cmp    $0x39,%ebx
  10578b:	7f 06                	jg     105793 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10578d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105791:	eb d3                	jmp    105766 <vprintfmt+0x8b>
            goto process_precision;
  105793:	eb 33                	jmp    1057c8 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  105795:	8b 45 14             	mov    0x14(%ebp),%eax
  105798:	8d 50 04             	lea    0x4(%eax),%edx
  10579b:	89 55 14             	mov    %edx,0x14(%ebp)
  10579e:	8b 00                	mov    (%eax),%eax
  1057a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1057a3:	eb 23                	jmp    1057c8 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1057a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057a9:	79 0c                	jns    1057b7 <vprintfmt+0xdc>
                width = 0;
  1057ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1057b2:	e9 78 ff ff ff       	jmp    10572f <vprintfmt+0x54>
  1057b7:	e9 73 ff ff ff       	jmp    10572f <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1057bc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1057c3:	e9 67 ff ff ff       	jmp    10572f <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1057c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057cc:	79 12                	jns    1057e0 <vprintfmt+0x105>
                width = precision, precision = -1;
  1057ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057d4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1057db:	e9 4f ff ff ff       	jmp    10572f <vprintfmt+0x54>
  1057e0:	e9 4a ff ff ff       	jmp    10572f <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1057e5:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1057e9:	e9 41 ff ff ff       	jmp    10572f <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1057ee:	8b 45 14             	mov    0x14(%ebp),%eax
  1057f1:	8d 50 04             	lea    0x4(%eax),%edx
  1057f4:	89 55 14             	mov    %edx,0x14(%ebp)
  1057f7:	8b 00                	mov    (%eax),%eax
  1057f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  105800:	89 04 24             	mov    %eax,(%esp)
  105803:	8b 45 08             	mov    0x8(%ebp),%eax
  105806:	ff d0                	call   *%eax
            break;
  105808:	e9 ac 02 00 00       	jmp    105ab9 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10580d:	8b 45 14             	mov    0x14(%ebp),%eax
  105810:	8d 50 04             	lea    0x4(%eax),%edx
  105813:	89 55 14             	mov    %edx,0x14(%ebp)
  105816:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105818:	85 db                	test   %ebx,%ebx
  10581a:	79 02                	jns    10581e <vprintfmt+0x143>
                err = -err;
  10581c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10581e:	83 fb 06             	cmp    $0x6,%ebx
  105821:	7f 0b                	jg     10582e <vprintfmt+0x153>
  105823:	8b 34 9d 38 72 10 00 	mov    0x107238(,%ebx,4),%esi
  10582a:	85 f6                	test   %esi,%esi
  10582c:	75 23                	jne    105851 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  10582e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105832:	c7 44 24 08 65 72 10 	movl   $0x107265,0x8(%esp)
  105839:	00 
  10583a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10583d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105841:	8b 45 08             	mov    0x8(%ebp),%eax
  105844:	89 04 24             	mov    %eax,(%esp)
  105847:	e8 61 fe ff ff       	call   1056ad <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10584c:	e9 68 02 00 00       	jmp    105ab9 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105851:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105855:	c7 44 24 08 6e 72 10 	movl   $0x10726e,0x8(%esp)
  10585c:	00 
  10585d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105860:	89 44 24 04          	mov    %eax,0x4(%esp)
  105864:	8b 45 08             	mov    0x8(%ebp),%eax
  105867:	89 04 24             	mov    %eax,(%esp)
  10586a:	e8 3e fe ff ff       	call   1056ad <printfmt>
            }
            break;
  10586f:	e9 45 02 00 00       	jmp    105ab9 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105874:	8b 45 14             	mov    0x14(%ebp),%eax
  105877:	8d 50 04             	lea    0x4(%eax),%edx
  10587a:	89 55 14             	mov    %edx,0x14(%ebp)
  10587d:	8b 30                	mov    (%eax),%esi
  10587f:	85 f6                	test   %esi,%esi
  105881:	75 05                	jne    105888 <vprintfmt+0x1ad>
                p = "(null)";
  105883:	be 71 72 10 00       	mov    $0x107271,%esi
            }
            if (width > 0 && padc != '-') {
  105888:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10588c:	7e 3e                	jle    1058cc <vprintfmt+0x1f1>
  10588e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105892:	74 38                	je     1058cc <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105894:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10589a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10589e:	89 34 24             	mov    %esi,(%esp)
  1058a1:	e8 15 03 00 00       	call   105bbb <strnlen>
  1058a6:	29 c3                	sub    %eax,%ebx
  1058a8:	89 d8                	mov    %ebx,%eax
  1058aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058ad:	eb 17                	jmp    1058c6 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1058af:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1058b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1058ba:	89 04 24             	mov    %eax,(%esp)
  1058bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c0:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1058c2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1058c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058ca:	7f e3                	jg     1058af <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1058cc:	eb 38                	jmp    105906 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1058ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1058d2:	74 1f                	je     1058f3 <vprintfmt+0x218>
  1058d4:	83 fb 1f             	cmp    $0x1f,%ebx
  1058d7:	7e 05                	jle    1058de <vprintfmt+0x203>
  1058d9:	83 fb 7e             	cmp    $0x7e,%ebx
  1058dc:	7e 15                	jle    1058f3 <vprintfmt+0x218>
                    putch('?', putdat);
  1058de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058e5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1058ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ef:	ff d0                	call   *%eax
  1058f1:	eb 0f                	jmp    105902 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  1058f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058fa:	89 1c 24             	mov    %ebx,(%esp)
  1058fd:	8b 45 08             	mov    0x8(%ebp),%eax
  105900:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105902:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105906:	89 f0                	mov    %esi,%eax
  105908:	8d 70 01             	lea    0x1(%eax),%esi
  10590b:	0f b6 00             	movzbl (%eax),%eax
  10590e:	0f be d8             	movsbl %al,%ebx
  105911:	85 db                	test   %ebx,%ebx
  105913:	74 10                	je     105925 <vprintfmt+0x24a>
  105915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105919:	78 b3                	js     1058ce <vprintfmt+0x1f3>
  10591b:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10591f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105923:	79 a9                	jns    1058ce <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105925:	eb 17                	jmp    10593e <vprintfmt+0x263>
                putch(' ', putdat);
  105927:	8b 45 0c             	mov    0xc(%ebp),%eax
  10592a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10592e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105935:	8b 45 08             	mov    0x8(%ebp),%eax
  105938:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10593a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10593e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105942:	7f e3                	jg     105927 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105944:	e9 70 01 00 00       	jmp    105ab9 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105949:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10594c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105950:	8d 45 14             	lea    0x14(%ebp),%eax
  105953:	89 04 24             	mov    %eax,(%esp)
  105956:	e8 0b fd ff ff       	call   105666 <getint>
  10595b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10595e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105967:	85 d2                	test   %edx,%edx
  105969:	79 26                	jns    105991 <vprintfmt+0x2b6>
                putch('-', putdat);
  10596b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10596e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105972:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105979:	8b 45 08             	mov    0x8(%ebp),%eax
  10597c:	ff d0                	call   *%eax
                num = -(long long)num;
  10597e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105984:	f7 d8                	neg    %eax
  105986:	83 d2 00             	adc    $0x0,%edx
  105989:	f7 da                	neg    %edx
  10598b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10598e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105991:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105998:	e9 a8 00 00 00       	jmp    105a45 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10599d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059a4:	8d 45 14             	lea    0x14(%ebp),%eax
  1059a7:	89 04 24             	mov    %eax,(%esp)
  1059aa:	e8 68 fc ff ff       	call   105617 <getuint>
  1059af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1059b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1059bc:	e9 84 00 00 00       	jmp    105a45 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1059c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059c8:	8d 45 14             	lea    0x14(%ebp),%eax
  1059cb:	89 04 24             	mov    %eax,(%esp)
  1059ce:	e8 44 fc ff ff       	call   105617 <getuint>
  1059d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1059d9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1059e0:	eb 63                	jmp    105a45 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1059e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059e9:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1059f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f3:	ff d0                	call   *%eax
            putch('x', putdat);
  1059f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059fc:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105a03:	8b 45 08             	mov    0x8(%ebp),%eax
  105a06:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105a08:	8b 45 14             	mov    0x14(%ebp),%eax
  105a0b:	8d 50 04             	lea    0x4(%eax),%edx
  105a0e:	89 55 14             	mov    %edx,0x14(%ebp)
  105a11:	8b 00                	mov    (%eax),%eax
  105a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105a1d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105a24:	eb 1f                	jmp    105a45 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105a26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a2d:	8d 45 14             	lea    0x14(%ebp),%eax
  105a30:	89 04 24             	mov    %eax,(%esp)
  105a33:	e8 df fb ff ff       	call   105617 <getuint>
  105a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105a3e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105a45:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a4c:	89 54 24 18          	mov    %edx,0x18(%esp)
  105a50:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105a53:	89 54 24 14          	mov    %edx,0x14(%esp)
  105a57:	89 44 24 10          	mov    %eax,0x10(%esp)
  105a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a61:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a65:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a70:	8b 45 08             	mov    0x8(%ebp),%eax
  105a73:	89 04 24             	mov    %eax,(%esp)
  105a76:	e8 97 fa ff ff       	call   105512 <printnum>
            break;
  105a7b:	eb 3c                	jmp    105ab9 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a84:	89 1c 24             	mov    %ebx,(%esp)
  105a87:	8b 45 08             	mov    0x8(%ebp),%eax
  105a8a:	ff d0                	call   *%eax
            break;
  105a8c:	eb 2b                	jmp    105ab9 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a91:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a95:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a9f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105aa1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105aa5:	eb 04                	jmp    105aab <vprintfmt+0x3d0>
  105aa7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105aab:	8b 45 10             	mov    0x10(%ebp),%eax
  105aae:	83 e8 01             	sub    $0x1,%eax
  105ab1:	0f b6 00             	movzbl (%eax),%eax
  105ab4:	3c 25                	cmp    $0x25,%al
  105ab6:	75 ef                	jne    105aa7 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105ab8:	90                   	nop
        }
    }
  105ab9:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105aba:	e9 3e fc ff ff       	jmp    1056fd <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105abf:	83 c4 40             	add    $0x40,%esp
  105ac2:	5b                   	pop    %ebx
  105ac3:	5e                   	pop    %esi
  105ac4:	5d                   	pop    %ebp
  105ac5:	c3                   	ret    

00105ac6 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105ac6:	55                   	push   %ebp
  105ac7:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105acc:	8b 40 08             	mov    0x8(%eax),%eax
  105acf:	8d 50 01             	lea    0x1(%eax),%edx
  105ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ad5:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105adb:	8b 10                	mov    (%eax),%edx
  105add:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ae0:	8b 40 04             	mov    0x4(%eax),%eax
  105ae3:	39 c2                	cmp    %eax,%edx
  105ae5:	73 12                	jae    105af9 <sprintputch+0x33>
        *b->buf ++ = ch;
  105ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aea:	8b 00                	mov    (%eax),%eax
  105aec:	8d 48 01             	lea    0x1(%eax),%ecx
  105aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  105af2:	89 0a                	mov    %ecx,(%edx)
  105af4:	8b 55 08             	mov    0x8(%ebp),%edx
  105af7:	88 10                	mov    %dl,(%eax)
    }
}
  105af9:	5d                   	pop    %ebp
  105afa:	c3                   	ret    

00105afb <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105afb:	55                   	push   %ebp
  105afc:	89 e5                	mov    %esp,%ebp
  105afe:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105b01:	8d 45 14             	lea    0x14(%ebp),%eax
  105b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b0e:	8b 45 10             	mov    0x10(%ebp),%eax
  105b11:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b1f:	89 04 24             	mov    %eax,(%esp)
  105b22:	e8 08 00 00 00       	call   105b2f <vsnprintf>
  105b27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105b2d:	c9                   	leave  
  105b2e:	c3                   	ret    

00105b2f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105b2f:	55                   	push   %ebp
  105b30:	89 e5                	mov    %esp,%ebp
  105b32:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105b35:	8b 45 08             	mov    0x8(%ebp),%eax
  105b38:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  105b41:	8b 45 08             	mov    0x8(%ebp),%eax
  105b44:	01 d0                	add    %edx,%eax
  105b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105b50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105b54:	74 0a                	je     105b60 <vsnprintf+0x31>
  105b56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b5c:	39 c2                	cmp    %eax,%edx
  105b5e:	76 07                	jbe    105b67 <vsnprintf+0x38>
        return -E_INVAL;
  105b60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105b65:	eb 2a                	jmp    105b91 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105b67:	8b 45 14             	mov    0x14(%ebp),%eax
  105b6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b6e:	8b 45 10             	mov    0x10(%ebp),%eax
  105b71:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b75:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b7c:	c7 04 24 c6 5a 10 00 	movl   $0x105ac6,(%esp)
  105b83:	e8 53 fb ff ff       	call   1056db <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b8b:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105b91:	c9                   	leave  
  105b92:	c3                   	ret    

00105b93 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105b93:	55                   	push   %ebp
  105b94:	89 e5                	mov    %esp,%ebp
  105b96:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105ba0:	eb 04                	jmp    105ba6 <strlen+0x13>
        cnt ++;
  105ba2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba9:	8d 50 01             	lea    0x1(%eax),%edx
  105bac:	89 55 08             	mov    %edx,0x8(%ebp)
  105baf:	0f b6 00             	movzbl (%eax),%eax
  105bb2:	84 c0                	test   %al,%al
  105bb4:	75 ec                	jne    105ba2 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105bb9:	c9                   	leave  
  105bba:	c3                   	ret    

00105bbb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105bbb:	55                   	push   %ebp
  105bbc:	89 e5                	mov    %esp,%ebp
  105bbe:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105bc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105bc8:	eb 04                	jmp    105bce <strnlen+0x13>
        cnt ++;
  105bca:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105bce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105bd1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105bd4:	73 10                	jae    105be6 <strnlen+0x2b>
  105bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd9:	8d 50 01             	lea    0x1(%eax),%edx
  105bdc:	89 55 08             	mov    %edx,0x8(%ebp)
  105bdf:	0f b6 00             	movzbl (%eax),%eax
  105be2:	84 c0                	test   %al,%al
  105be4:	75 e4                	jne    105bca <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105be9:	c9                   	leave  
  105bea:	c3                   	ret    

00105beb <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105beb:	55                   	push   %ebp
  105bec:	89 e5                	mov    %esp,%ebp
  105bee:	57                   	push   %edi
  105bef:	56                   	push   %esi
  105bf0:	83 ec 20             	sub    $0x20,%esp
  105bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105bff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c05:	89 d1                	mov    %edx,%ecx
  105c07:	89 c2                	mov    %eax,%edx
  105c09:	89 ce                	mov    %ecx,%esi
  105c0b:	89 d7                	mov    %edx,%edi
  105c0d:	ac                   	lods   %ds:(%esi),%al
  105c0e:	aa                   	stos   %al,%es:(%edi)
  105c0f:	84 c0                	test   %al,%al
  105c11:	75 fa                	jne    105c0d <strcpy+0x22>
  105c13:	89 fa                	mov    %edi,%edx
  105c15:	89 f1                	mov    %esi,%ecx
  105c17:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105c1a:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105c1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105c23:	83 c4 20             	add    $0x20,%esp
  105c26:	5e                   	pop    %esi
  105c27:	5f                   	pop    %edi
  105c28:	5d                   	pop    %ebp
  105c29:	c3                   	ret    

00105c2a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105c2a:	55                   	push   %ebp
  105c2b:	89 e5                	mov    %esp,%ebp
  105c2d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105c30:	8b 45 08             	mov    0x8(%ebp),%eax
  105c33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105c36:	eb 21                	jmp    105c59 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c3b:	0f b6 10             	movzbl (%eax),%edx
  105c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c41:	88 10                	mov    %dl,(%eax)
  105c43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c46:	0f b6 00             	movzbl (%eax),%eax
  105c49:	84 c0                	test   %al,%al
  105c4b:	74 04                	je     105c51 <strncpy+0x27>
            src ++;
  105c4d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105c51:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105c55:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105c59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c5d:	75 d9                	jne    105c38 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105c5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c62:	c9                   	leave  
  105c63:	c3                   	ret    

00105c64 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105c64:	55                   	push   %ebp
  105c65:	89 e5                	mov    %esp,%ebp
  105c67:	57                   	push   %edi
  105c68:	56                   	push   %esi
  105c69:	83 ec 20             	sub    $0x20,%esp
  105c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105c78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c7e:	89 d1                	mov    %edx,%ecx
  105c80:	89 c2                	mov    %eax,%edx
  105c82:	89 ce                	mov    %ecx,%esi
  105c84:	89 d7                	mov    %edx,%edi
  105c86:	ac                   	lods   %ds:(%esi),%al
  105c87:	ae                   	scas   %es:(%edi),%al
  105c88:	75 08                	jne    105c92 <strcmp+0x2e>
  105c8a:	84 c0                	test   %al,%al
  105c8c:	75 f8                	jne    105c86 <strcmp+0x22>
  105c8e:	31 c0                	xor    %eax,%eax
  105c90:	eb 04                	jmp    105c96 <strcmp+0x32>
  105c92:	19 c0                	sbb    %eax,%eax
  105c94:	0c 01                	or     $0x1,%al
  105c96:	89 fa                	mov    %edi,%edx
  105c98:	89 f1                	mov    %esi,%ecx
  105c9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c9d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105ca0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105ca6:	83 c4 20             	add    $0x20,%esp
  105ca9:	5e                   	pop    %esi
  105caa:	5f                   	pop    %edi
  105cab:	5d                   	pop    %ebp
  105cac:	c3                   	ret    

00105cad <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105cad:	55                   	push   %ebp
  105cae:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105cb0:	eb 0c                	jmp    105cbe <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105cb2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105cb6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cba:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105cbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cc2:	74 1a                	je     105cde <strncmp+0x31>
  105cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc7:	0f b6 00             	movzbl (%eax),%eax
  105cca:	84 c0                	test   %al,%al
  105ccc:	74 10                	je     105cde <strncmp+0x31>
  105cce:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd1:	0f b6 10             	movzbl (%eax),%edx
  105cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cd7:	0f b6 00             	movzbl (%eax),%eax
  105cda:	38 c2                	cmp    %al,%dl
  105cdc:	74 d4                	je     105cb2 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ce2:	74 18                	je     105cfc <strncmp+0x4f>
  105ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce7:	0f b6 00             	movzbl (%eax),%eax
  105cea:	0f b6 d0             	movzbl %al,%edx
  105ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cf0:	0f b6 00             	movzbl (%eax),%eax
  105cf3:	0f b6 c0             	movzbl %al,%eax
  105cf6:	29 c2                	sub    %eax,%edx
  105cf8:	89 d0                	mov    %edx,%eax
  105cfa:	eb 05                	jmp    105d01 <strncmp+0x54>
  105cfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105d01:	5d                   	pop    %ebp
  105d02:	c3                   	ret    

00105d03 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105d03:	55                   	push   %ebp
  105d04:	89 e5                	mov    %esp,%ebp
  105d06:	83 ec 04             	sub    $0x4,%esp
  105d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d0c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105d0f:	eb 14                	jmp    105d25 <strchr+0x22>
        if (*s == c) {
  105d11:	8b 45 08             	mov    0x8(%ebp),%eax
  105d14:	0f b6 00             	movzbl (%eax),%eax
  105d17:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105d1a:	75 05                	jne    105d21 <strchr+0x1e>
            return (char *)s;
  105d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d1f:	eb 13                	jmp    105d34 <strchr+0x31>
        }
        s ++;
  105d21:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105d25:	8b 45 08             	mov    0x8(%ebp),%eax
  105d28:	0f b6 00             	movzbl (%eax),%eax
  105d2b:	84 c0                	test   %al,%al
  105d2d:	75 e2                	jne    105d11 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105d2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105d34:	c9                   	leave  
  105d35:	c3                   	ret    

00105d36 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105d36:	55                   	push   %ebp
  105d37:	89 e5                	mov    %esp,%ebp
  105d39:	83 ec 04             	sub    $0x4,%esp
  105d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d3f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105d42:	eb 11                	jmp    105d55 <strfind+0x1f>
        if (*s == c) {
  105d44:	8b 45 08             	mov    0x8(%ebp),%eax
  105d47:	0f b6 00             	movzbl (%eax),%eax
  105d4a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105d4d:	75 02                	jne    105d51 <strfind+0x1b>
            break;
  105d4f:	eb 0e                	jmp    105d5f <strfind+0x29>
        }
        s ++;
  105d51:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105d55:	8b 45 08             	mov    0x8(%ebp),%eax
  105d58:	0f b6 00             	movzbl (%eax),%eax
  105d5b:	84 c0                	test   %al,%al
  105d5d:	75 e5                	jne    105d44 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105d5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105d62:	c9                   	leave  
  105d63:	c3                   	ret    

00105d64 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105d64:	55                   	push   %ebp
  105d65:	89 e5                	mov    %esp,%ebp
  105d67:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105d6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105d71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105d78:	eb 04                	jmp    105d7e <strtol+0x1a>
        s ++;
  105d7a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d81:	0f b6 00             	movzbl (%eax),%eax
  105d84:	3c 20                	cmp    $0x20,%al
  105d86:	74 f2                	je     105d7a <strtol+0x16>
  105d88:	8b 45 08             	mov    0x8(%ebp),%eax
  105d8b:	0f b6 00             	movzbl (%eax),%eax
  105d8e:	3c 09                	cmp    $0x9,%al
  105d90:	74 e8                	je     105d7a <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105d92:	8b 45 08             	mov    0x8(%ebp),%eax
  105d95:	0f b6 00             	movzbl (%eax),%eax
  105d98:	3c 2b                	cmp    $0x2b,%al
  105d9a:	75 06                	jne    105da2 <strtol+0x3e>
        s ++;
  105d9c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105da0:	eb 15                	jmp    105db7 <strtol+0x53>
    }
    else if (*s == '-') {
  105da2:	8b 45 08             	mov    0x8(%ebp),%eax
  105da5:	0f b6 00             	movzbl (%eax),%eax
  105da8:	3c 2d                	cmp    $0x2d,%al
  105daa:	75 0b                	jne    105db7 <strtol+0x53>
        s ++, neg = 1;
  105dac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105db0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105db7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105dbb:	74 06                	je     105dc3 <strtol+0x5f>
  105dbd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105dc1:	75 24                	jne    105de7 <strtol+0x83>
  105dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc6:	0f b6 00             	movzbl (%eax),%eax
  105dc9:	3c 30                	cmp    $0x30,%al
  105dcb:	75 1a                	jne    105de7 <strtol+0x83>
  105dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd0:	83 c0 01             	add    $0x1,%eax
  105dd3:	0f b6 00             	movzbl (%eax),%eax
  105dd6:	3c 78                	cmp    $0x78,%al
  105dd8:	75 0d                	jne    105de7 <strtol+0x83>
        s += 2, base = 16;
  105dda:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105dde:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105de5:	eb 2a                	jmp    105e11 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105de7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105deb:	75 17                	jne    105e04 <strtol+0xa0>
  105ded:	8b 45 08             	mov    0x8(%ebp),%eax
  105df0:	0f b6 00             	movzbl (%eax),%eax
  105df3:	3c 30                	cmp    $0x30,%al
  105df5:	75 0d                	jne    105e04 <strtol+0xa0>
        s ++, base = 8;
  105df7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105dfb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105e02:	eb 0d                	jmp    105e11 <strtol+0xad>
    }
    else if (base == 0) {
  105e04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e08:	75 07                	jne    105e11 <strtol+0xad>
        base = 10;
  105e0a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105e11:	8b 45 08             	mov    0x8(%ebp),%eax
  105e14:	0f b6 00             	movzbl (%eax),%eax
  105e17:	3c 2f                	cmp    $0x2f,%al
  105e19:	7e 1b                	jle    105e36 <strtol+0xd2>
  105e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e1e:	0f b6 00             	movzbl (%eax),%eax
  105e21:	3c 39                	cmp    $0x39,%al
  105e23:	7f 11                	jg     105e36 <strtol+0xd2>
            dig = *s - '0';
  105e25:	8b 45 08             	mov    0x8(%ebp),%eax
  105e28:	0f b6 00             	movzbl (%eax),%eax
  105e2b:	0f be c0             	movsbl %al,%eax
  105e2e:	83 e8 30             	sub    $0x30,%eax
  105e31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e34:	eb 48                	jmp    105e7e <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105e36:	8b 45 08             	mov    0x8(%ebp),%eax
  105e39:	0f b6 00             	movzbl (%eax),%eax
  105e3c:	3c 60                	cmp    $0x60,%al
  105e3e:	7e 1b                	jle    105e5b <strtol+0xf7>
  105e40:	8b 45 08             	mov    0x8(%ebp),%eax
  105e43:	0f b6 00             	movzbl (%eax),%eax
  105e46:	3c 7a                	cmp    $0x7a,%al
  105e48:	7f 11                	jg     105e5b <strtol+0xf7>
            dig = *s - 'a' + 10;
  105e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  105e4d:	0f b6 00             	movzbl (%eax),%eax
  105e50:	0f be c0             	movsbl %al,%eax
  105e53:	83 e8 57             	sub    $0x57,%eax
  105e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e59:	eb 23                	jmp    105e7e <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e5e:	0f b6 00             	movzbl (%eax),%eax
  105e61:	3c 40                	cmp    $0x40,%al
  105e63:	7e 3d                	jle    105ea2 <strtol+0x13e>
  105e65:	8b 45 08             	mov    0x8(%ebp),%eax
  105e68:	0f b6 00             	movzbl (%eax),%eax
  105e6b:	3c 5a                	cmp    $0x5a,%al
  105e6d:	7f 33                	jg     105ea2 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105e72:	0f b6 00             	movzbl (%eax),%eax
  105e75:	0f be c0             	movsbl %al,%eax
  105e78:	83 e8 37             	sub    $0x37,%eax
  105e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e81:	3b 45 10             	cmp    0x10(%ebp),%eax
  105e84:	7c 02                	jl     105e88 <strtol+0x124>
            break;
  105e86:	eb 1a                	jmp    105ea2 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105e88:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e8f:	0f af 45 10          	imul   0x10(%ebp),%eax
  105e93:	89 c2                	mov    %eax,%edx
  105e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e98:	01 d0                	add    %edx,%eax
  105e9a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105e9d:	e9 6f ff ff ff       	jmp    105e11 <strtol+0xad>

    if (endptr) {
  105ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105ea6:	74 08                	je     105eb0 <strtol+0x14c>
        *endptr = (char *) s;
  105ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105eab:	8b 55 08             	mov    0x8(%ebp),%edx
  105eae:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105eb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105eb4:	74 07                	je     105ebd <strtol+0x159>
  105eb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105eb9:	f7 d8                	neg    %eax
  105ebb:	eb 03                	jmp    105ec0 <strtol+0x15c>
  105ebd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105ec0:	c9                   	leave  
  105ec1:	c3                   	ret    

00105ec2 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105ec2:	55                   	push   %ebp
  105ec3:	89 e5                	mov    %esp,%ebp
  105ec5:	57                   	push   %edi
  105ec6:	83 ec 24             	sub    $0x24,%esp
  105ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ecc:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105ecf:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  105ed6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105ed9:	88 45 f7             	mov    %al,-0x9(%ebp)
  105edc:	8b 45 10             	mov    0x10(%ebp),%eax
  105edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105ee2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105ee5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105ee9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105eec:	89 d7                	mov    %edx,%edi
  105eee:	f3 aa                	rep stos %al,%es:(%edi)
  105ef0:	89 fa                	mov    %edi,%edx
  105ef2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105ef5:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105efb:	83 c4 24             	add    $0x24,%esp
  105efe:	5f                   	pop    %edi
  105eff:	5d                   	pop    %ebp
  105f00:	c3                   	ret    

00105f01 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105f01:	55                   	push   %ebp
  105f02:	89 e5                	mov    %esp,%ebp
  105f04:	57                   	push   %edi
  105f05:	56                   	push   %esi
  105f06:	53                   	push   %ebx
  105f07:	83 ec 30             	sub    $0x30,%esp
  105f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  105f0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105f16:	8b 45 10             	mov    0x10(%ebp),%eax
  105f19:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f1f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105f22:	73 42                	jae    105f66 <memmove+0x65>
  105f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105f2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105f30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f33:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105f36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105f39:	c1 e8 02             	shr    $0x2,%eax
  105f3c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105f3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f44:	89 d7                	mov    %edx,%edi
  105f46:	89 c6                	mov    %eax,%esi
  105f48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f4a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105f4d:	83 e1 03             	and    $0x3,%ecx
  105f50:	74 02                	je     105f54 <memmove+0x53>
  105f52:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f54:	89 f0                	mov    %esi,%eax
  105f56:	89 fa                	mov    %edi,%edx
  105f58:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105f5b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105f5e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f64:	eb 36                	jmp    105f9c <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105f66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f69:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f6f:	01 c2                	add    %eax,%edx
  105f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f74:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f7a:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105f7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f80:	89 c1                	mov    %eax,%ecx
  105f82:	89 d8                	mov    %ebx,%eax
  105f84:	89 d6                	mov    %edx,%esi
  105f86:	89 c7                	mov    %eax,%edi
  105f88:	fd                   	std    
  105f89:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f8b:	fc                   	cld    
  105f8c:	89 f8                	mov    %edi,%eax
  105f8e:	89 f2                	mov    %esi,%edx
  105f90:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105f93:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105f96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105f9c:	83 c4 30             	add    $0x30,%esp
  105f9f:	5b                   	pop    %ebx
  105fa0:	5e                   	pop    %esi
  105fa1:	5f                   	pop    %edi
  105fa2:	5d                   	pop    %ebp
  105fa3:	c3                   	ret    

00105fa4 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105fa4:	55                   	push   %ebp
  105fa5:	89 e5                	mov    %esp,%ebp
  105fa7:	57                   	push   %edi
  105fa8:	56                   	push   %esi
  105fa9:	83 ec 20             	sub    $0x20,%esp
  105fac:	8b 45 08             	mov    0x8(%ebp),%eax
  105faf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  105fbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105fbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105fc1:	c1 e8 02             	shr    $0x2,%eax
  105fc4:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105fc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fcc:	89 d7                	mov    %edx,%edi
  105fce:	89 c6                	mov    %eax,%esi
  105fd0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105fd2:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105fd5:	83 e1 03             	and    $0x3,%ecx
  105fd8:	74 02                	je     105fdc <memcpy+0x38>
  105fda:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105fdc:	89 f0                	mov    %esi,%eax
  105fde:	89 fa                	mov    %edi,%edx
  105fe0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105fe3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105fe6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105fec:	83 c4 20             	add    $0x20,%esp
  105fef:	5e                   	pop    %esi
  105ff0:	5f                   	pop    %edi
  105ff1:	5d                   	pop    %ebp
  105ff2:	c3                   	ret    

00105ff3 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105ff3:	55                   	push   %ebp
  105ff4:	89 e5                	mov    %esp,%ebp
  105ff6:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  105ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  106002:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  106005:	eb 30                	jmp    106037 <memcmp+0x44>
        if (*s1 != *s2) {
  106007:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10600a:	0f b6 10             	movzbl (%eax),%edx
  10600d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106010:	0f b6 00             	movzbl (%eax),%eax
  106013:	38 c2                	cmp    %al,%dl
  106015:	74 18                	je     10602f <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106017:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10601a:	0f b6 00             	movzbl (%eax),%eax
  10601d:	0f b6 d0             	movzbl %al,%edx
  106020:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106023:	0f b6 00             	movzbl (%eax),%eax
  106026:	0f b6 c0             	movzbl %al,%eax
  106029:	29 c2                	sub    %eax,%edx
  10602b:	89 d0                	mov    %edx,%eax
  10602d:	eb 1a                	jmp    106049 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  10602f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  106033:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  106037:	8b 45 10             	mov    0x10(%ebp),%eax
  10603a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10603d:	89 55 10             	mov    %edx,0x10(%ebp)
  106040:	85 c0                	test   %eax,%eax
  106042:	75 c3                	jne    106007 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  106044:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106049:	c9                   	leave  
  10604a:	c3                   	ret    
