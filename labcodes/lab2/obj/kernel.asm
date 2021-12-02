
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 28 af 11 c0       	mov    $0xc011af28,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 a0 11 c0 	movl   $0xc011a000,(%esp)
c010005d:	e8 60 5e 00 00       	call   c0105ec2 <memset>

    cons_init();                // init the console
c0100062:	e8 90 15 00 00       	call   c01015f7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 60 60 10 c0 	movl   $0xc0106060,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 7c 60 10 c0 	movl   $0xc010607c,(%esp)
c010007c:	e8 c7 02 00 00       	call   c0100348 <cprintf>

    print_kerninfo();
c0100081:	e8 f6 07 00 00       	call   c010087c <print_kerninfo>

    grade_backtrace();
c0100086:	e8 86 00 00 00       	call   c0100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 9d 43 00 00       	call   c010442d <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 cb 16 00 00       	call   c0101760 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 43 18 00 00       	call   c01018dd <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 0e 0d 00 00       	call   c0100dad <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 2a 16 00 00       	call   c01016ce <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	55                   	push   %ebp
c01000a7:	89 e5                	mov    %esp,%ebp
c01000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b3:	00 
c01000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bb:	00 
c01000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c3:	e8 06 0c 00 00       	call   c0100cce <mon_backtrace>
}
c01000c8:	c9                   	leave  
c01000c9:	c3                   	ret    

c01000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000ca:	55                   	push   %ebp
c01000cb:	89 e5                	mov    %esp,%ebp
c01000cd:	53                   	push   %ebx
c01000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000d7:	8d 55 08             	lea    0x8(%ebp),%edx
c01000da:	8b 45 08             	mov    0x8(%ebp),%eax
c01000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000e9:	89 04 24             	mov    %eax,(%esp)
c01000ec:	e8 b5 ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000f1:	83 c4 14             	add    $0x14,%esp
c01000f4:	5b                   	pop    %ebx
c01000f5:	5d                   	pop    %ebp
c01000f6:	c3                   	ret    

c01000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f7:	55                   	push   %ebp
c01000f8:	89 e5                	mov    %esp,%ebp
c01000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0100100:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100104:	8b 45 08             	mov    0x8(%ebp),%eax
c0100107:	89 04 24             	mov    %eax,(%esp)
c010010a:	e8 bb ff ff ff       	call   c01000ca <grade_backtrace1>
}
c010010f:	c9                   	leave  
c0100110:	c3                   	ret    

c0100111 <grade_backtrace>:

void
grade_backtrace(void) {
c0100111:	55                   	push   %ebp
c0100112:	89 e5                	mov    %esp,%ebp
c0100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100117:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100123:	ff 
c0100124:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010012f:	e8 c3 ff ff ff       	call   c01000f7 <grade_backtrace0>
}
c0100134:	c9                   	leave  
c0100135:	c3                   	ret    

c0100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100136:	55                   	push   %ebp
c0100137:	89 e5                	mov    %esp,%ebp
c0100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014c:	0f b7 c0             	movzwl %ax,%eax
c010014f:	83 e0 03             	and    $0x3,%eax
c0100152:	89 c2                	mov    %eax,%edx
c0100154:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100159:	89 54 24 08          	mov    %edx,0x8(%esp)
c010015d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100161:	c7 04 24 81 60 10 c0 	movl   $0xc0106081,(%esp)
c0100168:	e8 db 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100171:	0f b7 d0             	movzwl %ax,%edx
c0100174:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100179:	89 54 24 08          	mov    %edx,0x8(%esp)
c010017d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100181:	c7 04 24 8f 60 10 c0 	movl   $0xc010608f,(%esp)
c0100188:	e8 bb 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100191:	0f b7 d0             	movzwl %ax,%edx
c0100194:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100199:	89 54 24 08          	mov    %edx,0x8(%esp)
c010019d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a1:	c7 04 24 9d 60 10 c0 	movl   $0xc010609d,(%esp)
c01001a8:	e8 9b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b1:	0f b7 d0             	movzwl %ax,%edx
c01001b4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c1:	c7 04 24 ab 60 10 c0 	movl   $0xc01060ab,(%esp)
c01001c8:	e8 7b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d1:	0f b7 d0             	movzwl %ax,%edx
c01001d4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e1:	c7 04 24 b9 60 10 c0 	movl   $0xc01060b9,(%esp)
c01001e8:	e8 5b 01 00 00       	call   c0100348 <cprintf>
    round ++;
c01001ed:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001f2:	83 c0 01             	add    $0x1,%eax
c01001f5:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
}
c01001fa:	c9                   	leave  
c01001fb:	c3                   	ret    

c01001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001fc:	55                   	push   %ebp
c01001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001ff:	5d                   	pop    %ebp
c0100200:	c3                   	ret    

c0100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100201:	55                   	push   %ebp
c0100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100204:	5d                   	pop    %ebp
c0100205:	c3                   	ret    

c0100206 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100206:	55                   	push   %ebp
c0100207:	89 e5                	mov    %esp,%ebp
c0100209:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020c:	e8 25 ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100211:	c7 04 24 c8 60 10 c0 	movl   $0xc01060c8,(%esp)
c0100218:	e8 2b 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_user();
c010021d:	e8 da ff ff ff       	call   c01001fc <lab1_switch_to_user>
    lab1_print_cur_status();
c0100222:	e8 0f ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100227:	c7 04 24 e8 60 10 c0 	movl   $0xc01060e8,(%esp)
c010022e:	e8 15 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_kernel();
c0100233:	e8 c9 ff ff ff       	call   c0100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100238:	e8 f9 fe ff ff       	call   c0100136 <lab1_print_cur_status>
}
c010023d:	c9                   	leave  
c010023e:	c3                   	ret    

c010023f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010023f:	55                   	push   %ebp
c0100240:	89 e5                	mov    %esp,%ebp
c0100242:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100249:	74 13                	je     c010025e <readline+0x1f>
        cprintf("%s", prompt);
c010024b:	8b 45 08             	mov    0x8(%ebp),%eax
c010024e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100252:	c7 04 24 07 61 10 c0 	movl   $0xc0106107,(%esp)
c0100259:	e8 ea 00 00 00       	call   c0100348 <cprintf>
    }
    int i = 0, c;
c010025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100265:	e8 66 01 00 00       	call   c01003d0 <getchar>
c010026a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010026d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100271:	79 07                	jns    c010027a <readline+0x3b>
            return NULL;
c0100273:	b8 00 00 00 00       	mov    $0x0,%eax
c0100278:	eb 79                	jmp    c01002f3 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010027e:	7e 28                	jle    c01002a8 <readline+0x69>
c0100280:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100287:	7f 1f                	jg     c01002a8 <readline+0x69>
            cputchar(c);
c0100289:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028c:	89 04 24             	mov    %eax,(%esp)
c010028f:	e8 da 00 00 00       	call   c010036e <cputchar>
            buf[i ++] = c;
c0100294:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100297:	8d 50 01             	lea    0x1(%eax),%edx
c010029a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010029d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a0:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
c01002a6:	eb 46                	jmp    c01002ee <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002a8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002ac:	75 17                	jne    c01002c5 <readline+0x86>
c01002ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b2:	7e 11                	jle    c01002c5 <readline+0x86>
            cputchar(c);
c01002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b7:	89 04 24             	mov    %eax,(%esp)
c01002ba:	e8 af 00 00 00       	call   c010036e <cputchar>
            i --;
c01002bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c3:	eb 29                	jmp    c01002ee <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c9:	74 06                	je     c01002d1 <readline+0x92>
c01002cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002cf:	75 1d                	jne    c01002ee <readline+0xaf>
            cputchar(c);
c01002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d4:	89 04 24             	mov    %eax,(%esp)
c01002d7:	e8 92 00 00 00       	call   c010036e <cputchar>
            buf[i] = '\0';
c01002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002df:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01002e4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e7:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
c01002ec:	eb 05                	jmp    c01002f3 <readline+0xb4>
        }
    }
c01002ee:	e9 72 ff ff ff       	jmp    c0100265 <readline+0x26>
}
c01002f3:	c9                   	leave  
c01002f4:	c3                   	ret    

c01002f5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f5:	55                   	push   %ebp
c01002f6:	89 e5                	mov    %esp,%ebp
c01002f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fe:	89 04 24             	mov    %eax,(%esp)
c0100301:	e8 1d 13 00 00       	call   c0101623 <cons_putc>
    (*cnt) ++;
c0100306:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100309:	8b 00                	mov    (%eax),%eax
c010030b:	8d 50 01             	lea    0x1(%eax),%edx
c010030e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100311:	89 10                	mov    %edx,(%eax)
}
c0100313:	c9                   	leave  
c0100314:	c3                   	ret    

c0100315 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100315:	55                   	push   %ebp
c0100316:	89 e5                	mov    %esp,%ebp
c0100318:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100322:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100325:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100329:	8b 45 08             	mov    0x8(%ebp),%eax
c010032c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100330:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100333:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100337:	c7 04 24 f5 02 10 c0 	movl   $0xc01002f5,(%esp)
c010033e:	e8 98 53 00 00       	call   c01056db <vprintfmt>
    return cnt;
c0100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100346:	c9                   	leave  
c0100347:	c3                   	ret    

c0100348 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100348:	55                   	push   %ebp
c0100349:	89 e5                	mov    %esp,%ebp
c010034b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010034e:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100354:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100357:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035b:	8b 45 08             	mov    0x8(%ebp),%eax
c010035e:	89 04 24             	mov    %eax,(%esp)
c0100361:	e8 af ff ff ff       	call   c0100315 <vcprintf>
c0100366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100369:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036c:	c9                   	leave  
c010036d:	c3                   	ret    

c010036e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010036e:	55                   	push   %ebp
c010036f:	89 e5                	mov    %esp,%ebp
c0100371:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100374:	8b 45 08             	mov    0x8(%ebp),%eax
c0100377:	89 04 24             	mov    %eax,(%esp)
c010037a:	e8 a4 12 00 00       	call   c0101623 <cons_putc>
}
c010037f:	c9                   	leave  
c0100380:	c3                   	ret    

c0100381 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100381:	55                   	push   %ebp
c0100382:	89 e5                	mov    %esp,%ebp
c0100384:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038e:	eb 13                	jmp    c01003a3 <cputs+0x22>
        cputch(c, &cnt);
c0100390:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100397:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039b:	89 04 24             	mov    %eax,(%esp)
c010039e:	e8 52 ff ff ff       	call   c01002f5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a6:	8d 50 01             	lea    0x1(%eax),%edx
c01003a9:	89 55 08             	mov    %edx,0x8(%ebp)
c01003ac:	0f b6 00             	movzbl (%eax),%eax
c01003af:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b6:	75 d8                	jne    c0100390 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003bf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c6:	e8 2a ff ff ff       	call   c01002f5 <cputch>
    return cnt;
c01003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003ce:	c9                   	leave  
c01003cf:	c3                   	ret    

c01003d0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d0:	55                   	push   %ebp
c01003d1:	89 e5                	mov    %esp,%ebp
c01003d3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d6:	e8 84 12 00 00       	call   c010165f <cons_getc>
c01003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e2:	74 f2                	je     c01003d6 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003e7:	c9                   	leave  
c01003e8:	c3                   	ret    

c01003e9 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003e9:	55                   	push   %ebp
c01003ea:	89 e5                	mov    %esp,%ebp
c01003ec:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f2:	8b 00                	mov    (%eax),%eax
c01003f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fa:	8b 00                	mov    (%eax),%eax
c01003fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100406:	e9 d2 00 00 00       	jmp    c01004dd <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010040e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100411:	01 d0                	add    %edx,%eax
c0100413:	89 c2                	mov    %eax,%edx
c0100415:	c1 ea 1f             	shr    $0x1f,%edx
c0100418:	01 d0                	add    %edx,%eax
c010041a:	d1 f8                	sar    %eax
c010041c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100422:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100425:	eb 04                	jmp    c010042b <stab_binsearch+0x42>
            m --;
c0100427:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010042e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100431:	7c 1f                	jl     c0100452 <stab_binsearch+0x69>
c0100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100436:	89 d0                	mov    %edx,%eax
c0100438:	01 c0                	add    %eax,%eax
c010043a:	01 d0                	add    %edx,%eax
c010043c:	c1 e0 02             	shl    $0x2,%eax
c010043f:	89 c2                	mov    %eax,%edx
c0100441:	8b 45 08             	mov    0x8(%ebp),%eax
c0100444:	01 d0                	add    %edx,%eax
c0100446:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044a:	0f b6 c0             	movzbl %al,%eax
c010044d:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100450:	75 d5                	jne    c0100427 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100452:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100455:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100458:	7d 0b                	jge    c0100465 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010045d:	83 c0 01             	add    $0x1,%eax
c0100460:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100463:	eb 78                	jmp    c01004dd <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100465:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010046f:	89 d0                	mov    %edx,%eax
c0100471:	01 c0                	add    %eax,%eax
c0100473:	01 d0                	add    %edx,%eax
c0100475:	c1 e0 02             	shl    $0x2,%eax
c0100478:	89 c2                	mov    %eax,%edx
c010047a:	8b 45 08             	mov    0x8(%ebp),%eax
c010047d:	01 d0                	add    %edx,%eax
c010047f:	8b 40 08             	mov    0x8(%eax),%eax
c0100482:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100485:	73 13                	jae    c010049a <stab_binsearch+0xb1>
            *region_left = m;
c0100487:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010048f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100492:	83 c0 01             	add    $0x1,%eax
c0100495:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100498:	eb 43                	jmp    c01004dd <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049d:	89 d0                	mov    %edx,%eax
c010049f:	01 c0                	add    %eax,%eax
c01004a1:	01 d0                	add    %edx,%eax
c01004a3:	c1 e0 02             	shl    $0x2,%eax
c01004a6:	89 c2                	mov    %eax,%edx
c01004a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ab:	01 d0                	add    %edx,%eax
c01004ad:	8b 40 08             	mov    0x8(%eax),%eax
c01004b0:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b3:	76 16                	jbe    c01004cb <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004be:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	83 e8 01             	sub    $0x1,%eax
c01004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c9:	eb 12                	jmp    c01004dd <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d1:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004d9:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e3:	0f 8e 22 ff ff ff    	jle    c010040b <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004ed:	75 0f                	jne    c01004fe <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f2:	8b 00                	mov    (%eax),%eax
c01004f4:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fa:	89 10                	mov    %edx,(%eax)
c01004fc:	eb 3f                	jmp    c010053d <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0100501:	8b 00                	mov    (%eax),%eax
c0100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100506:	eb 04                	jmp    c010050c <stab_binsearch+0x123>
c0100508:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050f:	8b 00                	mov    (%eax),%eax
c0100511:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100514:	7d 1f                	jge    c0100535 <stab_binsearch+0x14c>
c0100516:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100519:	89 d0                	mov    %edx,%eax
c010051b:	01 c0                	add    %eax,%eax
c010051d:	01 d0                	add    %edx,%eax
c010051f:	c1 e0 02             	shl    $0x2,%eax
c0100522:	89 c2                	mov    %eax,%edx
c0100524:	8b 45 08             	mov    0x8(%ebp),%eax
c0100527:	01 d0                	add    %edx,%eax
c0100529:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010052d:	0f b6 c0             	movzbl %al,%eax
c0100530:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100533:	75 d3                	jne    c0100508 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100535:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100538:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053b:	89 10                	mov    %edx,(%eax)
    }
}
c010053d:	c9                   	leave  
c010053e:	c3                   	ret    

c010053f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010053f:	55                   	push   %ebp
c0100540:	89 e5                	mov    %esp,%ebp
c0100542:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100545:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100548:	c7 00 0c 61 10 c0    	movl   $0xc010610c,(%eax)
    info->eip_line = 0;
c010054e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100558:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055b:	c7 40 08 0c 61 10 c0 	movl   $0xc010610c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100562:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100565:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100572:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100575:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100578:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010057f:	c7 45 f4 d0 73 10 c0 	movl   $0xc01073d0,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100586:	c7 45 f0 e4 1f 11 c0 	movl   $0xc0111fe4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010058d:	c7 45 ec e5 1f 11 c0 	movl   $0xc0111fe5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100594:	c7 45 e8 1d 4a 11 c0 	movl   $0xc0114a1d,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a1:	76 0d                	jbe    c01005b0 <debuginfo_eip+0x71>
c01005a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a6:	83 e8 01             	sub    $0x1,%eax
c01005a9:	0f b6 00             	movzbl (%eax),%eax
c01005ac:	84 c0                	test   %al,%al
c01005ae:	74 0a                	je     c01005ba <debuginfo_eip+0x7b>
        return -1;
c01005b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b5:	e9 c0 02 00 00       	jmp    c010087a <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005c7:	29 c2                	sub    %eax,%edx
c01005c9:	89 d0                	mov    %edx,%eax
c01005cb:	c1 f8 02             	sar    $0x2,%eax
c01005ce:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d4:	83 e8 01             	sub    $0x1,%eax
c01005d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005da:	8b 45 08             	mov    0x8(%ebp),%eax
c01005dd:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005e8:	00 
c01005e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fa:	89 04 24             	mov    %eax,(%esp)
c01005fd:	e8 e7 fd ff ff       	call   c01003e9 <stab_binsearch>
    if (lfile == 0)
c0100602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100605:	85 c0                	test   %eax,%eax
c0100607:	75 0a                	jne    c0100613 <debuginfo_eip+0xd4>
        return -1;
c0100609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060e:	e9 67 02 00 00       	jmp    c010087a <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100616:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100619:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010061f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100622:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100626:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010062d:	00 
c010062e:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100631:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100635:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100638:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063f:	89 04 24             	mov    %eax,(%esp)
c0100642:	e8 a2 fd ff ff       	call   c01003e9 <stab_binsearch>

    if (lfun <= rfun) {
c0100647:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010064d:	39 c2                	cmp    %eax,%edx
c010064f:	7f 7c                	jg     c01006cd <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100651:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100654:	89 c2                	mov    %eax,%edx
c0100656:	89 d0                	mov    %edx,%eax
c0100658:	01 c0                	add    %eax,%eax
c010065a:	01 d0                	add    %edx,%eax
c010065c:	c1 e0 02             	shl    $0x2,%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100664:	01 d0                	add    %edx,%eax
c0100666:	8b 10                	mov    (%eax),%edx
c0100668:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066e:	29 c1                	sub    %eax,%ecx
c0100670:	89 c8                	mov    %ecx,%eax
c0100672:	39 c2                	cmp    %eax,%edx
c0100674:	73 22                	jae    c0100698 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100676:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100679:	89 c2                	mov    %eax,%edx
c010067b:	89 d0                	mov    %edx,%eax
c010067d:	01 c0                	add    %eax,%eax
c010067f:	01 d0                	add    %edx,%eax
c0100681:	c1 e0 02             	shl    $0x2,%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100689:	01 d0                	add    %edx,%eax
c010068b:	8b 10                	mov    (%eax),%edx
c010068d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100690:	01 c2                	add    %eax,%edx
c0100692:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100695:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100698:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069b:	89 c2                	mov    %eax,%edx
c010069d:	89 d0                	mov    %edx,%eax
c010069f:	01 c0                	add    %eax,%eax
c01006a1:	01 d0                	add    %edx,%eax
c01006a3:	c1 e0 02             	shl    $0x2,%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ab:	01 d0                	add    %edx,%eax
c01006ad:	8b 50 08             	mov    0x8(%eax),%edx
c01006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b9:	8b 40 10             	mov    0x10(%eax),%eax
c01006bc:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006cb:	eb 15                	jmp    c01006e2 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d0:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e5:	8b 40 08             	mov    0x8(%eax),%eax
c01006e8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006ef:	00 
c01006f0:	89 04 24             	mov    %eax,(%esp)
c01006f3:	e8 3e 56 00 00       	call   c0105d36 <strfind>
c01006f8:	89 c2                	mov    %eax,%edx
c01006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006fd:	8b 40 08             	mov    0x8(%eax),%eax
c0100700:	29 c2                	sub    %eax,%edx
c0100702:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100705:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100708:	8b 45 08             	mov    0x8(%ebp),%eax
c010070b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010070f:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100716:	00 
c0100717:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010071e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100721:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100728:	89 04 24             	mov    %eax,(%esp)
c010072b:	e8 b9 fc ff ff       	call   c01003e9 <stab_binsearch>
    if (lline <= rline) {
c0100730:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100733:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100736:	39 c2                	cmp    %eax,%edx
c0100738:	7f 24                	jg     c010075e <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073d:	89 c2                	mov    %eax,%edx
c010073f:	89 d0                	mov    %edx,%eax
c0100741:	01 c0                	add    %eax,%eax
c0100743:	01 d0                	add    %edx,%eax
c0100745:	c1 e0 02             	shl    $0x2,%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074d:	01 d0                	add    %edx,%eax
c010074f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100753:	0f b7 d0             	movzwl %ax,%edx
c0100756:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100759:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075c:	eb 13                	jmp    c0100771 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010075e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100763:	e9 12 01 00 00       	jmp    c010087a <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076b:	83 e8 01             	sub    $0x1,%eax
c010076e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100777:	39 c2                	cmp    %eax,%edx
c0100779:	7c 56                	jl     c01007d1 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077e:	89 c2                	mov    %eax,%edx
c0100780:	89 d0                	mov    %edx,%eax
c0100782:	01 c0                	add    %eax,%eax
c0100784:	01 d0                	add    %edx,%eax
c0100786:	c1 e0 02             	shl    $0x2,%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078e:	01 d0                	add    %edx,%eax
c0100790:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100794:	3c 84                	cmp    $0x84,%al
c0100796:	74 39                	je     c01007d1 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	89 d0                	mov    %edx,%eax
c010079f:	01 c0                	add    %eax,%eax
c01007a1:	01 d0                	add    %edx,%eax
c01007a3:	c1 e0 02             	shl    $0x2,%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ab:	01 d0                	add    %edx,%eax
c01007ad:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b1:	3c 64                	cmp    $0x64,%al
c01007b3:	75 b3                	jne    c0100768 <debuginfo_eip+0x229>
c01007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007b8:	89 c2                	mov    %eax,%edx
c01007ba:	89 d0                	mov    %edx,%eax
c01007bc:	01 c0                	add    %eax,%eax
c01007be:	01 d0                	add    %edx,%eax
c01007c0:	c1 e0 02             	shl    $0x2,%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c8:	01 d0                	add    %edx,%eax
c01007ca:	8b 40 08             	mov    0x8(%eax),%eax
c01007cd:	85 c0                	test   %eax,%eax
c01007cf:	74 97                	je     c0100768 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007d7:	39 c2                	cmp    %eax,%edx
c01007d9:	7c 46                	jl     c0100821 <debuginfo_eip+0x2e2>
c01007db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007de:	89 c2                	mov    %eax,%edx
c01007e0:	89 d0                	mov    %edx,%eax
c01007e2:	01 c0                	add    %eax,%eax
c01007e4:	01 d0                	add    %edx,%eax
c01007e6:	c1 e0 02             	shl    $0x2,%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ee:	01 d0                	add    %edx,%eax
c01007f0:	8b 10                	mov    (%eax),%edx
c01007f2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007f8:	29 c1                	sub    %eax,%ecx
c01007fa:	89 c8                	mov    %ecx,%eax
c01007fc:	39 c2                	cmp    %eax,%edx
c01007fe:	73 21                	jae    c0100821 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100803:	89 c2                	mov    %eax,%edx
c0100805:	89 d0                	mov    %edx,%eax
c0100807:	01 c0                	add    %eax,%eax
c0100809:	01 d0                	add    %edx,%eax
c010080b:	c1 e0 02             	shl    $0x2,%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100813:	01 d0                	add    %edx,%eax
c0100815:	8b 10                	mov    (%eax),%edx
c0100817:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081a:	01 c2                	add    %eax,%edx
c010081c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100821:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100824:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100827:	39 c2                	cmp    %eax,%edx
c0100829:	7d 4a                	jge    c0100875 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010082e:	83 c0 01             	add    $0x1,%eax
c0100831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100834:	eb 18                	jmp    c010084e <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100836:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100839:	8b 40 14             	mov    0x14(%eax),%eax
c010083c:	8d 50 01             	lea    0x1(%eax),%edx
c010083f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100842:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100848:	83 c0 01             	add    $0x1,%eax
c010084b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100851:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100854:	39 c2                	cmp    %eax,%edx
c0100856:	7d 1d                	jge    c0100875 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	89 d0                	mov    %edx,%eax
c010085f:	01 c0                	add    %eax,%eax
c0100861:	01 d0                	add    %edx,%eax
c0100863:	c1 e0 02             	shl    $0x2,%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086b:	01 d0                	add    %edx,%eax
c010086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100871:	3c a0                	cmp    $0xa0,%al
c0100873:	74 c1                	je     c0100836 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100875:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087a:	c9                   	leave  
c010087b:	c3                   	ret    

c010087c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087c:	55                   	push   %ebp
c010087d:	89 e5                	mov    %esp,%ebp
c010087f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100882:	c7 04 24 16 61 10 c0 	movl   $0xc0106116,(%esp)
c0100889:	e8 ba fa ff ff       	call   c0100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088e:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100895:	c0 
c0100896:	c7 04 24 2f 61 10 c0 	movl   $0xc010612f,(%esp)
c010089d:	e8 a6 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a2:	c7 44 24 04 4b 60 10 	movl   $0xc010604b,0x4(%esp)
c01008a9:	c0 
c01008aa:	c7 04 24 47 61 10 c0 	movl   $0xc0106147,(%esp)
c01008b1:	e8 92 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b6:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c01008bd:	c0 
c01008be:	c7 04 24 5f 61 10 c0 	movl   $0xc010615f,(%esp)
c01008c5:	e8 7e fa ff ff       	call   c0100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008ca:	c7 44 24 04 28 af 11 	movl   $0xc011af28,0x4(%esp)
c01008d1:	c0 
c01008d2:	c7 04 24 77 61 10 c0 	movl   $0xc0106177,(%esp)
c01008d9:	e8 6a fa ff ff       	call   c0100348 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008de:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c01008e3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008e9:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01008ee:	29 c2                	sub    %eax,%edx
c01008f0:	89 d0                	mov    %edx,%eax
c01008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f8:	85 c0                	test   %eax,%eax
c01008fa:	0f 48 c2             	cmovs  %edx,%eax
c01008fd:	c1 f8 0a             	sar    $0xa,%eax
c0100900:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100904:	c7 04 24 90 61 10 c0 	movl   $0xc0106190,(%esp)
c010090b:	e8 38 fa ff ff       	call   c0100348 <cprintf>
}
c0100910:	c9                   	leave  
c0100911:	c3                   	ret    

c0100912 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100912:	55                   	push   %ebp
c0100913:	89 e5                	mov    %esp,%ebp
c0100915:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091b:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010091e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100922:	8b 45 08             	mov    0x8(%ebp),%eax
c0100925:	89 04 24             	mov    %eax,(%esp)
c0100928:	e8 12 fc ff ff       	call   c010053f <debuginfo_eip>
c010092d:	85 c0                	test   %eax,%eax
c010092f:	74 15                	je     c0100946 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100931:	8b 45 08             	mov    0x8(%ebp),%eax
c0100934:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100938:	c7 04 24 ba 61 10 c0 	movl   $0xc01061ba,(%esp)
c010093f:	e8 04 fa ff ff       	call   c0100348 <cprintf>
c0100944:	eb 6d                	jmp    c01009b3 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010094d:	eb 1c                	jmp    c010096b <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100955:	01 d0                	add    %edx,%eax
c0100957:	0f b6 00             	movzbl (%eax),%eax
c010095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100963:	01 ca                	add    %ecx,%edx
c0100965:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100971:	7f dc                	jg     c010094f <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097c:	01 d0                	add    %edx,%eax
c010097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100984:	8b 55 08             	mov    0x8(%ebp),%edx
c0100987:	89 d1                	mov    %edx,%ecx
c0100989:	29 c1                	sub    %eax,%ecx
c010098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010099f:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a7:	c7 04 24 d6 61 10 c0 	movl   $0xc01061d6,(%esp)
c01009ae:	e8 95 f9 ff ff       	call   c0100348 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b3:	c9                   	leave  
c01009b4:	c3                   	ret    

c01009b5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b5:	55                   	push   %ebp
c01009b6:	89 e5                	mov    %esp,%ebp
c01009b8:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009bb:	8b 45 04             	mov    0x4(%ebp),%eax
c01009be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c4:	c9                   	leave  
c01009c5:	c3                   	ret    

c01009c6 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c6:	55                   	push   %ebp
c01009c7:	89 e5                	mov    %esp,%ebp
c01009c9:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cc:	89 e8                	mov    %ebp,%eax
c01009ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	// 读取当前栈帧的ebp和eip
	uint32_t ebp = read_ebp();
c01009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
   	uint32_t eip = read_eip();
c01009d7:	e8 d9 ff ff ff       	call   c01009b5 <read_eip>
c01009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32_t i = 0, j = 0;
c01009df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
c01009ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f4:	e9 88 00 00 00       	jmp    c0100a81 <print_stackframe+0xbb>
	{
        // 读取
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009fc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a07:	c7 04 24 e8 61 10 c0 	movl   $0xc01061e8,(%esp)
c0100a0e:	e8 35 f9 ff ff       	call   c0100348 <cprintf>
        uint32_t* args = (uint32_t*)ebp + 2 ;
c0100a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a16:	83 c0 08             	add    $0x8,%eax
c0100a19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for(j = 0; j < 4; j++)
c0100a1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a23:	eb 25                	jmp    c0100a4a <print_stackframe+0x84>
            cprintf("0x%08x ", args[j]);
c0100a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a32:	01 d0                	add    %edx,%eax
c0100a34:	8b 00                	mov    (%eax),%eax
c0100a36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3a:	c7 04 24 04 62 10 c0 	movl   $0xc0106204,(%esp)
c0100a41:	e8 02 f9 ff ff       	call   c0100348 <cprintf>
    	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
	{
        // 读取
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t* args = (uint32_t*)ebp + 2 ;
        for(j = 0; j < 4; j++)
c0100a46:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a4a:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4e:	76 d5                	jbe    c0100a25 <print_stackframe+0x5f>
            cprintf("0x%08x ", args[j]);
        cprintf("\n");
c0100a50:	c7 04 24 0c 62 10 c0 	movl   $0xc010620c,(%esp)
c0100a57:	e8 ec f8 ff ff       	call   c0100348 <cprintf>
        // eip指向异常指令的下一条指令，所以要减1
        print_debuginfo(eip-1);
c0100a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a5f:	83 e8 01             	sub    $0x1,%eax
c0100a62:	89 04 24             	mov    %eax,(%esp)
c0100a65:	e8 a8 fe ff ff       	call   c0100912 <print_debuginfo>
        // 将ebp 和eip设置为上一个栈帧的ebp和eip
        //  注意要先设置eip后设置ebp，否则当ebp被修改后，eip就无法找到正确的位置
        eip = *((uint32_t*)ebp + 1);
c0100a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6d:	83 c0 04             	add    $0x4,%eax
c0100a70:	8b 00                	mov    (%eax),%eax
c0100a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *(uint32_t*)ebp;
c0100a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a78:	8b 00                	mov    (%eax),%eax
c0100a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */
	// 读取当前栈帧的ebp和eip
	uint32_t ebp = read_ebp();
   	uint32_t eip = read_eip();
	uint32_t i = 0, j = 0;
    	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
c0100a7d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a85:	74 0a                	je     c0100a91 <print_stackframe+0xcb>
c0100a87:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a8b:	0f 86 68 ff ff ff    	jbe    c01009f9 <print_stackframe+0x33>
        // 将ebp 和eip设置为上一个栈帧的ebp和eip
        //  注意要先设置eip后设置ebp，否则当ebp被修改后，eip就无法找到正确的位置
        eip = *((uint32_t*)ebp + 1);
        ebp = *(uint32_t*)ebp;
    }
}
c0100a91:	c9                   	leave  
c0100a92:	c3                   	ret    

c0100a93 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a93:	55                   	push   %ebp
c0100a94:	89 e5                	mov    %esp,%ebp
c0100a96:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa0:	eb 0c                	jmp    c0100aae <parse+0x1b>
            *buf ++ = '\0';
c0100aa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa5:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa8:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aab:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab1:	0f b6 00             	movzbl (%eax),%eax
c0100ab4:	84 c0                	test   %al,%al
c0100ab6:	74 1d                	je     c0100ad5 <parse+0x42>
c0100ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abb:	0f b6 00             	movzbl (%eax),%eax
c0100abe:	0f be c0             	movsbl %al,%eax
c0100ac1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac5:	c7 04 24 90 62 10 c0 	movl   $0xc0106290,(%esp)
c0100acc:	e8 32 52 00 00       	call   c0105d03 <strchr>
c0100ad1:	85 c0                	test   %eax,%eax
c0100ad3:	75 cd                	jne    c0100aa2 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ad5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad8:	0f b6 00             	movzbl (%eax),%eax
c0100adb:	84 c0                	test   %al,%al
c0100add:	75 02                	jne    c0100ae1 <parse+0x4e>
            break;
c0100adf:	eb 67                	jmp    c0100b48 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ae1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae5:	75 14                	jne    c0100afb <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aee:	00 
c0100aef:	c7 04 24 95 62 10 c0 	movl   $0xc0106295,(%esp)
c0100af6:	e8 4d f8 ff ff       	call   c0100348 <cprintf>
        }
        argv[argc ++] = buf;
c0100afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afe:	8d 50 01             	lea    0x1(%eax),%edx
c0100b01:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0e:	01 c2                	add    %eax,%edx
c0100b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b13:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b15:	eb 04                	jmp    c0100b1b <parse+0x88>
            buf ++;
c0100b17:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1e:	0f b6 00             	movzbl (%eax),%eax
c0100b21:	84 c0                	test   %al,%al
c0100b23:	74 1d                	je     c0100b42 <parse+0xaf>
c0100b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b28:	0f b6 00             	movzbl (%eax),%eax
c0100b2b:	0f be c0             	movsbl %al,%eax
c0100b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b32:	c7 04 24 90 62 10 c0 	movl   $0xc0106290,(%esp)
c0100b39:	e8 c5 51 00 00       	call   c0105d03 <strchr>
c0100b3e:	85 c0                	test   %eax,%eax
c0100b40:	74 d5                	je     c0100b17 <parse+0x84>
            buf ++;
        }
    }
c0100b42:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b43:	e9 66 ff ff ff       	jmp    c0100aae <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b4b:	c9                   	leave  
c0100b4c:	c3                   	ret    

c0100b4d <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b4d:	55                   	push   %ebp
c0100b4e:	89 e5                	mov    %esp,%ebp
c0100b50:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b53:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5d:	89 04 24             	mov    %eax,(%esp)
c0100b60:	e8 2e ff ff ff       	call   c0100a93 <parse>
c0100b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b6c:	75 0a                	jne    c0100b78 <runcmd+0x2b>
        return 0;
c0100b6e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b73:	e9 85 00 00 00       	jmp    c0100bfd <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b7f:	eb 5c                	jmp    c0100bdd <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b81:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b84:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b87:	89 d0                	mov    %edx,%eax
c0100b89:	01 c0                	add    %eax,%eax
c0100b8b:	01 d0                	add    %edx,%eax
c0100b8d:	c1 e0 02             	shl    $0x2,%eax
c0100b90:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100b95:	8b 00                	mov    (%eax),%eax
c0100b97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b9b:	89 04 24             	mov    %eax,(%esp)
c0100b9e:	e8 c1 50 00 00       	call   c0105c64 <strcmp>
c0100ba3:	85 c0                	test   %eax,%eax
c0100ba5:	75 32                	jne    c0100bd9 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100baa:	89 d0                	mov    %edx,%eax
c0100bac:	01 c0                	add    %eax,%eax
c0100bae:	01 d0                	add    %edx,%eax
c0100bb0:	c1 e0 02             	shl    $0x2,%eax
c0100bb3:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100bb8:	8b 40 08             	mov    0x8(%eax),%eax
c0100bbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bbe:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bc4:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bc8:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bcb:	83 c2 04             	add    $0x4,%edx
c0100bce:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bd2:	89 0c 24             	mov    %ecx,(%esp)
c0100bd5:	ff d0                	call   *%eax
c0100bd7:	eb 24                	jmp    c0100bfd <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100be0:	83 f8 02             	cmp    $0x2,%eax
c0100be3:	76 9c                	jbe    c0100b81 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bec:	c7 04 24 b3 62 10 c0 	movl   $0xc01062b3,(%esp)
c0100bf3:	e8 50 f7 ff ff       	call   c0100348 <cprintf>
    return 0;
c0100bf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bfd:	c9                   	leave  
c0100bfe:	c3                   	ret    

c0100bff <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bff:	55                   	push   %ebp
c0100c00:	89 e5                	mov    %esp,%ebp
c0100c02:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c05:	c7 04 24 cc 62 10 c0 	movl   $0xc01062cc,(%esp)
c0100c0c:	e8 37 f7 ff ff       	call   c0100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c11:	c7 04 24 f4 62 10 c0 	movl   $0xc01062f4,(%esp)
c0100c18:	e8 2b f7 ff ff       	call   c0100348 <cprintf>

    if (tf != NULL) {
c0100c1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c21:	74 0b                	je     c0100c2e <kmonitor+0x2f>
        print_trapframe(tf);
c0100c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c26:	89 04 24             	mov    %eax,(%esp)
c0100c29:	e8 67 0e 00 00       	call   c0101a95 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c2e:	c7 04 24 19 63 10 c0 	movl   $0xc0106319,(%esp)
c0100c35:	e8 05 f6 ff ff       	call   c010023f <readline>
c0100c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c41:	74 18                	je     c0100c5b <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c43:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c4d:	89 04 24             	mov    %eax,(%esp)
c0100c50:	e8 f8 fe ff ff       	call   c0100b4d <runcmd>
c0100c55:	85 c0                	test   %eax,%eax
c0100c57:	79 02                	jns    c0100c5b <kmonitor+0x5c>
                break;
c0100c59:	eb 02                	jmp    c0100c5d <kmonitor+0x5e>
            }
        }
    }
c0100c5b:	eb d1                	jmp    c0100c2e <kmonitor+0x2f>
}
c0100c5d:	c9                   	leave  
c0100c5e:	c3                   	ret    

c0100c5f <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c5f:	55                   	push   %ebp
c0100c60:	89 e5                	mov    %esp,%ebp
c0100c62:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c6c:	eb 3f                	jmp    c0100cad <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c71:	89 d0                	mov    %edx,%eax
c0100c73:	01 c0                	add    %eax,%eax
c0100c75:	01 d0                	add    %edx,%eax
c0100c77:	c1 e0 02             	shl    $0x2,%eax
c0100c7a:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c7f:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c85:	89 d0                	mov    %edx,%eax
c0100c87:	01 c0                	add    %eax,%eax
c0100c89:	01 d0                	add    %edx,%eax
c0100c8b:	c1 e0 02             	shl    $0x2,%eax
c0100c8e:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c93:	8b 00                	mov    (%eax),%eax
c0100c95:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c9d:	c7 04 24 1d 63 10 c0 	movl   $0xc010631d,(%esp)
c0100ca4:	e8 9f f6 ff ff       	call   c0100348 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cb0:	83 f8 02             	cmp    $0x2,%eax
c0100cb3:	76 b9                	jbe    c0100c6e <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cba:	c9                   	leave  
c0100cbb:	c3                   	ret    

c0100cbc <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cbc:	55                   	push   %ebp
c0100cbd:	89 e5                	mov    %esp,%ebp
c0100cbf:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cc2:	e8 b5 fb ff ff       	call   c010087c <print_kerninfo>
    return 0;
c0100cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccc:	c9                   	leave  
c0100ccd:	c3                   	ret    

