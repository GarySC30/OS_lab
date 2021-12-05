
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 10 12 00       	mov    $0x121000,%eax
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
c0100020:	a3 00 10 12 c0       	mov    %eax,0xc0121000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 00 12 c0       	mov    $0xc0120000,%esp
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
c010003c:	ba 30 41 12 c0       	mov    $0xc0124130,%edx
c0100041:	b8 00 30 12 c0       	mov    $0xc0123000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 30 12 c0 	movl   $0xc0123000,(%esp)
c010005d:	e8 cb 8a 00 00       	call   c0108b2d <memset>

    cons_init();                // init the console
c0100062:	e8 91 15 00 00       	call   c01015f8 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 c0 8c 10 c0 	movl   $0xc0108cc0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 dc 8c 10 c0 	movl   $0xc0108cdc,(%esp)
c010007c:	e8 d6 02 00 00       	call   c0100357 <cprintf>

    print_kerninfo();
c0100081:	e8 05 08 00 00       	call   c010088b <print_kerninfo>

    grade_backtrace();
c0100086:	e8 95 00 00 00       	call   c0100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 8c 4c 00 00       	call   c0104d1c <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 41 1f 00 00       	call   c0101fd6 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 93 20 00 00       	call   c010212d <idt_init>

    vmm_init();                 // init virtual memory management
c010009a:	e8 d7 74 00 00       	call   c0107576 <vmm_init>

    ide_init();                 // init ide devices
c010009f:	e8 85 16 00 00       	call   c0101729 <ide_init>
    swap_init();                // init swap
c01000a4:	e8 e0 5f 00 00       	call   c0106089 <swap_init>

    clock_init();               // init clock interrupt
c01000a9:	e8 00 0d 00 00       	call   c0100dae <clock_init>
    intr_enable();              // enable irq interrupt
c01000ae:	e8 91 1e 00 00       	call   c0101f44 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000b3:	eb fe                	jmp    c01000b3 <kern_init+0x7d>

c01000b5 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b5:	55                   	push   %ebp
c01000b6:	89 e5                	mov    %esp,%ebp
c01000b8:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000c2:	00 
c01000c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000ca:	00 
c01000cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000d2:	e8 f8 0b 00 00       	call   c0100ccf <mon_backtrace>
}
c01000d7:	c9                   	leave  
c01000d8:	c3                   	ret    

c01000d9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d9:	55                   	push   %ebp
c01000da:	89 e5                	mov    %esp,%ebp
c01000dc:	53                   	push   %ebx
c01000dd:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e6:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000f0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f8:	89 04 24             	mov    %eax,(%esp)
c01000fb:	e8 b5 ff ff ff       	call   c01000b5 <grade_backtrace2>
}
c0100100:	83 c4 14             	add    $0x14,%esp
c0100103:	5b                   	pop    %ebx
c0100104:	5d                   	pop    %ebp
c0100105:	c3                   	ret    

c0100106 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100106:	55                   	push   %ebp
c0100107:	89 e5                	mov    %esp,%ebp
c0100109:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010c:	8b 45 10             	mov    0x10(%ebp),%eax
c010010f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100113:	8b 45 08             	mov    0x8(%ebp),%eax
c0100116:	89 04 24             	mov    %eax,(%esp)
c0100119:	e8 bb ff ff ff       	call   c01000d9 <grade_backtrace1>
}
c010011e:	c9                   	leave  
c010011f:	c3                   	ret    

c0100120 <grade_backtrace>:

void
grade_backtrace(void) {
c0100120:	55                   	push   %ebp
c0100121:	89 e5                	mov    %esp,%ebp
c0100123:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100126:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010012b:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100132:	ff 
c0100133:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013e:	e8 c3 ff ff ff       	call   c0100106 <grade_backtrace0>
}
c0100143:	c9                   	leave  
c0100144:	c3                   	ret    

c0100145 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100145:	55                   	push   %ebp
c0100146:	89 e5                	mov    %esp,%ebp
c0100148:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010014b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100151:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100154:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100157:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010015b:	0f b7 c0             	movzwl %ax,%eax
c010015e:	83 e0 03             	and    $0x3,%eax
c0100161:	89 c2                	mov    %eax,%edx
c0100163:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100168:	89 54 24 08          	mov    %edx,0x8(%esp)
c010016c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100170:	c7 04 24 e1 8c 10 c0 	movl   $0xc0108ce1,(%esp)
c0100177:	e8 db 01 00 00       	call   c0100357 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010017c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100180:	0f b7 d0             	movzwl %ax,%edx
c0100183:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100188:	89 54 24 08          	mov    %edx,0x8(%esp)
c010018c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100190:	c7 04 24 ef 8c 10 c0 	movl   $0xc0108cef,(%esp)
c0100197:	e8 bb 01 00 00       	call   c0100357 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010019c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a0:	0f b7 d0             	movzwl %ax,%edx
c01001a3:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b0:	c7 04 24 fd 8c 10 c0 	movl   $0xc0108cfd,(%esp)
c01001b7:	e8 9b 01 00 00       	call   c0100357 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001bc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c0:	0f b7 d0             	movzwl %ax,%edx
c01001c3:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001c8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d0:	c7 04 24 0b 8d 10 c0 	movl   $0xc0108d0b,(%esp)
c01001d7:	e8 7b 01 00 00       	call   c0100357 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001dc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e0:	0f b7 d0             	movzwl %ax,%edx
c01001e3:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001e8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f0:	c7 04 24 19 8d 10 c0 	movl   $0xc0108d19,(%esp)
c01001f7:	e8 5b 01 00 00       	call   c0100357 <cprintf>
    round ++;
c01001fc:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100201:	83 c0 01             	add    $0x1,%eax
c0100204:	a3 00 30 12 c0       	mov    %eax,0xc0123000
}
c0100209:	c9                   	leave  
c010020a:	c3                   	ret    

c010020b <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020b:	55                   	push   %ebp
c010020c:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020e:	5d                   	pop    %ebp
c010020f:	c3                   	ret    

c0100210 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100210:	55                   	push   %ebp
c0100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100213:	5d                   	pop    %ebp
c0100214:	c3                   	ret    

c0100215 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100215:	55                   	push   %ebp
c0100216:	89 e5                	mov    %esp,%ebp
c0100218:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010021b:	e8 25 ff ff ff       	call   c0100145 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100220:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0100227:	e8 2b 01 00 00       	call   c0100357 <cprintf>
    lab1_switch_to_user();
c010022c:	e8 da ff ff ff       	call   c010020b <lab1_switch_to_user>
    lab1_print_cur_status();
c0100231:	e8 0f ff ff ff       	call   c0100145 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100236:	c7 04 24 48 8d 10 c0 	movl   $0xc0108d48,(%esp)
c010023d:	e8 15 01 00 00       	call   c0100357 <cprintf>
    lab1_switch_to_kernel();
c0100242:	e8 c9 ff ff ff       	call   c0100210 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100247:	e8 f9 fe ff ff       	call   c0100145 <lab1_print_cur_status>
}
c010024c:	c9                   	leave  
c010024d:	c3                   	ret    

c010024e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010024e:	55                   	push   %ebp
c010024f:	89 e5                	mov    %esp,%ebp
c0100251:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100254:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100258:	74 13                	je     c010026d <readline+0x1f>
        cprintf("%s", prompt);
c010025a:	8b 45 08             	mov    0x8(%ebp),%eax
c010025d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100261:	c7 04 24 67 8d 10 c0 	movl   $0xc0108d67,(%esp)
c0100268:	e8 ea 00 00 00       	call   c0100357 <cprintf>
    }
    int i = 0, c;
c010026d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100274:	e8 66 01 00 00       	call   c01003df <getchar>
c0100279:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010027c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100280:	79 07                	jns    c0100289 <readline+0x3b>
            return NULL;
c0100282:	b8 00 00 00 00       	mov    $0x0,%eax
c0100287:	eb 79                	jmp    c0100302 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100289:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010028d:	7e 28                	jle    c01002b7 <readline+0x69>
c010028f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100296:	7f 1f                	jg     c01002b7 <readline+0x69>
            cputchar(c);
c0100298:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010029b:	89 04 24             	mov    %eax,(%esp)
c010029e:	e8 da 00 00 00       	call   c010037d <cputchar>
            buf[i ++] = c;
c01002a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002a6:	8d 50 01             	lea    0x1(%eax),%edx
c01002a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002af:	88 90 20 30 12 c0    	mov    %dl,-0x3fedcfe0(%eax)
c01002b5:	eb 46                	jmp    c01002fd <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002b7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002bb:	75 17                	jne    c01002d4 <readline+0x86>
c01002bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002c1:	7e 11                	jle    c01002d4 <readline+0x86>
            cputchar(c);
c01002c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c6:	89 04 24             	mov    %eax,(%esp)
c01002c9:	e8 af 00 00 00       	call   c010037d <cputchar>
            i --;
c01002ce:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002d2:	eb 29                	jmp    c01002fd <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002d4:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d8:	74 06                	je     c01002e0 <readline+0x92>
c01002da:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002de:	75 1d                	jne    c01002fd <readline+0xaf>
            cputchar(c);
c01002e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002e3:	89 04 24             	mov    %eax,(%esp)
c01002e6:	e8 92 00 00 00       	call   c010037d <cputchar>
            buf[i] = '\0';
c01002eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ee:	05 20 30 12 c0       	add    $0xc0123020,%eax
c01002f3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f6:	b8 20 30 12 c0       	mov    $0xc0123020,%eax
c01002fb:	eb 05                	jmp    c0100302 <readline+0xb4>
        }
    }
c01002fd:	e9 72 ff ff ff       	jmp    c0100274 <readline+0x26>
}
c0100302:	c9                   	leave  
c0100303:	c3                   	ret    

c0100304 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100304:	55                   	push   %ebp
c0100305:	89 e5                	mov    %esp,%ebp
c0100307:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010030a:	8b 45 08             	mov    0x8(%ebp),%eax
c010030d:	89 04 24             	mov    %eax,(%esp)
c0100310:	e8 0f 13 00 00       	call   c0101624 <cons_putc>
    (*cnt) ++;
c0100315:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100318:	8b 00                	mov    (%eax),%eax
c010031a:	8d 50 01             	lea    0x1(%eax),%edx
c010031d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100320:	89 10                	mov    %edx,(%eax)
}
c0100322:	c9                   	leave  
c0100323:	c3                   	ret    

c0100324 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100324:	55                   	push   %ebp
c0100325:	89 e5                	mov    %esp,%ebp
c0100327:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010032a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100331:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100334:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100338:	8b 45 08             	mov    0x8(%ebp),%eax
c010033b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033f:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100342:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100346:	c7 04 24 04 03 10 c0 	movl   $0xc0100304,(%esp)
c010034d:	e8 1c 7f 00 00       	call   c010826e <vprintfmt>
    return cnt;
c0100352:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100355:	c9                   	leave  
c0100356:	c3                   	ret    

c0100357 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100357:	55                   	push   %ebp
c0100358:	89 e5                	mov    %esp,%ebp
c010035a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010035d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100360:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100363:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100366:	89 44 24 04          	mov    %eax,0x4(%esp)
c010036a:	8b 45 08             	mov    0x8(%ebp),%eax
c010036d:	89 04 24             	mov    %eax,(%esp)
c0100370:	e8 af ff ff ff       	call   c0100324 <vcprintf>
c0100375:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100378:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010037b:	c9                   	leave  
c010037c:	c3                   	ret    

c010037d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010037d:	55                   	push   %ebp
c010037e:	89 e5                	mov    %esp,%ebp
c0100380:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100383:	8b 45 08             	mov    0x8(%ebp),%eax
c0100386:	89 04 24             	mov    %eax,(%esp)
c0100389:	e8 96 12 00 00       	call   c0101624 <cons_putc>
}
c010038e:	c9                   	leave  
c010038f:	c3                   	ret    

c0100390 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100390:	55                   	push   %ebp
c0100391:	89 e5                	mov    %esp,%ebp
c0100393:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100396:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010039d:	eb 13                	jmp    c01003b2 <cputs+0x22>
        cputch(c, &cnt);
c010039f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003a3:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003a6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003aa:	89 04 24             	mov    %eax,(%esp)
c01003ad:	e8 52 ff ff ff       	call   c0100304 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b5:	8d 50 01             	lea    0x1(%eax),%edx
c01003b8:	89 55 08             	mov    %edx,0x8(%ebp)
c01003bb:	0f b6 00             	movzbl (%eax),%eax
c01003be:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003c1:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c5:	75 d8                	jne    c010039f <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003ce:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d5:	e8 2a ff ff ff       	call   c0100304 <cputch>
    return cnt;
c01003da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003dd:	c9                   	leave  
c01003de:	c3                   	ret    

c01003df <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003df:	55                   	push   %ebp
c01003e0:	89 e5                	mov    %esp,%ebp
c01003e2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003e5:	e8 76 12 00 00       	call   c0101660 <cons_getc>
c01003ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003f1:	74 f2                	je     c01003e5 <getchar+0x6>
        /* do nothing */;
    return c;
c01003f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003f6:	c9                   	leave  
c01003f7:	c3                   	ret    

c01003f8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003f8:	55                   	push   %ebp
c01003f9:	89 e5                	mov    %esp,%ebp
c01003fb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100401:	8b 00                	mov    (%eax),%eax
c0100403:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100406:	8b 45 10             	mov    0x10(%ebp),%eax
c0100409:	8b 00                	mov    (%eax),%eax
c010040b:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010040e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100415:	e9 d2 00 00 00       	jmp    c01004ec <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010041a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010041d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100420:	01 d0                	add    %edx,%eax
c0100422:	89 c2                	mov    %eax,%edx
c0100424:	c1 ea 1f             	shr    $0x1f,%edx
c0100427:	01 d0                	add    %edx,%eax
c0100429:	d1 f8                	sar    %eax
c010042b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010042e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100431:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100434:	eb 04                	jmp    c010043a <stab_binsearch+0x42>
            m --;
c0100436:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010043a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010043d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100440:	7c 1f                	jl     c0100461 <stab_binsearch+0x69>
c0100442:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100445:	89 d0                	mov    %edx,%eax
c0100447:	01 c0                	add    %eax,%eax
c0100449:	01 d0                	add    %edx,%eax
c010044b:	c1 e0 02             	shl    $0x2,%eax
c010044e:	89 c2                	mov    %eax,%edx
c0100450:	8b 45 08             	mov    0x8(%ebp),%eax
c0100453:	01 d0                	add    %edx,%eax
c0100455:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100459:	0f b6 c0             	movzbl %al,%eax
c010045c:	3b 45 14             	cmp    0x14(%ebp),%eax
c010045f:	75 d5                	jne    c0100436 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100461:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100464:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100467:	7d 0b                	jge    c0100474 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100469:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010046c:	83 c0 01             	add    $0x1,%eax
c010046f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100472:	eb 78                	jmp    c01004ec <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100474:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010047b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047e:	89 d0                	mov    %edx,%eax
c0100480:	01 c0                	add    %eax,%eax
c0100482:	01 d0                	add    %edx,%eax
c0100484:	c1 e0 02             	shl    $0x2,%eax
c0100487:	89 c2                	mov    %eax,%edx
c0100489:	8b 45 08             	mov    0x8(%ebp),%eax
c010048c:	01 d0                	add    %edx,%eax
c010048e:	8b 40 08             	mov    0x8(%eax),%eax
c0100491:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100494:	73 13                	jae    c01004a9 <stab_binsearch+0xb1>
            *region_left = m;
c0100496:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100499:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010049e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004a1:	83 c0 01             	add    $0x1,%eax
c01004a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004a7:	eb 43                	jmp    c01004ec <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c01004a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004ac:	89 d0                	mov    %edx,%eax
c01004ae:	01 c0                	add    %eax,%eax
c01004b0:	01 d0                	add    %edx,%eax
c01004b2:	c1 e0 02             	shl    $0x2,%eax
c01004b5:	89 c2                	mov    %eax,%edx
c01004b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ba:	01 d0                	add    %edx,%eax
c01004bc:	8b 40 08             	mov    0x8(%eax),%eax
c01004bf:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004c2:	76 16                	jbe    c01004da <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004ca:	8b 45 10             	mov    0x10(%ebp),%eax
c01004cd:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d2:	83 e8 01             	sub    $0x1,%eax
c01004d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d8:	eb 12                	jmp    c01004ec <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004e0:	89 10                	mov    %edx,(%eax)
            l = m;
c01004e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004e8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004f2:	0f 8e 22 ff ff ff    	jle    c010041a <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004fc:	75 0f                	jne    c010050d <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100501:	8b 00                	mov    (%eax),%eax
c0100503:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100506:	8b 45 10             	mov    0x10(%ebp),%eax
c0100509:	89 10                	mov    %edx,(%eax)
c010050b:	eb 3f                	jmp    c010054c <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c010050d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100510:	8b 00                	mov    (%eax),%eax
c0100512:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100515:	eb 04                	jmp    c010051b <stab_binsearch+0x123>
c0100517:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010051b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051e:	8b 00                	mov    (%eax),%eax
c0100520:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100523:	7d 1f                	jge    c0100544 <stab_binsearch+0x14c>
c0100525:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100528:	89 d0                	mov    %edx,%eax
c010052a:	01 c0                	add    %eax,%eax
c010052c:	01 d0                	add    %edx,%eax
c010052e:	c1 e0 02             	shl    $0x2,%eax
c0100531:	89 c2                	mov    %eax,%edx
c0100533:	8b 45 08             	mov    0x8(%ebp),%eax
c0100536:	01 d0                	add    %edx,%eax
c0100538:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010053c:	0f b6 c0             	movzbl %al,%eax
c010053f:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100542:	75 d3                	jne    c0100517 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100544:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100547:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010054a:	89 10                	mov    %edx,(%eax)
    }
}
c010054c:	c9                   	leave  
c010054d:	c3                   	ret    

c010054e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010054e:	55                   	push   %ebp
c010054f:	89 e5                	mov    %esp,%ebp
c0100551:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100554:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100557:	c7 00 6c 8d 10 c0    	movl   $0xc0108d6c,(%eax)
    info->eip_line = 0;
c010055d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100560:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100567:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056a:	c7 40 08 6c 8d 10 c0 	movl   $0xc0108d6c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100571:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100574:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010057b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057e:	8b 55 08             	mov    0x8(%ebp),%edx
c0100581:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100584:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100587:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010058e:	c7 45 f4 c0 ac 10 c0 	movl   $0xc010acc0,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100595:	c7 45 f0 ec 9a 11 c0 	movl   $0xc0119aec,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010059c:	c7 45 ec ed 9a 11 c0 	movl   $0xc0119aed,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005a3:	c7 45 e8 84 d3 11 c0 	movl   $0xc011d384,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005ad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005b0:	76 0d                	jbe    c01005bf <debuginfo_eip+0x71>
c01005b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b5:	83 e8 01             	sub    $0x1,%eax
c01005b8:	0f b6 00             	movzbl (%eax),%eax
c01005bb:	84 c0                	test   %al,%al
c01005bd:	74 0a                	je     c01005c9 <debuginfo_eip+0x7b>
        return -1;
c01005bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c4:	e9 c0 02 00 00       	jmp    c0100889 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005d6:	29 c2                	sub    %eax,%edx
c01005d8:	89 d0                	mov    %edx,%eax
c01005da:	c1 f8 02             	sar    $0x2,%eax
c01005dd:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005e3:	83 e8 01             	sub    $0x1,%eax
c01005e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005f0:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f7:	00 
c01005f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c0100602:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100609:	89 04 24             	mov    %eax,(%esp)
c010060c:	e8 e7 fd ff ff       	call   c01003f8 <stab_binsearch>
    if (lfile == 0)
c0100611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100614:	85 c0                	test   %eax,%eax
c0100616:	75 0a                	jne    c0100622 <debuginfo_eip+0xd4>
        return -1;
c0100618:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010061d:	e9 67 02 00 00       	jmp    c0100889 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100625:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100628:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010062b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010062e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100631:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100635:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010063c:	00 
c010063d:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100640:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100644:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100647:	89 44 24 04          	mov    %eax,0x4(%esp)
c010064b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010064e:	89 04 24             	mov    %eax,(%esp)
c0100651:	e8 a2 fd ff ff       	call   c01003f8 <stab_binsearch>

    if (lfun <= rfun) {
c0100656:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100659:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010065c:	39 c2                	cmp    %eax,%edx
c010065e:	7f 7c                	jg     c01006dc <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100660:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100663:	89 c2                	mov    %eax,%edx
c0100665:	89 d0                	mov    %edx,%eax
c0100667:	01 c0                	add    %eax,%eax
c0100669:	01 d0                	add    %edx,%eax
c010066b:	c1 e0 02             	shl    $0x2,%eax
c010066e:	89 c2                	mov    %eax,%edx
c0100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	8b 10                	mov    (%eax),%edx
c0100677:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010067a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010067d:	29 c1                	sub    %eax,%ecx
c010067f:	89 c8                	mov    %ecx,%eax
c0100681:	39 c2                	cmp    %eax,%edx
c0100683:	73 22                	jae    c01006a7 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100685:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100688:	89 c2                	mov    %eax,%edx
c010068a:	89 d0                	mov    %edx,%eax
c010068c:	01 c0                	add    %eax,%eax
c010068e:	01 d0                	add    %edx,%eax
c0100690:	c1 e0 02             	shl    $0x2,%eax
c0100693:	89 c2                	mov    %eax,%edx
c0100695:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100698:	01 d0                	add    %edx,%eax
c010069a:	8b 10                	mov    (%eax),%edx
c010069c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010069f:	01 c2                	add    %eax,%edx
c01006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a4:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006aa:	89 c2                	mov    %eax,%edx
c01006ac:	89 d0                	mov    %edx,%eax
c01006ae:	01 c0                	add    %eax,%eax
c01006b0:	01 d0                	add    %edx,%eax
c01006b2:	c1 e0 02             	shl    $0x2,%eax
c01006b5:	89 c2                	mov    %eax,%edx
c01006b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ba:	01 d0                	add    %edx,%eax
c01006bc:	8b 50 08             	mov    0x8(%eax),%edx
c01006bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c2:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c8:	8b 40 10             	mov    0x10(%eax),%eax
c01006cb:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006da:	eb 15                	jmp    c01006f1 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006df:	8b 55 08             	mov    0x8(%ebp),%edx
c01006e2:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f4:	8b 40 08             	mov    0x8(%eax),%eax
c01006f7:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006fe:	00 
c01006ff:	89 04 24             	mov    %eax,(%esp)
c0100702:	e8 9a 82 00 00       	call   c01089a1 <strfind>
c0100707:	89 c2                	mov    %eax,%edx
c0100709:	8b 45 0c             	mov    0xc(%ebp),%eax
c010070c:	8b 40 08             	mov    0x8(%eax),%eax
c010070f:	29 c2                	sub    %eax,%edx
c0100711:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100714:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100717:	8b 45 08             	mov    0x8(%ebp),%eax
c010071a:	89 44 24 10          	mov    %eax,0x10(%esp)
c010071e:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100725:	00 
c0100726:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100729:	89 44 24 08          	mov    %eax,0x8(%esp)
c010072d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100730:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100734:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100737:	89 04 24             	mov    %eax,(%esp)
c010073a:	e8 b9 fc ff ff       	call   c01003f8 <stab_binsearch>
    if (lline <= rline) {
c010073f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100742:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100745:	39 c2                	cmp    %eax,%edx
c0100747:	7f 24                	jg     c010076d <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100749:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010074c:	89 c2                	mov    %eax,%edx
c010074e:	89 d0                	mov    %edx,%eax
c0100750:	01 c0                	add    %eax,%eax
c0100752:	01 d0                	add    %edx,%eax
c0100754:	c1 e0 02             	shl    $0x2,%eax
c0100757:	89 c2                	mov    %eax,%edx
c0100759:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010075c:	01 d0                	add    %edx,%eax
c010075e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100762:	0f b7 d0             	movzwl %ax,%edx
c0100765:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100768:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010076b:	eb 13                	jmp    c0100780 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010076d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100772:	e9 12 01 00 00       	jmp    c0100889 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100777:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077a:	83 e8 01             	sub    $0x1,%eax
c010077d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100780:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100786:	39 c2                	cmp    %eax,%edx
c0100788:	7c 56                	jl     c01007e0 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010078a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078d:	89 c2                	mov    %eax,%edx
c010078f:	89 d0                	mov    %edx,%eax
c0100791:	01 c0                	add    %eax,%eax
c0100793:	01 d0                	add    %edx,%eax
c0100795:	c1 e0 02             	shl    $0x2,%eax
c0100798:	89 c2                	mov    %eax,%edx
c010079a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079d:	01 d0                	add    %edx,%eax
c010079f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a3:	3c 84                	cmp    $0x84,%al
c01007a5:	74 39                	je     c01007e0 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01007a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007aa:	89 c2                	mov    %eax,%edx
c01007ac:	89 d0                	mov    %edx,%eax
c01007ae:	01 c0                	add    %eax,%eax
c01007b0:	01 d0                	add    %edx,%eax
c01007b2:	c1 e0 02             	shl    $0x2,%eax
c01007b5:	89 c2                	mov    %eax,%edx
c01007b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ba:	01 d0                	add    %edx,%eax
c01007bc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007c0:	3c 64                	cmp    $0x64,%al
c01007c2:	75 b3                	jne    c0100777 <debuginfo_eip+0x229>
c01007c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c7:	89 c2                	mov    %eax,%edx
c01007c9:	89 d0                	mov    %edx,%eax
c01007cb:	01 c0                	add    %eax,%eax
c01007cd:	01 d0                	add    %edx,%eax
c01007cf:	c1 e0 02             	shl    $0x2,%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d7:	01 d0                	add    %edx,%eax
c01007d9:	8b 40 08             	mov    0x8(%eax),%eax
c01007dc:	85 c0                	test   %eax,%eax
c01007de:	74 97                	je     c0100777 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e6:	39 c2                	cmp    %eax,%edx
c01007e8:	7c 46                	jl     c0100830 <debuginfo_eip+0x2e2>
c01007ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ed:	89 c2                	mov    %eax,%edx
c01007ef:	89 d0                	mov    %edx,%eax
c01007f1:	01 c0                	add    %eax,%eax
c01007f3:	01 d0                	add    %edx,%eax
c01007f5:	c1 e0 02             	shl    $0x2,%eax
c01007f8:	89 c2                	mov    %eax,%edx
c01007fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	8b 10                	mov    (%eax),%edx
c0100801:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100804:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100807:	29 c1                	sub    %eax,%ecx
c0100809:	89 c8                	mov    %ecx,%eax
c010080b:	39 c2                	cmp    %eax,%edx
c010080d:	73 21                	jae    c0100830 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100812:	89 c2                	mov    %eax,%edx
c0100814:	89 d0                	mov    %edx,%eax
c0100816:	01 c0                	add    %eax,%eax
c0100818:	01 d0                	add    %edx,%eax
c010081a:	c1 e0 02             	shl    $0x2,%eax
c010081d:	89 c2                	mov    %eax,%edx
c010081f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100822:	01 d0                	add    %edx,%eax
c0100824:	8b 10                	mov    (%eax),%edx
c0100826:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100829:	01 c2                	add    %eax,%edx
c010082b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100830:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100833:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100836:	39 c2                	cmp    %eax,%edx
c0100838:	7d 4a                	jge    c0100884 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010083a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010083d:	83 c0 01             	add    $0x1,%eax
c0100840:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100843:	eb 18                	jmp    c010085d <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100845:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100848:	8b 40 14             	mov    0x14(%eax),%eax
c010084b:	8d 50 01             	lea    0x1(%eax),%edx
c010084e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100851:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100854:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100857:	83 c0 01             	add    $0x1,%eax
c010085a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100860:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100863:	39 c2                	cmp    %eax,%edx
c0100865:	7d 1d                	jge    c0100884 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100867:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010086a:	89 c2                	mov    %eax,%edx
c010086c:	89 d0                	mov    %edx,%eax
c010086e:	01 c0                	add    %eax,%eax
c0100870:	01 d0                	add    %edx,%eax
c0100872:	c1 e0 02             	shl    $0x2,%eax
c0100875:	89 c2                	mov    %eax,%edx
c0100877:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010087a:	01 d0                	add    %edx,%eax
c010087c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100880:	3c a0                	cmp    $0xa0,%al
c0100882:	74 c1                	je     c0100845 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100884:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100889:	c9                   	leave  
c010088a:	c3                   	ret    

c010088b <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010088b:	55                   	push   %ebp
c010088c:	89 e5                	mov    %esp,%ebp
c010088e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100891:	c7 04 24 76 8d 10 c0 	movl   $0xc0108d76,(%esp)
c0100898:	e8 ba fa ff ff       	call   c0100357 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010089d:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01008a4:	c0 
c01008a5:	c7 04 24 8f 8d 10 c0 	movl   $0xc0108d8f,(%esp)
c01008ac:	e8 a6 fa ff ff       	call   c0100357 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008b1:	c7 44 24 04 b6 8c 10 	movl   $0xc0108cb6,0x4(%esp)
c01008b8:	c0 
c01008b9:	c7 04 24 a7 8d 10 c0 	movl   $0xc0108da7,(%esp)
c01008c0:	e8 92 fa ff ff       	call   c0100357 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c5:	c7 44 24 04 00 30 12 	movl   $0xc0123000,0x4(%esp)
c01008cc:	c0 
c01008cd:	c7 04 24 bf 8d 10 c0 	movl   $0xc0108dbf,(%esp)
c01008d4:	e8 7e fa ff ff       	call   c0100357 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d9:	c7 44 24 04 30 41 12 	movl   $0xc0124130,0x4(%esp)
c01008e0:	c0 
c01008e1:	c7 04 24 d7 8d 10 c0 	movl   $0xc0108dd7,(%esp)
c01008e8:	e8 6a fa ff ff       	call   c0100357 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008ed:	b8 30 41 12 c0       	mov    $0xc0124130,%eax
c01008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f8:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01008fd:	29 c2                	sub    %eax,%edx
c01008ff:	89 d0                	mov    %edx,%eax
c0100901:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100907:	85 c0                	test   %eax,%eax
c0100909:	0f 48 c2             	cmovs  %edx,%eax
c010090c:	c1 f8 0a             	sar    $0xa,%eax
c010090f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100913:	c7 04 24 f0 8d 10 c0 	movl   $0xc0108df0,(%esp)
c010091a:	e8 38 fa ff ff       	call   c0100357 <cprintf>
}
c010091f:	c9                   	leave  
c0100920:	c3                   	ret    

c0100921 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100921:	55                   	push   %ebp
c0100922:	89 e5                	mov    %esp,%ebp
c0100924:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010092a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010092d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100931:	8b 45 08             	mov    0x8(%ebp),%eax
c0100934:	89 04 24             	mov    %eax,(%esp)
c0100937:	e8 12 fc ff ff       	call   c010054e <debuginfo_eip>
c010093c:	85 c0                	test   %eax,%eax
c010093e:	74 15                	je     c0100955 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100940:	8b 45 08             	mov    0x8(%ebp),%eax
c0100943:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100947:	c7 04 24 1a 8e 10 c0 	movl   $0xc0108e1a,(%esp)
c010094e:	e8 04 fa ff ff       	call   c0100357 <cprintf>
c0100953:	eb 6d                	jmp    c01009c2 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100955:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010095c:	eb 1c                	jmp    c010097a <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010095e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100961:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100964:	01 d0                	add    %edx,%eax
c0100966:	0f b6 00             	movzbl (%eax),%eax
c0100969:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010096f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100972:	01 ca                	add    %ecx,%edx
c0100974:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100976:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010097a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010097d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100980:	7f dc                	jg     c010095e <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100982:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100988:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010098b:	01 d0                	add    %edx,%eax
c010098d:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100990:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100993:	8b 55 08             	mov    0x8(%ebp),%edx
c0100996:	89 d1                	mov    %edx,%ecx
c0100998:	29 c1                	sub    %eax,%ecx
c010099a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010099d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01009a0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01009a4:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009aa:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009ae:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009b2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b6:	c7 04 24 36 8e 10 c0 	movl   $0xc0108e36,(%esp)
c01009bd:	e8 95 f9 ff ff       	call   c0100357 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009c2:	c9                   	leave  
c01009c3:	c3                   	ret    

c01009c4 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009c4:	55                   	push   %ebp
c01009c5:	89 e5                	mov    %esp,%ebp
c01009c7:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009ca:	8b 45 04             	mov    0x4(%ebp),%eax
c01009cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009d3:	c9                   	leave  
c01009d4:	c3                   	ret    

c01009d5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009d5:	55                   	push   %ebp
c01009d6:	89 e5                	mov    %esp,%ebp
c01009d8:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009db:	89 e8                	mov    %ebp,%eax
c01009dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009e6:	e8 d9 ff ff ff       	call   c01009c4 <read_eip>
c01009eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f5:	e9 88 00 00 00       	jmp    c0100a82 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009fd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a08:	c7 04 24 48 8e 10 c0 	movl   $0xc0108e48,(%esp)
c0100a0f:	e8 43 f9 ff ff       	call   c0100357 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a17:	83 c0 08             	add    $0x8,%eax
c0100a1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a1d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a24:	eb 25                	jmp    c0100a4b <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a33:	01 d0                	add    %edx,%eax
c0100a35:	8b 00                	mov    (%eax),%eax
c0100a37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3b:	c7 04 24 64 8e 10 c0 	movl   $0xc0108e64,(%esp)
c0100a42:	e8 10 f9 ff ff       	call   c0100357 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a47:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a4b:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4f:	7e d5                	jle    c0100a26 <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a51:	c7 04 24 6c 8e 10 c0 	movl   $0xc0108e6c,(%esp)
c0100a58:	e8 fa f8 ff ff       	call   c0100357 <cprintf>
        print_debuginfo(eip - 1);
c0100a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a60:	83 e8 01             	sub    $0x1,%eax
c0100a63:	89 04 24             	mov    %eax,(%esp)
c0100a66:	e8 b6 fe ff ff       	call   c0100921 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6e:	83 c0 04             	add    $0x4,%eax
c0100a71:	8b 00                	mov    (%eax),%eax
c0100a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a79:	8b 00                	mov    (%eax),%eax
c0100a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a7e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a86:	74 0a                	je     c0100a92 <print_stackframe+0xbd>
c0100a88:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a8c:	0f 8e 68 ff ff ff    	jle    c01009fa <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a92:	c9                   	leave  
c0100a93:	c3                   	ret    

c0100a94 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a94:	55                   	push   %ebp
c0100a95:	89 e5                	mov    %esp,%ebp
c0100a97:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa1:	eb 0c                	jmp    c0100aaf <parse+0x1b>
            *buf ++ = '\0';
c0100aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa6:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa9:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aac:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab2:	0f b6 00             	movzbl (%eax),%eax
c0100ab5:	84 c0                	test   %al,%al
c0100ab7:	74 1d                	je     c0100ad6 <parse+0x42>
c0100ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abc:	0f b6 00             	movzbl (%eax),%eax
c0100abf:	0f be c0             	movsbl %al,%eax
c0100ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac6:	c7 04 24 f0 8e 10 c0 	movl   $0xc0108ef0,(%esp)
c0100acd:	e8 9c 7e 00 00       	call   c010896e <strchr>
c0100ad2:	85 c0                	test   %eax,%eax
c0100ad4:	75 cd                	jne    c0100aa3 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ad6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad9:	0f b6 00             	movzbl (%eax),%eax
c0100adc:	84 c0                	test   %al,%al
c0100ade:	75 02                	jne    c0100ae2 <parse+0x4e>
            break;
c0100ae0:	eb 67                	jmp    c0100b49 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ae2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae6:	75 14                	jne    c0100afc <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae8:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aef:	00 
c0100af0:	c7 04 24 f5 8e 10 c0 	movl   $0xc0108ef5,(%esp)
c0100af7:	e8 5b f8 ff ff       	call   c0100357 <cprintf>
        }
        argv[argc ++] = buf;
c0100afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aff:	8d 50 01             	lea    0x1(%eax),%edx
c0100b02:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0f:	01 c2                	add    %eax,%edx
c0100b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b14:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b16:	eb 04                	jmp    c0100b1c <parse+0x88>
            buf ++;
c0100b18:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1f:	0f b6 00             	movzbl (%eax),%eax
c0100b22:	84 c0                	test   %al,%al
c0100b24:	74 1d                	je     c0100b43 <parse+0xaf>
c0100b26:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b29:	0f b6 00             	movzbl (%eax),%eax
c0100b2c:	0f be c0             	movsbl %al,%eax
c0100b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b33:	c7 04 24 f0 8e 10 c0 	movl   $0xc0108ef0,(%esp)
c0100b3a:	e8 2f 7e 00 00       	call   c010896e <strchr>
c0100b3f:	85 c0                	test   %eax,%eax
c0100b41:	74 d5                	je     c0100b18 <parse+0x84>
            buf ++;
        }
    }
c0100b43:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b44:	e9 66 ff ff ff       	jmp    c0100aaf <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b4c:	c9                   	leave  
c0100b4d:	c3                   	ret    

c0100b4e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b4e:	55                   	push   %ebp
c0100b4f:	89 e5                	mov    %esp,%ebp
c0100b51:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b54:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5e:	89 04 24             	mov    %eax,(%esp)
c0100b61:	e8 2e ff ff ff       	call   c0100a94 <parse>
c0100b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b6d:	75 0a                	jne    c0100b79 <runcmd+0x2b>
        return 0;
c0100b6f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b74:	e9 85 00 00 00       	jmp    c0100bfe <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b80:	eb 5c                	jmp    c0100bde <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b82:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b88:	89 d0                	mov    %edx,%eax
c0100b8a:	01 c0                	add    %eax,%eax
c0100b8c:	01 d0                	add    %edx,%eax
c0100b8e:	c1 e0 02             	shl    $0x2,%eax
c0100b91:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100b96:	8b 00                	mov    (%eax),%eax
c0100b98:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b9c:	89 04 24             	mov    %eax,(%esp)
c0100b9f:	e8 2b 7d 00 00       	call   c01088cf <strcmp>
c0100ba4:	85 c0                	test   %eax,%eax
c0100ba6:	75 32                	jne    c0100bda <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bab:	89 d0                	mov    %edx,%eax
c0100bad:	01 c0                	add    %eax,%eax
c0100baf:	01 d0                	add    %edx,%eax
c0100bb1:	c1 e0 02             	shl    $0x2,%eax
c0100bb4:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100bb9:	8b 40 08             	mov    0x8(%eax),%eax
c0100bbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bbf:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bc5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bc9:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bcc:	83 c2 04             	add    $0x4,%edx
c0100bcf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bd3:	89 0c 24             	mov    %ecx,(%esp)
c0100bd6:	ff d0                	call   *%eax
c0100bd8:	eb 24                	jmp    c0100bfe <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bda:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100be1:	83 f8 02             	cmp    $0x2,%eax
c0100be4:	76 9c                	jbe    c0100b82 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bed:	c7 04 24 13 8f 10 c0 	movl   $0xc0108f13,(%esp)
c0100bf4:	e8 5e f7 ff ff       	call   c0100357 <cprintf>
    return 0;
c0100bf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bfe:	c9                   	leave  
c0100bff:	c3                   	ret    

c0100c00 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c00:	55                   	push   %ebp
c0100c01:	89 e5                	mov    %esp,%ebp
c0100c03:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c06:	c7 04 24 2c 8f 10 c0 	movl   $0xc0108f2c,(%esp)
c0100c0d:	e8 45 f7 ff ff       	call   c0100357 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c12:	c7 04 24 54 8f 10 c0 	movl   $0xc0108f54,(%esp)
c0100c19:	e8 39 f7 ff ff       	call   c0100357 <cprintf>

    if (tf != NULL) {
c0100c1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c22:	74 0b                	je     c0100c2f <kmonitor+0x2f>
        print_trapframe(tf);
c0100c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c27:	89 04 24             	mov    %eax,(%esp)
c0100c2a:	e8 37 16 00 00       	call   c0102266 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c2f:	c7 04 24 79 8f 10 c0 	movl   $0xc0108f79,(%esp)
c0100c36:	e8 13 f6 ff ff       	call   c010024e <readline>
c0100c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c42:	74 18                	je     c0100c5c <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c4e:	89 04 24             	mov    %eax,(%esp)
c0100c51:	e8 f8 fe ff ff       	call   c0100b4e <runcmd>
c0100c56:	85 c0                	test   %eax,%eax
c0100c58:	79 02                	jns    c0100c5c <kmonitor+0x5c>
                break;
c0100c5a:	eb 02                	jmp    c0100c5e <kmonitor+0x5e>
            }
        }
    }
c0100c5c:	eb d1                	jmp    c0100c2f <kmonitor+0x2f>
}
c0100c5e:	c9                   	leave  
c0100c5f:	c3                   	ret    

c0100c60 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c60:	55                   	push   %ebp
c0100c61:	89 e5                	mov    %esp,%ebp
c0100c63:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c6d:	eb 3f                	jmp    c0100cae <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c72:	89 d0                	mov    %edx,%eax
c0100c74:	01 c0                	add    %eax,%eax
c0100c76:	01 d0                	add    %edx,%eax
c0100c78:	c1 e0 02             	shl    $0x2,%eax
c0100c7b:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100c80:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c86:	89 d0                	mov    %edx,%eax
c0100c88:	01 c0                	add    %eax,%eax
c0100c8a:	01 d0                	add    %edx,%eax
c0100c8c:	c1 e0 02             	shl    $0x2,%eax
c0100c8f:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100c94:	8b 00                	mov    (%eax),%eax
c0100c96:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c9e:	c7 04 24 7d 8f 10 c0 	movl   $0xc0108f7d,(%esp)
c0100ca5:	e8 ad f6 ff ff       	call   c0100357 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100caa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cb1:	83 f8 02             	cmp    $0x2,%eax
c0100cb4:	76 b9                	jbe    c0100c6f <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbb:	c9                   	leave  
c0100cbc:	c3                   	ret    

c0100cbd <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cbd:	55                   	push   %ebp
c0100cbe:	89 e5                	mov    %esp,%ebp
c0100cc0:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cc3:	e8 c3 fb ff ff       	call   c010088b <print_kerninfo>
    return 0;
c0100cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccd:	c9                   	leave  
c0100cce:	c3                   	ret    

c0100ccf <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ccf:	55                   	push   %ebp
c0100cd0:	89 e5                	mov    %esp,%ebp
c0100cd2:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cd5:	e8 fb fc ff ff       	call   c01009d5 <print_stackframe>
    return 0;
c0100cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cdf:	c9                   	leave  
c0100ce0:	c3                   	ret    

c0100ce1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ce1:	55                   	push   %ebp
c0100ce2:	89 e5                	mov    %esp,%ebp
c0100ce4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce7:	a1 20 34 12 c0       	mov    0xc0123420,%eax
c0100cec:	85 c0                	test   %eax,%eax
c0100cee:	74 02                	je     c0100cf2 <__panic+0x11>
        goto panic_dead;
c0100cf0:	eb 59                	jmp    c0100d4b <__panic+0x6a>
    }
    is_panic = 1;
c0100cf2:	c7 05 20 34 12 c0 01 	movl   $0x1,0xc0123420
c0100cf9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cfc:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d02:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d05:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d10:	c7 04 24 86 8f 10 c0 	movl   $0xc0108f86,(%esp)
c0100d17:	e8 3b f6 ff ff       	call   c0100357 <cprintf>
    vcprintf(fmt, ap);
c0100d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d23:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d26:	89 04 24             	mov    %eax,(%esp)
c0100d29:	e8 f6 f5 ff ff       	call   c0100324 <vcprintf>
    cprintf("\n");
c0100d2e:	c7 04 24 a2 8f 10 c0 	movl   $0xc0108fa2,(%esp)
c0100d35:	e8 1d f6 ff ff       	call   c0100357 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d3a:	c7 04 24 a4 8f 10 c0 	movl   $0xc0108fa4,(%esp)
c0100d41:	e8 11 f6 ff ff       	call   c0100357 <cprintf>
    print_stackframe();
c0100d46:	e8 8a fc ff ff       	call   c01009d5 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d4b:	e8 fa 11 00 00       	call   c0101f4a <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d57:	e8 a4 fe ff ff       	call   c0100c00 <kmonitor>
    }
c0100d5c:	eb f2                	jmp    c0100d50 <__panic+0x6f>

c0100d5e <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d5e:	55                   	push   %ebp
c0100d5f:	89 e5                	mov    %esp,%ebp
c0100d61:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d64:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d6d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d71:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d78:	c7 04 24 b6 8f 10 c0 	movl   $0xc0108fb6,(%esp)
c0100d7f:	e8 d3 f5 ff ff       	call   c0100357 <cprintf>
    vcprintf(fmt, ap);
c0100d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d87:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d8b:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d8e:	89 04 24             	mov    %eax,(%esp)
c0100d91:	e8 8e f5 ff ff       	call   c0100324 <vcprintf>
    cprintf("\n");
c0100d96:	c7 04 24 a2 8f 10 c0 	movl   $0xc0108fa2,(%esp)
c0100d9d:	e8 b5 f5 ff ff       	call   c0100357 <cprintf>
    va_end(ap);
}
c0100da2:	c9                   	leave  
c0100da3:	c3                   	ret    

c0100da4 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100da4:	55                   	push   %ebp
c0100da5:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100da7:	a1 20 34 12 c0       	mov    0xc0123420,%eax
}
c0100dac:	5d                   	pop    %ebp
c0100dad:	c3                   	ret    

c0100dae <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dae:	55                   	push   %ebp
c0100daf:	89 e5                	mov    %esp,%ebp
c0100db1:	83 ec 28             	sub    $0x28,%esp
c0100db4:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100dba:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dbe:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dc2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dc6:	ee                   	out    %al,(%dx)
c0100dc7:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dcd:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dd1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dd5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dd9:	ee                   	out    %al,(%dx)
c0100dda:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100de0:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100de4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100de8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dec:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100ded:	c7 05 3c 40 12 c0 00 	movl   $0x0,0xc012403c
c0100df4:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100df7:	c7 04 24 d4 8f 10 c0 	movl   $0xc0108fd4,(%esp)
c0100dfe:	e8 54 f5 ff ff       	call   c0100357 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e0a:	e8 99 11 00 00       	call   c0101fa8 <pic_enable>
}
c0100e0f:	c9                   	leave  
c0100e10:	c3                   	ret    

c0100e11 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e11:	55                   	push   %ebp
c0100e12:	89 e5                	mov    %esp,%ebp
c0100e14:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e17:	9c                   	pushf  
c0100e18:	58                   	pop    %eax
c0100e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e1f:	25 00 02 00 00       	and    $0x200,%eax
c0100e24:	85 c0                	test   %eax,%eax
c0100e26:	74 0c                	je     c0100e34 <__intr_save+0x23>
        intr_disable();
c0100e28:	e8 1d 11 00 00       	call   c0101f4a <intr_disable>
        return 1;
c0100e2d:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e32:	eb 05                	jmp    c0100e39 <__intr_save+0x28>
    }
    return 0;
c0100e34:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e39:	c9                   	leave  
c0100e3a:	c3                   	ret    

c0100e3b <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e3b:	55                   	push   %ebp
c0100e3c:	89 e5                	mov    %esp,%ebp
c0100e3e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e45:	74 05                	je     c0100e4c <__intr_restore+0x11>
        intr_enable();
c0100e47:	e8 f8 10 00 00       	call   c0101f44 <intr_enable>
    }
}
c0100e4c:	c9                   	leave  
c0100e4d:	c3                   	ret    

c0100e4e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e4e:	55                   	push   %ebp
c0100e4f:	89 e5                	mov    %esp,%ebp
c0100e51:	83 ec 10             	sub    $0x10,%esp
c0100e54:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e5a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e5e:	89 c2                	mov    %eax,%edx
c0100e60:	ec                   	in     (%dx),%al
c0100e61:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e64:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e6a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e6e:	89 c2                	mov    %eax,%edx
c0100e70:	ec                   	in     (%dx),%al
c0100e71:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e74:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e7a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e7e:	89 c2                	mov    %eax,%edx
c0100e80:	ec                   	in     (%dx),%al
c0100e81:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e84:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e8a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e8e:	89 c2                	mov    %eax,%edx
c0100e90:	ec                   	in     (%dx),%al
c0100e91:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e94:	c9                   	leave  
c0100e95:	c3                   	ret    

c0100e96 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e96:	55                   	push   %ebp
c0100e97:	89 e5                	mov    %esp,%ebp
c0100e99:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e9c:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ea3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea6:	0f b7 00             	movzwl (%eax),%eax
c0100ea9:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb0:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb8:	0f b7 00             	movzwl (%eax),%eax
c0100ebb:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ebf:	74 12                	je     c0100ed3 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ec1:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ec8:	66 c7 05 46 34 12 c0 	movw   $0x3b4,0xc0123446
c0100ecf:	b4 03 
c0100ed1:	eb 13                	jmp    c0100ee6 <cga_init+0x50>
    } else {
        *cp = was;
c0100ed3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eda:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100edd:	66 c7 05 46 34 12 c0 	movw   $0x3d4,0xc0123446
c0100ee4:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ee6:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100eed:	0f b7 c0             	movzwl %ax,%eax
c0100ef0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ef4:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ef8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100efc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f00:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100f01:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f08:	83 c0 01             	add    $0x1,%eax
c0100f0b:	0f b7 c0             	movzwl %ax,%eax
c0100f0e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f12:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f16:	89 c2                	mov    %eax,%edx
c0100f18:	ec                   	in     (%dx),%al
c0100f19:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f1c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f20:	0f b6 c0             	movzbl %al,%eax
c0100f23:	c1 e0 08             	shl    $0x8,%eax
c0100f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f29:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f30:	0f b7 c0             	movzwl %ax,%eax
c0100f33:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f37:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f3b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f3f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f43:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f44:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f4b:	83 c0 01             	add    $0x1,%eax
c0100f4e:	0f b7 c0             	movzwl %ax,%eax
c0100f51:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f55:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f59:	89 c2                	mov    %eax,%edx
c0100f5b:	ec                   	in     (%dx),%al
c0100f5c:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f5f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f63:	0f b6 c0             	movzbl %al,%eax
c0100f66:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f69:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f6c:	a3 40 34 12 c0       	mov    %eax,0xc0123440
    crt_pos = pos;
c0100f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f74:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
}
c0100f7a:	c9                   	leave  
c0100f7b:	c3                   	ret    

c0100f7c <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f7c:	55                   	push   %ebp
c0100f7d:	89 e5                	mov    %esp,%ebp
c0100f7f:	83 ec 48             	sub    $0x48,%esp
c0100f82:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f88:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f8c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f90:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f94:	ee                   	out    %al,(%dx)
c0100f95:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f9b:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f9f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fa3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fa7:	ee                   	out    %al,(%dx)
c0100fa8:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100fae:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fb2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fb6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fba:	ee                   	out    %al,(%dx)
c0100fbb:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fc1:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fc5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fc9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fcd:	ee                   	out    %al,(%dx)
c0100fce:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fd4:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fd8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fdc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fe0:	ee                   	out    %al,(%dx)
c0100fe1:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fe7:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100feb:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fef:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100ff3:	ee                   	out    %al,(%dx)
c0100ff4:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100ffa:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100ffe:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101002:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101006:	ee                   	out    %al,(%dx)
c0101007:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010100d:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101011:	89 c2                	mov    %eax,%edx
c0101013:	ec                   	in     (%dx),%al
c0101014:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101017:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010101b:	3c ff                	cmp    $0xff,%al
c010101d:	0f 95 c0             	setne  %al
c0101020:	0f b6 c0             	movzbl %al,%eax
c0101023:	a3 48 34 12 c0       	mov    %eax,0xc0123448
c0101028:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010102e:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101032:	89 c2                	mov    %eax,%edx
c0101034:	ec                   	in     (%dx),%al
c0101035:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101038:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010103e:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101042:	89 c2                	mov    %eax,%edx
c0101044:	ec                   	in     (%dx),%al
c0101045:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101048:	a1 48 34 12 c0       	mov    0xc0123448,%eax
c010104d:	85 c0                	test   %eax,%eax
c010104f:	74 0c                	je     c010105d <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101051:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101058:	e8 4b 0f 00 00       	call   c0101fa8 <pic_enable>
    }
}
c010105d:	c9                   	leave  
c010105e:	c3                   	ret    

c010105f <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010105f:	55                   	push   %ebp
c0101060:	89 e5                	mov    %esp,%ebp
c0101062:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101065:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010106c:	eb 09                	jmp    c0101077 <lpt_putc_sub+0x18>
        delay();
c010106e:	e8 db fd ff ff       	call   c0100e4e <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101073:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101077:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010107d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101081:	89 c2                	mov    %eax,%edx
c0101083:	ec                   	in     (%dx),%al
c0101084:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101087:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010108b:	84 c0                	test   %al,%al
c010108d:	78 09                	js     c0101098 <lpt_putc_sub+0x39>
c010108f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101096:	7e d6                	jle    c010106e <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101098:	8b 45 08             	mov    0x8(%ebp),%eax
c010109b:	0f b6 c0             	movzbl %al,%eax
c010109e:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c01010a4:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010a7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010ab:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010af:	ee                   	out    %al,(%dx)
c01010b0:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010b6:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010ba:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010be:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010c2:	ee                   	out    %al,(%dx)
c01010c3:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010c9:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010cd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010d1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010d5:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010d6:	c9                   	leave  
c01010d7:	c3                   	ret    

c01010d8 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010d8:	55                   	push   %ebp
c01010d9:	89 e5                	mov    %esp,%ebp
c01010db:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010de:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010e2:	74 0d                	je     c01010f1 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e7:	89 04 24             	mov    %eax,(%esp)
c01010ea:	e8 70 ff ff ff       	call   c010105f <lpt_putc_sub>
c01010ef:	eb 24                	jmp    c0101115 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010f1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f8:	e8 62 ff ff ff       	call   c010105f <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010fd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101104:	e8 56 ff ff ff       	call   c010105f <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101109:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101110:	e8 4a ff ff ff       	call   c010105f <lpt_putc_sub>
    }
}
c0101115:	c9                   	leave  
c0101116:	c3                   	ret    

c0101117 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101117:	55                   	push   %ebp
c0101118:	89 e5                	mov    %esp,%ebp
c010111a:	53                   	push   %ebx
c010111b:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010111e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101121:	b0 00                	mov    $0x0,%al
c0101123:	85 c0                	test   %eax,%eax
c0101125:	75 07                	jne    c010112e <cga_putc+0x17>
        c |= 0x0700;
c0101127:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010112e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101131:	0f b6 c0             	movzbl %al,%eax
c0101134:	83 f8 0a             	cmp    $0xa,%eax
c0101137:	74 4c                	je     c0101185 <cga_putc+0x6e>
c0101139:	83 f8 0d             	cmp    $0xd,%eax
c010113c:	74 57                	je     c0101195 <cga_putc+0x7e>
c010113e:	83 f8 08             	cmp    $0x8,%eax
c0101141:	0f 85 88 00 00 00    	jne    c01011cf <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101147:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010114e:	66 85 c0             	test   %ax,%ax
c0101151:	74 30                	je     c0101183 <cga_putc+0x6c>
            crt_pos --;
c0101153:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010115a:	83 e8 01             	sub    $0x1,%eax
c010115d:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101163:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c0101168:	0f b7 15 44 34 12 c0 	movzwl 0xc0123444,%edx
c010116f:	0f b7 d2             	movzwl %dx,%edx
c0101172:	01 d2                	add    %edx,%edx
c0101174:	01 c2                	add    %eax,%edx
c0101176:	8b 45 08             	mov    0x8(%ebp),%eax
c0101179:	b0 00                	mov    $0x0,%al
c010117b:	83 c8 20             	or     $0x20,%eax
c010117e:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101181:	eb 72                	jmp    c01011f5 <cga_putc+0xde>
c0101183:	eb 70                	jmp    c01011f5 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101185:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010118c:	83 c0 50             	add    $0x50,%eax
c010118f:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101195:	0f b7 1d 44 34 12 c0 	movzwl 0xc0123444,%ebx
c010119c:	0f b7 0d 44 34 12 c0 	movzwl 0xc0123444,%ecx
c01011a3:	0f b7 c1             	movzwl %cx,%eax
c01011a6:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011ac:	c1 e8 10             	shr    $0x10,%eax
c01011af:	89 c2                	mov    %eax,%edx
c01011b1:	66 c1 ea 06          	shr    $0x6,%dx
c01011b5:	89 d0                	mov    %edx,%eax
c01011b7:	c1 e0 02             	shl    $0x2,%eax
c01011ba:	01 d0                	add    %edx,%eax
c01011bc:	c1 e0 04             	shl    $0x4,%eax
c01011bf:	29 c1                	sub    %eax,%ecx
c01011c1:	89 ca                	mov    %ecx,%edx
c01011c3:	89 d8                	mov    %ebx,%eax
c01011c5:	29 d0                	sub    %edx,%eax
c01011c7:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
        break;
c01011cd:	eb 26                	jmp    c01011f5 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011cf:	8b 0d 40 34 12 c0    	mov    0xc0123440,%ecx
c01011d5:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c01011dc:	8d 50 01             	lea    0x1(%eax),%edx
c01011df:	66 89 15 44 34 12 c0 	mov    %dx,0xc0123444
c01011e6:	0f b7 c0             	movzwl %ax,%eax
c01011e9:	01 c0                	add    %eax,%eax
c01011eb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01011f1:	66 89 02             	mov    %ax,(%edx)
        break;
c01011f4:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011f5:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c01011fc:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101200:	76 5b                	jbe    c010125d <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101202:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c0101207:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010120d:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c0101212:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101219:	00 
c010121a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010121e:	89 04 24             	mov    %eax,(%esp)
c0101221:	e8 46 79 00 00       	call   c0108b6c <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101226:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010122d:	eb 15                	jmp    c0101244 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010122f:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c0101234:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101237:	01 d2                	add    %edx,%edx
c0101239:	01 d0                	add    %edx,%eax
c010123b:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101240:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101244:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010124b:	7e e2                	jle    c010122f <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010124d:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c0101254:	83 e8 50             	sub    $0x50,%eax
c0101257:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010125d:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0101264:	0f b7 c0             	movzwl %ax,%eax
c0101267:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010126b:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010126f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101273:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101277:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101278:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010127f:	66 c1 e8 08          	shr    $0x8,%ax
c0101283:	0f b6 c0             	movzbl %al,%eax
c0101286:	0f b7 15 46 34 12 c0 	movzwl 0xc0123446,%edx
c010128d:	83 c2 01             	add    $0x1,%edx
c0101290:	0f b7 d2             	movzwl %dx,%edx
c0101293:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101297:	88 45 ed             	mov    %al,-0x13(%ebp)
c010129a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010129e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012a2:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012a3:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c01012aa:	0f b7 c0             	movzwl %ax,%eax
c01012ad:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012b1:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012b5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012b9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012bd:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012be:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c01012c5:	0f b6 c0             	movzbl %al,%eax
c01012c8:	0f b7 15 46 34 12 c0 	movzwl 0xc0123446,%edx
c01012cf:	83 c2 01             	add    $0x1,%edx
c01012d2:	0f b7 d2             	movzwl %dx,%edx
c01012d5:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012d9:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012dc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012e0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012e4:	ee                   	out    %al,(%dx)
}
c01012e5:	83 c4 34             	add    $0x34,%esp
c01012e8:	5b                   	pop    %ebx
c01012e9:	5d                   	pop    %ebp
c01012ea:	c3                   	ret    

c01012eb <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012eb:	55                   	push   %ebp
c01012ec:	89 e5                	mov    %esp,%ebp
c01012ee:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012f8:	eb 09                	jmp    c0101303 <serial_putc_sub+0x18>
        delay();
c01012fa:	e8 4f fb ff ff       	call   c0100e4e <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101303:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101309:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010130d:	89 c2                	mov    %eax,%edx
c010130f:	ec                   	in     (%dx),%al
c0101310:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101313:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101317:	0f b6 c0             	movzbl %al,%eax
c010131a:	83 e0 20             	and    $0x20,%eax
c010131d:	85 c0                	test   %eax,%eax
c010131f:	75 09                	jne    c010132a <serial_putc_sub+0x3f>
c0101321:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101328:	7e d0                	jle    c01012fa <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010132a:	8b 45 08             	mov    0x8(%ebp),%eax
c010132d:	0f b6 c0             	movzbl %al,%eax
c0101330:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101336:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101339:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010133d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101341:	ee                   	out    %al,(%dx)
}
c0101342:	c9                   	leave  
c0101343:	c3                   	ret    

c0101344 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101344:	55                   	push   %ebp
c0101345:	89 e5                	mov    %esp,%ebp
c0101347:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010134a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010134e:	74 0d                	je     c010135d <serial_putc+0x19>
        serial_putc_sub(c);
c0101350:	8b 45 08             	mov    0x8(%ebp),%eax
c0101353:	89 04 24             	mov    %eax,(%esp)
c0101356:	e8 90 ff ff ff       	call   c01012eb <serial_putc_sub>
c010135b:	eb 24                	jmp    c0101381 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010135d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101364:	e8 82 ff ff ff       	call   c01012eb <serial_putc_sub>
        serial_putc_sub(' ');
c0101369:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101370:	e8 76 ff ff ff       	call   c01012eb <serial_putc_sub>
        serial_putc_sub('\b');
c0101375:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010137c:	e8 6a ff ff ff       	call   c01012eb <serial_putc_sub>
    }
}
c0101381:	c9                   	leave  
c0101382:	c3                   	ret    

c0101383 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101383:	55                   	push   %ebp
c0101384:	89 e5                	mov    %esp,%ebp
c0101386:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101389:	eb 33                	jmp    c01013be <cons_intr+0x3b>
        if (c != 0) {
c010138b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010138f:	74 2d                	je     c01013be <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101391:	a1 64 36 12 c0       	mov    0xc0123664,%eax
c0101396:	8d 50 01             	lea    0x1(%eax),%edx
c0101399:	89 15 64 36 12 c0    	mov    %edx,0xc0123664
c010139f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013a2:	88 90 60 34 12 c0    	mov    %dl,-0x3fedcba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013a8:	a1 64 36 12 c0       	mov    0xc0123664,%eax
c01013ad:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013b2:	75 0a                	jne    c01013be <cons_intr+0x3b>
                cons.wpos = 0;
c01013b4:	c7 05 64 36 12 c0 00 	movl   $0x0,0xc0123664
c01013bb:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013be:	8b 45 08             	mov    0x8(%ebp),%eax
c01013c1:	ff d0                	call   *%eax
c01013c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013c6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013ca:	75 bf                	jne    c010138b <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013cc:	c9                   	leave  
c01013cd:	c3                   	ret    

c01013ce <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013ce:	55                   	push   %ebp
c01013cf:	89 e5                	mov    %esp,%ebp
c01013d1:	83 ec 10             	sub    $0x10,%esp
c01013d4:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013da:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013de:	89 c2                	mov    %eax,%edx
c01013e0:	ec                   	in     (%dx),%al
c01013e1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013e4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013e8:	0f b6 c0             	movzbl %al,%eax
c01013eb:	83 e0 01             	and    $0x1,%eax
c01013ee:	85 c0                	test   %eax,%eax
c01013f0:	75 07                	jne    c01013f9 <serial_proc_data+0x2b>
        return -1;
c01013f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013f7:	eb 2a                	jmp    c0101423 <serial_proc_data+0x55>
c01013f9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ff:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101403:	89 c2                	mov    %eax,%edx
c0101405:	ec                   	in     (%dx),%al
c0101406:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101409:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010140d:	0f b6 c0             	movzbl %al,%eax
c0101410:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101413:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101417:	75 07                	jne    c0101420 <serial_proc_data+0x52>
        c = '\b';
c0101419:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101420:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101423:	c9                   	leave  
c0101424:	c3                   	ret    

c0101425 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101425:	55                   	push   %ebp
c0101426:	89 e5                	mov    %esp,%ebp
c0101428:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010142b:	a1 48 34 12 c0       	mov    0xc0123448,%eax
c0101430:	85 c0                	test   %eax,%eax
c0101432:	74 0c                	je     c0101440 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101434:	c7 04 24 ce 13 10 c0 	movl   $0xc01013ce,(%esp)
c010143b:	e8 43 ff ff ff       	call   c0101383 <cons_intr>
    }
}
c0101440:	c9                   	leave  
c0101441:	c3                   	ret    

c0101442 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101442:	55                   	push   %ebp
c0101443:	89 e5                	mov    %esp,%ebp
c0101445:	83 ec 38             	sub    $0x38,%esp
c0101448:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101452:	89 c2                	mov    %eax,%edx
c0101454:	ec                   	in     (%dx),%al
c0101455:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101458:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010145c:	0f b6 c0             	movzbl %al,%eax
c010145f:	83 e0 01             	and    $0x1,%eax
c0101462:	85 c0                	test   %eax,%eax
c0101464:	75 0a                	jne    c0101470 <kbd_proc_data+0x2e>
        return -1;
c0101466:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010146b:	e9 59 01 00 00       	jmp    c01015c9 <kbd_proc_data+0x187>
c0101470:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101476:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010147a:	89 c2                	mov    %eax,%edx
c010147c:	ec                   	in     (%dx),%al
c010147d:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101480:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101484:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101487:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010148b:	75 17                	jne    c01014a4 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010148d:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101492:	83 c8 40             	or     $0x40,%eax
c0101495:	a3 68 36 12 c0       	mov    %eax,0xc0123668
        return 0;
c010149a:	b8 00 00 00 00       	mov    $0x0,%eax
c010149f:	e9 25 01 00 00       	jmp    c01015c9 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c01014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a8:	84 c0                	test   %al,%al
c01014aa:	79 47                	jns    c01014f3 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014ac:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01014b1:	83 e0 40             	and    $0x40,%eax
c01014b4:	85 c0                	test   %eax,%eax
c01014b6:	75 09                	jne    c01014c1 <kbd_proc_data+0x7f>
c01014b8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014bc:	83 e0 7f             	and    $0x7f,%eax
c01014bf:	eb 04                	jmp    c01014c5 <kbd_proc_data+0x83>
c01014c1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c5:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014c8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014cc:	0f b6 80 40 00 12 c0 	movzbl -0x3fedffc0(%eax),%eax
c01014d3:	83 c8 40             	or     $0x40,%eax
c01014d6:	0f b6 c0             	movzbl %al,%eax
c01014d9:	f7 d0                	not    %eax
c01014db:	89 c2                	mov    %eax,%edx
c01014dd:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01014e2:	21 d0                	and    %edx,%eax
c01014e4:	a3 68 36 12 c0       	mov    %eax,0xc0123668
        return 0;
c01014e9:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ee:	e9 d6 00 00 00       	jmp    c01015c9 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014f3:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01014f8:	83 e0 40             	and    $0x40,%eax
c01014fb:	85 c0                	test   %eax,%eax
c01014fd:	74 11                	je     c0101510 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014ff:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101503:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101508:	83 e0 bf             	and    $0xffffffbf,%eax
c010150b:	a3 68 36 12 c0       	mov    %eax,0xc0123668
    }

    shift |= shiftcode[data];
c0101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101514:	0f b6 80 40 00 12 c0 	movzbl -0x3fedffc0(%eax),%eax
c010151b:	0f b6 d0             	movzbl %al,%edx
c010151e:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101523:	09 d0                	or     %edx,%eax
c0101525:	a3 68 36 12 c0       	mov    %eax,0xc0123668
    shift ^= togglecode[data];
c010152a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152e:	0f b6 80 40 01 12 c0 	movzbl -0x3fedfec0(%eax),%eax
c0101535:	0f b6 d0             	movzbl %al,%edx
c0101538:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c010153d:	31 d0                	xor    %edx,%eax
c010153f:	a3 68 36 12 c0       	mov    %eax,0xc0123668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101544:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101549:	83 e0 03             	and    $0x3,%eax
c010154c:	8b 14 85 40 05 12 c0 	mov    -0x3fedfac0(,%eax,4),%edx
c0101553:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101557:	01 d0                	add    %edx,%eax
c0101559:	0f b6 00             	movzbl (%eax),%eax
c010155c:	0f b6 c0             	movzbl %al,%eax
c010155f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101562:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101567:	83 e0 08             	and    $0x8,%eax
c010156a:	85 c0                	test   %eax,%eax
c010156c:	74 22                	je     c0101590 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010156e:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101572:	7e 0c                	jle    c0101580 <kbd_proc_data+0x13e>
c0101574:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101578:	7f 06                	jg     c0101580 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010157a:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010157e:	eb 10                	jmp    c0101590 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101580:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101584:	7e 0a                	jle    c0101590 <kbd_proc_data+0x14e>
c0101586:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010158a:	7f 04                	jg     c0101590 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010158c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101590:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101595:	f7 d0                	not    %eax
c0101597:	83 e0 06             	and    $0x6,%eax
c010159a:	85 c0                	test   %eax,%eax
c010159c:	75 28                	jne    c01015c6 <kbd_proc_data+0x184>
c010159e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015a5:	75 1f                	jne    c01015c6 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c01015a7:	c7 04 24 ef 8f 10 c0 	movl   $0xc0108fef,(%esp)
c01015ae:	e8 a4 ed ff ff       	call   c0100357 <cprintf>
c01015b3:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015b9:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015bd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015c1:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015c5:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015c9:	c9                   	leave  
c01015ca:	c3                   	ret    

c01015cb <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015cb:	55                   	push   %ebp
c01015cc:	89 e5                	mov    %esp,%ebp
c01015ce:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015d1:	c7 04 24 42 14 10 c0 	movl   $0xc0101442,(%esp)
c01015d8:	e8 a6 fd ff ff       	call   c0101383 <cons_intr>
}
c01015dd:	c9                   	leave  
c01015de:	c3                   	ret    

c01015df <kbd_init>:

static void
kbd_init(void) {
c01015df:	55                   	push   %ebp
c01015e0:	89 e5                	mov    %esp,%ebp
c01015e2:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015e5:	e8 e1 ff ff ff       	call   c01015cb <kbd_intr>
    pic_enable(IRQ_KBD);
c01015ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015f1:	e8 b2 09 00 00       	call   c0101fa8 <pic_enable>
}
c01015f6:	c9                   	leave  
c01015f7:	c3                   	ret    

c01015f8 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015f8:	55                   	push   %ebp
c01015f9:	89 e5                	mov    %esp,%ebp
c01015fb:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015fe:	e8 93 f8 ff ff       	call   c0100e96 <cga_init>
    serial_init();
c0101603:	e8 74 f9 ff ff       	call   c0100f7c <serial_init>
    kbd_init();
c0101608:	e8 d2 ff ff ff       	call   c01015df <kbd_init>
    if (!serial_exists) {
c010160d:	a1 48 34 12 c0       	mov    0xc0123448,%eax
c0101612:	85 c0                	test   %eax,%eax
c0101614:	75 0c                	jne    c0101622 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101616:	c7 04 24 fb 8f 10 c0 	movl   $0xc0108ffb,(%esp)
c010161d:	e8 35 ed ff ff       	call   c0100357 <cprintf>
    }
}
c0101622:	c9                   	leave  
c0101623:	c3                   	ret    

c0101624 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101624:	55                   	push   %ebp
c0101625:	89 e5                	mov    %esp,%ebp
c0101627:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010162a:	e8 e2 f7 ff ff       	call   c0100e11 <__intr_save>
c010162f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101632:	8b 45 08             	mov    0x8(%ebp),%eax
c0101635:	89 04 24             	mov    %eax,(%esp)
c0101638:	e8 9b fa ff ff       	call   c01010d8 <lpt_putc>
        cga_putc(c);
c010163d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101640:	89 04 24             	mov    %eax,(%esp)
c0101643:	e8 cf fa ff ff       	call   c0101117 <cga_putc>
        serial_putc(c);
c0101648:	8b 45 08             	mov    0x8(%ebp),%eax
c010164b:	89 04 24             	mov    %eax,(%esp)
c010164e:	e8 f1 fc ff ff       	call   c0101344 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101653:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101656:	89 04 24             	mov    %eax,(%esp)
c0101659:	e8 dd f7 ff ff       	call   c0100e3b <__intr_restore>
}
c010165e:	c9                   	leave  
c010165f:	c3                   	ret    

c0101660 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101660:	55                   	push   %ebp
c0101661:	89 e5                	mov    %esp,%ebp
c0101663:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101666:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010166d:	e8 9f f7 ff ff       	call   c0100e11 <__intr_save>
c0101672:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101675:	e8 ab fd ff ff       	call   c0101425 <serial_intr>
        kbd_intr();
c010167a:	e8 4c ff ff ff       	call   c01015cb <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010167f:	8b 15 60 36 12 c0    	mov    0xc0123660,%edx
c0101685:	a1 64 36 12 c0       	mov    0xc0123664,%eax
c010168a:	39 c2                	cmp    %eax,%edx
c010168c:	74 31                	je     c01016bf <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010168e:	a1 60 36 12 c0       	mov    0xc0123660,%eax
c0101693:	8d 50 01             	lea    0x1(%eax),%edx
c0101696:	89 15 60 36 12 c0    	mov    %edx,0xc0123660
c010169c:	0f b6 80 60 34 12 c0 	movzbl -0x3fedcba0(%eax),%eax
c01016a3:	0f b6 c0             	movzbl %al,%eax
c01016a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016a9:	a1 60 36 12 c0       	mov    0xc0123660,%eax
c01016ae:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016b3:	75 0a                	jne    c01016bf <cons_getc+0x5f>
                cons.rpos = 0;
c01016b5:	c7 05 60 36 12 c0 00 	movl   $0x0,0xc0123660
c01016bc:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016c2:	89 04 24             	mov    %eax,(%esp)
c01016c5:	e8 71 f7 ff ff       	call   c0100e3b <__intr_restore>
    return c;
c01016ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016cd:	c9                   	leave  
c01016ce:	c3                   	ret    

c01016cf <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016cf:	55                   	push   %ebp
c01016d0:	89 e5                	mov    %esp,%ebp
c01016d2:	83 ec 14             	sub    $0x14,%esp
c01016d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01016d8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016dc:	90                   	nop
c01016dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e1:	83 c0 07             	add    $0x7,%eax
c01016e4:	0f b7 c0             	movzwl %ax,%eax
c01016e7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016eb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016ef:	89 c2                	mov    %eax,%edx
c01016f1:	ec                   	in     (%dx),%al
c01016f2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016f5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016f9:	0f b6 c0             	movzbl %al,%eax
c01016fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101702:	25 80 00 00 00       	and    $0x80,%eax
c0101707:	85 c0                	test   %eax,%eax
c0101709:	75 d2                	jne    c01016dd <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c010170b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010170f:	74 11                	je     c0101722 <ide_wait_ready+0x53>
c0101711:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101714:	83 e0 21             	and    $0x21,%eax
c0101717:	85 c0                	test   %eax,%eax
c0101719:	74 07                	je     c0101722 <ide_wait_ready+0x53>
        return -1;
c010171b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101720:	eb 05                	jmp    c0101727 <ide_wait_ready+0x58>
    }
    return 0;
c0101722:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101727:	c9                   	leave  
c0101728:	c3                   	ret    

c0101729 <ide_init>:

void
ide_init(void) {
c0101729:	55                   	push   %ebp
c010172a:	89 e5                	mov    %esp,%ebp
c010172c:	57                   	push   %edi
c010172d:	53                   	push   %ebx
c010172e:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101734:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c010173a:	e9 d6 02 00 00       	jmp    c0101a15 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c010173f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101743:	c1 e0 03             	shl    $0x3,%eax
c0101746:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010174d:	29 c2                	sub    %eax,%edx
c010174f:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c0101755:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101758:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010175c:	66 d1 e8             	shr    %ax
c010175f:	0f b7 c0             	movzwl %ax,%eax
c0101762:	0f b7 04 85 1c 90 10 	movzwl -0x3fef6fe4(,%eax,4),%eax
c0101769:	c0 
c010176a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c010176e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101772:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101779:	00 
c010177a:	89 04 24             	mov    %eax,(%esp)
c010177d:	e8 4d ff ff ff       	call   c01016cf <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101782:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101786:	83 e0 01             	and    $0x1,%eax
c0101789:	c1 e0 04             	shl    $0x4,%eax
c010178c:	83 c8 e0             	or     $0xffffffe0,%eax
c010178f:	0f b6 c0             	movzbl %al,%eax
c0101792:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101796:	83 c2 06             	add    $0x6,%edx
c0101799:	0f b7 d2             	movzwl %dx,%edx
c010179c:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c01017a0:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017a3:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01017a7:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01017ab:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017ac:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017b7:	00 
c01017b8:	89 04 24             	mov    %eax,(%esp)
c01017bb:	e8 0f ff ff ff       	call   c01016cf <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017c0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017c4:	83 c0 07             	add    $0x7,%eax
c01017c7:	0f b7 c0             	movzwl %ax,%eax
c01017ca:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017ce:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017d2:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017d6:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017da:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017db:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017e6:	00 
c01017e7:	89 04 24             	mov    %eax,(%esp)
c01017ea:	e8 e0 fe ff ff       	call   c01016cf <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017ef:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017f3:	83 c0 07             	add    $0x7,%eax
c01017f6:	0f b7 c0             	movzwl %ax,%eax
c01017f9:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017fd:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c0101801:	89 c2                	mov    %eax,%edx
c0101803:	ec                   	in     (%dx),%al
c0101804:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c0101807:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010180b:	84 c0                	test   %al,%al
c010180d:	0f 84 f7 01 00 00    	je     c0101a0a <ide_init+0x2e1>
c0101813:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101817:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010181e:	00 
c010181f:	89 04 24             	mov    %eax,(%esp)
c0101822:	e8 a8 fe ff ff       	call   c01016cf <ide_wait_ready>
c0101827:	85 c0                	test   %eax,%eax
c0101829:	0f 85 db 01 00 00    	jne    c0101a0a <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c010182f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101833:	c1 e0 03             	shl    $0x3,%eax
c0101836:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010183d:	29 c2                	sub    %eax,%edx
c010183f:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c0101845:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101848:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010184c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010184f:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101855:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101858:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c010185f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101862:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101865:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101868:	89 cb                	mov    %ecx,%ebx
c010186a:	89 df                	mov    %ebx,%edi
c010186c:	89 c1                	mov    %eax,%ecx
c010186e:	fc                   	cld    
c010186f:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101871:	89 c8                	mov    %ecx,%eax
c0101873:	89 fb                	mov    %edi,%ebx
c0101875:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101878:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c010187b:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101881:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101887:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c010188d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101890:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101893:	25 00 00 00 04       	and    $0x4000000,%eax
c0101898:	85 c0                	test   %eax,%eax
c010189a:	74 0e                	je     c01018aa <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c010189c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010189f:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c01018a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01018a8:	eb 09                	jmp    c01018b3 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c01018aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018ad:	8b 40 78             	mov    0x78(%eax),%eax
c01018b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c01018b3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018b7:	c1 e0 03             	shl    $0x3,%eax
c01018ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c1:	29 c2                	sub    %eax,%edx
c01018c3:	81 c2 80 36 12 c0    	add    $0xc0123680,%edx
c01018c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018cc:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018cf:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018d3:	c1 e0 03             	shl    $0x3,%eax
c01018d6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018dd:	29 c2                	sub    %eax,%edx
c01018df:	81 c2 80 36 12 c0    	add    $0xc0123680,%edx
c01018e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018e8:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018ee:	83 c0 62             	add    $0x62,%eax
c01018f1:	0f b7 00             	movzwl (%eax),%eax
c01018f4:	0f b7 c0             	movzwl %ax,%eax
c01018f7:	25 00 02 00 00       	and    $0x200,%eax
c01018fc:	85 c0                	test   %eax,%eax
c01018fe:	75 24                	jne    c0101924 <ide_init+0x1fb>
c0101900:	c7 44 24 0c 24 90 10 	movl   $0xc0109024,0xc(%esp)
c0101907:	c0 
c0101908:	c7 44 24 08 67 90 10 	movl   $0xc0109067,0x8(%esp)
c010190f:	c0 
c0101910:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101917:	00 
c0101918:	c7 04 24 7c 90 10 c0 	movl   $0xc010907c,(%esp)
c010191f:	e8 bd f3 ff ff       	call   c0100ce1 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101924:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101928:	c1 e0 03             	shl    $0x3,%eax
c010192b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101932:	29 c2                	sub    %eax,%edx
c0101934:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c010193a:	83 c0 0c             	add    $0xc,%eax
c010193d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101943:	83 c0 36             	add    $0x36,%eax
c0101946:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101949:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101950:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101957:	eb 34                	jmp    c010198d <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101959:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010195c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010195f:	01 c2                	add    %eax,%edx
c0101961:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101964:	8d 48 01             	lea    0x1(%eax),%ecx
c0101967:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010196a:	01 c8                	add    %ecx,%eax
c010196c:	0f b6 00             	movzbl (%eax),%eax
c010196f:	88 02                	mov    %al,(%edx)
c0101971:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101974:	8d 50 01             	lea    0x1(%eax),%edx
c0101977:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010197a:	01 c2                	add    %eax,%edx
c010197c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101982:	01 c8                	add    %ecx,%eax
c0101984:	0f b6 00             	movzbl (%eax),%eax
c0101987:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101989:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c010198d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101990:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101993:	72 c4                	jb     c0101959 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101995:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101998:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010199b:	01 d0                	add    %edx,%eax
c010199d:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c01019a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019a3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01019a6:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01019a9:	85 c0                	test   %eax,%eax
c01019ab:	74 0f                	je     c01019bc <ide_init+0x293>
c01019ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01019b3:	01 d0                	add    %edx,%eax
c01019b5:	0f b6 00             	movzbl (%eax),%eax
c01019b8:	3c 20                	cmp    $0x20,%al
c01019ba:	74 d9                	je     c0101995 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01019bc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019c0:	c1 e0 03             	shl    $0x3,%eax
c01019c3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019ca:	29 c2                	sub    %eax,%edx
c01019cc:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c01019d2:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019d5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019d9:	c1 e0 03             	shl    $0x3,%eax
c01019dc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019e3:	29 c2                	sub    %eax,%edx
c01019e5:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c01019eb:	8b 50 08             	mov    0x8(%eax),%edx
c01019ee:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f2:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019f6:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019fe:	c7 04 24 8e 90 10 c0 	movl   $0xc010908e,(%esp)
c0101a05:	e8 4d e9 ff ff       	call   c0100357 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101a0a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a0e:	83 c0 01             	add    $0x1,%eax
c0101a11:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101a15:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101a1a:	0f 86 1f fd ff ff    	jbe    c010173f <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a20:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a27:	e8 7c 05 00 00       	call   c0101fa8 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a2c:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a33:	e8 70 05 00 00       	call   c0101fa8 <pic_enable>
}
c0101a38:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a3e:	5b                   	pop    %ebx
c0101a3f:	5f                   	pop    %edi
c0101a40:	5d                   	pop    %ebp
c0101a41:	c3                   	ret    

c0101a42 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a42:	55                   	push   %ebp
c0101a43:	89 e5                	mov    %esp,%ebp
c0101a45:	83 ec 04             	sub    $0x4,%esp
c0101a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a4f:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a54:	77 24                	ja     c0101a7a <ide_device_valid+0x38>
c0101a56:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a5a:	c1 e0 03             	shl    $0x3,%eax
c0101a5d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a64:	29 c2                	sub    %eax,%edx
c0101a66:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c0101a6c:	0f b6 00             	movzbl (%eax),%eax
c0101a6f:	84 c0                	test   %al,%al
c0101a71:	74 07                	je     c0101a7a <ide_device_valid+0x38>
c0101a73:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a78:	eb 05                	jmp    c0101a7f <ide_device_valid+0x3d>
c0101a7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a7f:	c9                   	leave  
c0101a80:	c3                   	ret    

c0101a81 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a81:	55                   	push   %ebp
c0101a82:	89 e5                	mov    %esp,%ebp
c0101a84:	83 ec 08             	sub    $0x8,%esp
c0101a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a8a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a8e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a92:	89 04 24             	mov    %eax,(%esp)
c0101a95:	e8 a8 ff ff ff       	call   c0101a42 <ide_device_valid>
c0101a9a:	85 c0                	test   %eax,%eax
c0101a9c:	74 1b                	je     c0101ab9 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a9e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101aa2:	c1 e0 03             	shl    $0x3,%eax
c0101aa5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101aac:	29 c2                	sub    %eax,%edx
c0101aae:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c0101ab4:	8b 40 08             	mov    0x8(%eax),%eax
c0101ab7:	eb 05                	jmp    c0101abe <ide_device_size+0x3d>
    }
    return 0;
c0101ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101abe:	c9                   	leave  
c0101abf:	c3                   	ret    

c0101ac0 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101ac0:	55                   	push   %ebp
c0101ac1:	89 e5                	mov    %esp,%ebp
c0101ac3:	57                   	push   %edi
c0101ac4:	53                   	push   %ebx
c0101ac5:	83 ec 50             	sub    $0x50,%esp
c0101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101acb:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101acf:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ad6:	77 24                	ja     c0101afc <ide_read_secs+0x3c>
c0101ad8:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101add:	77 1d                	ja     c0101afc <ide_read_secs+0x3c>
c0101adf:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ae3:	c1 e0 03             	shl    $0x3,%eax
c0101ae6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101aed:	29 c2                	sub    %eax,%edx
c0101aef:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c0101af5:	0f b6 00             	movzbl (%eax),%eax
c0101af8:	84 c0                	test   %al,%al
c0101afa:	75 24                	jne    c0101b20 <ide_read_secs+0x60>
c0101afc:	c7 44 24 0c ac 90 10 	movl   $0xc01090ac,0xc(%esp)
c0101b03:	c0 
c0101b04:	c7 44 24 08 67 90 10 	movl   $0xc0109067,0x8(%esp)
c0101b0b:	c0 
c0101b0c:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101b13:	00 
c0101b14:	c7 04 24 7c 90 10 c0 	movl   $0xc010907c,(%esp)
c0101b1b:	e8 c1 f1 ff ff       	call   c0100ce1 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b20:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b27:	77 0f                	ja     c0101b38 <ide_read_secs+0x78>
c0101b29:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b2f:	01 d0                	add    %edx,%eax
c0101b31:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b36:	76 24                	jbe    c0101b5c <ide_read_secs+0x9c>
c0101b38:	c7 44 24 0c d4 90 10 	movl   $0xc01090d4,0xc(%esp)
c0101b3f:	c0 
c0101b40:	c7 44 24 08 67 90 10 	movl   $0xc0109067,0x8(%esp)
c0101b47:	c0 
c0101b48:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b4f:	00 
c0101b50:	c7 04 24 7c 90 10 c0 	movl   $0xc010907c,(%esp)
c0101b57:	e8 85 f1 ff ff       	call   c0100ce1 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b5c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b60:	66 d1 e8             	shr    %ax
c0101b63:	0f b7 c0             	movzwl %ax,%eax
c0101b66:	0f b7 04 85 1c 90 10 	movzwl -0x3fef6fe4(,%eax,4),%eax
c0101b6d:	c0 
c0101b6e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b72:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b76:	66 d1 e8             	shr    %ax
c0101b79:	0f b7 c0             	movzwl %ax,%eax
c0101b7c:	0f b7 04 85 1e 90 10 	movzwl -0x3fef6fe2(,%eax,4),%eax
c0101b83:	c0 
c0101b84:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b88:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b8c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b93:	00 
c0101b94:	89 04 24             	mov    %eax,(%esp)
c0101b97:	e8 33 fb ff ff       	call   c01016cf <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b9c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101ba0:	83 c0 02             	add    $0x2,%eax
c0101ba3:	0f b7 c0             	movzwl %ax,%eax
c0101ba6:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101baa:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101bae:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101bb2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101bb6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101bb7:	8b 45 14             	mov    0x14(%ebp),%eax
c0101bba:	0f b6 c0             	movzbl %al,%eax
c0101bbd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bc1:	83 c2 02             	add    $0x2,%edx
c0101bc4:	0f b7 d2             	movzwl %dx,%edx
c0101bc7:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bcb:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bce:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bd2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bd6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bda:	0f b6 c0             	movzbl %al,%eax
c0101bdd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101be1:	83 c2 03             	add    $0x3,%edx
c0101be4:	0f b7 d2             	movzwl %dx,%edx
c0101be7:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101beb:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bee:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bf2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101bf6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bfa:	c1 e8 08             	shr    $0x8,%eax
c0101bfd:	0f b6 c0             	movzbl %al,%eax
c0101c00:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c04:	83 c2 04             	add    $0x4,%edx
c0101c07:	0f b7 d2             	movzwl %dx,%edx
c0101c0a:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101c0e:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101c11:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101c15:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c19:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c1d:	c1 e8 10             	shr    $0x10,%eax
c0101c20:	0f b6 c0             	movzbl %al,%eax
c0101c23:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c27:	83 c2 05             	add    $0x5,%edx
c0101c2a:	0f b7 d2             	movzwl %dx,%edx
c0101c2d:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c31:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c34:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c38:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c3c:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c3d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c41:	83 e0 01             	and    $0x1,%eax
c0101c44:	c1 e0 04             	shl    $0x4,%eax
c0101c47:	89 c2                	mov    %eax,%edx
c0101c49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c4c:	c1 e8 18             	shr    $0x18,%eax
c0101c4f:	83 e0 0f             	and    $0xf,%eax
c0101c52:	09 d0                	or     %edx,%eax
c0101c54:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c57:	0f b6 c0             	movzbl %al,%eax
c0101c5a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c5e:	83 c2 06             	add    $0x6,%edx
c0101c61:	0f b7 d2             	movzwl %dx,%edx
c0101c64:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c68:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c6b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c6f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c73:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c74:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c78:	83 c0 07             	add    $0x7,%eax
c0101c7b:	0f b7 c0             	movzwl %ax,%eax
c0101c7e:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c82:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c86:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c8a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c8e:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c96:	eb 5a                	jmp    c0101cf2 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c98:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c9c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ca3:	00 
c0101ca4:	89 04 24             	mov    %eax,(%esp)
c0101ca7:	e8 23 fa ff ff       	call   c01016cf <ide_wait_ready>
c0101cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101caf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101cb3:	74 02                	je     c0101cb7 <ide_read_secs+0x1f7>
            goto out;
c0101cb5:	eb 41                	jmp    c0101cf8 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101cb7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101cbb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101cbe:	8b 45 10             	mov    0x10(%ebp),%eax
c0101cc1:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101cc4:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101ccb:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cce:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cd1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cd4:	89 cb                	mov    %ecx,%ebx
c0101cd6:	89 df                	mov    %ebx,%edi
c0101cd8:	89 c1                	mov    %eax,%ecx
c0101cda:	fc                   	cld    
c0101cdb:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cdd:	89 c8                	mov    %ecx,%eax
c0101cdf:	89 fb                	mov    %edi,%ebx
c0101ce1:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101ce4:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101ce7:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101ceb:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cf2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101cf6:	75 a0                	jne    c0101c98 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101cfb:	83 c4 50             	add    $0x50,%esp
c0101cfe:	5b                   	pop    %ebx
c0101cff:	5f                   	pop    %edi
c0101d00:	5d                   	pop    %ebp
c0101d01:	c3                   	ret    

c0101d02 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101d02:	55                   	push   %ebp
c0101d03:	89 e5                	mov    %esp,%ebp
c0101d05:	56                   	push   %esi
c0101d06:	53                   	push   %ebx
c0101d07:	83 ec 50             	sub    $0x50,%esp
c0101d0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0d:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101d11:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d18:	77 24                	ja     c0101d3e <ide_write_secs+0x3c>
c0101d1a:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d1f:	77 1d                	ja     c0101d3e <ide_write_secs+0x3c>
c0101d21:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d25:	c1 e0 03             	shl    $0x3,%eax
c0101d28:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d2f:	29 c2                	sub    %eax,%edx
c0101d31:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c0101d37:	0f b6 00             	movzbl (%eax),%eax
c0101d3a:	84 c0                	test   %al,%al
c0101d3c:	75 24                	jne    c0101d62 <ide_write_secs+0x60>
c0101d3e:	c7 44 24 0c ac 90 10 	movl   $0xc01090ac,0xc(%esp)
c0101d45:	c0 
c0101d46:	c7 44 24 08 67 90 10 	movl   $0xc0109067,0x8(%esp)
c0101d4d:	c0 
c0101d4e:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d55:	00 
c0101d56:	c7 04 24 7c 90 10 c0 	movl   $0xc010907c,(%esp)
c0101d5d:	e8 7f ef ff ff       	call   c0100ce1 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d62:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d69:	77 0f                	ja     c0101d7a <ide_write_secs+0x78>
c0101d6b:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d71:	01 d0                	add    %edx,%eax
c0101d73:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d78:	76 24                	jbe    c0101d9e <ide_write_secs+0x9c>
c0101d7a:	c7 44 24 0c d4 90 10 	movl   $0xc01090d4,0xc(%esp)
c0101d81:	c0 
c0101d82:	c7 44 24 08 67 90 10 	movl   $0xc0109067,0x8(%esp)
c0101d89:	c0 
c0101d8a:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d91:	00 
c0101d92:	c7 04 24 7c 90 10 c0 	movl   $0xc010907c,(%esp)
c0101d99:	e8 43 ef ff ff       	call   c0100ce1 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d9e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101da2:	66 d1 e8             	shr    %ax
c0101da5:	0f b7 c0             	movzwl %ax,%eax
c0101da8:	0f b7 04 85 1c 90 10 	movzwl -0x3fef6fe4(,%eax,4),%eax
c0101daf:	c0 
c0101db0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101db4:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101db8:	66 d1 e8             	shr    %ax
c0101dbb:	0f b7 c0             	movzwl %ax,%eax
c0101dbe:	0f b7 04 85 1e 90 10 	movzwl -0x3fef6fe2(,%eax,4),%eax
c0101dc5:	c0 
c0101dc6:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101dca:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101dce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101dd5:	00 
c0101dd6:	89 04 24             	mov    %eax,(%esp)
c0101dd9:	e8 f1 f8 ff ff       	call   c01016cf <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dde:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101de2:	83 c0 02             	add    $0x2,%eax
c0101de5:	0f b7 c0             	movzwl %ax,%eax
c0101de8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dec:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101df0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101df4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101df8:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101df9:	8b 45 14             	mov    0x14(%ebp),%eax
c0101dfc:	0f b6 c0             	movzbl %al,%eax
c0101dff:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e03:	83 c2 02             	add    $0x2,%edx
c0101e06:	0f b7 d2             	movzwl %dx,%edx
c0101e09:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101e0d:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101e10:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101e14:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101e18:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e1c:	0f b6 c0             	movzbl %al,%eax
c0101e1f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e23:	83 c2 03             	add    $0x3,%edx
c0101e26:	0f b7 d2             	movzwl %dx,%edx
c0101e29:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e2d:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e30:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e34:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e38:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e39:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e3c:	c1 e8 08             	shr    $0x8,%eax
c0101e3f:	0f b6 c0             	movzbl %al,%eax
c0101e42:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e46:	83 c2 04             	add    $0x4,%edx
c0101e49:	0f b7 d2             	movzwl %dx,%edx
c0101e4c:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e50:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e53:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e57:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e5b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e5f:	c1 e8 10             	shr    $0x10,%eax
c0101e62:	0f b6 c0             	movzbl %al,%eax
c0101e65:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e69:	83 c2 05             	add    $0x5,%edx
c0101e6c:	0f b7 d2             	movzwl %dx,%edx
c0101e6f:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e73:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e76:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e7a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e7e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e7f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e83:	83 e0 01             	and    $0x1,%eax
c0101e86:	c1 e0 04             	shl    $0x4,%eax
c0101e89:	89 c2                	mov    %eax,%edx
c0101e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e8e:	c1 e8 18             	shr    $0x18,%eax
c0101e91:	83 e0 0f             	and    $0xf,%eax
c0101e94:	09 d0                	or     %edx,%eax
c0101e96:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e99:	0f b6 c0             	movzbl %al,%eax
c0101e9c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ea0:	83 c2 06             	add    $0x6,%edx
c0101ea3:	0f b7 d2             	movzwl %dx,%edx
c0101ea6:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101eaa:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101ead:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101eb1:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101eb5:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101eb6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101eba:	83 c0 07             	add    $0x7,%eax
c0101ebd:	0f b7 c0             	movzwl %ax,%eax
c0101ec0:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101ec4:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101ec8:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101ecc:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101ed0:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101ed1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ed8:	eb 5a                	jmp    c0101f34 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101eda:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ede:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ee5:	00 
c0101ee6:	89 04 24             	mov    %eax,(%esp)
c0101ee9:	e8 e1 f7 ff ff       	call   c01016cf <ide_wait_ready>
c0101eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101ef1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101ef5:	74 02                	je     c0101ef9 <ide_write_secs+0x1f7>
            goto out;
c0101ef7:	eb 41                	jmp    c0101f3a <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101ef9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101efd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101f00:	8b 45 10             	mov    0x10(%ebp),%eax
c0101f03:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101f06:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101f0d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101f10:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101f13:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f16:	89 cb                	mov    %ecx,%ebx
c0101f18:	89 de                	mov    %ebx,%esi
c0101f1a:	89 c1                	mov    %eax,%ecx
c0101f1c:	fc                   	cld    
c0101f1d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f1f:	89 c8                	mov    %ecx,%eax
c0101f21:	89 f3                	mov    %esi,%ebx
c0101f23:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f26:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f29:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f2d:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f34:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f38:	75 a0                	jne    c0101eda <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f3d:	83 c4 50             	add    $0x50,%esp
c0101f40:	5b                   	pop    %ebx
c0101f41:	5e                   	pop    %esi
c0101f42:	5d                   	pop    %ebp
c0101f43:	c3                   	ret    

c0101f44 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f44:	55                   	push   %ebp
c0101f45:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f47:	fb                   	sti    
    sti();
}
c0101f48:	5d                   	pop    %ebp
c0101f49:	c3                   	ret    

c0101f4a <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f4a:	55                   	push   %ebp
c0101f4b:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f4d:	fa                   	cli    
    cli();
}
c0101f4e:	5d                   	pop    %ebp
c0101f4f:	c3                   	ret    

c0101f50 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f50:	55                   	push   %ebp
c0101f51:	89 e5                	mov    %esp,%ebp
c0101f53:	83 ec 14             	sub    $0x14,%esp
c0101f56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f59:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f5d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f61:	66 a3 50 05 12 c0    	mov    %ax,0xc0120550
    if (did_init) {
c0101f67:	a1 60 37 12 c0       	mov    0xc0123760,%eax
c0101f6c:	85 c0                	test   %eax,%eax
c0101f6e:	74 36                	je     c0101fa6 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f70:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f74:	0f b6 c0             	movzbl %al,%eax
c0101f77:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f7d:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f80:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f84:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f88:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f89:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f8d:	66 c1 e8 08          	shr    $0x8,%ax
c0101f91:	0f b6 c0             	movzbl %al,%eax
c0101f94:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f9a:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f9d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101fa1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fa5:	ee                   	out    %al,(%dx)
    }
}
c0101fa6:	c9                   	leave  
c0101fa7:	c3                   	ret    

c0101fa8 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101fa8:	55                   	push   %ebp
c0101fa9:	89 e5                	mov    %esp,%ebp
c0101fab:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101fae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fb1:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fb6:	89 c1                	mov    %eax,%ecx
c0101fb8:	d3 e2                	shl    %cl,%edx
c0101fba:	89 d0                	mov    %edx,%eax
c0101fbc:	f7 d0                	not    %eax
c0101fbe:	89 c2                	mov    %eax,%edx
c0101fc0:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c0101fc7:	21 d0                	and    %edx,%eax
c0101fc9:	0f b7 c0             	movzwl %ax,%eax
c0101fcc:	89 04 24             	mov    %eax,(%esp)
c0101fcf:	e8 7c ff ff ff       	call   c0101f50 <pic_setmask>
}
c0101fd4:	c9                   	leave  
c0101fd5:	c3                   	ret    

c0101fd6 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fd6:	55                   	push   %ebp
c0101fd7:	89 e5                	mov    %esp,%ebp
c0101fd9:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fdc:	c7 05 60 37 12 c0 01 	movl   $0x1,0xc0123760
c0101fe3:	00 00 00 
c0101fe6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fec:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101ff0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101ff4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101ff8:	ee                   	out    %al,(%dx)
c0101ff9:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fff:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0102003:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0102007:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010200b:	ee                   	out    %al,(%dx)
c010200c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0102012:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0102016:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010201a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010201e:	ee                   	out    %al,(%dx)
c010201f:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102025:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102029:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010202d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102031:	ee                   	out    %al,(%dx)
c0102032:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102038:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010203c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102040:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102044:	ee                   	out    %al,(%dx)
c0102045:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010204b:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c010204f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102053:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102057:	ee                   	out    %al,(%dx)
c0102058:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c010205e:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102062:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102066:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010206a:	ee                   	out    %al,(%dx)
c010206b:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102071:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102075:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102079:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010207d:	ee                   	out    %al,(%dx)
c010207e:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102084:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102088:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010208c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102090:	ee                   	out    %al,(%dx)
c0102091:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102097:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010209b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010209f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01020a3:	ee                   	out    %al,(%dx)
c01020a4:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c01020aa:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c01020ae:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01020b2:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020b6:	ee                   	out    %al,(%dx)
c01020b7:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020bd:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020c1:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020c5:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020c9:	ee                   	out    %al,(%dx)
c01020ca:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020d0:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020d4:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020d8:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020dc:	ee                   	out    %al,(%dx)
c01020dd:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020e3:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020e7:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020eb:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020ef:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020f0:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c01020f7:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020fb:	74 12                	je     c010210f <pic_init+0x139>
        pic_setmask(irq_mask);
c01020fd:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c0102104:	0f b7 c0             	movzwl %ax,%eax
c0102107:	89 04 24             	mov    %eax,(%esp)
c010210a:	e8 41 fe ff ff       	call   c0101f50 <pic_setmask>
    }
}
c010210f:	c9                   	leave  
c0102110:	c3                   	ret    

c0102111 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0102111:	55                   	push   %ebp
c0102112:	89 e5                	mov    %esp,%ebp
c0102114:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102117:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010211e:	00 
c010211f:	c7 04 24 20 91 10 c0 	movl   $0xc0109120,(%esp)
c0102126:	e8 2c e2 ff ff       	call   c0100357 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010212b:	c9                   	leave  
c010212c:	c3                   	ret    

c010212d <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010212d:	55                   	push   %ebp
c010212e:	89 e5                	mov    %esp,%ebp
c0102130:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0102133:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010213a:	e9 c3 00 00 00       	jmp    c0102202 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010213f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102142:	8b 04 85 e0 05 12 c0 	mov    -0x3fedfa20(,%eax,4),%eax
c0102149:	89 c2                	mov    %eax,%edx
c010214b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010214e:	66 89 14 c5 80 37 12 	mov    %dx,-0x3fedc880(,%eax,8)
c0102155:	c0 
c0102156:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102159:	66 c7 04 c5 82 37 12 	movw   $0x8,-0x3fedc87e(,%eax,8)
c0102160:	c0 08 00 
c0102163:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102166:	0f b6 14 c5 84 37 12 	movzbl -0x3fedc87c(,%eax,8),%edx
c010216d:	c0 
c010216e:	83 e2 e0             	and    $0xffffffe0,%edx
c0102171:	88 14 c5 84 37 12 c0 	mov    %dl,-0x3fedc87c(,%eax,8)
c0102178:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010217b:	0f b6 14 c5 84 37 12 	movzbl -0x3fedc87c(,%eax,8),%edx
c0102182:	c0 
c0102183:	83 e2 1f             	and    $0x1f,%edx
c0102186:	88 14 c5 84 37 12 c0 	mov    %dl,-0x3fedc87c(,%eax,8)
c010218d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102190:	0f b6 14 c5 85 37 12 	movzbl -0x3fedc87b(,%eax,8),%edx
c0102197:	c0 
c0102198:	83 e2 f0             	and    $0xfffffff0,%edx
c010219b:	83 ca 0e             	or     $0xe,%edx
c010219e:	88 14 c5 85 37 12 c0 	mov    %dl,-0x3fedc87b(,%eax,8)
c01021a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a8:	0f b6 14 c5 85 37 12 	movzbl -0x3fedc87b(,%eax,8),%edx
c01021af:	c0 
c01021b0:	83 e2 ef             	and    $0xffffffef,%edx
c01021b3:	88 14 c5 85 37 12 c0 	mov    %dl,-0x3fedc87b(,%eax,8)
c01021ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021bd:	0f b6 14 c5 85 37 12 	movzbl -0x3fedc87b(,%eax,8),%edx
c01021c4:	c0 
c01021c5:	83 e2 9f             	and    $0xffffff9f,%edx
c01021c8:	88 14 c5 85 37 12 c0 	mov    %dl,-0x3fedc87b(,%eax,8)
c01021cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d2:	0f b6 14 c5 85 37 12 	movzbl -0x3fedc87b(,%eax,8),%edx
c01021d9:	c0 
c01021da:	83 ca 80             	or     $0xffffff80,%edx
c01021dd:	88 14 c5 85 37 12 c0 	mov    %dl,-0x3fedc87b(,%eax,8)
c01021e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e7:	8b 04 85 e0 05 12 c0 	mov    -0x3fedfa20(,%eax,4),%eax
c01021ee:	c1 e8 10             	shr    $0x10,%eax
c01021f1:	89 c2                	mov    %eax,%edx
c01021f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f6:	66 89 14 c5 86 37 12 	mov    %dx,-0x3fedc87a(,%eax,8)
c01021fd:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01021fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102202:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102205:	3d ff 00 00 00       	cmp    $0xff,%eax
c010220a:	0f 86 2f ff ff ff    	jbe    c010213f <idt_init+0x12>
c0102210:	c7 45 f8 60 05 12 c0 	movl   $0xc0120560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102217:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010221a:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
c010221d:	c9                   	leave  
c010221e:	c3                   	ret    

c010221f <trapname>:

static const char *
trapname(int trapno) {
c010221f:	55                   	push   %ebp
c0102220:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102222:	8b 45 08             	mov    0x8(%ebp),%eax
c0102225:	83 f8 13             	cmp    $0x13,%eax
c0102228:	77 0c                	ja     c0102236 <trapname+0x17>
        return excnames[trapno];
c010222a:	8b 45 08             	mov    0x8(%ebp),%eax
c010222d:	8b 04 85 00 95 10 c0 	mov    -0x3fef6b00(,%eax,4),%eax
c0102234:	eb 18                	jmp    c010224e <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102236:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010223a:	7e 0d                	jle    c0102249 <trapname+0x2a>
c010223c:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102240:	7f 07                	jg     c0102249 <trapname+0x2a>
        return "Hardware Interrupt";
c0102242:	b8 2a 91 10 c0       	mov    $0xc010912a,%eax
c0102247:	eb 05                	jmp    c010224e <trapname+0x2f>
    }
    return "(unknown trap)";
c0102249:	b8 3d 91 10 c0       	mov    $0xc010913d,%eax
}
c010224e:	5d                   	pop    %ebp
c010224f:	c3                   	ret    

c0102250 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102250:	55                   	push   %ebp
c0102251:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102253:	8b 45 08             	mov    0x8(%ebp),%eax
c0102256:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010225a:	66 83 f8 08          	cmp    $0x8,%ax
c010225e:	0f 94 c0             	sete   %al
c0102261:	0f b6 c0             	movzbl %al,%eax
}
c0102264:	5d                   	pop    %ebp
c0102265:	c3                   	ret    

c0102266 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102266:	55                   	push   %ebp
c0102267:	89 e5                	mov    %esp,%ebp
c0102269:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010226c:	8b 45 08             	mov    0x8(%ebp),%eax
c010226f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102273:	c7 04 24 7e 91 10 c0 	movl   $0xc010917e,(%esp)
c010227a:	e8 d8 e0 ff ff       	call   c0100357 <cprintf>
    print_regs(&tf->tf_regs);
c010227f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102282:	89 04 24             	mov    %eax,(%esp)
c0102285:	e8 a1 01 00 00       	call   c010242b <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010228a:	8b 45 08             	mov    0x8(%ebp),%eax
c010228d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102291:	0f b7 c0             	movzwl %ax,%eax
c0102294:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102298:	c7 04 24 8f 91 10 c0 	movl   $0xc010918f,(%esp)
c010229f:	e8 b3 e0 ff ff       	call   c0100357 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01022a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01022a7:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01022ab:	0f b7 c0             	movzwl %ax,%eax
c01022ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022b2:	c7 04 24 a2 91 10 c0 	movl   $0xc01091a2,(%esp)
c01022b9:	e8 99 e0 ff ff       	call   c0100357 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01022be:	8b 45 08             	mov    0x8(%ebp),%eax
c01022c1:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01022c5:	0f b7 c0             	movzwl %ax,%eax
c01022c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022cc:	c7 04 24 b5 91 10 c0 	movl   $0xc01091b5,(%esp)
c01022d3:	e8 7f e0 ff ff       	call   c0100357 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01022d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01022db:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c01022df:	0f b7 c0             	movzwl %ax,%eax
c01022e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022e6:	c7 04 24 c8 91 10 c0 	movl   $0xc01091c8,(%esp)
c01022ed:	e8 65 e0 ff ff       	call   c0100357 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01022f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f5:	8b 40 30             	mov    0x30(%eax),%eax
c01022f8:	89 04 24             	mov    %eax,(%esp)
c01022fb:	e8 1f ff ff ff       	call   c010221f <trapname>
c0102300:	8b 55 08             	mov    0x8(%ebp),%edx
c0102303:	8b 52 30             	mov    0x30(%edx),%edx
c0102306:	89 44 24 08          	mov    %eax,0x8(%esp)
c010230a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010230e:	c7 04 24 db 91 10 c0 	movl   $0xc01091db,(%esp)
c0102315:	e8 3d e0 ff ff       	call   c0100357 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c010231a:	8b 45 08             	mov    0x8(%ebp),%eax
c010231d:	8b 40 34             	mov    0x34(%eax),%eax
c0102320:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102324:	c7 04 24 ed 91 10 c0 	movl   $0xc01091ed,(%esp)
c010232b:	e8 27 e0 ff ff       	call   c0100357 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102330:	8b 45 08             	mov    0x8(%ebp),%eax
c0102333:	8b 40 38             	mov    0x38(%eax),%eax
c0102336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010233a:	c7 04 24 fc 91 10 c0 	movl   $0xc01091fc,(%esp)
c0102341:	e8 11 e0 ff ff       	call   c0100357 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102346:	8b 45 08             	mov    0x8(%ebp),%eax
c0102349:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010234d:	0f b7 c0             	movzwl %ax,%eax
c0102350:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102354:	c7 04 24 0b 92 10 c0 	movl   $0xc010920b,(%esp)
c010235b:	e8 f7 df ff ff       	call   c0100357 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0102360:	8b 45 08             	mov    0x8(%ebp),%eax
c0102363:	8b 40 40             	mov    0x40(%eax),%eax
c0102366:	89 44 24 04          	mov    %eax,0x4(%esp)
c010236a:	c7 04 24 1e 92 10 c0 	movl   $0xc010921e,(%esp)
c0102371:	e8 e1 df ff ff       	call   c0100357 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102376:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010237d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102384:	eb 3e                	jmp    c01023c4 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102386:	8b 45 08             	mov    0x8(%ebp),%eax
c0102389:	8b 50 40             	mov    0x40(%eax),%edx
c010238c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010238f:	21 d0                	and    %edx,%eax
c0102391:	85 c0                	test   %eax,%eax
c0102393:	74 28                	je     c01023bd <print_trapframe+0x157>
c0102395:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102398:	8b 04 85 80 05 12 c0 	mov    -0x3fedfa80(,%eax,4),%eax
c010239f:	85 c0                	test   %eax,%eax
c01023a1:	74 1a                	je     c01023bd <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023a6:	8b 04 85 80 05 12 c0 	mov    -0x3fedfa80(,%eax,4),%eax
c01023ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023b1:	c7 04 24 2d 92 10 c0 	movl   $0xc010922d,(%esp)
c01023b8:	e8 9a df ff ff       	call   c0100357 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01023c1:	d1 65 f0             	shll   -0x10(%ebp)
c01023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023c7:	83 f8 17             	cmp    $0x17,%eax
c01023ca:	76 ba                	jbe    c0102386 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01023cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01023cf:	8b 40 40             	mov    0x40(%eax),%eax
c01023d2:	25 00 30 00 00       	and    $0x3000,%eax
c01023d7:	c1 e8 0c             	shr    $0xc,%eax
c01023da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023de:	c7 04 24 31 92 10 c0 	movl   $0xc0109231,(%esp)
c01023e5:	e8 6d df ff ff       	call   c0100357 <cprintf>

    if (!trap_in_kernel(tf)) {
c01023ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ed:	89 04 24             	mov    %eax,(%esp)
c01023f0:	e8 5b fe ff ff       	call   c0102250 <trap_in_kernel>
c01023f5:	85 c0                	test   %eax,%eax
c01023f7:	75 30                	jne    c0102429 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01023f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01023fc:	8b 40 44             	mov    0x44(%eax),%eax
c01023ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102403:	c7 04 24 3a 92 10 c0 	movl   $0xc010923a,(%esp)
c010240a:	e8 48 df ff ff       	call   c0100357 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010240f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102412:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102416:	0f b7 c0             	movzwl %ax,%eax
c0102419:	89 44 24 04          	mov    %eax,0x4(%esp)
c010241d:	c7 04 24 49 92 10 c0 	movl   $0xc0109249,(%esp)
c0102424:	e8 2e df ff ff       	call   c0100357 <cprintf>
    }
}
c0102429:	c9                   	leave  
c010242a:	c3                   	ret    

c010242b <print_regs>:

void
print_regs(struct pushregs *regs) {
c010242b:	55                   	push   %ebp
c010242c:	89 e5                	mov    %esp,%ebp
c010242e:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102431:	8b 45 08             	mov    0x8(%ebp),%eax
c0102434:	8b 00                	mov    (%eax),%eax
c0102436:	89 44 24 04          	mov    %eax,0x4(%esp)
c010243a:	c7 04 24 5c 92 10 c0 	movl   $0xc010925c,(%esp)
c0102441:	e8 11 df ff ff       	call   c0100357 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102446:	8b 45 08             	mov    0x8(%ebp),%eax
c0102449:	8b 40 04             	mov    0x4(%eax),%eax
c010244c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102450:	c7 04 24 6b 92 10 c0 	movl   $0xc010926b,(%esp)
c0102457:	e8 fb de ff ff       	call   c0100357 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c010245c:	8b 45 08             	mov    0x8(%ebp),%eax
c010245f:	8b 40 08             	mov    0x8(%eax),%eax
c0102462:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102466:	c7 04 24 7a 92 10 c0 	movl   $0xc010927a,(%esp)
c010246d:	e8 e5 de ff ff       	call   c0100357 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102472:	8b 45 08             	mov    0x8(%ebp),%eax
c0102475:	8b 40 0c             	mov    0xc(%eax),%eax
c0102478:	89 44 24 04          	mov    %eax,0x4(%esp)
c010247c:	c7 04 24 89 92 10 c0 	movl   $0xc0109289,(%esp)
c0102483:	e8 cf de ff ff       	call   c0100357 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102488:	8b 45 08             	mov    0x8(%ebp),%eax
c010248b:	8b 40 10             	mov    0x10(%eax),%eax
c010248e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102492:	c7 04 24 98 92 10 c0 	movl   $0xc0109298,(%esp)
c0102499:	e8 b9 de ff ff       	call   c0100357 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c010249e:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a1:	8b 40 14             	mov    0x14(%eax),%eax
c01024a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a8:	c7 04 24 a7 92 10 c0 	movl   $0xc01092a7,(%esp)
c01024af:	e8 a3 de ff ff       	call   c0100357 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01024b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b7:	8b 40 18             	mov    0x18(%eax),%eax
c01024ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024be:	c7 04 24 b6 92 10 c0 	movl   $0xc01092b6,(%esp)
c01024c5:	e8 8d de ff ff       	call   c0100357 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01024ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01024cd:	8b 40 1c             	mov    0x1c(%eax),%eax
c01024d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024d4:	c7 04 24 c5 92 10 c0 	movl   $0xc01092c5,(%esp)
c01024db:	e8 77 de ff ff       	call   c0100357 <cprintf>
}
c01024e0:	c9                   	leave  
c01024e1:	c3                   	ret    

c01024e2 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c01024e2:	55                   	push   %ebp
c01024e3:	89 e5                	mov    %esp,%ebp
c01024e5:	53                   	push   %ebx
c01024e6:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c01024e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ec:	8b 40 34             	mov    0x34(%eax),%eax
c01024ef:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01024f2:	85 c0                	test   %eax,%eax
c01024f4:	74 07                	je     c01024fd <print_pgfault+0x1b>
c01024f6:	b9 d4 92 10 c0       	mov    $0xc01092d4,%ecx
c01024fb:	eb 05                	jmp    c0102502 <print_pgfault+0x20>
c01024fd:	b9 e5 92 10 c0       	mov    $0xc01092e5,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102502:	8b 45 08             	mov    0x8(%ebp),%eax
c0102505:	8b 40 34             	mov    0x34(%eax),%eax
c0102508:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010250b:	85 c0                	test   %eax,%eax
c010250d:	74 07                	je     c0102516 <print_pgfault+0x34>
c010250f:	ba 57 00 00 00       	mov    $0x57,%edx
c0102514:	eb 05                	jmp    c010251b <print_pgfault+0x39>
c0102516:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c010251b:	8b 45 08             	mov    0x8(%ebp),%eax
c010251e:	8b 40 34             	mov    0x34(%eax),%eax
c0102521:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102524:	85 c0                	test   %eax,%eax
c0102526:	74 07                	je     c010252f <print_pgfault+0x4d>
c0102528:	b8 55 00 00 00       	mov    $0x55,%eax
c010252d:	eb 05                	jmp    c0102534 <print_pgfault+0x52>
c010252f:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102534:	0f 20 d3             	mov    %cr2,%ebx
c0102537:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c010253a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c010253d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102541:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102545:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102549:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010254d:	c7 04 24 f4 92 10 c0 	movl   $0xc01092f4,(%esp)
c0102554:	e8 fe dd ff ff       	call   c0100357 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c0102559:	83 c4 34             	add    $0x34,%esp
c010255c:	5b                   	pop    %ebx
c010255d:	5d                   	pop    %ebp
c010255e:	c3                   	ret    

c010255f <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010255f:	55                   	push   %ebp
c0102560:	89 e5                	mov    %esp,%ebp
c0102562:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102565:	8b 45 08             	mov    0x8(%ebp),%eax
c0102568:	89 04 24             	mov    %eax,(%esp)
c010256b:	e8 72 ff ff ff       	call   c01024e2 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102570:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c0102575:	85 c0                	test   %eax,%eax
c0102577:	74 28                	je     c01025a1 <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102579:	0f 20 d0             	mov    %cr2,%eax
c010257c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c010257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102582:	89 c1                	mov    %eax,%ecx
c0102584:	8b 45 08             	mov    0x8(%ebp),%eax
c0102587:	8b 50 34             	mov    0x34(%eax),%edx
c010258a:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c010258f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0102593:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102597:	89 04 24             	mov    %eax,(%esp)
c010259a:	e8 44 57 00 00       	call   c0107ce3 <do_pgfault>
c010259f:	eb 1c                	jmp    c01025bd <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c01025a1:	c7 44 24 08 17 93 10 	movl   $0xc0109317,0x8(%esp)
c01025a8:	c0 
c01025a9:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c01025b0:	00 
c01025b1:	c7 04 24 2e 93 10 c0 	movl   $0xc010932e,(%esp)
c01025b8:	e8 24 e7 ff ff       	call   c0100ce1 <__panic>
}
c01025bd:	c9                   	leave  
c01025be:	c3                   	ret    

c01025bf <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01025bf:	55                   	push   %ebp
c01025c0:	89 e5                	mov    %esp,%ebp
c01025c2:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c01025c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01025c8:	8b 40 30             	mov    0x30(%eax),%eax
c01025cb:	83 f8 24             	cmp    $0x24,%eax
c01025ce:	0f 84 c2 00 00 00    	je     c0102696 <trap_dispatch+0xd7>
c01025d4:	83 f8 24             	cmp    $0x24,%eax
c01025d7:	77 18                	ja     c01025f1 <trap_dispatch+0x32>
c01025d9:	83 f8 20             	cmp    $0x20,%eax
c01025dc:	74 7d                	je     c010265b <trap_dispatch+0x9c>
c01025de:	83 f8 21             	cmp    $0x21,%eax
c01025e1:	0f 84 d5 00 00 00    	je     c01026bc <trap_dispatch+0xfd>
c01025e7:	83 f8 0e             	cmp    $0xe,%eax
c01025ea:	74 28                	je     c0102614 <trap_dispatch+0x55>
c01025ec:	e9 0d 01 00 00       	jmp    c01026fe <trap_dispatch+0x13f>
c01025f1:	83 f8 2e             	cmp    $0x2e,%eax
c01025f4:	0f 82 04 01 00 00    	jb     c01026fe <trap_dispatch+0x13f>
c01025fa:	83 f8 2f             	cmp    $0x2f,%eax
c01025fd:	0f 86 33 01 00 00    	jbe    c0102736 <trap_dispatch+0x177>
c0102603:	83 e8 78             	sub    $0x78,%eax
c0102606:	83 f8 01             	cmp    $0x1,%eax
c0102609:	0f 87 ef 00 00 00    	ja     c01026fe <trap_dispatch+0x13f>
c010260f:	e9 ce 00 00 00       	jmp    c01026e2 <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102614:	8b 45 08             	mov    0x8(%ebp),%eax
c0102617:	89 04 24             	mov    %eax,(%esp)
c010261a:	e8 40 ff ff ff       	call   c010255f <pgfault_handler>
c010261f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102626:	74 2e                	je     c0102656 <trap_dispatch+0x97>
            print_trapframe(tf);
c0102628:	8b 45 08             	mov    0x8(%ebp),%eax
c010262b:	89 04 24             	mov    %eax,(%esp)
c010262e:	e8 33 fc ff ff       	call   c0102266 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102633:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102636:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010263a:	c7 44 24 08 3f 93 10 	movl   $0xc010933f,0x8(%esp)
c0102641:	c0 
c0102642:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0102649:	00 
c010264a:	c7 04 24 2e 93 10 c0 	movl   $0xc010932e,(%esp)
c0102651:	e8 8b e6 ff ff       	call   c0100ce1 <__panic>
        }
        break;
c0102656:	e9 dc 00 00 00       	jmp    c0102737 <trap_dispatch+0x178>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c010265b:	a1 3c 40 12 c0       	mov    0xc012403c,%eax
c0102660:	83 c0 01             	add    $0x1,%eax
c0102663:	a3 3c 40 12 c0       	mov    %eax,0xc012403c
        if (ticks % TICK_NUM == 0) {
c0102668:	8b 0d 3c 40 12 c0    	mov    0xc012403c,%ecx
c010266e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102673:	89 c8                	mov    %ecx,%eax
c0102675:	f7 e2                	mul    %edx
c0102677:	89 d0                	mov    %edx,%eax
c0102679:	c1 e8 05             	shr    $0x5,%eax
c010267c:	6b c0 64             	imul   $0x64,%eax,%eax
c010267f:	29 c1                	sub    %eax,%ecx
c0102681:	89 c8                	mov    %ecx,%eax
c0102683:	85 c0                	test   %eax,%eax
c0102685:	75 0a                	jne    c0102691 <trap_dispatch+0xd2>
            print_ticks();
c0102687:	e8 85 fa ff ff       	call   c0102111 <print_ticks>
        }
        break;
c010268c:	e9 a6 00 00 00       	jmp    c0102737 <trap_dispatch+0x178>
c0102691:	e9 a1 00 00 00       	jmp    c0102737 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102696:	e8 c5 ef ff ff       	call   c0101660 <cons_getc>
c010269b:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c010269e:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026a2:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026a6:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026ae:	c7 04 24 5a 93 10 c0 	movl   $0xc010935a,(%esp)
c01026b5:	e8 9d dc ff ff       	call   c0100357 <cprintf>
        break;
c01026ba:	eb 7b                	jmp    c0102737 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01026bc:	e8 9f ef ff ff       	call   c0101660 <cons_getc>
c01026c1:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01026c4:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026c8:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026cc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026d4:	c7 04 24 6c 93 10 c0 	movl   $0xc010936c,(%esp)
c01026db:	e8 77 dc ff ff       	call   c0100357 <cprintf>
        break;
c01026e0:	eb 55                	jmp    c0102737 <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c01026e2:	c7 44 24 08 7b 93 10 	movl   $0xc010937b,0x8(%esp)
c01026e9:	c0 
c01026ea:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01026f1:	00 
c01026f2:	c7 04 24 2e 93 10 c0 	movl   $0xc010932e,(%esp)
c01026f9:	e8 e3 e5 ff ff       	call   c0100ce1 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01026fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102701:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102705:	0f b7 c0             	movzwl %ax,%eax
c0102708:	83 e0 03             	and    $0x3,%eax
c010270b:	85 c0                	test   %eax,%eax
c010270d:	75 28                	jne    c0102737 <trap_dispatch+0x178>
            print_trapframe(tf);
c010270f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102712:	89 04 24             	mov    %eax,(%esp)
c0102715:	e8 4c fb ff ff       	call   c0102266 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010271a:	c7 44 24 08 8b 93 10 	movl   $0xc010938b,0x8(%esp)
c0102721:	c0 
c0102722:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0102729:	00 
c010272a:	c7 04 24 2e 93 10 c0 	movl   $0xc010932e,(%esp)
c0102731:	e8 ab e5 ff ff       	call   c0100ce1 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102736:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102737:	c9                   	leave  
c0102738:	c3                   	ret    

c0102739 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102739:	55                   	push   %ebp
c010273a:	89 e5                	mov    %esp,%ebp
c010273c:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010273f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102742:	89 04 24             	mov    %eax,(%esp)
c0102745:	e8 75 fe ff ff       	call   c01025bf <trap_dispatch>
}
c010274a:	c9                   	leave  
c010274b:	c3                   	ret    

c010274c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010274c:	1e                   	push   %ds
    pushl %es
c010274d:	06                   	push   %es
    pushl %fs
c010274e:	0f a0                	push   %fs
    pushl %gs
c0102750:	0f a8                	push   %gs
    pushal
c0102752:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102753:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102758:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010275a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010275c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010275d:	e8 d7 ff ff ff       	call   c0102739 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102762:	5c                   	pop    %esp

c0102763 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102763:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102764:	0f a9                	pop    %gs
    popl %fs
c0102766:	0f a1                	pop    %fs
    popl %es
c0102768:	07                   	pop    %es
    popl %ds
c0102769:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010276a:	83 c4 08             	add    $0x8,%esp
    iret
c010276d:	cf                   	iret   

c010276e <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c010276e:	6a 00                	push   $0x0
  pushl $0
c0102770:	6a 00                	push   $0x0
  jmp __alltraps
c0102772:	e9 d5 ff ff ff       	jmp    c010274c <__alltraps>

c0102777 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102777:	6a 00                	push   $0x0
  pushl $1
c0102779:	6a 01                	push   $0x1
  jmp __alltraps
c010277b:	e9 cc ff ff ff       	jmp    c010274c <__alltraps>

c0102780 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102780:	6a 00                	push   $0x0
  pushl $2
c0102782:	6a 02                	push   $0x2
  jmp __alltraps
c0102784:	e9 c3 ff ff ff       	jmp    c010274c <__alltraps>

c0102789 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102789:	6a 00                	push   $0x0
  pushl $3
c010278b:	6a 03                	push   $0x3
  jmp __alltraps
c010278d:	e9 ba ff ff ff       	jmp    c010274c <__alltraps>

c0102792 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102792:	6a 00                	push   $0x0
  pushl $4
c0102794:	6a 04                	push   $0x4
  jmp __alltraps
c0102796:	e9 b1 ff ff ff       	jmp    c010274c <__alltraps>

c010279b <vector5>:
.globl vector5
vector5:
  pushl $0
c010279b:	6a 00                	push   $0x0
  pushl $5
c010279d:	6a 05                	push   $0x5
  jmp __alltraps
c010279f:	e9 a8 ff ff ff       	jmp    c010274c <__alltraps>

c01027a4 <vector6>:
.globl vector6
vector6:
  pushl $0
c01027a4:	6a 00                	push   $0x0
  pushl $6
c01027a6:	6a 06                	push   $0x6
  jmp __alltraps
c01027a8:	e9 9f ff ff ff       	jmp    c010274c <__alltraps>

c01027ad <vector7>:
.globl vector7
vector7:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $7
c01027af:	6a 07                	push   $0x7
  jmp __alltraps
c01027b1:	e9 96 ff ff ff       	jmp    c010274c <__alltraps>

c01027b6 <vector8>:
.globl vector8
vector8:
  pushl $8
c01027b6:	6a 08                	push   $0x8
  jmp __alltraps
c01027b8:	e9 8f ff ff ff       	jmp    c010274c <__alltraps>

c01027bd <vector9>:
.globl vector9
vector9:
  pushl $0
c01027bd:	6a 00                	push   $0x0
  pushl $9
c01027bf:	6a 09                	push   $0x9
  jmp __alltraps
c01027c1:	e9 86 ff ff ff       	jmp    c010274c <__alltraps>

c01027c6 <vector10>:
.globl vector10
vector10:
  pushl $10
c01027c6:	6a 0a                	push   $0xa
  jmp __alltraps
c01027c8:	e9 7f ff ff ff       	jmp    c010274c <__alltraps>

c01027cd <vector11>:
.globl vector11
vector11:
  pushl $11
c01027cd:	6a 0b                	push   $0xb
  jmp __alltraps
c01027cf:	e9 78 ff ff ff       	jmp    c010274c <__alltraps>

c01027d4 <vector12>:
.globl vector12
vector12:
  pushl $12
c01027d4:	6a 0c                	push   $0xc
  jmp __alltraps
c01027d6:	e9 71 ff ff ff       	jmp    c010274c <__alltraps>

c01027db <vector13>:
.globl vector13
vector13:
  pushl $13
c01027db:	6a 0d                	push   $0xd
  jmp __alltraps
c01027dd:	e9 6a ff ff ff       	jmp    c010274c <__alltraps>

c01027e2 <vector14>:
.globl vector14
vector14:
  pushl $14
c01027e2:	6a 0e                	push   $0xe
  jmp __alltraps
c01027e4:	e9 63 ff ff ff       	jmp    c010274c <__alltraps>

c01027e9 <vector15>:
.globl vector15
vector15:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $15
c01027eb:	6a 0f                	push   $0xf
  jmp __alltraps
c01027ed:	e9 5a ff ff ff       	jmp    c010274c <__alltraps>

c01027f2 <vector16>:
.globl vector16
vector16:
  pushl $0
c01027f2:	6a 00                	push   $0x0
  pushl $16
c01027f4:	6a 10                	push   $0x10
  jmp __alltraps
c01027f6:	e9 51 ff ff ff       	jmp    c010274c <__alltraps>

c01027fb <vector17>:
.globl vector17
vector17:
  pushl $17
c01027fb:	6a 11                	push   $0x11
  jmp __alltraps
c01027fd:	e9 4a ff ff ff       	jmp    c010274c <__alltraps>

c0102802 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102802:	6a 00                	push   $0x0
  pushl $18
c0102804:	6a 12                	push   $0x12
  jmp __alltraps
c0102806:	e9 41 ff ff ff       	jmp    c010274c <__alltraps>

c010280b <vector19>:
.globl vector19
vector19:
  pushl $0
c010280b:	6a 00                	push   $0x0
  pushl $19
c010280d:	6a 13                	push   $0x13
  jmp __alltraps
c010280f:	e9 38 ff ff ff       	jmp    c010274c <__alltraps>

c0102814 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102814:	6a 00                	push   $0x0
  pushl $20
c0102816:	6a 14                	push   $0x14
  jmp __alltraps
c0102818:	e9 2f ff ff ff       	jmp    c010274c <__alltraps>

c010281d <vector21>:
.globl vector21
vector21:
  pushl $0
c010281d:	6a 00                	push   $0x0
  pushl $21
c010281f:	6a 15                	push   $0x15
  jmp __alltraps
c0102821:	e9 26 ff ff ff       	jmp    c010274c <__alltraps>

c0102826 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $22
c0102828:	6a 16                	push   $0x16
  jmp __alltraps
c010282a:	e9 1d ff ff ff       	jmp    c010274c <__alltraps>

c010282f <vector23>:
.globl vector23
vector23:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $23
c0102831:	6a 17                	push   $0x17
  jmp __alltraps
c0102833:	e9 14 ff ff ff       	jmp    c010274c <__alltraps>

c0102838 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102838:	6a 00                	push   $0x0
  pushl $24
c010283a:	6a 18                	push   $0x18
  jmp __alltraps
c010283c:	e9 0b ff ff ff       	jmp    c010274c <__alltraps>

c0102841 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102841:	6a 00                	push   $0x0
  pushl $25
c0102843:	6a 19                	push   $0x19
  jmp __alltraps
c0102845:	e9 02 ff ff ff       	jmp    c010274c <__alltraps>

c010284a <vector26>:
.globl vector26
vector26:
  pushl $0
c010284a:	6a 00                	push   $0x0
  pushl $26
c010284c:	6a 1a                	push   $0x1a
  jmp __alltraps
c010284e:	e9 f9 fe ff ff       	jmp    c010274c <__alltraps>

c0102853 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102853:	6a 00                	push   $0x0
  pushl $27
c0102855:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102857:	e9 f0 fe ff ff       	jmp    c010274c <__alltraps>

c010285c <vector28>:
.globl vector28
vector28:
  pushl $0
c010285c:	6a 00                	push   $0x0
  pushl $28
c010285e:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102860:	e9 e7 fe ff ff       	jmp    c010274c <__alltraps>

c0102865 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102865:	6a 00                	push   $0x0
  pushl $29
c0102867:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102869:	e9 de fe ff ff       	jmp    c010274c <__alltraps>

c010286e <vector30>:
.globl vector30
vector30:
  pushl $0
c010286e:	6a 00                	push   $0x0
  pushl $30
c0102870:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102872:	e9 d5 fe ff ff       	jmp    c010274c <__alltraps>

c0102877 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102877:	6a 00                	push   $0x0
  pushl $31
c0102879:	6a 1f                	push   $0x1f
  jmp __alltraps
c010287b:	e9 cc fe ff ff       	jmp    c010274c <__alltraps>

c0102880 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102880:	6a 00                	push   $0x0
  pushl $32
c0102882:	6a 20                	push   $0x20
  jmp __alltraps
c0102884:	e9 c3 fe ff ff       	jmp    c010274c <__alltraps>

c0102889 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102889:	6a 00                	push   $0x0
  pushl $33
c010288b:	6a 21                	push   $0x21
  jmp __alltraps
c010288d:	e9 ba fe ff ff       	jmp    c010274c <__alltraps>

c0102892 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102892:	6a 00                	push   $0x0
  pushl $34
c0102894:	6a 22                	push   $0x22
  jmp __alltraps
c0102896:	e9 b1 fe ff ff       	jmp    c010274c <__alltraps>

c010289b <vector35>:
.globl vector35
vector35:
  pushl $0
c010289b:	6a 00                	push   $0x0
  pushl $35
c010289d:	6a 23                	push   $0x23
  jmp __alltraps
c010289f:	e9 a8 fe ff ff       	jmp    c010274c <__alltraps>

c01028a4 <vector36>:
.globl vector36
vector36:
  pushl $0
c01028a4:	6a 00                	push   $0x0
  pushl $36
c01028a6:	6a 24                	push   $0x24
  jmp __alltraps
c01028a8:	e9 9f fe ff ff       	jmp    c010274c <__alltraps>

c01028ad <vector37>:
.globl vector37
vector37:
  pushl $0
c01028ad:	6a 00                	push   $0x0
  pushl $37
c01028af:	6a 25                	push   $0x25
  jmp __alltraps
c01028b1:	e9 96 fe ff ff       	jmp    c010274c <__alltraps>

c01028b6 <vector38>:
.globl vector38
vector38:
  pushl $0
c01028b6:	6a 00                	push   $0x0
  pushl $38
c01028b8:	6a 26                	push   $0x26
  jmp __alltraps
c01028ba:	e9 8d fe ff ff       	jmp    c010274c <__alltraps>

c01028bf <vector39>:
.globl vector39
vector39:
  pushl $0
c01028bf:	6a 00                	push   $0x0
  pushl $39
c01028c1:	6a 27                	push   $0x27
  jmp __alltraps
c01028c3:	e9 84 fe ff ff       	jmp    c010274c <__alltraps>

c01028c8 <vector40>:
.globl vector40
vector40:
  pushl $0
c01028c8:	6a 00                	push   $0x0
  pushl $40
c01028ca:	6a 28                	push   $0x28
  jmp __alltraps
c01028cc:	e9 7b fe ff ff       	jmp    c010274c <__alltraps>

c01028d1 <vector41>:
.globl vector41
vector41:
  pushl $0
c01028d1:	6a 00                	push   $0x0
  pushl $41
c01028d3:	6a 29                	push   $0x29
  jmp __alltraps
c01028d5:	e9 72 fe ff ff       	jmp    c010274c <__alltraps>

c01028da <vector42>:
.globl vector42
vector42:
  pushl $0
c01028da:	6a 00                	push   $0x0
  pushl $42
c01028dc:	6a 2a                	push   $0x2a
  jmp __alltraps
c01028de:	e9 69 fe ff ff       	jmp    c010274c <__alltraps>

c01028e3 <vector43>:
.globl vector43
vector43:
  pushl $0
c01028e3:	6a 00                	push   $0x0
  pushl $43
c01028e5:	6a 2b                	push   $0x2b
  jmp __alltraps
c01028e7:	e9 60 fe ff ff       	jmp    c010274c <__alltraps>

c01028ec <vector44>:
.globl vector44
vector44:
  pushl $0
c01028ec:	6a 00                	push   $0x0
  pushl $44
c01028ee:	6a 2c                	push   $0x2c
  jmp __alltraps
c01028f0:	e9 57 fe ff ff       	jmp    c010274c <__alltraps>

c01028f5 <vector45>:
.globl vector45
vector45:
  pushl $0
c01028f5:	6a 00                	push   $0x0
  pushl $45
c01028f7:	6a 2d                	push   $0x2d
  jmp __alltraps
c01028f9:	e9 4e fe ff ff       	jmp    c010274c <__alltraps>

c01028fe <vector46>:
.globl vector46
vector46:
  pushl $0
c01028fe:	6a 00                	push   $0x0
  pushl $46
c0102900:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102902:	e9 45 fe ff ff       	jmp    c010274c <__alltraps>

c0102907 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102907:	6a 00                	push   $0x0
  pushl $47
c0102909:	6a 2f                	push   $0x2f
  jmp __alltraps
c010290b:	e9 3c fe ff ff       	jmp    c010274c <__alltraps>

c0102910 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102910:	6a 00                	push   $0x0
  pushl $48
c0102912:	6a 30                	push   $0x30
  jmp __alltraps
c0102914:	e9 33 fe ff ff       	jmp    c010274c <__alltraps>

c0102919 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102919:	6a 00                	push   $0x0
  pushl $49
c010291b:	6a 31                	push   $0x31
  jmp __alltraps
c010291d:	e9 2a fe ff ff       	jmp    c010274c <__alltraps>

c0102922 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102922:	6a 00                	push   $0x0
  pushl $50
c0102924:	6a 32                	push   $0x32
  jmp __alltraps
c0102926:	e9 21 fe ff ff       	jmp    c010274c <__alltraps>

c010292b <vector51>:
.globl vector51
vector51:
  pushl $0
c010292b:	6a 00                	push   $0x0
  pushl $51
c010292d:	6a 33                	push   $0x33
  jmp __alltraps
c010292f:	e9 18 fe ff ff       	jmp    c010274c <__alltraps>

c0102934 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102934:	6a 00                	push   $0x0
  pushl $52
c0102936:	6a 34                	push   $0x34
  jmp __alltraps
c0102938:	e9 0f fe ff ff       	jmp    c010274c <__alltraps>

c010293d <vector53>:
.globl vector53
vector53:
  pushl $0
c010293d:	6a 00                	push   $0x0
  pushl $53
c010293f:	6a 35                	push   $0x35
  jmp __alltraps
c0102941:	e9 06 fe ff ff       	jmp    c010274c <__alltraps>

c0102946 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102946:	6a 00                	push   $0x0
  pushl $54
c0102948:	6a 36                	push   $0x36
  jmp __alltraps
c010294a:	e9 fd fd ff ff       	jmp    c010274c <__alltraps>

c010294f <vector55>:
.globl vector55
vector55:
  pushl $0
c010294f:	6a 00                	push   $0x0
  pushl $55
c0102951:	6a 37                	push   $0x37
  jmp __alltraps
c0102953:	e9 f4 fd ff ff       	jmp    c010274c <__alltraps>

c0102958 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102958:	6a 00                	push   $0x0
  pushl $56
c010295a:	6a 38                	push   $0x38
  jmp __alltraps
c010295c:	e9 eb fd ff ff       	jmp    c010274c <__alltraps>

c0102961 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102961:	6a 00                	push   $0x0
  pushl $57
c0102963:	6a 39                	push   $0x39
  jmp __alltraps
c0102965:	e9 e2 fd ff ff       	jmp    c010274c <__alltraps>

c010296a <vector58>:
.globl vector58
vector58:
  pushl $0
c010296a:	6a 00                	push   $0x0
  pushl $58
c010296c:	6a 3a                	push   $0x3a
  jmp __alltraps
c010296e:	e9 d9 fd ff ff       	jmp    c010274c <__alltraps>

c0102973 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102973:	6a 00                	push   $0x0
  pushl $59
c0102975:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102977:	e9 d0 fd ff ff       	jmp    c010274c <__alltraps>

c010297c <vector60>:
.globl vector60
vector60:
  pushl $0
c010297c:	6a 00                	push   $0x0
  pushl $60
c010297e:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102980:	e9 c7 fd ff ff       	jmp    c010274c <__alltraps>

c0102985 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102985:	6a 00                	push   $0x0
  pushl $61
c0102987:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102989:	e9 be fd ff ff       	jmp    c010274c <__alltraps>

c010298e <vector62>:
.globl vector62
vector62:
  pushl $0
c010298e:	6a 00                	push   $0x0
  pushl $62
c0102990:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102992:	e9 b5 fd ff ff       	jmp    c010274c <__alltraps>

c0102997 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102997:	6a 00                	push   $0x0
  pushl $63
c0102999:	6a 3f                	push   $0x3f
  jmp __alltraps
c010299b:	e9 ac fd ff ff       	jmp    c010274c <__alltraps>

c01029a0 <vector64>:
.globl vector64
vector64:
  pushl $0
c01029a0:	6a 00                	push   $0x0
  pushl $64
c01029a2:	6a 40                	push   $0x40
  jmp __alltraps
c01029a4:	e9 a3 fd ff ff       	jmp    c010274c <__alltraps>

c01029a9 <vector65>:
.globl vector65
vector65:
  pushl $0
c01029a9:	6a 00                	push   $0x0
  pushl $65
c01029ab:	6a 41                	push   $0x41
  jmp __alltraps
c01029ad:	e9 9a fd ff ff       	jmp    c010274c <__alltraps>

c01029b2 <vector66>:
.globl vector66
vector66:
  pushl $0
c01029b2:	6a 00                	push   $0x0
  pushl $66
c01029b4:	6a 42                	push   $0x42
  jmp __alltraps
c01029b6:	e9 91 fd ff ff       	jmp    c010274c <__alltraps>

c01029bb <vector67>:
.globl vector67
vector67:
  pushl $0
c01029bb:	6a 00                	push   $0x0
  pushl $67
c01029bd:	6a 43                	push   $0x43
  jmp __alltraps
c01029bf:	e9 88 fd ff ff       	jmp    c010274c <__alltraps>

c01029c4 <vector68>:
.globl vector68
vector68:
  pushl $0
c01029c4:	6a 00                	push   $0x0
  pushl $68
c01029c6:	6a 44                	push   $0x44
  jmp __alltraps
c01029c8:	e9 7f fd ff ff       	jmp    c010274c <__alltraps>

c01029cd <vector69>:
.globl vector69
vector69:
  pushl $0
c01029cd:	6a 00                	push   $0x0
  pushl $69
c01029cf:	6a 45                	push   $0x45
  jmp __alltraps
c01029d1:	e9 76 fd ff ff       	jmp    c010274c <__alltraps>

c01029d6 <vector70>:
.globl vector70
vector70:
  pushl $0
c01029d6:	6a 00                	push   $0x0
  pushl $70
c01029d8:	6a 46                	push   $0x46
  jmp __alltraps
c01029da:	e9 6d fd ff ff       	jmp    c010274c <__alltraps>

c01029df <vector71>:
.globl vector71
vector71:
  pushl $0
c01029df:	6a 00                	push   $0x0
  pushl $71
c01029e1:	6a 47                	push   $0x47
  jmp __alltraps
c01029e3:	e9 64 fd ff ff       	jmp    c010274c <__alltraps>

c01029e8 <vector72>:
.globl vector72
vector72:
  pushl $0
c01029e8:	6a 00                	push   $0x0
  pushl $72
c01029ea:	6a 48                	push   $0x48
  jmp __alltraps
c01029ec:	e9 5b fd ff ff       	jmp    c010274c <__alltraps>

c01029f1 <vector73>:
.globl vector73
vector73:
  pushl $0
c01029f1:	6a 00                	push   $0x0
  pushl $73
c01029f3:	6a 49                	push   $0x49
  jmp __alltraps
c01029f5:	e9 52 fd ff ff       	jmp    c010274c <__alltraps>

c01029fa <vector74>:
.globl vector74
vector74:
  pushl $0
c01029fa:	6a 00                	push   $0x0
  pushl $74
c01029fc:	6a 4a                	push   $0x4a
  jmp __alltraps
c01029fe:	e9 49 fd ff ff       	jmp    c010274c <__alltraps>

c0102a03 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102a03:	6a 00                	push   $0x0
  pushl $75
c0102a05:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102a07:	e9 40 fd ff ff       	jmp    c010274c <__alltraps>

c0102a0c <vector76>:
.globl vector76
vector76:
  pushl $0
c0102a0c:	6a 00                	push   $0x0
  pushl $76
c0102a0e:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102a10:	e9 37 fd ff ff       	jmp    c010274c <__alltraps>

c0102a15 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a15:	6a 00                	push   $0x0
  pushl $77
c0102a17:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a19:	e9 2e fd ff ff       	jmp    c010274c <__alltraps>

c0102a1e <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a1e:	6a 00                	push   $0x0
  pushl $78
c0102a20:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a22:	e9 25 fd ff ff       	jmp    c010274c <__alltraps>

c0102a27 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a27:	6a 00                	push   $0x0
  pushl $79
c0102a29:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a2b:	e9 1c fd ff ff       	jmp    c010274c <__alltraps>

c0102a30 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a30:	6a 00                	push   $0x0
  pushl $80
c0102a32:	6a 50                	push   $0x50
  jmp __alltraps
c0102a34:	e9 13 fd ff ff       	jmp    c010274c <__alltraps>

c0102a39 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a39:	6a 00                	push   $0x0
  pushl $81
c0102a3b:	6a 51                	push   $0x51
  jmp __alltraps
c0102a3d:	e9 0a fd ff ff       	jmp    c010274c <__alltraps>

c0102a42 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a42:	6a 00                	push   $0x0
  pushl $82
c0102a44:	6a 52                	push   $0x52
  jmp __alltraps
c0102a46:	e9 01 fd ff ff       	jmp    c010274c <__alltraps>

c0102a4b <vector83>:
.globl vector83
vector83:
  pushl $0
c0102a4b:	6a 00                	push   $0x0
  pushl $83
c0102a4d:	6a 53                	push   $0x53
  jmp __alltraps
c0102a4f:	e9 f8 fc ff ff       	jmp    c010274c <__alltraps>

c0102a54 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102a54:	6a 00                	push   $0x0
  pushl $84
c0102a56:	6a 54                	push   $0x54
  jmp __alltraps
c0102a58:	e9 ef fc ff ff       	jmp    c010274c <__alltraps>

c0102a5d <vector85>:
.globl vector85
vector85:
  pushl $0
c0102a5d:	6a 00                	push   $0x0
  pushl $85
c0102a5f:	6a 55                	push   $0x55
  jmp __alltraps
c0102a61:	e9 e6 fc ff ff       	jmp    c010274c <__alltraps>

c0102a66 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102a66:	6a 00                	push   $0x0
  pushl $86
c0102a68:	6a 56                	push   $0x56
  jmp __alltraps
c0102a6a:	e9 dd fc ff ff       	jmp    c010274c <__alltraps>

c0102a6f <vector87>:
.globl vector87
vector87:
  pushl $0
c0102a6f:	6a 00                	push   $0x0
  pushl $87
c0102a71:	6a 57                	push   $0x57
  jmp __alltraps
c0102a73:	e9 d4 fc ff ff       	jmp    c010274c <__alltraps>

c0102a78 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102a78:	6a 00                	push   $0x0
  pushl $88
c0102a7a:	6a 58                	push   $0x58
  jmp __alltraps
c0102a7c:	e9 cb fc ff ff       	jmp    c010274c <__alltraps>

c0102a81 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102a81:	6a 00                	push   $0x0
  pushl $89
c0102a83:	6a 59                	push   $0x59
  jmp __alltraps
c0102a85:	e9 c2 fc ff ff       	jmp    c010274c <__alltraps>

c0102a8a <vector90>:
.globl vector90
vector90:
  pushl $0
c0102a8a:	6a 00                	push   $0x0
  pushl $90
c0102a8c:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102a8e:	e9 b9 fc ff ff       	jmp    c010274c <__alltraps>

c0102a93 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102a93:	6a 00                	push   $0x0
  pushl $91
c0102a95:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102a97:	e9 b0 fc ff ff       	jmp    c010274c <__alltraps>

c0102a9c <vector92>:
.globl vector92
vector92:
  pushl $0
c0102a9c:	6a 00                	push   $0x0
  pushl $92
c0102a9e:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102aa0:	e9 a7 fc ff ff       	jmp    c010274c <__alltraps>

c0102aa5 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102aa5:	6a 00                	push   $0x0
  pushl $93
c0102aa7:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102aa9:	e9 9e fc ff ff       	jmp    c010274c <__alltraps>

c0102aae <vector94>:
.globl vector94
vector94:
  pushl $0
c0102aae:	6a 00                	push   $0x0
  pushl $94
c0102ab0:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102ab2:	e9 95 fc ff ff       	jmp    c010274c <__alltraps>

c0102ab7 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102ab7:	6a 00                	push   $0x0
  pushl $95
c0102ab9:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102abb:	e9 8c fc ff ff       	jmp    c010274c <__alltraps>

c0102ac0 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102ac0:	6a 00                	push   $0x0
  pushl $96
c0102ac2:	6a 60                	push   $0x60
  jmp __alltraps
c0102ac4:	e9 83 fc ff ff       	jmp    c010274c <__alltraps>

c0102ac9 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102ac9:	6a 00                	push   $0x0
  pushl $97
c0102acb:	6a 61                	push   $0x61
  jmp __alltraps
c0102acd:	e9 7a fc ff ff       	jmp    c010274c <__alltraps>

c0102ad2 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102ad2:	6a 00                	push   $0x0
  pushl $98
c0102ad4:	6a 62                	push   $0x62
  jmp __alltraps
c0102ad6:	e9 71 fc ff ff       	jmp    c010274c <__alltraps>

c0102adb <vector99>:
.globl vector99
vector99:
  pushl $0
c0102adb:	6a 00                	push   $0x0
  pushl $99
c0102add:	6a 63                	push   $0x63
  jmp __alltraps
c0102adf:	e9 68 fc ff ff       	jmp    c010274c <__alltraps>

c0102ae4 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102ae4:	6a 00                	push   $0x0
  pushl $100
c0102ae6:	6a 64                	push   $0x64
  jmp __alltraps
c0102ae8:	e9 5f fc ff ff       	jmp    c010274c <__alltraps>

c0102aed <vector101>:
.globl vector101
vector101:
  pushl $0
c0102aed:	6a 00                	push   $0x0
  pushl $101
c0102aef:	6a 65                	push   $0x65
  jmp __alltraps
c0102af1:	e9 56 fc ff ff       	jmp    c010274c <__alltraps>

c0102af6 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102af6:	6a 00                	push   $0x0
  pushl $102
c0102af8:	6a 66                	push   $0x66
  jmp __alltraps
c0102afa:	e9 4d fc ff ff       	jmp    c010274c <__alltraps>

c0102aff <vector103>:
.globl vector103
vector103:
  pushl $0
c0102aff:	6a 00                	push   $0x0
  pushl $103
c0102b01:	6a 67                	push   $0x67
  jmp __alltraps
c0102b03:	e9 44 fc ff ff       	jmp    c010274c <__alltraps>

c0102b08 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102b08:	6a 00                	push   $0x0
  pushl $104
c0102b0a:	6a 68                	push   $0x68
  jmp __alltraps
c0102b0c:	e9 3b fc ff ff       	jmp    c010274c <__alltraps>

c0102b11 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102b11:	6a 00                	push   $0x0
  pushl $105
c0102b13:	6a 69                	push   $0x69
  jmp __alltraps
c0102b15:	e9 32 fc ff ff       	jmp    c010274c <__alltraps>

c0102b1a <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b1a:	6a 00                	push   $0x0
  pushl $106
c0102b1c:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b1e:	e9 29 fc ff ff       	jmp    c010274c <__alltraps>

c0102b23 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b23:	6a 00                	push   $0x0
  pushl $107
c0102b25:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b27:	e9 20 fc ff ff       	jmp    c010274c <__alltraps>

c0102b2c <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b2c:	6a 00                	push   $0x0
  pushl $108
c0102b2e:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b30:	e9 17 fc ff ff       	jmp    c010274c <__alltraps>

c0102b35 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b35:	6a 00                	push   $0x0
  pushl $109
c0102b37:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b39:	e9 0e fc ff ff       	jmp    c010274c <__alltraps>

c0102b3e <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b3e:	6a 00                	push   $0x0
  pushl $110
c0102b40:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b42:	e9 05 fc ff ff       	jmp    c010274c <__alltraps>

c0102b47 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102b47:	6a 00                	push   $0x0
  pushl $111
c0102b49:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102b4b:	e9 fc fb ff ff       	jmp    c010274c <__alltraps>

c0102b50 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102b50:	6a 00                	push   $0x0
  pushl $112
c0102b52:	6a 70                	push   $0x70
  jmp __alltraps
c0102b54:	e9 f3 fb ff ff       	jmp    c010274c <__alltraps>

c0102b59 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102b59:	6a 00                	push   $0x0
  pushl $113
c0102b5b:	6a 71                	push   $0x71
  jmp __alltraps
c0102b5d:	e9 ea fb ff ff       	jmp    c010274c <__alltraps>

c0102b62 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102b62:	6a 00                	push   $0x0
  pushl $114
c0102b64:	6a 72                	push   $0x72
  jmp __alltraps
c0102b66:	e9 e1 fb ff ff       	jmp    c010274c <__alltraps>

c0102b6b <vector115>:
.globl vector115
vector115:
  pushl $0
c0102b6b:	6a 00                	push   $0x0
  pushl $115
c0102b6d:	6a 73                	push   $0x73
  jmp __alltraps
c0102b6f:	e9 d8 fb ff ff       	jmp    c010274c <__alltraps>

c0102b74 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102b74:	6a 00                	push   $0x0
  pushl $116
c0102b76:	6a 74                	push   $0x74
  jmp __alltraps
c0102b78:	e9 cf fb ff ff       	jmp    c010274c <__alltraps>

c0102b7d <vector117>:
.globl vector117
vector117:
  pushl $0
c0102b7d:	6a 00                	push   $0x0
  pushl $117
c0102b7f:	6a 75                	push   $0x75
  jmp __alltraps
c0102b81:	e9 c6 fb ff ff       	jmp    c010274c <__alltraps>

c0102b86 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102b86:	6a 00                	push   $0x0
  pushl $118
c0102b88:	6a 76                	push   $0x76
  jmp __alltraps
c0102b8a:	e9 bd fb ff ff       	jmp    c010274c <__alltraps>

c0102b8f <vector119>:
.globl vector119
vector119:
  pushl $0
c0102b8f:	6a 00                	push   $0x0
  pushl $119
c0102b91:	6a 77                	push   $0x77
  jmp __alltraps
c0102b93:	e9 b4 fb ff ff       	jmp    c010274c <__alltraps>

c0102b98 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102b98:	6a 00                	push   $0x0
  pushl $120
c0102b9a:	6a 78                	push   $0x78
  jmp __alltraps
c0102b9c:	e9 ab fb ff ff       	jmp    c010274c <__alltraps>

c0102ba1 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102ba1:	6a 00                	push   $0x0
  pushl $121
c0102ba3:	6a 79                	push   $0x79
  jmp __alltraps
c0102ba5:	e9 a2 fb ff ff       	jmp    c010274c <__alltraps>

c0102baa <vector122>:
.globl vector122
vector122:
  pushl $0
c0102baa:	6a 00                	push   $0x0
  pushl $122
c0102bac:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102bae:	e9 99 fb ff ff       	jmp    c010274c <__alltraps>

c0102bb3 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102bb3:	6a 00                	push   $0x0
  pushl $123
c0102bb5:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102bb7:	e9 90 fb ff ff       	jmp    c010274c <__alltraps>

c0102bbc <vector124>:
.globl vector124
vector124:
  pushl $0
c0102bbc:	6a 00                	push   $0x0
  pushl $124
c0102bbe:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102bc0:	e9 87 fb ff ff       	jmp    c010274c <__alltraps>

c0102bc5 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102bc5:	6a 00                	push   $0x0
  pushl $125
c0102bc7:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102bc9:	e9 7e fb ff ff       	jmp    c010274c <__alltraps>

c0102bce <vector126>:
.globl vector126
vector126:
  pushl $0
c0102bce:	6a 00                	push   $0x0
  pushl $126
c0102bd0:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102bd2:	e9 75 fb ff ff       	jmp    c010274c <__alltraps>

c0102bd7 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102bd7:	6a 00                	push   $0x0
  pushl $127
c0102bd9:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102bdb:	e9 6c fb ff ff       	jmp    c010274c <__alltraps>

c0102be0 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102be0:	6a 00                	push   $0x0
  pushl $128
c0102be2:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102be7:	e9 60 fb ff ff       	jmp    c010274c <__alltraps>

c0102bec <vector129>:
.globl vector129
vector129:
  pushl $0
c0102bec:	6a 00                	push   $0x0
  pushl $129
c0102bee:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102bf3:	e9 54 fb ff ff       	jmp    c010274c <__alltraps>

c0102bf8 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102bf8:	6a 00                	push   $0x0
  pushl $130
c0102bfa:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102bff:	e9 48 fb ff ff       	jmp    c010274c <__alltraps>

c0102c04 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102c04:	6a 00                	push   $0x0
  pushl $131
c0102c06:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102c0b:	e9 3c fb ff ff       	jmp    c010274c <__alltraps>

c0102c10 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102c10:	6a 00                	push   $0x0
  pushl $132
c0102c12:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c17:	e9 30 fb ff ff       	jmp    c010274c <__alltraps>

c0102c1c <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c1c:	6a 00                	push   $0x0
  pushl $133
c0102c1e:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c23:	e9 24 fb ff ff       	jmp    c010274c <__alltraps>

c0102c28 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c28:	6a 00                	push   $0x0
  pushl $134
c0102c2a:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c2f:	e9 18 fb ff ff       	jmp    c010274c <__alltraps>

c0102c34 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c34:	6a 00                	push   $0x0
  pushl $135
c0102c36:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c3b:	e9 0c fb ff ff       	jmp    c010274c <__alltraps>

c0102c40 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c40:	6a 00                	push   $0x0
  pushl $136
c0102c42:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102c47:	e9 00 fb ff ff       	jmp    c010274c <__alltraps>

c0102c4c <vector137>:
.globl vector137
vector137:
  pushl $0
c0102c4c:	6a 00                	push   $0x0
  pushl $137
c0102c4e:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102c53:	e9 f4 fa ff ff       	jmp    c010274c <__alltraps>

c0102c58 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102c58:	6a 00                	push   $0x0
  pushl $138
c0102c5a:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102c5f:	e9 e8 fa ff ff       	jmp    c010274c <__alltraps>

c0102c64 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102c64:	6a 00                	push   $0x0
  pushl $139
c0102c66:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102c6b:	e9 dc fa ff ff       	jmp    c010274c <__alltraps>

c0102c70 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102c70:	6a 00                	push   $0x0
  pushl $140
c0102c72:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102c77:	e9 d0 fa ff ff       	jmp    c010274c <__alltraps>

c0102c7c <vector141>:
.globl vector141
vector141:
  pushl $0
c0102c7c:	6a 00                	push   $0x0
  pushl $141
c0102c7e:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102c83:	e9 c4 fa ff ff       	jmp    c010274c <__alltraps>

c0102c88 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102c88:	6a 00                	push   $0x0
  pushl $142
c0102c8a:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102c8f:	e9 b8 fa ff ff       	jmp    c010274c <__alltraps>

c0102c94 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102c94:	6a 00                	push   $0x0
  pushl $143
c0102c96:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102c9b:	e9 ac fa ff ff       	jmp    c010274c <__alltraps>

c0102ca0 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102ca0:	6a 00                	push   $0x0
  pushl $144
c0102ca2:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102ca7:	e9 a0 fa ff ff       	jmp    c010274c <__alltraps>

c0102cac <vector145>:
.globl vector145
vector145:
  pushl $0
c0102cac:	6a 00                	push   $0x0
  pushl $145
c0102cae:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102cb3:	e9 94 fa ff ff       	jmp    c010274c <__alltraps>

c0102cb8 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102cb8:	6a 00                	push   $0x0
  pushl $146
c0102cba:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102cbf:	e9 88 fa ff ff       	jmp    c010274c <__alltraps>

c0102cc4 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102cc4:	6a 00                	push   $0x0
  pushl $147
c0102cc6:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102ccb:	e9 7c fa ff ff       	jmp    c010274c <__alltraps>

c0102cd0 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102cd0:	6a 00                	push   $0x0
  pushl $148
c0102cd2:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102cd7:	e9 70 fa ff ff       	jmp    c010274c <__alltraps>

c0102cdc <vector149>:
.globl vector149
vector149:
  pushl $0
c0102cdc:	6a 00                	push   $0x0
  pushl $149
c0102cde:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102ce3:	e9 64 fa ff ff       	jmp    c010274c <__alltraps>

c0102ce8 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102ce8:	6a 00                	push   $0x0
  pushl $150
c0102cea:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102cef:	e9 58 fa ff ff       	jmp    c010274c <__alltraps>

c0102cf4 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102cf4:	6a 00                	push   $0x0
  pushl $151
c0102cf6:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102cfb:	e9 4c fa ff ff       	jmp    c010274c <__alltraps>

c0102d00 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102d00:	6a 00                	push   $0x0
  pushl $152
c0102d02:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102d07:	e9 40 fa ff ff       	jmp    c010274c <__alltraps>

c0102d0c <vector153>:
.globl vector153
vector153:
  pushl $0
c0102d0c:	6a 00                	push   $0x0
  pushl $153
c0102d0e:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d13:	e9 34 fa ff ff       	jmp    c010274c <__alltraps>

c0102d18 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d18:	6a 00                	push   $0x0
  pushl $154
c0102d1a:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d1f:	e9 28 fa ff ff       	jmp    c010274c <__alltraps>

c0102d24 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d24:	6a 00                	push   $0x0
  pushl $155
c0102d26:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d2b:	e9 1c fa ff ff       	jmp    c010274c <__alltraps>

c0102d30 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d30:	6a 00                	push   $0x0
  pushl $156
c0102d32:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d37:	e9 10 fa ff ff       	jmp    c010274c <__alltraps>

c0102d3c <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d3c:	6a 00                	push   $0x0
  pushl $157
c0102d3e:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102d43:	e9 04 fa ff ff       	jmp    c010274c <__alltraps>

c0102d48 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102d48:	6a 00                	push   $0x0
  pushl $158
c0102d4a:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102d4f:	e9 f8 f9 ff ff       	jmp    c010274c <__alltraps>

c0102d54 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102d54:	6a 00                	push   $0x0
  pushl $159
c0102d56:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102d5b:	e9 ec f9 ff ff       	jmp    c010274c <__alltraps>

c0102d60 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102d60:	6a 00                	push   $0x0
  pushl $160
c0102d62:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102d67:	e9 e0 f9 ff ff       	jmp    c010274c <__alltraps>

c0102d6c <vector161>:
.globl vector161
vector161:
  pushl $0
c0102d6c:	6a 00                	push   $0x0
  pushl $161
c0102d6e:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102d73:	e9 d4 f9 ff ff       	jmp    c010274c <__alltraps>

c0102d78 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102d78:	6a 00                	push   $0x0
  pushl $162
c0102d7a:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102d7f:	e9 c8 f9 ff ff       	jmp    c010274c <__alltraps>

c0102d84 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102d84:	6a 00                	push   $0x0
  pushl $163
c0102d86:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102d8b:	e9 bc f9 ff ff       	jmp    c010274c <__alltraps>

c0102d90 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102d90:	6a 00                	push   $0x0
  pushl $164
c0102d92:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102d97:	e9 b0 f9 ff ff       	jmp    c010274c <__alltraps>

c0102d9c <vector165>:
.globl vector165
vector165:
  pushl $0
c0102d9c:	6a 00                	push   $0x0
  pushl $165
c0102d9e:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102da3:	e9 a4 f9 ff ff       	jmp    c010274c <__alltraps>

c0102da8 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102da8:	6a 00                	push   $0x0
  pushl $166
c0102daa:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102daf:	e9 98 f9 ff ff       	jmp    c010274c <__alltraps>

c0102db4 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102db4:	6a 00                	push   $0x0
  pushl $167
c0102db6:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102dbb:	e9 8c f9 ff ff       	jmp    c010274c <__alltraps>

c0102dc0 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102dc0:	6a 00                	push   $0x0
  pushl $168
c0102dc2:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102dc7:	e9 80 f9 ff ff       	jmp    c010274c <__alltraps>

c0102dcc <vector169>:
.globl vector169
vector169:
  pushl $0
c0102dcc:	6a 00                	push   $0x0
  pushl $169
c0102dce:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102dd3:	e9 74 f9 ff ff       	jmp    c010274c <__alltraps>

c0102dd8 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102dd8:	6a 00                	push   $0x0
  pushl $170
c0102dda:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102ddf:	e9 68 f9 ff ff       	jmp    c010274c <__alltraps>

c0102de4 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102de4:	6a 00                	push   $0x0
  pushl $171
c0102de6:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102deb:	e9 5c f9 ff ff       	jmp    c010274c <__alltraps>

c0102df0 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102df0:	6a 00                	push   $0x0
  pushl $172
c0102df2:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102df7:	e9 50 f9 ff ff       	jmp    c010274c <__alltraps>

c0102dfc <vector173>:
.globl vector173
vector173:
  pushl $0
c0102dfc:	6a 00                	push   $0x0
  pushl $173
c0102dfe:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102e03:	e9 44 f9 ff ff       	jmp    c010274c <__alltraps>

c0102e08 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102e08:	6a 00                	push   $0x0
  pushl $174
c0102e0a:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e0f:	e9 38 f9 ff ff       	jmp    c010274c <__alltraps>

c0102e14 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e14:	6a 00                	push   $0x0
  pushl $175
c0102e16:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e1b:	e9 2c f9 ff ff       	jmp    c010274c <__alltraps>

c0102e20 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e20:	6a 00                	push   $0x0
  pushl $176
c0102e22:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e27:	e9 20 f9 ff ff       	jmp    c010274c <__alltraps>

c0102e2c <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e2c:	6a 00                	push   $0x0
  pushl $177
c0102e2e:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e33:	e9 14 f9 ff ff       	jmp    c010274c <__alltraps>

c0102e38 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e38:	6a 00                	push   $0x0
  pushl $178
c0102e3a:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e3f:	e9 08 f9 ff ff       	jmp    c010274c <__alltraps>

c0102e44 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102e44:	6a 00                	push   $0x0
  pushl $179
c0102e46:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102e4b:	e9 fc f8 ff ff       	jmp    c010274c <__alltraps>

c0102e50 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102e50:	6a 00                	push   $0x0
  pushl $180
c0102e52:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102e57:	e9 f0 f8 ff ff       	jmp    c010274c <__alltraps>

c0102e5c <vector181>:
.globl vector181
vector181:
  pushl $0
c0102e5c:	6a 00                	push   $0x0
  pushl $181
c0102e5e:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102e63:	e9 e4 f8 ff ff       	jmp    c010274c <__alltraps>

c0102e68 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102e68:	6a 00                	push   $0x0
  pushl $182
c0102e6a:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102e6f:	e9 d8 f8 ff ff       	jmp    c010274c <__alltraps>

c0102e74 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102e74:	6a 00                	push   $0x0
  pushl $183
c0102e76:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102e7b:	e9 cc f8 ff ff       	jmp    c010274c <__alltraps>

c0102e80 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102e80:	6a 00                	push   $0x0
  pushl $184
c0102e82:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102e87:	e9 c0 f8 ff ff       	jmp    c010274c <__alltraps>

c0102e8c <vector185>:
.globl vector185
vector185:
  pushl $0
c0102e8c:	6a 00                	push   $0x0
  pushl $185
c0102e8e:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102e93:	e9 b4 f8 ff ff       	jmp    c010274c <__alltraps>

c0102e98 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102e98:	6a 00                	push   $0x0
  pushl $186
c0102e9a:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102e9f:	e9 a8 f8 ff ff       	jmp    c010274c <__alltraps>

c0102ea4 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102ea4:	6a 00                	push   $0x0
  pushl $187
c0102ea6:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102eab:	e9 9c f8 ff ff       	jmp    c010274c <__alltraps>

c0102eb0 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102eb0:	6a 00                	push   $0x0
  pushl $188
c0102eb2:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102eb7:	e9 90 f8 ff ff       	jmp    c010274c <__alltraps>

c0102ebc <vector189>:
.globl vector189
vector189:
  pushl $0
c0102ebc:	6a 00                	push   $0x0
  pushl $189
c0102ebe:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102ec3:	e9 84 f8 ff ff       	jmp    c010274c <__alltraps>

c0102ec8 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102ec8:	6a 00                	push   $0x0
  pushl $190
c0102eca:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102ecf:	e9 78 f8 ff ff       	jmp    c010274c <__alltraps>

c0102ed4 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102ed4:	6a 00                	push   $0x0
  pushl $191
c0102ed6:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102edb:	e9 6c f8 ff ff       	jmp    c010274c <__alltraps>

c0102ee0 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102ee0:	6a 00                	push   $0x0
  pushl $192
c0102ee2:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102ee7:	e9 60 f8 ff ff       	jmp    c010274c <__alltraps>

c0102eec <vector193>:
.globl vector193
vector193:
  pushl $0
c0102eec:	6a 00                	push   $0x0
  pushl $193
c0102eee:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102ef3:	e9 54 f8 ff ff       	jmp    c010274c <__alltraps>

c0102ef8 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102ef8:	6a 00                	push   $0x0
  pushl $194
c0102efa:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102eff:	e9 48 f8 ff ff       	jmp    c010274c <__alltraps>

c0102f04 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102f04:	6a 00                	push   $0x0
  pushl $195
c0102f06:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102f0b:	e9 3c f8 ff ff       	jmp    c010274c <__alltraps>

c0102f10 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102f10:	6a 00                	push   $0x0
  pushl $196
c0102f12:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f17:	e9 30 f8 ff ff       	jmp    c010274c <__alltraps>

c0102f1c <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f1c:	6a 00                	push   $0x0
  pushl $197
c0102f1e:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f23:	e9 24 f8 ff ff       	jmp    c010274c <__alltraps>

c0102f28 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f28:	6a 00                	push   $0x0
  pushl $198
c0102f2a:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f2f:	e9 18 f8 ff ff       	jmp    c010274c <__alltraps>

c0102f34 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f34:	6a 00                	push   $0x0
  pushl $199
c0102f36:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f3b:	e9 0c f8 ff ff       	jmp    c010274c <__alltraps>

c0102f40 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f40:	6a 00                	push   $0x0
  pushl $200
c0102f42:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102f47:	e9 00 f8 ff ff       	jmp    c010274c <__alltraps>

c0102f4c <vector201>:
.globl vector201
vector201:
  pushl $0
c0102f4c:	6a 00                	push   $0x0
  pushl $201
c0102f4e:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102f53:	e9 f4 f7 ff ff       	jmp    c010274c <__alltraps>

c0102f58 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102f58:	6a 00                	push   $0x0
  pushl $202
c0102f5a:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102f5f:	e9 e8 f7 ff ff       	jmp    c010274c <__alltraps>

c0102f64 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102f64:	6a 00                	push   $0x0
  pushl $203
c0102f66:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102f6b:	e9 dc f7 ff ff       	jmp    c010274c <__alltraps>

c0102f70 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102f70:	6a 00                	push   $0x0
  pushl $204
c0102f72:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102f77:	e9 d0 f7 ff ff       	jmp    c010274c <__alltraps>

c0102f7c <vector205>:
.globl vector205
vector205:
  pushl $0
c0102f7c:	6a 00                	push   $0x0
  pushl $205
c0102f7e:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102f83:	e9 c4 f7 ff ff       	jmp    c010274c <__alltraps>

c0102f88 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102f88:	6a 00                	push   $0x0
  pushl $206
c0102f8a:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102f8f:	e9 b8 f7 ff ff       	jmp    c010274c <__alltraps>

c0102f94 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102f94:	6a 00                	push   $0x0
  pushl $207
c0102f96:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102f9b:	e9 ac f7 ff ff       	jmp    c010274c <__alltraps>

c0102fa0 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102fa0:	6a 00                	push   $0x0
  pushl $208
c0102fa2:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102fa7:	e9 a0 f7 ff ff       	jmp    c010274c <__alltraps>

c0102fac <vector209>:
.globl vector209
vector209:
  pushl $0
c0102fac:	6a 00                	push   $0x0
  pushl $209
c0102fae:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102fb3:	e9 94 f7 ff ff       	jmp    c010274c <__alltraps>

c0102fb8 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102fb8:	6a 00                	push   $0x0
  pushl $210
c0102fba:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102fbf:	e9 88 f7 ff ff       	jmp    c010274c <__alltraps>

c0102fc4 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102fc4:	6a 00                	push   $0x0
  pushl $211
c0102fc6:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102fcb:	e9 7c f7 ff ff       	jmp    c010274c <__alltraps>

c0102fd0 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102fd0:	6a 00                	push   $0x0
  pushl $212
c0102fd2:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102fd7:	e9 70 f7 ff ff       	jmp    c010274c <__alltraps>

c0102fdc <vector213>:
.globl vector213
vector213:
  pushl $0
c0102fdc:	6a 00                	push   $0x0
  pushl $213
c0102fde:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102fe3:	e9 64 f7 ff ff       	jmp    c010274c <__alltraps>

c0102fe8 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102fe8:	6a 00                	push   $0x0
  pushl $214
c0102fea:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102fef:	e9 58 f7 ff ff       	jmp    c010274c <__alltraps>

c0102ff4 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102ff4:	6a 00                	push   $0x0
  pushl $215
c0102ff6:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102ffb:	e9 4c f7 ff ff       	jmp    c010274c <__alltraps>

c0103000 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103000:	6a 00                	push   $0x0
  pushl $216
c0103002:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103007:	e9 40 f7 ff ff       	jmp    c010274c <__alltraps>

c010300c <vector217>:
.globl vector217
vector217:
  pushl $0
c010300c:	6a 00                	push   $0x0
  pushl $217
c010300e:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103013:	e9 34 f7 ff ff       	jmp    c010274c <__alltraps>

c0103018 <vector218>:
.globl vector218
vector218:
  pushl $0
c0103018:	6a 00                	push   $0x0
  pushl $218
c010301a:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010301f:	e9 28 f7 ff ff       	jmp    c010274c <__alltraps>

c0103024 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103024:	6a 00                	push   $0x0
  pushl $219
c0103026:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010302b:	e9 1c f7 ff ff       	jmp    c010274c <__alltraps>

c0103030 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103030:	6a 00                	push   $0x0
  pushl $220
c0103032:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103037:	e9 10 f7 ff ff       	jmp    c010274c <__alltraps>

c010303c <vector221>:
.globl vector221
vector221:
  pushl $0
c010303c:	6a 00                	push   $0x0
  pushl $221
c010303e:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103043:	e9 04 f7 ff ff       	jmp    c010274c <__alltraps>

c0103048 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103048:	6a 00                	push   $0x0
  pushl $222
c010304a:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010304f:	e9 f8 f6 ff ff       	jmp    c010274c <__alltraps>

c0103054 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103054:	6a 00                	push   $0x0
  pushl $223
c0103056:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010305b:	e9 ec f6 ff ff       	jmp    c010274c <__alltraps>

c0103060 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103060:	6a 00                	push   $0x0
  pushl $224
c0103062:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103067:	e9 e0 f6 ff ff       	jmp    c010274c <__alltraps>

c010306c <vector225>:
.globl vector225
vector225:
  pushl $0
c010306c:	6a 00                	push   $0x0
  pushl $225
c010306e:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103073:	e9 d4 f6 ff ff       	jmp    c010274c <__alltraps>

c0103078 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103078:	6a 00                	push   $0x0
  pushl $226
c010307a:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010307f:	e9 c8 f6 ff ff       	jmp    c010274c <__alltraps>

c0103084 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103084:	6a 00                	push   $0x0
  pushl $227
c0103086:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010308b:	e9 bc f6 ff ff       	jmp    c010274c <__alltraps>

c0103090 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103090:	6a 00                	push   $0x0
  pushl $228
c0103092:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103097:	e9 b0 f6 ff ff       	jmp    c010274c <__alltraps>

c010309c <vector229>:
.globl vector229
vector229:
  pushl $0
c010309c:	6a 00                	push   $0x0
  pushl $229
c010309e:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01030a3:	e9 a4 f6 ff ff       	jmp    c010274c <__alltraps>

c01030a8 <vector230>:
.globl vector230
vector230:
  pushl $0
c01030a8:	6a 00                	push   $0x0
  pushl $230
c01030aa:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01030af:	e9 98 f6 ff ff       	jmp    c010274c <__alltraps>

c01030b4 <vector231>:
.globl vector231
vector231:
  pushl $0
c01030b4:	6a 00                	push   $0x0
  pushl $231
c01030b6:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01030bb:	e9 8c f6 ff ff       	jmp    c010274c <__alltraps>

c01030c0 <vector232>:
.globl vector232
vector232:
  pushl $0
c01030c0:	6a 00                	push   $0x0
  pushl $232
c01030c2:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01030c7:	e9 80 f6 ff ff       	jmp    c010274c <__alltraps>

c01030cc <vector233>:
.globl vector233
vector233:
  pushl $0
c01030cc:	6a 00                	push   $0x0
  pushl $233
c01030ce:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01030d3:	e9 74 f6 ff ff       	jmp    c010274c <__alltraps>

c01030d8 <vector234>:
.globl vector234
vector234:
  pushl $0
c01030d8:	6a 00                	push   $0x0
  pushl $234
c01030da:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01030df:	e9 68 f6 ff ff       	jmp    c010274c <__alltraps>

c01030e4 <vector235>:
.globl vector235
vector235:
  pushl $0
c01030e4:	6a 00                	push   $0x0
  pushl $235
c01030e6:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01030eb:	e9 5c f6 ff ff       	jmp    c010274c <__alltraps>

c01030f0 <vector236>:
.globl vector236
vector236:
  pushl $0
c01030f0:	6a 00                	push   $0x0
  pushl $236
c01030f2:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01030f7:	e9 50 f6 ff ff       	jmp    c010274c <__alltraps>

c01030fc <vector237>:
.globl vector237
vector237:
  pushl $0
c01030fc:	6a 00                	push   $0x0
  pushl $237
c01030fe:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103103:	e9 44 f6 ff ff       	jmp    c010274c <__alltraps>

c0103108 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103108:	6a 00                	push   $0x0
  pushl $238
c010310a:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010310f:	e9 38 f6 ff ff       	jmp    c010274c <__alltraps>

c0103114 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103114:	6a 00                	push   $0x0
  pushl $239
c0103116:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010311b:	e9 2c f6 ff ff       	jmp    c010274c <__alltraps>

c0103120 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103120:	6a 00                	push   $0x0
  pushl $240
c0103122:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103127:	e9 20 f6 ff ff       	jmp    c010274c <__alltraps>

c010312c <vector241>:
.globl vector241
vector241:
  pushl $0
c010312c:	6a 00                	push   $0x0
  pushl $241
c010312e:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103133:	e9 14 f6 ff ff       	jmp    c010274c <__alltraps>

c0103138 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103138:	6a 00                	push   $0x0
  pushl $242
c010313a:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010313f:	e9 08 f6 ff ff       	jmp    c010274c <__alltraps>

c0103144 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103144:	6a 00                	push   $0x0
  pushl $243
c0103146:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010314b:	e9 fc f5 ff ff       	jmp    c010274c <__alltraps>

c0103150 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103150:	6a 00                	push   $0x0
  pushl $244
c0103152:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103157:	e9 f0 f5 ff ff       	jmp    c010274c <__alltraps>

c010315c <vector245>:
.globl vector245
vector245:
  pushl $0
c010315c:	6a 00                	push   $0x0
  pushl $245
c010315e:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103163:	e9 e4 f5 ff ff       	jmp    c010274c <__alltraps>

c0103168 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103168:	6a 00                	push   $0x0
  pushl $246
c010316a:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010316f:	e9 d8 f5 ff ff       	jmp    c010274c <__alltraps>

c0103174 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103174:	6a 00                	push   $0x0
  pushl $247
c0103176:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010317b:	e9 cc f5 ff ff       	jmp    c010274c <__alltraps>

c0103180 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103180:	6a 00                	push   $0x0
  pushl $248
c0103182:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103187:	e9 c0 f5 ff ff       	jmp    c010274c <__alltraps>

c010318c <vector249>:
.globl vector249
vector249:
  pushl $0
c010318c:	6a 00                	push   $0x0
  pushl $249
c010318e:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103193:	e9 b4 f5 ff ff       	jmp    c010274c <__alltraps>

c0103198 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103198:	6a 00                	push   $0x0
  pushl $250
c010319a:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010319f:	e9 a8 f5 ff ff       	jmp    c010274c <__alltraps>

c01031a4 <vector251>:
.globl vector251
vector251:
  pushl $0
c01031a4:	6a 00                	push   $0x0
  pushl $251
c01031a6:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01031ab:	e9 9c f5 ff ff       	jmp    c010274c <__alltraps>

c01031b0 <vector252>:
.globl vector252
vector252:
  pushl $0
c01031b0:	6a 00                	push   $0x0
  pushl $252
c01031b2:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01031b7:	e9 90 f5 ff ff       	jmp    c010274c <__alltraps>

c01031bc <vector253>:
.globl vector253
vector253:
  pushl $0
c01031bc:	6a 00                	push   $0x0
  pushl $253
c01031be:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01031c3:	e9 84 f5 ff ff       	jmp    c010274c <__alltraps>

c01031c8 <vector254>:
.globl vector254
vector254:
  pushl $0
c01031c8:	6a 00                	push   $0x0
  pushl $254
c01031ca:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01031cf:	e9 78 f5 ff ff       	jmp    c010274c <__alltraps>

c01031d4 <vector255>:
.globl vector255
vector255:
  pushl $0
c01031d4:	6a 00                	push   $0x0
  pushl $255
c01031d6:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01031db:	e9 6c f5 ff ff       	jmp    c010274c <__alltraps>

c01031e0 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01031e0:	55                   	push   %ebp
c01031e1:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01031e3:	8b 55 08             	mov    0x8(%ebp),%edx
c01031e6:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c01031eb:	29 c2                	sub    %eax,%edx
c01031ed:	89 d0                	mov    %edx,%eax
c01031ef:	c1 f8 05             	sar    $0x5,%eax
}
c01031f2:	5d                   	pop    %ebp
c01031f3:	c3                   	ret    

c01031f4 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01031f4:	55                   	push   %ebp
c01031f5:	89 e5                	mov    %esp,%ebp
c01031f7:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01031fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01031fd:	89 04 24             	mov    %eax,(%esp)
c0103200:	e8 db ff ff ff       	call   c01031e0 <page2ppn>
c0103205:	c1 e0 0c             	shl    $0xc,%eax
}
c0103208:	c9                   	leave  
c0103209:	c3                   	ret    

c010320a <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010320a:	55                   	push   %ebp
c010320b:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010320d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103210:	8b 00                	mov    (%eax),%eax
}
c0103212:	5d                   	pop    %ebp
c0103213:	c3                   	ret    

c0103214 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103214:	55                   	push   %ebp
c0103215:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103217:	8b 45 08             	mov    0x8(%ebp),%eax
c010321a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010321d:	89 10                	mov    %edx,(%eax)
}
c010321f:	5d                   	pop    %ebp
c0103220:	c3                   	ret    

c0103221 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103221:	55                   	push   %ebp
c0103222:	89 e5                	mov    %esp,%ebp
c0103224:	83 ec 10             	sub    $0x10,%esp
c0103227:	c7 45 fc 40 40 12 c0 	movl   $0xc0124040,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010322e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103231:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103234:	89 50 04             	mov    %edx,0x4(%eax)
c0103237:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010323a:	8b 50 04             	mov    0x4(%eax),%edx
c010323d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103240:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103242:	c7 05 48 40 12 c0 00 	movl   $0x0,0xc0124048
c0103249:	00 00 00 
}
c010324c:	c9                   	leave  
c010324d:	c3                   	ret    

c010324e <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010324e:	55                   	push   %ebp
c010324f:	89 e5                	mov    %esp,%ebp
c0103251:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103254:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103258:	75 24                	jne    c010327e <default_init_memmap+0x30>
c010325a:	c7 44 24 0c 50 95 10 	movl   $0xc0109550,0xc(%esp)
c0103261:	c0 
c0103262:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103269:	c0 
c010326a:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0103271:	00 
c0103272:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103279:	e8 63 da ff ff       	call   c0100ce1 <__panic>
    struct Page *p = base;
c010327e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103281:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103284:	eb 7d                	jmp    c0103303 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0103286:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103289:	83 c0 04             	add    $0x4,%eax
c010328c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103293:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103296:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103299:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010329c:	0f a3 10             	bt     %edx,(%eax)
c010329f:	19 c0                	sbb    %eax,%eax
c01032a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01032a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01032a8:	0f 95 c0             	setne  %al
c01032ab:	0f b6 c0             	movzbl %al,%eax
c01032ae:	85 c0                	test   %eax,%eax
c01032b0:	75 24                	jne    c01032d6 <default_init_memmap+0x88>
c01032b2:	c7 44 24 0c 81 95 10 	movl   $0xc0109581,0xc(%esp)
c01032b9:	c0 
c01032ba:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c01032c1:	c0 
c01032c2:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01032c9:	00 
c01032ca:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01032d1:	e8 0b da ff ff       	call   c0100ce1 <__panic>
        p->flags = p->property = 0;
c01032d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01032e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e3:	8b 50 08             	mov    0x8(%eax),%edx
c01032e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e9:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01032ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01032f3:	00 
c01032f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032f7:	89 04 24             	mov    %eax,(%esp)
c01032fa:	e8 15 ff ff ff       	call   c0103214 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01032ff:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103303:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103306:	c1 e0 05             	shl    $0x5,%eax
c0103309:	89 c2                	mov    %eax,%edx
c010330b:	8b 45 08             	mov    0x8(%ebp),%eax
c010330e:	01 d0                	add    %edx,%eax
c0103310:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103313:	0f 85 6d ff ff ff    	jne    c0103286 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0103319:	8b 45 08             	mov    0x8(%ebp),%eax
c010331c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010331f:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103322:	8b 45 08             	mov    0x8(%ebp),%eax
c0103325:	83 c0 04             	add    $0x4,%eax
c0103328:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010332f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103332:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103335:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103338:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c010333b:	8b 15 48 40 12 c0    	mov    0xc0124048,%edx
c0103341:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103344:	01 d0                	add    %edx,%eax
c0103346:	a3 48 40 12 c0       	mov    %eax,0xc0124048
    list_add_before(&free_list, &(base->page_link));
c010334b:	8b 45 08             	mov    0x8(%ebp),%eax
c010334e:	83 c0 0c             	add    $0xc,%eax
c0103351:	c7 45 dc 40 40 12 c0 	movl   $0xc0124040,-0x24(%ebp)
c0103358:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010335b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010335e:	8b 00                	mov    (%eax),%eax
c0103360:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103363:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103366:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103369:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010336c:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010336f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103372:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103375:	89 10                	mov    %edx,(%eax)
c0103377:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010337a:	8b 10                	mov    (%eax),%edx
c010337c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010337f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103382:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103385:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103388:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010338b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010338e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103391:	89 10                	mov    %edx,(%eax)
}
c0103393:	c9                   	leave  
c0103394:	c3                   	ret    

c0103395 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0103395:	55                   	push   %ebp
c0103396:	89 e5                	mov    %esp,%ebp
c0103398:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010339b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010339f:	75 24                	jne    c01033c5 <default_alloc_pages+0x30>
c01033a1:	c7 44 24 0c 50 95 10 	movl   $0xc0109550,0xc(%esp)
c01033a8:	c0 
c01033a9:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c01033b0:	c0 
c01033b1:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c01033b8:	00 
c01033b9:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01033c0:	e8 1c d9 ff ff       	call   c0100ce1 <__panic>
    if (n > nr_free) {
c01033c5:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c01033ca:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033cd:	73 0a                	jae    c01033d9 <default_alloc_pages+0x44>
        return NULL;
c01033cf:	b8 00 00 00 00       	mov    $0x0,%eax
c01033d4:	e9 36 01 00 00       	jmp    c010350f <default_alloc_pages+0x17a>
    }
    struct Page *page = NULL;
c01033d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01033e0:	c7 45 f0 40 40 12 c0 	movl   $0xc0124040,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c01033e7:	eb 1c                	jmp    c0103405 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c01033e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033ec:	83 e8 0c             	sub    $0xc,%eax
c01033ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01033f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033f5:	8b 40 08             	mov    0x8(%eax),%eax
c01033f8:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033fb:	72 08                	jb     c0103405 <default_alloc_pages+0x70>
            page = p;
c01033fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103400:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0103403:	eb 18                	jmp    c010341d <default_alloc_pages+0x88>
c0103405:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010340b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010340e:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c0103411:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103414:	81 7d f0 40 40 12 c0 	cmpl   $0xc0124040,-0x10(%ebp)
c010341b:	75 cc                	jne    c01033e9 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c010341d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103421:	0f 84 e5 00 00 00    	je     c010350c <default_alloc_pages+0x177>
        if (page->property > n) {
c0103427:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010342a:	8b 40 08             	mov    0x8(%eax),%eax
c010342d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103430:	0f 86 85 00 00 00    	jbe    c01034bb <default_alloc_pages+0x126>
            struct Page *p = page + n;
c0103436:	8b 45 08             	mov    0x8(%ebp),%eax
c0103439:	c1 e0 05             	shl    $0x5,%eax
c010343c:	89 c2                	mov    %eax,%edx
c010343e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103441:	01 d0                	add    %edx,%eax
c0103443:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0103446:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103449:	8b 40 08             	mov    0x8(%eax),%eax
c010344c:	2b 45 08             	sub    0x8(%ebp),%eax
c010344f:	89 c2                	mov    %eax,%edx
c0103451:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103454:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0103457:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010345a:	83 c0 04             	add    $0x4,%eax
c010345d:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0103464:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103467:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010346a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010346d:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0103470:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103473:	83 c0 0c             	add    $0xc,%eax
c0103476:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103479:	83 c2 0c             	add    $0xc,%edx
c010347c:	89 55 d8             	mov    %edx,-0x28(%ebp)
c010347f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0103482:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103485:	8b 40 04             	mov    0x4(%eax),%eax
c0103488:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010348b:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010348e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103491:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103494:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103497:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010349a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010349d:	89 10                	mov    %edx,(%eax)
c010349f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01034a2:	8b 10                	mov    (%eax),%edx
c01034a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01034a7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01034aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034ad:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01034b0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01034b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034b6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01034b9:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c01034bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034be:	83 c0 0c             	add    $0xc,%eax
c01034c1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01034c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01034c7:	8b 40 04             	mov    0x4(%eax),%eax
c01034ca:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01034cd:	8b 12                	mov    (%edx),%edx
c01034cf:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01034d2:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01034d5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01034d8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01034db:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01034de:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034e1:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034e4:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c01034e6:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c01034eb:	2b 45 08             	sub    0x8(%ebp),%eax
c01034ee:	a3 48 40 12 c0       	mov    %eax,0xc0124048
        ClearPageProperty(page);
c01034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034f6:	83 c0 04             	add    $0x4,%eax
c01034f9:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0103500:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103503:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103506:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103509:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c010350c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010350f:	c9                   	leave  
c0103510:	c3                   	ret    

c0103511 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103511:	55                   	push   %ebp
c0103512:	89 e5                	mov    %esp,%ebp
c0103514:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c010351a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010351e:	75 24                	jne    c0103544 <default_free_pages+0x33>
c0103520:	c7 44 24 0c 50 95 10 	movl   $0xc0109550,0xc(%esp)
c0103527:	c0 
c0103528:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c010352f:	c0 
c0103530:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0103537:	00 
c0103538:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c010353f:	e8 9d d7 ff ff       	call   c0100ce1 <__panic>
    struct Page *p = base;
c0103544:	8b 45 08             	mov    0x8(%ebp),%eax
c0103547:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010354a:	e9 9d 00 00 00       	jmp    c01035ec <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c010354f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103552:	83 c0 04             	add    $0x4,%eax
c0103555:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010355c:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010355f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103562:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103565:	0f a3 10             	bt     %edx,(%eax)
c0103568:	19 c0                	sbb    %eax,%eax
c010356a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c010356d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103571:	0f 95 c0             	setne  %al
c0103574:	0f b6 c0             	movzbl %al,%eax
c0103577:	85 c0                	test   %eax,%eax
c0103579:	75 2c                	jne    c01035a7 <default_free_pages+0x96>
c010357b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010357e:	83 c0 04             	add    $0x4,%eax
c0103581:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0103588:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010358b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010358e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103591:	0f a3 10             	bt     %edx,(%eax)
c0103594:	19 c0                	sbb    %eax,%eax
c0103596:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0103599:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010359d:	0f 95 c0             	setne  %al
c01035a0:	0f b6 c0             	movzbl %al,%eax
c01035a3:	85 c0                	test   %eax,%eax
c01035a5:	74 24                	je     c01035cb <default_free_pages+0xba>
c01035a7:	c7 44 24 0c 94 95 10 	movl   $0xc0109594,0xc(%esp)
c01035ae:	c0 
c01035af:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c01035b6:	c0 
c01035b7:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c01035be:	00 
c01035bf:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01035c6:	e8 16 d7 ff ff       	call   c0100ce1 <__panic>
        p->flags = 0;
c01035cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01035d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01035dc:	00 
c01035dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e0:	89 04 24             	mov    %eax,(%esp)
c01035e3:	e8 2c fc ff ff       	call   c0103214 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01035e8:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01035ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035ef:	c1 e0 05             	shl    $0x5,%eax
c01035f2:	89 c2                	mov    %eax,%edx
c01035f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01035f7:	01 d0                	add    %edx,%eax
c01035f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01035fc:	0f 85 4d ff ff ff    	jne    c010354f <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0103602:	8b 45 08             	mov    0x8(%ebp),%eax
c0103605:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103608:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010360b:	8b 45 08             	mov    0x8(%ebp),%eax
c010360e:	83 c0 04             	add    $0x4,%eax
c0103611:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103618:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010361b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010361e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103621:	0f ab 10             	bts    %edx,(%eax)
c0103624:	c7 45 cc 40 40 12 c0 	movl   $0xc0124040,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010362b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010362e:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0103631:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0103634:	e9 fa 00 00 00       	jmp    c0103733 <default_free_pages+0x222>
        p = le2page(le, page_link);
c0103639:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010363c:	83 e8 0c             	sub    $0xc,%eax
c010363f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103642:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103645:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103648:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010364b:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010364e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0103651:	8b 45 08             	mov    0x8(%ebp),%eax
c0103654:	8b 40 08             	mov    0x8(%eax),%eax
c0103657:	c1 e0 05             	shl    $0x5,%eax
c010365a:	89 c2                	mov    %eax,%edx
c010365c:	8b 45 08             	mov    0x8(%ebp),%eax
c010365f:	01 d0                	add    %edx,%eax
c0103661:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103664:	75 5a                	jne    c01036c0 <default_free_pages+0x1af>
            base->property += p->property;
c0103666:	8b 45 08             	mov    0x8(%ebp),%eax
c0103669:	8b 50 08             	mov    0x8(%eax),%edx
c010366c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010366f:	8b 40 08             	mov    0x8(%eax),%eax
c0103672:	01 c2                	add    %eax,%edx
c0103674:	8b 45 08             	mov    0x8(%ebp),%eax
c0103677:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c010367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010367d:	83 c0 04             	add    $0x4,%eax
c0103680:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0103687:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010368a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010368d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103690:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0103693:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103696:	83 c0 0c             	add    $0xc,%eax
c0103699:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010369c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010369f:	8b 40 04             	mov    0x4(%eax),%eax
c01036a2:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01036a5:	8b 12                	mov    (%edx),%edx
c01036a7:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01036aa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01036ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01036b0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01036b3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01036b6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01036b9:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01036bc:	89 10                	mov    %edx,(%eax)
c01036be:	eb 73                	jmp    c0103733 <default_free_pages+0x222>
        }
        else if (p + p->property == base) {
c01036c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036c3:	8b 40 08             	mov    0x8(%eax),%eax
c01036c6:	c1 e0 05             	shl    $0x5,%eax
c01036c9:	89 c2                	mov    %eax,%edx
c01036cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ce:	01 d0                	add    %edx,%eax
c01036d0:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036d3:	75 5e                	jne    c0103733 <default_free_pages+0x222>
            p->property += base->property;
c01036d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036d8:	8b 50 08             	mov    0x8(%eax),%edx
c01036db:	8b 45 08             	mov    0x8(%ebp),%eax
c01036de:	8b 40 08             	mov    0x8(%eax),%eax
c01036e1:	01 c2                	add    %eax,%edx
c01036e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e6:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c01036e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01036ec:	83 c0 04             	add    $0x4,%eax
c01036ef:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c01036f6:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01036f9:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01036fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01036ff:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0103702:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103705:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0103708:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010370b:	83 c0 0c             	add    $0xc,%eax
c010370e:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103711:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103714:	8b 40 04             	mov    0x4(%eax),%eax
c0103717:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010371a:	8b 12                	mov    (%edx),%edx
c010371c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c010371f:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103722:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103725:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103728:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010372b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010372e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103731:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0103733:	81 7d f0 40 40 12 c0 	cmpl   $0xc0124040,-0x10(%ebp)
c010373a:	0f 85 f9 fe ff ff    	jne    c0103639 <default_free_pages+0x128>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0103740:	8b 15 48 40 12 c0    	mov    0xc0124048,%edx
c0103746:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103749:	01 d0                	add    %edx,%eax
c010374b:	a3 48 40 12 c0       	mov    %eax,0xc0124048
c0103750:	c7 45 9c 40 40 12 c0 	movl   $0xc0124040,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103757:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010375a:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c010375d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0103760:	eb 68                	jmp    c01037ca <default_free_pages+0x2b9>
        p = le2page(le, page_link);
c0103762:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103765:	83 e8 0c             	sub    $0xc,%eax
c0103768:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c010376b:	8b 45 08             	mov    0x8(%ebp),%eax
c010376e:	8b 40 08             	mov    0x8(%eax),%eax
c0103771:	c1 e0 05             	shl    $0x5,%eax
c0103774:	89 c2                	mov    %eax,%edx
c0103776:	8b 45 08             	mov    0x8(%ebp),%eax
c0103779:	01 d0                	add    %edx,%eax
c010377b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010377e:	77 3b                	ja     c01037bb <default_free_pages+0x2aa>
            assert(base + base->property != p);
c0103780:	8b 45 08             	mov    0x8(%ebp),%eax
c0103783:	8b 40 08             	mov    0x8(%eax),%eax
c0103786:	c1 e0 05             	shl    $0x5,%eax
c0103789:	89 c2                	mov    %eax,%edx
c010378b:	8b 45 08             	mov    0x8(%ebp),%eax
c010378e:	01 d0                	add    %edx,%eax
c0103790:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103793:	75 24                	jne    c01037b9 <default_free_pages+0x2a8>
c0103795:	c7 44 24 0c b9 95 10 	movl   $0xc01095b9,0xc(%esp)
c010379c:	c0 
c010379d:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c01037a4:	c0 
c01037a5:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01037ac:	00 
c01037ad:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01037b4:	e8 28 d5 ff ff       	call   c0100ce1 <__panic>
            break;
c01037b9:	eb 18                	jmp    c01037d3 <default_free_pages+0x2c2>
c01037bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037be:	89 45 98             	mov    %eax,-0x68(%ebp)
c01037c1:	8b 45 98             	mov    -0x68(%ebp),%eax
c01037c4:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c01037c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
    le = list_next(&free_list);
    while (le != &free_list) {
c01037ca:	81 7d f0 40 40 12 c0 	cmpl   $0xc0124040,-0x10(%ebp)
c01037d1:	75 8f                	jne    c0103762 <default_free_pages+0x251>
            assert(base + base->property != p);
            break;
        }
        le = list_next(le);
    }
    list_add_before(le, &(base->page_link));
c01037d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01037d6:	8d 50 0c             	lea    0xc(%eax),%edx
c01037d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037dc:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01037df:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01037e2:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01037e5:	8b 00                	mov    (%eax),%eax
c01037e7:	8b 55 90             	mov    -0x70(%ebp),%edx
c01037ea:	89 55 8c             	mov    %edx,-0x74(%ebp)
c01037ed:	89 45 88             	mov    %eax,-0x78(%ebp)
c01037f0:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01037f3:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01037f6:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01037f9:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01037fc:	89 10                	mov    %edx,(%eax)
c01037fe:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103801:	8b 10                	mov    (%eax),%edx
c0103803:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103806:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103809:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010380c:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010380f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103812:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103815:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103818:	89 10                	mov    %edx,(%eax)
}
c010381a:	c9                   	leave  
c010381b:	c3                   	ret    

c010381c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010381c:	55                   	push   %ebp
c010381d:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010381f:	a1 48 40 12 c0       	mov    0xc0124048,%eax
}
c0103824:	5d                   	pop    %ebp
c0103825:	c3                   	ret    

c0103826 <basic_check>:

static void
basic_check(void) {
c0103826:	55                   	push   %ebp
c0103827:	89 e5                	mov    %esp,%ebp
c0103829:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010382c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103833:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103836:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103839:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010383c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010383f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103846:	e8 d7 0e 00 00       	call   c0104722 <alloc_pages>
c010384b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010384e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103852:	75 24                	jne    c0103878 <basic_check+0x52>
c0103854:	c7 44 24 0c d4 95 10 	movl   $0xc01095d4,0xc(%esp)
c010385b:	c0 
c010385c:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103863:	c0 
c0103864:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c010386b:	00 
c010386c:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103873:	e8 69 d4 ff ff       	call   c0100ce1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103878:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010387f:	e8 9e 0e 00 00       	call   c0104722 <alloc_pages>
c0103884:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103887:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010388b:	75 24                	jne    c01038b1 <basic_check+0x8b>
c010388d:	c7 44 24 0c f0 95 10 	movl   $0xc01095f0,0xc(%esp)
c0103894:	c0 
c0103895:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c010389c:	c0 
c010389d:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c01038a4:	00 
c01038a5:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01038ac:	e8 30 d4 ff ff       	call   c0100ce1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01038b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038b8:	e8 65 0e 00 00       	call   c0104722 <alloc_pages>
c01038bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01038c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01038c4:	75 24                	jne    c01038ea <basic_check+0xc4>
c01038c6:	c7 44 24 0c 0c 96 10 	movl   $0xc010960c,0xc(%esp)
c01038cd:	c0 
c01038ce:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c01038d5:	c0 
c01038d6:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c01038dd:	00 
c01038de:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01038e5:	e8 f7 d3 ff ff       	call   c0100ce1 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01038ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01038f0:	74 10                	je     c0103902 <basic_check+0xdc>
c01038f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01038f8:	74 08                	je     c0103902 <basic_check+0xdc>
c01038fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103900:	75 24                	jne    c0103926 <basic_check+0x100>
c0103902:	c7 44 24 0c 28 96 10 	movl   $0xc0109628,0xc(%esp)
c0103909:	c0 
c010390a:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103911:	c0 
c0103912:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103919:	00 
c010391a:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103921:	e8 bb d3 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103926:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103929:	89 04 24             	mov    %eax,(%esp)
c010392c:	e8 d9 f8 ff ff       	call   c010320a <page_ref>
c0103931:	85 c0                	test   %eax,%eax
c0103933:	75 1e                	jne    c0103953 <basic_check+0x12d>
c0103935:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103938:	89 04 24             	mov    %eax,(%esp)
c010393b:	e8 ca f8 ff ff       	call   c010320a <page_ref>
c0103940:	85 c0                	test   %eax,%eax
c0103942:	75 0f                	jne    c0103953 <basic_check+0x12d>
c0103944:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103947:	89 04 24             	mov    %eax,(%esp)
c010394a:	e8 bb f8 ff ff       	call   c010320a <page_ref>
c010394f:	85 c0                	test   %eax,%eax
c0103951:	74 24                	je     c0103977 <basic_check+0x151>
c0103953:	c7 44 24 0c 4c 96 10 	movl   $0xc010964c,0xc(%esp)
c010395a:	c0 
c010395b:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103962:	c0 
c0103963:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c010396a:	00 
c010396b:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103972:	e8 6a d3 ff ff       	call   c0100ce1 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103977:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010397a:	89 04 24             	mov    %eax,(%esp)
c010397d:	e8 72 f8 ff ff       	call   c01031f4 <page2pa>
c0103982:	8b 15 a0 3f 12 c0    	mov    0xc0123fa0,%edx
c0103988:	c1 e2 0c             	shl    $0xc,%edx
c010398b:	39 d0                	cmp    %edx,%eax
c010398d:	72 24                	jb     c01039b3 <basic_check+0x18d>
c010398f:	c7 44 24 0c 88 96 10 	movl   $0xc0109688,0xc(%esp)
c0103996:	c0 
c0103997:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c010399e:	c0 
c010399f:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01039a6:	00 
c01039a7:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01039ae:	e8 2e d3 ff ff       	call   c0100ce1 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01039b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039b6:	89 04 24             	mov    %eax,(%esp)
c01039b9:	e8 36 f8 ff ff       	call   c01031f4 <page2pa>
c01039be:	8b 15 a0 3f 12 c0    	mov    0xc0123fa0,%edx
c01039c4:	c1 e2 0c             	shl    $0xc,%edx
c01039c7:	39 d0                	cmp    %edx,%eax
c01039c9:	72 24                	jb     c01039ef <basic_check+0x1c9>
c01039cb:	c7 44 24 0c a5 96 10 	movl   $0xc01096a5,0xc(%esp)
c01039d2:	c0 
c01039d3:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c01039da:	c0 
c01039db:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01039e2:	00 
c01039e3:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01039ea:	e8 f2 d2 ff ff       	call   c0100ce1 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01039ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039f2:	89 04 24             	mov    %eax,(%esp)
c01039f5:	e8 fa f7 ff ff       	call   c01031f4 <page2pa>
c01039fa:	8b 15 a0 3f 12 c0    	mov    0xc0123fa0,%edx
c0103a00:	c1 e2 0c             	shl    $0xc,%edx
c0103a03:	39 d0                	cmp    %edx,%eax
c0103a05:	72 24                	jb     c0103a2b <basic_check+0x205>
c0103a07:	c7 44 24 0c c2 96 10 	movl   $0xc01096c2,0xc(%esp)
c0103a0e:	c0 
c0103a0f:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103a16:	c0 
c0103a17:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103a1e:	00 
c0103a1f:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103a26:	e8 b6 d2 ff ff       	call   c0100ce1 <__panic>

    list_entry_t free_list_store = free_list;
c0103a2b:	a1 40 40 12 c0       	mov    0xc0124040,%eax
c0103a30:	8b 15 44 40 12 c0    	mov    0xc0124044,%edx
c0103a36:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103a39:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103a3c:	c7 45 e0 40 40 12 c0 	movl   $0xc0124040,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103a43:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a46:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103a49:	89 50 04             	mov    %edx,0x4(%eax)
c0103a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a4f:	8b 50 04             	mov    0x4(%eax),%edx
c0103a52:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a55:	89 10                	mov    %edx,(%eax)
c0103a57:	c7 45 dc 40 40 12 c0 	movl   $0xc0124040,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103a5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a61:	8b 40 04             	mov    0x4(%eax),%eax
c0103a64:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103a67:	0f 94 c0             	sete   %al
c0103a6a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103a6d:	85 c0                	test   %eax,%eax
c0103a6f:	75 24                	jne    c0103a95 <basic_check+0x26f>
c0103a71:	c7 44 24 0c df 96 10 	movl   $0xc01096df,0xc(%esp)
c0103a78:	c0 
c0103a79:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103a80:	c0 
c0103a81:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103a88:	00 
c0103a89:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103a90:	e8 4c d2 ff ff       	call   c0100ce1 <__panic>

    unsigned int nr_free_store = nr_free;
c0103a95:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c0103a9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103a9d:	c7 05 48 40 12 c0 00 	movl   $0x0,0xc0124048
c0103aa4:	00 00 00 

    assert(alloc_page() == NULL);
c0103aa7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103aae:	e8 6f 0c 00 00       	call   c0104722 <alloc_pages>
c0103ab3:	85 c0                	test   %eax,%eax
c0103ab5:	74 24                	je     c0103adb <basic_check+0x2b5>
c0103ab7:	c7 44 24 0c f6 96 10 	movl   $0xc01096f6,0xc(%esp)
c0103abe:	c0 
c0103abf:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103ac6:	c0 
c0103ac7:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103ace:	00 
c0103acf:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103ad6:	e8 06 d2 ff ff       	call   c0100ce1 <__panic>

    free_page(p0);
c0103adb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ae2:	00 
c0103ae3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ae6:	89 04 24             	mov    %eax,(%esp)
c0103ae9:	e8 9f 0c 00 00       	call   c010478d <free_pages>
    free_page(p1);
c0103aee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103af5:	00 
c0103af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103af9:	89 04 24             	mov    %eax,(%esp)
c0103afc:	e8 8c 0c 00 00       	call   c010478d <free_pages>
    free_page(p2);
c0103b01:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b08:	00 
c0103b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b0c:	89 04 24             	mov    %eax,(%esp)
c0103b0f:	e8 79 0c 00 00       	call   c010478d <free_pages>
    assert(nr_free == 3);
c0103b14:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c0103b19:	83 f8 03             	cmp    $0x3,%eax
c0103b1c:	74 24                	je     c0103b42 <basic_check+0x31c>
c0103b1e:	c7 44 24 0c 0b 97 10 	movl   $0xc010970b,0xc(%esp)
c0103b25:	c0 
c0103b26:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103b2d:	c0 
c0103b2e:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0103b35:	00 
c0103b36:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103b3d:	e8 9f d1 ff ff       	call   c0100ce1 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103b42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b49:	e8 d4 0b 00 00       	call   c0104722 <alloc_pages>
c0103b4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b51:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103b55:	75 24                	jne    c0103b7b <basic_check+0x355>
c0103b57:	c7 44 24 0c d4 95 10 	movl   $0xc01095d4,0xc(%esp)
c0103b5e:	c0 
c0103b5f:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103b66:	c0 
c0103b67:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0103b6e:	00 
c0103b6f:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103b76:	e8 66 d1 ff ff       	call   c0100ce1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103b7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b82:	e8 9b 0b 00 00       	call   c0104722 <alloc_pages>
c0103b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b8e:	75 24                	jne    c0103bb4 <basic_check+0x38e>
c0103b90:	c7 44 24 0c f0 95 10 	movl   $0xc01095f0,0xc(%esp)
c0103b97:	c0 
c0103b98:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103b9f:	c0 
c0103ba0:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103ba7:	00 
c0103ba8:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103baf:	e8 2d d1 ff ff       	call   c0100ce1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103bb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bbb:	e8 62 0b 00 00       	call   c0104722 <alloc_pages>
c0103bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103bc7:	75 24                	jne    c0103bed <basic_check+0x3c7>
c0103bc9:	c7 44 24 0c 0c 96 10 	movl   $0xc010960c,0xc(%esp)
c0103bd0:	c0 
c0103bd1:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103bd8:	c0 
c0103bd9:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103be0:	00 
c0103be1:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103be8:	e8 f4 d0 ff ff       	call   c0100ce1 <__panic>

    assert(alloc_page() == NULL);
c0103bed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bf4:	e8 29 0b 00 00       	call   c0104722 <alloc_pages>
c0103bf9:	85 c0                	test   %eax,%eax
c0103bfb:	74 24                	je     c0103c21 <basic_check+0x3fb>
c0103bfd:	c7 44 24 0c f6 96 10 	movl   $0xc01096f6,0xc(%esp)
c0103c04:	c0 
c0103c05:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103c0c:	c0 
c0103c0d:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103c14:	00 
c0103c15:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103c1c:	e8 c0 d0 ff ff       	call   c0100ce1 <__panic>

    free_page(p0);
c0103c21:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c28:	00 
c0103c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c2c:	89 04 24             	mov    %eax,(%esp)
c0103c2f:	e8 59 0b 00 00       	call   c010478d <free_pages>
c0103c34:	c7 45 d8 40 40 12 c0 	movl   $0xc0124040,-0x28(%ebp)
c0103c3b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103c3e:	8b 40 04             	mov    0x4(%eax),%eax
c0103c41:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103c44:	0f 94 c0             	sete   %al
c0103c47:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103c4a:	85 c0                	test   %eax,%eax
c0103c4c:	74 24                	je     c0103c72 <basic_check+0x44c>
c0103c4e:	c7 44 24 0c 18 97 10 	movl   $0xc0109718,0xc(%esp)
c0103c55:	c0 
c0103c56:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103c5d:	c0 
c0103c5e:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103c65:	00 
c0103c66:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103c6d:	e8 6f d0 ff ff       	call   c0100ce1 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103c72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c79:	e8 a4 0a 00 00       	call   c0104722 <alloc_pages>
c0103c7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c84:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103c87:	74 24                	je     c0103cad <basic_check+0x487>
c0103c89:	c7 44 24 0c 30 97 10 	movl   $0xc0109730,0xc(%esp)
c0103c90:	c0 
c0103c91:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103c98:	c0 
c0103c99:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103ca0:	00 
c0103ca1:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103ca8:	e8 34 d0 ff ff       	call   c0100ce1 <__panic>
    assert(alloc_page() == NULL);
c0103cad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cb4:	e8 69 0a 00 00       	call   c0104722 <alloc_pages>
c0103cb9:	85 c0                	test   %eax,%eax
c0103cbb:	74 24                	je     c0103ce1 <basic_check+0x4bb>
c0103cbd:	c7 44 24 0c f6 96 10 	movl   $0xc01096f6,0xc(%esp)
c0103cc4:	c0 
c0103cc5:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103ccc:	c0 
c0103ccd:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103cd4:	00 
c0103cd5:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103cdc:	e8 00 d0 ff ff       	call   c0100ce1 <__panic>

    assert(nr_free == 0);
c0103ce1:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c0103ce6:	85 c0                	test   %eax,%eax
c0103ce8:	74 24                	je     c0103d0e <basic_check+0x4e8>
c0103cea:	c7 44 24 0c 49 97 10 	movl   $0xc0109749,0xc(%esp)
c0103cf1:	c0 
c0103cf2:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103cf9:	c0 
c0103cfa:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0103d01:	00 
c0103d02:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103d09:	e8 d3 cf ff ff       	call   c0100ce1 <__panic>
    free_list = free_list_store;
c0103d0e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d11:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103d14:	a3 40 40 12 c0       	mov    %eax,0xc0124040
c0103d19:	89 15 44 40 12 c0    	mov    %edx,0xc0124044
    nr_free = nr_free_store;
c0103d1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d22:	a3 48 40 12 c0       	mov    %eax,0xc0124048

    free_page(p);
c0103d27:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d2e:	00 
c0103d2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d32:	89 04 24             	mov    %eax,(%esp)
c0103d35:	e8 53 0a 00 00       	call   c010478d <free_pages>
    free_page(p1);
c0103d3a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d41:	00 
c0103d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d45:	89 04 24             	mov    %eax,(%esp)
c0103d48:	e8 40 0a 00 00       	call   c010478d <free_pages>
    free_page(p2);
c0103d4d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d54:	00 
c0103d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d58:	89 04 24             	mov    %eax,(%esp)
c0103d5b:	e8 2d 0a 00 00       	call   c010478d <free_pages>
}
c0103d60:	c9                   	leave  
c0103d61:	c3                   	ret    

c0103d62 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103d62:	55                   	push   %ebp
c0103d63:	89 e5                	mov    %esp,%ebp
c0103d65:	53                   	push   %ebx
c0103d66:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103d6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103d73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103d7a:	c7 45 ec 40 40 12 c0 	movl   $0xc0124040,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103d81:	eb 6b                	jmp    c0103dee <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d86:	83 e8 0c             	sub    $0xc,%eax
c0103d89:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103d8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d8f:	83 c0 04             	add    $0x4,%eax
c0103d92:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103d99:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103d9c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103d9f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103da2:	0f a3 10             	bt     %edx,(%eax)
c0103da5:	19 c0                	sbb    %eax,%eax
c0103da7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103daa:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103dae:	0f 95 c0             	setne  %al
c0103db1:	0f b6 c0             	movzbl %al,%eax
c0103db4:	85 c0                	test   %eax,%eax
c0103db6:	75 24                	jne    c0103ddc <default_check+0x7a>
c0103db8:	c7 44 24 0c 56 97 10 	movl   $0xc0109756,0xc(%esp)
c0103dbf:	c0 
c0103dc0:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103dc7:	c0 
c0103dc8:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0103dcf:	00 
c0103dd0:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103dd7:	e8 05 cf ff ff       	call   c0100ce1 <__panic>
        count ++, total += p->property;
c0103ddc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103de0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103de3:	8b 50 08             	mov    0x8(%eax),%edx
c0103de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103de9:	01 d0                	add    %edx,%eax
c0103deb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103dee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103df1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103df4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103df7:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103dfa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103dfd:	81 7d ec 40 40 12 c0 	cmpl   $0xc0124040,-0x14(%ebp)
c0103e04:	0f 85 79 ff ff ff    	jne    c0103d83 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103e0a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103e0d:	e8 ad 09 00 00       	call   c01047bf <nr_free_pages>
c0103e12:	39 c3                	cmp    %eax,%ebx
c0103e14:	74 24                	je     c0103e3a <default_check+0xd8>
c0103e16:	c7 44 24 0c 66 97 10 	movl   $0xc0109766,0xc(%esp)
c0103e1d:	c0 
c0103e1e:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103e25:	c0 
c0103e26:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103e2d:	00 
c0103e2e:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103e35:	e8 a7 ce ff ff       	call   c0100ce1 <__panic>

    basic_check();
c0103e3a:	e8 e7 f9 ff ff       	call   c0103826 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103e3f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103e46:	e8 d7 08 00 00       	call   c0104722 <alloc_pages>
c0103e4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103e4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e52:	75 24                	jne    c0103e78 <default_check+0x116>
c0103e54:	c7 44 24 0c 7f 97 10 	movl   $0xc010977f,0xc(%esp)
c0103e5b:	c0 
c0103e5c:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103e63:	c0 
c0103e64:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0103e6b:	00 
c0103e6c:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103e73:	e8 69 ce ff ff       	call   c0100ce1 <__panic>
    assert(!PageProperty(p0));
c0103e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e7b:	83 c0 04             	add    $0x4,%eax
c0103e7e:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103e85:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103e88:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103e8b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103e8e:	0f a3 10             	bt     %edx,(%eax)
c0103e91:	19 c0                	sbb    %eax,%eax
c0103e93:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103e96:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103e9a:	0f 95 c0             	setne  %al
c0103e9d:	0f b6 c0             	movzbl %al,%eax
c0103ea0:	85 c0                	test   %eax,%eax
c0103ea2:	74 24                	je     c0103ec8 <default_check+0x166>
c0103ea4:	c7 44 24 0c 8a 97 10 	movl   $0xc010978a,0xc(%esp)
c0103eab:	c0 
c0103eac:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103eb3:	c0 
c0103eb4:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0103ebb:	00 
c0103ebc:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103ec3:	e8 19 ce ff ff       	call   c0100ce1 <__panic>

    list_entry_t free_list_store = free_list;
c0103ec8:	a1 40 40 12 c0       	mov    0xc0124040,%eax
c0103ecd:	8b 15 44 40 12 c0    	mov    0xc0124044,%edx
c0103ed3:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103ed6:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103ed9:	c7 45 b4 40 40 12 c0 	movl   $0xc0124040,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103ee0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103ee3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ee6:	89 50 04             	mov    %edx,0x4(%eax)
c0103ee9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103eec:	8b 50 04             	mov    0x4(%eax),%edx
c0103eef:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103ef2:	89 10                	mov    %edx,(%eax)
c0103ef4:	c7 45 b0 40 40 12 c0 	movl   $0xc0124040,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103efb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103efe:	8b 40 04             	mov    0x4(%eax),%eax
c0103f01:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103f04:	0f 94 c0             	sete   %al
c0103f07:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103f0a:	85 c0                	test   %eax,%eax
c0103f0c:	75 24                	jne    c0103f32 <default_check+0x1d0>
c0103f0e:	c7 44 24 0c df 96 10 	movl   $0xc01096df,0xc(%esp)
c0103f15:	c0 
c0103f16:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103f1d:	c0 
c0103f1e:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0103f25:	00 
c0103f26:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103f2d:	e8 af cd ff ff       	call   c0100ce1 <__panic>
    assert(alloc_page() == NULL);
c0103f32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f39:	e8 e4 07 00 00       	call   c0104722 <alloc_pages>
c0103f3e:	85 c0                	test   %eax,%eax
c0103f40:	74 24                	je     c0103f66 <default_check+0x204>
c0103f42:	c7 44 24 0c f6 96 10 	movl   $0xc01096f6,0xc(%esp)
c0103f49:	c0 
c0103f4a:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103f51:	c0 
c0103f52:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0103f59:	00 
c0103f5a:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103f61:	e8 7b cd ff ff       	call   c0100ce1 <__panic>

    unsigned int nr_free_store = nr_free;
c0103f66:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c0103f6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103f6e:	c7 05 48 40 12 c0 00 	movl   $0x0,0xc0124048
c0103f75:	00 00 00 

    free_pages(p0 + 2, 3);
c0103f78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f7b:	83 c0 40             	add    $0x40,%eax
c0103f7e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103f85:	00 
c0103f86:	89 04 24             	mov    %eax,(%esp)
c0103f89:	e8 ff 07 00 00       	call   c010478d <free_pages>
    assert(alloc_pages(4) == NULL);
c0103f8e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103f95:	e8 88 07 00 00       	call   c0104722 <alloc_pages>
c0103f9a:	85 c0                	test   %eax,%eax
c0103f9c:	74 24                	je     c0103fc2 <default_check+0x260>
c0103f9e:	c7 44 24 0c 9c 97 10 	movl   $0xc010979c,0xc(%esp)
c0103fa5:	c0 
c0103fa6:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0103fad:	c0 
c0103fae:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0103fb5:	00 
c0103fb6:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0103fbd:	e8 1f cd ff ff       	call   c0100ce1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103fc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fc5:	83 c0 40             	add    $0x40,%eax
c0103fc8:	83 c0 04             	add    $0x4,%eax
c0103fcb:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103fd2:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103fd5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103fd8:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103fdb:	0f a3 10             	bt     %edx,(%eax)
c0103fde:	19 c0                	sbb    %eax,%eax
c0103fe0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103fe3:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103fe7:	0f 95 c0             	setne  %al
c0103fea:	0f b6 c0             	movzbl %al,%eax
c0103fed:	85 c0                	test   %eax,%eax
c0103fef:	74 0e                	je     c0103fff <default_check+0x29d>
c0103ff1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ff4:	83 c0 40             	add    $0x40,%eax
c0103ff7:	8b 40 08             	mov    0x8(%eax),%eax
c0103ffa:	83 f8 03             	cmp    $0x3,%eax
c0103ffd:	74 24                	je     c0104023 <default_check+0x2c1>
c0103fff:	c7 44 24 0c b4 97 10 	movl   $0xc01097b4,0xc(%esp)
c0104006:	c0 
c0104007:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c010400e:	c0 
c010400f:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104016:	00 
c0104017:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c010401e:	e8 be cc ff ff       	call   c0100ce1 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104023:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010402a:	e8 f3 06 00 00       	call   c0104722 <alloc_pages>
c010402f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104032:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104036:	75 24                	jne    c010405c <default_check+0x2fa>
c0104038:	c7 44 24 0c e0 97 10 	movl   $0xc01097e0,0xc(%esp)
c010403f:	c0 
c0104040:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0104047:	c0 
c0104048:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c010404f:	00 
c0104050:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0104057:	e8 85 cc ff ff       	call   c0100ce1 <__panic>
    assert(alloc_page() == NULL);
c010405c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104063:	e8 ba 06 00 00       	call   c0104722 <alloc_pages>
c0104068:	85 c0                	test   %eax,%eax
c010406a:	74 24                	je     c0104090 <default_check+0x32e>
c010406c:	c7 44 24 0c f6 96 10 	movl   $0xc01096f6,0xc(%esp)
c0104073:	c0 
c0104074:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c010407b:	c0 
c010407c:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0104083:	00 
c0104084:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c010408b:	e8 51 cc ff ff       	call   c0100ce1 <__panic>
    assert(p0 + 2 == p1);
c0104090:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104093:	83 c0 40             	add    $0x40,%eax
c0104096:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104099:	74 24                	je     c01040bf <default_check+0x35d>
c010409b:	c7 44 24 0c fe 97 10 	movl   $0xc01097fe,0xc(%esp)
c01040a2:	c0 
c01040a3:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c01040aa:	c0 
c01040ab:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01040b2:	00 
c01040b3:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01040ba:	e8 22 cc ff ff       	call   c0100ce1 <__panic>

    p2 = p0 + 1;
c01040bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040c2:	83 c0 20             	add    $0x20,%eax
c01040c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01040c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040cf:	00 
c01040d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040d3:	89 04 24             	mov    %eax,(%esp)
c01040d6:	e8 b2 06 00 00       	call   c010478d <free_pages>
    free_pages(p1, 3);
c01040db:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01040e2:	00 
c01040e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040e6:	89 04 24             	mov    %eax,(%esp)
c01040e9:	e8 9f 06 00 00       	call   c010478d <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01040ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040f1:	83 c0 04             	add    $0x4,%eax
c01040f4:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01040fb:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01040fe:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104101:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104104:	0f a3 10             	bt     %edx,(%eax)
c0104107:	19 c0                	sbb    %eax,%eax
c0104109:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010410c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104110:	0f 95 c0             	setne  %al
c0104113:	0f b6 c0             	movzbl %al,%eax
c0104116:	85 c0                	test   %eax,%eax
c0104118:	74 0b                	je     c0104125 <default_check+0x3c3>
c010411a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010411d:	8b 40 08             	mov    0x8(%eax),%eax
c0104120:	83 f8 01             	cmp    $0x1,%eax
c0104123:	74 24                	je     c0104149 <default_check+0x3e7>
c0104125:	c7 44 24 0c 0c 98 10 	movl   $0xc010980c,0xc(%esp)
c010412c:	c0 
c010412d:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0104134:	c0 
c0104135:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c010413c:	00 
c010413d:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0104144:	e8 98 cb ff ff       	call   c0100ce1 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104149:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010414c:	83 c0 04             	add    $0x4,%eax
c010414f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104156:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104159:	8b 45 90             	mov    -0x70(%ebp),%eax
c010415c:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010415f:	0f a3 10             	bt     %edx,(%eax)
c0104162:	19 c0                	sbb    %eax,%eax
c0104164:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104167:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010416b:	0f 95 c0             	setne  %al
c010416e:	0f b6 c0             	movzbl %al,%eax
c0104171:	85 c0                	test   %eax,%eax
c0104173:	74 0b                	je     c0104180 <default_check+0x41e>
c0104175:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104178:	8b 40 08             	mov    0x8(%eax),%eax
c010417b:	83 f8 03             	cmp    $0x3,%eax
c010417e:	74 24                	je     c01041a4 <default_check+0x442>
c0104180:	c7 44 24 0c 34 98 10 	movl   $0xc0109834,0xc(%esp)
c0104187:	c0 
c0104188:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c010418f:	c0 
c0104190:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0104197:	00 
c0104198:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c010419f:	e8 3d cb ff ff       	call   c0100ce1 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01041a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041ab:	e8 72 05 00 00       	call   c0104722 <alloc_pages>
c01041b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041b6:	83 e8 20             	sub    $0x20,%eax
c01041b9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01041bc:	74 24                	je     c01041e2 <default_check+0x480>
c01041be:	c7 44 24 0c 5a 98 10 	movl   $0xc010985a,0xc(%esp)
c01041c5:	c0 
c01041c6:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c01041cd:	c0 
c01041ce:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c01041d5:	00 
c01041d6:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01041dd:	e8 ff ca ff ff       	call   c0100ce1 <__panic>
    free_page(p0);
c01041e2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01041e9:	00 
c01041ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041ed:	89 04 24             	mov    %eax,(%esp)
c01041f0:	e8 98 05 00 00       	call   c010478d <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01041f5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01041fc:	e8 21 05 00 00       	call   c0104722 <alloc_pages>
c0104201:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104204:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104207:	83 c0 20             	add    $0x20,%eax
c010420a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010420d:	74 24                	je     c0104233 <default_check+0x4d1>
c010420f:	c7 44 24 0c 78 98 10 	movl   $0xc0109878,0xc(%esp)
c0104216:	c0 
c0104217:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c010421e:	c0 
c010421f:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104226:	00 
c0104227:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c010422e:	e8 ae ca ff ff       	call   c0100ce1 <__panic>

    free_pages(p0, 2);
c0104233:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010423a:	00 
c010423b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010423e:	89 04 24             	mov    %eax,(%esp)
c0104241:	e8 47 05 00 00       	call   c010478d <free_pages>
    free_page(p2);
c0104246:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010424d:	00 
c010424e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104251:	89 04 24             	mov    %eax,(%esp)
c0104254:	e8 34 05 00 00       	call   c010478d <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104259:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104260:	e8 bd 04 00 00       	call   c0104722 <alloc_pages>
c0104265:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104268:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010426c:	75 24                	jne    c0104292 <default_check+0x530>
c010426e:	c7 44 24 0c 98 98 10 	movl   $0xc0109898,0xc(%esp)
c0104275:	c0 
c0104276:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c010427d:	c0 
c010427e:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0104285:	00 
c0104286:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c010428d:	e8 4f ca ff ff       	call   c0100ce1 <__panic>
    assert(alloc_page() == NULL);
c0104292:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104299:	e8 84 04 00 00       	call   c0104722 <alloc_pages>
c010429e:	85 c0                	test   %eax,%eax
c01042a0:	74 24                	je     c01042c6 <default_check+0x564>
c01042a2:	c7 44 24 0c f6 96 10 	movl   $0xc01096f6,0xc(%esp)
c01042a9:	c0 
c01042aa:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c01042b1:	c0 
c01042b2:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c01042b9:	00 
c01042ba:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01042c1:	e8 1b ca ff ff       	call   c0100ce1 <__panic>

    assert(nr_free == 0);
c01042c6:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c01042cb:	85 c0                	test   %eax,%eax
c01042cd:	74 24                	je     c01042f3 <default_check+0x591>
c01042cf:	c7 44 24 0c 49 97 10 	movl   $0xc0109749,0xc(%esp)
c01042d6:	c0 
c01042d7:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c01042de:	c0 
c01042df:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c01042e6:	00 
c01042e7:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01042ee:	e8 ee c9 ff ff       	call   c0100ce1 <__panic>
    nr_free = nr_free_store;
c01042f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042f6:	a3 48 40 12 c0       	mov    %eax,0xc0124048

    free_list = free_list_store;
c01042fb:	8b 45 80             	mov    -0x80(%ebp),%eax
c01042fe:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104301:	a3 40 40 12 c0       	mov    %eax,0xc0124040
c0104306:	89 15 44 40 12 c0    	mov    %edx,0xc0124044
    free_pages(p0, 5);
c010430c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104313:	00 
c0104314:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104317:	89 04 24             	mov    %eax,(%esp)
c010431a:	e8 6e 04 00 00       	call   c010478d <free_pages>

    le = &free_list;
c010431f:	c7 45 ec 40 40 12 c0 	movl   $0xc0124040,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104326:	eb 1d                	jmp    c0104345 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104328:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010432b:	83 e8 0c             	sub    $0xc,%eax
c010432e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104331:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104335:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104338:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010433b:	8b 40 08             	mov    0x8(%eax),%eax
c010433e:	29 c2                	sub    %eax,%edx
c0104340:	89 d0                	mov    %edx,%eax
c0104342:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104345:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104348:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010434b:	8b 45 88             	mov    -0x78(%ebp),%eax
c010434e:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104351:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104354:	81 7d ec 40 40 12 c0 	cmpl   $0xc0124040,-0x14(%ebp)
c010435b:	75 cb                	jne    c0104328 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010435d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104361:	74 24                	je     c0104387 <default_check+0x625>
c0104363:	c7 44 24 0c b6 98 10 	movl   $0xc01098b6,0xc(%esp)
c010436a:	c0 
c010436b:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c0104372:	c0 
c0104373:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c010437a:	00 
c010437b:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c0104382:	e8 5a c9 ff ff       	call   c0100ce1 <__panic>
    assert(total == 0);
c0104387:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010438b:	74 24                	je     c01043b1 <default_check+0x64f>
c010438d:	c7 44 24 0c c1 98 10 	movl   $0xc01098c1,0xc(%esp)
c0104394:	c0 
c0104395:	c7 44 24 08 56 95 10 	movl   $0xc0109556,0x8(%esp)
c010439c:	c0 
c010439d:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c01043a4:	00 
c01043a5:	c7 04 24 6b 95 10 c0 	movl   $0xc010956b,(%esp)
c01043ac:	e8 30 c9 ff ff       	call   c0100ce1 <__panic>
}
c01043b1:	81 c4 94 00 00 00    	add    $0x94,%esp
c01043b7:	5b                   	pop    %ebx
c01043b8:	5d                   	pop    %ebp
c01043b9:	c3                   	ret    

c01043ba <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01043ba:	55                   	push   %ebp
c01043bb:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01043bd:	8b 55 08             	mov    0x8(%ebp),%edx
c01043c0:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c01043c5:	29 c2                	sub    %eax,%edx
c01043c7:	89 d0                	mov    %edx,%eax
c01043c9:	c1 f8 05             	sar    $0x5,%eax
}
c01043cc:	5d                   	pop    %ebp
c01043cd:	c3                   	ret    

c01043ce <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01043ce:	55                   	push   %ebp
c01043cf:	89 e5                	mov    %esp,%ebp
c01043d1:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01043d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01043d7:	89 04 24             	mov    %eax,(%esp)
c01043da:	e8 db ff ff ff       	call   c01043ba <page2ppn>
c01043df:	c1 e0 0c             	shl    $0xc,%eax
}
c01043e2:	c9                   	leave  
c01043e3:	c3                   	ret    

c01043e4 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01043e4:	55                   	push   %ebp
c01043e5:	89 e5                	mov    %esp,%ebp
c01043e7:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01043ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01043ed:	c1 e8 0c             	shr    $0xc,%eax
c01043f0:	89 c2                	mov    %eax,%edx
c01043f2:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c01043f7:	39 c2                	cmp    %eax,%edx
c01043f9:	72 1c                	jb     c0104417 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01043fb:	c7 44 24 08 fc 98 10 	movl   $0xc01098fc,0x8(%esp)
c0104402:	c0 
c0104403:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010440a:	00 
c010440b:	c7 04 24 1b 99 10 c0 	movl   $0xc010991b,(%esp)
c0104412:	e8 ca c8 ff ff       	call   c0100ce1 <__panic>
    }
    return &pages[PPN(pa)];
c0104417:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c010441c:	8b 55 08             	mov    0x8(%ebp),%edx
c010441f:	c1 ea 0c             	shr    $0xc,%edx
c0104422:	c1 e2 05             	shl    $0x5,%edx
c0104425:	01 d0                	add    %edx,%eax
}
c0104427:	c9                   	leave  
c0104428:	c3                   	ret    

c0104429 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104429:	55                   	push   %ebp
c010442a:	89 e5                	mov    %esp,%ebp
c010442c:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010442f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104432:	89 04 24             	mov    %eax,(%esp)
c0104435:	e8 94 ff ff ff       	call   c01043ce <page2pa>
c010443a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010443d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104440:	c1 e8 0c             	shr    $0xc,%eax
c0104443:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104446:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c010444b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010444e:	72 23                	jb     c0104473 <page2kva+0x4a>
c0104450:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104453:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104457:	c7 44 24 08 2c 99 10 	movl   $0xc010992c,0x8(%esp)
c010445e:	c0 
c010445f:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0104466:	00 
c0104467:	c7 04 24 1b 99 10 c0 	movl   $0xc010991b,(%esp)
c010446e:	e8 6e c8 ff ff       	call   c0100ce1 <__panic>
c0104473:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104476:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010447b:	c9                   	leave  
c010447c:	c3                   	ret    

c010447d <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010447d:	55                   	push   %ebp
c010447e:	89 e5                	mov    %esp,%ebp
c0104480:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104483:	8b 45 08             	mov    0x8(%ebp),%eax
c0104486:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104489:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104490:	77 23                	ja     c01044b5 <kva2page+0x38>
c0104492:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104495:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104499:	c7 44 24 08 50 99 10 	movl   $0xc0109950,0x8(%esp)
c01044a0:	c0 
c01044a1:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01044a8:	00 
c01044a9:	c7 04 24 1b 99 10 c0 	movl   $0xc010991b,(%esp)
c01044b0:	e8 2c c8 ff ff       	call   c0100ce1 <__panic>
c01044b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044b8:	05 00 00 00 40       	add    $0x40000000,%eax
c01044bd:	89 04 24             	mov    %eax,(%esp)
c01044c0:	e8 1f ff ff ff       	call   c01043e4 <pa2page>
}
c01044c5:	c9                   	leave  
c01044c6:	c3                   	ret    

c01044c7 <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c01044c7:	55                   	push   %ebp
c01044c8:	89 e5                	mov    %esp,%ebp
c01044ca:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01044cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d0:	83 e0 01             	and    $0x1,%eax
c01044d3:	85 c0                	test   %eax,%eax
c01044d5:	75 1c                	jne    c01044f3 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01044d7:	c7 44 24 08 74 99 10 	movl   $0xc0109974,0x8(%esp)
c01044de:	c0 
c01044df:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01044e6:	00 
c01044e7:	c7 04 24 1b 99 10 c0 	movl   $0xc010991b,(%esp)
c01044ee:	e8 ee c7 ff ff       	call   c0100ce1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01044f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01044f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01044fb:	89 04 24             	mov    %eax,(%esp)
c01044fe:	e8 e1 fe ff ff       	call   c01043e4 <pa2page>
}
c0104503:	c9                   	leave  
c0104504:	c3                   	ret    

c0104505 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0104505:	55                   	push   %ebp
c0104506:	89 e5                	mov    %esp,%ebp
c0104508:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c010450b:	8b 45 08             	mov    0x8(%ebp),%eax
c010450e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104513:	89 04 24             	mov    %eax,(%esp)
c0104516:	e8 c9 fe ff ff       	call   c01043e4 <pa2page>
}
c010451b:	c9                   	leave  
c010451c:	c3                   	ret    

c010451d <page_ref>:

static inline int
page_ref(struct Page *page) {
c010451d:	55                   	push   %ebp
c010451e:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104520:	8b 45 08             	mov    0x8(%ebp),%eax
c0104523:	8b 00                	mov    (%eax),%eax
}
c0104525:	5d                   	pop    %ebp
c0104526:	c3                   	ret    

c0104527 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104527:	55                   	push   %ebp
c0104528:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010452a:	8b 45 08             	mov    0x8(%ebp),%eax
c010452d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104530:	89 10                	mov    %edx,(%eax)
}
c0104532:	5d                   	pop    %ebp
c0104533:	c3                   	ret    

c0104534 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104534:	55                   	push   %ebp
c0104535:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104537:	8b 45 08             	mov    0x8(%ebp),%eax
c010453a:	8b 00                	mov    (%eax),%eax
c010453c:	8d 50 01             	lea    0x1(%eax),%edx
c010453f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104542:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104544:	8b 45 08             	mov    0x8(%ebp),%eax
c0104547:	8b 00                	mov    (%eax),%eax
}
c0104549:	5d                   	pop    %ebp
c010454a:	c3                   	ret    

c010454b <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c010454b:	55                   	push   %ebp
c010454c:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c010454e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104551:	8b 00                	mov    (%eax),%eax
c0104553:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104556:	8b 45 08             	mov    0x8(%ebp),%eax
c0104559:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010455b:	8b 45 08             	mov    0x8(%ebp),%eax
c010455e:	8b 00                	mov    (%eax),%eax
}
c0104560:	5d                   	pop    %ebp
c0104561:	c3                   	ret    

c0104562 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104562:	55                   	push   %ebp
c0104563:	89 e5                	mov    %esp,%ebp
c0104565:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104568:	9c                   	pushf  
c0104569:	58                   	pop    %eax
c010456a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010456d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104570:	25 00 02 00 00       	and    $0x200,%eax
c0104575:	85 c0                	test   %eax,%eax
c0104577:	74 0c                	je     c0104585 <__intr_save+0x23>
        intr_disable();
c0104579:	e8 cc d9 ff ff       	call   c0101f4a <intr_disable>
        return 1;
c010457e:	b8 01 00 00 00       	mov    $0x1,%eax
c0104583:	eb 05                	jmp    c010458a <__intr_save+0x28>
    }
    return 0;
c0104585:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010458a:	c9                   	leave  
c010458b:	c3                   	ret    

c010458c <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010458c:	55                   	push   %ebp
c010458d:	89 e5                	mov    %esp,%ebp
c010458f:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104592:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104596:	74 05                	je     c010459d <__intr_restore+0x11>
        intr_enable();
c0104598:	e8 a7 d9 ff ff       	call   c0101f44 <intr_enable>
    }
}
c010459d:	c9                   	leave  
c010459e:	c3                   	ret    

c010459f <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c010459f:	55                   	push   %ebp
c01045a0:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01045a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a5:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01045a8:	b8 23 00 00 00       	mov    $0x23,%eax
c01045ad:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01045af:	b8 23 00 00 00       	mov    $0x23,%eax
c01045b4:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01045b6:	b8 10 00 00 00       	mov    $0x10,%eax
c01045bb:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01045bd:	b8 10 00 00 00       	mov    $0x10,%eax
c01045c2:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c01045c4:	b8 10 00 00 00       	mov    $0x10,%eax
c01045c9:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c01045cb:	ea d2 45 10 c0 08 00 	ljmp   $0x8,$0xc01045d2
}
c01045d2:	5d                   	pop    %ebp
c01045d3:	c3                   	ret    

c01045d4 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c01045d4:	55                   	push   %ebp
c01045d5:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c01045d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01045da:	a3 c4 3f 12 c0       	mov    %eax,0xc0123fc4
}
c01045df:	5d                   	pop    %ebp
c01045e0:	c3                   	ret    

c01045e1 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c01045e1:	55                   	push   %ebp
c01045e2:	89 e5                	mov    %esp,%ebp
c01045e4:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c01045e7:	b8 00 00 12 c0       	mov    $0xc0120000,%eax
c01045ec:	89 04 24             	mov    %eax,(%esp)
c01045ef:	e8 e0 ff ff ff       	call   c01045d4 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c01045f4:	66 c7 05 c8 3f 12 c0 	movw   $0x10,0xc0123fc8
c01045fb:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c01045fd:	66 c7 05 28 0a 12 c0 	movw   $0x68,0xc0120a28
c0104604:	68 00 
c0104606:	b8 c0 3f 12 c0       	mov    $0xc0123fc0,%eax
c010460b:	66 a3 2a 0a 12 c0    	mov    %ax,0xc0120a2a
c0104611:	b8 c0 3f 12 c0       	mov    $0xc0123fc0,%eax
c0104616:	c1 e8 10             	shr    $0x10,%eax
c0104619:	a2 2c 0a 12 c0       	mov    %al,0xc0120a2c
c010461e:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104625:	83 e0 f0             	and    $0xfffffff0,%eax
c0104628:	83 c8 09             	or     $0x9,%eax
c010462b:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0104630:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104637:	83 e0 ef             	and    $0xffffffef,%eax
c010463a:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c010463f:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104646:	83 e0 9f             	and    $0xffffff9f,%eax
c0104649:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c010464e:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104655:	83 c8 80             	or     $0xffffff80,%eax
c0104658:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c010465d:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0104664:	83 e0 f0             	and    $0xfffffff0,%eax
c0104667:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c010466c:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0104673:	83 e0 ef             	and    $0xffffffef,%eax
c0104676:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c010467b:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0104682:	83 e0 df             	and    $0xffffffdf,%eax
c0104685:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c010468a:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0104691:	83 c8 40             	or     $0x40,%eax
c0104694:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104699:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c01046a0:	83 e0 7f             	and    $0x7f,%eax
c01046a3:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c01046a8:	b8 c0 3f 12 c0       	mov    $0xc0123fc0,%eax
c01046ad:	c1 e8 18             	shr    $0x18,%eax
c01046b0:	a2 2f 0a 12 c0       	mov    %al,0xc0120a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c01046b5:	c7 04 24 30 0a 12 c0 	movl   $0xc0120a30,(%esp)
c01046bc:	e8 de fe ff ff       	call   c010459f <lgdt>
c01046c1:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01046c7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01046cb:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01046ce:	c9                   	leave  
c01046cf:	c3                   	ret    

c01046d0 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01046d0:	55                   	push   %ebp
c01046d1:	89 e5                	mov    %esp,%ebp
c01046d3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c01046d6:	c7 05 4c 40 12 c0 e0 	movl   $0xc01098e0,0xc012404c
c01046dd:	98 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01046e0:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c01046e5:	8b 00                	mov    (%eax),%eax
c01046e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046eb:	c7 04 24 a0 99 10 c0 	movl   $0xc01099a0,(%esp)
c01046f2:	e8 60 bc ff ff       	call   c0100357 <cprintf>
    pmm_manager->init();
c01046f7:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c01046fc:	8b 40 04             	mov    0x4(%eax),%eax
c01046ff:	ff d0                	call   *%eax
}
c0104701:	c9                   	leave  
c0104702:	c3                   	ret    

c0104703 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104703:	55                   	push   %ebp
c0104704:	89 e5                	mov    %esp,%ebp
c0104706:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104709:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c010470e:	8b 40 08             	mov    0x8(%eax),%eax
c0104711:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104714:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104718:	8b 55 08             	mov    0x8(%ebp),%edx
c010471b:	89 14 24             	mov    %edx,(%esp)
c010471e:	ff d0                	call   *%eax
}
c0104720:	c9                   	leave  
c0104721:	c3                   	ret    

c0104722 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104722:	55                   	push   %ebp
c0104723:	89 e5                	mov    %esp,%ebp
c0104725:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104728:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c010472f:	e8 2e fe ff ff       	call   c0104562 <__intr_save>
c0104734:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104737:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c010473c:	8b 40 0c             	mov    0xc(%eax),%eax
c010473f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104742:	89 14 24             	mov    %edx,(%esp)
c0104745:	ff d0                	call   *%eax
c0104747:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c010474a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010474d:	89 04 24             	mov    %eax,(%esp)
c0104750:	e8 37 fe ff ff       	call   c010458c <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104755:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104759:	75 2d                	jne    c0104788 <alloc_pages+0x66>
c010475b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c010475f:	77 27                	ja     c0104788 <alloc_pages+0x66>
c0104761:	a1 2c 40 12 c0       	mov    0xc012402c,%eax
c0104766:	85 c0                	test   %eax,%eax
c0104768:	74 1e                	je     c0104788 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c010476a:	8b 55 08             	mov    0x8(%ebp),%edx
c010476d:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c0104772:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104779:	00 
c010477a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010477e:	89 04 24             	mov    %eax,(%esp)
c0104781:	e8 0f 1a 00 00       	call   c0106195 <swap_out>
    }
c0104786:	eb a7                	jmp    c010472f <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104788:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010478b:	c9                   	leave  
c010478c:	c3                   	ret    

c010478d <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c010478d:	55                   	push   %ebp
c010478e:	89 e5                	mov    %esp,%ebp
c0104790:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104793:	e8 ca fd ff ff       	call   c0104562 <__intr_save>
c0104798:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c010479b:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c01047a0:	8b 40 10             	mov    0x10(%eax),%eax
c01047a3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047a6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01047ad:	89 14 24             	mov    %edx,(%esp)
c01047b0:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01047b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047b5:	89 04 24             	mov    %eax,(%esp)
c01047b8:	e8 cf fd ff ff       	call   c010458c <__intr_restore>
}
c01047bd:	c9                   	leave  
c01047be:	c3                   	ret    

c01047bf <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01047bf:	55                   	push   %ebp
c01047c0:	89 e5                	mov    %esp,%ebp
c01047c2:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01047c5:	e8 98 fd ff ff       	call   c0104562 <__intr_save>
c01047ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01047cd:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c01047d2:	8b 40 14             	mov    0x14(%eax),%eax
c01047d5:	ff d0                	call   *%eax
c01047d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01047da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047dd:	89 04 24             	mov    %eax,(%esp)
c01047e0:	e8 a7 fd ff ff       	call   c010458c <__intr_restore>
    return ret;
c01047e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01047e8:	c9                   	leave  
c01047e9:	c3                   	ret    

c01047ea <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01047ea:	55                   	push   %ebp
c01047eb:	89 e5                	mov    %esp,%ebp
c01047ed:	57                   	push   %edi
c01047ee:	56                   	push   %esi
c01047ef:	53                   	push   %ebx
c01047f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01047f6:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01047fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104804:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c010480b:	c7 04 24 b7 99 10 c0 	movl   $0xc01099b7,(%esp)
c0104812:	e8 40 bb ff ff       	call   c0100357 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104817:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010481e:	e9 15 01 00 00       	jmp    c0104938 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104823:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104826:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104829:	89 d0                	mov    %edx,%eax
c010482b:	c1 e0 02             	shl    $0x2,%eax
c010482e:	01 d0                	add    %edx,%eax
c0104830:	c1 e0 02             	shl    $0x2,%eax
c0104833:	01 c8                	add    %ecx,%eax
c0104835:	8b 50 08             	mov    0x8(%eax),%edx
c0104838:	8b 40 04             	mov    0x4(%eax),%eax
c010483b:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010483e:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104841:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104844:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104847:	89 d0                	mov    %edx,%eax
c0104849:	c1 e0 02             	shl    $0x2,%eax
c010484c:	01 d0                	add    %edx,%eax
c010484e:	c1 e0 02             	shl    $0x2,%eax
c0104851:	01 c8                	add    %ecx,%eax
c0104853:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104856:	8b 58 10             	mov    0x10(%eax),%ebx
c0104859:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010485c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010485f:	01 c8                	add    %ecx,%eax
c0104861:	11 da                	adc    %ebx,%edx
c0104863:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104866:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104869:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010486c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010486f:	89 d0                	mov    %edx,%eax
c0104871:	c1 e0 02             	shl    $0x2,%eax
c0104874:	01 d0                	add    %edx,%eax
c0104876:	c1 e0 02             	shl    $0x2,%eax
c0104879:	01 c8                	add    %ecx,%eax
c010487b:	83 c0 14             	add    $0x14,%eax
c010487e:	8b 00                	mov    (%eax),%eax
c0104880:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104886:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104889:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010488c:	83 c0 ff             	add    $0xffffffff,%eax
c010488f:	83 d2 ff             	adc    $0xffffffff,%edx
c0104892:	89 c6                	mov    %eax,%esi
c0104894:	89 d7                	mov    %edx,%edi
c0104896:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104899:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010489c:	89 d0                	mov    %edx,%eax
c010489e:	c1 e0 02             	shl    $0x2,%eax
c01048a1:	01 d0                	add    %edx,%eax
c01048a3:	c1 e0 02             	shl    $0x2,%eax
c01048a6:	01 c8                	add    %ecx,%eax
c01048a8:	8b 48 0c             	mov    0xc(%eax),%ecx
c01048ab:	8b 58 10             	mov    0x10(%eax),%ebx
c01048ae:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01048b4:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01048b8:	89 74 24 14          	mov    %esi,0x14(%esp)
c01048bc:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01048c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01048c3:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01048c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048ca:	89 54 24 10          	mov    %edx,0x10(%esp)
c01048ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01048d2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01048d6:	c7 04 24 c4 99 10 c0 	movl   $0xc01099c4,(%esp)
c01048dd:	e8 75 ba ff ff       	call   c0100357 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01048e2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01048e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048e8:	89 d0                	mov    %edx,%eax
c01048ea:	c1 e0 02             	shl    $0x2,%eax
c01048ed:	01 d0                	add    %edx,%eax
c01048ef:	c1 e0 02             	shl    $0x2,%eax
c01048f2:	01 c8                	add    %ecx,%eax
c01048f4:	83 c0 14             	add    $0x14,%eax
c01048f7:	8b 00                	mov    (%eax),%eax
c01048f9:	83 f8 01             	cmp    $0x1,%eax
c01048fc:	75 36                	jne    c0104934 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c01048fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104901:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104904:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104907:	77 2b                	ja     c0104934 <page_init+0x14a>
c0104909:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010490c:	72 05                	jb     c0104913 <page_init+0x129>
c010490e:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104911:	73 21                	jae    c0104934 <page_init+0x14a>
c0104913:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104917:	77 1b                	ja     c0104934 <page_init+0x14a>
c0104919:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010491d:	72 09                	jb     c0104928 <page_init+0x13e>
c010491f:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104926:	77 0c                	ja     c0104934 <page_init+0x14a>
                maxpa = end;
c0104928:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010492b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010492e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104931:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104934:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104938:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010493b:	8b 00                	mov    (%eax),%eax
c010493d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104940:	0f 8f dd fe ff ff    	jg     c0104823 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104946:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010494a:	72 1d                	jb     c0104969 <page_init+0x17f>
c010494c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104950:	77 09                	ja     c010495b <page_init+0x171>
c0104952:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104959:	76 0e                	jbe    c0104969 <page_init+0x17f>
        maxpa = KMEMSIZE;
c010495b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104962:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104969:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010496c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010496f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104973:	c1 ea 0c             	shr    $0xc,%edx
c0104976:	a3 a0 3f 12 c0       	mov    %eax,0xc0123fa0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010497b:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104982:	b8 30 41 12 c0       	mov    $0xc0124130,%eax
c0104987:	8d 50 ff             	lea    -0x1(%eax),%edx
c010498a:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010498d:	01 d0                	add    %edx,%eax
c010498f:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104992:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104995:	ba 00 00 00 00       	mov    $0x0,%edx
c010499a:	f7 75 ac             	divl   -0x54(%ebp)
c010499d:	89 d0                	mov    %edx,%eax
c010499f:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01049a2:	29 c2                	sub    %eax,%edx
c01049a4:	89 d0                	mov    %edx,%eax
c01049a6:	a3 54 40 12 c0       	mov    %eax,0xc0124054

    for (i = 0; i < npage; i ++) {
c01049ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01049b2:	eb 27                	jmp    c01049db <page_init+0x1f1>
        SetPageReserved(pages + i);
c01049b4:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c01049b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049bc:	c1 e2 05             	shl    $0x5,%edx
c01049bf:	01 d0                	add    %edx,%eax
c01049c1:	83 c0 04             	add    $0x4,%eax
c01049c4:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01049cb:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01049ce:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01049d1:	8b 55 90             	mov    -0x70(%ebp),%edx
c01049d4:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01049d7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01049db:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049de:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c01049e3:	39 c2                	cmp    %eax,%edx
c01049e5:	72 cd                	jb     c01049b4 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01049e7:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c01049ec:	c1 e0 05             	shl    $0x5,%eax
c01049ef:	89 c2                	mov    %eax,%edx
c01049f1:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c01049f6:	01 d0                	add    %edx,%eax
c01049f8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01049fb:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104a02:	77 23                	ja     c0104a27 <page_init+0x23d>
c0104a04:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104a07:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a0b:	c7 44 24 08 50 99 10 	movl   $0xc0109950,0x8(%esp)
c0104a12:	c0 
c0104a13:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0104a1a:	00 
c0104a1b:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0104a22:	e8 ba c2 ff ff       	call   c0100ce1 <__panic>
c0104a27:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104a2a:	05 00 00 00 40       	add    $0x40000000,%eax
c0104a2f:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104a32:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104a39:	e9 74 01 00 00       	jmp    c0104bb2 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104a3e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a41:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a44:	89 d0                	mov    %edx,%eax
c0104a46:	c1 e0 02             	shl    $0x2,%eax
c0104a49:	01 d0                	add    %edx,%eax
c0104a4b:	c1 e0 02             	shl    $0x2,%eax
c0104a4e:	01 c8                	add    %ecx,%eax
c0104a50:	8b 50 08             	mov    0x8(%eax),%edx
c0104a53:	8b 40 04             	mov    0x4(%eax),%eax
c0104a56:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a59:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104a5c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a5f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a62:	89 d0                	mov    %edx,%eax
c0104a64:	c1 e0 02             	shl    $0x2,%eax
c0104a67:	01 d0                	add    %edx,%eax
c0104a69:	c1 e0 02             	shl    $0x2,%eax
c0104a6c:	01 c8                	add    %ecx,%eax
c0104a6e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104a71:	8b 58 10             	mov    0x10(%eax),%ebx
c0104a74:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a77:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a7a:	01 c8                	add    %ecx,%eax
c0104a7c:	11 da                	adc    %ebx,%edx
c0104a7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104a81:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104a84:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a87:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a8a:	89 d0                	mov    %edx,%eax
c0104a8c:	c1 e0 02             	shl    $0x2,%eax
c0104a8f:	01 d0                	add    %edx,%eax
c0104a91:	c1 e0 02             	shl    $0x2,%eax
c0104a94:	01 c8                	add    %ecx,%eax
c0104a96:	83 c0 14             	add    $0x14,%eax
c0104a99:	8b 00                	mov    (%eax),%eax
c0104a9b:	83 f8 01             	cmp    $0x1,%eax
c0104a9e:	0f 85 0a 01 00 00    	jne    c0104bae <page_init+0x3c4>
            if (begin < freemem) {
c0104aa4:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104aa7:	ba 00 00 00 00       	mov    $0x0,%edx
c0104aac:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104aaf:	72 17                	jb     c0104ac8 <page_init+0x2de>
c0104ab1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104ab4:	77 05                	ja     c0104abb <page_init+0x2d1>
c0104ab6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104ab9:	76 0d                	jbe    c0104ac8 <page_init+0x2de>
                begin = freemem;
c0104abb:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104abe:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104ac1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104ac8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104acc:	72 1d                	jb     c0104aeb <page_init+0x301>
c0104ace:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104ad2:	77 09                	ja     c0104add <page_init+0x2f3>
c0104ad4:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104adb:	76 0e                	jbe    c0104aeb <page_init+0x301>
                end = KMEMSIZE;
c0104add:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104ae4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104aeb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104aee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104af1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104af4:	0f 87 b4 00 00 00    	ja     c0104bae <page_init+0x3c4>
c0104afa:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104afd:	72 09                	jb     c0104b08 <page_init+0x31e>
c0104aff:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104b02:	0f 83 a6 00 00 00    	jae    c0104bae <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0104b08:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104b0f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104b12:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104b15:	01 d0                	add    %edx,%eax
c0104b17:	83 e8 01             	sub    $0x1,%eax
c0104b1a:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104b1d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104b20:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b25:	f7 75 9c             	divl   -0x64(%ebp)
c0104b28:	89 d0                	mov    %edx,%eax
c0104b2a:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104b2d:	29 c2                	sub    %eax,%edx
c0104b2f:	89 d0                	mov    %edx,%eax
c0104b31:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b36:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104b39:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104b3c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104b3f:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104b42:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104b45:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b4a:	89 c7                	mov    %eax,%edi
c0104b4c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104b52:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104b55:	89 d0                	mov    %edx,%eax
c0104b57:	83 e0 00             	and    $0x0,%eax
c0104b5a:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104b5d:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104b60:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104b63:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104b66:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104b69:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b6c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104b6f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104b72:	77 3a                	ja     c0104bae <page_init+0x3c4>
c0104b74:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104b77:	72 05                	jb     c0104b7e <page_init+0x394>
c0104b79:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104b7c:	73 30                	jae    c0104bae <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104b7e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104b81:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104b84:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104b87:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104b8a:	29 c8                	sub    %ecx,%eax
c0104b8c:	19 da                	sbb    %ebx,%edx
c0104b8e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104b92:	c1 ea 0c             	shr    $0xc,%edx
c0104b95:	89 c3                	mov    %eax,%ebx
c0104b97:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b9a:	89 04 24             	mov    %eax,(%esp)
c0104b9d:	e8 42 f8 ff ff       	call   c01043e4 <pa2page>
c0104ba2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104ba6:	89 04 24             	mov    %eax,(%esp)
c0104ba9:	e8 55 fb ff ff       	call   c0104703 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104bae:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104bb2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104bb5:	8b 00                	mov    (%eax),%eax
c0104bb7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104bba:	0f 8f 7e fe ff ff    	jg     c0104a3e <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104bc0:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104bc6:	5b                   	pop    %ebx
c0104bc7:	5e                   	pop    %esi
c0104bc8:	5f                   	pop    %edi
c0104bc9:	5d                   	pop    %ebp
c0104bca:	c3                   	ret    

c0104bcb <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104bcb:	55                   	push   %ebp
c0104bcc:	89 e5                	mov    %esp,%ebp
c0104bce:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104bd1:	8b 45 14             	mov    0x14(%ebp),%eax
c0104bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104bd7:	31 d0                	xor    %edx,%eax
c0104bd9:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104bde:	85 c0                	test   %eax,%eax
c0104be0:	74 24                	je     c0104c06 <boot_map_segment+0x3b>
c0104be2:	c7 44 24 0c 02 9a 10 	movl   $0xc0109a02,0xc(%esp)
c0104be9:	c0 
c0104bea:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0104bf1:	c0 
c0104bf2:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0104bf9:	00 
c0104bfa:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0104c01:	e8 db c0 ff ff       	call   c0100ce1 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104c06:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c10:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104c15:	89 c2                	mov    %eax,%edx
c0104c17:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c1a:	01 c2                	add    %eax,%edx
c0104c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c1f:	01 d0                	add    %edx,%eax
c0104c21:	83 e8 01             	sub    $0x1,%eax
c0104c24:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c2a:	ba 00 00 00 00       	mov    $0x0,%edx
c0104c2f:	f7 75 f0             	divl   -0x10(%ebp)
c0104c32:	89 d0                	mov    %edx,%eax
c0104c34:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104c37:	29 c2                	sub    %eax,%edx
c0104c39:	89 d0                	mov    %edx,%eax
c0104c3b:	c1 e8 0c             	shr    $0xc,%eax
c0104c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104c41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c44:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104c47:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c4a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c4f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104c52:	8b 45 14             	mov    0x14(%ebp),%eax
c0104c55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c60:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104c63:	eb 6b                	jmp    c0104cd0 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104c65:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104c6c:	00 
c0104c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c70:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104c74:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c77:	89 04 24             	mov    %eax,(%esp)
c0104c7a:	e8 82 01 00 00       	call   c0104e01 <get_pte>
c0104c7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104c82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104c86:	75 24                	jne    c0104cac <boot_map_segment+0xe1>
c0104c88:	c7 44 24 0c 2e 9a 10 	movl   $0xc0109a2e,0xc(%esp)
c0104c8f:	c0 
c0104c90:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0104c97:	c0 
c0104c98:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0104c9f:	00 
c0104ca0:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0104ca7:	e8 35 c0 ff ff       	call   c0100ce1 <__panic>
        *ptep = pa | PTE_P | perm;
c0104cac:	8b 45 18             	mov    0x18(%ebp),%eax
c0104caf:	8b 55 14             	mov    0x14(%ebp),%edx
c0104cb2:	09 d0                	or     %edx,%eax
c0104cb4:	83 c8 01             	or     $0x1,%eax
c0104cb7:	89 c2                	mov    %eax,%edx
c0104cb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104cbc:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104cbe:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104cc2:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104cc9:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104cd4:	75 8f                	jne    c0104c65 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104cd6:	c9                   	leave  
c0104cd7:	c3                   	ret    

c0104cd8 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104cd8:	55                   	push   %ebp
c0104cd9:	89 e5                	mov    %esp,%ebp
c0104cdb:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104cde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ce5:	e8 38 fa ff ff       	call   c0104722 <alloc_pages>
c0104cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104ced:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104cf1:	75 1c                	jne    c0104d0f <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104cf3:	c7 44 24 08 3b 9a 10 	movl   $0xc0109a3b,0x8(%esp)
c0104cfa:	c0 
c0104cfb:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0104d02:	00 
c0104d03:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0104d0a:	e8 d2 bf ff ff       	call   c0100ce1 <__panic>
    }
    return page2kva(p);
c0104d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d12:	89 04 24             	mov    %eax,(%esp)
c0104d15:	e8 0f f7 ff ff       	call   c0104429 <page2kva>
}
c0104d1a:	c9                   	leave  
c0104d1b:	c3                   	ret    

c0104d1c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104d1c:	55                   	push   %ebp
c0104d1d:	89 e5                	mov    %esp,%ebp
c0104d1f:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104d22:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104d27:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d2a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104d31:	77 23                	ja     c0104d56 <pmm_init+0x3a>
c0104d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d36:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d3a:	c7 44 24 08 50 99 10 	movl   $0xc0109950,0x8(%esp)
c0104d41:	c0 
c0104d42:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104d49:	00 
c0104d4a:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0104d51:	e8 8b bf ff ff       	call   c0100ce1 <__panic>
c0104d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d59:	05 00 00 00 40       	add    $0x40000000,%eax
c0104d5e:	a3 50 40 12 c0       	mov    %eax,0xc0124050
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104d63:	e8 68 f9 ff ff       	call   c01046d0 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104d68:	e8 7d fa ff ff       	call   c01047ea <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104d6d:	e8 a6 04 00 00       	call   c0105218 <check_alloc_page>

    check_pgdir();
c0104d72:	e8 bf 04 00 00       	call   c0105236 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104d77:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104d7c:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104d82:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104d87:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d8a:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104d91:	77 23                	ja     c0104db6 <pmm_init+0x9a>
c0104d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d96:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d9a:	c7 44 24 08 50 99 10 	movl   $0xc0109950,0x8(%esp)
c0104da1:	c0 
c0104da2:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0104da9:	00 
c0104daa:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0104db1:	e8 2b bf ff ff       	call   c0100ce1 <__panic>
c0104db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104db9:	05 00 00 00 40       	add    $0x40000000,%eax
c0104dbe:	83 c8 03             	or     $0x3,%eax
c0104dc1:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104dc3:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104dc8:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104dcf:	00 
c0104dd0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104dd7:	00 
c0104dd8:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104ddf:	38 
c0104de0:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104de7:	c0 
c0104de8:	89 04 24             	mov    %eax,(%esp)
c0104deb:	e8 db fd ff ff       	call   c0104bcb <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104df0:	e8 ec f7 ff ff       	call   c01045e1 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104df5:	e8 d7 0a 00 00       	call   c01058d1 <check_boot_pgdir>

    print_pgdir();
c0104dfa:	e8 5f 0f 00 00       	call   c0105d5e <print_pgdir>

}
c0104dff:	c9                   	leave  
c0104e00:	c3                   	ret    

c0104e01 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104e01:	55                   	push   %ebp
c0104e02:	89 e5                	mov    %esp,%ebp
c0104e04:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0104e07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104e0a:	c1 e8 16             	shr    $0x16,%eax
c0104e0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104e14:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e17:	01 d0                	add    %edx,%eax
c0104e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0104e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e1f:	8b 00                	mov    (%eax),%eax
c0104e21:	83 e0 01             	and    $0x1,%eax
c0104e24:	85 c0                	test   %eax,%eax
c0104e26:	0f 85 af 00 00 00    	jne    c0104edb <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c0104e2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104e30:	74 15                	je     c0104e47 <get_pte+0x46>
c0104e32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e39:	e8 e4 f8 ff ff       	call   c0104722 <alloc_pages>
c0104e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e45:	75 0a                	jne    c0104e51 <get_pte+0x50>
            return NULL;
c0104e47:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e4c:	e9 e6 00 00 00       	jmp    c0104f37 <get_pte+0x136>
        }
        set_page_ref(page, 1);
c0104e51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e58:	00 
c0104e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e5c:	89 04 24             	mov    %eax,(%esp)
c0104e5f:	e8 c3 f6 ff ff       	call   c0104527 <set_page_ref>
        uintptr_t pa = page2pa(page);
c0104e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e67:	89 04 24             	mov    %eax,(%esp)
c0104e6a:	e8 5f f5 ff ff       	call   c01043ce <page2pa>
c0104e6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0104e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e75:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e78:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e7b:	c1 e8 0c             	shr    $0xc,%eax
c0104e7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e81:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0104e86:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104e89:	72 23                	jb     c0104eae <get_pte+0xad>
c0104e8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e92:	c7 44 24 08 2c 99 10 	movl   $0xc010992c,0x8(%esp)
c0104e99:	c0 
c0104e9a:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
c0104ea1:	00 
c0104ea2:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0104ea9:	e8 33 be ff ff       	call   c0100ce1 <__panic>
c0104eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104eb1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104eb6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104ebd:	00 
c0104ebe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ec5:	00 
c0104ec6:	89 04 24             	mov    %eax,(%esp)
c0104ec9:	e8 5f 3c 00 00       	call   c0108b2d <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0104ece:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ed1:	83 c8 07             	or     $0x7,%eax
c0104ed4:	89 c2                	mov    %eax,%edx
c0104ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed9:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ede:	8b 00                	mov    (%eax),%eax
c0104ee0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ee5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104ee8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104eeb:	c1 e8 0c             	shr    $0xc,%eax
c0104eee:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104ef1:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0104ef6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104ef9:	72 23                	jb     c0104f1e <get_pte+0x11d>
c0104efb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104efe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f02:	c7 44 24 08 2c 99 10 	movl   $0xc010992c,0x8(%esp)
c0104f09:	c0 
c0104f0a:	c7 44 24 04 82 01 00 	movl   $0x182,0x4(%esp)
c0104f11:	00 
c0104f12:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0104f19:	e8 c3 bd ff ff       	call   c0100ce1 <__panic>
c0104f1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f21:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104f26:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104f29:	c1 ea 0c             	shr    $0xc,%edx
c0104f2c:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104f32:	c1 e2 02             	shl    $0x2,%edx
c0104f35:	01 d0                	add    %edx,%eax
}
c0104f37:	c9                   	leave  
c0104f38:	c3                   	ret    

c0104f39 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104f39:	55                   	push   %ebp
c0104f3a:	89 e5                	mov    %esp,%ebp
c0104f3c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104f3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f46:	00 
c0104f47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f51:	89 04 24             	mov    %eax,(%esp)
c0104f54:	e8 a8 fe ff ff       	call   c0104e01 <get_pte>
c0104f59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104f5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104f60:	74 08                	je     c0104f6a <get_page+0x31>
        *ptep_store = ptep;
c0104f62:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f68:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104f6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f6e:	74 1b                	je     c0104f8b <get_page+0x52>
c0104f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f73:	8b 00                	mov    (%eax),%eax
c0104f75:	83 e0 01             	and    $0x1,%eax
c0104f78:	85 c0                	test   %eax,%eax
c0104f7a:	74 0f                	je     c0104f8b <get_page+0x52>
        return pte2page(*ptep);
c0104f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f7f:	8b 00                	mov    (%eax),%eax
c0104f81:	89 04 24             	mov    %eax,(%esp)
c0104f84:	e8 3e f5 ff ff       	call   c01044c7 <pte2page>
c0104f89:	eb 05                	jmp    c0104f90 <get_page+0x57>
    }
    return NULL;
c0104f8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104f90:	c9                   	leave  
c0104f91:	c3                   	ret    

c0104f92 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104f92:	55                   	push   %ebp
c0104f93:	89 e5                	mov    %esp,%ebp
c0104f95:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0104f98:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f9b:	8b 00                	mov    (%eax),%eax
c0104f9d:	83 e0 01             	and    $0x1,%eax
c0104fa0:	85 c0                	test   %eax,%eax
c0104fa2:	74 4d                	je     c0104ff1 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c0104fa4:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fa7:	8b 00                	mov    (%eax),%eax
c0104fa9:	89 04 24             	mov    %eax,(%esp)
c0104fac:	e8 16 f5 ff ff       	call   c01044c7 <pte2page>
c0104fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0104fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fb7:	89 04 24             	mov    %eax,(%esp)
c0104fba:	e8 8c f5 ff ff       	call   c010454b <page_ref_dec>
c0104fbf:	85 c0                	test   %eax,%eax
c0104fc1:	75 13                	jne    c0104fd6 <page_remove_pte+0x44>
            free_page(page);
c0104fc3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fca:	00 
c0104fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fce:	89 04 24             	mov    %eax,(%esp)
c0104fd1:	e8 b7 f7 ff ff       	call   c010478d <free_pages>
        }
        *ptep = 0;
c0104fd6:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0104fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fe2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fe6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fe9:	89 04 24             	mov    %eax,(%esp)
c0104fec:	e8 ff 00 00 00       	call   c01050f0 <tlb_invalidate>
    }
}
c0104ff1:	c9                   	leave  
c0104ff2:	c3                   	ret    

c0104ff3 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104ff3:	55                   	push   %ebp
c0104ff4:	89 e5                	mov    %esp,%ebp
c0104ff6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104ff9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105000:	00 
c0105001:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105004:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105008:	8b 45 08             	mov    0x8(%ebp),%eax
c010500b:	89 04 24             	mov    %eax,(%esp)
c010500e:	e8 ee fd ff ff       	call   c0104e01 <get_pte>
c0105013:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105016:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010501a:	74 19                	je     c0105035 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010501c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010501f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105023:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105026:	89 44 24 04          	mov    %eax,0x4(%esp)
c010502a:	8b 45 08             	mov    0x8(%ebp),%eax
c010502d:	89 04 24             	mov    %eax,(%esp)
c0105030:	e8 5d ff ff ff       	call   c0104f92 <page_remove_pte>
    }
}
c0105035:	c9                   	leave  
c0105036:	c3                   	ret    

c0105037 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105037:	55                   	push   %ebp
c0105038:	89 e5                	mov    %esp,%ebp
c010503a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010503d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105044:	00 
c0105045:	8b 45 10             	mov    0x10(%ebp),%eax
c0105048:	89 44 24 04          	mov    %eax,0x4(%esp)
c010504c:	8b 45 08             	mov    0x8(%ebp),%eax
c010504f:	89 04 24             	mov    %eax,(%esp)
c0105052:	e8 aa fd ff ff       	call   c0104e01 <get_pte>
c0105057:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010505a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010505e:	75 0a                	jne    c010506a <page_insert+0x33>
        return -E_NO_MEM;
c0105060:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105065:	e9 84 00 00 00       	jmp    c01050ee <page_insert+0xb7>
    }
    page_ref_inc(page);
c010506a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010506d:	89 04 24             	mov    %eax,(%esp)
c0105070:	e8 bf f4 ff ff       	call   c0104534 <page_ref_inc>
    if (*ptep & PTE_P) {
c0105075:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105078:	8b 00                	mov    (%eax),%eax
c010507a:	83 e0 01             	and    $0x1,%eax
c010507d:	85 c0                	test   %eax,%eax
c010507f:	74 3e                	je     c01050bf <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105081:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105084:	8b 00                	mov    (%eax),%eax
c0105086:	89 04 24             	mov    %eax,(%esp)
c0105089:	e8 39 f4 ff ff       	call   c01044c7 <pte2page>
c010508e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105091:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105094:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105097:	75 0d                	jne    c01050a6 <page_insert+0x6f>
            page_ref_dec(page);
c0105099:	8b 45 0c             	mov    0xc(%ebp),%eax
c010509c:	89 04 24             	mov    %eax,(%esp)
c010509f:	e8 a7 f4 ff ff       	call   c010454b <page_ref_dec>
c01050a4:	eb 19                	jmp    c01050bf <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01050a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050a9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01050ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01050b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01050b7:	89 04 24             	mov    %eax,(%esp)
c01050ba:	e8 d3 fe ff ff       	call   c0104f92 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01050bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050c2:	89 04 24             	mov    %eax,(%esp)
c01050c5:	e8 04 f3 ff ff       	call   c01043ce <page2pa>
c01050ca:	0b 45 14             	or     0x14(%ebp),%eax
c01050cd:	83 c8 01             	or     $0x1,%eax
c01050d0:	89 c2                	mov    %eax,%edx
c01050d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050d5:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01050d7:	8b 45 10             	mov    0x10(%ebp),%eax
c01050da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050de:	8b 45 08             	mov    0x8(%ebp),%eax
c01050e1:	89 04 24             	mov    %eax,(%esp)
c01050e4:	e8 07 00 00 00       	call   c01050f0 <tlb_invalidate>
    return 0;
c01050e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01050ee:	c9                   	leave  
c01050ef:	c3                   	ret    

c01050f0 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01050f0:	55                   	push   %ebp
c01050f1:	89 e5                	mov    %esp,%ebp
c01050f3:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01050f6:	0f 20 d8             	mov    %cr3,%eax
c01050f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01050fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01050ff:	89 c2                	mov    %eax,%edx
c0105101:	8b 45 08             	mov    0x8(%ebp),%eax
c0105104:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105107:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010510e:	77 23                	ja     c0105133 <tlb_invalidate+0x43>
c0105110:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105113:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105117:	c7 44 24 08 50 99 10 	movl   $0xc0109950,0x8(%esp)
c010511e:	c0 
c010511f:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0105126:	00 
c0105127:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c010512e:	e8 ae bb ff ff       	call   c0100ce1 <__panic>
c0105133:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105136:	05 00 00 00 40       	add    $0x40000000,%eax
c010513b:	39 c2                	cmp    %eax,%edx
c010513d:	75 0c                	jne    c010514b <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010513f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105142:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105145:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105148:	0f 01 38             	invlpg (%eax)
    }
}
c010514b:	c9                   	leave  
c010514c:	c3                   	ret    

c010514d <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c010514d:	55                   	push   %ebp
c010514e:	89 e5                	mov    %esp,%ebp
c0105150:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105153:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010515a:	e8 c3 f5 ff ff       	call   c0104722 <alloc_pages>
c010515f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105162:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105166:	0f 84 a7 00 00 00    	je     c0105213 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c010516c:	8b 45 10             	mov    0x10(%ebp),%eax
c010516f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105173:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105176:	89 44 24 08          	mov    %eax,0x8(%esp)
c010517a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010517d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105181:	8b 45 08             	mov    0x8(%ebp),%eax
c0105184:	89 04 24             	mov    %eax,(%esp)
c0105187:	e8 ab fe ff ff       	call   c0105037 <page_insert>
c010518c:	85 c0                	test   %eax,%eax
c010518e:	74 1a                	je     c01051aa <pgdir_alloc_page+0x5d>
            free_page(page);
c0105190:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105197:	00 
c0105198:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010519b:	89 04 24             	mov    %eax,(%esp)
c010519e:	e8 ea f5 ff ff       	call   c010478d <free_pages>
            return NULL;
c01051a3:	b8 00 00 00 00       	mov    $0x0,%eax
c01051a8:	eb 6c                	jmp    c0105216 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c01051aa:	a1 2c 40 12 c0       	mov    0xc012402c,%eax
c01051af:	85 c0                	test   %eax,%eax
c01051b1:	74 60                	je     c0105213 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c01051b3:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c01051b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01051bf:	00 
c01051c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01051c3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01051c7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01051ca:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051ce:	89 04 24             	mov    %eax,(%esp)
c01051d1:	e8 73 0f 00 00       	call   c0106149 <swap_map_swappable>
            page->pra_vaddr=la;
c01051d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051d9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01051dc:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01051df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051e2:	89 04 24             	mov    %eax,(%esp)
c01051e5:	e8 33 f3 ff ff       	call   c010451d <page_ref>
c01051ea:	83 f8 01             	cmp    $0x1,%eax
c01051ed:	74 24                	je     c0105213 <pgdir_alloc_page+0xc6>
c01051ef:	c7 44 24 0c 54 9a 10 	movl   $0xc0109a54,0xc(%esp)
c01051f6:	c0 
c01051f7:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c01051fe:	c0 
c01051ff:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0105206:	00 
c0105207:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c010520e:	e8 ce ba ff ff       	call   c0100ce1 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0105213:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105216:	c9                   	leave  
c0105217:	c3                   	ret    

c0105218 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105218:	55                   	push   %ebp
c0105219:	89 e5                	mov    %esp,%ebp
c010521b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010521e:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c0105223:	8b 40 18             	mov    0x18(%eax),%eax
c0105226:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105228:	c7 04 24 68 9a 10 c0 	movl   $0xc0109a68,(%esp)
c010522f:	e8 23 b1 ff ff       	call   c0100357 <cprintf>
}
c0105234:	c9                   	leave  
c0105235:	c3                   	ret    

c0105236 <check_pgdir>:

static void
check_pgdir(void) {
c0105236:	55                   	push   %ebp
c0105237:	89 e5                	mov    %esp,%ebp
c0105239:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010523c:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0105241:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105246:	76 24                	jbe    c010526c <check_pgdir+0x36>
c0105248:	c7 44 24 0c 87 9a 10 	movl   $0xc0109a87,0xc(%esp)
c010524f:	c0 
c0105250:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105257:	c0 
c0105258:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c010525f:	00 
c0105260:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105267:	e8 75 ba ff ff       	call   c0100ce1 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010526c:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105271:	85 c0                	test   %eax,%eax
c0105273:	74 0e                	je     c0105283 <check_pgdir+0x4d>
c0105275:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010527a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010527f:	85 c0                	test   %eax,%eax
c0105281:	74 24                	je     c01052a7 <check_pgdir+0x71>
c0105283:	c7 44 24 0c a4 9a 10 	movl   $0xc0109aa4,0xc(%esp)
c010528a:	c0 
c010528b:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105292:	c0 
c0105293:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c010529a:	00 
c010529b:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01052a2:	e8 3a ba ff ff       	call   c0100ce1 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01052a7:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01052ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01052b3:	00 
c01052b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01052bb:	00 
c01052bc:	89 04 24             	mov    %eax,(%esp)
c01052bf:	e8 75 fc ff ff       	call   c0104f39 <get_page>
c01052c4:	85 c0                	test   %eax,%eax
c01052c6:	74 24                	je     c01052ec <check_pgdir+0xb6>
c01052c8:	c7 44 24 0c dc 9a 10 	movl   $0xc0109adc,0xc(%esp)
c01052cf:	c0 
c01052d0:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c01052d7:	c0 
c01052d8:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c01052df:	00 
c01052e0:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01052e7:	e8 f5 b9 ff ff       	call   c0100ce1 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01052ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052f3:	e8 2a f4 ff ff       	call   c0104722 <alloc_pages>
c01052f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01052fb:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105300:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105307:	00 
c0105308:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010530f:	00 
c0105310:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105313:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105317:	89 04 24             	mov    %eax,(%esp)
c010531a:	e8 18 fd ff ff       	call   c0105037 <page_insert>
c010531f:	85 c0                	test   %eax,%eax
c0105321:	74 24                	je     c0105347 <check_pgdir+0x111>
c0105323:	c7 44 24 0c 04 9b 10 	movl   $0xc0109b04,0xc(%esp)
c010532a:	c0 
c010532b:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105332:	c0 
c0105333:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c010533a:	00 
c010533b:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105342:	e8 9a b9 ff ff       	call   c0100ce1 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105347:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010534c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105353:	00 
c0105354:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010535b:	00 
c010535c:	89 04 24             	mov    %eax,(%esp)
c010535f:	e8 9d fa ff ff       	call   c0104e01 <get_pte>
c0105364:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105367:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010536b:	75 24                	jne    c0105391 <check_pgdir+0x15b>
c010536d:	c7 44 24 0c 30 9b 10 	movl   $0xc0109b30,0xc(%esp)
c0105374:	c0 
c0105375:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c010537c:	c0 
c010537d:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0105384:	00 
c0105385:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c010538c:	e8 50 b9 ff ff       	call   c0100ce1 <__panic>
    assert(pte2page(*ptep) == p1);
c0105391:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105394:	8b 00                	mov    (%eax),%eax
c0105396:	89 04 24             	mov    %eax,(%esp)
c0105399:	e8 29 f1 ff ff       	call   c01044c7 <pte2page>
c010539e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01053a1:	74 24                	je     c01053c7 <check_pgdir+0x191>
c01053a3:	c7 44 24 0c 5d 9b 10 	movl   $0xc0109b5d,0xc(%esp)
c01053aa:	c0 
c01053ab:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c01053b2:	c0 
c01053b3:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c01053ba:	00 
c01053bb:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01053c2:	e8 1a b9 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p1) == 1);
c01053c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053ca:	89 04 24             	mov    %eax,(%esp)
c01053cd:	e8 4b f1 ff ff       	call   c010451d <page_ref>
c01053d2:	83 f8 01             	cmp    $0x1,%eax
c01053d5:	74 24                	je     c01053fb <check_pgdir+0x1c5>
c01053d7:	c7 44 24 0c 73 9b 10 	movl   $0xc0109b73,0xc(%esp)
c01053de:	c0 
c01053df:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c01053e6:	c0 
c01053e7:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c01053ee:	00 
c01053ef:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01053f6:	e8 e6 b8 ff ff       	call   c0100ce1 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01053fb:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105400:	8b 00                	mov    (%eax),%eax
c0105402:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105407:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010540a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010540d:	c1 e8 0c             	shr    $0xc,%eax
c0105410:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105413:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0105418:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010541b:	72 23                	jb     c0105440 <check_pgdir+0x20a>
c010541d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105420:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105424:	c7 44 24 08 2c 99 10 	movl   $0xc010992c,0x8(%esp)
c010542b:	c0 
c010542c:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0105433:	00 
c0105434:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c010543b:	e8 a1 b8 ff ff       	call   c0100ce1 <__panic>
c0105440:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105443:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105448:	83 c0 04             	add    $0x4,%eax
c010544b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010544e:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105453:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010545a:	00 
c010545b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105462:	00 
c0105463:	89 04 24             	mov    %eax,(%esp)
c0105466:	e8 96 f9 ff ff       	call   c0104e01 <get_pte>
c010546b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010546e:	74 24                	je     c0105494 <check_pgdir+0x25e>
c0105470:	c7 44 24 0c 88 9b 10 	movl   $0xc0109b88,0xc(%esp)
c0105477:	c0 
c0105478:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c010547f:	c0 
c0105480:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0105487:	00 
c0105488:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c010548f:	e8 4d b8 ff ff       	call   c0100ce1 <__panic>

    p2 = alloc_page();
c0105494:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010549b:	e8 82 f2 ff ff       	call   c0104722 <alloc_pages>
c01054a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01054a3:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01054a8:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01054af:	00 
c01054b0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01054b7:	00 
c01054b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054bb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01054bf:	89 04 24             	mov    %eax,(%esp)
c01054c2:	e8 70 fb ff ff       	call   c0105037 <page_insert>
c01054c7:	85 c0                	test   %eax,%eax
c01054c9:	74 24                	je     c01054ef <check_pgdir+0x2b9>
c01054cb:	c7 44 24 0c b0 9b 10 	movl   $0xc0109bb0,0xc(%esp)
c01054d2:	c0 
c01054d3:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c01054da:	c0 
c01054db:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c01054e2:	00 
c01054e3:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01054ea:	e8 f2 b7 ff ff       	call   c0100ce1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01054ef:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01054f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01054fb:	00 
c01054fc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105503:	00 
c0105504:	89 04 24             	mov    %eax,(%esp)
c0105507:	e8 f5 f8 ff ff       	call   c0104e01 <get_pte>
c010550c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010550f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105513:	75 24                	jne    c0105539 <check_pgdir+0x303>
c0105515:	c7 44 24 0c e8 9b 10 	movl   $0xc0109be8,0xc(%esp)
c010551c:	c0 
c010551d:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105524:	c0 
c0105525:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c010552c:	00 
c010552d:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105534:	e8 a8 b7 ff ff       	call   c0100ce1 <__panic>
    assert(*ptep & PTE_U);
c0105539:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010553c:	8b 00                	mov    (%eax),%eax
c010553e:	83 e0 04             	and    $0x4,%eax
c0105541:	85 c0                	test   %eax,%eax
c0105543:	75 24                	jne    c0105569 <check_pgdir+0x333>
c0105545:	c7 44 24 0c 18 9c 10 	movl   $0xc0109c18,0xc(%esp)
c010554c:	c0 
c010554d:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105554:	c0 
c0105555:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c010555c:	00 
c010555d:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105564:	e8 78 b7 ff ff       	call   c0100ce1 <__panic>
    assert(*ptep & PTE_W);
c0105569:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010556c:	8b 00                	mov    (%eax),%eax
c010556e:	83 e0 02             	and    $0x2,%eax
c0105571:	85 c0                	test   %eax,%eax
c0105573:	75 24                	jne    c0105599 <check_pgdir+0x363>
c0105575:	c7 44 24 0c 26 9c 10 	movl   $0xc0109c26,0xc(%esp)
c010557c:	c0 
c010557d:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105584:	c0 
c0105585:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c010558c:	00 
c010558d:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105594:	e8 48 b7 ff ff       	call   c0100ce1 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105599:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010559e:	8b 00                	mov    (%eax),%eax
c01055a0:	83 e0 04             	and    $0x4,%eax
c01055a3:	85 c0                	test   %eax,%eax
c01055a5:	75 24                	jne    c01055cb <check_pgdir+0x395>
c01055a7:	c7 44 24 0c 34 9c 10 	movl   $0xc0109c34,0xc(%esp)
c01055ae:	c0 
c01055af:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c01055b6:	c0 
c01055b7:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c01055be:	00 
c01055bf:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01055c6:	e8 16 b7 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p2) == 1);
c01055cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055ce:	89 04 24             	mov    %eax,(%esp)
c01055d1:	e8 47 ef ff ff       	call   c010451d <page_ref>
c01055d6:	83 f8 01             	cmp    $0x1,%eax
c01055d9:	74 24                	je     c01055ff <check_pgdir+0x3c9>
c01055db:	c7 44 24 0c 4a 9c 10 	movl   $0xc0109c4a,0xc(%esp)
c01055e2:	c0 
c01055e3:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c01055ea:	c0 
c01055eb:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c01055f2:	00 
c01055f3:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01055fa:	e8 e2 b6 ff ff       	call   c0100ce1 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01055ff:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105604:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010560b:	00 
c010560c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105613:	00 
c0105614:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105617:	89 54 24 04          	mov    %edx,0x4(%esp)
c010561b:	89 04 24             	mov    %eax,(%esp)
c010561e:	e8 14 fa ff ff       	call   c0105037 <page_insert>
c0105623:	85 c0                	test   %eax,%eax
c0105625:	74 24                	je     c010564b <check_pgdir+0x415>
c0105627:	c7 44 24 0c 5c 9c 10 	movl   $0xc0109c5c,0xc(%esp)
c010562e:	c0 
c010562f:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105636:	c0 
c0105637:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c010563e:	00 
c010563f:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105646:	e8 96 b6 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p1) == 2);
c010564b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010564e:	89 04 24             	mov    %eax,(%esp)
c0105651:	e8 c7 ee ff ff       	call   c010451d <page_ref>
c0105656:	83 f8 02             	cmp    $0x2,%eax
c0105659:	74 24                	je     c010567f <check_pgdir+0x449>
c010565b:	c7 44 24 0c 88 9c 10 	movl   $0xc0109c88,0xc(%esp)
c0105662:	c0 
c0105663:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c010566a:	c0 
c010566b:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0105672:	00 
c0105673:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c010567a:	e8 62 b6 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p2) == 0);
c010567f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105682:	89 04 24             	mov    %eax,(%esp)
c0105685:	e8 93 ee ff ff       	call   c010451d <page_ref>
c010568a:	85 c0                	test   %eax,%eax
c010568c:	74 24                	je     c01056b2 <check_pgdir+0x47c>
c010568e:	c7 44 24 0c 9a 9c 10 	movl   $0xc0109c9a,0xc(%esp)
c0105695:	c0 
c0105696:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c010569d:	c0 
c010569e:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c01056a5:	00 
c01056a6:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01056ad:	e8 2f b6 ff ff       	call   c0100ce1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01056b2:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01056b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01056be:	00 
c01056bf:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01056c6:	00 
c01056c7:	89 04 24             	mov    %eax,(%esp)
c01056ca:	e8 32 f7 ff ff       	call   c0104e01 <get_pte>
c01056cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01056d6:	75 24                	jne    c01056fc <check_pgdir+0x4c6>
c01056d8:	c7 44 24 0c e8 9b 10 	movl   $0xc0109be8,0xc(%esp)
c01056df:	c0 
c01056e0:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c01056e7:	c0 
c01056e8:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c01056ef:	00 
c01056f0:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01056f7:	e8 e5 b5 ff ff       	call   c0100ce1 <__panic>
    assert(pte2page(*ptep) == p1);
c01056fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056ff:	8b 00                	mov    (%eax),%eax
c0105701:	89 04 24             	mov    %eax,(%esp)
c0105704:	e8 be ed ff ff       	call   c01044c7 <pte2page>
c0105709:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010570c:	74 24                	je     c0105732 <check_pgdir+0x4fc>
c010570e:	c7 44 24 0c 5d 9b 10 	movl   $0xc0109b5d,0xc(%esp)
c0105715:	c0 
c0105716:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c010571d:	c0 
c010571e:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0105725:	00 
c0105726:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c010572d:	e8 af b5 ff ff       	call   c0100ce1 <__panic>
    assert((*ptep & PTE_U) == 0);
c0105732:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105735:	8b 00                	mov    (%eax),%eax
c0105737:	83 e0 04             	and    $0x4,%eax
c010573a:	85 c0                	test   %eax,%eax
c010573c:	74 24                	je     c0105762 <check_pgdir+0x52c>
c010573e:	c7 44 24 0c ac 9c 10 	movl   $0xc0109cac,0xc(%esp)
c0105745:	c0 
c0105746:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c010574d:	c0 
c010574e:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0105755:	00 
c0105756:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c010575d:	e8 7f b5 ff ff       	call   c0100ce1 <__panic>

    page_remove(boot_pgdir, 0x0);
c0105762:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105767:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010576e:	00 
c010576f:	89 04 24             	mov    %eax,(%esp)
c0105772:	e8 7c f8 ff ff       	call   c0104ff3 <page_remove>
    assert(page_ref(p1) == 1);
c0105777:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010577a:	89 04 24             	mov    %eax,(%esp)
c010577d:	e8 9b ed ff ff       	call   c010451d <page_ref>
c0105782:	83 f8 01             	cmp    $0x1,%eax
c0105785:	74 24                	je     c01057ab <check_pgdir+0x575>
c0105787:	c7 44 24 0c 73 9b 10 	movl   $0xc0109b73,0xc(%esp)
c010578e:	c0 
c010578f:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105796:	c0 
c0105797:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c010579e:	00 
c010579f:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01057a6:	e8 36 b5 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p2) == 0);
c01057ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057ae:	89 04 24             	mov    %eax,(%esp)
c01057b1:	e8 67 ed ff ff       	call   c010451d <page_ref>
c01057b6:	85 c0                	test   %eax,%eax
c01057b8:	74 24                	je     c01057de <check_pgdir+0x5a8>
c01057ba:	c7 44 24 0c 9a 9c 10 	movl   $0xc0109c9a,0xc(%esp)
c01057c1:	c0 
c01057c2:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c01057c9:	c0 
c01057ca:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c01057d1:	00 
c01057d2:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01057d9:	e8 03 b5 ff ff       	call   c0100ce1 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01057de:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01057e3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01057ea:	00 
c01057eb:	89 04 24             	mov    %eax,(%esp)
c01057ee:	e8 00 f8 ff ff       	call   c0104ff3 <page_remove>
    assert(page_ref(p1) == 0);
c01057f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057f6:	89 04 24             	mov    %eax,(%esp)
c01057f9:	e8 1f ed ff ff       	call   c010451d <page_ref>
c01057fe:	85 c0                	test   %eax,%eax
c0105800:	74 24                	je     c0105826 <check_pgdir+0x5f0>
c0105802:	c7 44 24 0c c1 9c 10 	movl   $0xc0109cc1,0xc(%esp)
c0105809:	c0 
c010580a:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105811:	c0 
c0105812:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0105819:	00 
c010581a:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105821:	e8 bb b4 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p2) == 0);
c0105826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105829:	89 04 24             	mov    %eax,(%esp)
c010582c:	e8 ec ec ff ff       	call   c010451d <page_ref>
c0105831:	85 c0                	test   %eax,%eax
c0105833:	74 24                	je     c0105859 <check_pgdir+0x623>
c0105835:	c7 44 24 0c 9a 9c 10 	movl   $0xc0109c9a,0xc(%esp)
c010583c:	c0 
c010583d:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105844:	c0 
c0105845:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c010584c:	00 
c010584d:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105854:	e8 88 b4 ff ff       	call   c0100ce1 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0105859:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010585e:	8b 00                	mov    (%eax),%eax
c0105860:	89 04 24             	mov    %eax,(%esp)
c0105863:	e8 9d ec ff ff       	call   c0104505 <pde2page>
c0105868:	89 04 24             	mov    %eax,(%esp)
c010586b:	e8 ad ec ff ff       	call   c010451d <page_ref>
c0105870:	83 f8 01             	cmp    $0x1,%eax
c0105873:	74 24                	je     c0105899 <check_pgdir+0x663>
c0105875:	c7 44 24 0c d4 9c 10 	movl   $0xc0109cd4,0xc(%esp)
c010587c:	c0 
c010587d:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105884:	c0 
c0105885:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c010588c:	00 
c010588d:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105894:	e8 48 b4 ff ff       	call   c0100ce1 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0105899:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010589e:	8b 00                	mov    (%eax),%eax
c01058a0:	89 04 24             	mov    %eax,(%esp)
c01058a3:	e8 5d ec ff ff       	call   c0104505 <pde2page>
c01058a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01058af:	00 
c01058b0:	89 04 24             	mov    %eax,(%esp)
c01058b3:	e8 d5 ee ff ff       	call   c010478d <free_pages>
    boot_pgdir[0] = 0;
c01058b8:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01058bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01058c3:	c7 04 24 fb 9c 10 c0 	movl   $0xc0109cfb,(%esp)
c01058ca:	e8 88 aa ff ff       	call   c0100357 <cprintf>
}
c01058cf:	c9                   	leave  
c01058d0:	c3                   	ret    

c01058d1 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01058d1:	55                   	push   %ebp
c01058d2:	89 e5                	mov    %esp,%ebp
c01058d4:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01058d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01058de:	e9 ca 00 00 00       	jmp    c01059ad <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01058e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058ec:	c1 e8 0c             	shr    $0xc,%eax
c01058ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01058f2:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c01058f7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01058fa:	72 23                	jb     c010591f <check_boot_pgdir+0x4e>
c01058fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105903:	c7 44 24 08 2c 99 10 	movl   $0xc010992c,0x8(%esp)
c010590a:	c0 
c010590b:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105912:	00 
c0105913:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c010591a:	e8 c2 b3 ff ff       	call   c0100ce1 <__panic>
c010591f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105922:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105927:	89 c2                	mov    %eax,%edx
c0105929:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010592e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105935:	00 
c0105936:	89 54 24 04          	mov    %edx,0x4(%esp)
c010593a:	89 04 24             	mov    %eax,(%esp)
c010593d:	e8 bf f4 ff ff       	call   c0104e01 <get_pte>
c0105942:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105945:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105949:	75 24                	jne    c010596f <check_boot_pgdir+0x9e>
c010594b:	c7 44 24 0c 18 9d 10 	movl   $0xc0109d18,0xc(%esp)
c0105952:	c0 
c0105953:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c010595a:	c0 
c010595b:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105962:	00 
c0105963:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c010596a:	e8 72 b3 ff ff       	call   c0100ce1 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010596f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105972:	8b 00                	mov    (%eax),%eax
c0105974:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105979:	89 c2                	mov    %eax,%edx
c010597b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010597e:	39 c2                	cmp    %eax,%edx
c0105980:	74 24                	je     c01059a6 <check_boot_pgdir+0xd5>
c0105982:	c7 44 24 0c 55 9d 10 	movl   $0xc0109d55,0xc(%esp)
c0105989:	c0 
c010598a:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105991:	c0 
c0105992:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105999:	00 
c010599a:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01059a1:	e8 3b b3 ff ff       	call   c0100ce1 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01059a6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01059ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059b0:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c01059b5:	39 c2                	cmp    %eax,%edx
c01059b7:	0f 82 26 ff ff ff    	jb     c01058e3 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01059bd:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01059c2:	05 ac 0f 00 00       	add    $0xfac,%eax
c01059c7:	8b 00                	mov    (%eax),%eax
c01059c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01059ce:	89 c2                	mov    %eax,%edx
c01059d0:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01059d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01059d8:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01059df:	77 23                	ja     c0105a04 <check_boot_pgdir+0x133>
c01059e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059e8:	c7 44 24 08 50 99 10 	movl   $0xc0109950,0x8(%esp)
c01059ef:	c0 
c01059f0:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c01059f7:	00 
c01059f8:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c01059ff:	e8 dd b2 ff ff       	call   c0100ce1 <__panic>
c0105a04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a07:	05 00 00 00 40       	add    $0x40000000,%eax
c0105a0c:	39 c2                	cmp    %eax,%edx
c0105a0e:	74 24                	je     c0105a34 <check_boot_pgdir+0x163>
c0105a10:	c7 44 24 0c 6c 9d 10 	movl   $0xc0109d6c,0xc(%esp)
c0105a17:	c0 
c0105a18:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105a1f:	c0 
c0105a20:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105a27:	00 
c0105a28:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105a2f:	e8 ad b2 ff ff       	call   c0100ce1 <__panic>

    assert(boot_pgdir[0] == 0);
c0105a34:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105a39:	8b 00                	mov    (%eax),%eax
c0105a3b:	85 c0                	test   %eax,%eax
c0105a3d:	74 24                	je     c0105a63 <check_boot_pgdir+0x192>
c0105a3f:	c7 44 24 0c a0 9d 10 	movl   $0xc0109da0,0xc(%esp)
c0105a46:	c0 
c0105a47:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105a4e:	c0 
c0105a4f:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105a56:	00 
c0105a57:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105a5e:	e8 7e b2 ff ff       	call   c0100ce1 <__panic>

    struct Page *p;
    p = alloc_page();
c0105a63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105a6a:	e8 b3 ec ff ff       	call   c0104722 <alloc_pages>
c0105a6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105a72:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105a77:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105a7e:	00 
c0105a7f:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105a86:	00 
c0105a87:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a8a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a8e:	89 04 24             	mov    %eax,(%esp)
c0105a91:	e8 a1 f5 ff ff       	call   c0105037 <page_insert>
c0105a96:	85 c0                	test   %eax,%eax
c0105a98:	74 24                	je     c0105abe <check_boot_pgdir+0x1ed>
c0105a9a:	c7 44 24 0c b4 9d 10 	movl   $0xc0109db4,0xc(%esp)
c0105aa1:	c0 
c0105aa2:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105aa9:	c0 
c0105aaa:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c0105ab1:	00 
c0105ab2:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105ab9:	e8 23 b2 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p) == 1);
c0105abe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ac1:	89 04 24             	mov    %eax,(%esp)
c0105ac4:	e8 54 ea ff ff       	call   c010451d <page_ref>
c0105ac9:	83 f8 01             	cmp    $0x1,%eax
c0105acc:	74 24                	je     c0105af2 <check_boot_pgdir+0x221>
c0105ace:	c7 44 24 0c e2 9d 10 	movl   $0xc0109de2,0xc(%esp)
c0105ad5:	c0 
c0105ad6:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105add:	c0 
c0105ade:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c0105ae5:	00 
c0105ae6:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105aed:	e8 ef b1 ff ff       	call   c0100ce1 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105af2:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105af7:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105afe:	00 
c0105aff:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105b06:	00 
c0105b07:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105b0a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b0e:	89 04 24             	mov    %eax,(%esp)
c0105b11:	e8 21 f5 ff ff       	call   c0105037 <page_insert>
c0105b16:	85 c0                	test   %eax,%eax
c0105b18:	74 24                	je     c0105b3e <check_boot_pgdir+0x26d>
c0105b1a:	c7 44 24 0c f4 9d 10 	movl   $0xc0109df4,0xc(%esp)
c0105b21:	c0 
c0105b22:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105b29:	c0 
c0105b2a:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105b31:	00 
c0105b32:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105b39:	e8 a3 b1 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p) == 2);
c0105b3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b41:	89 04 24             	mov    %eax,(%esp)
c0105b44:	e8 d4 e9 ff ff       	call   c010451d <page_ref>
c0105b49:	83 f8 02             	cmp    $0x2,%eax
c0105b4c:	74 24                	je     c0105b72 <check_boot_pgdir+0x2a1>
c0105b4e:	c7 44 24 0c 2b 9e 10 	movl   $0xc0109e2b,0xc(%esp)
c0105b55:	c0 
c0105b56:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105b5d:	c0 
c0105b5e:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
c0105b65:	00 
c0105b66:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105b6d:	e8 6f b1 ff ff       	call   c0100ce1 <__panic>

    const char *str = "ucore: Hello world!!";
c0105b72:	c7 45 dc 3c 9e 10 c0 	movl   $0xc0109e3c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105b79:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b80:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b87:	e8 ca 2c 00 00       	call   c0108856 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105b8c:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105b93:	00 
c0105b94:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b9b:	e8 2f 2d 00 00       	call   c01088cf <strcmp>
c0105ba0:	85 c0                	test   %eax,%eax
c0105ba2:	74 24                	je     c0105bc8 <check_boot_pgdir+0x2f7>
c0105ba4:	c7 44 24 0c 54 9e 10 	movl   $0xc0109e54,0xc(%esp)
c0105bab:	c0 
c0105bac:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105bb3:	c0 
c0105bb4:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
c0105bbb:	00 
c0105bbc:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105bc3:	e8 19 b1 ff ff       	call   c0100ce1 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105bc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105bcb:	89 04 24             	mov    %eax,(%esp)
c0105bce:	e8 56 e8 ff ff       	call   c0104429 <page2kva>
c0105bd3:	05 00 01 00 00       	add    $0x100,%eax
c0105bd8:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105bdb:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105be2:	e8 17 2c 00 00       	call   c01087fe <strlen>
c0105be7:	85 c0                	test   %eax,%eax
c0105be9:	74 24                	je     c0105c0f <check_boot_pgdir+0x33e>
c0105beb:	c7 44 24 0c 8c 9e 10 	movl   $0xc0109e8c,0xc(%esp)
c0105bf2:	c0 
c0105bf3:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105bfa:	c0 
c0105bfb:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
c0105c02:	00 
c0105c03:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105c0a:	e8 d2 b0 ff ff       	call   c0100ce1 <__panic>

    free_page(p);
c0105c0f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c16:	00 
c0105c17:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c1a:	89 04 24             	mov    %eax,(%esp)
c0105c1d:	e8 6b eb ff ff       	call   c010478d <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105c22:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105c27:	8b 00                	mov    (%eax),%eax
c0105c29:	89 04 24             	mov    %eax,(%esp)
c0105c2c:	e8 d4 e8 ff ff       	call   c0104505 <pde2page>
c0105c31:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c38:	00 
c0105c39:	89 04 24             	mov    %eax,(%esp)
c0105c3c:	e8 4c eb ff ff       	call   c010478d <free_pages>
    boot_pgdir[0] = 0;
c0105c41:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105c46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105c4c:	c7 04 24 b0 9e 10 c0 	movl   $0xc0109eb0,(%esp)
c0105c53:	e8 ff a6 ff ff       	call   c0100357 <cprintf>
}
c0105c58:	c9                   	leave  
c0105c59:	c3                   	ret    

c0105c5a <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105c5a:	55                   	push   %ebp
c0105c5b:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105c5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c60:	83 e0 04             	and    $0x4,%eax
c0105c63:	85 c0                	test   %eax,%eax
c0105c65:	74 07                	je     c0105c6e <perm2str+0x14>
c0105c67:	b8 75 00 00 00       	mov    $0x75,%eax
c0105c6c:	eb 05                	jmp    c0105c73 <perm2str+0x19>
c0105c6e:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105c73:	a2 28 40 12 c0       	mov    %al,0xc0124028
    str[1] = 'r';
c0105c78:	c6 05 29 40 12 c0 72 	movb   $0x72,0xc0124029
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105c7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c82:	83 e0 02             	and    $0x2,%eax
c0105c85:	85 c0                	test   %eax,%eax
c0105c87:	74 07                	je     c0105c90 <perm2str+0x36>
c0105c89:	b8 77 00 00 00       	mov    $0x77,%eax
c0105c8e:	eb 05                	jmp    c0105c95 <perm2str+0x3b>
c0105c90:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105c95:	a2 2a 40 12 c0       	mov    %al,0xc012402a
    str[3] = '\0';
c0105c9a:	c6 05 2b 40 12 c0 00 	movb   $0x0,0xc012402b
    return str;
c0105ca1:	b8 28 40 12 c0       	mov    $0xc0124028,%eax
}
c0105ca6:	5d                   	pop    %ebp
c0105ca7:	c3                   	ret    

c0105ca8 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105ca8:	55                   	push   %ebp
c0105ca9:	89 e5                	mov    %esp,%ebp
c0105cab:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105cae:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cb1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105cb4:	72 0a                	jb     c0105cc0 <get_pgtable_items+0x18>
        return 0;
c0105cb6:	b8 00 00 00 00       	mov    $0x0,%eax
c0105cbb:	e9 9c 00 00 00       	jmp    c0105d5c <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105cc0:	eb 04                	jmp    c0105cc6 <get_pgtable_items+0x1e>
        start ++;
c0105cc2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105cc6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cc9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ccc:	73 18                	jae    c0105ce6 <get_pgtable_items+0x3e>
c0105cce:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cd1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105cd8:	8b 45 14             	mov    0x14(%ebp),%eax
c0105cdb:	01 d0                	add    %edx,%eax
c0105cdd:	8b 00                	mov    (%eax),%eax
c0105cdf:	83 e0 01             	and    $0x1,%eax
c0105ce2:	85 c0                	test   %eax,%eax
c0105ce4:	74 dc                	je     c0105cc2 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105ce6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ce9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105cec:	73 69                	jae    c0105d57 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105cee:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105cf2:	74 08                	je     c0105cfc <get_pgtable_items+0x54>
            *left_store = start;
c0105cf4:	8b 45 18             	mov    0x18(%ebp),%eax
c0105cf7:	8b 55 10             	mov    0x10(%ebp),%edx
c0105cfa:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105cfc:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cff:	8d 50 01             	lea    0x1(%eax),%edx
c0105d02:	89 55 10             	mov    %edx,0x10(%ebp)
c0105d05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105d0c:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d0f:	01 d0                	add    %edx,%eax
c0105d11:	8b 00                	mov    (%eax),%eax
c0105d13:	83 e0 07             	and    $0x7,%eax
c0105d16:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105d19:	eb 04                	jmp    c0105d1f <get_pgtable_items+0x77>
            start ++;
c0105d1b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105d1f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d22:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d25:	73 1d                	jae    c0105d44 <get_pgtable_items+0x9c>
c0105d27:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d2a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105d31:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d34:	01 d0                	add    %edx,%eax
c0105d36:	8b 00                	mov    (%eax),%eax
c0105d38:	83 e0 07             	and    $0x7,%eax
c0105d3b:	89 c2                	mov    %eax,%edx
c0105d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d40:	39 c2                	cmp    %eax,%edx
c0105d42:	74 d7                	je     c0105d1b <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105d44:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105d48:	74 08                	je     c0105d52 <get_pgtable_items+0xaa>
            *right_store = start;
c0105d4a:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105d4d:	8b 55 10             	mov    0x10(%ebp),%edx
c0105d50:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105d52:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d55:	eb 05                	jmp    c0105d5c <get_pgtable_items+0xb4>
    }
    return 0;
c0105d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d5c:	c9                   	leave  
c0105d5d:	c3                   	ret    

c0105d5e <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105d5e:	55                   	push   %ebp
c0105d5f:	89 e5                	mov    %esp,%ebp
c0105d61:	57                   	push   %edi
c0105d62:	56                   	push   %esi
c0105d63:	53                   	push   %ebx
c0105d64:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105d67:	c7 04 24 d0 9e 10 c0 	movl   $0xc0109ed0,(%esp)
c0105d6e:	e8 e4 a5 ff ff       	call   c0100357 <cprintf>
    size_t left, right = 0, perm;
c0105d73:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105d7a:	e9 fa 00 00 00       	jmp    c0105e79 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d82:	89 04 24             	mov    %eax,(%esp)
c0105d85:	e8 d0 fe ff ff       	call   c0105c5a <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105d8a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105d8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d90:	29 d1                	sub    %edx,%ecx
c0105d92:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105d94:	89 d6                	mov    %edx,%esi
c0105d96:	c1 e6 16             	shl    $0x16,%esi
c0105d99:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105d9c:	89 d3                	mov    %edx,%ebx
c0105d9e:	c1 e3 16             	shl    $0x16,%ebx
c0105da1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105da4:	89 d1                	mov    %edx,%ecx
c0105da6:	c1 e1 16             	shl    $0x16,%ecx
c0105da9:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105dac:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105daf:	29 d7                	sub    %edx,%edi
c0105db1:	89 fa                	mov    %edi,%edx
c0105db3:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105db7:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105dbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105dbf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105dc3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105dc7:	c7 04 24 01 9f 10 c0 	movl   $0xc0109f01,(%esp)
c0105dce:	e8 84 a5 ff ff       	call   c0100357 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105dd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105dd6:	c1 e0 0a             	shl    $0xa,%eax
c0105dd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105ddc:	eb 54                	jmp    c0105e32 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105dde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105de1:	89 04 24             	mov    %eax,(%esp)
c0105de4:	e8 71 fe ff ff       	call   c0105c5a <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105de9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105dec:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105def:	29 d1                	sub    %edx,%ecx
c0105df1:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105df3:	89 d6                	mov    %edx,%esi
c0105df5:	c1 e6 0c             	shl    $0xc,%esi
c0105df8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105dfb:	89 d3                	mov    %edx,%ebx
c0105dfd:	c1 e3 0c             	shl    $0xc,%ebx
c0105e00:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105e03:	c1 e2 0c             	shl    $0xc,%edx
c0105e06:	89 d1                	mov    %edx,%ecx
c0105e08:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105e0b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105e0e:	29 d7                	sub    %edx,%edi
c0105e10:	89 fa                	mov    %edi,%edx
c0105e12:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105e16:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105e1a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105e1e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105e22:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e26:	c7 04 24 20 9f 10 c0 	movl   $0xc0109f20,(%esp)
c0105e2d:	e8 25 a5 ff ff       	call   c0100357 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105e32:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105e37:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105e3a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e3d:	89 ce                	mov    %ecx,%esi
c0105e3f:	c1 e6 0a             	shl    $0xa,%esi
c0105e42:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105e45:	89 cb                	mov    %ecx,%ebx
c0105e47:	c1 e3 0a             	shl    $0xa,%ebx
c0105e4a:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105e4d:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105e51:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105e54:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105e58:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e5c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e60:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105e64:	89 1c 24             	mov    %ebx,(%esp)
c0105e67:	e8 3c fe ff ff       	call   c0105ca8 <get_pgtable_items>
c0105e6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105e73:	0f 85 65 ff ff ff    	jne    c0105dde <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105e79:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105e7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e81:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105e84:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105e88:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105e8b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105e8f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e93:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e97:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105e9e:	00 
c0105e9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105ea6:	e8 fd fd ff ff       	call   c0105ca8 <get_pgtable_items>
c0105eab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105eae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105eb2:	0f 85 c7 fe ff ff    	jne    c0105d7f <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105eb8:	c7 04 24 44 9f 10 c0 	movl   $0xc0109f44,(%esp)
c0105ebf:	e8 93 a4 ff ff       	call   c0100357 <cprintf>
}
c0105ec4:	83 c4 4c             	add    $0x4c,%esp
c0105ec7:	5b                   	pop    %ebx
c0105ec8:	5e                   	pop    %esi
c0105ec9:	5f                   	pop    %edi
c0105eca:	5d                   	pop    %ebp
c0105ecb:	c3                   	ret    

c0105ecc <kmalloc>:

void *
kmalloc(size_t n) {
c0105ecc:	55                   	push   %ebp
c0105ecd:	89 e5                	mov    %esp,%ebp
c0105ecf:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0105ed2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0105ed9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0105ee0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105ee4:	74 09                	je     c0105eef <kmalloc+0x23>
c0105ee6:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0105eed:	76 24                	jbe    c0105f13 <kmalloc+0x47>
c0105eef:	c7 44 24 0c 75 9f 10 	movl   $0xc0109f75,0xc(%esp)
c0105ef6:	c0 
c0105ef7:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105efe:	c0 
c0105eff:	c7 44 24 04 9b 02 00 	movl   $0x29b,0x4(%esp)
c0105f06:	00 
c0105f07:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105f0e:	e8 ce ad ff ff       	call   c0100ce1 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105f13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f16:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105f1b:	c1 e8 0c             	shr    $0xc,%eax
c0105f1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0105f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f24:	89 04 24             	mov    %eax,(%esp)
c0105f27:	e8 f6 e7 ff ff       	call   c0104722 <alloc_pages>
c0105f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0105f2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105f33:	75 24                	jne    c0105f59 <kmalloc+0x8d>
c0105f35:	c7 44 24 0c 8c 9f 10 	movl   $0xc0109f8c,0xc(%esp)
c0105f3c:	c0 
c0105f3d:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105f44:	c0 
c0105f45:	c7 44 24 04 9e 02 00 	movl   $0x29e,0x4(%esp)
c0105f4c:	00 
c0105f4d:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105f54:	e8 88 ad ff ff       	call   c0100ce1 <__panic>
    ptr=page2kva(base);
c0105f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f5c:	89 04 24             	mov    %eax,(%esp)
c0105f5f:	e8 c5 e4 ff ff       	call   c0104429 <page2kva>
c0105f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0105f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105f6a:	c9                   	leave  
c0105f6b:	c3                   	ret    

c0105f6c <kfree>:

void 
kfree(void *ptr, size_t n) {
c0105f6c:	55                   	push   %ebp
c0105f6d:	89 e5                	mov    %esp,%ebp
c0105f6f:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c0105f72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105f76:	74 09                	je     c0105f81 <kfree+0x15>
c0105f78:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0105f7f:	76 24                	jbe    c0105fa5 <kfree+0x39>
c0105f81:	c7 44 24 0c 75 9f 10 	movl   $0xc0109f75,0xc(%esp)
c0105f88:	c0 
c0105f89:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105f90:	c0 
c0105f91:	c7 44 24 04 a5 02 00 	movl   $0x2a5,0x4(%esp)
c0105f98:	00 
c0105f99:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105fa0:	e8 3c ad ff ff       	call   c0100ce1 <__panic>
    assert(ptr != NULL);
c0105fa5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105fa9:	75 24                	jne    c0105fcf <kfree+0x63>
c0105fab:	c7 44 24 0c 99 9f 10 	movl   $0xc0109f99,0xc(%esp)
c0105fb2:	c0 
c0105fb3:	c7 44 24 08 19 9a 10 	movl   $0xc0109a19,0x8(%esp)
c0105fba:	c0 
c0105fbb:	c7 44 24 04 a6 02 00 	movl   $0x2a6,0x4(%esp)
c0105fc2:	00 
c0105fc3:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0105fca:	e8 12 ad ff ff       	call   c0100ce1 <__panic>
    struct Page *base=NULL;
c0105fcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fd9:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105fde:	c1 e8 0c             	shr    $0xc,%eax
c0105fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0105fe4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fe7:	89 04 24             	mov    %eax,(%esp)
c0105fea:	e8 8e e4 ff ff       	call   c010447d <kva2page>
c0105fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0105ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ff5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ffc:	89 04 24             	mov    %eax,(%esp)
c0105fff:	e8 89 e7 ff ff       	call   c010478d <free_pages>
}
c0106004:	c9                   	leave  
c0106005:	c3                   	ret    

c0106006 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106006:	55                   	push   %ebp
c0106007:	89 e5                	mov    %esp,%ebp
c0106009:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010600c:	8b 45 08             	mov    0x8(%ebp),%eax
c010600f:	c1 e8 0c             	shr    $0xc,%eax
c0106012:	89 c2                	mov    %eax,%edx
c0106014:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0106019:	39 c2                	cmp    %eax,%edx
c010601b:	72 1c                	jb     c0106039 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010601d:	c7 44 24 08 a8 9f 10 	movl   $0xc0109fa8,0x8(%esp)
c0106024:	c0 
c0106025:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010602c:	00 
c010602d:	c7 04 24 c7 9f 10 c0 	movl   $0xc0109fc7,(%esp)
c0106034:	e8 a8 ac ff ff       	call   c0100ce1 <__panic>
    }
    return &pages[PPN(pa)];
c0106039:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c010603e:	8b 55 08             	mov    0x8(%ebp),%edx
c0106041:	c1 ea 0c             	shr    $0xc,%edx
c0106044:	c1 e2 05             	shl    $0x5,%edx
c0106047:	01 d0                	add    %edx,%eax
}
c0106049:	c9                   	leave  
c010604a:	c3                   	ret    

c010604b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c010604b:	55                   	push   %ebp
c010604c:	89 e5                	mov    %esp,%ebp
c010604e:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106051:	8b 45 08             	mov    0x8(%ebp),%eax
c0106054:	83 e0 01             	and    $0x1,%eax
c0106057:	85 c0                	test   %eax,%eax
c0106059:	75 1c                	jne    c0106077 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010605b:	c7 44 24 08 d8 9f 10 	movl   $0xc0109fd8,0x8(%esp)
c0106062:	c0 
c0106063:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010606a:	00 
c010606b:	c7 04 24 c7 9f 10 c0 	movl   $0xc0109fc7,(%esp)
c0106072:	e8 6a ac ff ff       	call   c0100ce1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106077:	8b 45 08             	mov    0x8(%ebp),%eax
c010607a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010607f:	89 04 24             	mov    %eax,(%esp)
c0106082:	e8 7f ff ff ff       	call   c0106006 <pa2page>
}
c0106087:	c9                   	leave  
c0106088:	c3                   	ret    

c0106089 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106089:	55                   	push   %ebp
c010608a:	89 e5                	mov    %esp,%ebp
c010608c:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c010608f:	e8 e5 1e 00 00       	call   c0107f79 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106094:	a1 fc 40 12 c0       	mov    0xc01240fc,%eax
c0106099:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c010609e:	76 0c                	jbe    c01060ac <swap_init+0x23>
c01060a0:	a1 fc 40 12 c0       	mov    0xc01240fc,%eax
c01060a5:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c01060aa:	76 25                	jbe    c01060d1 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c01060ac:	a1 fc 40 12 c0       	mov    0xc01240fc,%eax
c01060b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01060b5:	c7 44 24 08 f9 9f 10 	movl   $0xc0109ff9,0x8(%esp)
c01060bc:	c0 
c01060bd:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c01060c4:	00 
c01060c5:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c01060cc:	e8 10 ac ff ff       	call   c0100ce1 <__panic>
     }
     

     sm = &swap_manager_fifo;
c01060d1:	c7 05 34 40 12 c0 40 	movl   $0xc0120a40,0xc0124034
c01060d8:	0a 12 c0 
     int r = sm->init();
c01060db:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c01060e0:	8b 40 04             	mov    0x4(%eax),%eax
c01060e3:	ff d0                	call   *%eax
c01060e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01060e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01060ec:	75 26                	jne    c0106114 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c01060ee:	c7 05 2c 40 12 c0 01 	movl   $0x1,0xc012402c
c01060f5:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01060f8:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c01060fd:	8b 00                	mov    (%eax),%eax
c01060ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106103:	c7 04 24 23 a0 10 c0 	movl   $0xc010a023,(%esp)
c010610a:	e8 48 a2 ff ff       	call   c0100357 <cprintf>
          check_swap();
c010610f:	e8 a4 04 00 00       	call   c01065b8 <check_swap>
     }

     return r;
c0106114:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106117:	c9                   	leave  
c0106118:	c3                   	ret    

c0106119 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106119:	55                   	push   %ebp
c010611a:	89 e5                	mov    %esp,%ebp
c010611c:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c010611f:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c0106124:	8b 40 08             	mov    0x8(%eax),%eax
c0106127:	8b 55 08             	mov    0x8(%ebp),%edx
c010612a:	89 14 24             	mov    %edx,(%esp)
c010612d:	ff d0                	call   *%eax
}
c010612f:	c9                   	leave  
c0106130:	c3                   	ret    

c0106131 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106131:	55                   	push   %ebp
c0106132:	89 e5                	mov    %esp,%ebp
c0106134:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106137:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c010613c:	8b 40 0c             	mov    0xc(%eax),%eax
c010613f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106142:	89 14 24             	mov    %edx,(%esp)
c0106145:	ff d0                	call   *%eax
}
c0106147:	c9                   	leave  
c0106148:	c3                   	ret    

c0106149 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106149:	55                   	push   %ebp
c010614a:	89 e5                	mov    %esp,%ebp
c010614c:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c010614f:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c0106154:	8b 40 10             	mov    0x10(%eax),%eax
c0106157:	8b 55 14             	mov    0x14(%ebp),%edx
c010615a:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010615e:	8b 55 10             	mov    0x10(%ebp),%edx
c0106161:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106165:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106168:	89 54 24 04          	mov    %edx,0x4(%esp)
c010616c:	8b 55 08             	mov    0x8(%ebp),%edx
c010616f:	89 14 24             	mov    %edx,(%esp)
c0106172:	ff d0                	call   *%eax
}
c0106174:	c9                   	leave  
c0106175:	c3                   	ret    

c0106176 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106176:	55                   	push   %ebp
c0106177:	89 e5                	mov    %esp,%ebp
c0106179:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c010617c:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c0106181:	8b 40 14             	mov    0x14(%eax),%eax
c0106184:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106187:	89 54 24 04          	mov    %edx,0x4(%esp)
c010618b:	8b 55 08             	mov    0x8(%ebp),%edx
c010618e:	89 14 24             	mov    %edx,(%esp)
c0106191:	ff d0                	call   *%eax
}
c0106193:	c9                   	leave  
c0106194:	c3                   	ret    

c0106195 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106195:	55                   	push   %ebp
c0106196:	89 e5                	mov    %esp,%ebp
c0106198:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c010619b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01061a2:	e9 5a 01 00 00       	jmp    c0106301 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c01061a7:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c01061ac:	8b 40 18             	mov    0x18(%eax),%eax
c01061af:	8b 55 10             	mov    0x10(%ebp),%edx
c01061b2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01061b6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c01061b9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061bd:	8b 55 08             	mov    0x8(%ebp),%edx
c01061c0:	89 14 24             	mov    %edx,(%esp)
c01061c3:	ff d0                	call   *%eax
c01061c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01061c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01061cc:	74 18                	je     c01061e6 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01061ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061d5:	c7 04 24 38 a0 10 c0 	movl   $0xc010a038,(%esp)
c01061dc:	e8 76 a1 ff ff       	call   c0100357 <cprintf>
c01061e1:	e9 27 01 00 00       	jmp    c010630d <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c01061e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061e9:	8b 40 1c             	mov    0x1c(%eax),%eax
c01061ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c01061ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01061f2:	8b 40 0c             	mov    0xc(%eax),%eax
c01061f5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01061fc:	00 
c01061fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106200:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106204:	89 04 24             	mov    %eax,(%esp)
c0106207:	e8 f5 eb ff ff       	call   c0104e01 <get_pte>
c010620c:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c010620f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106212:	8b 00                	mov    (%eax),%eax
c0106214:	83 e0 01             	and    $0x1,%eax
c0106217:	85 c0                	test   %eax,%eax
c0106219:	75 24                	jne    c010623f <swap_out+0xaa>
c010621b:	c7 44 24 0c 65 a0 10 	movl   $0xc010a065,0xc(%esp)
c0106222:	c0 
c0106223:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c010622a:	c0 
c010622b:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0106232:	00 
c0106233:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c010623a:	e8 a2 aa ff ff       	call   c0100ce1 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c010623f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106245:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106248:	c1 ea 0c             	shr    $0xc,%edx
c010624b:	83 c2 01             	add    $0x1,%edx
c010624e:	c1 e2 08             	shl    $0x8,%edx
c0106251:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106255:	89 14 24             	mov    %edx,(%esp)
c0106258:	e8 d6 1d 00 00       	call   c0108033 <swapfs_write>
c010625d:	85 c0                	test   %eax,%eax
c010625f:	74 34                	je     c0106295 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0106261:	c7 04 24 8f a0 10 c0 	movl   $0xc010a08f,(%esp)
c0106268:	e8 ea a0 ff ff       	call   c0100357 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c010626d:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c0106272:	8b 40 10             	mov    0x10(%eax),%eax
c0106275:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106278:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010627f:	00 
c0106280:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106284:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106287:	89 54 24 04          	mov    %edx,0x4(%esp)
c010628b:	8b 55 08             	mov    0x8(%ebp),%edx
c010628e:	89 14 24             	mov    %edx,(%esp)
c0106291:	ff d0                	call   *%eax
c0106293:	eb 68                	jmp    c01062fd <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106298:	8b 40 1c             	mov    0x1c(%eax),%eax
c010629b:	c1 e8 0c             	shr    $0xc,%eax
c010629e:	83 c0 01             	add    $0x1,%eax
c01062a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01062a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01062a8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01062ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062b3:	c7 04 24 a8 a0 10 c0 	movl   $0xc010a0a8,(%esp)
c01062ba:	e8 98 a0 ff ff       	call   c0100357 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c01062bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062c2:	8b 40 1c             	mov    0x1c(%eax),%eax
c01062c5:	c1 e8 0c             	shr    $0xc,%eax
c01062c8:	83 c0 01             	add    $0x1,%eax
c01062cb:	c1 e0 08             	shl    $0x8,%eax
c01062ce:	89 c2                	mov    %eax,%edx
c01062d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01062d3:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01062d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062d8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062df:	00 
c01062e0:	89 04 24             	mov    %eax,(%esp)
c01062e3:	e8 a5 e4 ff ff       	call   c010478d <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c01062e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01062eb:	8b 40 0c             	mov    0xc(%eax),%eax
c01062ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01062f1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062f5:	89 04 24             	mov    %eax,(%esp)
c01062f8:	e8 f3 ed ff ff       	call   c01050f0 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c01062fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106301:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106304:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106307:	0f 85 9a fe ff ff    	jne    c01061a7 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c010630d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106310:	c9                   	leave  
c0106311:	c3                   	ret    

c0106312 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106312:	55                   	push   %ebp
c0106313:	89 e5                	mov    %esp,%ebp
c0106315:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106318:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010631f:	e8 fe e3 ff ff       	call   c0104722 <alloc_pages>
c0106324:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106327:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010632b:	75 24                	jne    c0106351 <swap_in+0x3f>
c010632d:	c7 44 24 0c e8 a0 10 	movl   $0xc010a0e8,0xc(%esp)
c0106334:	c0 
c0106335:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c010633c:	c0 
c010633d:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0106344:	00 
c0106345:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c010634c:	e8 90 a9 ff ff       	call   c0100ce1 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106351:	8b 45 08             	mov    0x8(%ebp),%eax
c0106354:	8b 40 0c             	mov    0xc(%eax),%eax
c0106357:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010635e:	00 
c010635f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106362:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106366:	89 04 24             	mov    %eax,(%esp)
c0106369:	e8 93 ea ff ff       	call   c0104e01 <get_pte>
c010636e:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106371:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106374:	8b 00                	mov    (%eax),%eax
c0106376:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106379:	89 54 24 04          	mov    %edx,0x4(%esp)
c010637d:	89 04 24             	mov    %eax,(%esp)
c0106380:	e8 3c 1c 00 00       	call   c0107fc1 <swapfs_read>
c0106385:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106388:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010638c:	74 2a                	je     c01063b8 <swap_in+0xa6>
     {
        assert(r!=0);
c010638e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106392:	75 24                	jne    c01063b8 <swap_in+0xa6>
c0106394:	c7 44 24 0c f5 a0 10 	movl   $0xc010a0f5,0xc(%esp)
c010639b:	c0 
c010639c:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c01063a3:	c0 
c01063a4:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c01063ab:	00 
c01063ac:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c01063b3:	e8 29 a9 ff ff       	call   c0100ce1 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01063b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01063bb:	8b 00                	mov    (%eax),%eax
c01063bd:	c1 e8 08             	shr    $0x8,%eax
c01063c0:	89 c2                	mov    %eax,%edx
c01063c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01063c5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01063c9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063cd:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c01063d4:	e8 7e 9f ff ff       	call   c0100357 <cprintf>
     *ptr_result=result;
c01063d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01063dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01063df:	89 10                	mov    %edx,(%eax)
     return 0;
c01063e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01063e6:	c9                   	leave  
c01063e7:	c3                   	ret    

c01063e8 <check_content_set>:



static inline void
check_content_set(void)
{
c01063e8:	55                   	push   %ebp
c01063e9:	89 e5                	mov    %esp,%ebp
c01063eb:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01063ee:	b8 00 10 00 00       	mov    $0x1000,%eax
c01063f3:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01063f6:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c01063fb:	83 f8 01             	cmp    $0x1,%eax
c01063fe:	74 24                	je     c0106424 <check_content_set+0x3c>
c0106400:	c7 44 24 0c 3a a1 10 	movl   $0xc010a13a,0xc(%esp)
c0106407:	c0 
c0106408:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c010640f:	c0 
c0106410:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106417:	00 
c0106418:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c010641f:	e8 bd a8 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106424:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106429:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c010642c:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106431:	83 f8 01             	cmp    $0x1,%eax
c0106434:	74 24                	je     c010645a <check_content_set+0x72>
c0106436:	c7 44 24 0c 3a a1 10 	movl   $0xc010a13a,0xc(%esp)
c010643d:	c0 
c010643e:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c0106445:	c0 
c0106446:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c010644d:	00 
c010644e:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106455:	e8 87 a8 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c010645a:	b8 00 20 00 00       	mov    $0x2000,%eax
c010645f:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106462:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106467:	83 f8 02             	cmp    $0x2,%eax
c010646a:	74 24                	je     c0106490 <check_content_set+0xa8>
c010646c:	c7 44 24 0c 49 a1 10 	movl   $0xc010a149,0xc(%esp)
c0106473:	c0 
c0106474:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c010647b:	c0 
c010647c:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106483:	00 
c0106484:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c010648b:	e8 51 a8 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106490:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106495:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106498:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c010649d:	83 f8 02             	cmp    $0x2,%eax
c01064a0:	74 24                	je     c01064c6 <check_content_set+0xde>
c01064a2:	c7 44 24 0c 49 a1 10 	movl   $0xc010a149,0xc(%esp)
c01064a9:	c0 
c01064aa:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c01064b1:	c0 
c01064b2:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c01064b9:	00 
c01064ba:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c01064c1:	e8 1b a8 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c01064c6:	b8 00 30 00 00       	mov    $0x3000,%eax
c01064cb:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01064ce:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c01064d3:	83 f8 03             	cmp    $0x3,%eax
c01064d6:	74 24                	je     c01064fc <check_content_set+0x114>
c01064d8:	c7 44 24 0c 58 a1 10 	movl   $0xc010a158,0xc(%esp)
c01064df:	c0 
c01064e0:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c01064e7:	c0 
c01064e8:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c01064ef:	00 
c01064f0:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c01064f7:	e8 e5 a7 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01064fc:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106501:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106504:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106509:	83 f8 03             	cmp    $0x3,%eax
c010650c:	74 24                	je     c0106532 <check_content_set+0x14a>
c010650e:	c7 44 24 0c 58 a1 10 	movl   $0xc010a158,0xc(%esp)
c0106515:	c0 
c0106516:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c010651d:	c0 
c010651e:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106525:	00 
c0106526:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c010652d:	e8 af a7 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106532:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106537:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c010653a:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c010653f:	83 f8 04             	cmp    $0x4,%eax
c0106542:	74 24                	je     c0106568 <check_content_set+0x180>
c0106544:	c7 44 24 0c 67 a1 10 	movl   $0xc010a167,0xc(%esp)
c010654b:	c0 
c010654c:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c0106553:	c0 
c0106554:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c010655b:	00 
c010655c:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106563:	e8 79 a7 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106568:	b8 10 40 00 00       	mov    $0x4010,%eax
c010656d:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106570:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106575:	83 f8 04             	cmp    $0x4,%eax
c0106578:	74 24                	je     c010659e <check_content_set+0x1b6>
c010657a:	c7 44 24 0c 67 a1 10 	movl   $0xc010a167,0xc(%esp)
c0106581:	c0 
c0106582:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c0106589:	c0 
c010658a:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106591:	00 
c0106592:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106599:	e8 43 a7 ff ff       	call   c0100ce1 <__panic>
}
c010659e:	c9                   	leave  
c010659f:	c3                   	ret    

c01065a0 <check_content_access>:

static inline int
check_content_access(void)
{
c01065a0:	55                   	push   %ebp
c01065a1:	89 e5                	mov    %esp,%ebp
c01065a3:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c01065a6:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c01065ab:	8b 40 1c             	mov    0x1c(%eax),%eax
c01065ae:	ff d0                	call   *%eax
c01065b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c01065b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01065b6:	c9                   	leave  
c01065b7:	c3                   	ret    

c01065b8 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c01065b8:	55                   	push   %ebp
c01065b9:	89 e5                	mov    %esp,%ebp
c01065bb:	53                   	push   %ebx
c01065bc:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c01065bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01065c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c01065cd:	c7 45 e8 40 40 12 c0 	movl   $0xc0124040,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01065d4:	eb 6b                	jmp    c0106641 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c01065d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01065d9:	83 e8 0c             	sub    $0xc,%eax
c01065dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c01065df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065e2:	83 c0 04             	add    $0x4,%eax
c01065e5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01065ec:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01065ef:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01065f2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01065f5:	0f a3 10             	bt     %edx,(%eax)
c01065f8:	19 c0                	sbb    %eax,%eax
c01065fa:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c01065fd:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106601:	0f 95 c0             	setne  %al
c0106604:	0f b6 c0             	movzbl %al,%eax
c0106607:	85 c0                	test   %eax,%eax
c0106609:	75 24                	jne    c010662f <check_swap+0x77>
c010660b:	c7 44 24 0c 76 a1 10 	movl   $0xc010a176,0xc(%esp)
c0106612:	c0 
c0106613:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c010661a:	c0 
c010661b:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106622:	00 
c0106623:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c010662a:	e8 b2 a6 ff ff       	call   c0100ce1 <__panic>
        count ++, total += p->property;
c010662f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106636:	8b 50 08             	mov    0x8(%eax),%edx
c0106639:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010663c:	01 d0                	add    %edx,%eax
c010663e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106641:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106644:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106647:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010664a:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c010664d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106650:	81 7d e8 40 40 12 c0 	cmpl   $0xc0124040,-0x18(%ebp)
c0106657:	0f 85 79 ff ff ff    	jne    c01065d6 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c010665d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106660:	e8 5a e1 ff ff       	call   c01047bf <nr_free_pages>
c0106665:	39 c3                	cmp    %eax,%ebx
c0106667:	74 24                	je     c010668d <check_swap+0xd5>
c0106669:	c7 44 24 0c 86 a1 10 	movl   $0xc010a186,0xc(%esp)
c0106670:	c0 
c0106671:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c0106678:	c0 
c0106679:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106680:	00 
c0106681:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106688:	e8 54 a6 ff ff       	call   c0100ce1 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c010668d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106690:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106694:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106697:	89 44 24 04          	mov    %eax,0x4(%esp)
c010669b:	c7 04 24 a0 a1 10 c0 	movl   $0xc010a1a0,(%esp)
c01066a2:	e8 b0 9c ff ff       	call   c0100357 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c01066a7:	e8 13 0b 00 00       	call   c01071bf <mm_create>
c01066ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c01066af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01066b3:	75 24                	jne    c01066d9 <check_swap+0x121>
c01066b5:	c7 44 24 0c c6 a1 10 	movl   $0xc010a1c6,0xc(%esp)
c01066bc:	c0 
c01066bd:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c01066c4:	c0 
c01066c5:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c01066cc:	00 
c01066cd:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c01066d4:	e8 08 a6 ff ff       	call   c0100ce1 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c01066d9:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c01066de:	85 c0                	test   %eax,%eax
c01066e0:	74 24                	je     c0106706 <check_swap+0x14e>
c01066e2:	c7 44 24 0c d1 a1 10 	movl   $0xc010a1d1,0xc(%esp)
c01066e9:	c0 
c01066ea:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c01066f1:	c0 
c01066f2:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01066f9:	00 
c01066fa:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106701:	e8 db a5 ff ff       	call   c0100ce1 <__panic>

     check_mm_struct = mm;
c0106706:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106709:	a3 2c 41 12 c0       	mov    %eax,0xc012412c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c010670e:	8b 15 e0 09 12 c0    	mov    0xc01209e0,%edx
c0106714:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106717:	89 50 0c             	mov    %edx,0xc(%eax)
c010671a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010671d:	8b 40 0c             	mov    0xc(%eax),%eax
c0106720:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106723:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106726:	8b 00                	mov    (%eax),%eax
c0106728:	85 c0                	test   %eax,%eax
c010672a:	74 24                	je     c0106750 <check_swap+0x198>
c010672c:	c7 44 24 0c e9 a1 10 	movl   $0xc010a1e9,0xc(%esp)
c0106733:	c0 
c0106734:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c010673b:	c0 
c010673c:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106743:	00 
c0106744:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c010674b:	e8 91 a5 ff ff       	call   c0100ce1 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106750:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106757:	00 
c0106758:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c010675f:	00 
c0106760:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106767:	e8 cb 0a 00 00       	call   c0107237 <vma_create>
c010676c:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c010676f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106773:	75 24                	jne    c0106799 <check_swap+0x1e1>
c0106775:	c7 44 24 0c f7 a1 10 	movl   $0xc010a1f7,0xc(%esp)
c010677c:	c0 
c010677d:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c0106784:	c0 
c0106785:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010678c:	00 
c010678d:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106794:	e8 48 a5 ff ff       	call   c0100ce1 <__panic>

     insert_vma_struct(mm, vma);
c0106799:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010679c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067a3:	89 04 24             	mov    %eax,(%esp)
c01067a6:	e8 1c 0c 00 00       	call   c01073c7 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c01067ab:	c7 04 24 04 a2 10 c0 	movl   $0xc010a204,(%esp)
c01067b2:	e8 a0 9b ff ff       	call   c0100357 <cprintf>
     pte_t *temp_ptep=NULL;
c01067b7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c01067be:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067c1:	8b 40 0c             	mov    0xc(%eax),%eax
c01067c4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01067cb:	00 
c01067cc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01067d3:	00 
c01067d4:	89 04 24             	mov    %eax,(%esp)
c01067d7:	e8 25 e6 ff ff       	call   c0104e01 <get_pte>
c01067dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c01067df:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01067e3:	75 24                	jne    c0106809 <check_swap+0x251>
c01067e5:	c7 44 24 0c 38 a2 10 	movl   $0xc010a238,0xc(%esp)
c01067ec:	c0 
c01067ed:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c01067f4:	c0 
c01067f5:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c01067fc:	00 
c01067fd:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106804:	e8 d8 a4 ff ff       	call   c0100ce1 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106809:	c7 04 24 4c a2 10 c0 	movl   $0xc010a24c,(%esp)
c0106810:	e8 42 9b ff ff       	call   c0100357 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106815:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010681c:	e9 a3 00 00 00       	jmp    c01068c4 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0106821:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106828:	e8 f5 de ff ff       	call   c0104722 <alloc_pages>
c010682d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106830:	89 04 95 60 40 12 c0 	mov    %eax,-0x3fedbfa0(,%edx,4)
          assert(check_rp[i] != NULL );
c0106837:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010683a:	8b 04 85 60 40 12 c0 	mov    -0x3fedbfa0(,%eax,4),%eax
c0106841:	85 c0                	test   %eax,%eax
c0106843:	75 24                	jne    c0106869 <check_swap+0x2b1>
c0106845:	c7 44 24 0c 70 a2 10 	movl   $0xc010a270,0xc(%esp)
c010684c:	c0 
c010684d:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c0106854:	c0 
c0106855:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c010685c:	00 
c010685d:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106864:	e8 78 a4 ff ff       	call   c0100ce1 <__panic>
          assert(!PageProperty(check_rp[i]));
c0106869:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010686c:	8b 04 85 60 40 12 c0 	mov    -0x3fedbfa0(,%eax,4),%eax
c0106873:	83 c0 04             	add    $0x4,%eax
c0106876:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c010687d:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106880:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106883:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106886:	0f a3 10             	bt     %edx,(%eax)
c0106889:	19 c0                	sbb    %eax,%eax
c010688b:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c010688e:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106892:	0f 95 c0             	setne  %al
c0106895:	0f b6 c0             	movzbl %al,%eax
c0106898:	85 c0                	test   %eax,%eax
c010689a:	74 24                	je     c01068c0 <check_swap+0x308>
c010689c:	c7 44 24 0c 84 a2 10 	movl   $0xc010a284,0xc(%esp)
c01068a3:	c0 
c01068a4:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c01068ab:	c0 
c01068ac:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01068b3:	00 
c01068b4:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c01068bb:	e8 21 a4 ff ff       	call   c0100ce1 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01068c0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01068c4:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01068c8:	0f 8e 53 ff ff ff    	jle    c0106821 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c01068ce:	a1 40 40 12 c0       	mov    0xc0124040,%eax
c01068d3:	8b 15 44 40 12 c0    	mov    0xc0124044,%edx
c01068d9:	89 45 98             	mov    %eax,-0x68(%ebp)
c01068dc:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01068df:	c7 45 a8 40 40 12 c0 	movl   $0xc0124040,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01068e6:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01068e9:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01068ec:	89 50 04             	mov    %edx,0x4(%eax)
c01068ef:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01068f2:	8b 50 04             	mov    0x4(%eax),%edx
c01068f5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01068f8:	89 10                	mov    %edx,(%eax)
c01068fa:	c7 45 a4 40 40 12 c0 	movl   $0xc0124040,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106901:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106904:	8b 40 04             	mov    0x4(%eax),%eax
c0106907:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c010690a:	0f 94 c0             	sete   %al
c010690d:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0106910:	85 c0                	test   %eax,%eax
c0106912:	75 24                	jne    c0106938 <check_swap+0x380>
c0106914:	c7 44 24 0c 9f a2 10 	movl   $0xc010a29f,0xc(%esp)
c010691b:	c0 
c010691c:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c0106923:	c0 
c0106924:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c010692b:	00 
c010692c:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106933:	e8 a9 a3 ff ff       	call   c0100ce1 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106938:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c010693d:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0106940:	c7 05 48 40 12 c0 00 	movl   $0x0,0xc0124048
c0106947:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010694a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106951:	eb 1e                	jmp    c0106971 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106953:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106956:	8b 04 85 60 40 12 c0 	mov    -0x3fedbfa0(,%eax,4),%eax
c010695d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106964:	00 
c0106965:	89 04 24             	mov    %eax,(%esp)
c0106968:	e8 20 de ff ff       	call   c010478d <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010696d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106971:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106975:	7e dc                	jle    c0106953 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106977:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c010697c:	83 f8 04             	cmp    $0x4,%eax
c010697f:	74 24                	je     c01069a5 <check_swap+0x3ed>
c0106981:	c7 44 24 0c b8 a2 10 	movl   $0xc010a2b8,0xc(%esp)
c0106988:	c0 
c0106989:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c0106990:	c0 
c0106991:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106998:	00 
c0106999:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c01069a0:	e8 3c a3 ff ff       	call   c0100ce1 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c01069a5:	c7 04 24 dc a2 10 c0 	movl   $0xc010a2dc,(%esp)
c01069ac:	e8 a6 99 ff ff       	call   c0100357 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c01069b1:	c7 05 38 40 12 c0 00 	movl   $0x0,0xc0124038
c01069b8:	00 00 00 
     
     check_content_set();
c01069bb:	e8 28 fa ff ff       	call   c01063e8 <check_content_set>
     assert( nr_free == 0);         
c01069c0:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c01069c5:	85 c0                	test   %eax,%eax
c01069c7:	74 24                	je     c01069ed <check_swap+0x435>
c01069c9:	c7 44 24 0c 03 a3 10 	movl   $0xc010a303,0xc(%esp)
c01069d0:	c0 
c01069d1:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c01069d8:	c0 
c01069d9:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c01069e0:	00 
c01069e1:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c01069e8:	e8 f4 a2 ff ff       	call   c0100ce1 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01069ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01069f4:	eb 26                	jmp    c0106a1c <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c01069f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069f9:	c7 04 85 80 40 12 c0 	movl   $0xffffffff,-0x3fedbf80(,%eax,4)
c0106a00:	ff ff ff ff 
c0106a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a07:	8b 14 85 80 40 12 c0 	mov    -0x3fedbf80(,%eax,4),%edx
c0106a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a11:	89 14 85 c0 40 12 c0 	mov    %edx,-0x3fedbf40(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106a18:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106a1c:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106a20:	7e d4                	jle    c01069f6 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106a22:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106a29:	e9 eb 00 00 00       	jmp    c0106b19 <check_swap+0x561>
         check_ptep[i]=0;
c0106a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a31:	c7 04 85 14 41 12 c0 	movl   $0x0,-0x3fedbeec(,%eax,4)
c0106a38:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a3f:	83 c0 01             	add    $0x1,%eax
c0106a42:	c1 e0 0c             	shl    $0xc,%eax
c0106a45:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106a4c:	00 
c0106a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106a51:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a54:	89 04 24             	mov    %eax,(%esp)
c0106a57:	e8 a5 e3 ff ff       	call   c0104e01 <get_pte>
c0106a5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106a5f:	89 04 95 14 41 12 c0 	mov    %eax,-0x3fedbeec(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a69:	8b 04 85 14 41 12 c0 	mov    -0x3fedbeec(,%eax,4),%eax
c0106a70:	85 c0                	test   %eax,%eax
c0106a72:	75 24                	jne    c0106a98 <check_swap+0x4e0>
c0106a74:	c7 44 24 0c 10 a3 10 	movl   $0xc010a310,0xc(%esp)
c0106a7b:	c0 
c0106a7c:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c0106a83:	c0 
c0106a84:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0106a8b:	00 
c0106a8c:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106a93:	e8 49 a2 ff ff       	call   c0100ce1 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a9b:	8b 04 85 14 41 12 c0 	mov    -0x3fedbeec(,%eax,4),%eax
c0106aa2:	8b 00                	mov    (%eax),%eax
c0106aa4:	89 04 24             	mov    %eax,(%esp)
c0106aa7:	e8 9f f5 ff ff       	call   c010604b <pte2page>
c0106aac:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106aaf:	8b 14 95 60 40 12 c0 	mov    -0x3fedbfa0(,%edx,4),%edx
c0106ab6:	39 d0                	cmp    %edx,%eax
c0106ab8:	74 24                	je     c0106ade <check_swap+0x526>
c0106aba:	c7 44 24 0c 28 a3 10 	movl   $0xc010a328,0xc(%esp)
c0106ac1:	c0 
c0106ac2:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c0106ac9:	c0 
c0106aca:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0106ad1:	00 
c0106ad2:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106ad9:	e8 03 a2 ff ff       	call   c0100ce1 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ae1:	8b 04 85 14 41 12 c0 	mov    -0x3fedbeec(,%eax,4),%eax
c0106ae8:	8b 00                	mov    (%eax),%eax
c0106aea:	83 e0 01             	and    $0x1,%eax
c0106aed:	85 c0                	test   %eax,%eax
c0106aef:	75 24                	jne    c0106b15 <check_swap+0x55d>
c0106af1:	c7 44 24 0c 50 a3 10 	movl   $0xc010a350,0xc(%esp)
c0106af8:	c0 
c0106af9:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c0106b00:	c0 
c0106b01:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0106b08:	00 
c0106b09:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106b10:	e8 cc a1 ff ff       	call   c0100ce1 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b15:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106b19:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106b1d:	0f 8e 0b ff ff ff    	jle    c0106a2e <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0106b23:	c7 04 24 6c a3 10 c0 	movl   $0xc010a36c,(%esp)
c0106b2a:	e8 28 98 ff ff       	call   c0100357 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106b2f:	e8 6c fa ff ff       	call   c01065a0 <check_content_access>
c0106b34:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0106b37:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106b3b:	74 24                	je     c0106b61 <check_swap+0x5a9>
c0106b3d:	c7 44 24 0c 92 a3 10 	movl   $0xc010a392,0xc(%esp)
c0106b44:	c0 
c0106b45:	c7 44 24 08 7a a0 10 	movl   $0xc010a07a,0x8(%esp)
c0106b4c:	c0 
c0106b4d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0106b54:	00 
c0106b55:	c7 04 24 14 a0 10 c0 	movl   $0xc010a014,(%esp)
c0106b5c:	e8 80 a1 ff ff       	call   c0100ce1 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b61:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106b68:	eb 1e                	jmp    c0106b88 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0106b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b6d:	8b 04 85 60 40 12 c0 	mov    -0x3fedbfa0(,%eax,4),%eax
c0106b74:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106b7b:	00 
c0106b7c:	89 04 24             	mov    %eax,(%esp)
c0106b7f:	e8 09 dc ff ff       	call   c010478d <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b84:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106b88:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106b8c:	7e dc                	jle    c0106b6a <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106b8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106b91:	89 04 24             	mov    %eax,(%esp)
c0106b94:	e8 5e 09 00 00       	call   c01074f7 <mm_destroy>
         
     nr_free = nr_free_store;
c0106b99:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106b9c:	a3 48 40 12 c0       	mov    %eax,0xc0124048
     free_list = free_list_store;
c0106ba1:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106ba4:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106ba7:	a3 40 40 12 c0       	mov    %eax,0xc0124040
c0106bac:	89 15 44 40 12 c0    	mov    %edx,0xc0124044

     
     le = &free_list;
c0106bb2:	c7 45 e8 40 40 12 c0 	movl   $0xc0124040,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106bb9:	eb 1d                	jmp    c0106bd8 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0106bbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106bbe:	83 e8 0c             	sub    $0xc,%eax
c0106bc1:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0106bc4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106bc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106bcb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106bce:	8b 40 08             	mov    0x8(%eax),%eax
c0106bd1:	29 c2                	sub    %eax,%edx
c0106bd3:	89 d0                	mov    %edx,%eax
c0106bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106bd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106bdb:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106bde:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106be1:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106be4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106be7:	81 7d e8 40 40 12 c0 	cmpl   $0xc0124040,-0x18(%ebp)
c0106bee:	75 cb                	jne    c0106bbb <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106bf3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bfe:	c7 04 24 99 a3 10 c0 	movl   $0xc010a399,(%esp)
c0106c05:	e8 4d 97 ff ff       	call   c0100357 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0106c0a:	c7 04 24 b3 a3 10 c0 	movl   $0xc010a3b3,(%esp)
c0106c11:	e8 41 97 ff ff       	call   c0100357 <cprintf>
}
c0106c16:	83 c4 74             	add    $0x74,%esp
c0106c19:	5b                   	pop    %ebx
c0106c1a:	5d                   	pop    %ebp
c0106c1b:	c3                   	ret    

c0106c1c <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0106c1c:	55                   	push   %ebp
c0106c1d:	89 e5                	mov    %esp,%ebp
c0106c1f:	83 ec 10             	sub    $0x10,%esp
c0106c22:	c7 45 fc 24 41 12 c0 	movl   $0xc0124124,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106c2f:	89 50 04             	mov    %edx,0x4(%eax)
c0106c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c35:	8b 50 04             	mov    0x4(%eax),%edx
c0106c38:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c3b:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106c3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c40:	c7 40 14 24 41 12 c0 	movl   $0xc0124124,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106c47:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106c4c:	c9                   	leave  
c0106c4d:	c3                   	ret    

c0106c4e <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106c4e:	55                   	push   %ebp
c0106c4f:	89 e5                	mov    %esp,%ebp
c0106c51:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106c54:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c57:	8b 40 14             	mov    0x14(%eax),%eax
c0106c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106c5d:	8b 45 10             	mov    0x10(%ebp),%eax
c0106c60:	83 c0 14             	add    $0x14,%eax
c0106c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0106c66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106c6a:	74 06                	je     c0106c72 <_fifo_map_swappable+0x24>
c0106c6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106c70:	75 24                	jne    c0106c96 <_fifo_map_swappable+0x48>
c0106c72:	c7 44 24 0c cc a3 10 	movl   $0xc010a3cc,0xc(%esp)
c0106c79:	c0 
c0106c7a:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106c81:	c0 
c0106c82:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0106c89:	00 
c0106c8a:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0106c91:	e8 4b a0 ff ff       	call   c0100ce1 <__panic>
c0106c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c99:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ca5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106cab:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0106cae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106cb1:	8b 40 04             	mov    0x4(%eax),%eax
c0106cb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106cb7:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106cba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106cbd:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0106cc0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0106cc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106cc6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106cc9:	89 10                	mov    %edx,(%eax)
c0106ccb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106cce:	8b 10                	mov    (%eax),%edx
c0106cd0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106cd3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106cd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106cd9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106cdc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106cdf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106ce2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106ce5:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head, entry);
    return 0;
c0106ce7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106cec:	c9                   	leave  
c0106ced:	c3                   	ret    

c0106cee <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106cee:	55                   	push   %ebp
c0106cef:	89 e5                	mov    %esp,%ebp
c0106cf1:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cf7:	8b 40 14             	mov    0x14(%eax),%eax
c0106cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0106cfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106d01:	75 24                	jne    c0106d27 <_fifo_swap_out_victim+0x39>
c0106d03:	c7 44 24 0c 13 a4 10 	movl   $0xc010a413,0xc(%esp)
c0106d0a:	c0 
c0106d0b:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106d12:	c0 
c0106d13:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0106d1a:	00 
c0106d1b:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0106d22:	e8 ba 9f ff ff       	call   c0100ce1 <__panic>
     assert(in_tick==0);
c0106d27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106d2b:	74 24                	je     c0106d51 <_fifo_swap_out_victim+0x63>
c0106d2d:	c7 44 24 0c 20 a4 10 	movl   $0xc010a420,0xc(%esp)
c0106d34:	c0 
c0106d35:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106d3c:	c0 
c0106d3d:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0106d44:	00 
c0106d45:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0106d4c:	e8 90 9f ff ff       	call   c0100ce1 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  assign the value of *ptr_page to the addr of this page
     list_entry_t *le = head->prev;
c0106d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d54:	8b 00                	mov    (%eax),%eax
c0106d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(head!=le);
c0106d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0106d5f:	75 24                	jne    c0106d85 <_fifo_swap_out_victim+0x97>
c0106d61:	c7 44 24 0c 2b a4 10 	movl   $0xc010a42b,0xc(%esp)
c0106d68:	c0 
c0106d69:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106d70:	c0 
c0106d71:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
c0106d78:	00 
c0106d79:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0106d80:	e8 5c 9f ff ff       	call   c0100ce1 <__panic>
     struct Page *p = le2page(le, pra_page_link);
c0106d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d88:	83 e8 14             	sub    $0x14,%eax
c0106d8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d91:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0106d94:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d97:	8b 40 04             	mov    0x4(%eax),%eax
c0106d9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106d9d:	8b 12                	mov    (%edx),%edx
c0106d9f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106da2:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0106da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106da8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106dab:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106dae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106db1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106db4:	89 10                	mov    %edx,(%eax)
     list_del(le);
     assert(p !=NULL);
c0106db6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106dba:	75 24                	jne    c0106de0 <_fifo_swap_out_victim+0xf2>
c0106dbc:	c7 44 24 0c 34 a4 10 	movl   $0xc010a434,0xc(%esp)
c0106dc3:	c0 
c0106dc4:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106dcb:	c0 
c0106dcc:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
c0106dd3:	00 
c0106dd4:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0106ddb:	e8 01 9f ff ff       	call   c0100ce1 <__panic>
     *ptr_page = p;
c0106de0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106de3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106de6:	89 10                	mov    %edx,(%eax)

     return 0;
c0106de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106ded:	c9                   	leave  
c0106dee:	c3                   	ret    

c0106def <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106def:	55                   	push   %ebp
c0106df0:	89 e5                	mov    %esp,%ebp
c0106df2:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106df5:	c7 04 24 40 a4 10 c0 	movl   $0xc010a440,(%esp)
c0106dfc:	e8 56 95 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106e01:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106e06:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106e09:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106e0e:	83 f8 04             	cmp    $0x4,%eax
c0106e11:	74 24                	je     c0106e37 <_fifo_check_swap+0x48>
c0106e13:	c7 44 24 0c 66 a4 10 	movl   $0xc010a466,0xc(%esp)
c0106e1a:	c0 
c0106e1b:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106e22:	c0 
c0106e23:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0106e2a:	00 
c0106e2b:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0106e32:	e8 aa 9e ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106e37:	c7 04 24 78 a4 10 c0 	movl   $0xc010a478,(%esp)
c0106e3e:	e8 14 95 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106e43:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106e48:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0106e4b:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106e50:	83 f8 04             	cmp    $0x4,%eax
c0106e53:	74 24                	je     c0106e79 <_fifo_check_swap+0x8a>
c0106e55:	c7 44 24 0c 66 a4 10 	movl   $0xc010a466,0xc(%esp)
c0106e5c:	c0 
c0106e5d:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106e64:	c0 
c0106e65:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c0106e6c:	00 
c0106e6d:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0106e74:	e8 68 9e ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106e79:	c7 04 24 a0 a4 10 c0 	movl   $0xc010a4a0,(%esp)
c0106e80:	e8 d2 94 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106e85:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106e8a:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106e8d:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106e92:	83 f8 04             	cmp    $0x4,%eax
c0106e95:	74 24                	je     c0106ebb <_fifo_check_swap+0xcc>
c0106e97:	c7 44 24 0c 66 a4 10 	movl   $0xc010a466,0xc(%esp)
c0106e9e:	c0 
c0106e9f:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106ea6:	c0 
c0106ea7:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0106eae:	00 
c0106eaf:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0106eb6:	e8 26 9e ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106ebb:	c7 04 24 c8 a4 10 c0 	movl   $0xc010a4c8,(%esp)
c0106ec2:	e8 90 94 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106ec7:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106ecc:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106ecf:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106ed4:	83 f8 04             	cmp    $0x4,%eax
c0106ed7:	74 24                	je     c0106efd <_fifo_check_swap+0x10e>
c0106ed9:	c7 44 24 0c 66 a4 10 	movl   $0xc010a466,0xc(%esp)
c0106ee0:	c0 
c0106ee1:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106ee8:	c0 
c0106ee9:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0106ef0:	00 
c0106ef1:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0106ef8:	e8 e4 9d ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106efd:	c7 04 24 f0 a4 10 c0 	movl   $0xc010a4f0,(%esp)
c0106f04:	e8 4e 94 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0106f09:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106f0e:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0106f11:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106f16:	83 f8 05             	cmp    $0x5,%eax
c0106f19:	74 24                	je     c0106f3f <_fifo_check_swap+0x150>
c0106f1b:	c7 44 24 0c 16 a5 10 	movl   $0xc010a516,0xc(%esp)
c0106f22:	c0 
c0106f23:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106f2a:	c0 
c0106f2b:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0106f32:	00 
c0106f33:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0106f3a:	e8 a2 9d ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106f3f:	c7 04 24 c8 a4 10 c0 	movl   $0xc010a4c8,(%esp)
c0106f46:	e8 0c 94 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106f4b:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106f50:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0106f53:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106f58:	83 f8 05             	cmp    $0x5,%eax
c0106f5b:	74 24                	je     c0106f81 <_fifo_check_swap+0x192>
c0106f5d:	c7 44 24 0c 16 a5 10 	movl   $0xc010a516,0xc(%esp)
c0106f64:	c0 
c0106f65:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106f6c:	c0 
c0106f6d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0106f74:	00 
c0106f75:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0106f7c:	e8 60 9d ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106f81:	c7 04 24 78 a4 10 c0 	movl   $0xc010a478,(%esp)
c0106f88:	e8 ca 93 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106f8d:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106f92:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0106f95:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106f9a:	83 f8 06             	cmp    $0x6,%eax
c0106f9d:	74 24                	je     c0106fc3 <_fifo_check_swap+0x1d4>
c0106f9f:	c7 44 24 0c 25 a5 10 	movl   $0xc010a525,0xc(%esp)
c0106fa6:	c0 
c0106fa7:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106fae:	c0 
c0106faf:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106fb6:	00 
c0106fb7:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0106fbe:	e8 1e 9d ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106fc3:	c7 04 24 c8 a4 10 c0 	movl   $0xc010a4c8,(%esp)
c0106fca:	e8 88 93 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106fcf:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106fd4:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0106fd7:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106fdc:	83 f8 07             	cmp    $0x7,%eax
c0106fdf:	74 24                	je     c0107005 <_fifo_check_swap+0x216>
c0106fe1:	c7 44 24 0c 34 a5 10 	movl   $0xc010a534,0xc(%esp)
c0106fe8:	c0 
c0106fe9:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0106ff0:	c0 
c0106ff1:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0106ff8:	00 
c0106ff9:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0107000:	e8 dc 9c ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107005:	c7 04 24 40 a4 10 c0 	movl   $0xc010a440,(%esp)
c010700c:	e8 46 93 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107011:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107016:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107019:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c010701e:	83 f8 08             	cmp    $0x8,%eax
c0107021:	74 24                	je     c0107047 <_fifo_check_swap+0x258>
c0107023:	c7 44 24 0c 43 a5 10 	movl   $0xc010a543,0xc(%esp)
c010702a:	c0 
c010702b:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0107032:	c0 
c0107033:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010703a:	00 
c010703b:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0107042:	e8 9a 9c ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107047:	c7 04 24 a0 a4 10 c0 	movl   $0xc010a4a0,(%esp)
c010704e:	e8 04 93 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107053:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107058:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c010705b:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0107060:	83 f8 09             	cmp    $0x9,%eax
c0107063:	74 24                	je     c0107089 <_fifo_check_swap+0x29a>
c0107065:	c7 44 24 0c 52 a5 10 	movl   $0xc010a552,0xc(%esp)
c010706c:	c0 
c010706d:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0107074:	c0 
c0107075:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010707c:	00 
c010707d:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0107084:	e8 58 9c ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107089:	c7 04 24 f0 a4 10 c0 	movl   $0xc010a4f0,(%esp)
c0107090:	e8 c2 92 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107095:	b8 00 50 00 00       	mov    $0x5000,%eax
c010709a:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c010709d:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c01070a2:	83 f8 0a             	cmp    $0xa,%eax
c01070a5:	74 24                	je     c01070cb <_fifo_check_swap+0x2dc>
c01070a7:	c7 44 24 0c 61 a5 10 	movl   $0xc010a561,0xc(%esp)
c01070ae:	c0 
c01070af:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c01070b6:	c0 
c01070b7:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
c01070be:	00 
c01070bf:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c01070c6:	e8 16 9c ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01070cb:	c7 04 24 78 a4 10 c0 	movl   $0xc010a478,(%esp)
c01070d2:	e8 80 92 ff ff       	call   c0100357 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c01070d7:	b8 00 10 00 00       	mov    $0x1000,%eax
c01070dc:	0f b6 00             	movzbl (%eax),%eax
c01070df:	3c 0a                	cmp    $0xa,%al
c01070e1:	74 24                	je     c0107107 <_fifo_check_swap+0x318>
c01070e3:	c7 44 24 0c 74 a5 10 	movl   $0xc010a574,0xc(%esp)
c01070ea:	c0 
c01070eb:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c01070f2:	c0 
c01070f3:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
c01070fa:	00 
c01070fb:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0107102:	e8 da 9b ff ff       	call   c0100ce1 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0107107:	b8 00 10 00 00       	mov    $0x1000,%eax
c010710c:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c010710f:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0107114:	83 f8 0b             	cmp    $0xb,%eax
c0107117:	74 24                	je     c010713d <_fifo_check_swap+0x34e>
c0107119:	c7 44 24 0c 95 a5 10 	movl   $0xc010a595,0xc(%esp)
c0107120:	c0 
c0107121:	c7 44 24 08 ea a3 10 	movl   $0xc010a3ea,0x8(%esp)
c0107128:	c0 
c0107129:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
c0107130:	00 
c0107131:	c7 04 24 ff a3 10 c0 	movl   $0xc010a3ff,(%esp)
c0107138:	e8 a4 9b ff ff       	call   c0100ce1 <__panic>
    return 0;
c010713d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107142:	c9                   	leave  
c0107143:	c3                   	ret    

c0107144 <_fifo_init>:


static int
_fifo_init(void)
{
c0107144:	55                   	push   %ebp
c0107145:	89 e5                	mov    %esp,%ebp
    return 0;
c0107147:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010714c:	5d                   	pop    %ebp
c010714d:	c3                   	ret    

c010714e <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c010714e:	55                   	push   %ebp
c010714f:	89 e5                	mov    %esp,%ebp
    return 0;
c0107151:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107156:	5d                   	pop    %ebp
c0107157:	c3                   	ret    

c0107158 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107158:	55                   	push   %ebp
c0107159:	89 e5                	mov    %esp,%ebp
c010715b:	b8 00 00 00 00       	mov    $0x0,%eax
c0107160:	5d                   	pop    %ebp
c0107161:	c3                   	ret    

c0107162 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0107162:	55                   	push   %ebp
c0107163:	89 e5                	mov    %esp,%ebp
c0107165:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107168:	8b 45 08             	mov    0x8(%ebp),%eax
c010716b:	c1 e8 0c             	shr    $0xc,%eax
c010716e:	89 c2                	mov    %eax,%edx
c0107170:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0107175:	39 c2                	cmp    %eax,%edx
c0107177:	72 1c                	jb     c0107195 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107179:	c7 44 24 08 b8 a5 10 	movl   $0xc010a5b8,0x8(%esp)
c0107180:	c0 
c0107181:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0107188:	00 
c0107189:	c7 04 24 d7 a5 10 c0 	movl   $0xc010a5d7,(%esp)
c0107190:	e8 4c 9b ff ff       	call   c0100ce1 <__panic>
    }
    return &pages[PPN(pa)];
c0107195:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c010719a:	8b 55 08             	mov    0x8(%ebp),%edx
c010719d:	c1 ea 0c             	shr    $0xc,%edx
c01071a0:	c1 e2 05             	shl    $0x5,%edx
c01071a3:	01 d0                	add    %edx,%eax
}
c01071a5:	c9                   	leave  
c01071a6:	c3                   	ret    

c01071a7 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c01071a7:	55                   	push   %ebp
c01071a8:	89 e5                	mov    %esp,%ebp
c01071aa:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01071ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01071b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01071b5:	89 04 24             	mov    %eax,(%esp)
c01071b8:	e8 a5 ff ff ff       	call   c0107162 <pa2page>
}
c01071bd:	c9                   	leave  
c01071be:	c3                   	ret    

c01071bf <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c01071bf:	55                   	push   %ebp
c01071c0:	89 e5                	mov    %esp,%ebp
c01071c2:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c01071c5:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01071cc:	e8 fb ec ff ff       	call   c0105ecc <kmalloc>
c01071d1:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01071d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071d8:	74 58                	je     c0107232 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c01071da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01071e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01071e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01071e6:	89 50 04             	mov    %edx,0x4(%eax)
c01071e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01071ec:	8b 50 04             	mov    0x4(%eax),%edx
c01071ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01071f2:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c01071f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c01071fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107201:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107208:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010720b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107212:	a1 2c 40 12 c0       	mov    0xc012402c,%eax
c0107217:	85 c0                	test   %eax,%eax
c0107219:	74 0d                	je     c0107228 <mm_create+0x69>
c010721b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010721e:	89 04 24             	mov    %eax,(%esp)
c0107221:	e8 f3 ee ff ff       	call   c0106119 <swap_init_mm>
c0107226:	eb 0a                	jmp    c0107232 <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107228:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010722b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0107232:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107235:	c9                   	leave  
c0107236:	c3                   	ret    

c0107237 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107237:	55                   	push   %ebp
c0107238:	89 e5                	mov    %esp,%ebp
c010723a:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c010723d:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107244:	e8 83 ec ff ff       	call   c0105ecc <kmalloc>
c0107249:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c010724c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107250:	74 1b                	je     c010726d <vma_create+0x36>
        vma->vm_start = vm_start;
c0107252:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107255:	8b 55 08             	mov    0x8(%ebp),%edx
c0107258:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c010725b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010725e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107261:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107264:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107267:	8b 55 10             	mov    0x10(%ebp),%edx
c010726a:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c010726d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107270:	c9                   	leave  
c0107271:	c3                   	ret    

c0107272 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107272:	55                   	push   %ebp
c0107273:	89 e5                	mov    %esp,%ebp
c0107275:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107278:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c010727f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107283:	0f 84 95 00 00 00    	je     c010731e <find_vma+0xac>
        vma = mm->mmap_cache;
c0107289:	8b 45 08             	mov    0x8(%ebp),%eax
c010728c:	8b 40 08             	mov    0x8(%eax),%eax
c010728f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0107292:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107296:	74 16                	je     c01072ae <find_vma+0x3c>
c0107298:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010729b:	8b 40 04             	mov    0x4(%eax),%eax
c010729e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01072a1:	77 0b                	ja     c01072ae <find_vma+0x3c>
c01072a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01072a6:	8b 40 08             	mov    0x8(%eax),%eax
c01072a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01072ac:	77 61                	ja     c010730f <find_vma+0x9d>
                bool found = 0;
c01072ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c01072b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01072b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01072bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072be:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c01072c1:	eb 28                	jmp    c01072eb <find_vma+0x79>
                    vma = le2vma(le, list_link);
c01072c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072c6:	83 e8 10             	sub    $0x10,%eax
c01072c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01072cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01072cf:	8b 40 04             	mov    0x4(%eax),%eax
c01072d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01072d5:	77 14                	ja     c01072eb <find_vma+0x79>
c01072d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01072da:	8b 40 08             	mov    0x8(%eax),%eax
c01072dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01072e0:	76 09                	jbe    c01072eb <find_vma+0x79>
                        found = 1;
c01072e2:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c01072e9:	eb 17                	jmp    c0107302 <find_vma+0x90>
c01072eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01072f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01072f4:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c01072f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01072fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107300:	75 c1                	jne    c01072c3 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107302:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107306:	75 07                	jne    c010730f <find_vma+0x9d>
                    vma = NULL;
c0107308:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c010730f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107313:	74 09                	je     c010731e <find_vma+0xac>
            mm->mmap_cache = vma;
c0107315:	8b 45 08             	mov    0x8(%ebp),%eax
c0107318:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010731b:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c010731e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107321:	c9                   	leave  
c0107322:	c3                   	ret    

c0107323 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107323:	55                   	push   %ebp
c0107324:	89 e5                	mov    %esp,%ebp
c0107326:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107329:	8b 45 08             	mov    0x8(%ebp),%eax
c010732c:	8b 50 04             	mov    0x4(%eax),%edx
c010732f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107332:	8b 40 08             	mov    0x8(%eax),%eax
c0107335:	39 c2                	cmp    %eax,%edx
c0107337:	72 24                	jb     c010735d <check_vma_overlap+0x3a>
c0107339:	c7 44 24 0c e5 a5 10 	movl   $0xc010a5e5,0xc(%esp)
c0107340:	c0 
c0107341:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107348:	c0 
c0107349:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0107350:	00 
c0107351:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107358:	e8 84 99 ff ff       	call   c0100ce1 <__panic>
    assert(prev->vm_end <= next->vm_start);
c010735d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107360:	8b 50 08             	mov    0x8(%eax),%edx
c0107363:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107366:	8b 40 04             	mov    0x4(%eax),%eax
c0107369:	39 c2                	cmp    %eax,%edx
c010736b:	76 24                	jbe    c0107391 <check_vma_overlap+0x6e>
c010736d:	c7 44 24 0c 28 a6 10 	movl   $0xc010a628,0xc(%esp)
c0107374:	c0 
c0107375:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c010737c:	c0 
c010737d:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0107384:	00 
c0107385:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c010738c:	e8 50 99 ff ff       	call   c0100ce1 <__panic>
    assert(next->vm_start < next->vm_end);
c0107391:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107394:	8b 50 04             	mov    0x4(%eax),%edx
c0107397:	8b 45 0c             	mov    0xc(%ebp),%eax
c010739a:	8b 40 08             	mov    0x8(%eax),%eax
c010739d:	39 c2                	cmp    %eax,%edx
c010739f:	72 24                	jb     c01073c5 <check_vma_overlap+0xa2>
c01073a1:	c7 44 24 0c 47 a6 10 	movl   $0xc010a647,0xc(%esp)
c01073a8:	c0 
c01073a9:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c01073b0:	c0 
c01073b1:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01073b8:	00 
c01073b9:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c01073c0:	e8 1c 99 ff ff       	call   c0100ce1 <__panic>
}
c01073c5:	c9                   	leave  
c01073c6:	c3                   	ret    

c01073c7 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c01073c7:	55                   	push   %ebp
c01073c8:	89 e5                	mov    %esp,%ebp
c01073ca:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c01073cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073d0:	8b 50 04             	mov    0x4(%eax),%edx
c01073d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073d6:	8b 40 08             	mov    0x8(%eax),%eax
c01073d9:	39 c2                	cmp    %eax,%edx
c01073db:	72 24                	jb     c0107401 <insert_vma_struct+0x3a>
c01073dd:	c7 44 24 0c 65 a6 10 	movl   $0xc010a665,0xc(%esp)
c01073e4:	c0 
c01073e5:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c01073ec:	c0 
c01073ed:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01073f4:	00 
c01073f5:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c01073fc:	e8 e0 98 ff ff       	call   c0100ce1 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107401:	8b 45 08             	mov    0x8(%ebp),%eax
c0107404:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0107407:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010740a:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c010740d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107410:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107413:	eb 21                	jmp    c0107436 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0107415:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107418:	83 e8 10             	sub    $0x10,%eax
c010741b:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c010741e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107421:	8b 50 04             	mov    0x4(%eax),%edx
c0107424:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107427:	8b 40 04             	mov    0x4(%eax),%eax
c010742a:	39 c2                	cmp    %eax,%edx
c010742c:	76 02                	jbe    c0107430 <insert_vma_struct+0x69>
                break;
c010742e:	eb 1d                	jmp    c010744d <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107430:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107433:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107436:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107439:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010743c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010743f:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107442:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107445:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107448:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010744b:	75 c8                	jne    c0107415 <insert_vma_struct+0x4e>
c010744d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107450:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107453:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107456:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0107459:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c010745c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010745f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107462:	74 15                	je     c0107479 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0107464:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107467:	8d 50 f0             	lea    -0x10(%eax),%edx
c010746a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010746d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107471:	89 14 24             	mov    %edx,(%esp)
c0107474:	e8 aa fe ff ff       	call   c0107323 <check_vma_overlap>
    }
    if (le_next != list) {
c0107479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010747c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010747f:	74 15                	je     c0107496 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0107481:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107484:	83 e8 10             	sub    $0x10,%eax
c0107487:	89 44 24 04          	mov    %eax,0x4(%esp)
c010748b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010748e:	89 04 24             	mov    %eax,(%esp)
c0107491:	e8 8d fe ff ff       	call   c0107323 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0107496:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107499:	8b 55 08             	mov    0x8(%ebp),%edx
c010749c:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c010749e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074a1:	8d 50 10             	lea    0x10(%eax),%edx
c01074a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01074aa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01074ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01074b0:	8b 40 04             	mov    0x4(%eax),%eax
c01074b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01074b6:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01074b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01074bc:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01074bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01074c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01074c5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01074c8:	89 10                	mov    %edx,(%eax)
c01074ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01074cd:	8b 10                	mov    (%eax),%edx
c01074cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01074d2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01074d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01074d8:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01074db:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01074de:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01074e1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01074e4:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c01074e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01074e9:	8b 40 10             	mov    0x10(%eax),%eax
c01074ec:	8d 50 01             	lea    0x1(%eax),%edx
c01074ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01074f2:	89 50 10             	mov    %edx,0x10(%eax)
}
c01074f5:	c9                   	leave  
c01074f6:	c3                   	ret    

c01074f7 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c01074f7:	55                   	push   %ebp
c01074f8:	89 e5                	mov    %esp,%ebp
c01074fa:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c01074fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0107500:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107503:	eb 3e                	jmp    c0107543 <mm_destroy+0x4c>
c0107505:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107508:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010750b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010750e:	8b 40 04             	mov    0x4(%eax),%eax
c0107511:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107514:	8b 12                	mov    (%edx),%edx
c0107516:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010751c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010751f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107522:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107528:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010752b:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c010752d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107530:	83 e8 10             	sub    $0x10,%eax
c0107533:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c010753a:	00 
c010753b:	89 04 24             	mov    %eax,(%esp)
c010753e:	e8 29 ea ff ff       	call   c0105f6c <kfree>
c0107543:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107546:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107549:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010754c:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c010754f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107552:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107555:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107558:	75 ab                	jne    c0107505 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c010755a:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0107561:	00 
c0107562:	8b 45 08             	mov    0x8(%ebp),%eax
c0107565:	89 04 24             	mov    %eax,(%esp)
c0107568:	e8 ff e9 ff ff       	call   c0105f6c <kfree>
    mm=NULL;
c010756d:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0107574:	c9                   	leave  
c0107575:	c3                   	ret    

c0107576 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0107576:	55                   	push   %ebp
c0107577:	89 e5                	mov    %esp,%ebp
c0107579:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c010757c:	e8 02 00 00 00       	call   c0107583 <check_vmm>
}
c0107581:	c9                   	leave  
c0107582:	c3                   	ret    

c0107583 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0107583:	55                   	push   %ebp
c0107584:	89 e5                	mov    %esp,%ebp
c0107586:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107589:	e8 31 d2 ff ff       	call   c01047bf <nr_free_pages>
c010758e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0107591:	e8 41 00 00 00       	call   c01075d7 <check_vma_struct>
    check_pgfault();
c0107596:	e8 03 05 00 00       	call   c0107a9e <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c010759b:	e8 1f d2 ff ff       	call   c01047bf <nr_free_pages>
c01075a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01075a3:	74 24                	je     c01075c9 <check_vmm+0x46>
c01075a5:	c7 44 24 0c 84 a6 10 	movl   $0xc010a684,0xc(%esp)
c01075ac:	c0 
c01075ad:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c01075b4:	c0 
c01075b5:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c01075bc:	00 
c01075bd:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c01075c4:	e8 18 97 ff ff       	call   c0100ce1 <__panic>

    cprintf("check_vmm() succeeded.\n");
c01075c9:	c7 04 24 ab a6 10 c0 	movl   $0xc010a6ab,(%esp)
c01075d0:	e8 82 8d ff ff       	call   c0100357 <cprintf>
}
c01075d5:	c9                   	leave  
c01075d6:	c3                   	ret    

c01075d7 <check_vma_struct>:

static void
check_vma_struct(void) {
c01075d7:	55                   	push   %ebp
c01075d8:	89 e5                	mov    %esp,%ebp
c01075da:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01075dd:	e8 dd d1 ff ff       	call   c01047bf <nr_free_pages>
c01075e2:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01075e5:	e8 d5 fb ff ff       	call   c01071bf <mm_create>
c01075ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01075ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01075f1:	75 24                	jne    c0107617 <check_vma_struct+0x40>
c01075f3:	c7 44 24 0c c3 a6 10 	movl   $0xc010a6c3,0xc(%esp)
c01075fa:	c0 
c01075fb:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107602:	c0 
c0107603:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c010760a:	00 
c010760b:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107612:	e8 ca 96 ff ff       	call   c0100ce1 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107617:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c010761e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107621:	89 d0                	mov    %edx,%eax
c0107623:	c1 e0 02             	shl    $0x2,%eax
c0107626:	01 d0                	add    %edx,%eax
c0107628:	01 c0                	add    %eax,%eax
c010762a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c010762d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107630:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107633:	eb 70                	jmp    c01076a5 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107635:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107638:	89 d0                	mov    %edx,%eax
c010763a:	c1 e0 02             	shl    $0x2,%eax
c010763d:	01 d0                	add    %edx,%eax
c010763f:	83 c0 02             	add    $0x2,%eax
c0107642:	89 c1                	mov    %eax,%ecx
c0107644:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107647:	89 d0                	mov    %edx,%eax
c0107649:	c1 e0 02             	shl    $0x2,%eax
c010764c:	01 d0                	add    %edx,%eax
c010764e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107655:	00 
c0107656:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010765a:	89 04 24             	mov    %eax,(%esp)
c010765d:	e8 d5 fb ff ff       	call   c0107237 <vma_create>
c0107662:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107665:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107669:	75 24                	jne    c010768f <check_vma_struct+0xb8>
c010766b:	c7 44 24 0c ce a6 10 	movl   $0xc010a6ce,0xc(%esp)
c0107672:	c0 
c0107673:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c010767a:	c0 
c010767b:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0107682:	00 
c0107683:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c010768a:	e8 52 96 ff ff       	call   c0100ce1 <__panic>
        insert_vma_struct(mm, vma);
c010768f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107692:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107696:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107699:	89 04 24             	mov    %eax,(%esp)
c010769c:	e8 26 fd ff ff       	call   c01073c7 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c01076a1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01076a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01076a9:	7f 8a                	jg     c0107635 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01076ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01076ae:	83 c0 01             	add    $0x1,%eax
c01076b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01076b4:	eb 70                	jmp    c0107726 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01076b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01076b9:	89 d0                	mov    %edx,%eax
c01076bb:	c1 e0 02             	shl    $0x2,%eax
c01076be:	01 d0                	add    %edx,%eax
c01076c0:	83 c0 02             	add    $0x2,%eax
c01076c3:	89 c1                	mov    %eax,%ecx
c01076c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01076c8:	89 d0                	mov    %edx,%eax
c01076ca:	c1 e0 02             	shl    $0x2,%eax
c01076cd:	01 d0                	add    %edx,%eax
c01076cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01076d6:	00 
c01076d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01076db:	89 04 24             	mov    %eax,(%esp)
c01076de:	e8 54 fb ff ff       	call   c0107237 <vma_create>
c01076e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c01076e6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01076ea:	75 24                	jne    c0107710 <check_vma_struct+0x139>
c01076ec:	c7 44 24 0c ce a6 10 	movl   $0xc010a6ce,0xc(%esp)
c01076f3:	c0 
c01076f4:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c01076fb:	c0 
c01076fc:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0107703:	00 
c0107704:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c010770b:	e8 d1 95 ff ff       	call   c0100ce1 <__panic>
        insert_vma_struct(mm, vma);
c0107710:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107713:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107717:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010771a:	89 04 24             	mov    %eax,(%esp)
c010771d:	e8 a5 fc ff ff       	call   c01073c7 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107722:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107726:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107729:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010772c:	7e 88                	jle    c01076b6 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c010772e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107731:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107734:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107737:	8b 40 04             	mov    0x4(%eax),%eax
c010773a:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c010773d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107744:	e9 97 00 00 00       	jmp    c01077e0 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107749:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010774c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010774f:	75 24                	jne    c0107775 <check_vma_struct+0x19e>
c0107751:	c7 44 24 0c da a6 10 	movl   $0xc010a6da,0xc(%esp)
c0107758:	c0 
c0107759:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107760:	c0 
c0107761:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0107768:	00 
c0107769:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107770:	e8 6c 95 ff ff       	call   c0100ce1 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107775:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107778:	83 e8 10             	sub    $0x10,%eax
c010777b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c010777e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107781:	8b 48 04             	mov    0x4(%eax),%ecx
c0107784:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107787:	89 d0                	mov    %edx,%eax
c0107789:	c1 e0 02             	shl    $0x2,%eax
c010778c:	01 d0                	add    %edx,%eax
c010778e:	39 c1                	cmp    %eax,%ecx
c0107790:	75 17                	jne    c01077a9 <check_vma_struct+0x1d2>
c0107792:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107795:	8b 48 08             	mov    0x8(%eax),%ecx
c0107798:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010779b:	89 d0                	mov    %edx,%eax
c010779d:	c1 e0 02             	shl    $0x2,%eax
c01077a0:	01 d0                	add    %edx,%eax
c01077a2:	83 c0 02             	add    $0x2,%eax
c01077a5:	39 c1                	cmp    %eax,%ecx
c01077a7:	74 24                	je     c01077cd <check_vma_struct+0x1f6>
c01077a9:	c7 44 24 0c f4 a6 10 	movl   $0xc010a6f4,0xc(%esp)
c01077b0:	c0 
c01077b1:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c01077b8:	c0 
c01077b9:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01077c0:	00 
c01077c1:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c01077c8:	e8 14 95 ff ff       	call   c0100ce1 <__panic>
c01077cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01077d0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01077d3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01077d6:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01077d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c01077dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01077e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077e3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01077e6:	0f 8e 5d ff ff ff    	jle    c0107749 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01077ec:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01077f3:	e9 cd 01 00 00       	jmp    c01079c5 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c01077f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01077ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107802:	89 04 24             	mov    %eax,(%esp)
c0107805:	e8 68 fa ff ff       	call   c0107272 <find_vma>
c010780a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c010780d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107811:	75 24                	jne    c0107837 <check_vma_struct+0x260>
c0107813:	c7 44 24 0c 29 a7 10 	movl   $0xc010a729,0xc(%esp)
c010781a:	c0 
c010781b:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107822:	c0 
c0107823:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c010782a:	00 
c010782b:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107832:	e8 aa 94 ff ff       	call   c0100ce1 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107837:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010783a:	83 c0 01             	add    $0x1,%eax
c010783d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107841:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107844:	89 04 24             	mov    %eax,(%esp)
c0107847:	e8 26 fa ff ff       	call   c0107272 <find_vma>
c010784c:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c010784f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107853:	75 24                	jne    c0107879 <check_vma_struct+0x2a2>
c0107855:	c7 44 24 0c 36 a7 10 	movl   $0xc010a736,0xc(%esp)
c010785c:	c0 
c010785d:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107864:	c0 
c0107865:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c010786c:	00 
c010786d:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107874:	e8 68 94 ff ff       	call   c0100ce1 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107879:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010787c:	83 c0 02             	add    $0x2,%eax
c010787f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107883:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107886:	89 04 24             	mov    %eax,(%esp)
c0107889:	e8 e4 f9 ff ff       	call   c0107272 <find_vma>
c010788e:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107891:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107895:	74 24                	je     c01078bb <check_vma_struct+0x2e4>
c0107897:	c7 44 24 0c 43 a7 10 	movl   $0xc010a743,0xc(%esp)
c010789e:	c0 
c010789f:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c01078a6:	c0 
c01078a7:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01078ae:	00 
c01078af:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c01078b6:	e8 26 94 ff ff       	call   c0100ce1 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01078bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078be:	83 c0 03             	add    $0x3,%eax
c01078c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01078c8:	89 04 24             	mov    %eax,(%esp)
c01078cb:	e8 a2 f9 ff ff       	call   c0107272 <find_vma>
c01078d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c01078d3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01078d7:	74 24                	je     c01078fd <check_vma_struct+0x326>
c01078d9:	c7 44 24 0c 50 a7 10 	movl   $0xc010a750,0xc(%esp)
c01078e0:	c0 
c01078e1:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c01078e8:	c0 
c01078e9:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c01078f0:	00 
c01078f1:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c01078f8:	e8 e4 93 ff ff       	call   c0100ce1 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c01078fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107900:	83 c0 04             	add    $0x4,%eax
c0107903:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107907:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010790a:	89 04 24             	mov    %eax,(%esp)
c010790d:	e8 60 f9 ff ff       	call   c0107272 <find_vma>
c0107912:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107915:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107919:	74 24                	je     c010793f <check_vma_struct+0x368>
c010791b:	c7 44 24 0c 5d a7 10 	movl   $0xc010a75d,0xc(%esp)
c0107922:	c0 
c0107923:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c010792a:	c0 
c010792b:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0107932:	00 
c0107933:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c010793a:	e8 a2 93 ff ff       	call   c0100ce1 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c010793f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107942:	8b 50 04             	mov    0x4(%eax),%edx
c0107945:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107948:	39 c2                	cmp    %eax,%edx
c010794a:	75 10                	jne    c010795c <check_vma_struct+0x385>
c010794c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010794f:	8b 50 08             	mov    0x8(%eax),%edx
c0107952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107955:	83 c0 02             	add    $0x2,%eax
c0107958:	39 c2                	cmp    %eax,%edx
c010795a:	74 24                	je     c0107980 <check_vma_struct+0x3a9>
c010795c:	c7 44 24 0c 6c a7 10 	movl   $0xc010a76c,0xc(%esp)
c0107963:	c0 
c0107964:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c010796b:	c0 
c010796c:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107973:	00 
c0107974:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c010797b:	e8 61 93 ff ff       	call   c0100ce1 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0107980:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107983:	8b 50 04             	mov    0x4(%eax),%edx
c0107986:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107989:	39 c2                	cmp    %eax,%edx
c010798b:	75 10                	jne    c010799d <check_vma_struct+0x3c6>
c010798d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107990:	8b 50 08             	mov    0x8(%eax),%edx
c0107993:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107996:	83 c0 02             	add    $0x2,%eax
c0107999:	39 c2                	cmp    %eax,%edx
c010799b:	74 24                	je     c01079c1 <check_vma_struct+0x3ea>
c010799d:	c7 44 24 0c 9c a7 10 	movl   $0xc010a79c,0xc(%esp)
c01079a4:	c0 
c01079a5:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c01079ac:	c0 
c01079ad:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01079b4:	00 
c01079b5:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c01079bc:	e8 20 93 ff ff       	call   c0100ce1 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01079c1:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c01079c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01079c8:	89 d0                	mov    %edx,%eax
c01079ca:	c1 e0 02             	shl    $0x2,%eax
c01079cd:	01 d0                	add    %edx,%eax
c01079cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01079d2:	0f 8d 20 fe ff ff    	jge    c01077f8 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01079d8:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01079df:	eb 70                	jmp    c0107a51 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01079e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01079e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079eb:	89 04 24             	mov    %eax,(%esp)
c01079ee:	e8 7f f8 ff ff       	call   c0107272 <find_vma>
c01079f3:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c01079f6:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01079fa:	74 27                	je     c0107a23 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c01079fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01079ff:	8b 50 08             	mov    0x8(%eax),%edx
c0107a02:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107a05:	8b 40 04             	mov    0x4(%eax),%eax
c0107a08:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107a0c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a17:	c7 04 24 cc a7 10 c0 	movl   $0xc010a7cc,(%esp)
c0107a1e:	e8 34 89 ff ff       	call   c0100357 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107a23:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107a27:	74 24                	je     c0107a4d <check_vma_struct+0x476>
c0107a29:	c7 44 24 0c f1 a7 10 	movl   $0xc010a7f1,0xc(%esp)
c0107a30:	c0 
c0107a31:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107a38:	c0 
c0107a39:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0107a40:	00 
c0107a41:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107a48:	e8 94 92 ff ff       	call   c0100ce1 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107a4d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107a51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107a55:	79 8a                	jns    c01079e1 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0107a57:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a5a:	89 04 24             	mov    %eax,(%esp)
c0107a5d:	e8 95 fa ff ff       	call   c01074f7 <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c0107a62:	e8 58 cd ff ff       	call   c01047bf <nr_free_pages>
c0107a67:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107a6a:	74 24                	je     c0107a90 <check_vma_struct+0x4b9>
c0107a6c:	c7 44 24 0c 84 a6 10 	movl   $0xc010a684,0xc(%esp)
c0107a73:	c0 
c0107a74:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107a7b:	c0 
c0107a7c:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0107a83:	00 
c0107a84:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107a8b:	e8 51 92 ff ff       	call   c0100ce1 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0107a90:	c7 04 24 08 a8 10 c0 	movl   $0xc010a808,(%esp)
c0107a97:	e8 bb 88 ff ff       	call   c0100357 <cprintf>
}
c0107a9c:	c9                   	leave  
c0107a9d:	c3                   	ret    

c0107a9e <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107a9e:	55                   	push   %ebp
c0107a9f:	89 e5                	mov    %esp,%ebp
c0107aa1:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107aa4:	e8 16 cd ff ff       	call   c01047bf <nr_free_pages>
c0107aa9:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107aac:	e8 0e f7 ff ff       	call   c01071bf <mm_create>
c0107ab1:	a3 2c 41 12 c0       	mov    %eax,0xc012412c
    assert(check_mm_struct != NULL);
c0107ab6:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c0107abb:	85 c0                	test   %eax,%eax
c0107abd:	75 24                	jne    c0107ae3 <check_pgfault+0x45>
c0107abf:	c7 44 24 0c 27 a8 10 	movl   $0xc010a827,0xc(%esp)
c0107ac6:	c0 
c0107ac7:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107ace:	c0 
c0107acf:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0107ad6:	00 
c0107ad7:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107ade:	e8 fe 91 ff ff       	call   c0100ce1 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107ae3:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c0107ae8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107aeb:	8b 15 e0 09 12 c0    	mov    0xc01209e0,%edx
c0107af1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107af4:	89 50 0c             	mov    %edx,0xc(%eax)
c0107af7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107afa:	8b 40 0c             	mov    0xc(%eax),%eax
c0107afd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107b00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b03:	8b 00                	mov    (%eax),%eax
c0107b05:	85 c0                	test   %eax,%eax
c0107b07:	74 24                	je     c0107b2d <check_pgfault+0x8f>
c0107b09:	c7 44 24 0c 3f a8 10 	movl   $0xc010a83f,0xc(%esp)
c0107b10:	c0 
c0107b11:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107b18:	c0 
c0107b19:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107b20:	00 
c0107b21:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107b28:	e8 b4 91 ff ff       	call   c0100ce1 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107b2d:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107b34:	00 
c0107b35:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107b3c:	00 
c0107b3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107b44:	e8 ee f6 ff ff       	call   c0107237 <vma_create>
c0107b49:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107b4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107b50:	75 24                	jne    c0107b76 <check_pgfault+0xd8>
c0107b52:	c7 44 24 0c ce a6 10 	movl   $0xc010a6ce,0xc(%esp)
c0107b59:	c0 
c0107b5a:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107b61:	c0 
c0107b62:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107b69:	00 
c0107b6a:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107b71:	e8 6b 91 ff ff       	call   c0100ce1 <__panic>

    insert_vma_struct(mm, vma);
c0107b76:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107b79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b80:	89 04 24             	mov    %eax,(%esp)
c0107b83:	e8 3f f8 ff ff       	call   c01073c7 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107b88:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107b8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b96:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b99:	89 04 24             	mov    %eax,(%esp)
c0107b9c:	e8 d1 f6 ff ff       	call   c0107272 <find_vma>
c0107ba1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107ba4:	74 24                	je     c0107bca <check_pgfault+0x12c>
c0107ba6:	c7 44 24 0c 4d a8 10 	movl   $0xc010a84d,0xc(%esp)
c0107bad:	c0 
c0107bae:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107bb5:	c0 
c0107bb6:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0107bbd:	00 
c0107bbe:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107bc5:	e8 17 91 ff ff       	call   c0100ce1 <__panic>

    int i, sum = 0;
c0107bca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107bd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107bd8:	eb 17                	jmp    c0107bf1 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0107bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107bdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107be0:	01 d0                	add    %edx,%eax
c0107be2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107be5:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107bea:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107bed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107bf1:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107bf5:	7e e3                	jle    c0107bda <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107bf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107bfe:	eb 15                	jmp    c0107c15 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0107c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107c03:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107c06:	01 d0                	add    %edx,%eax
c0107c08:	0f b6 00             	movzbl (%eax),%eax
c0107c0b:	0f be c0             	movsbl %al,%eax
c0107c0e:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107c11:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107c15:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107c19:	7e e5                	jle    c0107c00 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0107c1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107c1f:	74 24                	je     c0107c45 <check_pgfault+0x1a7>
c0107c21:	c7 44 24 0c 67 a8 10 	movl   $0xc010a867,0xc(%esp)
c0107c28:	c0 
c0107c29:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107c30:	c0 
c0107c31:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0107c38:	00 
c0107c39:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107c40:	e8 9c 90 ff ff       	call   c0100ce1 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0107c45:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107c48:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107c4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107c4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107c53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c5a:	89 04 24             	mov    %eax,(%esp)
c0107c5d:	e8 91 d3 ff ff       	call   c0104ff3 <page_remove>
    free_page(pde2page(pgdir[0]));
c0107c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c65:	8b 00                	mov    (%eax),%eax
c0107c67:	89 04 24             	mov    %eax,(%esp)
c0107c6a:	e8 38 f5 ff ff       	call   c01071a7 <pde2page>
c0107c6f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107c76:	00 
c0107c77:	89 04 24             	mov    %eax,(%esp)
c0107c7a:	e8 0e cb ff ff       	call   c010478d <free_pages>
    pgdir[0] = 0;
c0107c7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107c88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c8b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0107c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c95:	89 04 24             	mov    %eax,(%esp)
c0107c98:	e8 5a f8 ff ff       	call   c01074f7 <mm_destroy>
    check_mm_struct = NULL;
c0107c9d:	c7 05 2c 41 12 c0 00 	movl   $0x0,0xc012412c
c0107ca4:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0107ca7:	e8 13 cb ff ff       	call   c01047bf <nr_free_pages>
c0107cac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107caf:	74 24                	je     c0107cd5 <check_pgfault+0x237>
c0107cb1:	c7 44 24 0c 84 a6 10 	movl   $0xc010a684,0xc(%esp)
c0107cb8:	c0 
c0107cb9:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0107cc0:	c0 
c0107cc1:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0107cc8:	00 
c0107cc9:	c7 04 24 18 a6 10 c0 	movl   $0xc010a618,(%esp)
c0107cd0:	e8 0c 90 ff ff       	call   c0100ce1 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0107cd5:	c7 04 24 70 a8 10 c0 	movl   $0xc010a870,(%esp)
c0107cdc:	e8 76 86 ff ff       	call   c0100357 <cprintf>
}
c0107ce1:	c9                   	leave  
c0107ce2:	c3                   	ret    

c0107ce3 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0107ce3:	55                   	push   %ebp
c0107ce4:	89 e5                	mov    %esp,%ebp
c0107ce6:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0107ce9:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0107cf0:	8b 45 10             	mov    0x10(%ebp),%eax
c0107cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cfa:	89 04 24             	mov    %eax,(%esp)
c0107cfd:	e8 70 f5 ff ff       	call   c0107272 <find_vma>
c0107d02:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0107d05:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0107d0a:	83 c0 01             	add    $0x1,%eax
c0107d0d:	a3 38 40 12 c0       	mov    %eax,0xc0124038
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0107d12:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107d16:	74 0b                	je     c0107d23 <do_pgfault+0x40>
c0107d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d1b:	8b 40 04             	mov    0x4(%eax),%eax
c0107d1e:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107d21:	76 18                	jbe    c0107d3b <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0107d23:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d2a:	c7 04 24 8c a8 10 c0 	movl   $0xc010a88c,(%esp)
c0107d31:	e8 21 86 ff ff       	call   c0100357 <cprintf>
        goto failed;
c0107d36:	e9 bb 01 00 00       	jmp    c0107ef6 <do_pgfault+0x213>
    }
    //check the error_code
    switch (error_code & 3) {
c0107d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107d3e:	83 e0 03             	and    $0x3,%eax
c0107d41:	85 c0                	test   %eax,%eax
c0107d43:	74 36                	je     c0107d7b <do_pgfault+0x98>
c0107d45:	83 f8 01             	cmp    $0x1,%eax
c0107d48:	74 20                	je     c0107d6a <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0107d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d4d:	8b 40 0c             	mov    0xc(%eax),%eax
c0107d50:	83 e0 02             	and    $0x2,%eax
c0107d53:	85 c0                	test   %eax,%eax
c0107d55:	75 11                	jne    c0107d68 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0107d57:	c7 04 24 bc a8 10 c0 	movl   $0xc010a8bc,(%esp)
c0107d5e:	e8 f4 85 ff ff       	call   c0100357 <cprintf>
            goto failed;
c0107d63:	e9 8e 01 00 00       	jmp    c0107ef6 <do_pgfault+0x213>
        }
        break;
c0107d68:	eb 2f                	jmp    c0107d99 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0107d6a:	c7 04 24 1c a9 10 c0 	movl   $0xc010a91c,(%esp)
c0107d71:	e8 e1 85 ff ff       	call   c0100357 <cprintf>
        goto failed;
c0107d76:	e9 7b 01 00 00       	jmp    c0107ef6 <do_pgfault+0x213>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0107d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d7e:	8b 40 0c             	mov    0xc(%eax),%eax
c0107d81:	83 e0 05             	and    $0x5,%eax
c0107d84:	85 c0                	test   %eax,%eax
c0107d86:	75 11                	jne    c0107d99 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0107d88:	c7 04 24 54 a9 10 c0 	movl   $0xc010a954,(%esp)
c0107d8f:	e8 c3 85 ff ff       	call   c0100357 <cprintf>
            goto failed;
c0107d94:	e9 5d 01 00 00       	jmp    c0107ef6 <do_pgfault+0x213>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0107d99:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0107da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107da3:	8b 40 0c             	mov    0xc(%eax),%eax
c0107da6:	83 e0 02             	and    $0x2,%eax
c0107da9:	85 c0                	test   %eax,%eax
c0107dab:	74 04                	je     c0107db1 <do_pgfault+0xce>
        perm |= PTE_W;
c0107dad:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0107db1:	8b 45 10             	mov    0x10(%ebp),%eax
c0107db4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107dba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107dbf:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0107dc2:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0107dc9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        }
   }
#endif

    /*LAB3 EXERCISE 1: YOUR CODE*/
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) { // 查找当前虚拟地址所对应的页表项
c0107dd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dd3:	8b 40 0c             	mov    0xc(%eax),%eax
c0107dd6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107ddd:	00 
c0107dde:	8b 55 10             	mov    0x10(%ebp),%edx
c0107de1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107de5:	89 04 24             	mov    %eax,(%esp)
c0107de8:	e8 14 d0 ff ff       	call   c0104e01 <get_pte>
c0107ded:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107df0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107df4:	75 11                	jne    c0107e07 <do_pgfault+0x124>
        cprintf("get_pte in do_pgfault failed\n");
c0107df6:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c0107dfd:	e8 55 85 ff ff       	call   c0100357 <cprintf>
        goto failed;
c0107e02:	e9 ef 00 00 00       	jmp    c0107ef6 <do_pgfault+0x213>
    }
    
    if (*ptep == 0) { // 如果这个页表项所对应的物理页不存在，则分配一块物理页，并设置页表项
c0107e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e0a:	8b 00                	mov    (%eax),%eax
c0107e0c:	85 c0                	test   %eax,%eax
c0107e0e:	75 35                	jne    c0107e45 <do_pgfault+0x162>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0107e10:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e13:	8b 40 0c             	mov    0xc(%eax),%eax
c0107e16:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107e19:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107e1d:	8b 55 10             	mov    0x10(%ebp),%edx
c0107e20:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e24:	89 04 24             	mov    %eax,(%esp)
c0107e27:	e8 21 d3 ff ff       	call   c010514d <pgdir_alloc_page>
c0107e2c:	85 c0                	test   %eax,%eax
c0107e2e:	0f 85 bb 00 00 00    	jne    c0107eef <do_pgfault+0x20c>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
c0107e34:	c7 04 24 d8 a9 10 c0 	movl   $0xc010a9d8,(%esp)
c0107e3b:	e8 17 85 ff ff       	call   c0100357 <cprintf>
            goto failed;
c0107e40:	e9 b1 00 00 00       	jmp    c0107ef6 <do_pgfault+0x213>
        }
    }
    else { // 如果这个页表项所对应的物理页存在，但不在内存中
           // 如果swap已经初始化完成
        if(swap_init_ok) { // 将目标数据加载到某块新的物理页中。将目标数据加载到某块新的物理页中
c0107e45:	a1 2c 40 12 c0       	mov    0xc012402c,%eax
c0107e4a:	85 c0                	test   %eax,%eax
c0107e4c:	0f 84 86 00 00 00    	je     c0107ed8 <do_pgfault+0x1f5>
	    // 该物理页可能是尚未分配的物理页，也可能是从别的已分配物理页中取的
            struct Page *page=NULL;
c0107e52:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            if ((ret = swap_in(mm, addr, &page)) != 0) {
c0107e59:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0107e5c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e60:	8b 45 10             	mov    0x10(%ebp),%eax
c0107e63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e67:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e6a:	89 04 24             	mov    %eax,(%esp)
c0107e6d:	e8 a0 e4 ff ff       	call   c0106312 <swap_in>
c0107e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107e75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107e79:	74 0e                	je     c0107e89 <do_pgfault+0x1a6>
                cprintf("swap_in in do_pgfault failed\n");
c0107e7b:	c7 04 24 ff a9 10 c0 	movl   $0xc010a9ff,(%esp)
c0107e82:	e8 d0 84 ff ff       	call   c0100357 <cprintf>
c0107e87:	eb 6d                	jmp    c0107ef6 <do_pgfault+0x213>
                goto failed;
            }    
	    // 将该物理页与对应的虚拟地址关联，同时设置页表。
	    // 当前缺失的页已经加载回内存中，所以设置当前页为可swap。
            page_insert(mm->pgdir, page, addr, perm);
c0107e89:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107e8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e8f:	8b 40 0c             	mov    0xc(%eax),%eax
c0107e92:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107e95:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0107e99:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0107e9c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0107ea0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107ea4:	89 04 24             	mov    %eax,(%esp)
c0107ea7:	e8 8b d1 ff ff       	call   c0105037 <page_insert>
            swap_map_swappable(mm, addr, page, 1);
c0107eac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107eaf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0107eb6:	00 
c0107eb7:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107ebb:	8b 45 10             	mov    0x10(%ebp),%eax
c0107ebe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ec2:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ec5:	89 04 24             	mov    %eax,(%esp)
c0107ec8:	e8 7c e2 ff ff       	call   c0106149 <swap_map_swappable>
            page->pra_vaddr = addr;
c0107ecd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107ed0:	8b 55 10             	mov    0x10(%ebp),%edx
c0107ed3:	89 50 1c             	mov    %edx,0x1c(%eax)
c0107ed6:	eb 17                	jmp    c0107eef <do_pgfault+0x20c>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0107ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107edb:	8b 00                	mov    (%eax),%eax
c0107edd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ee1:	c7 04 24 20 aa 10 c0 	movl   $0xc010aa20,(%esp)
c0107ee8:	e8 6a 84 ff ff       	call   c0100357 <cprintf>
            goto failed;
c0107eed:	eb 07                	jmp    c0107ef6 <do_pgfault+0x213>
        }
   }
   ret = 0;
c0107eef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0107ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107ef9:	c9                   	leave  
c0107efa:	c3                   	ret    

c0107efb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0107efb:	55                   	push   %ebp
c0107efc:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0107efe:	8b 55 08             	mov    0x8(%ebp),%edx
c0107f01:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c0107f06:	29 c2                	sub    %eax,%edx
c0107f08:	89 d0                	mov    %edx,%eax
c0107f0a:	c1 f8 05             	sar    $0x5,%eax
}
c0107f0d:	5d                   	pop    %ebp
c0107f0e:	c3                   	ret    

c0107f0f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0107f0f:	55                   	push   %ebp
c0107f10:	89 e5                	mov    %esp,%ebp
c0107f12:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0107f15:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f18:	89 04 24             	mov    %eax,(%esp)
c0107f1b:	e8 db ff ff ff       	call   c0107efb <page2ppn>
c0107f20:	c1 e0 0c             	shl    $0xc,%eax
}
c0107f23:	c9                   	leave  
c0107f24:	c3                   	ret    

c0107f25 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0107f25:	55                   	push   %ebp
c0107f26:	89 e5                	mov    %esp,%ebp
c0107f28:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0107f2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f2e:	89 04 24             	mov    %eax,(%esp)
c0107f31:	e8 d9 ff ff ff       	call   c0107f0f <page2pa>
c0107f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f3c:	c1 e8 0c             	shr    $0xc,%eax
c0107f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107f42:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0107f47:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107f4a:	72 23                	jb     c0107f6f <page2kva+0x4a>
c0107f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107f53:	c7 44 24 08 48 aa 10 	movl   $0xc010aa48,0x8(%esp)
c0107f5a:	c0 
c0107f5b:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0107f62:	00 
c0107f63:	c7 04 24 6b aa 10 c0 	movl   $0xc010aa6b,(%esp)
c0107f6a:	e8 72 8d ff ff       	call   c0100ce1 <__panic>
c0107f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f72:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0107f77:	c9                   	leave  
c0107f78:	c3                   	ret    

c0107f79 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0107f79:	55                   	push   %ebp
c0107f7a:	89 e5                	mov    %esp,%ebp
c0107f7c:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0107f7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107f86:	e8 b7 9a ff ff       	call   c0101a42 <ide_device_valid>
c0107f8b:	85 c0                	test   %eax,%eax
c0107f8d:	75 1c                	jne    c0107fab <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0107f8f:	c7 44 24 08 79 aa 10 	movl   $0xc010aa79,0x8(%esp)
c0107f96:	c0 
c0107f97:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0107f9e:	00 
c0107f9f:	c7 04 24 93 aa 10 c0 	movl   $0xc010aa93,(%esp)
c0107fa6:	e8 36 8d ff ff       	call   c0100ce1 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0107fab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107fb2:	e8 ca 9a ff ff       	call   c0101a81 <ide_device_size>
c0107fb7:	c1 e8 03             	shr    $0x3,%eax
c0107fba:	a3 fc 40 12 c0       	mov    %eax,0xc01240fc
}
c0107fbf:	c9                   	leave  
c0107fc0:	c3                   	ret    

c0107fc1 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0107fc1:	55                   	push   %ebp
c0107fc2:	89 e5                	mov    %esp,%ebp
c0107fc4:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fca:	89 04 24             	mov    %eax,(%esp)
c0107fcd:	e8 53 ff ff ff       	call   c0107f25 <page2kva>
c0107fd2:	8b 55 08             	mov    0x8(%ebp),%edx
c0107fd5:	c1 ea 08             	shr    $0x8,%edx
c0107fd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107fdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107fdf:	74 0b                	je     c0107fec <swapfs_read+0x2b>
c0107fe1:	8b 15 fc 40 12 c0    	mov    0xc01240fc,%edx
c0107fe7:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107fea:	72 23                	jb     c010800f <swapfs_read+0x4e>
c0107fec:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fef:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107ff3:	c7 44 24 08 a4 aa 10 	movl   $0xc010aaa4,0x8(%esp)
c0107ffa:	c0 
c0107ffb:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108002:	00 
c0108003:	c7 04 24 93 aa 10 c0 	movl   $0xc010aa93,(%esp)
c010800a:	e8 d2 8c ff ff       	call   c0100ce1 <__panic>
c010800f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108012:	c1 e2 03             	shl    $0x3,%edx
c0108015:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010801c:	00 
c010801d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108021:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108025:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010802c:	e8 8f 9a ff ff       	call   c0101ac0 <ide_read_secs>
}
c0108031:	c9                   	leave  
c0108032:	c3                   	ret    

c0108033 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0108033:	55                   	push   %ebp
c0108034:	89 e5                	mov    %esp,%ebp
c0108036:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108039:	8b 45 0c             	mov    0xc(%ebp),%eax
c010803c:	89 04 24             	mov    %eax,(%esp)
c010803f:	e8 e1 fe ff ff       	call   c0107f25 <page2kva>
c0108044:	8b 55 08             	mov    0x8(%ebp),%edx
c0108047:	c1 ea 08             	shr    $0x8,%edx
c010804a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010804d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108051:	74 0b                	je     c010805e <swapfs_write+0x2b>
c0108053:	8b 15 fc 40 12 c0    	mov    0xc01240fc,%edx
c0108059:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010805c:	72 23                	jb     c0108081 <swapfs_write+0x4e>
c010805e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108061:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108065:	c7 44 24 08 a4 aa 10 	movl   $0xc010aaa4,0x8(%esp)
c010806c:	c0 
c010806d:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0108074:	00 
c0108075:	c7 04 24 93 aa 10 c0 	movl   $0xc010aa93,(%esp)
c010807c:	e8 60 8c ff ff       	call   c0100ce1 <__panic>
c0108081:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108084:	c1 e2 03             	shl    $0x3,%edx
c0108087:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010808e:	00 
c010808f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108093:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108097:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010809e:	e8 5f 9c ff ff       	call   c0101d02 <ide_write_secs>
}
c01080a3:	c9                   	leave  
c01080a4:	c3                   	ret    

c01080a5 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01080a5:	55                   	push   %ebp
c01080a6:	89 e5                	mov    %esp,%ebp
c01080a8:	83 ec 58             	sub    $0x58,%esp
c01080ab:	8b 45 10             	mov    0x10(%ebp),%eax
c01080ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01080b1:	8b 45 14             	mov    0x14(%ebp),%eax
c01080b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01080b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01080ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01080bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01080c0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01080c3:	8b 45 18             	mov    0x18(%ebp),%eax
c01080c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01080c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01080cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01080cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01080d2:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01080d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01080db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01080df:	74 1c                	je     c01080fd <printnum+0x58>
c01080e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080e4:	ba 00 00 00 00       	mov    $0x0,%edx
c01080e9:	f7 75 e4             	divl   -0x1c(%ebp)
c01080ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01080ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080f2:	ba 00 00 00 00       	mov    $0x0,%edx
c01080f7:	f7 75 e4             	divl   -0x1c(%ebp)
c01080fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01080fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108100:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108103:	f7 75 e4             	divl   -0x1c(%ebp)
c0108106:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108109:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010810c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010810f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108112:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108115:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108118:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010811b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010811e:	8b 45 18             	mov    0x18(%ebp),%eax
c0108121:	ba 00 00 00 00       	mov    $0x0,%edx
c0108126:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108129:	77 56                	ja     c0108181 <printnum+0xdc>
c010812b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010812e:	72 05                	jb     c0108135 <printnum+0x90>
c0108130:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0108133:	77 4c                	ja     c0108181 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0108135:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108138:	8d 50 ff             	lea    -0x1(%eax),%edx
c010813b:	8b 45 20             	mov    0x20(%ebp),%eax
c010813e:	89 44 24 18          	mov    %eax,0x18(%esp)
c0108142:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108146:	8b 45 18             	mov    0x18(%ebp),%eax
c0108149:	89 44 24 10          	mov    %eax,0x10(%esp)
c010814d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108150:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108153:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108157:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010815b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010815e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108162:	8b 45 08             	mov    0x8(%ebp),%eax
c0108165:	89 04 24             	mov    %eax,(%esp)
c0108168:	e8 38 ff ff ff       	call   c01080a5 <printnum>
c010816d:	eb 1c                	jmp    c010818b <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010816f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108172:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108176:	8b 45 20             	mov    0x20(%ebp),%eax
c0108179:	89 04 24             	mov    %eax,(%esp)
c010817c:	8b 45 08             	mov    0x8(%ebp),%eax
c010817f:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0108181:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0108185:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0108189:	7f e4                	jg     c010816f <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010818b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010818e:	05 44 ab 10 c0       	add    $0xc010ab44,%eax
c0108193:	0f b6 00             	movzbl (%eax),%eax
c0108196:	0f be c0             	movsbl %al,%eax
c0108199:	8b 55 0c             	mov    0xc(%ebp),%edx
c010819c:	89 54 24 04          	mov    %edx,0x4(%esp)
c01081a0:	89 04 24             	mov    %eax,(%esp)
c01081a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01081a6:	ff d0                	call   *%eax
}
c01081a8:	c9                   	leave  
c01081a9:	c3                   	ret    

c01081aa <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01081aa:	55                   	push   %ebp
c01081ab:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01081ad:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01081b1:	7e 14                	jle    c01081c7 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01081b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01081b6:	8b 00                	mov    (%eax),%eax
c01081b8:	8d 48 08             	lea    0x8(%eax),%ecx
c01081bb:	8b 55 08             	mov    0x8(%ebp),%edx
c01081be:	89 0a                	mov    %ecx,(%edx)
c01081c0:	8b 50 04             	mov    0x4(%eax),%edx
c01081c3:	8b 00                	mov    (%eax),%eax
c01081c5:	eb 30                	jmp    c01081f7 <getuint+0x4d>
    }
    else if (lflag) {
c01081c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01081cb:	74 16                	je     c01081e3 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01081cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01081d0:	8b 00                	mov    (%eax),%eax
c01081d2:	8d 48 04             	lea    0x4(%eax),%ecx
c01081d5:	8b 55 08             	mov    0x8(%ebp),%edx
c01081d8:	89 0a                	mov    %ecx,(%edx)
c01081da:	8b 00                	mov    (%eax),%eax
c01081dc:	ba 00 00 00 00       	mov    $0x0,%edx
c01081e1:	eb 14                	jmp    c01081f7 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01081e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01081e6:	8b 00                	mov    (%eax),%eax
c01081e8:	8d 48 04             	lea    0x4(%eax),%ecx
c01081eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01081ee:	89 0a                	mov    %ecx,(%edx)
c01081f0:	8b 00                	mov    (%eax),%eax
c01081f2:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01081f7:	5d                   	pop    %ebp
c01081f8:	c3                   	ret    

c01081f9 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01081f9:	55                   	push   %ebp
c01081fa:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01081fc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108200:	7e 14                	jle    c0108216 <getint+0x1d>
        return va_arg(*ap, long long);
c0108202:	8b 45 08             	mov    0x8(%ebp),%eax
c0108205:	8b 00                	mov    (%eax),%eax
c0108207:	8d 48 08             	lea    0x8(%eax),%ecx
c010820a:	8b 55 08             	mov    0x8(%ebp),%edx
c010820d:	89 0a                	mov    %ecx,(%edx)
c010820f:	8b 50 04             	mov    0x4(%eax),%edx
c0108212:	8b 00                	mov    (%eax),%eax
c0108214:	eb 28                	jmp    c010823e <getint+0x45>
    }
    else if (lflag) {
c0108216:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010821a:	74 12                	je     c010822e <getint+0x35>
        return va_arg(*ap, long);
c010821c:	8b 45 08             	mov    0x8(%ebp),%eax
c010821f:	8b 00                	mov    (%eax),%eax
c0108221:	8d 48 04             	lea    0x4(%eax),%ecx
c0108224:	8b 55 08             	mov    0x8(%ebp),%edx
c0108227:	89 0a                	mov    %ecx,(%edx)
c0108229:	8b 00                	mov    (%eax),%eax
c010822b:	99                   	cltd   
c010822c:	eb 10                	jmp    c010823e <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010822e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108231:	8b 00                	mov    (%eax),%eax
c0108233:	8d 48 04             	lea    0x4(%eax),%ecx
c0108236:	8b 55 08             	mov    0x8(%ebp),%edx
c0108239:	89 0a                	mov    %ecx,(%edx)
c010823b:	8b 00                	mov    (%eax),%eax
c010823d:	99                   	cltd   
    }
}
c010823e:	5d                   	pop    %ebp
c010823f:	c3                   	ret    

c0108240 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0108240:	55                   	push   %ebp
c0108241:	89 e5                	mov    %esp,%ebp
c0108243:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0108246:	8d 45 14             	lea    0x14(%ebp),%eax
c0108249:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010824c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010824f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108253:	8b 45 10             	mov    0x10(%ebp),%eax
c0108256:	89 44 24 08          	mov    %eax,0x8(%esp)
c010825a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010825d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108261:	8b 45 08             	mov    0x8(%ebp),%eax
c0108264:	89 04 24             	mov    %eax,(%esp)
c0108267:	e8 02 00 00 00       	call   c010826e <vprintfmt>
    va_end(ap);
}
c010826c:	c9                   	leave  
c010826d:	c3                   	ret    

c010826e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010826e:	55                   	push   %ebp
c010826f:	89 e5                	mov    %esp,%ebp
c0108271:	56                   	push   %esi
c0108272:	53                   	push   %ebx
c0108273:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108276:	eb 18                	jmp    c0108290 <vprintfmt+0x22>
            if (ch == '\0') {
c0108278:	85 db                	test   %ebx,%ebx
c010827a:	75 05                	jne    c0108281 <vprintfmt+0x13>
                return;
c010827c:	e9 d1 03 00 00       	jmp    c0108652 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0108281:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108284:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108288:	89 1c 24             	mov    %ebx,(%esp)
c010828b:	8b 45 08             	mov    0x8(%ebp),%eax
c010828e:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108290:	8b 45 10             	mov    0x10(%ebp),%eax
c0108293:	8d 50 01             	lea    0x1(%eax),%edx
c0108296:	89 55 10             	mov    %edx,0x10(%ebp)
c0108299:	0f b6 00             	movzbl (%eax),%eax
c010829c:	0f b6 d8             	movzbl %al,%ebx
c010829f:	83 fb 25             	cmp    $0x25,%ebx
c01082a2:	75 d4                	jne    c0108278 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01082a4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01082a8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01082af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01082b5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01082bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01082bf:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01082c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01082c5:	8d 50 01             	lea    0x1(%eax),%edx
c01082c8:	89 55 10             	mov    %edx,0x10(%ebp)
c01082cb:	0f b6 00             	movzbl (%eax),%eax
c01082ce:	0f b6 d8             	movzbl %al,%ebx
c01082d1:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01082d4:	83 f8 55             	cmp    $0x55,%eax
c01082d7:	0f 87 44 03 00 00    	ja     c0108621 <vprintfmt+0x3b3>
c01082dd:	8b 04 85 68 ab 10 c0 	mov    -0x3fef5498(,%eax,4),%eax
c01082e4:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01082e6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01082ea:	eb d6                	jmp    c01082c2 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01082ec:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01082f0:	eb d0                	jmp    c01082c2 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01082f2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01082f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01082fc:	89 d0                	mov    %edx,%eax
c01082fe:	c1 e0 02             	shl    $0x2,%eax
c0108301:	01 d0                	add    %edx,%eax
c0108303:	01 c0                	add    %eax,%eax
c0108305:	01 d8                	add    %ebx,%eax
c0108307:	83 e8 30             	sub    $0x30,%eax
c010830a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010830d:	8b 45 10             	mov    0x10(%ebp),%eax
c0108310:	0f b6 00             	movzbl (%eax),%eax
c0108313:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0108316:	83 fb 2f             	cmp    $0x2f,%ebx
c0108319:	7e 0b                	jle    c0108326 <vprintfmt+0xb8>
c010831b:	83 fb 39             	cmp    $0x39,%ebx
c010831e:	7f 06                	jg     c0108326 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108320:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0108324:	eb d3                	jmp    c01082f9 <vprintfmt+0x8b>
            goto process_precision;
c0108326:	eb 33                	jmp    c010835b <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0108328:	8b 45 14             	mov    0x14(%ebp),%eax
c010832b:	8d 50 04             	lea    0x4(%eax),%edx
c010832e:	89 55 14             	mov    %edx,0x14(%ebp)
c0108331:	8b 00                	mov    (%eax),%eax
c0108333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0108336:	eb 23                	jmp    c010835b <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0108338:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010833c:	79 0c                	jns    c010834a <vprintfmt+0xdc>
                width = 0;
c010833e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0108345:	e9 78 ff ff ff       	jmp    c01082c2 <vprintfmt+0x54>
c010834a:	e9 73 ff ff ff       	jmp    c01082c2 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010834f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0108356:	e9 67 ff ff ff       	jmp    c01082c2 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010835b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010835f:	79 12                	jns    c0108373 <vprintfmt+0x105>
                width = precision, precision = -1;
c0108361:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108364:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108367:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010836e:	e9 4f ff ff ff       	jmp    c01082c2 <vprintfmt+0x54>
c0108373:	e9 4a ff ff ff       	jmp    c01082c2 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0108378:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010837c:	e9 41 ff ff ff       	jmp    c01082c2 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108381:	8b 45 14             	mov    0x14(%ebp),%eax
c0108384:	8d 50 04             	lea    0x4(%eax),%edx
c0108387:	89 55 14             	mov    %edx,0x14(%ebp)
c010838a:	8b 00                	mov    (%eax),%eax
c010838c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010838f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108393:	89 04 24             	mov    %eax,(%esp)
c0108396:	8b 45 08             	mov    0x8(%ebp),%eax
c0108399:	ff d0                	call   *%eax
            break;
c010839b:	e9 ac 02 00 00       	jmp    c010864c <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01083a0:	8b 45 14             	mov    0x14(%ebp),%eax
c01083a3:	8d 50 04             	lea    0x4(%eax),%edx
c01083a6:	89 55 14             	mov    %edx,0x14(%ebp)
c01083a9:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01083ab:	85 db                	test   %ebx,%ebx
c01083ad:	79 02                	jns    c01083b1 <vprintfmt+0x143>
                err = -err;
c01083af:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01083b1:	83 fb 06             	cmp    $0x6,%ebx
c01083b4:	7f 0b                	jg     c01083c1 <vprintfmt+0x153>
c01083b6:	8b 34 9d 28 ab 10 c0 	mov    -0x3fef54d8(,%ebx,4),%esi
c01083bd:	85 f6                	test   %esi,%esi
c01083bf:	75 23                	jne    c01083e4 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01083c1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01083c5:	c7 44 24 08 55 ab 10 	movl   $0xc010ab55,0x8(%esp)
c01083cc:	c0 
c01083cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01083d7:	89 04 24             	mov    %eax,(%esp)
c01083da:	e8 61 fe ff ff       	call   c0108240 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01083df:	e9 68 02 00 00       	jmp    c010864c <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01083e4:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01083e8:	c7 44 24 08 5e ab 10 	movl   $0xc010ab5e,0x8(%esp)
c01083ef:	c0 
c01083f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01083fa:	89 04 24             	mov    %eax,(%esp)
c01083fd:	e8 3e fe ff ff       	call   c0108240 <printfmt>
            }
            break;
c0108402:	e9 45 02 00 00       	jmp    c010864c <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0108407:	8b 45 14             	mov    0x14(%ebp),%eax
c010840a:	8d 50 04             	lea    0x4(%eax),%edx
c010840d:	89 55 14             	mov    %edx,0x14(%ebp)
c0108410:	8b 30                	mov    (%eax),%esi
c0108412:	85 f6                	test   %esi,%esi
c0108414:	75 05                	jne    c010841b <vprintfmt+0x1ad>
                p = "(null)";
c0108416:	be 61 ab 10 c0       	mov    $0xc010ab61,%esi
            }
            if (width > 0 && padc != '-') {
c010841b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010841f:	7e 3e                	jle    c010845f <vprintfmt+0x1f1>
c0108421:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0108425:	74 38                	je     c010845f <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108427:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010842a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010842d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108431:	89 34 24             	mov    %esi,(%esp)
c0108434:	e8 ed 03 00 00       	call   c0108826 <strnlen>
c0108439:	29 c3                	sub    %eax,%ebx
c010843b:	89 d8                	mov    %ebx,%eax
c010843d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108440:	eb 17                	jmp    c0108459 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0108442:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0108446:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108449:	89 54 24 04          	mov    %edx,0x4(%esp)
c010844d:	89 04 24             	mov    %eax,(%esp)
c0108450:	8b 45 08             	mov    0x8(%ebp),%eax
c0108453:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108455:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108459:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010845d:	7f e3                	jg     c0108442 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010845f:	eb 38                	jmp    c0108499 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108461:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108465:	74 1f                	je     c0108486 <vprintfmt+0x218>
c0108467:	83 fb 1f             	cmp    $0x1f,%ebx
c010846a:	7e 05                	jle    c0108471 <vprintfmt+0x203>
c010846c:	83 fb 7e             	cmp    $0x7e,%ebx
c010846f:	7e 15                	jle    c0108486 <vprintfmt+0x218>
                    putch('?', putdat);
c0108471:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108474:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108478:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010847f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108482:	ff d0                	call   *%eax
c0108484:	eb 0f                	jmp    c0108495 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0108486:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108489:	89 44 24 04          	mov    %eax,0x4(%esp)
c010848d:	89 1c 24             	mov    %ebx,(%esp)
c0108490:	8b 45 08             	mov    0x8(%ebp),%eax
c0108493:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108495:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108499:	89 f0                	mov    %esi,%eax
c010849b:	8d 70 01             	lea    0x1(%eax),%esi
c010849e:	0f b6 00             	movzbl (%eax),%eax
c01084a1:	0f be d8             	movsbl %al,%ebx
c01084a4:	85 db                	test   %ebx,%ebx
c01084a6:	74 10                	je     c01084b8 <vprintfmt+0x24a>
c01084a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01084ac:	78 b3                	js     c0108461 <vprintfmt+0x1f3>
c01084ae:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01084b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01084b6:	79 a9                	jns    c0108461 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01084b8:	eb 17                	jmp    c01084d1 <vprintfmt+0x263>
                putch(' ', putdat);
c01084ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084c1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01084c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01084cb:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01084cd:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01084d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01084d5:	7f e3                	jg     c01084ba <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01084d7:	e9 70 01 00 00       	jmp    c010864c <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01084dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01084df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084e3:	8d 45 14             	lea    0x14(%ebp),%eax
c01084e6:	89 04 24             	mov    %eax,(%esp)
c01084e9:	e8 0b fd ff ff       	call   c01081f9 <getint>
c01084ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01084f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01084f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01084fa:	85 d2                	test   %edx,%edx
c01084fc:	79 26                	jns    c0108524 <vprintfmt+0x2b6>
                putch('-', putdat);
c01084fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108501:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108505:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010850c:	8b 45 08             	mov    0x8(%ebp),%eax
c010850f:	ff d0                	call   *%eax
                num = -(long long)num;
c0108511:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108514:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108517:	f7 d8                	neg    %eax
c0108519:	83 d2 00             	adc    $0x0,%edx
c010851c:	f7 da                	neg    %edx
c010851e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108521:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0108524:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010852b:	e9 a8 00 00 00       	jmp    c01085d8 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0108530:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108533:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108537:	8d 45 14             	lea    0x14(%ebp),%eax
c010853a:	89 04 24             	mov    %eax,(%esp)
c010853d:	e8 68 fc ff ff       	call   c01081aa <getuint>
c0108542:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108545:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0108548:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010854f:	e9 84 00 00 00       	jmp    c01085d8 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0108554:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108557:	89 44 24 04          	mov    %eax,0x4(%esp)
c010855b:	8d 45 14             	lea    0x14(%ebp),%eax
c010855e:	89 04 24             	mov    %eax,(%esp)
c0108561:	e8 44 fc ff ff       	call   c01081aa <getuint>
c0108566:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108569:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010856c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0108573:	eb 63                	jmp    c01085d8 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0108575:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108578:	89 44 24 04          	mov    %eax,0x4(%esp)
c010857c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0108583:	8b 45 08             	mov    0x8(%ebp),%eax
c0108586:	ff d0                	call   *%eax
            putch('x', putdat);
c0108588:	8b 45 0c             	mov    0xc(%ebp),%eax
c010858b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010858f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0108596:	8b 45 08             	mov    0x8(%ebp),%eax
c0108599:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010859b:	8b 45 14             	mov    0x14(%ebp),%eax
c010859e:	8d 50 04             	lea    0x4(%eax),%edx
c01085a1:	89 55 14             	mov    %edx,0x14(%ebp)
c01085a4:	8b 00                	mov    (%eax),%eax
c01085a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01085a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01085b0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01085b7:	eb 1f                	jmp    c01085d8 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01085b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01085bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085c0:	8d 45 14             	lea    0x14(%ebp),%eax
c01085c3:	89 04 24             	mov    %eax,(%esp)
c01085c6:	e8 df fb ff ff       	call   c01081aa <getuint>
c01085cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01085ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01085d1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01085d8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01085dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01085df:	89 54 24 18          	mov    %edx,0x18(%esp)
c01085e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01085e6:	89 54 24 14          	mov    %edx,0x14(%esp)
c01085ea:	89 44 24 10          	mov    %eax,0x10(%esp)
c01085ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01085f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01085f4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01085f8:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01085fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108603:	8b 45 08             	mov    0x8(%ebp),%eax
c0108606:	89 04 24             	mov    %eax,(%esp)
c0108609:	e8 97 fa ff ff       	call   c01080a5 <printnum>
            break;
c010860e:	eb 3c                	jmp    c010864c <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0108610:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108613:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108617:	89 1c 24             	mov    %ebx,(%esp)
c010861a:	8b 45 08             	mov    0x8(%ebp),%eax
c010861d:	ff d0                	call   *%eax
            break;
c010861f:	eb 2b                	jmp    c010864c <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0108621:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108624:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108628:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010862f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108632:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108634:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108638:	eb 04                	jmp    c010863e <vprintfmt+0x3d0>
c010863a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010863e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108641:	83 e8 01             	sub    $0x1,%eax
c0108644:	0f b6 00             	movzbl (%eax),%eax
c0108647:	3c 25                	cmp    $0x25,%al
c0108649:	75 ef                	jne    c010863a <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010864b:	90                   	nop
        }
    }
c010864c:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010864d:	e9 3e fc ff ff       	jmp    c0108290 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0108652:	83 c4 40             	add    $0x40,%esp
c0108655:	5b                   	pop    %ebx
c0108656:	5e                   	pop    %esi
c0108657:	5d                   	pop    %ebp
c0108658:	c3                   	ret    

c0108659 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0108659:	55                   	push   %ebp
c010865a:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010865c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010865f:	8b 40 08             	mov    0x8(%eax),%eax
c0108662:	8d 50 01             	lea    0x1(%eax),%edx
c0108665:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108668:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010866b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010866e:	8b 10                	mov    (%eax),%edx
c0108670:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108673:	8b 40 04             	mov    0x4(%eax),%eax
c0108676:	39 c2                	cmp    %eax,%edx
c0108678:	73 12                	jae    c010868c <sprintputch+0x33>
        *b->buf ++ = ch;
c010867a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010867d:	8b 00                	mov    (%eax),%eax
c010867f:	8d 48 01             	lea    0x1(%eax),%ecx
c0108682:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108685:	89 0a                	mov    %ecx,(%edx)
c0108687:	8b 55 08             	mov    0x8(%ebp),%edx
c010868a:	88 10                	mov    %dl,(%eax)
    }
}
c010868c:	5d                   	pop    %ebp
c010868d:	c3                   	ret    

c010868e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010868e:	55                   	push   %ebp
c010868f:	89 e5                	mov    %esp,%ebp
c0108691:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0108694:	8d 45 14             	lea    0x14(%ebp),%eax
c0108697:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010869a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010869d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01086a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01086a4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01086a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086af:	8b 45 08             	mov    0x8(%ebp),%eax
c01086b2:	89 04 24             	mov    %eax,(%esp)
c01086b5:	e8 08 00 00 00       	call   c01086c2 <vsnprintf>
c01086ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01086bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01086c0:	c9                   	leave  
c01086c1:	c3                   	ret    

c01086c2 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01086c2:	55                   	push   %ebp
c01086c3:	89 e5                	mov    %esp,%ebp
c01086c5:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01086c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01086cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01086ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086d1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01086d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01086d7:	01 d0                	add    %edx,%eax
c01086d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01086dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01086e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01086e7:	74 0a                	je     c01086f3 <vsnprintf+0x31>
c01086e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01086ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086ef:	39 c2                	cmp    %eax,%edx
c01086f1:	76 07                	jbe    c01086fa <vsnprintf+0x38>
        return -E_INVAL;
c01086f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01086f8:	eb 2a                	jmp    c0108724 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01086fa:	8b 45 14             	mov    0x14(%ebp),%eax
c01086fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108701:	8b 45 10             	mov    0x10(%ebp),%eax
c0108704:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108708:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010870b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010870f:	c7 04 24 59 86 10 c0 	movl   $0xc0108659,(%esp)
c0108716:	e8 53 fb ff ff       	call   c010826e <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010871b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010871e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0108721:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108724:	c9                   	leave  
c0108725:	c3                   	ret    

c0108726 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0108726:	55                   	push   %ebp
c0108727:	89 e5                	mov    %esp,%ebp
c0108729:	57                   	push   %edi
c010872a:	56                   	push   %esi
c010872b:	53                   	push   %ebx
c010872c:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010872f:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c0108734:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c010873a:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0108740:	6b f0 05             	imul   $0x5,%eax,%esi
c0108743:	01 f7                	add    %esi,%edi
c0108745:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010874a:	f7 e6                	mul    %esi
c010874c:	8d 34 17             	lea    (%edi,%edx,1),%esi
c010874f:	89 f2                	mov    %esi,%edx
c0108751:	83 c0 0b             	add    $0xb,%eax
c0108754:	83 d2 00             	adc    $0x0,%edx
c0108757:	89 c7                	mov    %eax,%edi
c0108759:	83 e7 ff             	and    $0xffffffff,%edi
c010875c:	89 f9                	mov    %edi,%ecx
c010875e:	0f b7 da             	movzwl %dx,%ebx
c0108761:	89 0d 60 0a 12 c0    	mov    %ecx,0xc0120a60
c0108767:	89 1d 64 0a 12 c0    	mov    %ebx,0xc0120a64
    unsigned long long result = (next >> 12);
c010876d:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c0108772:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c0108778:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010877c:	c1 ea 0c             	shr    $0xc,%edx
c010877f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108782:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0108785:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010878c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010878f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108792:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108795:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108798:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010879b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010879e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01087a2:	74 1c                	je     c01087c0 <rand+0x9a>
c01087a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01087a7:	ba 00 00 00 00       	mov    $0x0,%edx
c01087ac:	f7 75 dc             	divl   -0x24(%ebp)
c01087af:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01087b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01087b5:	ba 00 00 00 00       	mov    $0x0,%edx
c01087ba:	f7 75 dc             	divl   -0x24(%ebp)
c01087bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01087c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01087c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01087c6:	f7 75 dc             	divl   -0x24(%ebp)
c01087c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01087cc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01087cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01087d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01087d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01087d8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01087db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c01087de:	83 c4 24             	add    $0x24,%esp
c01087e1:	5b                   	pop    %ebx
c01087e2:	5e                   	pop    %esi
c01087e3:	5f                   	pop    %edi
c01087e4:	5d                   	pop    %ebp
c01087e5:	c3                   	ret    

c01087e6 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c01087e6:	55                   	push   %ebp
c01087e7:	89 e5                	mov    %esp,%ebp
    next = seed;
c01087e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01087ec:	ba 00 00 00 00       	mov    $0x0,%edx
c01087f1:	a3 60 0a 12 c0       	mov    %eax,0xc0120a60
c01087f6:	89 15 64 0a 12 c0    	mov    %edx,0xc0120a64
}
c01087fc:	5d                   	pop    %ebp
c01087fd:	c3                   	ret    

c01087fe <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01087fe:	55                   	push   %ebp
c01087ff:	89 e5                	mov    %esp,%ebp
c0108801:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108804:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010880b:	eb 04                	jmp    c0108811 <strlen+0x13>
        cnt ++;
c010880d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0108811:	8b 45 08             	mov    0x8(%ebp),%eax
c0108814:	8d 50 01             	lea    0x1(%eax),%edx
c0108817:	89 55 08             	mov    %edx,0x8(%ebp)
c010881a:	0f b6 00             	movzbl (%eax),%eax
c010881d:	84 c0                	test   %al,%al
c010881f:	75 ec                	jne    c010880d <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0108821:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108824:	c9                   	leave  
c0108825:	c3                   	ret    

c0108826 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0108826:	55                   	push   %ebp
c0108827:	89 e5                	mov    %esp,%ebp
c0108829:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010882c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108833:	eb 04                	jmp    c0108839 <strnlen+0x13>
        cnt ++;
c0108835:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0108839:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010883c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010883f:	73 10                	jae    c0108851 <strnlen+0x2b>
c0108841:	8b 45 08             	mov    0x8(%ebp),%eax
c0108844:	8d 50 01             	lea    0x1(%eax),%edx
c0108847:	89 55 08             	mov    %edx,0x8(%ebp)
c010884a:	0f b6 00             	movzbl (%eax),%eax
c010884d:	84 c0                	test   %al,%al
c010884f:	75 e4                	jne    c0108835 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0108851:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108854:	c9                   	leave  
c0108855:	c3                   	ret    

c0108856 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0108856:	55                   	push   %ebp
c0108857:	89 e5                	mov    %esp,%ebp
c0108859:	57                   	push   %edi
c010885a:	56                   	push   %esi
c010885b:	83 ec 20             	sub    $0x20,%esp
c010885e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108861:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108864:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108867:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010886a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010886d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108870:	89 d1                	mov    %edx,%ecx
c0108872:	89 c2                	mov    %eax,%edx
c0108874:	89 ce                	mov    %ecx,%esi
c0108876:	89 d7                	mov    %edx,%edi
c0108878:	ac                   	lods   %ds:(%esi),%al
c0108879:	aa                   	stos   %al,%es:(%edi)
c010887a:	84 c0                	test   %al,%al
c010887c:	75 fa                	jne    c0108878 <strcpy+0x22>
c010887e:	89 fa                	mov    %edi,%edx
c0108880:	89 f1                	mov    %esi,%ecx
c0108882:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108885:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108888:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010888b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010888e:	83 c4 20             	add    $0x20,%esp
c0108891:	5e                   	pop    %esi
c0108892:	5f                   	pop    %edi
c0108893:	5d                   	pop    %ebp
c0108894:	c3                   	ret    

c0108895 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0108895:	55                   	push   %ebp
c0108896:	89 e5                	mov    %esp,%ebp
c0108898:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010889b:	8b 45 08             	mov    0x8(%ebp),%eax
c010889e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01088a1:	eb 21                	jmp    c01088c4 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01088a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088a6:	0f b6 10             	movzbl (%eax),%edx
c01088a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01088ac:	88 10                	mov    %dl,(%eax)
c01088ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01088b1:	0f b6 00             	movzbl (%eax),%eax
c01088b4:	84 c0                	test   %al,%al
c01088b6:	74 04                	je     c01088bc <strncpy+0x27>
            src ++;
c01088b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01088bc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01088c0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01088c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01088c8:	75 d9                	jne    c01088a3 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01088ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01088cd:	c9                   	leave  
c01088ce:	c3                   	ret    

c01088cf <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01088cf:	55                   	push   %ebp
c01088d0:	89 e5                	mov    %esp,%ebp
c01088d2:	57                   	push   %edi
c01088d3:	56                   	push   %esi
c01088d4:	83 ec 20             	sub    $0x20,%esp
c01088d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01088da:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01088dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01088e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01088e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01088e9:	89 d1                	mov    %edx,%ecx
c01088eb:	89 c2                	mov    %eax,%edx
c01088ed:	89 ce                	mov    %ecx,%esi
c01088ef:	89 d7                	mov    %edx,%edi
c01088f1:	ac                   	lods   %ds:(%esi),%al
c01088f2:	ae                   	scas   %es:(%edi),%al
c01088f3:	75 08                	jne    c01088fd <strcmp+0x2e>
c01088f5:	84 c0                	test   %al,%al
c01088f7:	75 f8                	jne    c01088f1 <strcmp+0x22>
c01088f9:	31 c0                	xor    %eax,%eax
c01088fb:	eb 04                	jmp    c0108901 <strcmp+0x32>
c01088fd:	19 c0                	sbb    %eax,%eax
c01088ff:	0c 01                	or     $0x1,%al
c0108901:	89 fa                	mov    %edi,%edx
c0108903:	89 f1                	mov    %esi,%ecx
c0108905:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108908:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010890b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c010890e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0108911:	83 c4 20             	add    $0x20,%esp
c0108914:	5e                   	pop    %esi
c0108915:	5f                   	pop    %edi
c0108916:	5d                   	pop    %ebp
c0108917:	c3                   	ret    

c0108918 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0108918:	55                   	push   %ebp
c0108919:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010891b:	eb 0c                	jmp    c0108929 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010891d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108921:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108925:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108929:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010892d:	74 1a                	je     c0108949 <strncmp+0x31>
c010892f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108932:	0f b6 00             	movzbl (%eax),%eax
c0108935:	84 c0                	test   %al,%al
c0108937:	74 10                	je     c0108949 <strncmp+0x31>
c0108939:	8b 45 08             	mov    0x8(%ebp),%eax
c010893c:	0f b6 10             	movzbl (%eax),%edx
c010893f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108942:	0f b6 00             	movzbl (%eax),%eax
c0108945:	38 c2                	cmp    %al,%dl
c0108947:	74 d4                	je     c010891d <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108949:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010894d:	74 18                	je     c0108967 <strncmp+0x4f>
c010894f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108952:	0f b6 00             	movzbl (%eax),%eax
c0108955:	0f b6 d0             	movzbl %al,%edx
c0108958:	8b 45 0c             	mov    0xc(%ebp),%eax
c010895b:	0f b6 00             	movzbl (%eax),%eax
c010895e:	0f b6 c0             	movzbl %al,%eax
c0108961:	29 c2                	sub    %eax,%edx
c0108963:	89 d0                	mov    %edx,%eax
c0108965:	eb 05                	jmp    c010896c <strncmp+0x54>
c0108967:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010896c:	5d                   	pop    %ebp
c010896d:	c3                   	ret    

c010896e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010896e:	55                   	push   %ebp
c010896f:	89 e5                	mov    %esp,%ebp
c0108971:	83 ec 04             	sub    $0x4,%esp
c0108974:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108977:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010897a:	eb 14                	jmp    c0108990 <strchr+0x22>
        if (*s == c) {
c010897c:	8b 45 08             	mov    0x8(%ebp),%eax
c010897f:	0f b6 00             	movzbl (%eax),%eax
c0108982:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108985:	75 05                	jne    c010898c <strchr+0x1e>
            return (char *)s;
c0108987:	8b 45 08             	mov    0x8(%ebp),%eax
c010898a:	eb 13                	jmp    c010899f <strchr+0x31>
        }
        s ++;
c010898c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0108990:	8b 45 08             	mov    0x8(%ebp),%eax
c0108993:	0f b6 00             	movzbl (%eax),%eax
c0108996:	84 c0                	test   %al,%al
c0108998:	75 e2                	jne    c010897c <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010899a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010899f:	c9                   	leave  
c01089a0:	c3                   	ret    

c01089a1 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01089a1:	55                   	push   %ebp
c01089a2:	89 e5                	mov    %esp,%ebp
c01089a4:	83 ec 04             	sub    $0x4,%esp
c01089a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089aa:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01089ad:	eb 11                	jmp    c01089c0 <strfind+0x1f>
        if (*s == c) {
c01089af:	8b 45 08             	mov    0x8(%ebp),%eax
c01089b2:	0f b6 00             	movzbl (%eax),%eax
c01089b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01089b8:	75 02                	jne    c01089bc <strfind+0x1b>
            break;
c01089ba:	eb 0e                	jmp    c01089ca <strfind+0x29>
        }
        s ++;
c01089bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01089c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01089c3:	0f b6 00             	movzbl (%eax),%eax
c01089c6:	84 c0                	test   %al,%al
c01089c8:	75 e5                	jne    c01089af <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c01089ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01089cd:	c9                   	leave  
c01089ce:	c3                   	ret    

c01089cf <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01089cf:	55                   	push   %ebp
c01089d0:	89 e5                	mov    %esp,%ebp
c01089d2:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01089d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01089dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01089e3:	eb 04                	jmp    c01089e9 <strtol+0x1a>
        s ++;
c01089e5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01089e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01089ec:	0f b6 00             	movzbl (%eax),%eax
c01089ef:	3c 20                	cmp    $0x20,%al
c01089f1:	74 f2                	je     c01089e5 <strtol+0x16>
c01089f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01089f6:	0f b6 00             	movzbl (%eax),%eax
c01089f9:	3c 09                	cmp    $0x9,%al
c01089fb:	74 e8                	je     c01089e5 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01089fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a00:	0f b6 00             	movzbl (%eax),%eax
c0108a03:	3c 2b                	cmp    $0x2b,%al
c0108a05:	75 06                	jne    c0108a0d <strtol+0x3e>
        s ++;
c0108a07:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108a0b:	eb 15                	jmp    c0108a22 <strtol+0x53>
    }
    else if (*s == '-') {
c0108a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a10:	0f b6 00             	movzbl (%eax),%eax
c0108a13:	3c 2d                	cmp    $0x2d,%al
c0108a15:	75 0b                	jne    c0108a22 <strtol+0x53>
        s ++, neg = 1;
c0108a17:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108a1b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0108a22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108a26:	74 06                	je     c0108a2e <strtol+0x5f>
c0108a28:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0108a2c:	75 24                	jne    c0108a52 <strtol+0x83>
c0108a2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a31:	0f b6 00             	movzbl (%eax),%eax
c0108a34:	3c 30                	cmp    $0x30,%al
c0108a36:	75 1a                	jne    c0108a52 <strtol+0x83>
c0108a38:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a3b:	83 c0 01             	add    $0x1,%eax
c0108a3e:	0f b6 00             	movzbl (%eax),%eax
c0108a41:	3c 78                	cmp    $0x78,%al
c0108a43:	75 0d                	jne    c0108a52 <strtol+0x83>
        s += 2, base = 16;
c0108a45:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108a49:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0108a50:	eb 2a                	jmp    c0108a7c <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0108a52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108a56:	75 17                	jne    c0108a6f <strtol+0xa0>
c0108a58:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a5b:	0f b6 00             	movzbl (%eax),%eax
c0108a5e:	3c 30                	cmp    $0x30,%al
c0108a60:	75 0d                	jne    c0108a6f <strtol+0xa0>
        s ++, base = 8;
c0108a62:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108a66:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108a6d:	eb 0d                	jmp    c0108a7c <strtol+0xad>
    }
    else if (base == 0) {
c0108a6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108a73:	75 07                	jne    c0108a7c <strtol+0xad>
        base = 10;
c0108a75:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108a7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a7f:	0f b6 00             	movzbl (%eax),%eax
c0108a82:	3c 2f                	cmp    $0x2f,%al
c0108a84:	7e 1b                	jle    c0108aa1 <strtol+0xd2>
c0108a86:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a89:	0f b6 00             	movzbl (%eax),%eax
c0108a8c:	3c 39                	cmp    $0x39,%al
c0108a8e:	7f 11                	jg     c0108aa1 <strtol+0xd2>
            dig = *s - '0';
c0108a90:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a93:	0f b6 00             	movzbl (%eax),%eax
c0108a96:	0f be c0             	movsbl %al,%eax
c0108a99:	83 e8 30             	sub    $0x30,%eax
c0108a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a9f:	eb 48                	jmp    c0108ae9 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0108aa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aa4:	0f b6 00             	movzbl (%eax),%eax
c0108aa7:	3c 60                	cmp    $0x60,%al
c0108aa9:	7e 1b                	jle    c0108ac6 <strtol+0xf7>
c0108aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aae:	0f b6 00             	movzbl (%eax),%eax
c0108ab1:	3c 7a                	cmp    $0x7a,%al
c0108ab3:	7f 11                	jg     c0108ac6 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0108ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ab8:	0f b6 00             	movzbl (%eax),%eax
c0108abb:	0f be c0             	movsbl %al,%eax
c0108abe:	83 e8 57             	sub    $0x57,%eax
c0108ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108ac4:	eb 23                	jmp    c0108ae9 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0108ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ac9:	0f b6 00             	movzbl (%eax),%eax
c0108acc:	3c 40                	cmp    $0x40,%al
c0108ace:	7e 3d                	jle    c0108b0d <strtol+0x13e>
c0108ad0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ad3:	0f b6 00             	movzbl (%eax),%eax
c0108ad6:	3c 5a                	cmp    $0x5a,%al
c0108ad8:	7f 33                	jg     c0108b0d <strtol+0x13e>
            dig = *s - 'A' + 10;
c0108ada:	8b 45 08             	mov    0x8(%ebp),%eax
c0108add:	0f b6 00             	movzbl (%eax),%eax
c0108ae0:	0f be c0             	movsbl %al,%eax
c0108ae3:	83 e8 37             	sub    $0x37,%eax
c0108ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108aec:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108aef:	7c 02                	jl     c0108af3 <strtol+0x124>
            break;
c0108af1:	eb 1a                	jmp    c0108b0d <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0108af3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108af7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108afa:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108afe:	89 c2                	mov    %eax,%edx
c0108b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b03:	01 d0                	add    %edx,%eax
c0108b05:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0108b08:	e9 6f ff ff ff       	jmp    c0108a7c <strtol+0xad>

    if (endptr) {
c0108b0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108b11:	74 08                	je     c0108b1b <strtol+0x14c>
        *endptr = (char *) s;
c0108b13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b16:	8b 55 08             	mov    0x8(%ebp),%edx
c0108b19:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108b1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108b1f:	74 07                	je     c0108b28 <strtol+0x159>
c0108b21:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108b24:	f7 d8                	neg    %eax
c0108b26:	eb 03                	jmp    c0108b2b <strtol+0x15c>
c0108b28:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108b2b:	c9                   	leave  
c0108b2c:	c3                   	ret    

c0108b2d <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108b2d:	55                   	push   %ebp
c0108b2e:	89 e5                	mov    %esp,%ebp
c0108b30:	57                   	push   %edi
c0108b31:	83 ec 24             	sub    $0x24,%esp
c0108b34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b37:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108b3a:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108b3e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108b41:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0108b44:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108b47:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108b4d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108b50:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0108b54:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108b57:	89 d7                	mov    %edx,%edi
c0108b59:	f3 aa                	rep stos %al,%es:(%edi)
c0108b5b:	89 fa                	mov    %edi,%edx
c0108b5d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108b60:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108b63:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108b66:	83 c4 24             	add    $0x24,%esp
c0108b69:	5f                   	pop    %edi
c0108b6a:	5d                   	pop    %ebp
c0108b6b:	c3                   	ret    

c0108b6c <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108b6c:	55                   	push   %ebp
c0108b6d:	89 e5                	mov    %esp,%ebp
c0108b6f:	57                   	push   %edi
c0108b70:	56                   	push   %esi
c0108b71:	53                   	push   %ebx
c0108b72:	83 ec 30             	sub    $0x30,%esp
c0108b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108b81:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b84:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b8a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108b8d:	73 42                	jae    c0108bd1 <memmove+0x65>
c0108b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b98:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108b9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b9e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108ba1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108ba4:	c1 e8 02             	shr    $0x2,%eax
c0108ba7:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108ba9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108bac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108baf:	89 d7                	mov    %edx,%edi
c0108bb1:	89 c6                	mov    %eax,%esi
c0108bb3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108bb5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108bb8:	83 e1 03             	and    $0x3,%ecx
c0108bbb:	74 02                	je     c0108bbf <memmove+0x53>
c0108bbd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108bbf:	89 f0                	mov    %esi,%eax
c0108bc1:	89 fa                	mov    %edi,%edx
c0108bc3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108bc6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108bc9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108bcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108bcf:	eb 36                	jmp    c0108c07 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bd4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108bda:	01 c2                	add    %eax,%edx
c0108bdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bdf:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0108be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108be5:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0108be8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108beb:	89 c1                	mov    %eax,%ecx
c0108bed:	89 d8                	mov    %ebx,%eax
c0108bef:	89 d6                	mov    %edx,%esi
c0108bf1:	89 c7                	mov    %eax,%edi
c0108bf3:	fd                   	std    
c0108bf4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108bf6:	fc                   	cld    
c0108bf7:	89 f8                	mov    %edi,%eax
c0108bf9:	89 f2                	mov    %esi,%edx
c0108bfb:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108bfe:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108c01:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0108c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108c07:	83 c4 30             	add    $0x30,%esp
c0108c0a:	5b                   	pop    %ebx
c0108c0b:	5e                   	pop    %esi
c0108c0c:	5f                   	pop    %edi
c0108c0d:	5d                   	pop    %ebp
c0108c0e:	c3                   	ret    

c0108c0f <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108c0f:	55                   	push   %ebp
c0108c10:	89 e5                	mov    %esp,%ebp
c0108c12:	57                   	push   %edi
c0108c13:	56                   	push   %esi
c0108c14:	83 ec 20             	sub    $0x20,%esp
c0108c17:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108c23:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c26:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c2c:	c1 e8 02             	shr    $0x2,%eax
c0108c2f:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c37:	89 d7                	mov    %edx,%edi
c0108c39:	89 c6                	mov    %eax,%esi
c0108c3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108c3d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108c40:	83 e1 03             	and    $0x3,%ecx
c0108c43:	74 02                	je     c0108c47 <memcpy+0x38>
c0108c45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108c47:	89 f0                	mov    %esi,%eax
c0108c49:	89 fa                	mov    %edi,%edx
c0108c4b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108c4e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108c51:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108c57:	83 c4 20             	add    $0x20,%esp
c0108c5a:	5e                   	pop    %esi
c0108c5b:	5f                   	pop    %edi
c0108c5c:	5d                   	pop    %ebp
c0108c5d:	c3                   	ret    

c0108c5e <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108c5e:	55                   	push   %ebp
c0108c5f:	89 e5                	mov    %esp,%ebp
c0108c61:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108c64:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c67:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108c70:	eb 30                	jmp    c0108ca2 <memcmp+0x44>
        if (*s1 != *s2) {
c0108c72:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108c75:	0f b6 10             	movzbl (%eax),%edx
c0108c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108c7b:	0f b6 00             	movzbl (%eax),%eax
c0108c7e:	38 c2                	cmp    %al,%dl
c0108c80:	74 18                	je     c0108c9a <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108c82:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108c85:	0f b6 00             	movzbl (%eax),%eax
c0108c88:	0f b6 d0             	movzbl %al,%edx
c0108c8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108c8e:	0f b6 00             	movzbl (%eax),%eax
c0108c91:	0f b6 c0             	movzbl %al,%eax
c0108c94:	29 c2                	sub    %eax,%edx
c0108c96:	89 d0                	mov    %edx,%eax
c0108c98:	eb 1a                	jmp    c0108cb4 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108c9a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108c9e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0108ca2:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ca5:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108ca8:	89 55 10             	mov    %edx,0x10(%ebp)
c0108cab:	85 c0                	test   %eax,%eax
c0108cad:	75 c3                	jne    c0108c72 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108caf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108cb4:	c9                   	leave  
c0108cb5:	c3                   	ret    