c0100cce <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cce:	55                   	push   %ebp
c0100ccf:	89 e5                	mov    %esp,%ebp
c0100cd1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cd4:	e8 ed fc ff ff       	call   c01009c6 <print_stackframe>
    return 0;
c0100cd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cde:	c9                   	leave  
c0100cdf:	c3                   	ret    

c0100ce0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ce0:	55                   	push   %ebp
c0100ce1:	89 e5                	mov    %esp,%ebp
c0100ce3:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce6:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c0100ceb:	85 c0                	test   %eax,%eax
c0100ced:	74 02                	je     c0100cf1 <__panic+0x11>
        goto panic_dead;
c0100cef:	eb 59                	jmp    c0100d4a <__panic+0x6a>
    }
    is_panic = 1;
c0100cf1:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
c0100cf8:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cfb:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d04:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0f:	c7 04 24 26 63 10 c0 	movl   $0xc0106326,(%esp)
c0100d16:	e8 2d f6 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d22:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d25:	89 04 24             	mov    %eax,(%esp)
c0100d28:	e8 e8 f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d2d:	c7 04 24 42 63 10 c0 	movl   $0xc0106342,(%esp)
c0100d34:	e8 0f f6 ff ff       	call   c0100348 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d39:	c7 04 24 44 63 10 c0 	movl   $0xc0106344,(%esp)
c0100d40:	e8 03 f6 ff ff       	call   c0100348 <cprintf>
    print_stackframe();
c0100d45:	e8 7c fc ff ff       	call   c01009c6 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d4a:	e8 85 09 00 00       	call   c01016d4 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d56:	e8 a4 fe ff ff       	call   c0100bff <kmonitor>
    }
c0100d5b:	eb f2                	jmp    c0100d4f <__panic+0x6f>

c0100d5d <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d5d:	55                   	push   %ebp
c0100d5e:	89 e5                	mov    %esp,%ebp
c0100d60:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d63:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d6c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d70:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d73:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d77:	c7 04 24 56 63 10 c0 	movl   $0xc0106356,(%esp)
c0100d7e:	e8 c5 f5 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d86:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d8a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d8d:	89 04 24             	mov    %eax,(%esp)
c0100d90:	e8 80 f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d95:	c7 04 24 42 63 10 c0 	movl   $0xc0106342,(%esp)
c0100d9c:	e8 a7 f5 ff ff       	call   c0100348 <cprintf>
    va_end(ap);
}
c0100da1:	c9                   	leave  
c0100da2:	c3                   	ret    

c0100da3 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100da3:	55                   	push   %ebp
c0100da4:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100da6:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
}
c0100dab:	5d                   	pop    %ebp
c0100dac:	c3                   	ret    

c0100dad <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dad:	55                   	push   %ebp
c0100dae:	89 e5                	mov    %esp,%ebp
c0100db0:	83 ec 28             	sub    $0x28,%esp
c0100db3:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100db9:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dbd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dc1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dc5:	ee                   	out    %al,(%dx)
c0100dc6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dcc:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dd0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dd4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dd8:	ee                   	out    %al,(%dx)
c0100dd9:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100ddf:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100de3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100de7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100deb:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dec:	c7 05 0c af 11 c0 00 	movl   $0x0,0xc011af0c
c0100df3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100df6:	c7 04 24 74 63 10 c0 	movl   $0xc0106374,(%esp)
c0100dfd:	e8 46 f5 ff ff       	call   c0100348 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e09:	e8 24 09 00 00       	call   c0101732 <pic_enable>
}
c0100e0e:	c9                   	leave  
c0100e0f:	c3                   	ret    

c0100e10 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e10:	55                   	push   %ebp
c0100e11:	89 e5                	mov    %esp,%ebp
c0100e13:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e16:	9c                   	pushf  
c0100e17:	58                   	pop    %eax
c0100e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e1e:	25 00 02 00 00       	and    $0x200,%eax
c0100e23:	85 c0                	test   %eax,%eax
c0100e25:	74 0c                	je     c0100e33 <__intr_save+0x23>
        intr_disable();
c0100e27:	e8 a8 08 00 00       	call   c01016d4 <intr_disable>
        return 1;
c0100e2c:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e31:	eb 05                	jmp    c0100e38 <__intr_save+0x28>
    }
    return 0;
c0100e33:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e38:	c9                   	leave  
c0100e39:	c3                   	ret    

c0100e3a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e3a:	55                   	push   %ebp
c0100e3b:	89 e5                	mov    %esp,%ebp
c0100e3d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e44:	74 05                	je     c0100e4b <__intr_restore+0x11>
        intr_enable();
c0100e46:	e8 83 08 00 00       	call   c01016ce <intr_enable>
    }
}
c0100e4b:	c9                   	leave  
c0100e4c:	c3                   	ret    

c0100e4d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e4d:	55                   	push   %ebp
c0100e4e:	89 e5                	mov    %esp,%ebp
c0100e50:	83 ec 10             	sub    $0x10,%esp
c0100e53:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e59:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e5d:	89 c2                	mov    %eax,%edx
c0100e5f:	ec                   	in     (%dx),%al
c0100e60:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e63:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e69:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e6d:	89 c2                	mov    %eax,%edx
c0100e6f:	ec                   	in     (%dx),%al
c0100e70:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e73:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e79:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e7d:	89 c2                	mov    %eax,%edx
c0100e7f:	ec                   	in     (%dx),%al
c0100e80:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e83:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e89:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e8d:	89 c2                	mov    %eax,%edx
c0100e8f:	ec                   	in     (%dx),%al
c0100e90:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e93:	c9                   	leave  
c0100e94:	c3                   	ret    

c0100e95 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e95:	55                   	push   %ebp
c0100e96:	89 e5                	mov    %esp,%ebp
c0100e98:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e9b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea5:	0f b7 00             	movzwl (%eax),%eax
c0100ea8:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eaf:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb7:	0f b7 00             	movzwl (%eax),%eax
c0100eba:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ebe:	74 12                	je     c0100ed2 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ec0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ec7:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100ece:	b4 03 
c0100ed0:	eb 13                	jmp    c0100ee5 <cga_init+0x50>
    } else {
        *cp = was;
c0100ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ed9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100edc:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100ee3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ee5:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100eec:	0f b7 c0             	movzwl %ax,%eax
c0100eef:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ef3:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ef7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100efb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eff:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100f00:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f07:	83 c0 01             	add    $0x1,%eax
c0100f0a:	0f b7 c0             	movzwl %ax,%eax
c0100f0d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f11:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f15:	89 c2                	mov    %eax,%edx
c0100f17:	ec                   	in     (%dx),%al
c0100f18:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f1b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f1f:	0f b6 c0             	movzbl %al,%eax
c0100f22:	c1 e0 08             	shl    $0x8,%eax
c0100f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f28:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f2f:	0f b7 c0             	movzwl %ax,%eax
c0100f32:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f36:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f3a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f3e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f42:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f43:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f4a:	83 c0 01             	add    $0x1,%eax
c0100f4d:	0f b7 c0             	movzwl %ax,%eax
c0100f50:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f54:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f58:	89 c2                	mov    %eax,%edx
c0100f5a:	ec                   	in     (%dx),%al
c0100f5b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f5e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f62:	0f b6 c0             	movzbl %al,%eax
c0100f65:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f6b:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f73:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
}
c0100f79:	c9                   	leave  
c0100f7a:	c3                   	ret    

c0100f7b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f7b:	55                   	push   %ebp
c0100f7c:	89 e5                	mov    %esp,%ebp
c0100f7e:	83 ec 48             	sub    $0x48,%esp
c0100f81:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f87:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f8b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f8f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f93:	ee                   	out    %al,(%dx)
c0100f94:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f9a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f9e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fa2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fa6:	ee                   	out    %al,(%dx)
c0100fa7:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100fad:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fb1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fb5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fb9:	ee                   	out    %al,(%dx)
c0100fba:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fc0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fc4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fc8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fcc:	ee                   	out    %al,(%dx)
c0100fcd:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fd3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fd7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fdb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fdf:	ee                   	out    %al,(%dx)
c0100fe0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fe6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fea:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fee:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100ff2:	ee                   	out    %al,(%dx)
c0100ff3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100ff9:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100ffd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101001:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101005:	ee                   	out    %al,(%dx)
c0101006:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010100c:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101010:	89 c2                	mov    %eax,%edx
c0101012:	ec                   	in     (%dx),%al
c0101013:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101016:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010101a:	3c ff                	cmp    $0xff,%al
c010101c:	0f 95 c0             	setne  %al
c010101f:	0f b6 c0             	movzbl %al,%eax
c0101022:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
c0101027:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010102d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101031:	89 c2                	mov    %eax,%edx
c0101033:	ec                   	in     (%dx),%al
c0101034:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101037:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010103d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101041:	89 c2                	mov    %eax,%edx
c0101043:	ec                   	in     (%dx),%al
c0101044:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101047:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010104c:	85 c0                	test   %eax,%eax
c010104e:	74 0c                	je     c010105c <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101050:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101057:	e8 d6 06 00 00       	call   c0101732 <pic_enable>
    }
}
c010105c:	c9                   	leave  
c010105d:	c3                   	ret    

c010105e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010105e:	55                   	push   %ebp
c010105f:	89 e5                	mov    %esp,%ebp
c0101061:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010106b:	eb 09                	jmp    c0101076 <lpt_putc_sub+0x18>
        delay();
c010106d:	e8 db fd ff ff       	call   c0100e4d <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101072:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101076:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010107c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101080:	89 c2                	mov    %eax,%edx
c0101082:	ec                   	in     (%dx),%al
c0101083:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101086:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010108a:	84 c0                	test   %al,%al
c010108c:	78 09                	js     c0101097 <lpt_putc_sub+0x39>
c010108e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101095:	7e d6                	jle    c010106d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101097:	8b 45 08             	mov    0x8(%ebp),%eax
c010109a:	0f b6 c0             	movzbl %al,%eax
c010109d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c01010a3:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010a6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010aa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010ae:	ee                   	out    %al,(%dx)
c01010af:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010b5:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010b9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010bd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010c1:	ee                   	out    %al,(%dx)
c01010c2:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010c8:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010cc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010d0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010d4:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010d5:	c9                   	leave  
c01010d6:	c3                   	ret    

c01010d7 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010d7:	55                   	push   %ebp
c01010d8:	89 e5                	mov    %esp,%ebp
c01010da:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010dd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010e1:	74 0d                	je     c01010f0 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e6:	89 04 24             	mov    %eax,(%esp)
c01010e9:	e8 70 ff ff ff       	call   c010105e <lpt_putc_sub>
c01010ee:	eb 24                	jmp    c0101114 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010f0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f7:	e8 62 ff ff ff       	call   c010105e <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010fc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101103:	e8 56 ff ff ff       	call   c010105e <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101108:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010110f:	e8 4a ff ff ff       	call   c010105e <lpt_putc_sub>
    }
}
c0101114:	c9                   	leave  
c0101115:	c3                   	ret    

c0101116 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101116:	55                   	push   %ebp
c0101117:	89 e5                	mov    %esp,%ebp
c0101119:	53                   	push   %ebx
c010111a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010111d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101120:	b0 00                	mov    $0x0,%al
c0101122:	85 c0                	test   %eax,%eax
c0101124:	75 07                	jne    c010112d <cga_putc+0x17>
        c |= 0x0700;
c0101126:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010112d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101130:	0f b6 c0             	movzbl %al,%eax
c0101133:	83 f8 0a             	cmp    $0xa,%eax
c0101136:	74 4c                	je     c0101184 <cga_putc+0x6e>
c0101138:	83 f8 0d             	cmp    $0xd,%eax
c010113b:	74 57                	je     c0101194 <cga_putc+0x7e>
c010113d:	83 f8 08             	cmp    $0x8,%eax
c0101140:	0f 85 88 00 00 00    	jne    c01011ce <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101146:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010114d:	66 85 c0             	test   %ax,%ax
c0101150:	74 30                	je     c0101182 <cga_putc+0x6c>
            crt_pos --;
c0101152:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101159:	83 e8 01             	sub    $0x1,%eax
c010115c:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101162:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101167:	0f b7 15 44 a4 11 c0 	movzwl 0xc011a444,%edx
c010116e:	0f b7 d2             	movzwl %dx,%edx
c0101171:	01 d2                	add    %edx,%edx
c0101173:	01 c2                	add    %eax,%edx
c0101175:	8b 45 08             	mov    0x8(%ebp),%eax
c0101178:	b0 00                	mov    $0x0,%al
c010117a:	83 c8 20             	or     $0x20,%eax
c010117d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101180:	eb 72                	jmp    c01011f4 <cga_putc+0xde>
c0101182:	eb 70                	jmp    c01011f4 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101184:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010118b:	83 c0 50             	add    $0x50,%eax
c010118e:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101194:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c010119b:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c01011a2:	0f b7 c1             	movzwl %cx,%eax
c01011a5:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011ab:	c1 e8 10             	shr    $0x10,%eax
c01011ae:	89 c2                	mov    %eax,%edx
c01011b0:	66 c1 ea 06          	shr    $0x6,%dx
c01011b4:	89 d0                	mov    %edx,%eax
c01011b6:	c1 e0 02             	shl    $0x2,%eax
c01011b9:	01 d0                	add    %edx,%eax
c01011bb:	c1 e0 04             	shl    $0x4,%eax
c01011be:	29 c1                	sub    %eax,%ecx
c01011c0:	89 ca                	mov    %ecx,%edx
c01011c2:	89 d8                	mov    %ebx,%eax
c01011c4:	29 d0                	sub    %edx,%eax
c01011c6:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c01011cc:	eb 26                	jmp    c01011f4 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011ce:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01011d4:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011db:	8d 50 01             	lea    0x1(%eax),%edx
c01011de:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
c01011e5:	0f b7 c0             	movzwl %ax,%eax
c01011e8:	01 c0                	add    %eax,%eax
c01011ea:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01011f0:	66 89 02             	mov    %ax,(%edx)
        break;
c01011f3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011f4:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011fb:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011ff:	76 5b                	jbe    c010125c <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101201:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101206:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010120c:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101211:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101218:	00 
c0101219:	89 54 24 04          	mov    %edx,0x4(%esp)
c010121d:	89 04 24             	mov    %eax,(%esp)
c0101220:	e8 dc 4c 00 00       	call   c0105f01 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101225:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010122c:	eb 15                	jmp    c0101243 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010122e:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101233:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101236:	01 d2                	add    %edx,%edx
c0101238:	01 d0                	add    %edx,%eax
c010123a:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010123f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101243:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010124a:	7e e2                	jle    c010122e <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010124c:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101253:	83 e8 50             	sub    $0x50,%eax
c0101256:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010125c:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0101263:	0f b7 c0             	movzwl %ax,%eax
c0101266:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010126a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010126e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101272:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101276:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101277:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010127e:	66 c1 e8 08          	shr    $0x8,%ax
c0101282:	0f b6 c0             	movzbl %al,%eax
c0101285:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c010128c:	83 c2 01             	add    $0x1,%edx
c010128f:	0f b7 d2             	movzwl %dx,%edx
c0101292:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101296:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101299:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010129d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012a1:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012a2:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c01012a9:	0f b7 c0             	movzwl %ax,%eax
c01012ac:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012b0:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012b4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012b8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012bc:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012bd:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01012c4:	0f b6 c0             	movzbl %al,%eax
c01012c7:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c01012ce:	83 c2 01             	add    $0x1,%edx
c01012d1:	0f b7 d2             	movzwl %dx,%edx
c01012d4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012d8:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012db:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012df:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012e3:	ee                   	out    %al,(%dx)
}
c01012e4:	83 c4 34             	add    $0x34,%esp
c01012e7:	5b                   	pop    %ebx
c01012e8:	5d                   	pop    %ebp
c01012e9:	c3                   	ret    

c01012ea <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012ea:	55                   	push   %ebp
c01012eb:	89 e5                	mov    %esp,%ebp
c01012ed:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012f7:	eb 09                	jmp    c0101302 <serial_putc_sub+0x18>
        delay();
c01012f9:	e8 4f fb ff ff       	call   c0100e4d <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101302:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101308:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010130c:	89 c2                	mov    %eax,%edx
c010130e:	ec                   	in     (%dx),%al
c010130f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101312:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101316:	0f b6 c0             	movzbl %al,%eax
c0101319:	83 e0 20             	and    $0x20,%eax
c010131c:	85 c0                	test   %eax,%eax
c010131e:	75 09                	jne    c0101329 <serial_putc_sub+0x3f>
c0101320:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101327:	7e d0                	jle    c01012f9 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101329:	8b 45 08             	mov    0x8(%ebp),%eax
c010132c:	0f b6 c0             	movzbl %al,%eax
c010132f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101335:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101338:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010133c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101340:	ee                   	out    %al,(%dx)
}
c0101341:	c9                   	leave  
c0101342:	c3                   	ret    

c0101343 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101343:	55                   	push   %ebp
c0101344:	89 e5                	mov    %esp,%ebp
c0101346:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101349:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010134d:	74 0d                	je     c010135c <serial_putc+0x19>
        serial_putc_sub(c);
c010134f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101352:	89 04 24             	mov    %eax,(%esp)
c0101355:	e8 90 ff ff ff       	call   c01012ea <serial_putc_sub>
c010135a:	eb 24                	jmp    c0101380 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010135c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101363:	e8 82 ff ff ff       	call   c01012ea <serial_putc_sub>
        serial_putc_sub(' ');
c0101368:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010136f:	e8 76 ff ff ff       	call   c01012ea <serial_putc_sub>
        serial_putc_sub('\b');
c0101374:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010137b:	e8 6a ff ff ff       	call   c01012ea <serial_putc_sub>
    }
}
c0101380:	c9                   	leave  
c0101381:	c3                   	ret    

c0101382 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101382:	55                   	push   %ebp
c0101383:	89 e5                	mov    %esp,%ebp
c0101385:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101388:	eb 33                	jmp    c01013bd <cons_intr+0x3b>
        if (c != 0) {
c010138a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010138e:	74 2d                	je     c01013bd <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101390:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101395:	8d 50 01             	lea    0x1(%eax),%edx
c0101398:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c010139e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013a1:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013a7:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c01013ac:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013b1:	75 0a                	jne    c01013bd <cons_intr+0x3b>
                cons.wpos = 0;
c01013b3:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
c01013ba:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01013c0:	ff d0                	call   *%eax
c01013c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013c5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013c9:	75 bf                	jne    c010138a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013cb:	c9                   	leave  
c01013cc:	c3                   	ret    

c01013cd <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013cd:	55                   	push   %ebp
c01013ce:	89 e5                	mov    %esp,%ebp
c01013d0:	83 ec 10             	sub    $0x10,%esp
c01013d3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013dd:	89 c2                	mov    %eax,%edx
c01013df:	ec                   	in     (%dx),%al
c01013e0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013e3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013e7:	0f b6 c0             	movzbl %al,%eax
c01013ea:	83 e0 01             	and    $0x1,%eax
c01013ed:	85 c0                	test   %eax,%eax
c01013ef:	75 07                	jne    c01013f8 <serial_proc_data+0x2b>
        return -1;
c01013f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013f6:	eb 2a                	jmp    c0101422 <serial_proc_data+0x55>
c01013f8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013fe:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101402:	89 c2                	mov    %eax,%edx
c0101404:	ec                   	in     (%dx),%al
c0101405:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101408:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010140c:	0f b6 c0             	movzbl %al,%eax
c010140f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101412:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101416:	75 07                	jne    c010141f <serial_proc_data+0x52>
        c = '\b';
c0101418:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010141f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101422:	c9                   	leave  
c0101423:	c3                   	ret    

c0101424 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101424:	55                   	push   %ebp
c0101425:	89 e5                	mov    %esp,%ebp
c0101427:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010142a:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010142f:	85 c0                	test   %eax,%eax
c0101431:	74 0c                	je     c010143f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101433:	c7 04 24 cd 13 10 c0 	movl   $0xc01013cd,(%esp)
c010143a:	e8 43 ff ff ff       	call   c0101382 <cons_intr>
    }
}
c010143f:	c9                   	leave  
c0101440:	c3                   	ret    

c0101441 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101441:	55                   	push   %ebp
c0101442:	89 e5                	mov    %esp,%ebp
c0101444:	83 ec 38             	sub    $0x38,%esp
c0101447:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101451:	89 c2                	mov    %eax,%edx
c0101453:	ec                   	in     (%dx),%al
c0101454:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101457:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010145b:	0f b6 c0             	movzbl %al,%eax
c010145e:	83 e0 01             	and    $0x1,%eax
c0101461:	85 c0                	test   %eax,%eax
c0101463:	75 0a                	jne    c010146f <kbd_proc_data+0x2e>
        return -1;
c0101465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010146a:	e9 59 01 00 00       	jmp    c01015c8 <kbd_proc_data+0x187>
c010146f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101475:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101479:	89 c2                	mov    %eax,%edx
c010147b:	ec                   	in     (%dx),%al
c010147c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010147f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101483:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101486:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010148a:	75 17                	jne    c01014a3 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010148c:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101491:	83 c8 40             	or     $0x40,%eax
c0101494:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c0101499:	b8 00 00 00 00       	mov    $0x0,%eax
c010149e:	e9 25 01 00 00       	jmp    c01015c8 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c01014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a7:	84 c0                	test   %al,%al
c01014a9:	79 47                	jns    c01014f2 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014ab:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014b0:	83 e0 40             	and    $0x40,%eax
c01014b3:	85 c0                	test   %eax,%eax
c01014b5:	75 09                	jne    c01014c0 <kbd_proc_data+0x7f>
c01014b7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014bb:	83 e0 7f             	and    $0x7f,%eax
c01014be:	eb 04                	jmp    c01014c4 <kbd_proc_data+0x83>
c01014c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014c7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014cb:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014d2:	83 c8 40             	or     $0x40,%eax
c01014d5:	0f b6 c0             	movzbl %al,%eax
c01014d8:	f7 d0                	not    %eax
c01014da:	89 c2                	mov    %eax,%edx
c01014dc:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014e1:	21 d0                	and    %edx,%eax
c01014e3:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014e8:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ed:	e9 d6 00 00 00       	jmp    c01015c8 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014f2:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014f7:	83 e0 40             	and    $0x40,%eax
c01014fa:	85 c0                	test   %eax,%eax
c01014fc:	74 11                	je     c010150f <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014fe:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101502:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101507:	83 e0 bf             	and    $0xffffffbf,%eax
c010150a:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c010150f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101513:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c010151a:	0f b6 d0             	movzbl %al,%edx
c010151d:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101522:	09 d0                	or     %edx,%eax
c0101524:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c0101529:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152d:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c0101534:	0f b6 d0             	movzbl %al,%edx
c0101537:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010153c:	31 d0                	xor    %edx,%eax
c010153e:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101543:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101548:	83 e0 03             	and    $0x3,%eax
c010154b:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c0101552:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101556:	01 d0                	add    %edx,%eax
c0101558:	0f b6 00             	movzbl (%eax),%eax
c010155b:	0f b6 c0             	movzbl %al,%eax
c010155e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101561:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101566:	83 e0 08             	and    $0x8,%eax
c0101569:	85 c0                	test   %eax,%eax
c010156b:	74 22                	je     c010158f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010156d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101571:	7e 0c                	jle    c010157f <kbd_proc_data+0x13e>
c0101573:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101577:	7f 06                	jg     c010157f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101579:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010157d:	eb 10                	jmp    c010158f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010157f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101583:	7e 0a                	jle    c010158f <kbd_proc_data+0x14e>
c0101585:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101589:	7f 04                	jg     c010158f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010158b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010158f:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101594:	f7 d0                	not    %eax
c0101596:	83 e0 06             	and    $0x6,%eax
c0101599:	85 c0                	test   %eax,%eax
c010159b:	75 28                	jne    c01015c5 <kbd_proc_data+0x184>
c010159d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015a4:	75 1f                	jne    c01015c5 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c01015a6:	c7 04 24 8f 63 10 c0 	movl   $0xc010638f,(%esp)
c01015ad:	e8 96 ed ff ff       	call   c0100348 <cprintf>
c01015b2:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015b8:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015bc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015c0:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015c4:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015c8:	c9                   	leave  
c01015c9:	c3                   	ret    

c01015ca <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015ca:	55                   	push   %ebp
c01015cb:	89 e5                	mov    %esp,%ebp
c01015cd:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015d0:	c7 04 24 41 14 10 c0 	movl   $0xc0101441,(%esp)
c01015d7:	e8 a6 fd ff ff       	call   c0101382 <cons_intr>
}
c01015dc:	c9                   	leave  
c01015dd:	c3                   	ret    

c01015de <kbd_init>:

static void
kbd_init(void) {
c01015de:	55                   	push   %ebp
c01015df:	89 e5                	mov    %esp,%ebp
c01015e1:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015e4:	e8 e1 ff ff ff       	call   c01015ca <kbd_intr>
    pic_enable(IRQ_KBD);
c01015e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015f0:	e8 3d 01 00 00       	call   c0101732 <pic_enable>
}
c01015f5:	c9                   	leave  
c01015f6:	c3                   	ret    

c01015f7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015f7:	55                   	push   %ebp
c01015f8:	89 e5                	mov    %esp,%ebp
c01015fa:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015fd:	e8 93 f8 ff ff       	call   c0100e95 <cga_init>
    serial_init();
c0101602:	e8 74 f9 ff ff       	call   c0100f7b <serial_init>
    kbd_init();
c0101607:	e8 d2 ff ff ff       	call   c01015de <kbd_init>
    if (!serial_exists) {
c010160c:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101611:	85 c0                	test   %eax,%eax
c0101613:	75 0c                	jne    c0101621 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101615:	c7 04 24 9b 63 10 c0 	movl   $0xc010639b,(%esp)
c010161c:	e8 27 ed ff ff       	call   c0100348 <cprintf>
    }
}
c0101621:	c9                   	leave  
c0101622:	c3                   	ret    

c0101623 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101623:	55                   	push   %ebp
c0101624:	89 e5                	mov    %esp,%ebp
c0101626:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101629:	e8 e2 f7 ff ff       	call   c0100e10 <__intr_save>
c010162e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101631:	8b 45 08             	mov    0x8(%ebp),%eax
c0101634:	89 04 24             	mov    %eax,(%esp)
c0101637:	e8 9b fa ff ff       	call   c01010d7 <lpt_putc>
        cga_putc(c);
c010163c:	8b 45 08             	mov    0x8(%ebp),%eax
c010163f:	89 04 24             	mov    %eax,(%esp)
c0101642:	e8 cf fa ff ff       	call   c0101116 <cga_putc>
        serial_putc(c);
c0101647:	8b 45 08             	mov    0x8(%ebp),%eax
c010164a:	89 04 24             	mov    %eax,(%esp)
c010164d:	e8 f1 fc ff ff       	call   c0101343 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101652:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101655:	89 04 24             	mov    %eax,(%esp)
c0101658:	e8 dd f7 ff ff       	call   c0100e3a <__intr_restore>
}
c010165d:	c9                   	leave  
c010165e:	c3                   	ret    

c010165f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010165f:	55                   	push   %ebp
c0101660:	89 e5                	mov    %esp,%ebp
c0101662:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101665:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010166c:	e8 9f f7 ff ff       	call   c0100e10 <__intr_save>
c0101671:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101674:	e8 ab fd ff ff       	call   c0101424 <serial_intr>
        kbd_intr();
c0101679:	e8 4c ff ff ff       	call   c01015ca <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010167e:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c0101684:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101689:	39 c2                	cmp    %eax,%edx
c010168b:	74 31                	je     c01016be <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010168d:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c0101692:	8d 50 01             	lea    0x1(%eax),%edx
c0101695:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c010169b:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c01016a2:	0f b6 c0             	movzbl %al,%eax
c01016a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016a8:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c01016ad:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016b2:	75 0a                	jne    c01016be <cons_getc+0x5f>
                cons.rpos = 0;
c01016b4:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
c01016bb:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016c1:	89 04 24             	mov    %eax,(%esp)
c01016c4:	e8 71 f7 ff ff       	call   c0100e3a <__intr_restore>
    return c;
c01016c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016cc:	c9                   	leave  
c01016cd:	c3                   	ret    

c01016ce <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016ce:	55                   	push   %ebp
c01016cf:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016d1:	fb                   	sti    
    sti();
}
c01016d2:	5d                   	pop    %ebp
c01016d3:	c3                   	ret    

c01016d4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016d4:	55                   	push   %ebp
c01016d5:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016d7:	fa                   	cli    
    cli();
}
c01016d8:	5d                   	pop    %ebp
c01016d9:	c3                   	ret    

c01016da <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016da:	55                   	push   %ebp
c01016db:	89 e5                	mov    %esp,%ebp
c01016dd:	83 ec 14             	sub    $0x14,%esp
c01016e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016e3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016e7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016eb:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c01016f1:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
c01016f6:	85 c0                	test   %eax,%eax
c01016f8:	74 36                	je     c0101730 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016fa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016fe:	0f b6 c0             	movzbl %al,%eax
c0101701:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101707:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010170a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010170e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101712:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101713:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101717:	66 c1 e8 08          	shr    $0x8,%ax
c010171b:	0f b6 c0             	movzbl %al,%eax
c010171e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101724:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101727:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010172b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010172f:	ee                   	out    %al,(%dx)
    }
}
c0101730:	c9                   	leave  
c0101731:	c3                   	ret    

c0101732 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101732:	55                   	push   %ebp
c0101733:	89 e5                	mov    %esp,%ebp
c0101735:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101738:	8b 45 08             	mov    0x8(%ebp),%eax
c010173b:	ba 01 00 00 00       	mov    $0x1,%edx
c0101740:	89 c1                	mov    %eax,%ecx
c0101742:	d3 e2                	shl    %cl,%edx
c0101744:	89 d0                	mov    %edx,%eax
c0101746:	f7 d0                	not    %eax
c0101748:	89 c2                	mov    %eax,%edx
c010174a:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101751:	21 d0                	and    %edx,%eax
c0101753:	0f b7 c0             	movzwl %ax,%eax
c0101756:	89 04 24             	mov    %eax,(%esp)
c0101759:	e8 7c ff ff ff       	call   c01016da <pic_setmask>
}
c010175e:	c9                   	leave  
c010175f:	c3                   	ret    

c0101760 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101760:	55                   	push   %ebp
c0101761:	89 e5                	mov    %esp,%ebp
c0101763:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101766:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
c010176d:	00 00 00 
c0101770:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101776:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010177a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010177e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101782:	ee                   	out    %al,(%dx)
c0101783:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101789:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c010178d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101791:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101795:	ee                   	out    %al,(%dx)
c0101796:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010179c:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01017a0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01017a4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01017a8:	ee                   	out    %al,(%dx)
c01017a9:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01017af:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01017b3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01017b7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017bb:	ee                   	out    %al,(%dx)
c01017bc:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017c2:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017c6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017ca:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017ce:	ee                   	out    %al,(%dx)
c01017cf:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017d5:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017d9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017dd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017e1:	ee                   	out    %al,(%dx)
c01017e2:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017e8:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017ec:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017f0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017f4:	ee                   	out    %al,(%dx)
c01017f5:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017fb:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017ff:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101803:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101807:	ee                   	out    %al,(%dx)
c0101808:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010180e:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0101812:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101816:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010181a:	ee                   	out    %al,(%dx)
c010181b:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101821:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101825:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101829:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010182d:	ee                   	out    %al,(%dx)
c010182e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101834:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101838:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010183c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101840:	ee                   	out    %al,(%dx)
c0101841:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101847:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010184b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010184f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101853:	ee                   	out    %al,(%dx)
c0101854:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010185a:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010185e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101862:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101866:	ee                   	out    %al,(%dx)
c0101867:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010186d:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101871:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101875:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101879:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010187a:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101881:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101885:	74 12                	je     c0101899 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101887:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c010188e:	0f b7 c0             	movzwl %ax,%eax
c0101891:	89 04 24             	mov    %eax,(%esp)
c0101894:	e8 41 fe ff ff       	call   c01016da <pic_setmask>
    }
}
c0101899:	c9                   	leave  
c010189a:	c3                   	ret    

c010189b <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010189b:	55                   	push   %ebp
c010189c:	89 e5                	mov    %esp,%ebp
c010189e:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01018a1:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01018a8:	00 
c01018a9:	c7 04 24 c0 63 10 c0 	movl   $0xc01063c0,(%esp)
c01018b0:	e8 93 ea ff ff       	call   c0100348 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01018b5:	c7 04 24 ca 63 10 c0 	movl   $0xc01063ca,(%esp)
c01018bc:	e8 87 ea ff ff       	call   c0100348 <cprintf>
    panic("EOT: kernel seems ok.");
c01018c1:	c7 44 24 08 d8 63 10 	movl   $0xc01063d8,0x8(%esp)
c01018c8:	c0 
c01018c9:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018d0:	00 
c01018d1:	c7 04 24 ee 63 10 c0 	movl   $0xc01063ee,(%esp)
c01018d8:	e8 03 f4 ff ff       	call   c0100ce0 <__panic>

c01018dd <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018dd:	55                   	push   %ebp
c01018de:	89 e5                	mov    %esp,%ebp
c01018e0:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	// __vectors定义于vector.S中
	extern uintptr_t __vectors[];
  	int i;
  	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++)
c01018e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018ea:	e9 c3 00 00 00       	jmp    c01019b2 <idt_init+0xd5>
      	// 目标idt项为idt[i]
      	// 该idt项为内核代码，所以使用GD_KTEXT段选择子
      	// 中断处理程序的入口地址存放于__vectors[i]
      	// 特权级为DPL_KERNEL
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f2:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01018f9:	89 c2                	mov    %eax,%edx
c01018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fe:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c0101905:	c0 
c0101906:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101909:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c0101910:	c0 08 00 
c0101913:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101916:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c010191d:	c0 
c010191e:	83 e2 e0             	and    $0xffffffe0,%edx
c0101921:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101928:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192b:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101932:	c0 
c0101933:	83 e2 1f             	and    $0x1f,%edx
c0101936:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c010193d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101940:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101947:	c0 
c0101948:	83 e2 f0             	and    $0xfffffff0,%edx
c010194b:	83 ca 0e             	or     $0xe,%edx
c010194e:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101955:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101958:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010195f:	c0 
c0101960:	83 e2 ef             	and    $0xffffffef,%edx
c0101963:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010196a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196d:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101974:	c0 
c0101975:	83 e2 9f             	and    $0xffffff9f,%edx
c0101978:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010197f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101982:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101989:	c0 
c010198a:	83 ca 80             	or     $0xffffff80,%edx
c010198d:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101994:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101997:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c010199e:	c1 e8 10             	shr    $0x10,%eax
c01019a1:	89 c2                	mov    %eax,%edx
c01019a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a6:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c01019ad:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	// __vectors定义于vector.S中
	extern uintptr_t __vectors[];
  	int i;
  	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++)
c01019ae:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b5:	3d ff 00 00 00       	cmp    $0xff,%eax
c01019ba:	0f 86 2f ff ff ff    	jbe    c01018ef <idt_init+0x12>
      	// 该idt项为内核代码，所以使用GD_KTEXT段选择子
      	// 中断处理程序的入口地址存放于__vectors[i]
      	// 特权级为DPL_KERNEL
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  	// 设置从用户态转为内核态的中断的特权级为DPL_USER
  	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01019c0:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c01019c5:	66 a3 48 aa 11 c0    	mov    %ax,0xc011aa48
c01019cb:	66 c7 05 4a aa 11 c0 	movw   $0x8,0xc011aa4a
c01019d2:	08 00 
c01019d4:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c01019db:	83 e0 e0             	and    $0xffffffe0,%eax
c01019de:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c01019e3:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c01019ea:	83 e0 1f             	and    $0x1f,%eax
c01019ed:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c01019f2:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019f9:	83 e0 f0             	and    $0xfffffff0,%eax
c01019fc:	83 c8 0e             	or     $0xe,%eax
c01019ff:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a04:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a0b:	83 e0 ef             	and    $0xffffffef,%eax
c0101a0e:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a13:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a1a:	83 c8 60             	or     $0x60,%eax
c0101a1d:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a22:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a29:	83 c8 80             	or     $0xffffff80,%eax
c0101a2c:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a31:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c0101a36:	c1 e8 10             	shr    $0x10,%eax
c0101a39:	66 a3 4e aa 11 c0    	mov    %ax,0xc011aa4e
c0101a3f:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a46:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a49:	0f 01 18             	lidtl  (%eax)
	// 加载该IDT
  	lidt(&idt_pd);
	
}
c0101a4c:	c9                   	leave  
c0101a4d:	c3                   	ret    

c0101a4e <trapname>:

static const char *
trapname(int trapno) {
c0101a4e:	55                   	push   %ebp
c0101a4f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a54:	83 f8 13             	cmp    $0x13,%eax
c0101a57:	77 0c                	ja     c0101a65 <trapname+0x17>
        return excnames[trapno];
c0101a59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a5c:	8b 04 85 40 67 10 c0 	mov    -0x3fef98c0(,%eax,4),%eax
c0101a63:	eb 18                	jmp    c0101a7d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a65:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a69:	7e 0d                	jle    c0101a78 <trapname+0x2a>
c0101a6b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a6f:	7f 07                	jg     c0101a78 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a71:	b8 ff 63 10 c0       	mov    $0xc01063ff,%eax
c0101a76:	eb 05                	jmp    c0101a7d <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a78:	b8 12 64 10 c0       	mov    $0xc0106412,%eax
}
c0101a7d:	5d                   	pop    %ebp
c0101a7e:	c3                   	ret    

c0101a7f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a7f:	55                   	push   %ebp
c0101a80:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a85:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a89:	66 83 f8 08          	cmp    $0x8,%ax
c0101a8d:	0f 94 c0             	sete   %al
c0101a90:	0f b6 c0             	movzbl %al,%eax
}
c0101a93:	5d                   	pop    %ebp
c0101a94:	c3                   	ret    

c0101a95 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a95:	55                   	push   %ebp
c0101a96:	89 e5                	mov    %esp,%ebp
c0101a98:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa2:	c7 04 24 53 64 10 c0 	movl   $0xc0106453,(%esp)
c0101aa9:	e8 9a e8 ff ff       	call   c0100348 <cprintf>
    print_regs(&tf->tf_regs);
c0101aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab1:	89 04 24             	mov    %eax,(%esp)
c0101ab4:	e8 a1 01 00 00       	call   c0101c5a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abc:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101ac0:	0f b7 c0             	movzwl %ax,%eax
c0101ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac7:	c7 04 24 64 64 10 c0 	movl   $0xc0106464,(%esp)
c0101ace:	e8 75 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ada:	0f b7 c0             	movzwl %ax,%eax
c0101add:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae1:	c7 04 24 77 64 10 c0 	movl   $0xc0106477,(%esp)
c0101ae8:	e8 5b e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101aed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af0:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101af4:	0f b7 c0             	movzwl %ax,%eax
c0101af7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101afb:	c7 04 24 8a 64 10 c0 	movl   $0xc010648a,(%esp)
c0101b02:	e8 41 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b0a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b0e:	0f b7 c0             	movzwl %ax,%eax
c0101b11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b15:	c7 04 24 9d 64 10 c0 	movl   $0xc010649d,(%esp)
c0101b1c:	e8 27 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b21:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b24:	8b 40 30             	mov    0x30(%eax),%eax
c0101b27:	89 04 24             	mov    %eax,(%esp)
c0101b2a:	e8 1f ff ff ff       	call   c0101a4e <trapname>
c0101b2f:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b32:	8b 52 30             	mov    0x30(%edx),%edx
c0101b35:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b39:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b3d:	c7 04 24 b0 64 10 c0 	movl   $0xc01064b0,(%esp)
c0101b44:	e8 ff e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4c:	8b 40 34             	mov    0x34(%eax),%eax
c0101b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b53:	c7 04 24 c2 64 10 c0 	movl   $0xc01064c2,(%esp)
c0101b5a:	e8 e9 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b62:	8b 40 38             	mov    0x38(%eax),%eax
c0101b65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b69:	c7 04 24 d1 64 10 c0 	movl   $0xc01064d1,(%esp)
c0101b70:	e8 d3 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b78:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b7c:	0f b7 c0             	movzwl %ax,%eax
c0101b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b83:	c7 04 24 e0 64 10 c0 	movl   $0xc01064e0,(%esp)
c0101b8a:	e8 b9 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b92:	8b 40 40             	mov    0x40(%eax),%eax
c0101b95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b99:	c7 04 24 f3 64 10 c0 	movl   $0xc01064f3,(%esp)
c0101ba0:	e8 a3 e7 ff ff       	call   c0100348 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ba5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101bac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101bb3:	eb 3e                	jmp    c0101bf3 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb8:	8b 50 40             	mov    0x40(%eax),%edx
c0101bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bbe:	21 d0                	and    %edx,%eax
c0101bc0:	85 c0                	test   %eax,%eax
c0101bc2:	74 28                	je     c0101bec <print_trapframe+0x157>
c0101bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc7:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101bce:	85 c0                	test   %eax,%eax
c0101bd0:	74 1a                	je     c0101bec <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bd5:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be0:	c7 04 24 02 65 10 c0 	movl   $0xc0106502,(%esp)
c0101be7:	e8 5c e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bf0:	d1 65 f0             	shll   -0x10(%ebp)
c0101bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bf6:	83 f8 17             	cmp    $0x17,%eax
c0101bf9:	76 ba                	jbe    c0101bb5 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfe:	8b 40 40             	mov    0x40(%eax),%eax
c0101c01:	25 00 30 00 00       	and    $0x3000,%eax
c0101c06:	c1 e8 0c             	shr    $0xc,%eax
c0101c09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0d:	c7 04 24 06 65 10 c0 	movl   $0xc0106506,(%esp)
c0101c14:	e8 2f e7 ff ff       	call   c0100348 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1c:	89 04 24             	mov    %eax,(%esp)
c0101c1f:	e8 5b fe ff ff       	call   c0101a7f <trap_in_kernel>
c0101c24:	85 c0                	test   %eax,%eax
c0101c26:	75 30                	jne    c0101c58 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2b:	8b 40 44             	mov    0x44(%eax),%eax
c0101c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c32:	c7 04 24 0f 65 10 c0 	movl   $0xc010650f,(%esp)
c0101c39:	e8 0a e7 ff ff       	call   c0100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c41:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c45:	0f b7 c0             	movzwl %ax,%eax
c0101c48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c4c:	c7 04 24 1e 65 10 c0 	movl   $0xc010651e,(%esp)
c0101c53:	e8 f0 e6 ff ff       	call   c0100348 <cprintf>
    }
}
c0101c58:	c9                   	leave  
c0101c59:	c3                   	ret    

c0101c5a <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c5a:	55                   	push   %ebp
c0101c5b:	89 e5                	mov    %esp,%ebp
c0101c5d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c63:	8b 00                	mov    (%eax),%eax
c0101c65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c69:	c7 04 24 31 65 10 c0 	movl   $0xc0106531,(%esp)
c0101c70:	e8 d3 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c78:	8b 40 04             	mov    0x4(%eax),%eax
c0101c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c7f:	c7 04 24 40 65 10 c0 	movl   $0xc0106540,(%esp)
c0101c86:	e8 bd e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8e:	8b 40 08             	mov    0x8(%eax),%eax
c0101c91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c95:	c7 04 24 4f 65 10 c0 	movl   $0xc010654f,(%esp)
c0101c9c:	e8 a7 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101ca1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca4:	8b 40 0c             	mov    0xc(%eax),%eax
c0101ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cab:	c7 04 24 5e 65 10 c0 	movl   $0xc010655e,(%esp)
c0101cb2:	e8 91 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101cb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cba:	8b 40 10             	mov    0x10(%eax),%eax
c0101cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc1:	c7 04 24 6d 65 10 c0 	movl   $0xc010656d,(%esp)
c0101cc8:	e8 7b e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd0:	8b 40 14             	mov    0x14(%eax),%eax
c0101cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd7:	c7 04 24 7c 65 10 c0 	movl   $0xc010657c,(%esp)
c0101cde:	e8 65 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce6:	8b 40 18             	mov    0x18(%eax),%eax
c0101ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ced:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0101cf4:	e8 4f e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cfc:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d03:	c7 04 24 9a 65 10 c0 	movl   $0xc010659a,(%esp)
c0101d0a:	e8 39 e6 ff ff       	call   c0100348 <cprintf>
}
c0101d0f:	c9                   	leave  
c0101d10:	c3                   	ret    

c0101d11 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d11:	55                   	push   %ebp
c0101d12:	89 e5                	mov    %esp,%ebp
c0101d14:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1a:	8b 40 30             	mov    0x30(%eax),%eax
c0101d1d:	83 f8 2f             	cmp    $0x2f,%eax
c0101d20:	77 21                	ja     c0101d43 <trap_dispatch+0x32>
c0101d22:	83 f8 2e             	cmp    $0x2e,%eax
c0101d25:	0f 83 04 01 00 00    	jae    c0101e2f <trap_dispatch+0x11e>
c0101d2b:	83 f8 21             	cmp    $0x21,%eax
c0101d2e:	0f 84 81 00 00 00    	je     c0101db5 <trap_dispatch+0xa4>
c0101d34:	83 f8 24             	cmp    $0x24,%eax
c0101d37:	74 56                	je     c0101d8f <trap_dispatch+0x7e>
c0101d39:	83 f8 20             	cmp    $0x20,%eax
c0101d3c:	74 16                	je     c0101d54 <trap_dispatch+0x43>
c0101d3e:	e9 b4 00 00 00       	jmp    c0101df7 <trap_dispatch+0xe6>
c0101d43:	83 e8 78             	sub    $0x78,%eax
c0101d46:	83 f8 01             	cmp    $0x1,%eax
c0101d49:	0f 87 a8 00 00 00    	ja     c0101df7 <trap_dispatch+0xe6>
c0101d4f:	e9 87 00 00 00       	jmp    c0101ddb <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
c0101d54:	a1 0c af 11 c0       	mov    0xc011af0c,%eax
c0101d59:	83 c0 01             	add    $0x1,%eax
c0101d5c:	a3 0c af 11 c0       	mov    %eax,0xc011af0c
        if(ticks % TICK_NUM == 0)
c0101d61:	8b 0d 0c af 11 c0    	mov    0xc011af0c,%ecx
c0101d67:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d6c:	89 c8                	mov    %ecx,%eax
c0101d6e:	f7 e2                	mul    %edx
c0101d70:	89 d0                	mov    %edx,%eax
c0101d72:	c1 e8 05             	shr    $0x5,%eax
c0101d75:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d78:	29 c1                	sub    %eax,%ecx
c0101d7a:	89 c8                	mov    %ecx,%eax
c0101d7c:	85 c0                	test   %eax,%eax
c0101d7e:	75 0a                	jne    c0101d8a <trap_dispatch+0x79>
            print_ticks();
c0101d80:	e8 16 fb ff ff       	call   c010189b <print_ticks>
        break;
c0101d85:	e9 a6 00 00 00       	jmp    c0101e30 <trap_dispatch+0x11f>
c0101d8a:	e9 a1 00 00 00       	jmp    c0101e30 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d8f:	e8 cb f8 ff ff       	call   c010165f <cons_getc>
c0101d94:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d97:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d9b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d9f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101da3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101da7:	c7 04 24 a9 65 10 c0 	movl   $0xc01065a9,(%esp)
c0101dae:	e8 95 e5 ff ff       	call   c0100348 <cprintf>
        break;
c0101db3:	eb 7b                	jmp    c0101e30 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101db5:	e8 a5 f8 ff ff       	call   c010165f <cons_getc>
c0101dba:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101dbd:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101dc1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101dc5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dcd:	c7 04 24 bb 65 10 c0 	movl   $0xc01065bb,(%esp)
c0101dd4:	e8 6f e5 ff ff       	call   c0100348 <cprintf>
        break;
c0101dd9:	eb 55                	jmp    c0101e30 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101ddb:	c7 44 24 08 ca 65 10 	movl   $0xc01065ca,0x8(%esp)
c0101de2:	c0 
c0101de3:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0101dea:	00 
c0101deb:	c7 04 24 ee 63 10 c0 	movl   $0xc01063ee,(%esp)
c0101df2:	e8 e9 ee ff ff       	call   c0100ce0 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101df7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dfa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dfe:	0f b7 c0             	movzwl %ax,%eax
c0101e01:	83 e0 03             	and    $0x3,%eax
c0101e04:	85 c0                	test   %eax,%eax
c0101e06:	75 28                	jne    c0101e30 <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101e08:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e0b:	89 04 24             	mov    %eax,(%esp)
c0101e0e:	e8 82 fc ff ff       	call   c0101a95 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e13:	c7 44 24 08 da 65 10 	movl   $0xc01065da,0x8(%esp)
c0101e1a:	c0 
c0101e1b:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101e22:	00 
c0101e23:	c7 04 24 ee 63 10 c0 	movl   $0xc01063ee,(%esp)
c0101e2a:	e8 b1 ee ff ff       	call   c0100ce0 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e2f:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e30:	c9                   	leave  
c0101e31:	c3                   	ret    

c0101e32 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e32:	55                   	push   %ebp
c0101e33:	89 e5                	mov    %esp,%ebp
c0101e35:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e3b:	89 04 24             	mov    %eax,(%esp)
c0101e3e:	e8 ce fe ff ff       	call   c0101d11 <trap_dispatch>
}
c0101e43:	c9                   	leave  
c0101e44:	c3                   	ret    

c0101e45 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e45:	1e                   	push   %ds
    pushl %es
c0101e46:	06                   	push   %es
    pushl %fs
c0101e47:	0f a0                	push   %fs
    pushl %gs
c0101e49:	0f a8                	push   %gs
    pushal
c0101e4b:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e4c:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e51:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e53:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e55:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e56:	e8 d7 ff ff ff       	call   c0101e32 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e5b:	5c                   	pop    %esp

c0101e5c <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e5c:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e5d:	0f a9                	pop    %gs
    popl %fs
c0101e5f:	0f a1                	pop    %fs
    popl %es
c0101e61:	07                   	pop    %es
    popl %ds
c0101e62:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e63:	83 c4 08             	add    $0x8,%esp
    iret
c0101e66:	cf                   	iret   

c0101e67 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e67:	6a 00                	push   $0x0
  pushl $0
c0101e69:	6a 00                	push   $0x0
  jmp __alltraps
c0101e6b:	e9 d5 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101e70 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e70:	6a 00                	push   $0x0
  pushl $1
c0101e72:	6a 01                	push   $0x1
  jmp __alltraps
c0101e74:	e9 cc ff ff ff       	jmp    c0101e45 <__alltraps>

c0101e79 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e79:	6a 00                	push   $0x0
  pushl $2
c0101e7b:	6a 02                	push   $0x2
  jmp __alltraps
c0101e7d:	e9 c3 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101e82 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e82:	6a 00                	push   $0x0
  pushl $3
c0101e84:	6a 03                	push   $0x3
  jmp __alltraps
c0101e86:	e9 ba ff ff ff       	jmp    c0101e45 <__alltraps>

c0101e8b <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e8b:	6a 00                	push   $0x0
  pushl $4
c0101e8d:	6a 04                	push   $0x4
  jmp __alltraps
c0101e8f:	e9 b1 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101e94 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e94:	6a 00                	push   $0x0
  pushl $5
c0101e96:	6a 05                	push   $0x5
  jmp __alltraps
c0101e98:	e9 a8 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101e9d <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e9d:	6a 00                	push   $0x0
  pushl $6
c0101e9f:	6a 06                	push   $0x6
  jmp __alltraps
c0101ea1:	e9 9f ff ff ff       	jmp    c0101e45 <__alltraps>

c0101ea6 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101ea6:	6a 00                	push   $0x0
  pushl $7
c0101ea8:	6a 07                	push   $0x7
  jmp __alltraps
c0101eaa:	e9 96 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101eaf <vector8>:
.globl vector8
vector8:
  pushl $8
c0101eaf:	6a 08                	push   $0x8
  jmp __alltraps
c0101eb1:	e9 8f ff ff ff       	jmp    c0101e45 <__alltraps>

c0101eb6 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101eb6:	6a 00                	push   $0x0
  pushl $9
c0101eb8:	6a 09                	push   $0x9
  jmp __alltraps
c0101eba:	e9 86 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101ebf <vector10>:
.globl vector10
vector10:
  pushl $10
c0101ebf:	6a 0a                	push   $0xa
  jmp __alltraps
c0101ec1:	e9 7f ff ff ff       	jmp    c0101e45 <__alltraps>

c0101ec6 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101ec6:	6a 0b                	push   $0xb
  jmp __alltraps
c0101ec8:	e9 78 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101ecd <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ecd:	6a 0c                	push   $0xc
  jmp __alltraps
c0101ecf:	e9 71 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101ed4 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101ed4:	6a 0d                	push   $0xd
  jmp __alltraps
c0101ed6:	e9 6a ff ff ff       	jmp    c0101e45 <__alltraps>

c0101edb <vector14>:
.globl vector14
vector14:
  pushl $14
c0101edb:	6a 0e                	push   $0xe
  jmp __alltraps
c0101edd:	e9 63 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101ee2 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101ee2:	6a 00                	push   $0x0
  pushl $15
c0101ee4:	6a 0f                	push   $0xf
  jmp __alltraps
c0101ee6:	e9 5a ff ff ff       	jmp    c0101e45 <__alltraps>

c0101eeb <vector16>:
.globl vector16
vector16:
  pushl $0
c0101eeb:	6a 00                	push   $0x0
  pushl $16
c0101eed:	6a 10                	push   $0x10
  jmp __alltraps
c0101eef:	e9 51 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101ef4 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ef4:	6a 11                	push   $0x11
  jmp __alltraps
c0101ef6:	e9 4a ff ff ff       	jmp    c0101e45 <__alltraps>

c0101efb <vector18>:
.globl vector18
vector18:
  pushl $0
c0101efb:	6a 00                	push   $0x0
  pushl $18
c0101efd:	6a 12                	push   $0x12
  jmp __alltraps
c0101eff:	e9 41 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101f04 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f04:	6a 00                	push   $0x0
  pushl $19
c0101f06:	6a 13                	push   $0x13
  jmp __alltraps
c0101f08:	e9 38 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101f0d <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f0d:	6a 00                	push   $0x0
  pushl $20
c0101f0f:	6a 14                	push   $0x14
  jmp __alltraps
c0101f11:	e9 2f ff ff ff       	jmp    c0101e45 <__alltraps>

c0101f16 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f16:	6a 00                	push   $0x0
  pushl $21
c0101f18:	6a 15                	push   $0x15
  jmp __alltraps
c0101f1a:	e9 26 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101f1f <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f1f:	6a 00                	push   $0x0
  pushl $22
c0101f21:	6a 16                	push   $0x16
  jmp __alltraps
c0101f23:	e9 1d ff ff ff       	jmp    c0101e45 <__alltraps>

c0101f28 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f28:	6a 00                	push   $0x0
  pushl $23
c0101f2a:	6a 17                	push   $0x17
  jmp __alltraps
c0101f2c:	e9 14 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101f31 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f31:	6a 00                	push   $0x0
  pushl $24
c0101f33:	6a 18                	push   $0x18
  jmp __alltraps
c0101f35:	e9 0b ff ff ff       	jmp    c0101e45 <__alltraps>

c0101f3a <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f3a:	6a 00                	push   $0x0
  pushl $25
c0101f3c:	6a 19                	push   $0x19
  jmp __alltraps
c0101f3e:	e9 02 ff ff ff       	jmp    c0101e45 <__alltraps>

c0101f43 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f43:	6a 00                	push   $0x0
  pushl $26
c0101f45:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f47:	e9 f9 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101f4c <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f4c:	6a 00                	push   $0x0
  pushl $27
c0101f4e:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f50:	e9 f0 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101f55 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f55:	6a 00                	push   $0x0
  pushl $28
c0101f57:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f59:	e9 e7 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101f5e <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f5e:	6a 00                	push   $0x0
  pushl $29
c0101f60:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f62:	e9 de fe ff ff       	jmp    c0101e45 <__alltraps>

c0101f67 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f67:	6a 00                	push   $0x0
  pushl $30
c0101f69:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f6b:	e9 d5 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101f70 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f70:	6a 00                	push   $0x0
  pushl $31
c0101f72:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f74:	e9 cc fe ff ff       	jmp    c0101e45 <__alltraps>

c0101f79 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f79:	6a 00                	push   $0x0
  pushl $32
c0101f7b:	6a 20                	push   $0x20
  jmp __alltraps
c0101f7d:	e9 c3 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101f82 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f82:	6a 00                	push   $0x0
  pushl $33
c0101f84:	6a 21                	push   $0x21
  jmp __alltraps
c0101f86:	e9 ba fe ff ff       	jmp    c0101e45 <__alltraps>

c0101f8b <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f8b:	6a 00                	push   $0x0
  pushl $34
c0101f8d:	6a 22                	push   $0x22
  jmp __alltraps
c0101f8f:	e9 b1 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101f94 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f94:	6a 00                	push   $0x0
  pushl $35
c0101f96:	6a 23                	push   $0x23
  jmp __alltraps
c0101f98:	e9 a8 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101f9d <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f9d:	6a 00                	push   $0x0
  pushl $36
c0101f9f:	6a 24                	push   $0x24
  jmp __alltraps
c0101fa1:	e9 9f fe ff ff       	jmp    c0101e45 <__alltraps>

c0101fa6 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101fa6:	6a 00                	push   $0x0
  pushl $37
c0101fa8:	6a 25                	push   $0x25
  jmp __alltraps
c0101faa:	e9 96 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101faf <vector38>:
.globl vector38
vector38:
  pushl $0
c0101faf:	6a 00                	push   $0x0
  pushl $38
c0101fb1:	6a 26                	push   $0x26
  jmp __alltraps
c0101fb3:	e9 8d fe ff ff       	jmp    c0101e45 <__alltraps>

c0101fb8 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101fb8:	6a 00                	push   $0x0
  pushl $39
c0101fba:	6a 27                	push   $0x27
  jmp __alltraps
c0101fbc:	e9 84 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101fc1 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101fc1:	6a 00                	push   $0x0
  pushl $40
c0101fc3:	6a 28                	push   $0x28
  jmp __alltraps
c0101fc5:	e9 7b fe ff ff       	jmp    c0101e45 <__alltraps>

c0101fca <vector41>:
.globl vector41
vector41:
  pushl $0
c0101fca:	6a 00                	push   $0x0
  pushl $41
c0101fcc:	6a 29                	push   $0x29
  jmp __alltraps
c0101fce:	e9 72 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101fd3 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fd3:	6a 00                	push   $0x0
  pushl $42
c0101fd5:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101fd7:	e9 69 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101fdc <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fdc:	6a 00                	push   $0x0
  pushl $43
c0101fde:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fe0:	e9 60 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101fe5 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101fe5:	6a 00                	push   $0x0
  pushl $44
c0101fe7:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101fe9:	e9 57 fe ff ff       	jmp    c0101e45 <__alltraps>

c0101fee <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fee:	6a 00                	push   $0x0
  pushl $45
c0101ff0:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101ff2:	e9 4e fe ff ff       	jmp    c0101e45 <__alltraps>

c0101ff7 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101ff7:	6a 00                	push   $0x0
  pushl $46
c0101ff9:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101ffb:	e9 45 fe ff ff       	jmp    c0101e45 <__alltraps>

c0102000 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102000:	6a 00                	push   $0x0
  pushl $47
c0102002:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102004:	e9 3c fe ff ff       	jmp    c0101e45 <__alltraps>

c0102009 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102009:	6a 00                	push   $0x0
  pushl $48
c010200b:	6a 30                	push   $0x30
  jmp __alltraps
c010200d:	e9 33 fe ff ff       	jmp    c0101e45 <__alltraps>

c0102012 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102012:	6a 00                	push   $0x0
  pushl $49
c0102014:	6a 31                	push   $0x31
  jmp __alltraps
c0102016:	e9 2a fe ff ff       	jmp    c0101e45 <__alltraps>

c010201b <vector50>:
.globl vector50
vector50:
  pushl $0
c010201b:	6a 00                	push   $0x0
  pushl $50
c010201d:	6a 32                	push   $0x32
  jmp __alltraps
c010201f:	e9 21 fe ff ff       	jmp    c0101e45 <__alltraps>

c0102024 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102024:	6a 00                	push   $0x0
  pushl $51
c0102026:	6a 33                	push   $0x33
  jmp __alltraps
c0102028:	e9 18 fe ff ff       	jmp    c0101e45 <__alltraps>

c010202d <vector52>:
.globl vector52
vector52:
  pushl $0
c010202d:	6a 00                	push   $0x0
  pushl $52
c010202f:	6a 34                	push   $0x34
  jmp __alltraps
c0102031:	e9 0f fe ff ff       	jmp    c0101e45 <__alltraps>

c0102036 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102036:	6a 00                	push   $0x0
  pushl $53
c0102038:	6a 35                	push   $0x35
  jmp __alltraps
c010203a:	e9 06 fe ff ff       	jmp    c0101e45 <__alltraps>

c010203f <vector54>:
.globl vector54
vector54:
  pushl $0
c010203f:	6a 00                	push   $0x0
  pushl $54
c0102041:	6a 36                	push   $0x36
  jmp __alltraps
c0102043:	e9 fd fd ff ff       	jmp    c0101e45 <__alltraps>

c0102048 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102048:	6a 00                	push   $0x0
  pushl $55
c010204a:	6a 37                	push   $0x37
  jmp __alltraps
c010204c:	e9 f4 fd ff ff       	jmp    c0101e45 <__alltraps>

c0102051 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102051:	6a 00                	push   $0x0
  pushl $56
c0102053:	6a 38                	push   $0x38
  jmp __alltraps
c0102055:	e9 eb fd ff ff       	jmp    c0101e45 <__alltraps>

c010205a <vector57>:
.globl vector57
vector57:
  pushl $0
c010205a:	6a 00                	push   $0x0
  pushl $57
c010205c:	6a 39                	push   $0x39
  jmp __alltraps
c010205e:	e9 e2 fd ff ff       	jmp    c0101e45 <__alltraps>

c0102063 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102063:	6a 00                	push   $0x0
  pushl $58
c0102065:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102067:	e9 d9 fd ff ff       	jmp    c0101e45 <__alltraps>

c010206c <vector59>:
.globl vector59
vector59:
  pushl $0
c010206c:	6a 00                	push   $0x0
  pushl $59
c010206e:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102070:	e9 d0 fd ff ff       	jmp    c0101e45 <__alltraps>

c0102075 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102075:	6a 00                	push   $0x0
  pushl $60
c0102077:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102079:	e9 c7 fd ff ff       	jmp    c0101e45 <__alltraps>

c010207e <vector61>:
.globl vector61
vector61:
  pushl $0
c010207e:	6a 00                	push   $0x0
  pushl $61
c0102080:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102082:	e9 be fd ff ff       	jmp    c0101e45 <__alltraps>

c0102087 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102087:	6a 00                	push   $0x0
  pushl $62
c0102089:	6a 3e                	push   $0x3e
  jmp __alltraps
c010208b:	e9 b5 fd ff ff       	jmp    c0101e45 <__alltraps>

c0102090 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102090:	6a 00                	push   $0x0
  pushl $63
c0102092:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102094:	e9 ac fd ff ff       	jmp    c0101e45 <__alltraps>

c0102099 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102099:	6a 00                	push   $0x0
  pushl $64
c010209b:	6a 40                	push   $0x40
  jmp __alltraps
c010209d:	e9 a3 fd ff ff       	jmp    c0101e45 <__alltraps>

c01020a2 <vector65>:
.globl vector65
vector65:
  pushl $0
c01020a2:	6a 00                	push   $0x0
  pushl $65
c01020a4:	6a 41                	push   $0x41
  jmp __alltraps
c01020a6:	e9 9a fd ff ff       	jmp    c0101e45 <__alltraps>

c01020ab <vector66>:
.globl vector66
vector66:
  pushl $0
c01020ab:	6a 00                	push   $0x0
  pushl $66
c01020ad:	6a 42                	push   $0x42
  jmp __alltraps
c01020af:	e9 91 fd ff ff       	jmp    c0101e45 <__alltraps>

c01020b4 <vector67>:
.globl vector67
vector67:
  pushl $0
c01020b4:	6a 00                	push   $0x0
  pushl $67
c01020b6:	6a 43                	push   $0x43
  jmp __alltraps
c01020b8:	e9 88 fd ff ff       	jmp    c0101e45 <__alltraps>

c01020bd <vector68>:
.globl vector68
vector68:
  pushl $0
c01020bd:	6a 00                	push   $0x0
  pushl $68
c01020bf:	6a 44                	push   $0x44
  jmp __alltraps
c01020c1:	e9 7f fd ff ff       	jmp    c0101e45 <__alltraps>

c01020c6 <vector69>:
.globl vector69
vector69:
  pushl $0
c01020c6:	6a 00                	push   $0x0
  pushl $69
c01020c8:	6a 45                	push   $0x45
  jmp __alltraps
c01020ca:	e9 76 fd ff ff       	jmp    c0101e45 <__alltraps>

c01020cf <vector70>:
.globl vector70
vector70:
  pushl $0
c01020cf:	6a 00                	push   $0x0
  pushl $70
c01020d1:	6a 46                	push   $0x46
  jmp __alltraps
c01020d3:	e9 6d fd ff ff       	jmp    c0101e45 <__alltraps>

c01020d8 <vector71>:
.globl vector71
vector71:
  pushl $0
c01020d8:	6a 00                	push   $0x0
  pushl $71
c01020da:	6a 47                	push   $0x47
  jmp __alltraps
c01020dc:	e9 64 fd ff ff       	jmp    c0101e45 <__alltraps>

c01020e1 <vector72>:
.globl vector72
vector72:
  pushl $0
c01020e1:	6a 00                	push   $0x0
  pushl $72
c01020e3:	6a 48                	push   $0x48
  jmp __alltraps
c01020e5:	e9 5b fd ff ff       	jmp    c0101e45 <__alltraps>

c01020ea <vector73>:
.globl vector73
vector73:
  pushl $0
c01020ea:	6a 00                	push   $0x0
  pushl $73
c01020ec:	6a 49                	push   $0x49
  jmp __alltraps
c01020ee:	e9 52 fd ff ff       	jmp    c0101e45 <__alltraps>

c01020f3 <vector74>:
.globl vector74
vector74:
  pushl $0
c01020f3:	6a 00                	push   $0x0
  pushl $74
c01020f5:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020f7:	e9 49 fd ff ff       	jmp    c0101e45 <__alltraps>

c01020fc <vector75>:
.globl vector75
vector75:
  pushl $0
c01020fc:	6a 00                	push   $0x0
  pushl $75
c01020fe:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102100:	e9 40 fd ff ff       	jmp    c0101e45 <__alltraps>

c0102105 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102105:	6a 00                	push   $0x0
  pushl $76
c0102107:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102109:	e9 37 fd ff ff       	jmp    c0101e45 <__alltraps>

c010210e <vector77>:
.globl vector77
vector77:
  pushl $0
c010210e:	6a 00                	push   $0x0
  pushl $77
c0102110:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102112:	e9 2e fd ff ff       	jmp    c0101e45 <__alltraps>

c0102117 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102117:	6a 00                	push   $0x0
  pushl $78
c0102119:	6a 4e                	push   $0x4e
  jmp __alltraps
c010211b:	e9 25 fd ff ff       	jmp    c0101e45 <__alltraps>

c0102120 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102120:	6a 00                	push   $0x0
  pushl $79
c0102122:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102124:	e9 1c fd ff ff       	jmp    c0101e45 <__alltraps>

c0102129 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102129:	6a 00                	push   $0x0
  pushl $80
c010212b:	6a 50                	push   $0x50
  jmp __alltraps
c010212d:	e9 13 fd ff ff       	jmp    c0101e45 <__alltraps>

c0102132 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102132:	6a 00                	push   $0x0
  pushl $81
c0102134:	6a 51                	push   $0x51
  jmp __alltraps
c0102136:	e9 0a fd ff ff       	jmp    c0101e45 <__alltraps>

c010213b <vector82>:
.globl vector82
vector82:
  pushl $0
c010213b:	6a 00                	push   $0x0
  pushl $82
c010213d:	6a 52                	push   $0x52
  jmp __alltraps
c010213f:	e9 01 fd ff ff       	jmp    c0101e45 <__alltraps>

c0102144 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102144:	6a 00                	push   $0x0
  pushl $83
c0102146:	6a 53                	push   $0x53
  jmp __alltraps
c0102148:	e9 f8 fc ff ff       	jmp    c0101e45 <__alltraps>

c010214d <vector84>:
.globl vector84
vector84:
  pushl $0
c010214d:	6a 00                	push   $0x0
  pushl $84
c010214f:	6a 54                	push   $0x54
  jmp __alltraps
c0102151:	e9 ef fc ff ff       	jmp    c0101e45 <__alltraps>

c0102156 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102156:	6a 00                	push   $0x0
  pushl $85
c0102158:	6a 55                	push   $0x55
  jmp __alltraps
c010215a:	e9 e6 fc ff ff       	jmp    c0101e45 <__alltraps>

c010215f <vector86>:
.globl vector86
vector86:
  pushl $0
c010215f:	6a 00                	push   $0x0
  pushl $86
c0102161:	6a 56                	push   $0x56
  jmp __alltraps
c0102163:	e9 dd fc ff ff       	jmp    c0101e45 <__alltraps>

c0102168 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102168:	6a 00                	push   $0x0
  pushl $87
c010216a:	6a 57                	push   $0x57
  jmp __alltraps
c010216c:	e9 d4 fc ff ff       	jmp    c0101e45 <__alltraps>

c0102171 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102171:	6a 00                	push   $0x0
  pushl $88
c0102173:	6a 58                	push   $0x58
  jmp __alltraps
c0102175:	e9 cb fc ff ff       	jmp    c0101e45 <__alltraps>

c010217a <vector89>:
.globl vector89
vector89:
  pushl $0
c010217a:	6a 00                	push   $0x0
  pushl $89
c010217c:	6a 59                	push   $0x59
  jmp __alltraps
c010217e:	e9 c2 fc ff ff       	jmp    c0101e45 <__alltraps>

c0102183 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102183:	6a 00                	push   $0x0
  pushl $90
c0102185:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102187:	e9 b9 fc ff ff       	jmp    c0101e45 <__alltraps>

c010218c <vector91>:
.globl vector91
vector91:
  pushl $0
c010218c:	6a 00                	push   $0x0
  pushl $91
c010218e:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102190:	e9 b0 fc ff ff       	jmp    c0101e45 <__alltraps>

c0102195 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102195:	6a 00                	push   $0x0
  pushl $92
c0102197:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102199:	e9 a7 fc ff ff       	jmp    c0101e45 <__alltraps>

c010219e <vector93>:
.globl vector93
vector93:
  pushl $0
c010219e:	6a 00                	push   $0x0
  pushl $93
c01021a0:	6a 5d                	push   $0x5d
  jmp __alltraps
c01021a2:	e9 9e fc ff ff       	jmp    c0101e45 <__alltraps>

c01021a7 <vector94>:
.globl vector94
vector94:
  pushl $0
c01021a7:	6a 00                	push   $0x0
  pushl $94
c01021a9:	6a 5e                	push   $0x5e
  jmp __alltraps
c01021ab:	e9 95 fc ff ff       	jmp    c0101e45 <__alltraps>

c01021b0 <vector95>:
.globl vector95
vector95:
  pushl $0
c01021b0:	6a 00                	push   $0x0
  pushl $95
c01021b2:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021b4:	e9 8c fc ff ff       	jmp    c0101e45 <__alltraps>

c01021b9 <vector96>:
.globl vector96
vector96:
  pushl $0
c01021b9:	6a 00                	push   $0x0
  pushl $96
c01021bb:	6a 60                	push   $0x60
  jmp __alltraps
c01021bd:	e9 83 fc ff ff       	jmp    c0101e45 <__alltraps>

c01021c2 <vector97>:
.globl vector97
vector97:
  pushl $0
c01021c2:	6a 00                	push   $0x0
  pushl $97
c01021c4:	6a 61                	push   $0x61
  jmp __alltraps
c01021c6:	e9 7a fc ff ff       	jmp    c0101e45 <__alltraps>

c01021cb <vector98>:
.globl vector98
vector98:
  pushl $0
c01021cb:	6a 00                	push   $0x0
  pushl $98
c01021cd:	6a 62                	push   $0x62
  jmp __alltraps
c01021cf:	e9 71 fc ff ff       	jmp    c0101e45 <__alltraps>

c01021d4 <vector99>:
.globl vector99
vector99:
  pushl $0
c01021d4:	6a 00                	push   $0x0
  pushl $99
c01021d6:	6a 63                	push   $0x63
  jmp __alltraps
c01021d8:	e9 68 fc ff ff       	jmp    c0101e45 <__alltraps>

c01021dd <vector100>:
.globl vector100
vector100:
  pushl $0
c01021dd:	6a 00                	push   $0x0
  pushl $100
c01021df:	6a 64                	push   $0x64
  jmp __alltraps
c01021e1:	e9 5f fc ff ff       	jmp    c0101e45 <__alltraps>

c01021e6 <vector101>:
.globl vector101
vector101:
  pushl $0
c01021e6:	6a 00                	push   $0x0
  pushl $101
c01021e8:	6a 65                	push   $0x65
  jmp __alltraps
c01021ea:	e9 56 fc ff ff       	jmp    c0101e45 <__alltraps>

c01021ef <vector102>:
.globl vector102
vector102:
  pushl $0
c01021ef:	6a 00                	push   $0x0
  pushl $102
c01021f1:	6a 66                	push   $0x66
  jmp __alltraps
c01021f3:	e9 4d fc ff ff       	jmp    c0101e45 <__alltraps>

c01021f8 <vector103>:
.globl vector103
vector103:
  pushl $0
c01021f8:	6a 00                	push   $0x0
  pushl $103
c01021fa:	6a 67                	push   $0x67
  jmp __alltraps
c01021fc:	e9 44 fc ff ff       	jmp    c0101e45 <__alltraps>

c0102201 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102201:	6a 00                	push   $0x0
  pushl $104
c0102203:	6a 68                	push   $0x68
  jmp __alltraps
c0102205:	e9 3b fc ff ff       	jmp    c0101e45 <__alltraps>

c010220a <vector105>:
.globl vector105
vector105:
  pushl $0
c010220a:	6a 00                	push   $0x0
  pushl $105
c010220c:	6a 69                	push   $0x69
  jmp __alltraps
c010220e:	e9 32 fc ff ff       	jmp    c0101e45 <__alltraps>

c0102213 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102213:	6a 00                	push   $0x0
  pushl $106
c0102215:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102217:	e9 29 fc ff ff       	jmp    c0101e45 <__alltraps>

c010221c <vector107>:
.globl vector107
vector107:
  pushl $0
c010221c:	6a 00                	push   $0x0
  pushl $107
c010221e:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102220:	e9 20 fc ff ff       	jmp    c0101e45 <__alltraps>

c0102225 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102225:	6a 00                	push   $0x0
  pushl $108
c0102227:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102229:	e9 17 fc ff ff       	jmp    c0101e45 <__alltraps>

c010222e <vector109>:
.globl vector109
vector109:
  pushl $0
c010222e:	6a 00                	push   $0x0
  pushl $109
c0102230:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102232:	e9 0e fc ff ff       	jmp    c0101e45 <__alltraps>

c0102237 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102237:	6a 00                	push   $0x0
  pushl $110
c0102239:	6a 6e                	push   $0x6e
  jmp __alltraps
c010223b:	e9 05 fc ff ff       	jmp    c0101e45 <__alltraps>

c0102240 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102240:	6a 00                	push   $0x0
  pushl $111
c0102242:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102244:	e9 fc fb ff ff       	jmp    c0101e45 <__alltraps>

c0102249 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102249:	6a 00                	push   $0x0
  pushl $112
c010224b:	6a 70                	push   $0x70
  jmp __alltraps
c010224d:	e9 f3 fb ff ff       	jmp    c0101e45 <__alltraps>

c0102252 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102252:	6a 00                	push   $0x0
  pushl $113
c0102254:	6a 71                	push   $0x71
  jmp __alltraps
c0102256:	e9 ea fb ff ff       	jmp    c0101e45 <__alltraps>

c010225b <vector114>:
.globl vector114
vector114:
  pushl $0
c010225b:	6a 00                	push   $0x0
  pushl $114
c010225d:	6a 72                	push   $0x72
  jmp __alltraps
c010225f:	e9 e1 fb ff ff       	jmp    c0101e45 <__alltraps>

c0102264 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102264:	6a 00                	push   $0x0
  pushl $115
c0102266:	6a 73                	push   $0x73
  jmp __alltraps
c0102268:	e9 d8 fb ff ff       	jmp    c0101e45 <__alltraps>

c010226d <vector116>:
.globl vector116
vector116:
  pushl $0
c010226d:	6a 00                	push   $0x0
  pushl $116
c010226f:	6a 74                	push   $0x74
  jmp __alltraps
c0102271:	e9 cf fb ff ff       	jmp    c0101e45 <__alltraps>

c0102276 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102276:	6a 00                	push   $0x0
  pushl $117
c0102278:	6a 75                	push   $0x75
  jmp __alltraps
c010227a:	e9 c6 fb ff ff       	jmp    c0101e45 <__alltraps>

c010227f <vector118>:
.globl vector118
vector118:
  pushl $0
c010227f:	6a 00                	push   $0x0
  pushl $118
c0102281:	6a 76                	push   $0x76
  jmp __alltraps
c0102283:	e9 bd fb ff ff       	jmp    c0101e45 <__alltraps>

c0102288 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102288:	6a 00                	push   $0x0
  pushl $119
c010228a:	6a 77                	push   $0x77
  jmp __alltraps
c010228c:	e9 b4 fb ff ff       	jmp    c0101e45 <__alltraps>

c0102291 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102291:	6a 00                	push   $0x0
  pushl $120
c0102293:	6a 78                	push   $0x78
  jmp __alltraps
c0102295:	e9 ab fb ff ff       	jmp    c0101e45 <__alltraps>

c010229a <vector121>:
.globl vector121
vector121:
  pushl $0
c010229a:	6a 00                	push   $0x0
  pushl $121
c010229c:	6a 79                	push   $0x79
  jmp __alltraps
c010229e:	e9 a2 fb ff ff       	jmp    c0101e45 <__alltraps>

c01022a3 <vector122>:
.globl vector122
vector122:
  pushl $0
c01022a3:	6a 00                	push   $0x0
  pushl $122
c01022a5:	6a 7a                	push   $0x7a
  jmp __alltraps
c01022a7:	e9 99 fb ff ff       	jmp    c0101e45 <__alltraps>

c01022ac <vector123>:
.globl vector123
vector123:
  pushl $0
c01022ac:	6a 00                	push   $0x0
  pushl $123
c01022ae:	6a 7b                	push   $0x7b
  jmp __alltraps
c01022b0:	e9 90 fb ff ff       	jmp    c0101e45 <__alltraps>

c01022b5 <vector124>:
.globl vector124
vector124:
  pushl $0
c01022b5:	6a 00                	push   $0x0
  pushl $124
c01022b7:	6a 7c                	push   $0x7c
  jmp __alltraps
c01022b9:	e9 87 fb ff ff       	jmp    c0101e45 <__alltraps>

c01022be <vector125>:
.globl vector125
vector125:
  pushl $0
c01022be:	6a 00                	push   $0x0
  pushl $125
c01022c0:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022c2:	e9 7e fb ff ff       	jmp    c0101e45 <__alltraps>

c01022c7 <vector126>:
.globl vector126
vector126:
  pushl $0
c01022c7:	6a 00                	push   $0x0
  pushl $126
c01022c9:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022cb:	e9 75 fb ff ff       	jmp    c0101e45 <__alltraps>

c01022d0 <vector127>:
.globl vector127
vector127:
  pushl $0
c01022d0:	6a 00                	push   $0x0
  pushl $127
c01022d2:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022d4:	e9 6c fb ff ff       	jmp    c0101e45 <__alltraps>

c01022d9 <vector128>:
.globl vector128
vector128:
  pushl $0
c01022d9:	6a 00                	push   $0x0
  pushl $128
c01022db:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022e0:	e9 60 fb ff ff       	jmp    c0101e45 <__alltraps>

c01022e5 <vector129>:
.globl vector129
vector129:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $129
c01022e7:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022ec:	e9 54 fb ff ff       	jmp    c0101e45 <__alltraps>

c01022f1 <vector130>:
.globl vector130
vector130:
  pushl $0
c01022f1:	6a 00                	push   $0x0
  pushl $130
c01022f3:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022f8:	e9 48 fb ff ff       	jmp    c0101e45 <__alltraps>

c01022fd <vector131>:
.globl vector131
vector131:
  pushl $0
c01022fd:	6a 00                	push   $0x0
  pushl $131
c01022ff:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102304:	e9 3c fb ff ff       	jmp    c0101e45 <__alltraps>

c0102309 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $132
c010230b:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102310:	e9 30 fb ff ff       	jmp    c0101e45 <__alltraps>

c0102315 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102315:	6a 00                	push   $0x0
  pushl $133
c0102317:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010231c:	e9 24 fb ff ff       	jmp    c0101e45 <__alltraps>

c0102321 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102321:	6a 00                	push   $0x0
  pushl $134
c0102323:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102328:	e9 18 fb ff ff       	jmp    c0101e45 <__alltraps>

c010232d <vector135>:
.globl vector135
vector135:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $135
c010232f:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102334:	e9 0c fb ff ff       	jmp    c0101e45 <__alltraps>

c0102339 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102339:	6a 00                	push   $0x0
  pushl $136
c010233b:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102340:	e9 00 fb ff ff       	jmp    c0101e45 <__alltraps>

c0102345 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102345:	6a 00                	push   $0x0
  pushl $137
c0102347:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010234c:	e9 f4 fa ff ff       	jmp    c0101e45 <__alltraps>

c0102351 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102351:	6a 00                	push   $0x0
  pushl $138
c0102353:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102358:	e9 e8 fa ff ff       	jmp    c0101e45 <__alltraps>

c010235d <vector139>:
.globl vector139
vector139:
  pushl $0
c010235d:	6a 00                	push   $0x0
  pushl $139
c010235f:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102364:	e9 dc fa ff ff       	jmp    c0101e45 <__alltraps>

c0102369 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102369:	6a 00                	push   $0x0
  pushl $140
c010236b:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102370:	e9 d0 fa ff ff       	jmp    c0101e45 <__alltraps>

c0102375 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102375:	6a 00                	push   $0x0
  pushl $141
c0102377:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010237c:	e9 c4 fa ff ff       	jmp    c0101e45 <__alltraps>

c0102381 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102381:	6a 00                	push   $0x0
  pushl $142
c0102383:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102388:	e9 b8 fa ff ff       	jmp    c0101e45 <__alltraps>

c010238d <vector143>:
.globl vector143
vector143:
  pushl $0
c010238d:	6a 00                	push   $0x0
  pushl $143
c010238f:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102394:	e9 ac fa ff ff       	jmp    c0101e45 <__alltraps>

c0102399 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102399:	6a 00                	push   $0x0
  pushl $144
c010239b:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01023a0:	e9 a0 fa ff ff       	jmp    c0101e45 <__alltraps>

c01023a5 <vector145>:
.globl vector145
vector145:
  pushl $0
c01023a5:	6a 00                	push   $0x0
  pushl $145
c01023a7:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01023ac:	e9 94 fa ff ff       	jmp    c0101e45 <__alltraps>

c01023b1 <vector146>:
.globl vector146
vector146:
  pushl $0
c01023b1:	6a 00                	push   $0x0
  pushl $146
c01023b3:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01023b8:	e9 88 fa ff ff       	jmp    c0101e45 <__alltraps>

c01023bd <vector147>:
.globl vector147
vector147:
  pushl $0
c01023bd:	6a 00                	push   $0x0
  pushl $147
c01023bf:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023c4:	e9 7c fa ff ff       	jmp    c0101e45 <__alltraps>

c01023c9 <vector148>:
.globl vector148
vector148:
  pushl $0
c01023c9:	6a 00                	push   $0x0
  pushl $148
c01023cb:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023d0:	e9 70 fa ff ff       	jmp    c0101e45 <__alltraps>

c01023d5 <vector149>:
.globl vector149
vector149:
  pushl $0
c01023d5:	6a 00                	push   $0x0
  pushl $149
c01023d7:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023dc:	e9 64 fa ff ff       	jmp    c0101e45 <__alltraps>

c01023e1 <vector150>:
.globl vector150
vector150:
  pushl $0
c01023e1:	6a 00                	push   $0x0
  pushl $150
c01023e3:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023e8:	e9 58 fa ff ff       	jmp    c0101e45 <__alltraps>

c01023ed <vector151>:
.globl vector151
vector151:
  pushl $0
c01023ed:	6a 00                	push   $0x0
  pushl $151
c01023ef:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023f4:	e9 4c fa ff ff       	jmp    c0101e45 <__alltraps>

c01023f9 <vector152>:
.globl vector152
vector152:
  pushl $0
c01023f9:	6a 00                	push   $0x0
  pushl $152
c01023fb:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102400:	e9 40 fa ff ff       	jmp    c0101e45 <__alltraps>

c0102405 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102405:	6a 00                	push   $0x0
  pushl $153
c0102407:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010240c:	e9 34 fa ff ff       	jmp    c0101e45 <__alltraps>

c0102411 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102411:	6a 00                	push   $0x0
  pushl $154
c0102413:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102418:	e9 28 fa ff ff       	jmp    c0101e45 <__alltraps>

c010241d <vector155>:
.globl vector155
vector155:
  pushl $0
c010241d:	6a 00                	push   $0x0
  pushl $155
c010241f:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102424:	e9 1c fa ff ff       	jmp    c0101e45 <__alltraps>

c0102429 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102429:	6a 00                	push   $0x0
  pushl $156
c010242b:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102430:	e9 10 fa ff ff       	jmp    c0101e45 <__alltraps>

c0102435 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102435:	6a 00                	push   $0x0
  pushl $157
c0102437:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010243c:	e9 04 fa ff ff       	jmp    c0101e45 <__alltraps>

c0102441 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102441:	6a 00                	push   $0x0
  pushl $158
c0102443:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102448:	e9 f8 f9 ff ff       	jmp    c0101e45 <__alltraps>

c010244d <vector159>:
.globl vector159
vector159:
  pushl $0
c010244d:	6a 00                	push   $0x0
  pushl $159
c010244f:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102454:	e9 ec f9 ff ff       	jmp    c0101e45 <__alltraps>

c0102459 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102459:	6a 00                	push   $0x0
  pushl $160
c010245b:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102460:	e9 e0 f9 ff ff       	jmp    c0101e45 <__alltraps>

c0102465 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102465:	6a 00                	push   $0x0
  pushl $161
c0102467:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010246c:	e9 d4 f9 ff ff       	jmp    c0101e45 <__alltraps>

c0102471 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102471:	6a 00                	push   $0x0
  pushl $162
c0102473:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102478:	e9 c8 f9 ff ff       	jmp    c0101e45 <__alltraps>

c010247d <vector163>:
.globl vector163
vector163:
  pushl $0
c010247d:	6a 00                	push   $0x0
  pushl $163
c010247f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102484:	e9 bc f9 ff ff       	jmp    c0101e45 <__alltraps>

c0102489 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102489:	6a 00                	push   $0x0
  pushl $164
c010248b:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102490:	e9 b0 f9 ff ff       	jmp    c0101e45 <__alltraps>

c0102495 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102495:	6a 00                	push   $0x0
  pushl $165
c0102497:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010249c:	e9 a4 f9 ff ff       	jmp    c0101e45 <__alltraps>

c01024a1 <vector166>:
.globl vector166
vector166:
  pushl $0
c01024a1:	6a 00                	push   $0x0
  pushl $166
c01024a3:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01024a8:	e9 98 f9 ff ff       	jmp    c0101e45 <__alltraps>

c01024ad <vector167>:
.globl vector167
vector167:
  pushl $0
c01024ad:	6a 00                	push   $0x0
  pushl $167
c01024af:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024b4:	e9 8c f9 ff ff       	jmp    c0101e45 <__alltraps>

c01024b9 <vector168>:
.globl vector168
vector168:
  pushl $0
c01024b9:	6a 00                	push   $0x0
  pushl $168
c01024bb:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024c0:	e9 80 f9 ff ff       	jmp    c0101e45 <__alltraps>

c01024c5 <vector169>:
.globl vector169
vector169:
  pushl $0
c01024c5:	6a 00                	push   $0x0
  pushl $169
c01024c7:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024cc:	e9 74 f9 ff ff       	jmp    c0101e45 <__alltraps>

c01024d1 <vector170>:
.globl vector170
vector170:
  pushl $0
c01024d1:	6a 00                	push   $0x0
  pushl $170
c01024d3:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024d8:	e9 68 f9 ff ff       	jmp    c0101e45 <__alltraps>

c01024dd <vector171>:
.globl vector171
vector171:
  pushl $0
c01024dd:	6a 00                	push   $0x0
  pushl $171
c01024df:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024e4:	e9 5c f9 ff ff       	jmp    c0101e45 <__alltraps>

c01024e9 <vector172>:
.globl vector172
vector172:
  pushl $0
c01024e9:	6a 00                	push   $0x0
  pushl $172
c01024eb:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024f0:	e9 50 f9 ff ff       	jmp    c0101e45 <__alltraps>

c01024f5 <vector173>:
.globl vector173
vector173:
  pushl $0
c01024f5:	6a 00                	push   $0x0
  pushl $173
c01024f7:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024fc:	e9 44 f9 ff ff       	jmp    c0101e45 <__alltraps>

c0102501 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102501:	6a 00                	push   $0x0
  pushl $174
c0102503:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102508:	e9 38 f9 ff ff       	jmp    c0101e45 <__alltraps>

c010250d <vector175>:
.globl vector175
vector175:
  pushl $0
c010250d:	6a 00                	push   $0x0
  pushl $175
c010250f:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102514:	e9 2c f9 ff ff       	jmp    c0101e45 <__alltraps>

c0102519 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102519:	6a 00                	push   $0x0
  pushl $176
c010251b:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102520:	e9 20 f9 ff ff       	jmp    c0101e45 <__alltraps>

c0102525 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102525:	6a 00                	push   $0x0
  pushl $177
c0102527:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010252c:	e9 14 f9 ff ff       	jmp    c0101e45 <__alltraps>

c0102531 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102531:	6a 00                	push   $0x0
  pushl $178
c0102533:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102538:	e9 08 f9 ff ff       	jmp    c0101e45 <__alltraps>

c010253d <vector179>:
.globl vector179
vector179:
  pushl $0
c010253d:	6a 00                	push   $0x0
  pushl $179
c010253f:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102544:	e9 fc f8 ff ff       	jmp    c0101e45 <__alltraps>

c0102549 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102549:	6a 00                	push   $0x0
  pushl $180
c010254b:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102550:	e9 f0 f8 ff ff       	jmp    c0101e45 <__alltraps>

c0102555 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102555:	6a 00                	push   $0x0
  pushl $181
c0102557:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010255c:	e9 e4 f8 ff ff       	jmp    c0101e45 <__alltraps>

c0102561 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102561:	6a 00                	push   $0x0
  pushl $182
c0102563:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102568:	e9 d8 f8 ff ff       	jmp    c0101e45 <__alltraps>

c010256d <vector183>:
.globl vector183
vector183:
  pushl $0
c010256d:	6a 00                	push   $0x0
  pushl $183
c010256f:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102574:	e9 cc f8 ff ff       	jmp    c0101e45 <__alltraps>

c0102579 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102579:	6a 00                	push   $0x0
  pushl $184
c010257b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102580:	e9 c0 f8 ff ff       	jmp    c0101e45 <__alltraps>

c0102585 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102585:	6a 00                	push   $0x0
  pushl $185
c0102587:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010258c:	e9 b4 f8 ff ff       	jmp    c0101e45 <__alltraps>

c0102591 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102591:	6a 00                	push   $0x0
  pushl $186
c0102593:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102598:	e9 a8 f8 ff ff       	jmp    c0101e45 <__alltraps>

c010259d <vector187>:
.globl vector187
vector187:
  pushl $0
c010259d:	6a 00                	push   $0x0
  pushl $187
c010259f:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01025a4:	e9 9c f8 ff ff       	jmp    c0101e45 <__alltraps>

c01025a9 <vector188>:
.globl vector188
vector188:
  pushl $0
c01025a9:	6a 00                	push   $0x0
  pushl $188
c01025ab:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01025b0:	e9 90 f8 ff ff       	jmp    c0101e45 <__alltraps>

c01025b5 <vector189>:
.globl vector189
vector189:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $189
c01025b7:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01025bc:	e9 84 f8 ff ff       	jmp    c0101e45 <__alltraps>

c01025c1 <vector190>:
.globl vector190
vector190:
  pushl $0
c01025c1:	6a 00                	push   $0x0
  pushl $190
c01025c3:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025c8:	e9 78 f8 ff ff       	jmp    c0101e45 <__alltraps>

c01025cd <vector191>:
.globl vector191
vector191:
  pushl $0
c01025cd:	6a 00                	push   $0x0
  pushl $191
c01025cf:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025d4:	e9 6c f8 ff ff       	jmp    c0101e45 <__alltraps>

c01025d9 <vector192>:
.globl vector192
vector192:
  pushl $0
c01025d9:	6a 00                	push   $0x0
  pushl $192
c01025db:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025e0:	e9 60 f8 ff ff       	jmp    c0101e45 <__alltraps>

c01025e5 <vector193>:
.globl vector193
vector193:
  pushl $0
c01025e5:	6a 00                	push   $0x0
  pushl $193
c01025e7:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025ec:	e9 54 f8 ff ff       	jmp    c0101e45 <__alltraps>

c01025f1 <vector194>:
.globl vector194
vector194:
  pushl $0
c01025f1:	6a 00                	push   $0x0
  pushl $194
c01025f3:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025f8:	e9 48 f8 ff ff       	jmp    c0101e45 <__alltraps>

c01025fd <vector195>:
.globl vector195
vector195:
  pushl $0
c01025fd:	6a 00                	push   $0x0
  pushl $195
c01025ff:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102604:	e9 3c f8 ff ff       	jmp    c0101e45 <__alltraps>

c0102609 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102609:	6a 00                	push   $0x0
  pushl $196
c010260b:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102610:	e9 30 f8 ff ff       	jmp    c0101e45 <__alltraps>

c0102615 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102615:	6a 00                	push   $0x0
  pushl $197
c0102617:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010261c:	e9 24 f8 ff ff       	jmp    c0101e45 <__alltraps>

c0102621 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102621:	6a 00                	push   $0x0
  pushl $198
c0102623:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102628:	e9 18 f8 ff ff       	jmp    c0101e45 <__alltraps>

c010262d <vector199>:
.globl vector199
vector199:
  pushl $0
c010262d:	6a 00                	push   $0x0
  pushl $199
c010262f:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102634:	e9 0c f8 ff ff       	jmp    c0101e45 <__alltraps>

c0102639 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102639:	6a 00                	push   $0x0
  pushl $200
c010263b:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102640:	e9 00 f8 ff ff       	jmp    c0101e45 <__alltraps>

c0102645 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102645:	6a 00                	push   $0x0
  pushl $201
c0102647:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010264c:	e9 f4 f7 ff ff       	jmp    c0101e45 <__alltraps>

c0102651 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102651:	6a 00                	push   $0x0
  pushl $202
c0102653:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102658:	e9 e8 f7 ff ff       	jmp    c0101e45 <__alltraps>

c010265d <vector203>:
.globl vector203
vector203:
  pushl $0
c010265d:	6a 00                	push   $0x0
  pushl $203
c010265f:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102664:	e9 dc f7 ff ff       	jmp    c0101e45 <__alltraps>

c0102669 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102669:	6a 00                	push   $0x0
  pushl $204
c010266b:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102670:	e9 d0 f7 ff ff       	jmp    c0101e45 <__alltraps>

c0102675 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102675:	6a 00                	push   $0x0
  pushl $205
c0102677:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010267c:	e9 c4 f7 ff ff       	jmp    c0101e45 <__alltraps>

c0102681 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102681:	6a 00                	push   $0x0
  pushl $206
c0102683:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102688:	e9 b8 f7 ff ff       	jmp    c0101e45 <__alltraps>

c010268d <vector207>:
.globl vector207
vector207:
  pushl $0
c010268d:	6a 00                	push   $0x0
  pushl $207
c010268f:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102694:	e9 ac f7 ff ff       	jmp    c0101e45 <__alltraps>

c0102699 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102699:	6a 00                	push   $0x0
  pushl $208
c010269b:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01026a0:	e9 a0 f7 ff ff       	jmp    c0101e45 <__alltraps>

c01026a5 <vector209>:
.globl vector209
vector209:
  pushl $0
c01026a5:	6a 00                	push   $0x0
  pushl $209
c01026a7:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01026ac:	e9 94 f7 ff ff       	jmp    c0101e45 <__alltraps>

c01026b1 <vector210>:
.globl vector210
vector210:
  pushl $0
c01026b1:	6a 00                	push   $0x0
  pushl $210
c01026b3:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01026b8:	e9 88 f7 ff ff       	jmp    c0101e45 <__alltraps>

c01026bd <vector211>:
.globl vector211
vector211:
  pushl $0
c01026bd:	6a 00                	push   $0x0
  pushl $211
c01026bf:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026c4:	e9 7c f7 ff ff       	jmp    c0101e45 <__alltraps>

c01026c9 <vector212>:
.globl vector212
vector212:
  pushl $0
c01026c9:	6a 00                	push   $0x0
  pushl $212
c01026cb:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026d0:	e9 70 f7 ff ff       	jmp    c0101e45 <__alltraps>

c01026d5 <vector213>:
.globl vector213
vector213:
  pushl $0
c01026d5:	6a 00                	push   $0x0
  pushl $213
c01026d7:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026dc:	e9 64 f7 ff ff       	jmp    c0101e45 <__alltraps>

c01026e1 <vector214>:
.globl vector214
vector214:
  pushl $0
c01026e1:	6a 00                	push   $0x0
  pushl $214
c01026e3:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026e8:	e9 58 f7 ff ff       	jmp    c0101e45 <__alltraps>

c01026ed <vector215>:
.globl vector215
vector215:
  pushl $0
c01026ed:	6a 00                	push   $0x0
  pushl $215
c01026ef:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026f4:	e9 4c f7 ff ff       	jmp    c0101e45 <__alltraps>

c01026f9 <vector216>:
.globl vector216
vector216:
  pushl $0
c01026f9:	6a 00                	push   $0x0
  pushl $216
c01026fb:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102700:	e9 40 f7 ff ff       	jmp    c0101e45 <__alltraps>

c0102705 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102705:	6a 00                	push   $0x0
  pushl $217
c0102707:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010270c:	e9 34 f7 ff ff       	jmp    c0101e45 <__alltraps>

c0102711 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102711:	6a 00                	push   $0x0
  pushl $218
c0102713:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102718:	e9 28 f7 ff ff       	jmp    c0101e45 <__alltraps>

c010271d <vector219>:
.globl vector219
vector219:
  pushl $0
c010271d:	6a 00                	push   $0x0
  pushl $219
c010271f:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102724:	e9 1c f7 ff ff       	jmp    c0101e45 <__alltraps>

c0102729 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102729:	6a 00                	push   $0x0
  pushl $220
c010272b:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102730:	e9 10 f7 ff ff       	jmp    c0101e45 <__alltraps>

c0102735 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102735:	6a 00                	push   $0x0
  pushl $221
c0102737:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010273c:	e9 04 f7 ff ff       	jmp    c0101e45 <__alltraps>

c0102741 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102741:	6a 00                	push   $0x0
  pushl $222
c0102743:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102748:	e9 f8 f6 ff ff       	jmp    c0101e45 <__alltraps>

c010274d <vector223>:
.globl vector223
vector223:
  pushl $0
c010274d:	6a 00                	push   $0x0
  pushl $223
c010274f:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102754:	e9 ec f6 ff ff       	jmp    c0101e45 <__alltraps>

c0102759 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102759:	6a 00                	push   $0x0
  pushl $224
c010275b:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102760:	e9 e0 f6 ff ff       	jmp    c0101e45 <__alltraps>

c0102765 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102765:	6a 00                	push   $0x0
  pushl $225
c0102767:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010276c:	e9 d4 f6 ff ff       	jmp    c0101e45 <__alltraps>

c0102771 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102771:	6a 00                	push   $0x0
  pushl $226
c0102773:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102778:	e9 c8 f6 ff ff       	jmp    c0101e45 <__alltraps>

c010277d <vector227>:
.globl vector227
vector227:
  pushl $0
c010277d:	6a 00                	push   $0x0
  pushl $227
c010277f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102784:	e9 bc f6 ff ff       	jmp    c0101e45 <__alltraps>

c0102789 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102789:	6a 00                	push   $0x0
  pushl $228
c010278b:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102790:	e9 b0 f6 ff ff       	jmp    c0101e45 <__alltraps>

c0102795 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102795:	6a 00                	push   $0x0
  pushl $229
c0102797:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010279c:	e9 a4 f6 ff ff       	jmp    c0101e45 <__alltraps>

c01027a1 <vector230>:
.globl vector230
vector230:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $230
c01027a3:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01027a8:	e9 98 f6 ff ff       	jmp    c0101e45 <__alltraps>

c01027ad <vector231>:
.globl vector231
vector231:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $231
c01027af:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027b4:	e9 8c f6 ff ff       	jmp    c0101e45 <__alltraps>

c01027b9 <vector232>:
.globl vector232
vector232:
  pushl $0
c01027b9:	6a 00                	push   $0x0
  pushl $232
c01027bb:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027c0:	e9 80 f6 ff ff       	jmp    c0101e45 <__alltraps>

c01027c5 <vector233>:
.globl vector233
vector233:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $233
c01027c7:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027cc:	e9 74 f6 ff ff       	jmp    c0101e45 <__alltraps>

c01027d1 <vector234>:
.globl vector234
vector234:
  pushl $0
c01027d1:	6a 00                	push   $0x0
  pushl $234
c01027d3:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027d8:	e9 68 f6 ff ff       	jmp    c0101e45 <__alltraps>

c01027dd <vector235>:
.globl vector235
vector235:
  pushl $0
c01027dd:	6a 00                	push   $0x0
  pushl $235
c01027df:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027e4:	e9 5c f6 ff ff       	jmp    c0101e45 <__alltraps>

c01027e9 <vector236>:
.globl vector236
vector236:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $236
c01027eb:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027f0:	e9 50 f6 ff ff       	jmp    c0101e45 <__alltraps>

c01027f5 <vector237>:
.globl vector237
vector237:
  pushl $0
c01027f5:	6a 00                	push   $0x0
  pushl $237
c01027f7:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027fc:	e9 44 f6 ff ff       	jmp    c0101e45 <__alltraps>

c0102801 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102801:	6a 00                	push   $0x0
  pushl $238
c0102803:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102808:	e9 38 f6 ff ff       	jmp    c0101e45 <__alltraps>

c010280d <vector239>:
.globl vector239
vector239:
  pushl $0
c010280d:	6a 00                	push   $0x0
  pushl $239
c010280f:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102814:	e9 2c f6 ff ff       	jmp    c0101e45 <__alltraps>

c0102819 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102819:	6a 00                	push   $0x0
  pushl $240
c010281b:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102820:	e9 20 f6 ff ff       	jmp    c0101e45 <__alltraps>

c0102825 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102825:	6a 00                	push   $0x0
  pushl $241
c0102827:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010282c:	e9 14 f6 ff ff       	jmp    c0101e45 <__alltraps>

c0102831 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102831:	6a 00                	push   $0x0
  pushl $242
c0102833:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102838:	e9 08 f6 ff ff       	jmp    c0101e45 <__alltraps>

c010283d <vector243>:
.globl vector243
vector243:
  pushl $0
c010283d:	6a 00                	push   $0x0
  pushl $243
c010283f:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102844:	e9 fc f5 ff ff       	jmp    c0101e45 <__alltraps>

c0102849 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102849:	6a 00                	push   $0x0
  pushl $244
c010284b:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102850:	e9 f0 f5 ff ff       	jmp    c0101e45 <__alltraps>

c0102855 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102855:	6a 00                	push   $0x0
  pushl $245
c0102857:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010285c:	e9 e4 f5 ff ff       	jmp    c0101e45 <__alltraps>

c0102861 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102861:	6a 00                	push   $0x0
  pushl $246
c0102863:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102868:	e9 d8 f5 ff ff       	jmp    c0101e45 <__alltraps>

c010286d <vector247>:
.globl vector247
vector247:
  pushl $0
c010286d:	6a 00                	push   $0x0
  pushl $247
c010286f:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102874:	e9 cc f5 ff ff       	jmp    c0101e45 <__alltraps>

c0102879 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $248
c010287b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102880:	e9 c0 f5 ff ff       	jmp    c0101e45 <__alltraps>

c0102885 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102885:	6a 00                	push   $0x0
  pushl $249
c0102887:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010288c:	e9 b4 f5 ff ff       	jmp    c0101e45 <__alltraps>

c0102891 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102891:	6a 00                	push   $0x0
  pushl $250
c0102893:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102898:	e9 a8 f5 ff ff       	jmp    c0101e45 <__alltraps>

c010289d <vector251>:
.globl vector251
vector251:
  pushl $0
c010289d:	6a 00                	push   $0x0
  pushl $251
c010289f:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01028a4:	e9 9c f5 ff ff       	jmp    c0101e45 <__alltraps>

c01028a9 <vector252>:
.globl vector252
vector252:
  pushl $0
c01028a9:	6a 00                	push   $0x0
  pushl $252
c01028ab:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01028b0:	e9 90 f5 ff ff       	jmp    c0101e45 <__alltraps>

c01028b5 <vector253>:
.globl vector253
vector253:
  pushl $0
c01028b5:	6a 00                	push   $0x0
  pushl $253
c01028b7:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01028bc:	e9 84 f5 ff ff       	jmp    c0101e45 <__alltraps>

c01028c1 <vector254>:
.globl vector254
vector254:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $254
c01028c3:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028c8:	e9 78 f5 ff ff       	jmp    c0101e45 <__alltraps>

c01028cd <vector255>:
.globl vector255
vector255:
  pushl $0
c01028cd:	6a 00                	push   $0x0
  pushl $255
c01028cf:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028d4:	e9 6c f5 ff ff       	jmp    c0101e45 <__alltraps>

c01028d9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028d9:	55                   	push   %ebp
c01028da:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028dc:	8b 55 08             	mov    0x8(%ebp),%edx
c01028df:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c01028e4:	29 c2                	sub    %eax,%edx
c01028e6:	89 d0                	mov    %edx,%eax
c01028e8:	c1 f8 02             	sar    $0x2,%eax
c01028eb:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028f1:	5d                   	pop    %ebp
c01028f2:	c3                   	ret    

c01028f3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028f3:	55                   	push   %ebp
c01028f4:	89 e5                	mov    %esp,%ebp
c01028f6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01028fc:	89 04 24             	mov    %eax,(%esp)
c01028ff:	e8 d5 ff ff ff       	call   c01028d9 <page2ppn>
c0102904:	c1 e0 0c             	shl    $0xc,%eax
}
c0102907:	c9                   	leave  
c0102908:	c3                   	ret    

c0102909 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102909:	55                   	push   %ebp
c010290a:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010290c:	8b 45 08             	mov    0x8(%ebp),%eax
c010290f:	8b 00                	mov    (%eax),%eax
}
c0102911:	5d                   	pop    %ebp
c0102912:	c3                   	ret    

c0102913 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102913:	55                   	push   %ebp
c0102914:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102916:	8b 45 08             	mov    0x8(%ebp),%eax
c0102919:	8b 55 0c             	mov    0xc(%ebp),%edx
c010291c:	89 10                	mov    %edx,(%eax)
}
c010291e:	5d                   	pop    %ebp
c010291f:	c3                   	ret    

c0102920 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102920:	55                   	push   %ebp
c0102921:	89 e5                	mov    %esp,%ebp
c0102923:	83 ec 10             	sub    $0x10,%esp
c0102926:	c7 45 fc 10 af 11 c0 	movl   $0xc011af10,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010292d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102930:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102933:	89 50 04             	mov    %edx,0x4(%eax)
c0102936:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102939:	8b 50 04             	mov    0x4(%eax),%edx
c010293c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010293f:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102941:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c0102948:	00 00 00 
}
c010294b:	c9                   	leave  
c010294c:	c3                   	ret    

c010294d <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010294d:	55                   	push   %ebp
c010294e:	89 e5                	mov    %esp,%ebp
c0102950:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102953:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102957:	75 24                	jne    c010297d <default_init_memmap+0x30>
c0102959:	c7 44 24 0c 90 67 10 	movl   $0xc0106790,0xc(%esp)
c0102960:	c0 
c0102961:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0102968:	c0 
c0102969:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102970:	00 
c0102971:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0102978:	e8 63 e3 ff ff       	call   c0100ce0 <__panic>
// 设置当前页向后的n个页
    struct Page *p = base;
c010297d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102980:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102983:	eb 7d                	jmp    c0102a02 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0102985:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102988:	83 c0 04             	add    $0x4,%eax
c010298b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102992:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102995:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102998:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010299b:	0f a3 10             	bt     %edx,(%eax)
c010299e:	19 c0                	sbb    %eax,%eax
c01029a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01029a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01029a7:	0f 95 c0             	setne  %al
c01029aa:	0f b6 c0             	movzbl %al,%eax
c01029ad:	85 c0                	test   %eax,%eax
c01029af:	75 24                	jne    c01029d5 <default_init_memmap+0x88>
c01029b1:	c7 44 24 0c c1 67 10 	movl   $0xc01067c1,0xc(%esp)
c01029b8:	c0 
c01029b9:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01029c0:	c0 
c01029c1:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c01029c8:	00 
c01029c9:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01029d0:	e8 0b e3 ff ff       	call   c0100ce0 <__panic>
        p->flags = p->property = 0;
c01029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029e2:	8b 50 08             	mov    0x8(%eax),%edx
c01029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029e8:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01029eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029f2:	00 
c01029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029f6:	89 04 24             	mov    %eax,(%esp)
c01029f9:	e8 15 ff ff ff       	call   c0102913 <set_page_ref>
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
// 设置当前页向后的n个页
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01029fe:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a02:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a05:	89 d0                	mov    %edx,%eax
c0102a07:	c1 e0 02             	shl    $0x2,%eax
c0102a0a:	01 d0                	add    %edx,%eax
c0102a0c:	c1 e0 02             	shl    $0x2,%eax
c0102a0f:	89 c2                	mov    %eax,%edx
c0102a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a14:	01 d0                	add    %edx,%eax
c0102a16:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a19:	0f 85 66 ff ff ff    	jne    c0102985 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
 // 设置free pages的数量
    base->property = n;
c0102a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a22:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a25:	89 50 08             	mov    %edx,0x8(%eax)
// 设置当前页为可用
    SetPageProperty(base);
c0102a28:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a2b:	83 c0 04             	add    $0x4,%eax
c0102a2e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102a35:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a38:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102a3e:	0f ab 10             	bts    %edx,(%eax)
// 设置总共的空闲内存页面
    nr_free += n;
c0102a41:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102a47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a4a:	01 d0                	add    %edx,%eax
c0102a4c:	a3 18 af 11 c0       	mov    %eax,0xc011af18
    list_add_before(&free_list, &(base->page_link));
c0102a51:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a54:	83 c0 0c             	add    $0xc,%eax
c0102a57:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
c0102a5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a64:	8b 00                	mov    (%eax),%eax
c0102a66:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a69:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102a6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102a6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a72:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a75:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a78:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a7b:	89 10                	mov    %edx,(%eax)
c0102a7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a80:	8b 10                	mov    (%eax),%edx
c0102a82:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a85:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a8b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a8e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a94:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a97:	89 10                	mov    %edx,(%eax)
}
c0102a99:	c9                   	leave  
c0102a9a:	c3                   	ret    

c0102a9b <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a9b:	55                   	push   %ebp
c0102a9c:	89 e5                	mov    %esp,%ebp
c0102a9e:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102aa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102aa5:	75 24                	jne    c0102acb <default_alloc_pages+0x30>
c0102aa7:	c7 44 24 0c 90 67 10 	movl   $0xc0106790,0xc(%esp)
c0102aae:	c0 
c0102aaf:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0102ab6:	c0 
c0102ab7:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
c0102abe:	00 
c0102abf:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0102ac6:	e8 15 e2 ff ff       	call   c0100ce0 <__panic>
// 如果待分配的空闲页面数量小于所需的内存数量
    if (n > nr_free) {
c0102acb:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102ad0:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ad3:	73 0a                	jae    c0102adf <default_alloc_pages+0x44>
        return NULL;
c0102ad5:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ada:	e9 3d 01 00 00       	jmp    c0102c1c <default_alloc_pages+0x181>
    }
 // 查找符合要求的连续页
    struct Page *page = NULL;
c0102adf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102ae6:	c7 45 f0 10 af 11 c0 	movl   $0xc011af10,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102aed:	eb 1c                	jmp    c0102b0b <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102af2:	83 e8 0c             	sub    $0xc,%eax
c0102af5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102afb:	8b 40 08             	mov    0x8(%eax),%eax
c0102afe:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b01:	72 08                	jb     c0102b0b <default_alloc_pages+0x70>
            page = p;
c0102b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102b09:	eb 18                	jmp    c0102b23 <default_alloc_pages+0x88>
c0102b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b14:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
 // 查找符合要求的连续页
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b1a:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102b21:	75 cc                	jne    c0102aef <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102b23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102b27:	0f 84 ec 00 00 00    	je     c0102c19 <default_alloc_pages+0x17e>
    	if (page->property > n) {
c0102b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b30:	8b 40 08             	mov    0x8(%eax),%eax
c0102b33:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b36:	0f 86 8c 00 00 00    	jbe    c0102bc8 <default_alloc_pages+0x12d>
       		struct Page *p = page + n;
c0102b3c:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b3f:	89 d0                	mov    %edx,%eax
c0102b41:	c1 e0 02             	shl    $0x2,%eax
c0102b44:	01 d0                	add    %edx,%eax
c0102b46:	c1 e0 02             	shl    $0x2,%eax
c0102b49:	89 c2                	mov    %eax,%edx
c0102b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b4e:	01 d0                	add    %edx,%eax
c0102b50:	89 45 e8             	mov    %eax,-0x18(%ebp)
       		p->property = page->property - n;
c0102b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b56:	8b 40 08             	mov    0x8(%eax),%eax
c0102b59:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b5c:	89 c2                	mov    %eax,%edx
c0102b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b61:	89 50 08             	mov    %edx,0x8(%eax)
       		SetPageProperty(p);
c0102b64:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b67:	83 c0 04             	add    $0x4,%eax
c0102b6a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102b71:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102b74:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b77:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b7a:	0f ab 10             	bts    %edx,(%eax)
       		// 注意这一步add after
        	list_add_after(&(page->page_link), &(p->page_link));
c0102b7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b80:	83 c0 0c             	add    $0xc,%eax
c0102b83:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102b86:	83 c2 0c             	add    $0xc,%edx
c0102b89:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102b8c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102b8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b92:	8b 40 04             	mov    0x4(%eax),%eax
c0102b95:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b98:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102b9b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b9e:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102ba1:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ba4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102ba7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102baa:	89 10                	mov    %edx,(%eax)
c0102bac:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102baf:	8b 10                	mov    (%eax),%edx
c0102bb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102bb4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102bb7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102bba:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102bbd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102bc0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102bc3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102bc6:	89 10                	mov    %edx,(%eax)
   	    }
    	    list_del(&(page->page_link));
c0102bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bcb:	83 c0 0c             	add    $0xc,%eax
c0102bce:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102bd1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102bd4:	8b 40 04             	mov    0x4(%eax),%eax
c0102bd7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102bda:	8b 12                	mov    (%edx),%edx
c0102bdc:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102bdf:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102be2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102be5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102be8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102beb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102bee:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102bf1:	89 10                	mov    %edx,(%eax)
    	    nr_free -= n;
c0102bf3:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102bf8:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bfb:	a3 18 af 11 c0       	mov    %eax,0xc011af18
    	    ClearPageProperty(page);
c0102c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c03:	83 c0 04             	add    $0x4,%eax
c0102c06:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102c0d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c10:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102c13:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102c16:	0f b3 10             	btr    %edx,(%eax)
	}
    return page;
c0102c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102c1c:	c9                   	leave  
c0102c1d:	c3                   	ret    

c0102c1e <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102c1e:	55                   	push   %ebp
c0102c1f:	89 e5                	mov    %esp,%ebp
c0102c21:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c2b:	75 24                	jne    c0102c51 <default_free_pages+0x33>
c0102c2d:	c7 44 24 0c 90 67 10 	movl   $0xc0106790,0xc(%esp)
c0102c34:	c0 
c0102c35:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0102c3c:	c0 
c0102c3d:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0102c44:	00 
c0102c45:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0102c4c:	e8 8f e0 ff ff       	call   c0100ce0 <__panic>
    struct Page *p = base;
c0102c51:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102c57:	e9 9d 00 00 00       	jmp    c0102cf9 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c5f:	83 c0 04             	add    $0x4,%eax
c0102c62:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102c69:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c72:	0f a3 10             	bt     %edx,(%eax)
c0102c75:	19 c0                	sbb    %eax,%eax
c0102c77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102c7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c7e:	0f 95 c0             	setne  %al
c0102c81:	0f b6 c0             	movzbl %al,%eax
c0102c84:	85 c0                	test   %eax,%eax
c0102c86:	75 2c                	jne    c0102cb4 <default_free_pages+0x96>
c0102c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c8b:	83 c0 04             	add    $0x4,%eax
c0102c8e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102c95:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c98:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c9e:	0f a3 10             	bt     %edx,(%eax)
c0102ca1:	19 c0                	sbb    %eax,%eax
c0102ca3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102ca6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102caa:	0f 95 c0             	setne  %al
c0102cad:	0f b6 c0             	movzbl %al,%eax
c0102cb0:	85 c0                	test   %eax,%eax
c0102cb2:	74 24                	je     c0102cd8 <default_free_pages+0xba>
c0102cb4:	c7 44 24 0c d4 67 10 	movl   $0xc01067d4,0xc(%esp)
c0102cbb:	c0 
c0102cbc:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0102cc3:	c0 
c0102cc4:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
c0102ccb:	00 
c0102ccc:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0102cd3:	e8 08 e0 ff ff       	call   c0100ce0 <__panic>
        p->flags = 0;
c0102cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102ce2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102ce9:	00 
c0102cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ced:	89 04 24             	mov    %eax,(%esp)
c0102cf0:	e8 1e fc ff ff       	call   c0102913 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102cf5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cfc:	89 d0                	mov    %edx,%eax
c0102cfe:	c1 e0 02             	shl    $0x2,%eax
c0102d01:	01 d0                	add    %edx,%eax
c0102d03:	c1 e0 02             	shl    $0x2,%eax
c0102d06:	89 c2                	mov    %eax,%edx
c0102d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d0b:	01 d0                	add    %edx,%eax
c0102d0d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d10:	0f 85 46 ff ff ff    	jne    c0102c5c <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102d16:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d19:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d1c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102d1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d22:	83 c0 04             	add    $0x4,%eax
c0102d25:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102d2c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d32:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102d35:	0f ab 10             	bts    %edx,(%eax)
c0102d38:	c7 45 cc 10 af 11 c0 	movl   $0xc011af10,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102d3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d42:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102d48:	e9 08 01 00 00       	jmp    c0102e55 <default_free_pages+0x237>
        p = le2page(le, page_link);
c0102d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d50:	83 e8 0c             	sub    $0xc,%eax
c0102d53:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d59:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102d5c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d5f:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102d62:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102d65:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d68:	8b 50 08             	mov    0x8(%eax),%edx
c0102d6b:	89 d0                	mov    %edx,%eax
c0102d6d:	c1 e0 02             	shl    $0x2,%eax
c0102d70:	01 d0                	add    %edx,%eax
c0102d72:	c1 e0 02             	shl    $0x2,%eax
c0102d75:	89 c2                	mov    %eax,%edx
c0102d77:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d7a:	01 d0                	add    %edx,%eax
c0102d7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d7f:	75 5a                	jne    c0102ddb <default_free_pages+0x1bd>
            base->property += p->property;
c0102d81:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d84:	8b 50 08             	mov    0x8(%eax),%edx
c0102d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d8a:	8b 40 08             	mov    0x8(%eax),%eax
c0102d8d:	01 c2                	add    %eax,%edx
c0102d8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d92:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d98:	83 c0 04             	add    $0x4,%eax
c0102d9b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102da2:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102da5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102da8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102dab:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db1:	83 c0 0c             	add    $0xc,%eax
c0102db4:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102db7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102dba:	8b 40 04             	mov    0x4(%eax),%eax
c0102dbd:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102dc0:	8b 12                	mov    (%edx),%edx
c0102dc2:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102dc5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102dc8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102dcb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102dce:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102dd1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102dd4:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102dd7:	89 10                	mov    %edx,(%eax)
c0102dd9:	eb 7a                	jmp    c0102e55 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0102ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dde:	8b 50 08             	mov    0x8(%eax),%edx
c0102de1:	89 d0                	mov    %edx,%eax
c0102de3:	c1 e0 02             	shl    $0x2,%eax
c0102de6:	01 d0                	add    %edx,%eax
c0102de8:	c1 e0 02             	shl    $0x2,%eax
c0102deb:	89 c2                	mov    %eax,%edx
c0102ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102df0:	01 d0                	add    %edx,%eax
c0102df2:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102df5:	75 5e                	jne    c0102e55 <default_free_pages+0x237>
            p->property += base->property;
c0102df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dfa:	8b 50 08             	mov    0x8(%eax),%edx
c0102dfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e00:	8b 40 08             	mov    0x8(%eax),%eax
c0102e03:	01 c2                	add    %eax,%edx
c0102e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e08:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102e0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e0e:	83 c0 04             	add    $0x4,%eax
c0102e11:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102e18:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102e1b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e1e:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102e21:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e27:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e2d:	83 c0 0c             	add    $0xc,%eax
c0102e30:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102e33:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e36:	8b 40 04             	mov    0x4(%eax),%eax
c0102e39:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102e3c:	8b 12                	mov    (%edx),%edx
c0102e3e:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102e41:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102e44:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102e47:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102e4a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e4d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102e50:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e53:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102e55:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102e5c:	0f 85 eb fe ff ff    	jne    c0102d4d <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0102e62:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102e68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e6b:	01 d0                	add    %edx,%eax
c0102e6d:	a3 18 af 11 c0       	mov    %eax,0xc011af18
c0102e72:	c7 45 9c 10 af 11 c0 	movl   $0xc011af10,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102e79:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102e7c:	8b 40 04             	mov    0x4(%eax),%eax
#if 0
    list_add(&free_list, &(base->page_link));
#else
    // myLAB2 链表按照低地址到高地址的顺序排列，因此要查找插入点
    for(le = list_next(&free_list); le != &free_list; le = list_next(le))
c0102e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e82:	eb 76                	jmp    c0102efa <default_free_pages+0x2dc>
    {
        p = le2page(le, page_link);
c0102e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e87:	83 e8 0c             	sub    $0xc,%eax
c0102e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0102e8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e90:	8b 50 08             	mov    0x8(%eax),%edx
c0102e93:	89 d0                	mov    %edx,%eax
c0102e95:	c1 e0 02             	shl    $0x2,%eax
c0102e98:	01 d0                	add    %edx,%eax
c0102e9a:	c1 e0 02             	shl    $0x2,%eax
c0102e9d:	89 c2                	mov    %eax,%edx
c0102e9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ea2:	01 d0                	add    %edx,%eax
c0102ea4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ea7:	77 42                	ja     c0102eeb <default_free_pages+0x2cd>
            assert(base + base->property != p);
c0102ea9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eac:	8b 50 08             	mov    0x8(%eax),%edx
c0102eaf:	89 d0                	mov    %edx,%eax
c0102eb1:	c1 e0 02             	shl    $0x2,%eax
c0102eb4:	01 d0                	add    %edx,%eax
c0102eb6:	c1 e0 02             	shl    $0x2,%eax
c0102eb9:	89 c2                	mov    %eax,%edx
c0102ebb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ebe:	01 d0                	add    %edx,%eax
c0102ec0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ec3:	75 24                	jne    c0102ee9 <default_free_pages+0x2cb>
c0102ec5:	c7 44 24 0c f9 67 10 	movl   $0xc01067f9,0xc(%esp)
c0102ecc:	c0 
c0102ecd:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0102ed4:	c0 
c0102ed5:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0102edc:	00 
c0102edd:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0102ee4:	e8 f7 dd ff ff       	call   c0100ce0 <__panic>
            break;
c0102ee9:	eb 18                	jmp    c0102f03 <default_free_pages+0x2e5>
c0102eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102eee:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102ef1:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102ef4:	8b 40 04             	mov    0x4(%eax),%eax
    nr_free += n;
#if 0
    list_add(&free_list, &(base->page_link));
#else
    // myLAB2 链表按照低地址到高地址的顺序排列，因此要查找插入点
    for(le = list_next(&free_list); le != &free_list; le = list_next(le))
c0102ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102efa:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102f01:	75 81                	jne    c0102e84 <default_free_pages+0x266>
        if (base + base->property <= p) {
            assert(base + base->property != p);
            break;
        }
    }
    list_add_before(le, &(base->page_link));
c0102f03:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f06:	8d 50 0c             	lea    0xc(%eax),%edx
c0102f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f0c:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102f0f:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102f12:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f15:	8b 00                	mov    (%eax),%eax
c0102f17:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102f1a:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102f1d:	89 45 88             	mov    %eax,-0x78(%ebp)
c0102f20:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f23:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102f26:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102f29:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102f2c:	89 10                	mov    %edx,(%eax)
c0102f2e:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102f31:	8b 10                	mov    (%eax),%edx
c0102f33:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102f36:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102f39:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f3c:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102f3f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102f42:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f45:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102f48:	89 10                	mov    %edx,(%eax)
#endif
}
c0102f4a:	c9                   	leave  
c0102f4b:	c3                   	ret    

c0102f4c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102f4c:	55                   	push   %ebp
c0102f4d:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102f4f:	a1 18 af 11 c0       	mov    0xc011af18,%eax
}
c0102f54:	5d                   	pop    %ebp
c0102f55:	c3                   	ret    

c0102f56 <basic_check>:

static void
basic_check(void) {
c0102f56:	55                   	push   %ebp
c0102f57:	89 e5                	mov    %esp,%ebp
c0102f59:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102f5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f66:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102f6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f76:	e8 db 0e 00 00       	call   c0103e56 <alloc_pages>
c0102f7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102f82:	75 24                	jne    c0102fa8 <basic_check+0x52>
c0102f84:	c7 44 24 0c 14 68 10 	movl   $0xc0106814,0xc(%esp)
c0102f8b:	c0 
c0102f8c:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0102f93:	c0 
c0102f94:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0102f9b:	00 
c0102f9c:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0102fa3:	e8 38 dd ff ff       	call   c0100ce0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102fa8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102faf:	e8 a2 0e 00 00       	call   c0103e56 <alloc_pages>
c0102fb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102fb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102fbb:	75 24                	jne    c0102fe1 <basic_check+0x8b>
c0102fbd:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c0102fc4:	c0 
c0102fc5:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0102fcc:	c0 
c0102fcd:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0102fd4:	00 
c0102fd5:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0102fdc:	e8 ff dc ff ff       	call   c0100ce0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102fe1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102fe8:	e8 69 0e 00 00       	call   c0103e56 <alloc_pages>
c0102fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ff0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102ff4:	75 24                	jne    c010301a <basic_check+0xc4>
c0102ff6:	c7 44 24 0c 4c 68 10 	movl   $0xc010684c,0xc(%esp)
c0102ffd:	c0 
c0102ffe:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103005:	c0 
c0103006:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c010300d:	00 
c010300e:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103015:	e8 c6 dc ff ff       	call   c0100ce0 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010301a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010301d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103020:	74 10                	je     c0103032 <basic_check+0xdc>
c0103022:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103025:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103028:	74 08                	je     c0103032 <basic_check+0xdc>
c010302a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010302d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103030:	75 24                	jne    c0103056 <basic_check+0x100>
c0103032:	c7 44 24 0c 68 68 10 	movl   $0xc0106868,0xc(%esp)
c0103039:	c0 
c010303a:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103041:	c0 
c0103042:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103049:	00 
c010304a:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103051:	e8 8a dc ff ff       	call   c0100ce0 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103056:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103059:	89 04 24             	mov    %eax,(%esp)
c010305c:	e8 a8 f8 ff ff       	call   c0102909 <page_ref>
c0103061:	85 c0                	test   %eax,%eax
c0103063:	75 1e                	jne    c0103083 <basic_check+0x12d>
c0103065:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103068:	89 04 24             	mov    %eax,(%esp)
c010306b:	e8 99 f8 ff ff       	call   c0102909 <page_ref>
c0103070:	85 c0                	test   %eax,%eax
c0103072:	75 0f                	jne    c0103083 <basic_check+0x12d>
c0103074:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103077:	89 04 24             	mov    %eax,(%esp)
c010307a:	e8 8a f8 ff ff       	call   c0102909 <page_ref>
c010307f:	85 c0                	test   %eax,%eax
c0103081:	74 24                	je     c01030a7 <basic_check+0x151>
c0103083:	c7 44 24 0c 8c 68 10 	movl   $0xc010688c,0xc(%esp)
c010308a:	c0 
c010308b:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103092:	c0 
c0103093:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c010309a:	00 
c010309b:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01030a2:	e8 39 dc ff ff       	call   c0100ce0 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01030a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030aa:	89 04 24             	mov    %eax,(%esp)
c01030ad:	e8 41 f8 ff ff       	call   c01028f3 <page2pa>
c01030b2:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c01030b8:	c1 e2 0c             	shl    $0xc,%edx
c01030bb:	39 d0                	cmp    %edx,%eax
c01030bd:	72 24                	jb     c01030e3 <basic_check+0x18d>
c01030bf:	c7 44 24 0c c8 68 10 	movl   $0xc01068c8,0xc(%esp)
c01030c6:	c0 
c01030c7:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01030ce:	c0 
c01030cf:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01030d6:	00 
c01030d7:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01030de:	e8 fd db ff ff       	call   c0100ce0 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01030e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030e6:	89 04 24             	mov    %eax,(%esp)
c01030e9:	e8 05 f8 ff ff       	call   c01028f3 <page2pa>
c01030ee:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c01030f4:	c1 e2 0c             	shl    $0xc,%edx
c01030f7:	39 d0                	cmp    %edx,%eax
c01030f9:	72 24                	jb     c010311f <basic_check+0x1c9>
c01030fb:	c7 44 24 0c e5 68 10 	movl   $0xc01068e5,0xc(%esp)
c0103102:	c0 
c0103103:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c010310a:	c0 
c010310b:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103112:	00 
c0103113:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c010311a:	e8 c1 db ff ff       	call   c0100ce0 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103122:	89 04 24             	mov    %eax,(%esp)
c0103125:	e8 c9 f7 ff ff       	call   c01028f3 <page2pa>
c010312a:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0103130:	c1 e2 0c             	shl    $0xc,%edx
c0103133:	39 d0                	cmp    %edx,%eax
c0103135:	72 24                	jb     c010315b <basic_check+0x205>
c0103137:	c7 44 24 0c 02 69 10 	movl   $0xc0106902,0xc(%esp)
c010313e:	c0 
c010313f:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103146:	c0 
c0103147:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010314e:	00 
c010314f:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103156:	e8 85 db ff ff       	call   c0100ce0 <__panic>

    list_entry_t free_list_store = free_list;
c010315b:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0103160:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c0103166:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103169:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010316c:	c7 45 e0 10 af 11 c0 	movl   $0xc011af10,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103173:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103176:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103179:	89 50 04             	mov    %edx,0x4(%eax)
c010317c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010317f:	8b 50 04             	mov    0x4(%eax),%edx
c0103182:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103185:	89 10                	mov    %edx,(%eax)
c0103187:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010318e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103191:	8b 40 04             	mov    0x4(%eax),%eax
c0103194:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103197:	0f 94 c0             	sete   %al
c010319a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010319d:	85 c0                	test   %eax,%eax
c010319f:	75 24                	jne    c01031c5 <basic_check+0x26f>
c01031a1:	c7 44 24 0c 1f 69 10 	movl   $0xc010691f,0xc(%esp)
c01031a8:	c0 
c01031a9:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01031b0:	c0 
c01031b1:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c01031b8:	00 
c01031b9:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01031c0:	e8 1b db ff ff       	call   c0100ce0 <__panic>

    unsigned int nr_free_store = nr_free;
c01031c5:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c01031ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01031cd:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c01031d4:	00 00 00 

    assert(alloc_page() == NULL);
c01031d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031de:	e8 73 0c 00 00       	call   c0103e56 <alloc_pages>
c01031e3:	85 c0                	test   %eax,%eax
c01031e5:	74 24                	je     c010320b <basic_check+0x2b5>
c01031e7:	c7 44 24 0c 36 69 10 	movl   $0xc0106936,0xc(%esp)
c01031ee:	c0 
c01031ef:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01031f6:	c0 
c01031f7:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c01031fe:	00 
c01031ff:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103206:	e8 d5 da ff ff       	call   c0100ce0 <__panic>

    free_page(p0);
c010320b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103212:	00 
c0103213:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103216:	89 04 24             	mov    %eax,(%esp)
c0103219:	e8 70 0c 00 00       	call   c0103e8e <free_pages>
    free_page(p1);
c010321e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103225:	00 
c0103226:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103229:	89 04 24             	mov    %eax,(%esp)
c010322c:	e8 5d 0c 00 00       	call   c0103e8e <free_pages>
    free_page(p2);
c0103231:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103238:	00 
c0103239:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010323c:	89 04 24             	mov    %eax,(%esp)
c010323f:	e8 4a 0c 00 00       	call   c0103e8e <free_pages>
    assert(nr_free == 3);
c0103244:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103249:	83 f8 03             	cmp    $0x3,%eax
c010324c:	74 24                	je     c0103272 <basic_check+0x31c>
c010324e:	c7 44 24 0c 4b 69 10 	movl   $0xc010694b,0xc(%esp)
c0103255:	c0 
c0103256:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c010325d:	c0 
c010325e:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103265:	00 
c0103266:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c010326d:	e8 6e da ff ff       	call   c0100ce0 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103272:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103279:	e8 d8 0b 00 00       	call   c0103e56 <alloc_pages>
c010327e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103281:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103285:	75 24                	jne    c01032ab <basic_check+0x355>
c0103287:	c7 44 24 0c 14 68 10 	movl   $0xc0106814,0xc(%esp)
c010328e:	c0 
c010328f:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103296:	c0 
c0103297:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c010329e:	00 
c010329f:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01032a6:	e8 35 da ff ff       	call   c0100ce0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01032ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032b2:	e8 9f 0b 00 00       	call   c0103e56 <alloc_pages>
c01032b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01032be:	75 24                	jne    c01032e4 <basic_check+0x38e>
c01032c0:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c01032c7:	c0 
c01032c8:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01032cf:	c0 
c01032d0:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c01032d7:	00 
c01032d8:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01032df:	e8 fc d9 ff ff       	call   c0100ce0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01032e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032eb:	e8 66 0b 00 00       	call   c0103e56 <alloc_pages>
c01032f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01032f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032f7:	75 24                	jne    c010331d <basic_check+0x3c7>
c01032f9:	c7 44 24 0c 4c 68 10 	movl   $0xc010684c,0xc(%esp)
c0103300:	c0 
c0103301:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103308:	c0 
c0103309:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103310:	00 
c0103311:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103318:	e8 c3 d9 ff ff       	call   c0100ce0 <__panic>

    assert(alloc_page() == NULL);
c010331d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103324:	e8 2d 0b 00 00       	call   c0103e56 <alloc_pages>
c0103329:	85 c0                	test   %eax,%eax
c010332b:	74 24                	je     c0103351 <basic_check+0x3fb>
c010332d:	c7 44 24 0c 36 69 10 	movl   $0xc0106936,0xc(%esp)
c0103334:	c0 
c0103335:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c010333c:	c0 
c010333d:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0103344:	00 
c0103345:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c010334c:	e8 8f d9 ff ff       	call   c0100ce0 <__panic>

    free_page(p0);
c0103351:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103358:	00 
c0103359:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010335c:	89 04 24             	mov    %eax,(%esp)
c010335f:	e8 2a 0b 00 00       	call   c0103e8e <free_pages>
c0103364:	c7 45 d8 10 af 11 c0 	movl   $0xc011af10,-0x28(%ebp)
c010336b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010336e:	8b 40 04             	mov    0x4(%eax),%eax
c0103371:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103374:	0f 94 c0             	sete   %al
c0103377:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010337a:	85 c0                	test   %eax,%eax
c010337c:	74 24                	je     c01033a2 <basic_check+0x44c>
c010337e:	c7 44 24 0c 58 69 10 	movl   $0xc0106958,0xc(%esp)
c0103385:	c0 
c0103386:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c010338d:	c0 
c010338e:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0103395:	00 
c0103396:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c010339d:	e8 3e d9 ff ff       	call   c0100ce0 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01033a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033a9:	e8 a8 0a 00 00       	call   c0103e56 <alloc_pages>
c01033ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01033b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01033b7:	74 24                	je     c01033dd <basic_check+0x487>
c01033b9:	c7 44 24 0c 70 69 10 	movl   $0xc0106970,0xc(%esp)
c01033c0:	c0 
c01033c1:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01033c8:	c0 
c01033c9:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c01033d0:	00 
c01033d1:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01033d8:	e8 03 d9 ff ff       	call   c0100ce0 <__panic>
    assert(alloc_page() == NULL);
c01033dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033e4:	e8 6d 0a 00 00       	call   c0103e56 <alloc_pages>
c01033e9:	85 c0                	test   %eax,%eax
c01033eb:	74 24                	je     c0103411 <basic_check+0x4bb>
c01033ed:	c7 44 24 0c 36 69 10 	movl   $0xc0106936,0xc(%esp)
c01033f4:	c0 
c01033f5:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01033fc:	c0 
c01033fd:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c0103404:	00 
c0103405:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c010340c:	e8 cf d8 ff ff       	call   c0100ce0 <__panic>

    assert(nr_free == 0);
c0103411:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103416:	85 c0                	test   %eax,%eax
c0103418:	74 24                	je     c010343e <basic_check+0x4e8>
c010341a:	c7 44 24 0c 89 69 10 	movl   $0xc0106989,0xc(%esp)
c0103421:	c0 
c0103422:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103429:	c0 
c010342a:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103431:	00 
c0103432:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103439:	e8 a2 d8 ff ff       	call   c0100ce0 <__panic>
    free_list = free_list_store;
c010343e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103441:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103444:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c0103449:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    nr_free = nr_free_store;
c010344f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103452:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_page(p);
c0103457:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010345e:	00 
c010345f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103462:	89 04 24             	mov    %eax,(%esp)
c0103465:	e8 24 0a 00 00       	call   c0103e8e <free_pages>
    free_page(p1);
c010346a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103471:	00 
c0103472:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103475:	89 04 24             	mov    %eax,(%esp)
c0103478:	e8 11 0a 00 00       	call   c0103e8e <free_pages>
    free_page(p2);
c010347d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103484:	00 
c0103485:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103488:	89 04 24             	mov    %eax,(%esp)
c010348b:	e8 fe 09 00 00       	call   c0103e8e <free_pages>
}
c0103490:	c9                   	leave  
c0103491:	c3                   	ret    

c0103492 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103492:	55                   	push   %ebp
c0103493:	89 e5                	mov    %esp,%ebp
c0103495:	53                   	push   %ebx
c0103496:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c010349c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01034a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01034aa:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01034b1:	eb 6b                	jmp    c010351e <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01034b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034b6:	83 e8 0c             	sub    $0xc,%eax
c01034b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01034bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034bf:	83 c0 04             	add    $0x4,%eax
c01034c2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01034c9:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01034cf:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01034d2:	0f a3 10             	bt     %edx,(%eax)
c01034d5:	19 c0                	sbb    %eax,%eax
c01034d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01034da:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01034de:	0f 95 c0             	setne  %al
c01034e1:	0f b6 c0             	movzbl %al,%eax
c01034e4:	85 c0                	test   %eax,%eax
c01034e6:	75 24                	jne    c010350c <default_check+0x7a>
c01034e8:	c7 44 24 0c 96 69 10 	movl   $0xc0106996,0xc(%esp)
c01034ef:	c0 
c01034f0:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01034f7:	c0 
c01034f8:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01034ff:	00 
c0103500:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103507:	e8 d4 d7 ff ff       	call   c0100ce0 <__panic>
        count ++, total += p->property;
c010350c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103510:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103513:	8b 50 08             	mov    0x8(%eax),%edx
c0103516:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103519:	01 d0                	add    %edx,%eax
c010351b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010351e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103521:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103524:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103527:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010352a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010352d:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c0103534:	0f 85 79 ff ff ff    	jne    c01034b3 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010353a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010353d:	e8 7e 09 00 00       	call   c0103ec0 <nr_free_pages>
c0103542:	39 c3                	cmp    %eax,%ebx
c0103544:	74 24                	je     c010356a <default_check+0xd8>
c0103546:	c7 44 24 0c a6 69 10 	movl   $0xc01069a6,0xc(%esp)
c010354d:	c0 
c010354e:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103555:	c0 
c0103556:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c010355d:	00 
c010355e:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103565:	e8 76 d7 ff ff       	call   c0100ce0 <__panic>

    basic_check();
c010356a:	e8 e7 f9 ff ff       	call   c0102f56 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010356f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103576:	e8 db 08 00 00       	call   c0103e56 <alloc_pages>
c010357b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c010357e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103582:	75 24                	jne    c01035a8 <default_check+0x116>
c0103584:	c7 44 24 0c bf 69 10 	movl   $0xc01069bf,0xc(%esp)
c010358b:	c0 
c010358c:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103593:	c0 
c0103594:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c010359b:	00 
c010359c:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01035a3:	e8 38 d7 ff ff       	call   c0100ce0 <__panic>
    assert(!PageProperty(p0));
c01035a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035ab:	83 c0 04             	add    $0x4,%eax
c01035ae:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01035b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035b8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01035bb:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01035be:	0f a3 10             	bt     %edx,(%eax)
c01035c1:	19 c0                	sbb    %eax,%eax
c01035c3:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01035c6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01035ca:	0f 95 c0             	setne  %al
c01035cd:	0f b6 c0             	movzbl %al,%eax
c01035d0:	85 c0                	test   %eax,%eax
c01035d2:	74 24                	je     c01035f8 <default_check+0x166>
c01035d4:	c7 44 24 0c ca 69 10 	movl   $0xc01069ca,0xc(%esp)
c01035db:	c0 
c01035dc:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01035e3:	c0 
c01035e4:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c01035eb:	00 
c01035ec:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01035f3:	e8 e8 d6 ff ff       	call   c0100ce0 <__panic>

    list_entry_t free_list_store = free_list;
c01035f8:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c01035fd:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c0103603:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103606:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103609:	c7 45 b4 10 af 11 c0 	movl   $0xc011af10,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103610:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103613:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103616:	89 50 04             	mov    %edx,0x4(%eax)
c0103619:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010361c:	8b 50 04             	mov    0x4(%eax),%edx
c010361f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103622:	89 10                	mov    %edx,(%eax)
c0103624:	c7 45 b0 10 af 11 c0 	movl   $0xc011af10,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010362b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010362e:	8b 40 04             	mov    0x4(%eax),%eax
c0103631:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103634:	0f 94 c0             	sete   %al
c0103637:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010363a:	85 c0                	test   %eax,%eax
c010363c:	75 24                	jne    c0103662 <default_check+0x1d0>
c010363e:	c7 44 24 0c 1f 69 10 	movl   $0xc010691f,0xc(%esp)
c0103645:	c0 
c0103646:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c010364d:	c0 
c010364e:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0103655:	00 
c0103656:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c010365d:	e8 7e d6 ff ff       	call   c0100ce0 <__panic>
    assert(alloc_page() == NULL);
c0103662:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103669:	e8 e8 07 00 00       	call   c0103e56 <alloc_pages>
c010366e:	85 c0                	test   %eax,%eax
c0103670:	74 24                	je     c0103696 <default_check+0x204>
c0103672:	c7 44 24 0c 36 69 10 	movl   $0xc0106936,0xc(%esp)
c0103679:	c0 
c010367a:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103681:	c0 
c0103682:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0103689:	00 
c010368a:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103691:	e8 4a d6 ff ff       	call   c0100ce0 <__panic>

    unsigned int nr_free_store = nr_free;
c0103696:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c010369b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010369e:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c01036a5:	00 00 00 

    free_pages(p0 + 2, 3);
c01036a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036ab:	83 c0 28             	add    $0x28,%eax
c01036ae:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01036b5:	00 
c01036b6:	89 04 24             	mov    %eax,(%esp)
c01036b9:	e8 d0 07 00 00       	call   c0103e8e <free_pages>
    assert(alloc_pages(4) == NULL);
c01036be:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01036c5:	e8 8c 07 00 00       	call   c0103e56 <alloc_pages>
c01036ca:	85 c0                	test   %eax,%eax
c01036cc:	74 24                	je     c01036f2 <default_check+0x260>
c01036ce:	c7 44 24 0c dc 69 10 	movl   $0xc01069dc,0xc(%esp)
c01036d5:	c0 
c01036d6:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01036dd:	c0 
c01036de:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c01036e5:	00 
c01036e6:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01036ed:	e8 ee d5 ff ff       	call   c0100ce0 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01036f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036f5:	83 c0 28             	add    $0x28,%eax
c01036f8:	83 c0 04             	add    $0x4,%eax
c01036fb:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103702:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103705:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103708:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010370b:	0f a3 10             	bt     %edx,(%eax)
c010370e:	19 c0                	sbb    %eax,%eax
c0103710:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103713:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103717:	0f 95 c0             	setne  %al
c010371a:	0f b6 c0             	movzbl %al,%eax
c010371d:	85 c0                	test   %eax,%eax
c010371f:	74 0e                	je     c010372f <default_check+0x29d>
c0103721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103724:	83 c0 28             	add    $0x28,%eax
c0103727:	8b 40 08             	mov    0x8(%eax),%eax
c010372a:	83 f8 03             	cmp    $0x3,%eax
c010372d:	74 24                	je     c0103753 <default_check+0x2c1>
c010372f:	c7 44 24 0c f4 69 10 	movl   $0xc01069f4,0xc(%esp)
c0103736:	c0 
c0103737:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c010373e:	c0 
c010373f:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0103746:	00 
c0103747:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c010374e:	e8 8d d5 ff ff       	call   c0100ce0 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103753:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010375a:	e8 f7 06 00 00       	call   c0103e56 <alloc_pages>
c010375f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103762:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103766:	75 24                	jne    c010378c <default_check+0x2fa>
c0103768:	c7 44 24 0c 20 6a 10 	movl   $0xc0106a20,0xc(%esp)
c010376f:	c0 
c0103770:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103777:	c0 
c0103778:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c010377f:	00 
c0103780:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103787:	e8 54 d5 ff ff       	call   c0100ce0 <__panic>
    assert(alloc_page() == NULL);
c010378c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103793:	e8 be 06 00 00       	call   c0103e56 <alloc_pages>
c0103798:	85 c0                	test   %eax,%eax
c010379a:	74 24                	je     c01037c0 <default_check+0x32e>
c010379c:	c7 44 24 0c 36 69 10 	movl   $0xc0106936,0xc(%esp)
c01037a3:	c0 
c01037a4:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01037ab:	c0 
c01037ac:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c01037b3:	00 
c01037b4:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01037bb:	e8 20 d5 ff ff       	call   c0100ce0 <__panic>
    assert(p0 + 2 == p1);
c01037c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037c3:	83 c0 28             	add    $0x28,%eax
c01037c6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01037c9:	74 24                	je     c01037ef <default_check+0x35d>
c01037cb:	c7 44 24 0c 3e 6a 10 	movl   $0xc0106a3e,0xc(%esp)
c01037d2:	c0 
c01037d3:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01037da:	c0 
c01037db:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c01037e2:	00 
c01037e3:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01037ea:	e8 f1 d4 ff ff       	call   c0100ce0 <__panic>

    p2 = p0 + 1;
c01037ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037f2:	83 c0 14             	add    $0x14,%eax
c01037f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01037f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037ff:	00 
c0103800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103803:	89 04 24             	mov    %eax,(%esp)
c0103806:	e8 83 06 00 00       	call   c0103e8e <free_pages>
    free_pages(p1, 3);
c010380b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103812:	00 
c0103813:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103816:	89 04 24             	mov    %eax,(%esp)
c0103819:	e8 70 06 00 00       	call   c0103e8e <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010381e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103821:	83 c0 04             	add    $0x4,%eax
c0103824:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010382b:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010382e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103831:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103834:	0f a3 10             	bt     %edx,(%eax)
c0103837:	19 c0                	sbb    %eax,%eax
c0103839:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010383c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103840:	0f 95 c0             	setne  %al
c0103843:	0f b6 c0             	movzbl %al,%eax
c0103846:	85 c0                	test   %eax,%eax
c0103848:	74 0b                	je     c0103855 <default_check+0x3c3>
c010384a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010384d:	8b 40 08             	mov    0x8(%eax),%eax
c0103850:	83 f8 01             	cmp    $0x1,%eax
c0103853:	74 24                	je     c0103879 <default_check+0x3e7>
c0103855:	c7 44 24 0c 4c 6a 10 	movl   $0xc0106a4c,0xc(%esp)
c010385c:	c0 
c010385d:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103864:	c0 
c0103865:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c010386c:	00 
c010386d:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103874:	e8 67 d4 ff ff       	call   c0100ce0 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103879:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010387c:	83 c0 04             	add    $0x4,%eax
c010387f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103886:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103889:	8b 45 90             	mov    -0x70(%ebp),%eax
c010388c:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010388f:	0f a3 10             	bt     %edx,(%eax)
c0103892:	19 c0                	sbb    %eax,%eax
c0103894:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103897:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010389b:	0f 95 c0             	setne  %al
c010389e:	0f b6 c0             	movzbl %al,%eax
c01038a1:	85 c0                	test   %eax,%eax
c01038a3:	74 0b                	je     c01038b0 <default_check+0x41e>
c01038a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01038a8:	8b 40 08             	mov    0x8(%eax),%eax
c01038ab:	83 f8 03             	cmp    $0x3,%eax
c01038ae:	74 24                	je     c01038d4 <default_check+0x442>
c01038b0:	c7 44 24 0c 74 6a 10 	movl   $0xc0106a74,0xc(%esp)
c01038b7:	c0 
c01038b8:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01038bf:	c0 
c01038c0:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c01038c7:	00 
c01038c8:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01038cf:	e8 0c d4 ff ff       	call   c0100ce0 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01038d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038db:	e8 76 05 00 00       	call   c0103e56 <alloc_pages>
c01038e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038e6:	83 e8 14             	sub    $0x14,%eax
c01038e9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01038ec:	74 24                	je     c0103912 <default_check+0x480>
c01038ee:	c7 44 24 0c 9a 6a 10 	movl   $0xc0106a9a,0xc(%esp)
c01038f5:	c0 
c01038f6:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01038fd:	c0 
c01038fe:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0103905:	00 
c0103906:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c010390d:	e8 ce d3 ff ff       	call   c0100ce0 <__panic>
    free_page(p0);
c0103912:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103919:	00 
c010391a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010391d:	89 04 24             	mov    %eax,(%esp)
c0103920:	e8 69 05 00 00       	call   c0103e8e <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103925:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010392c:	e8 25 05 00 00       	call   c0103e56 <alloc_pages>
c0103931:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103934:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103937:	83 c0 14             	add    $0x14,%eax
c010393a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010393d:	74 24                	je     c0103963 <default_check+0x4d1>
c010393f:	c7 44 24 0c b8 6a 10 	movl   $0xc0106ab8,0xc(%esp)
c0103946:	c0 
c0103947:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c010394e:	c0 
c010394f:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0103956:	00 
c0103957:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c010395e:	e8 7d d3 ff ff       	call   c0100ce0 <__panic>

    free_pages(p0, 2);
c0103963:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010396a:	00 
c010396b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010396e:	89 04 24             	mov    %eax,(%esp)
c0103971:	e8 18 05 00 00       	call   c0103e8e <free_pages>
    free_page(p2);
c0103976:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010397d:	00 
c010397e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103981:	89 04 24             	mov    %eax,(%esp)
c0103984:	e8 05 05 00 00       	call   c0103e8e <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103989:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103990:	e8 c1 04 00 00       	call   c0103e56 <alloc_pages>
c0103995:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103998:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010399c:	75 24                	jne    c01039c2 <default_check+0x530>
c010399e:	c7 44 24 0c d8 6a 10 	movl   $0xc0106ad8,0xc(%esp)
c01039a5:	c0 
c01039a6:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01039ad:	c0 
c01039ae:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c01039b5:	00 
c01039b6:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01039bd:	e8 1e d3 ff ff       	call   c0100ce0 <__panic>
    assert(alloc_page() == NULL);
c01039c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039c9:	e8 88 04 00 00       	call   c0103e56 <alloc_pages>
c01039ce:	85 c0                	test   %eax,%eax
c01039d0:	74 24                	je     c01039f6 <default_check+0x564>
c01039d2:	c7 44 24 0c 36 69 10 	movl   $0xc0106936,0xc(%esp)
c01039d9:	c0 
c01039da:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c01039e1:	c0 
c01039e2:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c01039e9:	00 
c01039ea:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c01039f1:	e8 ea d2 ff ff       	call   c0100ce0 <__panic>

    assert(nr_free == 0);
c01039f6:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c01039fb:	85 c0                	test   %eax,%eax
c01039fd:	74 24                	je     c0103a23 <default_check+0x591>
c01039ff:	c7 44 24 0c 89 69 10 	movl   $0xc0106989,0xc(%esp)
c0103a06:	c0 
c0103a07:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103a0e:	c0 
c0103a0f:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c0103a16:	00 
c0103a17:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103a1e:	e8 bd d2 ff ff       	call   c0100ce0 <__panic>
    nr_free = nr_free_store;
c0103a23:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a26:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_list = free_list_store;
c0103a2b:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103a2e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103a31:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c0103a36:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    free_pages(p0, 5);
c0103a3c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103a43:	00 
c0103a44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a47:	89 04 24             	mov    %eax,(%esp)
c0103a4a:	e8 3f 04 00 00       	call   c0103e8e <free_pages>

    le = &free_list;
c0103a4f:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103a56:	eb 5b                	jmp    c0103ab3 <default_check+0x621>
        assert(le->next->prev == le && le->prev->next == le);
c0103a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a5b:	8b 40 04             	mov    0x4(%eax),%eax
c0103a5e:	8b 00                	mov    (%eax),%eax
c0103a60:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103a63:	75 0d                	jne    c0103a72 <default_check+0x5e0>
c0103a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a68:	8b 00                	mov    (%eax),%eax
c0103a6a:	8b 40 04             	mov    0x4(%eax),%eax
c0103a6d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103a70:	74 24                	je     c0103a96 <default_check+0x604>
c0103a72:	c7 44 24 0c f8 6a 10 	movl   $0xc0106af8,0xc(%esp)
c0103a79:	c0 
c0103a7a:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103a81:	c0 
c0103a82:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
c0103a89:	00 
c0103a8a:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103a91:	e8 4a d2 ff ff       	call   c0100ce0 <__panic>
        struct Page *p = le2page(le, page_link);
c0103a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a99:	83 e8 0c             	sub    $0xc,%eax
c0103a9c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103a9f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103aa3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103aa6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103aa9:	8b 40 08             	mov    0x8(%eax),%eax
c0103aac:	29 c2                	sub    %eax,%edx
c0103aae:	89 d0                	mov    %edx,%eax
c0103ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ab6:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103ab9:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103abc:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103abf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103ac2:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c0103ac9:	75 8d                	jne    c0103a58 <default_check+0x5c6>
        assert(le->next->prev == le && le->prev->next == le);
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103acb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103acf:	74 24                	je     c0103af5 <default_check+0x663>
c0103ad1:	c7 44 24 0c 25 6b 10 	movl   $0xc0106b25,0xc(%esp)
c0103ad8:	c0 
c0103ad9:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103ae0:	c0 
c0103ae1:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
c0103ae8:	00 
c0103ae9:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103af0:	e8 eb d1 ff ff       	call   c0100ce0 <__panic>
    assert(total == 0);
c0103af5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103af9:	74 24                	je     c0103b1f <default_check+0x68d>
c0103afb:	c7 44 24 0c 30 6b 10 	movl   $0xc0106b30,0xc(%esp)
c0103b02:	c0 
c0103b03:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0103b0a:	c0 
c0103b0b:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
c0103b12:	00 
c0103b13:	c7 04 24 ab 67 10 c0 	movl   $0xc01067ab,(%esp)
c0103b1a:	e8 c1 d1 ff ff       	call   c0100ce0 <__panic>
}
c0103b1f:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103b25:	5b                   	pop    %ebx
c0103b26:	5d                   	pop    %ebp
c0103b27:	c3                   	ret    

c0103b28 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103b28:	55                   	push   %ebp
c0103b29:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103b2b:	8b 55 08             	mov    0x8(%ebp),%edx
c0103b2e:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0103b33:	29 c2                	sub    %eax,%edx
c0103b35:	89 d0                	mov    %edx,%eax
c0103b37:	c1 f8 02             	sar    $0x2,%eax
c0103b3a:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103b40:	5d                   	pop    %ebp
c0103b41:	c3                   	ret    

c0103b42 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103b42:	55                   	push   %ebp
c0103b43:	89 e5                	mov    %esp,%ebp
c0103b45:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b4b:	89 04 24             	mov    %eax,(%esp)
c0103b4e:	e8 d5 ff ff ff       	call   c0103b28 <page2ppn>
c0103b53:	c1 e0 0c             	shl    $0xc,%eax
}
c0103b56:	c9                   	leave  
c0103b57:	c3                   	ret    

c0103b58 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103b58:	55                   	push   %ebp
c0103b59:	89 e5                	mov    %esp,%ebp
c0103b5b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b61:	c1 e8 0c             	shr    $0xc,%eax
c0103b64:	89 c2                	mov    %eax,%edx
c0103b66:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103b6b:	39 c2                	cmp    %eax,%edx
c0103b6d:	72 1c                	jb     c0103b8b <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103b6f:	c7 44 24 08 6c 6b 10 	movl   $0xc0106b6c,0x8(%esp)
c0103b76:	c0 
c0103b77:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103b7e:	00 
c0103b7f:	c7 04 24 8b 6b 10 c0 	movl   $0xc0106b8b,(%esp)
c0103b86:	e8 55 d1 ff ff       	call   c0100ce0 <__panic>
    }
    return &pages[PPN(pa)];
c0103b8b:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c0103b91:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b94:	c1 e8 0c             	shr    $0xc,%eax
c0103b97:	89 c2                	mov    %eax,%edx
c0103b99:	89 d0                	mov    %edx,%eax
c0103b9b:	c1 e0 02             	shl    $0x2,%eax
c0103b9e:	01 d0                	add    %edx,%eax
c0103ba0:	c1 e0 02             	shl    $0x2,%eax
c0103ba3:	01 c8                	add    %ecx,%eax
}
c0103ba5:	c9                   	leave  
c0103ba6:	c3                   	ret    

c0103ba7 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103ba7:	55                   	push   %ebp
c0103ba8:	89 e5                	mov    %esp,%ebp
c0103baa:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bb0:	89 04 24             	mov    %eax,(%esp)
c0103bb3:	e8 8a ff ff ff       	call   c0103b42 <page2pa>
c0103bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bbe:	c1 e8 0c             	shr    $0xc,%eax
c0103bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bc4:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103bc9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103bcc:	72 23                	jb     c0103bf1 <page2kva+0x4a>
c0103bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bd1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103bd5:	c7 44 24 08 9c 6b 10 	movl   $0xc0106b9c,0x8(%esp)
c0103bdc:	c0 
c0103bdd:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103be4:	00 
c0103be5:	c7 04 24 8b 6b 10 c0 	movl   $0xc0106b8b,(%esp)
c0103bec:	e8 ef d0 ff ff       	call   c0100ce0 <__panic>
c0103bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bf4:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103bf9:	c9                   	leave  
c0103bfa:	c3                   	ret    

c0103bfb <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103bfb:	55                   	push   %ebp
c0103bfc:	89 e5                	mov    %esp,%ebp
c0103bfe:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103c01:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c04:	83 e0 01             	and    $0x1,%eax
c0103c07:	85 c0                	test   %eax,%eax
c0103c09:	75 1c                	jne    c0103c27 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103c0b:	c7 44 24 08 c0 6b 10 	movl   $0xc0106bc0,0x8(%esp)
c0103c12:	c0 
c0103c13:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103c1a:	00 
c0103c1b:	c7 04 24 8b 6b 10 c0 	movl   $0xc0106b8b,(%esp)
c0103c22:	e8 b9 d0 ff ff       	call   c0100ce0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103c27:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c2a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c2f:	89 04 24             	mov    %eax,(%esp)
c0103c32:	e8 21 ff ff ff       	call   c0103b58 <pa2page>
}
c0103c37:	c9                   	leave  
c0103c38:	c3                   	ret    

c0103c39 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103c39:	55                   	push   %ebp
c0103c3a:	89 e5                	mov    %esp,%ebp
c0103c3c:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c47:	89 04 24             	mov    %eax,(%esp)
c0103c4a:	e8 09 ff ff ff       	call   c0103b58 <pa2page>
}
c0103c4f:	c9                   	leave  
c0103c50:	c3                   	ret    

c0103c51 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103c51:	55                   	push   %ebp
c0103c52:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103c54:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c57:	8b 00                	mov    (%eax),%eax
}
c0103c59:	5d                   	pop    %ebp
c0103c5a:	c3                   	ret    

c0103c5b <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103c5b:	55                   	push   %ebp
c0103c5c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103c5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c61:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c64:	89 10                	mov    %edx,(%eax)
}
c0103c66:	5d                   	pop    %ebp
c0103c67:	c3                   	ret    

c0103c68 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103c68:	55                   	push   %ebp
c0103c69:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c6e:	8b 00                	mov    (%eax),%eax
c0103c70:	8d 50 01             	lea    0x1(%eax),%edx
c0103c73:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c76:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c7b:	8b 00                	mov    (%eax),%eax
}
c0103c7d:	5d                   	pop    %ebp
c0103c7e:	c3                   	ret    

c0103c7f <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103c7f:	55                   	push   %ebp
c0103c80:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103c82:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c85:	8b 00                	mov    (%eax),%eax
c0103c87:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103c8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c8d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103c8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c92:	8b 00                	mov    (%eax),%eax
}
c0103c94:	5d                   	pop    %ebp
c0103c95:	c3                   	ret    

c0103c96 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103c96:	55                   	push   %ebp
c0103c97:	89 e5                	mov    %esp,%ebp
c0103c99:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103c9c:	9c                   	pushf  
c0103c9d:	58                   	pop    %eax
c0103c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103ca4:	25 00 02 00 00       	and    $0x200,%eax
c0103ca9:	85 c0                	test   %eax,%eax
c0103cab:	74 0c                	je     c0103cb9 <__intr_save+0x23>
        intr_disable();
c0103cad:	e8 22 da ff ff       	call   c01016d4 <intr_disable>
        return 1;
c0103cb2:	b8 01 00 00 00       	mov    $0x1,%eax
c0103cb7:	eb 05                	jmp    c0103cbe <__intr_save+0x28>
    }
    return 0;
c0103cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103cbe:	c9                   	leave  
c0103cbf:	c3                   	ret    

c0103cc0 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103cc0:	55                   	push   %ebp
c0103cc1:	89 e5                	mov    %esp,%ebp
c0103cc3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103cc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103cca:	74 05                	je     c0103cd1 <__intr_restore+0x11>
        intr_enable();
c0103ccc:	e8 fd d9 ff ff       	call   c01016ce <intr_enable>
    }
}
c0103cd1:	c9                   	leave  
c0103cd2:	c3                   	ret    

c0103cd3 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103cd3:	55                   	push   %ebp
c0103cd4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103cd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cd9:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103cdc:	b8 23 00 00 00       	mov    $0x23,%eax
c0103ce1:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103ce3:	b8 23 00 00 00       	mov    $0x23,%eax
c0103ce8:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103cea:	b8 10 00 00 00       	mov    $0x10,%eax
c0103cef:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103cf1:	b8 10 00 00 00       	mov    $0x10,%eax
c0103cf6:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103cf8:	b8 10 00 00 00       	mov    $0x10,%eax
c0103cfd:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103cff:	ea 06 3d 10 c0 08 00 	ljmp   $0x8,$0xc0103d06
}
c0103d06:	5d                   	pop    %ebp
c0103d07:	c3                   	ret    

c0103d08 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103d08:	55                   	push   %ebp
c0103d09:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103d0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d0e:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c0103d13:	5d                   	pop    %ebp
c0103d14:	c3                   	ret    

c0103d15 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103d15:	55                   	push   %ebp
c0103d16:	89 e5                	mov    %esp,%ebp
c0103d18:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103d1b:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103d20:	89 04 24             	mov    %eax,(%esp)
c0103d23:	e8 e0 ff ff ff       	call   c0103d08 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103d28:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c0103d2f:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103d31:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103d38:	68 00 
c0103d3a:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103d3f:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103d45:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103d4a:	c1 e8 10             	shr    $0x10,%eax
c0103d4d:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103d52:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103d59:	83 e0 f0             	and    $0xfffffff0,%eax
c0103d5c:	83 c8 09             	or     $0x9,%eax
c0103d5f:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103d64:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103d6b:	83 e0 ef             	and    $0xffffffef,%eax
c0103d6e:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103d73:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103d7a:	83 e0 9f             	and    $0xffffff9f,%eax
c0103d7d:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103d82:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103d89:	83 c8 80             	or     $0xffffff80,%eax
c0103d8c:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103d91:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103d98:	83 e0 f0             	and    $0xfffffff0,%eax
c0103d9b:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103da0:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103da7:	83 e0 ef             	and    $0xffffffef,%eax
c0103daa:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103daf:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103db6:	83 e0 df             	and    $0xffffffdf,%eax
c0103db9:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103dbe:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103dc5:	83 c8 40             	or     $0x40,%eax
c0103dc8:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103dcd:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103dd4:	83 e0 7f             	and    $0x7f,%eax
c0103dd7:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ddc:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103de1:	c1 e8 18             	shr    $0x18,%eax
c0103de4:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103de9:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103df0:	e8 de fe ff ff       	call   c0103cd3 <lgdt>
c0103df5:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103dfb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103dff:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103e02:	c9                   	leave  
c0103e03:	c3                   	ret    

c0103e04 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103e04:	55                   	push   %ebp
c0103e05:	89 e5                	mov    %esp,%ebp
c0103e07:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103e0a:	c7 05 1c af 11 c0 50 	movl   $0xc0106b50,0xc011af1c
c0103e11:	6b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103e14:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103e19:	8b 00                	mov    (%eax),%eax
c0103e1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103e1f:	c7 04 24 ec 6b 10 c0 	movl   $0xc0106bec,(%esp)
c0103e26:	e8 1d c5 ff ff       	call   c0100348 <cprintf>
    pmm_manager->init();
c0103e2b:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103e30:	8b 40 04             	mov    0x4(%eax),%eax
c0103e33:	ff d0                	call   *%eax
}
c0103e35:	c9                   	leave  
c0103e36:	c3                   	ret    

c0103e37 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103e37:	55                   	push   %ebp
c0103e38:	89 e5                	mov    %esp,%ebp
c0103e3a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103e3d:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103e42:	8b 40 08             	mov    0x8(%eax),%eax
c0103e45:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103e48:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e4c:	8b 55 08             	mov    0x8(%ebp),%edx
c0103e4f:	89 14 24             	mov    %edx,(%esp)
c0103e52:	ff d0                	call   *%eax
}
c0103e54:	c9                   	leave  
c0103e55:	c3                   	ret    

c0103e56 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103e56:	55                   	push   %ebp
c0103e57:	89 e5                	mov    %esp,%ebp
c0103e59:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103e5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103e63:	e8 2e fe ff ff       	call   c0103c96 <__intr_save>
c0103e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103e6b:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103e70:	8b 40 0c             	mov    0xc(%eax),%eax
c0103e73:	8b 55 08             	mov    0x8(%ebp),%edx
c0103e76:	89 14 24             	mov    %edx,(%esp)
c0103e79:	ff d0                	call   *%eax
c0103e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e81:	89 04 24             	mov    %eax,(%esp)
c0103e84:	e8 37 fe ff ff       	call   c0103cc0 <__intr_restore>
    return page;
c0103e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103e8c:	c9                   	leave  
c0103e8d:	c3                   	ret    

c0103e8e <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103e8e:	55                   	push   %ebp
c0103e8f:	89 e5                	mov    %esp,%ebp
c0103e91:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103e94:	e8 fd fd ff ff       	call   c0103c96 <__intr_save>
c0103e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103e9c:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103ea1:	8b 40 10             	mov    0x10(%eax),%eax
c0103ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ea7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103eab:	8b 55 08             	mov    0x8(%ebp),%edx
c0103eae:	89 14 24             	mov    %edx,(%esp)
c0103eb1:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103eb6:	89 04 24             	mov    %eax,(%esp)
c0103eb9:	e8 02 fe ff ff       	call   c0103cc0 <__intr_restore>
}
c0103ebe:	c9                   	leave  
c0103ebf:	c3                   	ret    

c0103ec0 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103ec0:	55                   	push   %ebp
c0103ec1:	89 e5                	mov    %esp,%ebp
c0103ec3:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103ec6:	e8 cb fd ff ff       	call   c0103c96 <__intr_save>
c0103ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103ece:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103ed3:	8b 40 14             	mov    0x14(%eax),%eax
c0103ed6:	ff d0                	call   *%eax
c0103ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ede:	89 04 24             	mov    %eax,(%esp)
c0103ee1:	e8 da fd ff ff       	call   c0103cc0 <__intr_restore>
    return ret;
c0103ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103ee9:	c9                   	leave  
c0103eea:	c3                   	ret    

c0103eeb <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103eeb:	55                   	push   %ebp
c0103eec:	89 e5                	mov    %esp,%ebp
c0103eee:	57                   	push   %edi
c0103eef:	56                   	push   %esi
c0103ef0:	53                   	push   %ebx
c0103ef1:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103ef7:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103efe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103f05:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103f0c:	c7 04 24 03 6c 10 c0 	movl   $0xc0106c03,(%esp)
c0103f13:	e8 30 c4 ff ff       	call   c0100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103f18:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f1f:	e9 15 01 00 00       	jmp    c0104039 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103f24:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f27:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f2a:	89 d0                	mov    %edx,%eax
c0103f2c:	c1 e0 02             	shl    $0x2,%eax
c0103f2f:	01 d0                	add    %edx,%eax
c0103f31:	c1 e0 02             	shl    $0x2,%eax
c0103f34:	01 c8                	add    %ecx,%eax
c0103f36:	8b 50 08             	mov    0x8(%eax),%edx
c0103f39:	8b 40 04             	mov    0x4(%eax),%eax
c0103f3c:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103f3f:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103f42:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f45:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f48:	89 d0                	mov    %edx,%eax
c0103f4a:	c1 e0 02             	shl    $0x2,%eax
c0103f4d:	01 d0                	add    %edx,%eax
c0103f4f:	c1 e0 02             	shl    $0x2,%eax
c0103f52:	01 c8                	add    %ecx,%eax
c0103f54:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103f57:	8b 58 10             	mov    0x10(%eax),%ebx
c0103f5a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103f5d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103f60:	01 c8                	add    %ecx,%eax
c0103f62:	11 da                	adc    %ebx,%edx
c0103f64:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103f67:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103f6a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f70:	89 d0                	mov    %edx,%eax
c0103f72:	c1 e0 02             	shl    $0x2,%eax
c0103f75:	01 d0                	add    %edx,%eax
c0103f77:	c1 e0 02             	shl    $0x2,%eax
c0103f7a:	01 c8                	add    %ecx,%eax
c0103f7c:	83 c0 14             	add    $0x14,%eax
c0103f7f:	8b 00                	mov    (%eax),%eax
c0103f81:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103f87:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f8a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f8d:	83 c0 ff             	add    $0xffffffff,%eax
c0103f90:	83 d2 ff             	adc    $0xffffffff,%edx
c0103f93:	89 c6                	mov    %eax,%esi
c0103f95:	89 d7                	mov    %edx,%edi
c0103f97:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f9d:	89 d0                	mov    %edx,%eax
c0103f9f:	c1 e0 02             	shl    $0x2,%eax
c0103fa2:	01 d0                	add    %edx,%eax
c0103fa4:	c1 e0 02             	shl    $0x2,%eax
c0103fa7:	01 c8                	add    %ecx,%eax
c0103fa9:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103fac:	8b 58 10             	mov    0x10(%eax),%ebx
c0103faf:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103fb5:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103fb9:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103fbd:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103fc1:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103fc4:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103fc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103fcb:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103fcf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103fd3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103fd7:	c7 04 24 10 6c 10 c0 	movl   $0xc0106c10,(%esp)
c0103fde:	e8 65 c3 ff ff       	call   c0100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103fe3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fe6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fe9:	89 d0                	mov    %edx,%eax
c0103feb:	c1 e0 02             	shl    $0x2,%eax
c0103fee:	01 d0                	add    %edx,%eax
c0103ff0:	c1 e0 02             	shl    $0x2,%eax
c0103ff3:	01 c8                	add    %ecx,%eax
c0103ff5:	83 c0 14             	add    $0x14,%eax
c0103ff8:	8b 00                	mov    (%eax),%eax
c0103ffa:	83 f8 01             	cmp    $0x1,%eax
c0103ffd:	75 36                	jne    c0104035 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103fff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104002:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104005:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104008:	77 2b                	ja     c0104035 <page_init+0x14a>
c010400a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010400d:	72 05                	jb     c0104014 <page_init+0x129>
c010400f:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104012:	73 21                	jae    c0104035 <page_init+0x14a>
c0104014:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104018:	77 1b                	ja     c0104035 <page_init+0x14a>
c010401a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010401e:	72 09                	jb     c0104029 <page_init+0x13e>
c0104020:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104027:	77 0c                	ja     c0104035 <page_init+0x14a>
                maxpa = end;
c0104029:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010402c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010402f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104032:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104035:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104039:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010403c:	8b 00                	mov    (%eax),%eax
c010403e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104041:	0f 8f dd fe ff ff    	jg     c0103f24 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104047:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010404b:	72 1d                	jb     c010406a <page_init+0x17f>
c010404d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104051:	77 09                	ja     c010405c <page_init+0x171>
c0104053:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c010405a:	76 0e                	jbe    c010406a <page_init+0x17f>
        maxpa = KMEMSIZE;
c010405c:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104063:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010406a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010406d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104070:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104074:	c1 ea 0c             	shr    $0xc,%edx
c0104077:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010407c:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104083:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c0104088:	8d 50 ff             	lea    -0x1(%eax),%edx
c010408b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010408e:	01 d0                	add    %edx,%eax
c0104090:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104093:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104096:	ba 00 00 00 00       	mov    $0x0,%edx
c010409b:	f7 75 ac             	divl   -0x54(%ebp)
c010409e:	89 d0                	mov    %edx,%eax
c01040a0:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01040a3:	29 c2                	sub    %eax,%edx
c01040a5:	89 d0                	mov    %edx,%eax
c01040a7:	a3 24 af 11 c0       	mov    %eax,0xc011af24

    for (i = 0; i < npage; i ++) {
c01040ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01040b3:	eb 2f                	jmp    c01040e4 <page_init+0x1f9>
        SetPageReserved(pages + i);
c01040b5:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c01040bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040be:	89 d0                	mov    %edx,%eax
c01040c0:	c1 e0 02             	shl    $0x2,%eax
c01040c3:	01 d0                	add    %edx,%eax
c01040c5:	c1 e0 02             	shl    $0x2,%eax
c01040c8:	01 c8                	add    %ecx,%eax
c01040ca:	83 c0 04             	add    $0x4,%eax
c01040cd:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01040d4:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01040d7:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01040da:	8b 55 90             	mov    -0x70(%ebp),%edx
c01040dd:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01040e0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01040e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040e7:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01040ec:	39 c2                	cmp    %eax,%edx
c01040ee:	72 c5                	jb     c01040b5 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01040f0:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c01040f6:	89 d0                	mov    %edx,%eax
c01040f8:	c1 e0 02             	shl    $0x2,%eax
c01040fb:	01 d0                	add    %edx,%eax
c01040fd:	c1 e0 02             	shl    $0x2,%eax
c0104100:	89 c2                	mov    %eax,%edx
c0104102:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104107:	01 d0                	add    %edx,%eax
c0104109:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010410c:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104113:	77 23                	ja     c0104138 <page_init+0x24d>
c0104115:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104118:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010411c:	c7 44 24 08 40 6c 10 	movl   $0xc0106c40,0x8(%esp)
c0104123:	c0 
c0104124:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010412b:	00 
c010412c:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104133:	e8 a8 cb ff ff       	call   c0100ce0 <__panic>
c0104138:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010413b:	05 00 00 00 40       	add    $0x40000000,%eax
c0104140:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104143:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010414a:	e9 74 01 00 00       	jmp    c01042c3 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010414f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104152:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104155:	89 d0                	mov    %edx,%eax
c0104157:	c1 e0 02             	shl    $0x2,%eax
c010415a:	01 d0                	add    %edx,%eax
c010415c:	c1 e0 02             	shl    $0x2,%eax
c010415f:	01 c8                	add    %ecx,%eax
c0104161:	8b 50 08             	mov    0x8(%eax),%edx
c0104164:	8b 40 04             	mov    0x4(%eax),%eax
c0104167:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010416a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010416d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104170:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104173:	89 d0                	mov    %edx,%eax
c0104175:	c1 e0 02             	shl    $0x2,%eax
c0104178:	01 d0                	add    %edx,%eax
c010417a:	c1 e0 02             	shl    $0x2,%eax
c010417d:	01 c8                	add    %ecx,%eax
c010417f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104182:	8b 58 10             	mov    0x10(%eax),%ebx
c0104185:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104188:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010418b:	01 c8                	add    %ecx,%eax
c010418d:	11 da                	adc    %ebx,%edx
c010418f:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104192:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104195:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104198:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010419b:	89 d0                	mov    %edx,%eax
c010419d:	c1 e0 02             	shl    $0x2,%eax
c01041a0:	01 d0                	add    %edx,%eax
c01041a2:	c1 e0 02             	shl    $0x2,%eax
c01041a5:	01 c8                	add    %ecx,%eax
c01041a7:	83 c0 14             	add    $0x14,%eax
c01041aa:	8b 00                	mov    (%eax),%eax
c01041ac:	83 f8 01             	cmp    $0x1,%eax
c01041af:	0f 85 0a 01 00 00    	jne    c01042bf <page_init+0x3d4>
            if (begin < freemem) {
c01041b5:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01041b8:	ba 00 00 00 00       	mov    $0x0,%edx
c01041bd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01041c0:	72 17                	jb     c01041d9 <page_init+0x2ee>
c01041c2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01041c5:	77 05                	ja     c01041cc <page_init+0x2e1>
c01041c7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01041ca:	76 0d                	jbe    c01041d9 <page_init+0x2ee>
                begin = freemem;
c01041cc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01041cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01041d2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01041d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01041dd:	72 1d                	jb     c01041fc <page_init+0x311>
c01041df:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01041e3:	77 09                	ja     c01041ee <page_init+0x303>
c01041e5:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01041ec:	76 0e                	jbe    c01041fc <page_init+0x311>
                end = KMEMSIZE;
c01041ee:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01041f5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01041fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104202:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104205:	0f 87 b4 00 00 00    	ja     c01042bf <page_init+0x3d4>
c010420b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010420e:	72 09                	jb     c0104219 <page_init+0x32e>
c0104210:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104213:	0f 83 a6 00 00 00    	jae    c01042bf <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104219:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104220:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104223:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104226:	01 d0                	add    %edx,%eax
c0104228:	83 e8 01             	sub    $0x1,%eax
c010422b:	89 45 98             	mov    %eax,-0x68(%ebp)
c010422e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104231:	ba 00 00 00 00       	mov    $0x0,%edx
c0104236:	f7 75 9c             	divl   -0x64(%ebp)
c0104239:	89 d0                	mov    %edx,%eax
c010423b:	8b 55 98             	mov    -0x68(%ebp),%edx
c010423e:	29 c2                	sub    %eax,%edx
c0104240:	89 d0                	mov    %edx,%eax
c0104242:	ba 00 00 00 00       	mov    $0x0,%edx
c0104247:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010424a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010424d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104250:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104253:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104256:	ba 00 00 00 00       	mov    $0x0,%edx
c010425b:	89 c7                	mov    %eax,%edi
c010425d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104263:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104266:	89 d0                	mov    %edx,%eax
c0104268:	83 e0 00             	and    $0x0,%eax
c010426b:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010426e:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104271:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104274:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104277:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c010427a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010427d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104280:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104283:	77 3a                	ja     c01042bf <page_init+0x3d4>
c0104285:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104288:	72 05                	jb     c010428f <page_init+0x3a4>
c010428a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010428d:	73 30                	jae    c01042bf <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010428f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104292:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104295:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104298:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010429b:	29 c8                	sub    %ecx,%eax
c010429d:	19 da                	sbb    %ebx,%edx
c010429f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01042a3:	c1 ea 0c             	shr    $0xc,%edx
c01042a6:	89 c3                	mov    %eax,%ebx
c01042a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042ab:	89 04 24             	mov    %eax,(%esp)
c01042ae:	e8 a5 f8 ff ff       	call   c0103b58 <pa2page>
c01042b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01042b7:	89 04 24             	mov    %eax,(%esp)
c01042ba:	e8 78 fb ff ff       	call   c0103e37 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01042bf:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01042c3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01042c6:	8b 00                	mov    (%eax),%eax
c01042c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01042cb:	0f 8f 7e fe ff ff    	jg     c010414f <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01042d1:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01042d7:	5b                   	pop    %ebx
c01042d8:	5e                   	pop    %esi
c01042d9:	5f                   	pop    %edi
c01042da:	5d                   	pop    %ebp
c01042db:	c3                   	ret    

c01042dc <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01042dc:	55                   	push   %ebp
c01042dd:	89 e5                	mov    %esp,%ebp
c01042df:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01042e2:	8b 45 14             	mov    0x14(%ebp),%eax
c01042e5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01042e8:	31 d0                	xor    %edx,%eax
c01042ea:	25 ff 0f 00 00       	and    $0xfff,%eax
c01042ef:	85 c0                	test   %eax,%eax
c01042f1:	74 24                	je     c0104317 <boot_map_segment+0x3b>
c01042f3:	c7 44 24 0c 72 6c 10 	movl   $0xc0106c72,0xc(%esp)
c01042fa:	c0 
c01042fb:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104302:	c0 
c0104303:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010430a:	00 
c010430b:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104312:	e8 c9 c9 ff ff       	call   c0100ce0 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104317:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010431e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104321:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104326:	89 c2                	mov    %eax,%edx
c0104328:	8b 45 10             	mov    0x10(%ebp),%eax
c010432b:	01 c2                	add    %eax,%edx
c010432d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104330:	01 d0                	add    %edx,%eax
c0104332:	83 e8 01             	sub    $0x1,%eax
c0104335:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104338:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010433b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104340:	f7 75 f0             	divl   -0x10(%ebp)
c0104343:	89 d0                	mov    %edx,%eax
c0104345:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104348:	29 c2                	sub    %eax,%edx
c010434a:	89 d0                	mov    %edx,%eax
c010434c:	c1 e8 0c             	shr    $0xc,%eax
c010434f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104352:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104355:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104358:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010435b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104360:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104363:	8b 45 14             	mov    0x14(%ebp),%eax
c0104366:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010436c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104371:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104374:	eb 6b                	jmp    c01043e1 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104376:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010437d:	00 
c010437e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104381:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104385:	8b 45 08             	mov    0x8(%ebp),%eax
c0104388:	89 04 24             	mov    %eax,(%esp)
c010438b:	e8 82 01 00 00       	call   c0104512 <get_pte>
c0104390:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104393:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104397:	75 24                	jne    c01043bd <boot_map_segment+0xe1>
c0104399:	c7 44 24 0c 9e 6c 10 	movl   $0xc0106c9e,0xc(%esp)
c01043a0:	c0 
c01043a1:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c01043a8:	c0 
c01043a9:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01043b0:	00 
c01043b1:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c01043b8:	e8 23 c9 ff ff       	call   c0100ce0 <__panic>
        *ptep = pa | PTE_P | perm;
c01043bd:	8b 45 18             	mov    0x18(%ebp),%eax
c01043c0:	8b 55 14             	mov    0x14(%ebp),%edx
c01043c3:	09 d0                	or     %edx,%eax
c01043c5:	83 c8 01             	or     $0x1,%eax
c01043c8:	89 c2                	mov    %eax,%edx
c01043ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01043cd:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01043cf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01043d3:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01043da:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01043e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01043e5:	75 8f                	jne    c0104376 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01043e7:	c9                   	leave  
c01043e8:	c3                   	ret    

c01043e9 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01043e9:	55                   	push   %ebp
c01043ea:	89 e5                	mov    %esp,%ebp
c01043ec:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01043ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01043f6:	e8 5b fa ff ff       	call   c0103e56 <alloc_pages>
c01043fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01043fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104402:	75 1c                	jne    c0104420 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104404:	c7 44 24 08 ab 6c 10 	movl   $0xc0106cab,0x8(%esp)
c010440b:	c0 
c010440c:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104413:	00 
c0104414:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c010441b:	e8 c0 c8 ff ff       	call   c0100ce0 <__panic>
    }
    return page2kva(p);
c0104420:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104423:	89 04 24             	mov    %eax,(%esp)
c0104426:	e8 7c f7 ff ff       	call   c0103ba7 <page2kva>
}
c010442b:	c9                   	leave  
c010442c:	c3                   	ret    

c010442d <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010442d:	55                   	push   %ebp
c010442e:	89 e5                	mov    %esp,%ebp
c0104430:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104433:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104438:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010443b:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104442:	77 23                	ja     c0104467 <pmm_init+0x3a>
c0104444:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104447:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010444b:	c7 44 24 08 40 6c 10 	movl   $0xc0106c40,0x8(%esp)
c0104452:	c0 
c0104453:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010445a:	00 
c010445b:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104462:	e8 79 c8 ff ff       	call   c0100ce0 <__panic>
c0104467:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010446a:	05 00 00 00 40       	add    $0x40000000,%eax
c010446f:	a3 20 af 11 c0       	mov    %eax,0xc011af20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104474:	e8 8b f9 ff ff       	call   c0103e04 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104479:	e8 6d fa ff ff       	call   c0103eeb <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010447e:	e8 db 03 00 00       	call   c010485e <check_alloc_page>

    check_pgdir();
c0104483:	e8 f4 03 00 00       	call   c010487c <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104488:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010448d:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104493:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104498:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010449b:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01044a2:	77 23                	ja     c01044c7 <pmm_init+0x9a>
c01044a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044ab:	c7 44 24 08 40 6c 10 	movl   $0xc0106c40,0x8(%esp)
c01044b2:	c0 
c01044b3:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01044ba:	00 
c01044bb:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c01044c2:	e8 19 c8 ff ff       	call   c0100ce0 <__panic>
c01044c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044ca:	05 00 00 00 40       	add    $0x40000000,%eax
c01044cf:	83 c8 03             	or     $0x3,%eax
c01044d2:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01044d4:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01044d9:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01044e0:	00 
c01044e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01044e8:	00 
c01044e9:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01044f0:	38 
c01044f1:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01044f8:	c0 
c01044f9:	89 04 24             	mov    %eax,(%esp)
c01044fc:	e8 db fd ff ff       	call   c01042dc <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104501:	e8 0f f8 ff ff       	call   c0103d15 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104506:	e8 0c 0a 00 00       	call   c0104f17 <check_boot_pgdir>

    print_pgdir();
c010450b:	e8 94 0e 00 00       	call   c01053a4 <print_pgdir>

}
c0104510:	c9                   	leave  
c0104511:	c3                   	ret    

c0104512 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104512:	55                   	push   %ebp
c0104513:	89 e5                	mov    %esp,%ebp
c0104515:	83 ec 38             	sub    $0x38,%esp
    }

    // 返回在pgdir中对应于la的二级页表项
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
*/
    pde_t *pdep = &pgdir[PDX(la)];
c0104518:	8b 45 0c             	mov    0xc(%ebp),%eax
c010451b:	c1 e8 16             	shr    $0x16,%eax
c010451e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104525:	8b 45 08             	mov    0x8(%ebp),%eax
c0104528:	01 d0                	add    %edx,%eax
c010452a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c010452d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104530:	8b 00                	mov    (%eax),%eax
c0104532:	83 e0 01             	and    $0x1,%eax
c0104535:	85 c0                	test   %eax,%eax
c0104537:	0f 85 af 00 00 00    	jne    c01045ec <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c010453d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104541:	74 15                	je     c0104558 <get_pte+0x46>
c0104543:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010454a:	e8 07 f9 ff ff       	call   c0103e56 <alloc_pages>
c010454f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104552:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104556:	75 0a                	jne    c0104562 <get_pte+0x50>
            return NULL;
c0104558:	b8 00 00 00 00       	mov    $0x0,%eax
c010455d:	e9 e6 00 00 00       	jmp    c0104648 <get_pte+0x136>
        }
        set_page_ref(page, 1);
c0104562:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104569:	00 
c010456a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010456d:	89 04 24             	mov    %eax,(%esp)
c0104570:	e8 e6 f6 ff ff       	call   c0103c5b <set_page_ref>
        uintptr_t pa = page2pa(page);
c0104575:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104578:	89 04 24             	mov    %eax,(%esp)
c010457b:	e8 c2 f5 ff ff       	call   c0103b42 <page2pa>
c0104580:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0104583:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104586:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104589:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010458c:	c1 e8 0c             	shr    $0xc,%eax
c010458f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104592:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104597:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010459a:	72 23                	jb     c01045bf <get_pte+0xad>
c010459c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010459f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045a3:	c7 44 24 08 9c 6b 10 	movl   $0xc0106b9c,0x8(%esp)
c01045aa:	c0 
c01045ab:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
c01045b2:	00 
c01045b3:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c01045ba:	e8 21 c7 ff ff       	call   c0100ce0 <__panic>
c01045bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01045c2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01045c7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01045ce:	00 
c01045cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01045d6:	00 
c01045d7:	89 04 24             	mov    %eax,(%esp)
c01045da:	e8 e3 18 00 00       	call   c0105ec2 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c01045df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045e2:	83 c8 07             	or     $0x7,%eax
c01045e5:	89 c2                	mov    %eax,%edx
c01045e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ea:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01045ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ef:	8b 00                	mov    (%eax),%eax
c01045f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01045f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01045f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045fc:	c1 e8 0c             	shr    $0xc,%eax
c01045ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104602:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104607:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010460a:	72 23                	jb     c010462f <get_pte+0x11d>
c010460c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010460f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104613:	c7 44 24 08 9c 6b 10 	movl   $0xc0106b9c,0x8(%esp)
c010461a:	c0 
c010461b:	c7 44 24 04 82 01 00 	movl   $0x182,0x4(%esp)
c0104622:	00 
c0104623:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c010462a:	e8 b1 c6 ff ff       	call   c0100ce0 <__panic>
c010462f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104632:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104637:	8b 55 0c             	mov    0xc(%ebp),%edx
c010463a:	c1 ea 0c             	shr    $0xc,%edx
c010463d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104643:	c1 e2 02             	shl    $0x2,%edx
c0104646:	01 d0                	add    %edx,%eax
}
c0104648:	c9                   	leave  
c0104649:	c3                   	ret    

c010464a <get_page>:


//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010464a:	55                   	push   %ebp
c010464b:	89 e5                	mov    %esp,%ebp
c010464d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104650:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104657:	00 
c0104658:	8b 45 0c             	mov    0xc(%ebp),%eax
c010465b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010465f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104662:	89 04 24             	mov    %eax,(%esp)
c0104665:	e8 a8 fe ff ff       	call   c0104512 <get_pte>
c010466a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010466d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104671:	74 08                	je     c010467b <get_page+0x31>
        *ptep_store = ptep;
c0104673:	8b 45 10             	mov    0x10(%ebp),%eax
c0104676:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104679:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010467b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010467f:	74 1b                	je     c010469c <get_page+0x52>
c0104681:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104684:	8b 00                	mov    (%eax),%eax
c0104686:	83 e0 01             	and    $0x1,%eax
c0104689:	85 c0                	test   %eax,%eax
c010468b:	74 0f                	je     c010469c <get_page+0x52>
        return pte2page(*ptep);
c010468d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104690:	8b 00                	mov    (%eax),%eax
c0104692:	89 04 24             	mov    %eax,(%esp)
c0104695:	e8 61 f5 ff ff       	call   c0103bfb <pte2page>
c010469a:	eb 05                	jmp    c01046a1 <get_page+0x57>
    }
    return NULL;
c010469c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01046a1:	c9                   	leave  
c01046a2:	c3                   	ret    

c01046a3 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01046a3:	55                   	push   %ebp
c01046a4:	89 e5                	mov    %esp,%ebp
c01046a6:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    // 如果传入的页表条目是可用的
    if (*ptep & PTE_P) {
c01046a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01046ac:	8b 00                	mov    (%eax),%eax
c01046ae:	83 e0 01             	and    $0x1,%eax
c01046b1:	85 c0                	test   %eax,%eax
c01046b3:	74 4d                	je     c0104702 <page_remove_pte+0x5f>
        // 获取该页表条目所对应的地址
        struct Page *page = pte2page(*ptep);
c01046b5:	8b 45 10             	mov    0x10(%ebp),%eax
c01046b8:	8b 00                	mov    (%eax),%eax
c01046ba:	89 04 24             	mov    %eax,(%esp)
c01046bd:	e8 39 f5 ff ff       	call   c0103bfb <pte2page>
c01046c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 如果该页的引用次数在减1后为0
        if (page_ref_dec(page) == 0)
c01046c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c8:	89 04 24             	mov    %eax,(%esp)
c01046cb:	e8 af f5 ff ff       	call   c0103c7f <page_ref_dec>
c01046d0:	85 c0                	test   %eax,%eax
c01046d2:	75 13                	jne    c01046e7 <page_remove_pte+0x44>
            // 释放当前页
            free_page(page);
c01046d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01046db:	00 
c01046dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046df:	89 04 24             	mov    %eax,(%esp)
c01046e2:	e8 a7 f7 ff ff       	call   c0103e8e <free_pages>
        // 清空PTE
        *ptep = 0;
c01046e7:	8b 45 10             	mov    0x10(%ebp),%eax
c01046ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        // 刷新TLB内的数据
        tlb_invalidate(pgdir, la);
c01046f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01046fa:	89 04 24             	mov    %eax,(%esp)
c01046fd:	e8 ff 00 00 00       	call   c0104801 <tlb_invalidate>
    }
}
c0104702:	c9                   	leave  
c0104703:	c3                   	ret    

c0104704 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104704:	55                   	push   %ebp
c0104705:	89 e5                	mov    %esp,%ebp
c0104707:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010470a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104711:	00 
c0104712:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104719:	8b 45 08             	mov    0x8(%ebp),%eax
c010471c:	89 04 24             	mov    %eax,(%esp)
c010471f:	e8 ee fd ff ff       	call   c0104512 <get_pte>
c0104724:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104727:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010472b:	74 19                	je     c0104746 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010472d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104730:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104734:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104737:	89 44 24 04          	mov    %eax,0x4(%esp)
c010473b:	8b 45 08             	mov    0x8(%ebp),%eax
c010473e:	89 04 24             	mov    %eax,(%esp)
c0104741:	e8 5d ff ff ff       	call   c01046a3 <page_remove_pte>
    }
}
c0104746:	c9                   	leave  
c0104747:	c3                   	ret    

c0104748 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104748:	55                   	push   %ebp
c0104749:	89 e5                	mov    %esp,%ebp
c010474b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010474e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104755:	00 
c0104756:	8b 45 10             	mov    0x10(%ebp),%eax
c0104759:	89 44 24 04          	mov    %eax,0x4(%esp)
c010475d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104760:	89 04 24             	mov    %eax,(%esp)
c0104763:	e8 aa fd ff ff       	call   c0104512 <get_pte>
c0104768:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010476b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010476f:	75 0a                	jne    c010477b <page_insert+0x33>
        return -E_NO_MEM;
c0104771:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104776:	e9 84 00 00 00       	jmp    c01047ff <page_insert+0xb7>
    }
    page_ref_inc(page);
c010477b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010477e:	89 04 24             	mov    %eax,(%esp)
c0104781:	e8 e2 f4 ff ff       	call   c0103c68 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104786:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104789:	8b 00                	mov    (%eax),%eax
c010478b:	83 e0 01             	and    $0x1,%eax
c010478e:	85 c0                	test   %eax,%eax
c0104790:	74 3e                	je     c01047d0 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104792:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104795:	8b 00                	mov    (%eax),%eax
c0104797:	89 04 24             	mov    %eax,(%esp)
c010479a:	e8 5c f4 ff ff       	call   c0103bfb <pte2page>
c010479f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01047a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01047a8:	75 0d                	jne    c01047b7 <page_insert+0x6f>
            page_ref_dec(page);
c01047aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047ad:	89 04 24             	mov    %eax,(%esp)
c01047b0:	e8 ca f4 ff ff       	call   c0103c7f <page_ref_dec>
c01047b5:	eb 19                	jmp    c01047d0 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01047b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047ba:	89 44 24 08          	mov    %eax,0x8(%esp)
c01047be:	8b 45 10             	mov    0x10(%ebp),%eax
c01047c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c8:	89 04 24             	mov    %eax,(%esp)
c01047cb:	e8 d3 fe ff ff       	call   c01046a3 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01047d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047d3:	89 04 24             	mov    %eax,(%esp)
c01047d6:	e8 67 f3 ff ff       	call   c0103b42 <page2pa>
c01047db:	0b 45 14             	or     0x14(%ebp),%eax
c01047de:	83 c8 01             	or     $0x1,%eax
c01047e1:	89 c2                	mov    %eax,%edx
c01047e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e6:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01047e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01047eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01047f2:	89 04 24             	mov    %eax,(%esp)
c01047f5:	e8 07 00 00 00       	call   c0104801 <tlb_invalidate>
    return 0;
c01047fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047ff:	c9                   	leave  
c0104800:	c3                   	ret    

c0104801 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104801:	55                   	push   %ebp
c0104802:	89 e5                	mov    %esp,%ebp
c0104804:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104807:	0f 20 d8             	mov    %cr3,%eax
c010480a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010480d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104810:	89 c2                	mov    %eax,%edx
c0104812:	8b 45 08             	mov    0x8(%ebp),%eax
c0104815:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104818:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010481f:	77 23                	ja     c0104844 <tlb_invalidate+0x43>
c0104821:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104824:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104828:	c7 44 24 08 40 6c 10 	movl   $0xc0106c40,0x8(%esp)
c010482f:	c0 
c0104830:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0104837:	00 
c0104838:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c010483f:	e8 9c c4 ff ff       	call   c0100ce0 <__panic>
c0104844:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104847:	05 00 00 00 40       	add    $0x40000000,%eax
c010484c:	39 c2                	cmp    %eax,%edx
c010484e:	75 0c                	jne    c010485c <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104850:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104853:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104856:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104859:	0f 01 38             	invlpg (%eax)
    }
}
c010485c:	c9                   	leave  
c010485d:	c3                   	ret    

c010485e <check_alloc_page>:

static void
check_alloc_page(void) {
c010485e:	55                   	push   %ebp
c010485f:	89 e5                	mov    %esp,%ebp
c0104861:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104864:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0104869:	8b 40 18             	mov    0x18(%eax),%eax
c010486c:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010486e:	c7 04 24 c4 6c 10 c0 	movl   $0xc0106cc4,(%esp)
c0104875:	e8 ce ba ff ff       	call   c0100348 <cprintf>
}
c010487a:	c9                   	leave  
c010487b:	c3                   	ret    

c010487c <check_pgdir>:

static void
check_pgdir(void) {
c010487c:	55                   	push   %ebp
c010487d:	89 e5                	mov    %esp,%ebp
c010487f:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104882:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104887:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010488c:	76 24                	jbe    c01048b2 <check_pgdir+0x36>
c010488e:	c7 44 24 0c e3 6c 10 	movl   $0xc0106ce3,0xc(%esp)
c0104895:	c0 
c0104896:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c010489d:	c0 
c010489e:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c01048a5:	00 
c01048a6:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c01048ad:	e8 2e c4 ff ff       	call   c0100ce0 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01048b2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01048b7:	85 c0                	test   %eax,%eax
c01048b9:	74 0e                	je     c01048c9 <check_pgdir+0x4d>
c01048bb:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01048c0:	25 ff 0f 00 00       	and    $0xfff,%eax
c01048c5:	85 c0                	test   %eax,%eax
c01048c7:	74 24                	je     c01048ed <check_pgdir+0x71>
c01048c9:	c7 44 24 0c 00 6d 10 	movl   $0xc0106d00,0xc(%esp)
c01048d0:	c0 
c01048d1:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c01048d8:	c0 
c01048d9:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c01048e0:	00 
c01048e1:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c01048e8:	e8 f3 c3 ff ff       	call   c0100ce0 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01048ed:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01048f2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048f9:	00 
c01048fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104901:	00 
c0104902:	89 04 24             	mov    %eax,(%esp)
c0104905:	e8 40 fd ff ff       	call   c010464a <get_page>
c010490a:	85 c0                	test   %eax,%eax
c010490c:	74 24                	je     c0104932 <check_pgdir+0xb6>
c010490e:	c7 44 24 0c 38 6d 10 	movl   $0xc0106d38,0xc(%esp)
c0104915:	c0 
c0104916:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c010491d:	c0 
c010491e:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0104925:	00 
c0104926:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c010492d:	e8 ae c3 ff ff       	call   c0100ce0 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104932:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104939:	e8 18 f5 ff ff       	call   c0103e56 <alloc_pages>
c010493e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104941:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104946:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010494d:	00 
c010494e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104955:	00 
c0104956:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104959:	89 54 24 04          	mov    %edx,0x4(%esp)
c010495d:	89 04 24             	mov    %eax,(%esp)
c0104960:	e8 e3 fd ff ff       	call   c0104748 <page_insert>
c0104965:	85 c0                	test   %eax,%eax
c0104967:	74 24                	je     c010498d <check_pgdir+0x111>
c0104969:	c7 44 24 0c 60 6d 10 	movl   $0xc0106d60,0xc(%esp)
c0104970:	c0 
c0104971:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104978:	c0 
c0104979:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0104980:	00 
c0104981:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104988:	e8 53 c3 ff ff       	call   c0100ce0 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010498d:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104992:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104999:	00 
c010499a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01049a1:	00 
c01049a2:	89 04 24             	mov    %eax,(%esp)
c01049a5:	e8 68 fb ff ff       	call   c0104512 <get_pte>
c01049aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01049ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01049b1:	75 24                	jne    c01049d7 <check_pgdir+0x15b>
c01049b3:	c7 44 24 0c 8c 6d 10 	movl   $0xc0106d8c,0xc(%esp)
c01049ba:	c0 
c01049bb:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c01049c2:	c0 
c01049c3:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c01049ca:	00 
c01049cb:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c01049d2:	e8 09 c3 ff ff       	call   c0100ce0 <__panic>
    assert(pte2page(*ptep) == p1);
c01049d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049da:	8b 00                	mov    (%eax),%eax
c01049dc:	89 04 24             	mov    %eax,(%esp)
c01049df:	e8 17 f2 ff ff       	call   c0103bfb <pte2page>
c01049e4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01049e7:	74 24                	je     c0104a0d <check_pgdir+0x191>
c01049e9:	c7 44 24 0c b9 6d 10 	movl   $0xc0106db9,0xc(%esp)
c01049f0:	c0 
c01049f1:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c01049f8:	c0 
c01049f9:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104a00:	00 
c0104a01:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104a08:	e8 d3 c2 ff ff       	call   c0100ce0 <__panic>
    assert(page_ref(p1) == 1);
c0104a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a10:	89 04 24             	mov    %eax,(%esp)
c0104a13:	e8 39 f2 ff ff       	call   c0103c51 <page_ref>
c0104a18:	83 f8 01             	cmp    $0x1,%eax
c0104a1b:	74 24                	je     c0104a41 <check_pgdir+0x1c5>
c0104a1d:	c7 44 24 0c cf 6d 10 	movl   $0xc0106dcf,0xc(%esp)
c0104a24:	c0 
c0104a25:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104a2c:	c0 
c0104a2d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0104a34:	00 
c0104a35:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104a3c:	e8 9f c2 ff ff       	call   c0100ce0 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104a41:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104a46:	8b 00                	mov    (%eax),%eax
c0104a48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104a4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a53:	c1 e8 0c             	shr    $0xc,%eax
c0104a56:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104a59:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104a5e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104a61:	72 23                	jb     c0104a86 <check_pgdir+0x20a>
c0104a63:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a66:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a6a:	c7 44 24 08 9c 6b 10 	movl   $0xc0106b9c,0x8(%esp)
c0104a71:	c0 
c0104a72:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104a79:	00 
c0104a7a:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104a81:	e8 5a c2 ff ff       	call   c0100ce0 <__panic>
c0104a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a89:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104a8e:	83 c0 04             	add    $0x4,%eax
c0104a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104a94:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104a99:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104aa0:	00 
c0104aa1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104aa8:	00 
c0104aa9:	89 04 24             	mov    %eax,(%esp)
c0104aac:	e8 61 fa ff ff       	call   c0104512 <get_pte>
c0104ab1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104ab4:	74 24                	je     c0104ada <check_pgdir+0x25e>
c0104ab6:	c7 44 24 0c e4 6d 10 	movl   $0xc0106de4,0xc(%esp)
c0104abd:	c0 
c0104abe:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104ac5:	c0 
c0104ac6:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104acd:	00 
c0104ace:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104ad5:	e8 06 c2 ff ff       	call   c0100ce0 <__panic>

    p2 = alloc_page();
c0104ada:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ae1:	e8 70 f3 ff ff       	call   c0103e56 <alloc_pages>
c0104ae6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104ae9:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104aee:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104af5:	00 
c0104af6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104afd:	00 
c0104afe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104b01:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b05:	89 04 24             	mov    %eax,(%esp)
c0104b08:	e8 3b fc ff ff       	call   c0104748 <page_insert>
c0104b0d:	85 c0                	test   %eax,%eax
c0104b0f:	74 24                	je     c0104b35 <check_pgdir+0x2b9>
c0104b11:	c7 44 24 0c 0c 6e 10 	movl   $0xc0106e0c,0xc(%esp)
c0104b18:	c0 
c0104b19:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104b20:	c0 
c0104b21:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104b28:	00 
c0104b29:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104b30:	e8 ab c1 ff ff       	call   c0100ce0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104b35:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104b3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b41:	00 
c0104b42:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b49:	00 
c0104b4a:	89 04 24             	mov    %eax,(%esp)
c0104b4d:	e8 c0 f9 ff ff       	call   c0104512 <get_pte>
c0104b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b59:	75 24                	jne    c0104b7f <check_pgdir+0x303>
c0104b5b:	c7 44 24 0c 44 6e 10 	movl   $0xc0106e44,0xc(%esp)
c0104b62:	c0 
c0104b63:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104b6a:	c0 
c0104b6b:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104b72:	00 
c0104b73:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104b7a:	e8 61 c1 ff ff       	call   c0100ce0 <__panic>
    assert(*ptep & PTE_U);
c0104b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b82:	8b 00                	mov    (%eax),%eax
c0104b84:	83 e0 04             	and    $0x4,%eax
c0104b87:	85 c0                	test   %eax,%eax
c0104b89:	75 24                	jne    c0104baf <check_pgdir+0x333>
c0104b8b:	c7 44 24 0c 74 6e 10 	movl   $0xc0106e74,0xc(%esp)
c0104b92:	c0 
c0104b93:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104b9a:	c0 
c0104b9b:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104ba2:	00 
c0104ba3:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104baa:	e8 31 c1 ff ff       	call   c0100ce0 <__panic>
    assert(*ptep & PTE_W);
c0104baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bb2:	8b 00                	mov    (%eax),%eax
c0104bb4:	83 e0 02             	and    $0x2,%eax
c0104bb7:	85 c0                	test   %eax,%eax
c0104bb9:	75 24                	jne    c0104bdf <check_pgdir+0x363>
c0104bbb:	c7 44 24 0c 82 6e 10 	movl   $0xc0106e82,0xc(%esp)
c0104bc2:	c0 
c0104bc3:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104bca:	c0 
c0104bcb:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104bd2:	00 
c0104bd3:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104bda:	e8 01 c1 ff ff       	call   c0100ce0 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104bdf:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104be4:	8b 00                	mov    (%eax),%eax
c0104be6:	83 e0 04             	and    $0x4,%eax
c0104be9:	85 c0                	test   %eax,%eax
c0104beb:	75 24                	jne    c0104c11 <check_pgdir+0x395>
c0104bed:	c7 44 24 0c 90 6e 10 	movl   $0xc0106e90,0xc(%esp)
c0104bf4:	c0 
c0104bf5:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104bfc:	c0 
c0104bfd:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104c04:	00 
c0104c05:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104c0c:	e8 cf c0 ff ff       	call   c0100ce0 <__panic>
    assert(page_ref(p2) == 1);
c0104c11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c14:	89 04 24             	mov    %eax,(%esp)
c0104c17:	e8 35 f0 ff ff       	call   c0103c51 <page_ref>
c0104c1c:	83 f8 01             	cmp    $0x1,%eax
c0104c1f:	74 24                	je     c0104c45 <check_pgdir+0x3c9>
c0104c21:	c7 44 24 0c a6 6e 10 	movl   $0xc0106ea6,0xc(%esp)
c0104c28:	c0 
c0104c29:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104c30:	c0 
c0104c31:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104c38:	00 
c0104c39:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104c40:	e8 9b c0 ff ff       	call   c0100ce0 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104c45:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104c4a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104c51:	00 
c0104c52:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104c59:	00 
c0104c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104c5d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c61:	89 04 24             	mov    %eax,(%esp)
c0104c64:	e8 df fa ff ff       	call   c0104748 <page_insert>
c0104c69:	85 c0                	test   %eax,%eax
c0104c6b:	74 24                	je     c0104c91 <check_pgdir+0x415>
c0104c6d:	c7 44 24 0c b8 6e 10 	movl   $0xc0106eb8,0xc(%esp)
c0104c74:	c0 
c0104c75:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104c7c:	c0 
c0104c7d:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104c84:	00 
c0104c85:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104c8c:	e8 4f c0 ff ff       	call   c0100ce0 <__panic>
    assert(page_ref(p1) == 2);
c0104c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c94:	89 04 24             	mov    %eax,(%esp)
c0104c97:	e8 b5 ef ff ff       	call   c0103c51 <page_ref>
c0104c9c:	83 f8 02             	cmp    $0x2,%eax
c0104c9f:	74 24                	je     c0104cc5 <check_pgdir+0x449>
c0104ca1:	c7 44 24 0c e4 6e 10 	movl   $0xc0106ee4,0xc(%esp)
c0104ca8:	c0 
c0104ca9:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104cb0:	c0 
c0104cb1:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104cb8:	00 
c0104cb9:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104cc0:	e8 1b c0 ff ff       	call   c0100ce0 <__panic>
    assert(page_ref(p2) == 0);
c0104cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cc8:	89 04 24             	mov    %eax,(%esp)
c0104ccb:	e8 81 ef ff ff       	call   c0103c51 <page_ref>
c0104cd0:	85 c0                	test   %eax,%eax
c0104cd2:	74 24                	je     c0104cf8 <check_pgdir+0x47c>
c0104cd4:	c7 44 24 0c f6 6e 10 	movl   $0xc0106ef6,0xc(%esp)
c0104cdb:	c0 
c0104cdc:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104ce3:	c0 
c0104ce4:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104ceb:	00 
c0104cec:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104cf3:	e8 e8 bf ff ff       	call   c0100ce0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104cf8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104cfd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d04:	00 
c0104d05:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d0c:	00 
c0104d0d:	89 04 24             	mov    %eax,(%esp)
c0104d10:	e8 fd f7 ff ff       	call   c0104512 <get_pte>
c0104d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104d1c:	75 24                	jne    c0104d42 <check_pgdir+0x4c6>
c0104d1e:	c7 44 24 0c 44 6e 10 	movl   $0xc0106e44,0xc(%esp)
c0104d25:	c0 
c0104d26:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104d2d:	c0 
c0104d2e:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104d35:	00 
c0104d36:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104d3d:	e8 9e bf ff ff       	call   c0100ce0 <__panic>
    assert(pte2page(*ptep) == p1);
c0104d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d45:	8b 00                	mov    (%eax),%eax
c0104d47:	89 04 24             	mov    %eax,(%esp)
c0104d4a:	e8 ac ee ff ff       	call   c0103bfb <pte2page>
c0104d4f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104d52:	74 24                	je     c0104d78 <check_pgdir+0x4fc>
c0104d54:	c7 44 24 0c b9 6d 10 	movl   $0xc0106db9,0xc(%esp)
c0104d5b:	c0 
c0104d5c:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104d63:	c0 
c0104d64:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104d6b:	00 
c0104d6c:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104d73:	e8 68 bf ff ff       	call   c0100ce0 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d7b:	8b 00                	mov    (%eax),%eax
c0104d7d:	83 e0 04             	and    $0x4,%eax
c0104d80:	85 c0                	test   %eax,%eax
c0104d82:	74 24                	je     c0104da8 <check_pgdir+0x52c>
c0104d84:	c7 44 24 0c 08 6f 10 	movl   $0xc0106f08,0xc(%esp)
c0104d8b:	c0 
c0104d8c:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104d93:	c0 
c0104d94:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104d9b:	00 
c0104d9c:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104da3:	e8 38 bf ff ff       	call   c0100ce0 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104da8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104dad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104db4:	00 
c0104db5:	89 04 24             	mov    %eax,(%esp)
c0104db8:	e8 47 f9 ff ff       	call   c0104704 <page_remove>
    assert(page_ref(p1) == 1);
c0104dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dc0:	89 04 24             	mov    %eax,(%esp)
c0104dc3:	e8 89 ee ff ff       	call   c0103c51 <page_ref>
c0104dc8:	83 f8 01             	cmp    $0x1,%eax
c0104dcb:	74 24                	je     c0104df1 <check_pgdir+0x575>
c0104dcd:	c7 44 24 0c cf 6d 10 	movl   $0xc0106dcf,0xc(%esp)
c0104dd4:	c0 
c0104dd5:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104ddc:	c0 
c0104ddd:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104de4:	00 
c0104de5:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104dec:	e8 ef be ff ff       	call   c0100ce0 <__panic>
    assert(page_ref(p2) == 0);
c0104df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104df4:	89 04 24             	mov    %eax,(%esp)
c0104df7:	e8 55 ee ff ff       	call   c0103c51 <page_ref>
c0104dfc:	85 c0                	test   %eax,%eax
c0104dfe:	74 24                	je     c0104e24 <check_pgdir+0x5a8>
c0104e00:	c7 44 24 0c f6 6e 10 	movl   $0xc0106ef6,0xc(%esp)
c0104e07:	c0 
c0104e08:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104e0f:	c0 
c0104e10:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104e17:	00 
c0104e18:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104e1f:	e8 bc be ff ff       	call   c0100ce0 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104e24:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e29:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104e30:	00 
c0104e31:	89 04 24             	mov    %eax,(%esp)
c0104e34:	e8 cb f8 ff ff       	call   c0104704 <page_remove>
    assert(page_ref(p1) == 0);
c0104e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e3c:	89 04 24             	mov    %eax,(%esp)
c0104e3f:	e8 0d ee ff ff       	call   c0103c51 <page_ref>
c0104e44:	85 c0                	test   %eax,%eax
c0104e46:	74 24                	je     c0104e6c <check_pgdir+0x5f0>
c0104e48:	c7 44 24 0c 1d 6f 10 	movl   $0xc0106f1d,0xc(%esp)
c0104e4f:	c0 
c0104e50:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104e57:	c0 
c0104e58:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104e5f:	00 
c0104e60:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104e67:	e8 74 be ff ff       	call   c0100ce0 <__panic>
    assert(page_ref(p2) == 0);
c0104e6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e6f:	89 04 24             	mov    %eax,(%esp)
c0104e72:	e8 da ed ff ff       	call   c0103c51 <page_ref>
c0104e77:	85 c0                	test   %eax,%eax
c0104e79:	74 24                	je     c0104e9f <check_pgdir+0x623>
c0104e7b:	c7 44 24 0c f6 6e 10 	movl   $0xc0106ef6,0xc(%esp)
c0104e82:	c0 
c0104e83:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104e8a:	c0 
c0104e8b:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104e92:	00 
c0104e93:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104e9a:	e8 41 be ff ff       	call   c0100ce0 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104e9f:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104ea4:	8b 00                	mov    (%eax),%eax
c0104ea6:	89 04 24             	mov    %eax,(%esp)
c0104ea9:	e8 8b ed ff ff       	call   c0103c39 <pde2page>
c0104eae:	89 04 24             	mov    %eax,(%esp)
c0104eb1:	e8 9b ed ff ff       	call   c0103c51 <page_ref>
c0104eb6:	83 f8 01             	cmp    $0x1,%eax
c0104eb9:	74 24                	je     c0104edf <check_pgdir+0x663>
c0104ebb:	c7 44 24 0c 30 6f 10 	movl   $0xc0106f30,0xc(%esp)
c0104ec2:	c0 
c0104ec3:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104eca:	c0 
c0104ecb:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104ed2:	00 
c0104ed3:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104eda:	e8 01 be ff ff       	call   c0100ce0 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104edf:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104ee4:	8b 00                	mov    (%eax),%eax
c0104ee6:	89 04 24             	mov    %eax,(%esp)
c0104ee9:	e8 4b ed ff ff       	call   c0103c39 <pde2page>
c0104eee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ef5:	00 
c0104ef6:	89 04 24             	mov    %eax,(%esp)
c0104ef9:	e8 90 ef ff ff       	call   c0103e8e <free_pages>
    boot_pgdir[0] = 0;
c0104efe:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104f03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104f09:	c7 04 24 57 6f 10 c0 	movl   $0xc0106f57,(%esp)
c0104f10:	e8 33 b4 ff ff       	call   c0100348 <cprintf>
}
c0104f15:	c9                   	leave  
c0104f16:	c3                   	ret    

c0104f17 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104f17:	55                   	push   %ebp
c0104f18:	89 e5                	mov    %esp,%ebp
c0104f1a:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104f1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104f24:	e9 ca 00 00 00       	jmp    c0104ff3 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f32:	c1 e8 0c             	shr    $0xc,%eax
c0104f35:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104f38:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104f3d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104f40:	72 23                	jb     c0104f65 <check_boot_pgdir+0x4e>
c0104f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f45:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f49:	c7 44 24 08 9c 6b 10 	movl   $0xc0106b9c,0x8(%esp)
c0104f50:	c0 
c0104f51:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0104f58:	00 
c0104f59:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104f60:	e8 7b bd ff ff       	call   c0100ce0 <__panic>
c0104f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f68:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104f6d:	89 c2                	mov    %eax,%edx
c0104f6f:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104f74:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f7b:	00 
c0104f7c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f80:	89 04 24             	mov    %eax,(%esp)
c0104f83:	e8 8a f5 ff ff       	call   c0104512 <get_pte>
c0104f88:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104f8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104f8f:	75 24                	jne    c0104fb5 <check_boot_pgdir+0x9e>
c0104f91:	c7 44 24 0c 74 6f 10 	movl   $0xc0106f74,0xc(%esp)
c0104f98:	c0 
c0104f99:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104fa0:	c0 
c0104fa1:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0104fa8:	00 
c0104fa9:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104fb0:	e8 2b bd ff ff       	call   c0100ce0 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fb8:	8b 00                	mov    (%eax),%eax
c0104fba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104fbf:	89 c2                	mov    %eax,%edx
c0104fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fc4:	39 c2                	cmp    %eax,%edx
c0104fc6:	74 24                	je     c0104fec <check_boot_pgdir+0xd5>
c0104fc8:	c7 44 24 0c b1 6f 10 	movl   $0xc0106fb1,0xc(%esp)
c0104fcf:	c0 
c0104fd0:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0104fd7:	c0 
c0104fd8:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0104fdf:	00 
c0104fe0:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0104fe7:	e8 f4 bc ff ff       	call   c0100ce0 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104fec:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104ff3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104ff6:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104ffb:	39 c2                	cmp    %eax,%edx
c0104ffd:	0f 82 26 ff ff ff    	jb     c0104f29 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105003:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0105008:	05 ac 0f 00 00       	add    $0xfac,%eax
c010500d:	8b 00                	mov    (%eax),%eax
c010500f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105014:	89 c2                	mov    %eax,%edx
c0105016:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010501b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010501e:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0105025:	77 23                	ja     c010504a <check_boot_pgdir+0x133>
c0105027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010502a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010502e:	c7 44 24 08 40 6c 10 	movl   $0xc0106c40,0x8(%esp)
c0105035:	c0 
c0105036:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c010503d:	00 
c010503e:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0105045:	e8 96 bc ff ff       	call   c0100ce0 <__panic>
c010504a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010504d:	05 00 00 00 40       	add    $0x40000000,%eax
c0105052:	39 c2                	cmp    %eax,%edx
c0105054:	74 24                	je     c010507a <check_boot_pgdir+0x163>
c0105056:	c7 44 24 0c c8 6f 10 	movl   $0xc0106fc8,0xc(%esp)
c010505d:	c0 
c010505e:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0105065:	c0 
c0105066:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c010506d:	00 
c010506e:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0105075:	e8 66 bc ff ff       	call   c0100ce0 <__panic>

    assert(boot_pgdir[0] == 0);
c010507a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010507f:	8b 00                	mov    (%eax),%eax
c0105081:	85 c0                	test   %eax,%eax
c0105083:	74 24                	je     c01050a9 <check_boot_pgdir+0x192>
c0105085:	c7 44 24 0c fc 6f 10 	movl   $0xc0106ffc,0xc(%esp)
c010508c:	c0 
c010508d:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0105094:	c0 
c0105095:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c010509c:	00 
c010509d:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c01050a4:	e8 37 bc ff ff       	call   c0100ce0 <__panic>

    struct Page *p;
    p = alloc_page();
c01050a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01050b0:	e8 a1 ed ff ff       	call   c0103e56 <alloc_pages>
c01050b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01050b8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01050bd:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01050c4:	00 
c01050c5:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01050cc:	00 
c01050cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01050d0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050d4:	89 04 24             	mov    %eax,(%esp)
c01050d7:	e8 6c f6 ff ff       	call   c0104748 <page_insert>
c01050dc:	85 c0                	test   %eax,%eax
c01050de:	74 24                	je     c0105104 <check_boot_pgdir+0x1ed>
c01050e0:	c7 44 24 0c 10 70 10 	movl   $0xc0107010,0xc(%esp)
c01050e7:	c0 
c01050e8:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c01050ef:	c0 
c01050f0:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c01050f7:	00 
c01050f8:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c01050ff:	e8 dc bb ff ff       	call   c0100ce0 <__panic>
    assert(page_ref(p) == 1);
c0105104:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105107:	89 04 24             	mov    %eax,(%esp)
c010510a:	e8 42 eb ff ff       	call   c0103c51 <page_ref>
c010510f:	83 f8 01             	cmp    $0x1,%eax
c0105112:	74 24                	je     c0105138 <check_boot_pgdir+0x221>
c0105114:	c7 44 24 0c 3e 70 10 	movl   $0xc010703e,0xc(%esp)
c010511b:	c0 
c010511c:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0105123:	c0 
c0105124:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c010512b:	00 
c010512c:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0105133:	e8 a8 bb ff ff       	call   c0100ce0 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105138:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010513d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105144:	00 
c0105145:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010514c:	00 
c010514d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105150:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105154:	89 04 24             	mov    %eax,(%esp)
c0105157:	e8 ec f5 ff ff       	call   c0104748 <page_insert>
c010515c:	85 c0                	test   %eax,%eax
c010515e:	74 24                	je     c0105184 <check_boot_pgdir+0x26d>
c0105160:	c7 44 24 0c 50 70 10 	movl   $0xc0107050,0xc(%esp)
c0105167:	c0 
c0105168:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c010516f:	c0 
c0105170:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105177:	00 
c0105178:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c010517f:	e8 5c bb ff ff       	call   c0100ce0 <__panic>
    assert(page_ref(p) == 2);
c0105184:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105187:	89 04 24             	mov    %eax,(%esp)
c010518a:	e8 c2 ea ff ff       	call   c0103c51 <page_ref>
c010518f:	83 f8 02             	cmp    $0x2,%eax
c0105192:	74 24                	je     c01051b8 <check_boot_pgdir+0x2a1>
c0105194:	c7 44 24 0c 87 70 10 	movl   $0xc0107087,0xc(%esp)
c010519b:	c0 
c010519c:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c01051a3:	c0 
c01051a4:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c01051ab:	00 
c01051ac:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c01051b3:	e8 28 bb ff ff       	call   c0100ce0 <__panic>

    const char *str = "ucore: Hello world!!";
c01051b8:	c7 45 dc 98 70 10 c0 	movl   $0xc0107098,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01051bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01051c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051c6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01051cd:	e8 19 0a 00 00       	call   c0105beb <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01051d2:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01051d9:	00 
c01051da:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01051e1:	e8 7e 0a 00 00       	call   c0105c64 <strcmp>
c01051e6:	85 c0                	test   %eax,%eax
c01051e8:	74 24                	je     c010520e <check_boot_pgdir+0x2f7>
c01051ea:	c7 44 24 0c b0 70 10 	movl   $0xc01070b0,0xc(%esp)
c01051f1:	c0 
c01051f2:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c01051f9:	c0 
c01051fa:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105201:	00 
c0105202:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0105209:	e8 d2 ba ff ff       	call   c0100ce0 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010520e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105211:	89 04 24             	mov    %eax,(%esp)
c0105214:	e8 8e e9 ff ff       	call   c0103ba7 <page2kva>
c0105219:	05 00 01 00 00       	add    $0x100,%eax
c010521e:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105221:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105228:	e8 66 09 00 00       	call   c0105b93 <strlen>
c010522d:	85 c0                	test   %eax,%eax
c010522f:	74 24                	je     c0105255 <check_boot_pgdir+0x33e>
c0105231:	c7 44 24 0c e8 70 10 	movl   $0xc01070e8,0xc(%esp)
c0105238:	c0 
c0105239:	c7 44 24 08 89 6c 10 	movl   $0xc0106c89,0x8(%esp)
c0105240:	c0 
c0105241:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105248:	00 
c0105249:	c7 04 24 64 6c 10 c0 	movl   $0xc0106c64,(%esp)
c0105250:	e8 8b ba ff ff       	call   c0100ce0 <__panic>

    free_page(p);
c0105255:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010525c:	00 
c010525d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105260:	89 04 24             	mov    %eax,(%esp)
c0105263:	e8 26 ec ff ff       	call   c0103e8e <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105268:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010526d:	8b 00                	mov    (%eax),%eax
c010526f:	89 04 24             	mov    %eax,(%esp)
c0105272:	e8 c2 e9 ff ff       	call   c0103c39 <pde2page>
c0105277:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010527e:	00 
c010527f:	89 04 24             	mov    %eax,(%esp)
c0105282:	e8 07 ec ff ff       	call   c0103e8e <free_pages>
    boot_pgdir[0] = 0;
c0105287:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010528c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105292:	c7 04 24 0c 71 10 c0 	movl   $0xc010710c,(%esp)
c0105299:	e8 aa b0 ff ff       	call   c0100348 <cprintf>
}
c010529e:	c9                   	leave  
c010529f:	c3                   	ret    

c01052a0 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01052a0:	55                   	push   %ebp
c01052a1:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01052a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a6:	83 e0 04             	and    $0x4,%eax
c01052a9:	85 c0                	test   %eax,%eax
c01052ab:	74 07                	je     c01052b4 <perm2str+0x14>
c01052ad:	b8 75 00 00 00       	mov    $0x75,%eax
c01052b2:	eb 05                	jmp    c01052b9 <perm2str+0x19>
c01052b4:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01052b9:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c01052be:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01052c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01052c8:	83 e0 02             	and    $0x2,%eax
c01052cb:	85 c0                	test   %eax,%eax
c01052cd:	74 07                	je     c01052d6 <perm2str+0x36>
c01052cf:	b8 77 00 00 00       	mov    $0x77,%eax
c01052d4:	eb 05                	jmp    c01052db <perm2str+0x3b>
c01052d6:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01052db:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c01052e0:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c01052e7:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c01052ec:	5d                   	pop    %ebp
c01052ed:	c3                   	ret    

c01052ee <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01052ee:	55                   	push   %ebp
c01052ef:	89 e5                	mov    %esp,%ebp
c01052f1:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01052f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01052f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052fa:	72 0a                	jb     c0105306 <get_pgtable_items+0x18>
        return 0;
c01052fc:	b8 00 00 00 00       	mov    $0x0,%eax
c0105301:	e9 9c 00 00 00       	jmp    c01053a2 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105306:	eb 04                	jmp    c010530c <get_pgtable_items+0x1e>
        start ++;
c0105308:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010530c:	8b 45 10             	mov    0x10(%ebp),%eax
c010530f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105312:	73 18                	jae    c010532c <get_pgtable_items+0x3e>
c0105314:	8b 45 10             	mov    0x10(%ebp),%eax
c0105317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010531e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105321:	01 d0                	add    %edx,%eax
c0105323:	8b 00                	mov    (%eax),%eax
c0105325:	83 e0 01             	and    $0x1,%eax
c0105328:	85 c0                	test   %eax,%eax
c010532a:	74 dc                	je     c0105308 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c010532c:	8b 45 10             	mov    0x10(%ebp),%eax
c010532f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105332:	73 69                	jae    c010539d <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105334:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105338:	74 08                	je     c0105342 <get_pgtable_items+0x54>
            *left_store = start;
c010533a:	8b 45 18             	mov    0x18(%ebp),%eax
c010533d:	8b 55 10             	mov    0x10(%ebp),%edx
c0105340:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105342:	8b 45 10             	mov    0x10(%ebp),%eax
c0105345:	8d 50 01             	lea    0x1(%eax),%edx
c0105348:	89 55 10             	mov    %edx,0x10(%ebp)
c010534b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105352:	8b 45 14             	mov    0x14(%ebp),%eax
c0105355:	01 d0                	add    %edx,%eax
c0105357:	8b 00                	mov    (%eax),%eax
c0105359:	83 e0 07             	and    $0x7,%eax
c010535c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010535f:	eb 04                	jmp    c0105365 <get_pgtable_items+0x77>
            start ++;
c0105361:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105365:	8b 45 10             	mov    0x10(%ebp),%eax
c0105368:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010536b:	73 1d                	jae    c010538a <get_pgtable_items+0x9c>
c010536d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105370:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105377:	8b 45 14             	mov    0x14(%ebp),%eax
c010537a:	01 d0                	add    %edx,%eax
c010537c:	8b 00                	mov    (%eax),%eax
c010537e:	83 e0 07             	and    $0x7,%eax
c0105381:	89 c2                	mov    %eax,%edx
c0105383:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105386:	39 c2                	cmp    %eax,%edx
c0105388:	74 d7                	je     c0105361 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c010538a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010538e:	74 08                	je     c0105398 <get_pgtable_items+0xaa>
            *right_store = start;
c0105390:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105393:	8b 55 10             	mov    0x10(%ebp),%edx
c0105396:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105398:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010539b:	eb 05                	jmp    c01053a2 <get_pgtable_items+0xb4>
    }
    return 0;
c010539d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01053a2:	c9                   	leave  
c01053a3:	c3                   	ret    

c01053a4 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01053a4:	55                   	push   %ebp
c01053a5:	89 e5                	mov    %esp,%ebp
c01053a7:	57                   	push   %edi
c01053a8:	56                   	push   %esi
c01053a9:	53                   	push   %ebx
c01053aa:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01053ad:	c7 04 24 2c 71 10 c0 	movl   $0xc010712c,(%esp)
c01053b4:	e8 8f af ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
c01053b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01053c0:	e9 fa 00 00 00       	jmp    c01054bf <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01053c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053c8:	89 04 24             	mov    %eax,(%esp)
c01053cb:	e8 d0 fe ff ff       	call   c01052a0 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01053d0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01053d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053d6:	29 d1                	sub    %edx,%ecx
c01053d8:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01053da:	89 d6                	mov    %edx,%esi
c01053dc:	c1 e6 16             	shl    $0x16,%esi
c01053df:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053e2:	89 d3                	mov    %edx,%ebx
c01053e4:	c1 e3 16             	shl    $0x16,%ebx
c01053e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053ea:	89 d1                	mov    %edx,%ecx
c01053ec:	c1 e1 16             	shl    $0x16,%ecx
c01053ef:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01053f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053f5:	29 d7                	sub    %edx,%edi
c01053f7:	89 fa                	mov    %edi,%edx
c01053f9:	89 44 24 14          	mov    %eax,0x14(%esp)
c01053fd:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105401:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105405:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105409:	89 54 24 04          	mov    %edx,0x4(%esp)
c010540d:	c7 04 24 5d 71 10 c0 	movl   $0xc010715d,(%esp)
c0105414:	e8 2f af ff ff       	call   c0100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105419:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010541c:	c1 e0 0a             	shl    $0xa,%eax
c010541f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105422:	eb 54                	jmp    c0105478 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105427:	89 04 24             	mov    %eax,(%esp)
c010542a:	e8 71 fe ff ff       	call   c01052a0 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010542f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105432:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105435:	29 d1                	sub    %edx,%ecx
c0105437:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105439:	89 d6                	mov    %edx,%esi
c010543b:	c1 e6 0c             	shl    $0xc,%esi
c010543e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105441:	89 d3                	mov    %edx,%ebx
c0105443:	c1 e3 0c             	shl    $0xc,%ebx
c0105446:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105449:	c1 e2 0c             	shl    $0xc,%edx
c010544c:	89 d1                	mov    %edx,%ecx
c010544e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105451:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105454:	29 d7                	sub    %edx,%edi
c0105456:	89 fa                	mov    %edi,%edx
c0105458:	89 44 24 14          	mov    %eax,0x14(%esp)
c010545c:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105460:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105464:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105468:	89 54 24 04          	mov    %edx,0x4(%esp)
c010546c:	c7 04 24 7c 71 10 c0 	movl   $0xc010717c,(%esp)
c0105473:	e8 d0 ae ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105478:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010547d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105480:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105483:	89 ce                	mov    %ecx,%esi
c0105485:	c1 e6 0a             	shl    $0xa,%esi
c0105488:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010548b:	89 cb                	mov    %ecx,%ebx
c010548d:	c1 e3 0a             	shl    $0xa,%ebx
c0105490:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105493:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105497:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010549a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010549e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01054a2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054a6:	89 74 24 04          	mov    %esi,0x4(%esp)
c01054aa:	89 1c 24             	mov    %ebx,(%esp)
c01054ad:	e8 3c fe ff ff       	call   c01052ee <get_pgtable_items>
c01054b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01054b9:	0f 85 65 ff ff ff    	jne    c0105424 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01054bf:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01054c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054c7:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01054ca:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01054ce:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01054d1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01054d5:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01054d9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054dd:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01054e4:	00 
c01054e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01054ec:	e8 fd fd ff ff       	call   c01052ee <get_pgtable_items>
c01054f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01054f8:	0f 85 c7 fe ff ff    	jne    c01053c5 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01054fe:	c7 04 24 a0 71 10 c0 	movl   $0xc01071a0,(%esp)
c0105505:	e8 3e ae ff ff       	call   c0100348 <cprintf>
}
c010550a:	83 c4 4c             	add    $0x4c,%esp
c010550d:	5b                   	pop    %ebx
c010550e:	5e                   	pop    %esi
c010550f:	5f                   	pop    %edi
c0105510:	5d                   	pop    %ebp
c0105511:	c3                   	ret    

c0105512 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105512:	55                   	push   %ebp
c0105513:	89 e5                	mov    %esp,%ebp
c0105515:	83 ec 58             	sub    $0x58,%esp
c0105518:	8b 45 10             	mov    0x10(%ebp),%eax
c010551b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010551e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105521:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105524:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105527:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010552a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010552d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105530:	8b 45 18             	mov    0x18(%ebp),%eax
c0105533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105536:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105539:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010553c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010553f:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105542:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105545:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105548:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010554c:	74 1c                	je     c010556a <printnum+0x58>
c010554e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105551:	ba 00 00 00 00       	mov    $0x0,%edx
c0105556:	f7 75 e4             	divl   -0x1c(%ebp)
c0105559:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010555c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010555f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105564:	f7 75 e4             	divl   -0x1c(%ebp)
c0105567:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010556a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010556d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105570:	f7 75 e4             	divl   -0x1c(%ebp)
c0105573:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105576:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105579:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010557c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010557f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105582:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105585:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105588:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010558b:	8b 45 18             	mov    0x18(%ebp),%eax
c010558e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105593:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105596:	77 56                	ja     c01055ee <printnum+0xdc>
c0105598:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010559b:	72 05                	jb     c01055a2 <printnum+0x90>
c010559d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01055a0:	77 4c                	ja     c01055ee <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01055a2:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01055a5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01055a8:	8b 45 20             	mov    0x20(%ebp),%eax
c01055ab:	89 44 24 18          	mov    %eax,0x18(%esp)
c01055af:	89 54 24 14          	mov    %edx,0x14(%esp)
c01055b3:	8b 45 18             	mov    0x18(%ebp),%eax
c01055b6:	89 44 24 10          	mov    %eax,0x10(%esp)
c01055ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01055c0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01055c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d2:	89 04 24             	mov    %eax,(%esp)
c01055d5:	e8 38 ff ff ff       	call   c0105512 <printnum>
c01055da:	eb 1c                	jmp    c01055f8 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01055dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055e3:	8b 45 20             	mov    0x20(%ebp),%eax
c01055e6:	89 04 24             	mov    %eax,(%esp)
c01055e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ec:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01055ee:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01055f2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01055f6:	7f e4                	jg     c01055dc <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01055f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01055fb:	05 54 72 10 c0       	add    $0xc0107254,%eax
c0105600:	0f b6 00             	movzbl (%eax),%eax
c0105603:	0f be c0             	movsbl %al,%eax
c0105606:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105609:	89 54 24 04          	mov    %edx,0x4(%esp)
c010560d:	89 04 24             	mov    %eax,(%esp)
c0105610:	8b 45 08             	mov    0x8(%ebp),%eax
c0105613:	ff d0                	call   *%eax
}
c0105615:	c9                   	leave  
c0105616:	c3                   	ret    

c0105617 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105617:	55                   	push   %ebp
c0105618:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010561a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010561e:	7e 14                	jle    c0105634 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105620:	8b 45 08             	mov    0x8(%ebp),%eax
c0105623:	8b 00                	mov    (%eax),%eax
c0105625:	8d 48 08             	lea    0x8(%eax),%ecx
c0105628:	8b 55 08             	mov    0x8(%ebp),%edx
c010562b:	89 0a                	mov    %ecx,(%edx)
c010562d:	8b 50 04             	mov    0x4(%eax),%edx
c0105630:	8b 00                	mov    (%eax),%eax
c0105632:	eb 30                	jmp    c0105664 <getuint+0x4d>
    }
    else if (lflag) {
c0105634:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105638:	74 16                	je     c0105650 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010563a:	8b 45 08             	mov    0x8(%ebp),%eax
c010563d:	8b 00                	mov    (%eax),%eax
c010563f:	8d 48 04             	lea    0x4(%eax),%ecx
c0105642:	8b 55 08             	mov    0x8(%ebp),%edx
c0105645:	89 0a                	mov    %ecx,(%edx)
c0105647:	8b 00                	mov    (%eax),%eax
c0105649:	ba 00 00 00 00       	mov    $0x0,%edx
c010564e:	eb 14                	jmp    c0105664 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105650:	8b 45 08             	mov    0x8(%ebp),%eax
c0105653:	8b 00                	mov    (%eax),%eax
c0105655:	8d 48 04             	lea    0x4(%eax),%ecx
c0105658:	8b 55 08             	mov    0x8(%ebp),%edx
c010565b:	89 0a                	mov    %ecx,(%edx)
c010565d:	8b 00                	mov    (%eax),%eax
c010565f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105664:	5d                   	pop    %ebp
c0105665:	c3                   	ret    

c0105666 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105666:	55                   	push   %ebp
c0105667:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105669:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010566d:	7e 14                	jle    c0105683 <getint+0x1d>
        return va_arg(*ap, long long);
c010566f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105672:	8b 00                	mov    (%eax),%eax
c0105674:	8d 48 08             	lea    0x8(%eax),%ecx
c0105677:	8b 55 08             	mov    0x8(%ebp),%edx
c010567a:	89 0a                	mov    %ecx,(%edx)
c010567c:	8b 50 04             	mov    0x4(%eax),%edx
c010567f:	8b 00                	mov    (%eax),%eax
c0105681:	eb 28                	jmp    c01056ab <getint+0x45>
    }
    else if (lflag) {
c0105683:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105687:	74 12                	je     c010569b <getint+0x35>
        return va_arg(*ap, long);
c0105689:	8b 45 08             	mov    0x8(%ebp),%eax
c010568c:	8b 00                	mov    (%eax),%eax
c010568e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105691:	8b 55 08             	mov    0x8(%ebp),%edx
c0105694:	89 0a                	mov    %ecx,(%edx)
c0105696:	8b 00                	mov    (%eax),%eax
c0105698:	99                   	cltd   
c0105699:	eb 10                	jmp    c01056ab <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010569b:	8b 45 08             	mov    0x8(%ebp),%eax
c010569e:	8b 00                	mov    (%eax),%eax
c01056a0:	8d 48 04             	lea    0x4(%eax),%ecx
c01056a3:	8b 55 08             	mov    0x8(%ebp),%edx
c01056a6:	89 0a                	mov    %ecx,(%edx)
c01056a8:	8b 00                	mov    (%eax),%eax
c01056aa:	99                   	cltd   
    }
}
c01056ab:	5d                   	pop    %ebp
c01056ac:	c3                   	ret    

c01056ad <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01056ad:	55                   	push   %ebp
c01056ae:	89 e5                	mov    %esp,%ebp
c01056b0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01056b3:	8d 45 14             	lea    0x14(%ebp),%eax
c01056b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01056b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01056c0:	8b 45 10             	mov    0x10(%ebp),%eax
c01056c3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01056c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d1:	89 04 24             	mov    %eax,(%esp)
c01056d4:	e8 02 00 00 00       	call   c01056db <vprintfmt>
    va_end(ap);
}
c01056d9:	c9                   	leave  
c01056da:	c3                   	ret    

c01056db <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01056db:	55                   	push   %ebp
c01056dc:	89 e5                	mov    %esp,%ebp
c01056de:	56                   	push   %esi
c01056df:	53                   	push   %ebx
c01056e0:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01056e3:	eb 18                	jmp    c01056fd <vprintfmt+0x22>
            if (ch == '\0') {
c01056e5:	85 db                	test   %ebx,%ebx
c01056e7:	75 05                	jne    c01056ee <vprintfmt+0x13>
                return;
c01056e9:	e9 d1 03 00 00       	jmp    c0105abf <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01056ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056f5:	89 1c 24             	mov    %ebx,(%esp)
c01056f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01056fb:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01056fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0105700:	8d 50 01             	lea    0x1(%eax),%edx
c0105703:	89 55 10             	mov    %edx,0x10(%ebp)
c0105706:	0f b6 00             	movzbl (%eax),%eax
c0105709:	0f b6 d8             	movzbl %al,%ebx
c010570c:	83 fb 25             	cmp    $0x25,%ebx
c010570f:	75 d4                	jne    c01056e5 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105711:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105715:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010571c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010571f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105722:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105729:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010572c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010572f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105732:	8d 50 01             	lea    0x1(%eax),%edx
c0105735:	89 55 10             	mov    %edx,0x10(%ebp)
c0105738:	0f b6 00             	movzbl (%eax),%eax
c010573b:	0f b6 d8             	movzbl %al,%ebx
c010573e:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105741:	83 f8 55             	cmp    $0x55,%eax
c0105744:	0f 87 44 03 00 00    	ja     c0105a8e <vprintfmt+0x3b3>
c010574a:	8b 04 85 78 72 10 c0 	mov    -0x3fef8d88(,%eax,4),%eax
c0105751:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105753:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105757:	eb d6                	jmp    c010572f <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105759:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010575d:	eb d0                	jmp    c010572f <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010575f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105766:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105769:	89 d0                	mov    %edx,%eax
c010576b:	c1 e0 02             	shl    $0x2,%eax
c010576e:	01 d0                	add    %edx,%eax
c0105770:	01 c0                	add    %eax,%eax
c0105772:	01 d8                	add    %ebx,%eax
c0105774:	83 e8 30             	sub    $0x30,%eax
c0105777:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010577a:	8b 45 10             	mov    0x10(%ebp),%eax
c010577d:	0f b6 00             	movzbl (%eax),%eax
c0105780:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105783:	83 fb 2f             	cmp    $0x2f,%ebx
c0105786:	7e 0b                	jle    c0105793 <vprintfmt+0xb8>
c0105788:	83 fb 39             	cmp    $0x39,%ebx
c010578b:	7f 06                	jg     c0105793 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010578d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105791:	eb d3                	jmp    c0105766 <vprintfmt+0x8b>
            goto process_precision;
c0105793:	eb 33                	jmp    c01057c8 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105795:	8b 45 14             	mov    0x14(%ebp),%eax
c0105798:	8d 50 04             	lea    0x4(%eax),%edx
c010579b:	89 55 14             	mov    %edx,0x14(%ebp)
c010579e:	8b 00                	mov    (%eax),%eax
c01057a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01057a3:	eb 23                	jmp    c01057c8 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01057a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057a9:	79 0c                	jns    c01057b7 <vprintfmt+0xdc>
                width = 0;
c01057ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01057b2:	e9 78 ff ff ff       	jmp    c010572f <vprintfmt+0x54>
c01057b7:	e9 73 ff ff ff       	jmp    c010572f <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01057bc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01057c3:	e9 67 ff ff ff       	jmp    c010572f <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01057c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057cc:	79 12                	jns    c01057e0 <vprintfmt+0x105>
                width = precision, precision = -1;
c01057ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057d4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01057db:	e9 4f ff ff ff       	jmp    c010572f <vprintfmt+0x54>
c01057e0:	e9 4a ff ff ff       	jmp    c010572f <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01057e5:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01057e9:	e9 41 ff ff ff       	jmp    c010572f <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01057ee:	8b 45 14             	mov    0x14(%ebp),%eax
c01057f1:	8d 50 04             	lea    0x4(%eax),%edx
c01057f4:	89 55 14             	mov    %edx,0x14(%ebp)
c01057f7:	8b 00                	mov    (%eax),%eax
c01057f9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057fc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105800:	89 04 24             	mov    %eax,(%esp)
c0105803:	8b 45 08             	mov    0x8(%ebp),%eax
c0105806:	ff d0                	call   *%eax
            break;
c0105808:	e9 ac 02 00 00       	jmp    c0105ab9 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010580d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105810:	8d 50 04             	lea    0x4(%eax),%edx
c0105813:	89 55 14             	mov    %edx,0x14(%ebp)
c0105816:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105818:	85 db                	test   %ebx,%ebx
c010581a:	79 02                	jns    c010581e <vprintfmt+0x143>
                err = -err;
c010581c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010581e:	83 fb 06             	cmp    $0x6,%ebx
c0105821:	7f 0b                	jg     c010582e <vprintfmt+0x153>
c0105823:	8b 34 9d 38 72 10 c0 	mov    -0x3fef8dc8(,%ebx,4),%esi
c010582a:	85 f6                	test   %esi,%esi
c010582c:	75 23                	jne    c0105851 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010582e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105832:	c7 44 24 08 65 72 10 	movl   $0xc0107265,0x8(%esp)
c0105839:	c0 
c010583a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010583d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105841:	8b 45 08             	mov    0x8(%ebp),%eax
c0105844:	89 04 24             	mov    %eax,(%esp)
c0105847:	e8 61 fe ff ff       	call   c01056ad <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010584c:	e9 68 02 00 00       	jmp    c0105ab9 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105851:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105855:	c7 44 24 08 6e 72 10 	movl   $0xc010726e,0x8(%esp)
c010585c:	c0 
c010585d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105860:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105864:	8b 45 08             	mov    0x8(%ebp),%eax
c0105867:	89 04 24             	mov    %eax,(%esp)
c010586a:	e8 3e fe ff ff       	call   c01056ad <printfmt>
            }
            break;
c010586f:	e9 45 02 00 00       	jmp    c0105ab9 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105874:	8b 45 14             	mov    0x14(%ebp),%eax
c0105877:	8d 50 04             	lea    0x4(%eax),%edx
c010587a:	89 55 14             	mov    %edx,0x14(%ebp)
c010587d:	8b 30                	mov    (%eax),%esi
c010587f:	85 f6                	test   %esi,%esi
c0105881:	75 05                	jne    c0105888 <vprintfmt+0x1ad>
                p = "(null)";
c0105883:	be 71 72 10 c0       	mov    $0xc0107271,%esi
            }
            if (width > 0 && padc != '-') {
c0105888:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010588c:	7e 3e                	jle    c01058cc <vprintfmt+0x1f1>
c010588e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105892:	74 38                	je     c01058cc <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105894:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010589a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010589e:	89 34 24             	mov    %esi,(%esp)
c01058a1:	e8 15 03 00 00       	call   c0105bbb <strnlen>
c01058a6:	29 c3                	sub    %eax,%ebx
c01058a8:	89 d8                	mov    %ebx,%eax
c01058aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058ad:	eb 17                	jmp    c01058c6 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01058af:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01058b3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058b6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01058ba:	89 04 24             	mov    %eax,(%esp)
c01058bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01058c0:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01058c2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01058c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058ca:	7f e3                	jg     c01058af <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01058cc:	eb 38                	jmp    c0105906 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01058ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01058d2:	74 1f                	je     c01058f3 <vprintfmt+0x218>
c01058d4:	83 fb 1f             	cmp    $0x1f,%ebx
c01058d7:	7e 05                	jle    c01058de <vprintfmt+0x203>
c01058d9:	83 fb 7e             	cmp    $0x7e,%ebx
c01058dc:	7e 15                	jle    c01058f3 <vprintfmt+0x218>
                    putch('?', putdat);
c01058de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058e5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01058ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ef:	ff d0                	call   *%eax
c01058f1:	eb 0f                	jmp    c0105902 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01058f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058fa:	89 1c 24             	mov    %ebx,(%esp)
c01058fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105900:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105902:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105906:	89 f0                	mov    %esi,%eax
c0105908:	8d 70 01             	lea    0x1(%eax),%esi
c010590b:	0f b6 00             	movzbl (%eax),%eax
c010590e:	0f be d8             	movsbl %al,%ebx
c0105911:	85 db                	test   %ebx,%ebx
c0105913:	74 10                	je     c0105925 <vprintfmt+0x24a>
c0105915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105919:	78 b3                	js     c01058ce <vprintfmt+0x1f3>
c010591b:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010591f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105923:	79 a9                	jns    c01058ce <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105925:	eb 17                	jmp    c010593e <vprintfmt+0x263>
                putch(' ', putdat);
c0105927:	8b 45 0c             	mov    0xc(%ebp),%eax
c010592a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010592e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105935:	8b 45 08             	mov    0x8(%ebp),%eax
c0105938:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010593a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010593e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105942:	7f e3                	jg     c0105927 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105944:	e9 70 01 00 00       	jmp    c0105ab9 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105949:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010594c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105950:	8d 45 14             	lea    0x14(%ebp),%eax
c0105953:	89 04 24             	mov    %eax,(%esp)
c0105956:	e8 0b fd ff ff       	call   c0105666 <getint>
c010595b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010595e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105961:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105964:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105967:	85 d2                	test   %edx,%edx
c0105969:	79 26                	jns    c0105991 <vprintfmt+0x2b6>
                putch('-', putdat);
c010596b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010596e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105972:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105979:	8b 45 08             	mov    0x8(%ebp),%eax
c010597c:	ff d0                	call   *%eax
                num = -(long long)num;
c010597e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105981:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105984:	f7 d8                	neg    %eax
c0105986:	83 d2 00             	adc    $0x0,%edx
c0105989:	f7 da                	neg    %edx
c010598b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010598e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105991:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105998:	e9 a8 00 00 00       	jmp    c0105a45 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010599d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059a4:	8d 45 14             	lea    0x14(%ebp),%eax
c01059a7:	89 04 24             	mov    %eax,(%esp)
c01059aa:	e8 68 fc ff ff       	call   c0105617 <getuint>
c01059af:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01059b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01059bc:	e9 84 00 00 00       	jmp    c0105a45 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01059c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059c8:	8d 45 14             	lea    0x14(%ebp),%eax
c01059cb:	89 04 24             	mov    %eax,(%esp)
c01059ce:	e8 44 fc ff ff       	call   c0105617 <getuint>
c01059d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01059d9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01059e0:	eb 63                	jmp    c0105a45 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01059e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059e9:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01059f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f3:	ff d0                	call   *%eax
            putch('x', putdat);
c01059f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059fc:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a06:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105a08:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a0b:	8d 50 04             	lea    0x4(%eax),%edx
c0105a0e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a11:	8b 00                	mov    (%eax),%eax
c0105a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105a1d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105a24:	eb 1f                	jmp    c0105a45 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105a26:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a2d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a30:	89 04 24             	mov    %eax,(%esp)
c0105a33:	e8 df fb ff ff       	call   c0105617 <getuint>
c0105a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105a3e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105a45:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a4c:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105a50:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105a53:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105a57:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a61:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a65:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105a69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a70:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a73:	89 04 24             	mov    %eax,(%esp)
c0105a76:	e8 97 fa ff ff       	call   c0105512 <printnum>
            break;
c0105a7b:	eb 3c                	jmp    c0105ab9 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a80:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a84:	89 1c 24             	mov    %ebx,(%esp)
c0105a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8a:	ff d0                	call   *%eax
            break;
c0105a8c:	eb 2b                	jmp    c0105ab9 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a95:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105a9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a9f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105aa1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105aa5:	eb 04                	jmp    c0105aab <vprintfmt+0x3d0>
c0105aa7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105aab:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aae:	83 e8 01             	sub    $0x1,%eax
c0105ab1:	0f b6 00             	movzbl (%eax),%eax
c0105ab4:	3c 25                	cmp    $0x25,%al
c0105ab6:	75 ef                	jne    c0105aa7 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105ab8:	90                   	nop
        }
    }
c0105ab9:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105aba:	e9 3e fc ff ff       	jmp    c01056fd <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105abf:	83 c4 40             	add    $0x40,%esp
c0105ac2:	5b                   	pop    %ebx
c0105ac3:	5e                   	pop    %esi
c0105ac4:	5d                   	pop    %ebp
c0105ac5:	c3                   	ret    

c0105ac6 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105ac6:	55                   	push   %ebp
c0105ac7:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105acc:	8b 40 08             	mov    0x8(%eax),%eax
c0105acf:	8d 50 01             	lea    0x1(%eax),%edx
c0105ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ad5:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105adb:	8b 10                	mov    (%eax),%edx
c0105add:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ae0:	8b 40 04             	mov    0x4(%eax),%eax
c0105ae3:	39 c2                	cmp    %eax,%edx
c0105ae5:	73 12                	jae    c0105af9 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aea:	8b 00                	mov    (%eax),%eax
c0105aec:	8d 48 01             	lea    0x1(%eax),%ecx
c0105aef:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105af2:	89 0a                	mov    %ecx,(%edx)
c0105af4:	8b 55 08             	mov    0x8(%ebp),%edx
c0105af7:	88 10                	mov    %dl,(%eax)
    }
}
c0105af9:	5d                   	pop    %ebp
c0105afa:	c3                   	ret    

c0105afb <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105afb:	55                   	push   %ebp
c0105afc:	89 e5                	mov    %esp,%ebp
c0105afe:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105b01:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b0e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b11:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b1f:	89 04 24             	mov    %eax,(%esp)
c0105b22:	e8 08 00 00 00       	call   c0105b2f <vsnprintf>
c0105b27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b2d:	c9                   	leave  
c0105b2e:	c3                   	ret    

c0105b2f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105b2f:	55                   	push   %ebp
c0105b30:	89 e5                	mov    %esp,%ebp
c0105b32:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105b35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b38:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b3e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105b41:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b44:	01 d0                	add    %edx,%eax
c0105b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105b50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105b54:	74 0a                	je     c0105b60 <vsnprintf+0x31>
c0105b56:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b5c:	39 c2                	cmp    %eax,%edx
c0105b5e:	76 07                	jbe    c0105b67 <vsnprintf+0x38>
        return -E_INVAL;
c0105b60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105b65:	eb 2a                	jmp    c0105b91 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105b67:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b6e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b71:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b75:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105b78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b7c:	c7 04 24 c6 5a 10 c0 	movl   $0xc0105ac6,(%esp)
c0105b83:	e8 53 fb ff ff       	call   c01056db <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b8b:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b91:	c9                   	leave  
c0105b92:	c3                   	ret    

c0105b93 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105b93:	55                   	push   %ebp
c0105b94:	89 e5                	mov    %esp,%ebp
c0105b96:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105ba0:	eb 04                	jmp    c0105ba6 <strlen+0x13>
        cnt ++;
c0105ba2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba9:	8d 50 01             	lea    0x1(%eax),%edx
c0105bac:	89 55 08             	mov    %edx,0x8(%ebp)
c0105baf:	0f b6 00             	movzbl (%eax),%eax
c0105bb2:	84 c0                	test   %al,%al
c0105bb4:	75 ec                	jne    c0105ba2 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105bb9:	c9                   	leave  
c0105bba:	c3                   	ret    

c0105bbb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105bbb:	55                   	push   %ebp
c0105bbc:	89 e5                	mov    %esp,%ebp
c0105bbe:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105bc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105bc8:	eb 04                	jmp    c0105bce <strnlen+0x13>
        cnt ++;
c0105bca:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105bce:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105bd1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105bd4:	73 10                	jae    c0105be6 <strnlen+0x2b>
c0105bd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd9:	8d 50 01             	lea    0x1(%eax),%edx
c0105bdc:	89 55 08             	mov    %edx,0x8(%ebp)
c0105bdf:	0f b6 00             	movzbl (%eax),%eax
c0105be2:	84 c0                	test   %al,%al
c0105be4:	75 e4                	jne    c0105bca <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105be9:	c9                   	leave  
c0105bea:	c3                   	ret    

c0105beb <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105beb:	55                   	push   %ebp
c0105bec:	89 e5                	mov    %esp,%ebp
c0105bee:	57                   	push   %edi
c0105bef:	56                   	push   %esi
c0105bf0:	83 ec 20             	sub    $0x20,%esp
c0105bf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105bff:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c05:	89 d1                	mov    %edx,%ecx
c0105c07:	89 c2                	mov    %eax,%edx
c0105c09:	89 ce                	mov    %ecx,%esi
c0105c0b:	89 d7                	mov    %edx,%edi
c0105c0d:	ac                   	lods   %ds:(%esi),%al
c0105c0e:	aa                   	stos   %al,%es:(%edi)
c0105c0f:	84 c0                	test   %al,%al
c0105c11:	75 fa                	jne    c0105c0d <strcpy+0x22>
c0105c13:	89 fa                	mov    %edi,%edx
c0105c15:	89 f1                	mov    %esi,%ecx
c0105c17:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105c1a:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105c1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105c23:	83 c4 20             	add    $0x20,%esp
c0105c26:	5e                   	pop    %esi
c0105c27:	5f                   	pop    %edi
c0105c28:	5d                   	pop    %ebp
c0105c29:	c3                   	ret    

c0105c2a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105c2a:	55                   	push   %ebp
c0105c2b:	89 e5                	mov    %esp,%ebp
c0105c2d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105c36:	eb 21                	jmp    c0105c59 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105c38:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c3b:	0f b6 10             	movzbl (%eax),%edx
c0105c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c41:	88 10                	mov    %dl,(%eax)
c0105c43:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c46:	0f b6 00             	movzbl (%eax),%eax
c0105c49:	84 c0                	test   %al,%al
c0105c4b:	74 04                	je     c0105c51 <strncpy+0x27>
            src ++;
c0105c4d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105c51:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105c55:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105c59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c5d:	75 d9                	jne    c0105c38 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105c5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c62:	c9                   	leave  
c0105c63:	c3                   	ret    

c0105c64 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105c64:	55                   	push   %ebp
c0105c65:	89 e5                	mov    %esp,%ebp
c0105c67:	57                   	push   %edi
c0105c68:	56                   	push   %esi
c0105c69:	83 ec 20             	sub    $0x20,%esp
c0105c6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105c78:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c7e:	89 d1                	mov    %edx,%ecx
c0105c80:	89 c2                	mov    %eax,%edx
c0105c82:	89 ce                	mov    %ecx,%esi
c0105c84:	89 d7                	mov    %edx,%edi
c0105c86:	ac                   	lods   %ds:(%esi),%al
c0105c87:	ae                   	scas   %es:(%edi),%al
c0105c88:	75 08                	jne    c0105c92 <strcmp+0x2e>
c0105c8a:	84 c0                	test   %al,%al
c0105c8c:	75 f8                	jne    c0105c86 <strcmp+0x22>
c0105c8e:	31 c0                	xor    %eax,%eax
c0105c90:	eb 04                	jmp    c0105c96 <strcmp+0x32>
c0105c92:	19 c0                	sbb    %eax,%eax
c0105c94:	0c 01                	or     $0x1,%al
c0105c96:	89 fa                	mov    %edi,%edx
c0105c98:	89 f1                	mov    %esi,%ecx
c0105c9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c9d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105ca0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105ca6:	83 c4 20             	add    $0x20,%esp
c0105ca9:	5e                   	pop    %esi
c0105caa:	5f                   	pop    %edi
c0105cab:	5d                   	pop    %ebp
c0105cac:	c3                   	ret    

c0105cad <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105cad:	55                   	push   %ebp
c0105cae:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105cb0:	eb 0c                	jmp    c0105cbe <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105cb2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105cb6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cba:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105cbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cc2:	74 1a                	je     c0105cde <strncmp+0x31>
c0105cc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc7:	0f b6 00             	movzbl (%eax),%eax
c0105cca:	84 c0                	test   %al,%al
c0105ccc:	74 10                	je     c0105cde <strncmp+0x31>
c0105cce:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd1:	0f b6 10             	movzbl (%eax),%edx
c0105cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cd7:	0f b6 00             	movzbl (%eax),%eax
c0105cda:	38 c2                	cmp    %al,%dl
c0105cdc:	74 d4                	je     c0105cb2 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ce2:	74 18                	je     c0105cfc <strncmp+0x4f>
c0105ce4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce7:	0f b6 00             	movzbl (%eax),%eax
c0105cea:	0f b6 d0             	movzbl %al,%edx
c0105ced:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cf0:	0f b6 00             	movzbl (%eax),%eax
c0105cf3:	0f b6 c0             	movzbl %al,%eax
c0105cf6:	29 c2                	sub    %eax,%edx
c0105cf8:	89 d0                	mov    %edx,%eax
c0105cfa:	eb 05                	jmp    c0105d01 <strncmp+0x54>
c0105cfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d01:	5d                   	pop    %ebp
c0105d02:	c3                   	ret    

c0105d03 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105d03:	55                   	push   %ebp
c0105d04:	89 e5                	mov    %esp,%ebp
c0105d06:	83 ec 04             	sub    $0x4,%esp
c0105d09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d0c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105d0f:	eb 14                	jmp    c0105d25 <strchr+0x22>
        if (*s == c) {
c0105d11:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d14:	0f b6 00             	movzbl (%eax),%eax
c0105d17:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105d1a:	75 05                	jne    c0105d21 <strchr+0x1e>
            return (char *)s;
c0105d1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d1f:	eb 13                	jmp    c0105d34 <strchr+0x31>
        }
        s ++;
c0105d21:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105d25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d28:	0f b6 00             	movzbl (%eax),%eax
c0105d2b:	84 c0                	test   %al,%al
c0105d2d:	75 e2                	jne    c0105d11 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105d2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d34:	c9                   	leave  
c0105d35:	c3                   	ret    

c0105d36 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105d36:	55                   	push   %ebp
c0105d37:	89 e5                	mov    %esp,%ebp
c0105d39:	83 ec 04             	sub    $0x4,%esp
c0105d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d3f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105d42:	eb 11                	jmp    c0105d55 <strfind+0x1f>
        if (*s == c) {
c0105d44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d47:	0f b6 00             	movzbl (%eax),%eax
c0105d4a:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105d4d:	75 02                	jne    c0105d51 <strfind+0x1b>
            break;
c0105d4f:	eb 0e                	jmp    c0105d5f <strfind+0x29>
        }
        s ++;
c0105d51:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105d55:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d58:	0f b6 00             	movzbl (%eax),%eax
c0105d5b:	84 c0                	test   %al,%al
c0105d5d:	75 e5                	jne    c0105d44 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105d5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105d62:	c9                   	leave  
c0105d63:	c3                   	ret    

c0105d64 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105d64:	55                   	push   %ebp
c0105d65:	89 e5                	mov    %esp,%ebp
c0105d67:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105d6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105d71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105d78:	eb 04                	jmp    c0105d7e <strtol+0x1a>
        s ++;
c0105d7a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105d7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d81:	0f b6 00             	movzbl (%eax),%eax
c0105d84:	3c 20                	cmp    $0x20,%al
c0105d86:	74 f2                	je     c0105d7a <strtol+0x16>
c0105d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8b:	0f b6 00             	movzbl (%eax),%eax
c0105d8e:	3c 09                	cmp    $0x9,%al
c0105d90:	74 e8                	je     c0105d7a <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105d92:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d95:	0f b6 00             	movzbl (%eax),%eax
c0105d98:	3c 2b                	cmp    $0x2b,%al
c0105d9a:	75 06                	jne    c0105da2 <strtol+0x3e>
        s ++;
c0105d9c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105da0:	eb 15                	jmp    c0105db7 <strtol+0x53>
    }
    else if (*s == '-') {
c0105da2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da5:	0f b6 00             	movzbl (%eax),%eax
c0105da8:	3c 2d                	cmp    $0x2d,%al
c0105daa:	75 0b                	jne    c0105db7 <strtol+0x53>
        s ++, neg = 1;
c0105dac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105db0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105db7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105dbb:	74 06                	je     c0105dc3 <strtol+0x5f>
c0105dbd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105dc1:	75 24                	jne    c0105de7 <strtol+0x83>
c0105dc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc6:	0f b6 00             	movzbl (%eax),%eax
c0105dc9:	3c 30                	cmp    $0x30,%al
c0105dcb:	75 1a                	jne    c0105de7 <strtol+0x83>
c0105dcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd0:	83 c0 01             	add    $0x1,%eax
c0105dd3:	0f b6 00             	movzbl (%eax),%eax
c0105dd6:	3c 78                	cmp    $0x78,%al
c0105dd8:	75 0d                	jne    c0105de7 <strtol+0x83>
        s += 2, base = 16;
c0105dda:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105dde:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105de5:	eb 2a                	jmp    c0105e11 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105de7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105deb:	75 17                	jne    c0105e04 <strtol+0xa0>
c0105ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df0:	0f b6 00             	movzbl (%eax),%eax
c0105df3:	3c 30                	cmp    $0x30,%al
c0105df5:	75 0d                	jne    c0105e04 <strtol+0xa0>
        s ++, base = 8;
c0105df7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105dfb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105e02:	eb 0d                	jmp    c0105e11 <strtol+0xad>
    }
    else if (base == 0) {
c0105e04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e08:	75 07                	jne    c0105e11 <strtol+0xad>
        base = 10;
c0105e0a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105e11:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e14:	0f b6 00             	movzbl (%eax),%eax
c0105e17:	3c 2f                	cmp    $0x2f,%al
c0105e19:	7e 1b                	jle    c0105e36 <strtol+0xd2>
c0105e1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e1e:	0f b6 00             	movzbl (%eax),%eax
c0105e21:	3c 39                	cmp    $0x39,%al
c0105e23:	7f 11                	jg     c0105e36 <strtol+0xd2>
            dig = *s - '0';
c0105e25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e28:	0f b6 00             	movzbl (%eax),%eax
c0105e2b:	0f be c0             	movsbl %al,%eax
c0105e2e:	83 e8 30             	sub    $0x30,%eax
c0105e31:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e34:	eb 48                	jmp    c0105e7e <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105e36:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e39:	0f b6 00             	movzbl (%eax),%eax
c0105e3c:	3c 60                	cmp    $0x60,%al
c0105e3e:	7e 1b                	jle    c0105e5b <strtol+0xf7>
c0105e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e43:	0f b6 00             	movzbl (%eax),%eax
c0105e46:	3c 7a                	cmp    $0x7a,%al
c0105e48:	7f 11                	jg     c0105e5b <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105e4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e4d:	0f b6 00             	movzbl (%eax),%eax
c0105e50:	0f be c0             	movsbl %al,%eax
c0105e53:	83 e8 57             	sub    $0x57,%eax
c0105e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e59:	eb 23                	jmp    c0105e7e <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105e5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e5e:	0f b6 00             	movzbl (%eax),%eax
c0105e61:	3c 40                	cmp    $0x40,%al
c0105e63:	7e 3d                	jle    c0105ea2 <strtol+0x13e>
c0105e65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e68:	0f b6 00             	movzbl (%eax),%eax
c0105e6b:	3c 5a                	cmp    $0x5a,%al
c0105e6d:	7f 33                	jg     c0105ea2 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105e6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e72:	0f b6 00             	movzbl (%eax),%eax
c0105e75:	0f be c0             	movsbl %al,%eax
c0105e78:	83 e8 37             	sub    $0x37,%eax
c0105e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e81:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105e84:	7c 02                	jl     c0105e88 <strtol+0x124>
            break;
c0105e86:	eb 1a                	jmp    c0105ea2 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105e88:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e8f:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105e93:	89 c2                	mov    %eax,%edx
c0105e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e98:	01 d0                	add    %edx,%eax
c0105e9a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105e9d:	e9 6f ff ff ff       	jmp    c0105e11 <strtol+0xad>

    if (endptr) {
c0105ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105ea6:	74 08                	je     c0105eb0 <strtol+0x14c>
        *endptr = (char *) s;
c0105ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105eab:	8b 55 08             	mov    0x8(%ebp),%edx
c0105eae:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105eb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105eb4:	74 07                	je     c0105ebd <strtol+0x159>
c0105eb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105eb9:	f7 d8                	neg    %eax
c0105ebb:	eb 03                	jmp    c0105ec0 <strtol+0x15c>
c0105ebd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105ec0:	c9                   	leave  
c0105ec1:	c3                   	ret    

c0105ec2 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105ec2:	55                   	push   %ebp
c0105ec3:	89 e5                	mov    %esp,%ebp
c0105ec5:	57                   	push   %edi
c0105ec6:	83 ec 24             	sub    $0x24,%esp
c0105ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ecc:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105ecf:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105ed3:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ed6:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105ed9:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105edc:	8b 45 10             	mov    0x10(%ebp),%eax
c0105edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105ee2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105ee5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105ee9:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105eec:	89 d7                	mov    %edx,%edi
c0105eee:	f3 aa                	rep stos %al,%es:(%edi)
c0105ef0:	89 fa                	mov    %edi,%edx
c0105ef2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105ef5:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105efb:	83 c4 24             	add    $0x24,%esp
c0105efe:	5f                   	pop    %edi
c0105eff:	5d                   	pop    %ebp
c0105f00:	c3                   	ret    

c0105f01 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105f01:	55                   	push   %ebp
c0105f02:	89 e5                	mov    %esp,%ebp
c0105f04:	57                   	push   %edi
c0105f05:	56                   	push   %esi
c0105f06:	53                   	push   %ebx
c0105f07:	83 ec 30             	sub    $0x30,%esp
c0105f0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f13:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105f16:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f19:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f1f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105f22:	73 42                	jae    c0105f66 <memmove+0x65>
c0105f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105f2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105f30:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f33:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105f36:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f39:	c1 e8 02             	shr    $0x2,%eax
c0105f3c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105f3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f44:	89 d7                	mov    %edx,%edi
c0105f46:	89 c6                	mov    %eax,%esi
c0105f48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f4a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105f4d:	83 e1 03             	and    $0x3,%ecx
c0105f50:	74 02                	je     c0105f54 <memmove+0x53>
c0105f52:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f54:	89 f0                	mov    %esi,%eax
c0105f56:	89 fa                	mov    %edi,%edx
c0105f58:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105f5b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105f5e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f64:	eb 36                	jmp    c0105f9c <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105f66:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f69:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f6f:	01 c2                	add    %eax,%edx
c0105f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f74:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f7a:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105f7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f80:	89 c1                	mov    %eax,%ecx
c0105f82:	89 d8                	mov    %ebx,%eax
c0105f84:	89 d6                	mov    %edx,%esi
c0105f86:	89 c7                	mov    %eax,%edi
c0105f88:	fd                   	std    
c0105f89:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f8b:	fc                   	cld    
c0105f8c:	89 f8                	mov    %edi,%eax
c0105f8e:	89 f2                	mov    %esi,%edx
c0105f90:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105f93:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105f96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105f9c:	83 c4 30             	add    $0x30,%esp
c0105f9f:	5b                   	pop    %ebx
c0105fa0:	5e                   	pop    %esi
c0105fa1:	5f                   	pop    %edi
c0105fa2:	5d                   	pop    %ebp
c0105fa3:	c3                   	ret    

c0105fa4 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105fa4:	55                   	push   %ebp
c0105fa5:	89 e5                	mov    %esp,%ebp
c0105fa7:	57                   	push   %edi
c0105fa8:	56                   	push   %esi
c0105fa9:	83 ec 20             	sub    $0x20,%esp
c0105fac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105faf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fb8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105fbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fc1:	c1 e8 02             	shr    $0x2,%eax
c0105fc4:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105fc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fcc:	89 d7                	mov    %edx,%edi
c0105fce:	89 c6                	mov    %eax,%esi
c0105fd0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105fd2:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105fd5:	83 e1 03             	and    $0x3,%ecx
c0105fd8:	74 02                	je     c0105fdc <memcpy+0x38>
c0105fda:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105fdc:	89 f0                	mov    %esi,%eax
c0105fde:	89 fa                	mov    %edi,%edx
c0105fe0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105fe3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105fe6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105fec:	83 c4 20             	add    $0x20,%esp
c0105fef:	5e                   	pop    %esi
c0105ff0:	5f                   	pop    %edi
c0105ff1:	5d                   	pop    %ebp
c0105ff2:	c3                   	ret    

c0105ff3 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105ff3:	55                   	push   %ebp
c0105ff4:	89 e5                	mov    %esp,%ebp
c0105ff6:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105ff9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105fff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106002:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0106005:	eb 30                	jmp    c0106037 <memcmp+0x44>
        if (*s1 != *s2) {
c0106007:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010600a:	0f b6 10             	movzbl (%eax),%edx
c010600d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106010:	0f b6 00             	movzbl (%eax),%eax
c0106013:	38 c2                	cmp    %al,%dl
c0106015:	74 18                	je     c010602f <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106017:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010601a:	0f b6 00             	movzbl (%eax),%eax
c010601d:	0f b6 d0             	movzbl %al,%edx
c0106020:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106023:	0f b6 00             	movzbl (%eax),%eax
c0106026:	0f b6 c0             	movzbl %al,%eax
c0106029:	29 c2                	sub    %eax,%edx
c010602b:	89 d0                	mov    %edx,%eax
c010602d:	eb 1a                	jmp    c0106049 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010602f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0106033:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0106037:	8b 45 10             	mov    0x10(%ebp),%eax
c010603a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010603d:	89 55 10             	mov    %edx,0x10(%ebp)
c0106040:	85 c0                	test   %eax,%eax
c0106042:	75 c3                	jne    c0106007 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0106044:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106049:	c9                   	leave  
c010604a:	c3                   	ret    
