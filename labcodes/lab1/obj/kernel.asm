
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 2f 31 00 00       	call   10315b <memset>

    cons_init();                // init the console
  10002c:	e8 53 15 00 00       	call   101584 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 00 33 10 00 	movl   $0x103300,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 1c 33 10 00 	movl   $0x10331c,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 47 27 00 00       	call   1027a1 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 68 16 00 00       	call   1016c7 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 ba 17 00 00       	call   10181e <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 0e 0d 00 00       	call   100d77 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 c7 15 00 00       	call   101635 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 06 0c 00 00       	call   100c98 <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 21 33 10 00 	movl   $0x103321,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 2f 33 10 00 	movl   $0x10332f,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 3d 33 10 00 	movl   $0x10333d,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 4b 33 10 00 	movl   $0x10334b,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 59 33 10 00 	movl   $0x103359,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 68 33 10 00 	movl   $0x103368,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 88 33 10 00 	movl   $0x103388,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 a7 33 10 00 	movl   $0x1033a7,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 e0 12 00 00       	call   1015b0 <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 67 26 00 00       	call   102974 <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 67 12 00 00       	call   1015b0 <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 34 12 00 00       	call   1015d9 <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 ac 33 10 00    	movl   $0x1033ac,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 ac 33 10 00 	movl   $0x1033ac,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 0c 3c 10 00 	movl   $0x103c0c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 bc b2 10 00 	movl   $0x10b2bc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec bd b2 10 00 	movl   $0x10b2bd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 b8 d2 10 00 	movl   $0x10d2b8,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 0d 29 00 00       	call   102fcf <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 b6 33 10 00 	movl   $0x1033b6,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 cf 33 10 00 	movl   $0x1033cf,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 e4 32 10 	movl   $0x1032e4,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 e7 33 10 00 	movl   $0x1033e7,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 ff 33 10 00 	movl   $0x1033ff,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 17 34 10 00 	movl   $0x103417,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 30 34 10 00 	movl   $0x103430,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 5a 34 10 00 	movl   $0x10345a,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 76 34 10 00 	movl   $0x103476,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10099b:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	// 读取当前栈帧的ebp和eip
	uint32_t ebp = read_ebp();
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
   	uint32_t eip = read_eip();
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32_t i = 0, j = 0;
  1009a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  1009b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009be:	e9 88 00 00 00       	jmp    100a4b <print_stackframe+0xbb>
	{
        // 读取
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d1:	c7 04 24 88 34 10 00 	movl   $0x103488,(%esp)
  1009d8:	e8 35 f9 ff ff       	call   100312 <cprintf>
        uint32_t* args = (uint32_t*)ebp + 2 ;
  1009dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e0:	83 c0 08             	add    $0x8,%eax
  1009e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for(j = 0; j < 4; j++)
  1009e6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009ed:	eb 25                	jmp    100a14 <print_stackframe+0x84>
            cprintf("0x%08x ", args[j]);
  1009ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009fc:	01 d0                	add    %edx,%eax
  1009fe:	8b 00                	mov    (%eax),%eax
  100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a04:	c7 04 24 a4 34 10 00 	movl   $0x1034a4,(%esp)
  100a0b:	e8 02 f9 ff ff       	call   100312 <cprintf>
    	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
	{
        // 读取
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t* args = (uint32_t*)ebp + 2 ;
        for(j = 0; j < 4; j++)
  100a10:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a14:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a18:	76 d5                	jbe    1009ef <print_stackframe+0x5f>
            cprintf("0x%08x ", args[j]);
        cprintf("\n");
  100a1a:	c7 04 24 ac 34 10 00 	movl   $0x1034ac,(%esp)
  100a21:	e8 ec f8 ff ff       	call   100312 <cprintf>
        // eip指向异常指令的下一条指令，所以要减1
        print_debuginfo(eip-1);
  100a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a29:	83 e8 01             	sub    $0x1,%eax
  100a2c:	89 04 24             	mov    %eax,(%esp)
  100a2f:	e8 a8 fe ff ff       	call   1008dc <print_debuginfo>
        // 将ebp 和eip设置为上一个栈帧的ebp和eip
        //  注意要先设置eip后设置ebp，否则当ebp被修改后，eip就无法找到正确的位置
        eip = *((uint32_t*)ebp + 1);
  100a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a37:	83 c0 04             	add    $0x4,%eax
  100a3a:	8b 00                	mov    (%eax),%eax
  100a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *(uint32_t*)ebp;
  100a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a42:	8b 00                	mov    (%eax),%eax
  100a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */
	// 读取当前栈帧的ebp和eip
	uint32_t ebp = read_ebp();
   	uint32_t eip = read_eip();
	uint32_t i = 0, j = 0;
    	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  100a47:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a4f:	74 0a                	je     100a5b <print_stackframe+0xcb>
  100a51:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a55:	0f 86 68 ff ff ff    	jbe    1009c3 <print_stackframe+0x33>
        // 将ebp 和eip设置为上一个栈帧的ebp和eip
        //  注意要先设置eip后设置ebp，否则当ebp被修改后，eip就无法找到正确的位置
        eip = *((uint32_t*)ebp + 1);
        ebp = *(uint32_t*)ebp;
    }
}
  100a5b:	c9                   	leave  
  100a5c:	c3                   	ret    

00100a5d <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a5d:	55                   	push   %ebp
  100a5e:	89 e5                	mov    %esp,%ebp
  100a60:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a6a:	eb 0c                	jmp    100a78 <parse+0x1b>
            *buf ++ = '\0';
  100a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6f:	8d 50 01             	lea    0x1(%eax),%edx
  100a72:	89 55 08             	mov    %edx,0x8(%ebp)
  100a75:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a78:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7b:	0f b6 00             	movzbl (%eax),%eax
  100a7e:	84 c0                	test   %al,%al
  100a80:	74 1d                	je     100a9f <parse+0x42>
  100a82:	8b 45 08             	mov    0x8(%ebp),%eax
  100a85:	0f b6 00             	movzbl (%eax),%eax
  100a88:	0f be c0             	movsbl %al,%eax
  100a8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a8f:	c7 04 24 30 35 10 00 	movl   $0x103530,(%esp)
  100a96:	e8 01 25 00 00       	call   102f9c <strchr>
  100a9b:	85 c0                	test   %eax,%eax
  100a9d:	75 cd                	jne    100a6c <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa2:	0f b6 00             	movzbl (%eax),%eax
  100aa5:	84 c0                	test   %al,%al
  100aa7:	75 02                	jne    100aab <parse+0x4e>
            break;
  100aa9:	eb 67                	jmp    100b12 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aab:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aaf:	75 14                	jne    100ac5 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ab1:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ab8:	00 
  100ab9:	c7 04 24 35 35 10 00 	movl   $0x103535,(%esp)
  100ac0:	e8 4d f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac8:	8d 50 01             	lea    0x1(%eax),%edx
  100acb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ace:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ad5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ad8:	01 c2                	add    %eax,%edx
  100ada:	8b 45 08             	mov    0x8(%ebp),%eax
  100add:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100adf:	eb 04                	jmp    100ae5 <parse+0x88>
            buf ++;
  100ae1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae8:	0f b6 00             	movzbl (%eax),%eax
  100aeb:	84 c0                	test   %al,%al
  100aed:	74 1d                	je     100b0c <parse+0xaf>
  100aef:	8b 45 08             	mov    0x8(%ebp),%eax
  100af2:	0f b6 00             	movzbl (%eax),%eax
  100af5:	0f be c0             	movsbl %al,%eax
  100af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100afc:	c7 04 24 30 35 10 00 	movl   $0x103530,(%esp)
  100b03:	e8 94 24 00 00       	call   102f9c <strchr>
  100b08:	85 c0                	test   %eax,%eax
  100b0a:	74 d5                	je     100ae1 <parse+0x84>
            buf ++;
        }
    }
  100b0c:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b0d:	e9 66 ff ff ff       	jmp    100a78 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b15:	c9                   	leave  
  100b16:	c3                   	ret    

00100b17 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b17:	55                   	push   %ebp
  100b18:	89 e5                	mov    %esp,%ebp
  100b1a:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b1d:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b20:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b24:	8b 45 08             	mov    0x8(%ebp),%eax
  100b27:	89 04 24             	mov    %eax,(%esp)
  100b2a:	e8 2e ff ff ff       	call   100a5d <parse>
  100b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b36:	75 0a                	jne    100b42 <runcmd+0x2b>
        return 0;
  100b38:	b8 00 00 00 00       	mov    $0x0,%eax
  100b3d:	e9 85 00 00 00       	jmp    100bc7 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b49:	eb 5c                	jmp    100ba7 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b4b:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b51:	89 d0                	mov    %edx,%eax
  100b53:	01 c0                	add    %eax,%eax
  100b55:	01 d0                	add    %edx,%eax
  100b57:	c1 e0 02             	shl    $0x2,%eax
  100b5a:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b5f:	8b 00                	mov    (%eax),%eax
  100b61:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b65:	89 04 24             	mov    %eax,(%esp)
  100b68:	e8 90 23 00 00       	call   102efd <strcmp>
  100b6d:	85 c0                	test   %eax,%eax
  100b6f:	75 32                	jne    100ba3 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b74:	89 d0                	mov    %edx,%eax
  100b76:	01 c0                	add    %eax,%eax
  100b78:	01 d0                	add    %edx,%eax
  100b7a:	c1 e0 02             	shl    $0x2,%eax
  100b7d:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b82:	8b 40 08             	mov    0x8(%eax),%eax
  100b85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b88:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b8e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b92:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b95:	83 c2 04             	add    $0x4,%edx
  100b98:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b9c:	89 0c 24             	mov    %ecx,(%esp)
  100b9f:	ff d0                	call   *%eax
  100ba1:	eb 24                	jmp    100bc7 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ba3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100baa:	83 f8 02             	cmp    $0x2,%eax
  100bad:	76 9c                	jbe    100b4b <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100baf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb6:	c7 04 24 53 35 10 00 	movl   $0x103553,(%esp)
  100bbd:	e8 50 f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bc7:	c9                   	leave  
  100bc8:	c3                   	ret    

00100bc9 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bc9:	55                   	push   %ebp
  100bca:	89 e5                	mov    %esp,%ebp
  100bcc:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bcf:	c7 04 24 6c 35 10 00 	movl   $0x10356c,(%esp)
  100bd6:	e8 37 f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bdb:	c7 04 24 94 35 10 00 	movl   $0x103594,(%esp)
  100be2:	e8 2b f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100be7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100beb:	74 0b                	je     100bf8 <kmonitor+0x2f>
        print_trapframe(tf);
  100bed:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf0:	89 04 24             	mov    %eax,(%esp)
  100bf3:	e8 72 0c 00 00       	call   10186a <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bf8:	c7 04 24 b9 35 10 00 	movl   $0x1035b9,(%esp)
  100bff:	e8 05 f6 ff ff       	call   100209 <readline>
  100c04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c0b:	74 18                	je     100c25 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  100c10:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c17:	89 04 24             	mov    %eax,(%esp)
  100c1a:	e8 f8 fe ff ff       	call   100b17 <runcmd>
  100c1f:	85 c0                	test   %eax,%eax
  100c21:	79 02                	jns    100c25 <kmonitor+0x5c>
                break;
  100c23:	eb 02                	jmp    100c27 <kmonitor+0x5e>
            }
        }
    }
  100c25:	eb d1                	jmp    100bf8 <kmonitor+0x2f>
}
  100c27:	c9                   	leave  
  100c28:	c3                   	ret    

00100c29 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c29:	55                   	push   %ebp
  100c2a:	89 e5                	mov    %esp,%ebp
  100c2c:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c36:	eb 3f                	jmp    100c77 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3b:	89 d0                	mov    %edx,%eax
  100c3d:	01 c0                	add    %eax,%eax
  100c3f:	01 d0                	add    %edx,%eax
  100c41:	c1 e0 02             	shl    $0x2,%eax
  100c44:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c49:	8b 48 04             	mov    0x4(%eax),%ecx
  100c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c4f:	89 d0                	mov    %edx,%eax
  100c51:	01 c0                	add    %eax,%eax
  100c53:	01 d0                	add    %edx,%eax
  100c55:	c1 e0 02             	shl    $0x2,%eax
  100c58:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c5d:	8b 00                	mov    (%eax),%eax
  100c5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c67:	c7 04 24 bd 35 10 00 	movl   $0x1035bd,(%esp)
  100c6e:	e8 9f f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c73:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c7a:	83 f8 02             	cmp    $0x2,%eax
  100c7d:	76 b9                	jbe    100c38 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c84:	c9                   	leave  
  100c85:	c3                   	ret    

00100c86 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c86:	55                   	push   %ebp
  100c87:	89 e5                	mov    %esp,%ebp
  100c89:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c8c:	e8 b5 fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c96:	c9                   	leave  
  100c97:	c3                   	ret    

00100c98 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c98:	55                   	push   %ebp
  100c99:	89 e5                	mov    %esp,%ebp
  100c9b:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c9e:	e8 ed fc ff ff       	call   100990 <print_stackframe>
    return 0;
  100ca3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca8:	c9                   	leave  
  100ca9:	c3                   	ret    

00100caa <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100caa:	55                   	push   %ebp
  100cab:	89 e5                	mov    %esp,%ebp
  100cad:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cb0:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cb5:	85 c0                	test   %eax,%eax
  100cb7:	74 02                	je     100cbb <__panic+0x11>
        goto panic_dead;
  100cb9:	eb 59                	jmp    100d14 <__panic+0x6a>
    }
    is_panic = 1;
  100cbb:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cc2:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cc5:	8d 45 14             	lea    0x14(%ebp),%eax
  100cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cce:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd9:	c7 04 24 c6 35 10 00 	movl   $0x1035c6,(%esp)
  100ce0:	e8 2d f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cec:	8b 45 10             	mov    0x10(%ebp),%eax
  100cef:	89 04 24             	mov    %eax,(%esp)
  100cf2:	e8 e8 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100cf7:	c7 04 24 e2 35 10 00 	movl   $0x1035e2,(%esp)
  100cfe:	e8 0f f6 ff ff       	call   100312 <cprintf>
    
    cprintf("stack trackback:\n");
  100d03:	c7 04 24 e4 35 10 00 	movl   $0x1035e4,(%esp)
  100d0a:	e8 03 f6 ff ff       	call   100312 <cprintf>
    print_stackframe();
  100d0f:	e8 7c fc ff ff       	call   100990 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d14:	e8 22 09 00 00       	call   10163b <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d20:	e8 a4 fe ff ff       	call   100bc9 <kmonitor>
    }
  100d25:	eb f2                	jmp    100d19 <__panic+0x6f>

00100d27 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d27:	55                   	push   %ebp
  100d28:	89 e5                	mov    %esp,%ebp
  100d2a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d2d:	8d 45 14             	lea    0x14(%ebp),%eax
  100d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d36:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  100d3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d41:	c7 04 24 f6 35 10 00 	movl   $0x1035f6,(%esp)
  100d48:	e8 c5 f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d54:	8b 45 10             	mov    0x10(%ebp),%eax
  100d57:	89 04 24             	mov    %eax,(%esp)
  100d5a:	e8 80 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d5f:	c7 04 24 e2 35 10 00 	movl   $0x1035e2,(%esp)
  100d66:	e8 a7 f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d6b:	c9                   	leave  
  100d6c:	c3                   	ret    

00100d6d <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d6d:	55                   	push   %ebp
  100d6e:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d70:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d75:	5d                   	pop    %ebp
  100d76:	c3                   	ret    

00100d77 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d77:	55                   	push   %ebp
  100d78:	89 e5                	mov    %esp,%ebp
  100d7a:	83 ec 28             	sub    $0x28,%esp
  100d7d:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d83:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d87:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d8b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d8f:	ee                   	out    %al,(%dx)
  100d90:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d96:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d9a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d9e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100da2:	ee                   	out    %al,(%dx)
  100da3:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100da9:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dad:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100db1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100db5:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100db6:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100dbd:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dc0:	c7 04 24 14 36 10 00 	movl   $0x103614,(%esp)
  100dc7:	e8 46 f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100dcc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dd3:	e8 c1 08 00 00       	call   101699 <pic_enable>
}
  100dd8:	c9                   	leave  
  100dd9:	c3                   	ret    

00100dda <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dda:	55                   	push   %ebp
  100ddb:	89 e5                	mov    %esp,%ebp
  100ddd:	83 ec 10             	sub    $0x10,%esp
  100de0:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100de6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dea:	89 c2                	mov    %eax,%edx
  100dec:	ec                   	in     (%dx),%al
  100ded:	88 45 fd             	mov    %al,-0x3(%ebp)
  100df0:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100df6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dfa:	89 c2                	mov    %eax,%edx
  100dfc:	ec                   	in     (%dx),%al
  100dfd:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e00:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e06:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e0a:	89 c2                	mov    %eax,%edx
  100e0c:	ec                   	in     (%dx),%al
  100e0d:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e10:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e16:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e1a:	89 c2                	mov    %eax,%edx
  100e1c:	ec                   	in     (%dx),%al
  100e1d:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e20:	c9                   	leave  
  100e21:	c3                   	ret    

00100e22 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e22:	55                   	push   %ebp
  100e23:	89 e5                	mov    %esp,%ebp
  100e25:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e28:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e32:	0f b7 00             	movzwl (%eax),%eax
  100e35:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e3c:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e44:	0f b7 00             	movzwl (%eax),%eax
  100e47:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e4b:	74 12                	je     100e5f <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e4d:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e54:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e5b:	b4 03 
  100e5d:	eb 13                	jmp    100e72 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e62:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e66:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e69:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e70:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e72:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e79:	0f b7 c0             	movzwl %ax,%eax
  100e7c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e80:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e84:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e88:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e8c:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e8d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e94:	83 c0 01             	add    $0x1,%eax
  100e97:	0f b7 c0             	movzwl %ax,%eax
  100e9a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e9e:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ea2:	89 c2                	mov    %eax,%edx
  100ea4:	ec                   	in     (%dx),%al
  100ea5:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ea8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eac:	0f b6 c0             	movzbl %al,%eax
  100eaf:	c1 e0 08             	shl    $0x8,%eax
  100eb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eb5:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ebc:	0f b7 c0             	movzwl %ax,%eax
  100ebf:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ec3:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ec7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ecb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ecf:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ed0:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ed7:	83 c0 01             	add    $0x1,%eax
  100eda:	0f b7 c0             	movzwl %ax,%eax
  100edd:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ee1:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ee5:	89 c2                	mov    %eax,%edx
  100ee7:	ec                   	in     (%dx),%al
  100ee8:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100eeb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eef:	0f b6 c0             	movzbl %al,%eax
  100ef2:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ef8:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f00:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100f06:	c9                   	leave  
  100f07:	c3                   	ret    

00100f08 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f08:	55                   	push   %ebp
  100f09:	89 e5                	mov    %esp,%ebp
  100f0b:	83 ec 48             	sub    $0x48,%esp
  100f0e:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f14:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f18:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f1c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f20:	ee                   	out    %al,(%dx)
  100f21:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f27:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f2b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f2f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f33:	ee                   	out    %al,(%dx)
  100f34:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f3a:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f3e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f42:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f46:	ee                   	out    %al,(%dx)
  100f47:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f4d:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f51:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f55:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f59:	ee                   	out    %al,(%dx)
  100f5a:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f60:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f64:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f68:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f6c:	ee                   	out    %al,(%dx)
  100f6d:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f73:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f77:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f7b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f7f:	ee                   	out    %al,(%dx)
  100f80:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f86:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f8a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f8e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f92:	ee                   	out    %al,(%dx)
  100f93:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f99:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f9d:	89 c2                	mov    %eax,%edx
  100f9f:	ec                   	in     (%dx),%al
  100fa0:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fa3:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fa7:	3c ff                	cmp    $0xff,%al
  100fa9:	0f 95 c0             	setne  %al
  100fac:	0f b6 c0             	movzbl %al,%eax
  100faf:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fb4:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fba:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fbe:	89 c2                	mov    %eax,%edx
  100fc0:	ec                   	in     (%dx),%al
  100fc1:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fc4:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fca:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fce:	89 c2                	mov    %eax,%edx
  100fd0:	ec                   	in     (%dx),%al
  100fd1:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fd4:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fd9:	85 c0                	test   %eax,%eax
  100fdb:	74 0c                	je     100fe9 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fdd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fe4:	e8 b0 06 00 00       	call   101699 <pic_enable>
    }
}
  100fe9:	c9                   	leave  
  100fea:	c3                   	ret    

00100feb <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100feb:	55                   	push   %ebp
  100fec:	89 e5                	mov    %esp,%ebp
  100fee:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ff1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100ff8:	eb 09                	jmp    101003 <lpt_putc_sub+0x18>
        delay();
  100ffa:	e8 db fd ff ff       	call   100dda <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101003:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101009:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10100d:	89 c2                	mov    %eax,%edx
  10100f:	ec                   	in     (%dx),%al
  101010:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101013:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101017:	84 c0                	test   %al,%al
  101019:	78 09                	js     101024 <lpt_putc_sub+0x39>
  10101b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101022:	7e d6                	jle    100ffa <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101024:	8b 45 08             	mov    0x8(%ebp),%eax
  101027:	0f b6 c0             	movzbl %al,%eax
  10102a:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101030:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101033:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101037:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10103b:	ee                   	out    %al,(%dx)
  10103c:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101042:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101046:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10104a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10104e:	ee                   	out    %al,(%dx)
  10104f:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101055:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101059:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10105d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101061:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101062:	c9                   	leave  
  101063:	c3                   	ret    

00101064 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101064:	55                   	push   %ebp
  101065:	89 e5                	mov    %esp,%ebp
  101067:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10106a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10106e:	74 0d                	je     10107d <lpt_putc+0x19>
        lpt_putc_sub(c);
  101070:	8b 45 08             	mov    0x8(%ebp),%eax
  101073:	89 04 24             	mov    %eax,(%esp)
  101076:	e8 70 ff ff ff       	call   100feb <lpt_putc_sub>
  10107b:	eb 24                	jmp    1010a1 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10107d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101084:	e8 62 ff ff ff       	call   100feb <lpt_putc_sub>
        lpt_putc_sub(' ');
  101089:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101090:	e8 56 ff ff ff       	call   100feb <lpt_putc_sub>
        lpt_putc_sub('\b');
  101095:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10109c:	e8 4a ff ff ff       	call   100feb <lpt_putc_sub>
    }
}
  1010a1:	c9                   	leave  
  1010a2:	c3                   	ret    

001010a3 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010a3:	55                   	push   %ebp
  1010a4:	89 e5                	mov    %esp,%ebp
  1010a6:	53                   	push   %ebx
  1010a7:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ad:	b0 00                	mov    $0x0,%al
  1010af:	85 c0                	test   %eax,%eax
  1010b1:	75 07                	jne    1010ba <cga_putc+0x17>
        c |= 0x0700;
  1010b3:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bd:	0f b6 c0             	movzbl %al,%eax
  1010c0:	83 f8 0a             	cmp    $0xa,%eax
  1010c3:	74 4c                	je     101111 <cga_putc+0x6e>
  1010c5:	83 f8 0d             	cmp    $0xd,%eax
  1010c8:	74 57                	je     101121 <cga_putc+0x7e>
  1010ca:	83 f8 08             	cmp    $0x8,%eax
  1010cd:	0f 85 88 00 00 00    	jne    10115b <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010d3:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010da:	66 85 c0             	test   %ax,%ax
  1010dd:	74 30                	je     10110f <cga_putc+0x6c>
            crt_pos --;
  1010df:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e6:	83 e8 01             	sub    $0x1,%eax
  1010e9:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010ef:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010f4:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010fb:	0f b7 d2             	movzwl %dx,%edx
  1010fe:	01 d2                	add    %edx,%edx
  101100:	01 c2                	add    %eax,%edx
  101102:	8b 45 08             	mov    0x8(%ebp),%eax
  101105:	b0 00                	mov    $0x0,%al
  101107:	83 c8 20             	or     $0x20,%eax
  10110a:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10110d:	eb 72                	jmp    101181 <cga_putc+0xde>
  10110f:	eb 70                	jmp    101181 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101111:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101118:	83 c0 50             	add    $0x50,%eax
  10111b:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101121:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101128:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10112f:	0f b7 c1             	movzwl %cx,%eax
  101132:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101138:	c1 e8 10             	shr    $0x10,%eax
  10113b:	89 c2                	mov    %eax,%edx
  10113d:	66 c1 ea 06          	shr    $0x6,%dx
  101141:	89 d0                	mov    %edx,%eax
  101143:	c1 e0 02             	shl    $0x2,%eax
  101146:	01 d0                	add    %edx,%eax
  101148:	c1 e0 04             	shl    $0x4,%eax
  10114b:	29 c1                	sub    %eax,%ecx
  10114d:	89 ca                	mov    %ecx,%edx
  10114f:	89 d8                	mov    %ebx,%eax
  101151:	29 d0                	sub    %edx,%eax
  101153:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101159:	eb 26                	jmp    101181 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10115b:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101161:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101168:	8d 50 01             	lea    0x1(%eax),%edx
  10116b:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101172:	0f b7 c0             	movzwl %ax,%eax
  101175:	01 c0                	add    %eax,%eax
  101177:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10117a:	8b 45 08             	mov    0x8(%ebp),%eax
  10117d:	66 89 02             	mov    %ax,(%edx)
        break;
  101180:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101181:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101188:	66 3d cf 07          	cmp    $0x7cf,%ax
  10118c:	76 5b                	jbe    1011e9 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10118e:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101193:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101199:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10119e:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011a5:	00 
  1011a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011aa:	89 04 24             	mov    %eax,(%esp)
  1011ad:	e8 e8 1f 00 00       	call   10319a <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011b2:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011b9:	eb 15                	jmp    1011d0 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011bb:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011c3:	01 d2                	add    %edx,%edx
  1011c5:	01 d0                	add    %edx,%eax
  1011c7:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011d0:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011d7:	7e e2                	jle    1011bb <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011d9:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011e0:	83 e8 50             	sub    $0x50,%eax
  1011e3:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011e9:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011f0:	0f b7 c0             	movzwl %ax,%eax
  1011f3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011f7:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011fb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011ff:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101203:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101204:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10120b:	66 c1 e8 08          	shr    $0x8,%ax
  10120f:	0f b6 c0             	movzbl %al,%eax
  101212:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101219:	83 c2 01             	add    $0x1,%edx
  10121c:	0f b7 d2             	movzwl %dx,%edx
  10121f:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101223:	88 45 ed             	mov    %al,-0x13(%ebp)
  101226:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10122a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10122e:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10122f:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101236:	0f b7 c0             	movzwl %ax,%eax
  101239:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10123d:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101241:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101245:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101249:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10124a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101251:	0f b6 c0             	movzbl %al,%eax
  101254:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10125b:	83 c2 01             	add    $0x1,%edx
  10125e:	0f b7 d2             	movzwl %dx,%edx
  101261:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101265:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101268:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10126c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101270:	ee                   	out    %al,(%dx)
}
  101271:	83 c4 34             	add    $0x34,%esp
  101274:	5b                   	pop    %ebx
  101275:	5d                   	pop    %ebp
  101276:	c3                   	ret    

00101277 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101277:	55                   	push   %ebp
  101278:	89 e5                	mov    %esp,%ebp
  10127a:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10127d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101284:	eb 09                	jmp    10128f <serial_putc_sub+0x18>
        delay();
  101286:	e8 4f fb ff ff       	call   100dda <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10128b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10128f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101295:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101299:	89 c2                	mov    %eax,%edx
  10129b:	ec                   	in     (%dx),%al
  10129c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10129f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012a3:	0f b6 c0             	movzbl %al,%eax
  1012a6:	83 e0 20             	and    $0x20,%eax
  1012a9:	85 c0                	test   %eax,%eax
  1012ab:	75 09                	jne    1012b6 <serial_putc_sub+0x3f>
  1012ad:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012b4:	7e d0                	jle    101286 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1012b9:	0f b6 c0             	movzbl %al,%eax
  1012bc:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012c2:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c5:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012c9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012cd:	ee                   	out    %al,(%dx)
}
  1012ce:	c9                   	leave  
  1012cf:	c3                   	ret    

001012d0 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012d0:	55                   	push   %ebp
  1012d1:	89 e5                	mov    %esp,%ebp
  1012d3:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012d6:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012da:	74 0d                	je     1012e9 <serial_putc+0x19>
        serial_putc_sub(c);
  1012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1012df:	89 04 24             	mov    %eax,(%esp)
  1012e2:	e8 90 ff ff ff       	call   101277 <serial_putc_sub>
  1012e7:	eb 24                	jmp    10130d <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012e9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012f0:	e8 82 ff ff ff       	call   101277 <serial_putc_sub>
        serial_putc_sub(' ');
  1012f5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012fc:	e8 76 ff ff ff       	call   101277 <serial_putc_sub>
        serial_putc_sub('\b');
  101301:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101308:	e8 6a ff ff ff       	call   101277 <serial_putc_sub>
    }
}
  10130d:	c9                   	leave  
  10130e:	c3                   	ret    

0010130f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10130f:	55                   	push   %ebp
  101310:	89 e5                	mov    %esp,%ebp
  101312:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101315:	eb 33                	jmp    10134a <cons_intr+0x3b>
        if (c != 0) {
  101317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10131b:	74 2d                	je     10134a <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10131d:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101322:	8d 50 01             	lea    0x1(%eax),%edx
  101325:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10132b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10132e:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101334:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101339:	3d 00 02 00 00       	cmp    $0x200,%eax
  10133e:	75 0a                	jne    10134a <cons_intr+0x3b>
                cons.wpos = 0;
  101340:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101347:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10134a:	8b 45 08             	mov    0x8(%ebp),%eax
  10134d:	ff d0                	call   *%eax
  10134f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101352:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101356:	75 bf                	jne    101317 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101358:	c9                   	leave  
  101359:	c3                   	ret    

0010135a <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10135a:	55                   	push   %ebp
  10135b:	89 e5                	mov    %esp,%ebp
  10135d:	83 ec 10             	sub    $0x10,%esp
  101360:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101366:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10136a:	89 c2                	mov    %eax,%edx
  10136c:	ec                   	in     (%dx),%al
  10136d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101370:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101374:	0f b6 c0             	movzbl %al,%eax
  101377:	83 e0 01             	and    $0x1,%eax
  10137a:	85 c0                	test   %eax,%eax
  10137c:	75 07                	jne    101385 <serial_proc_data+0x2b>
        return -1;
  10137e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101383:	eb 2a                	jmp    1013af <serial_proc_data+0x55>
  101385:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10138b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10138f:	89 c2                	mov    %eax,%edx
  101391:	ec                   	in     (%dx),%al
  101392:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101395:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101399:	0f b6 c0             	movzbl %al,%eax
  10139c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10139f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013a3:	75 07                	jne    1013ac <serial_proc_data+0x52>
        c = '\b';
  1013a5:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013af:	c9                   	leave  
  1013b0:	c3                   	ret    

001013b1 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013b1:	55                   	push   %ebp
  1013b2:	89 e5                	mov    %esp,%ebp
  1013b4:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013b7:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013bc:	85 c0                	test   %eax,%eax
  1013be:	74 0c                	je     1013cc <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013c0:	c7 04 24 5a 13 10 00 	movl   $0x10135a,(%esp)
  1013c7:	e8 43 ff ff ff       	call   10130f <cons_intr>
    }
}
  1013cc:	c9                   	leave  
  1013cd:	c3                   	ret    

001013ce <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013ce:	55                   	push   %ebp
  1013cf:	89 e5                	mov    %esp,%ebp
  1013d1:	83 ec 38             	sub    $0x38,%esp
  1013d4:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013da:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013de:	89 c2                	mov    %eax,%edx
  1013e0:	ec                   	in     (%dx),%al
  1013e1:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013e4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013e8:	0f b6 c0             	movzbl %al,%eax
  1013eb:	83 e0 01             	and    $0x1,%eax
  1013ee:	85 c0                	test   %eax,%eax
  1013f0:	75 0a                	jne    1013fc <kbd_proc_data+0x2e>
        return -1;
  1013f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013f7:	e9 59 01 00 00       	jmp    101555 <kbd_proc_data+0x187>
  1013fc:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101402:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101406:	89 c2                	mov    %eax,%edx
  101408:	ec                   	in     (%dx),%al
  101409:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10140c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101410:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101413:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101417:	75 17                	jne    101430 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101419:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10141e:	83 c8 40             	or     $0x40,%eax
  101421:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101426:	b8 00 00 00 00       	mov    $0x0,%eax
  10142b:	e9 25 01 00 00       	jmp    101555 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101430:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101434:	84 c0                	test   %al,%al
  101436:	79 47                	jns    10147f <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101438:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10143d:	83 e0 40             	and    $0x40,%eax
  101440:	85 c0                	test   %eax,%eax
  101442:	75 09                	jne    10144d <kbd_proc_data+0x7f>
  101444:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101448:	83 e0 7f             	and    $0x7f,%eax
  10144b:	eb 04                	jmp    101451 <kbd_proc_data+0x83>
  10144d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101451:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101454:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101458:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10145f:	83 c8 40             	or     $0x40,%eax
  101462:	0f b6 c0             	movzbl %al,%eax
  101465:	f7 d0                	not    %eax
  101467:	89 c2                	mov    %eax,%edx
  101469:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10146e:	21 d0                	and    %edx,%eax
  101470:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101475:	b8 00 00 00 00       	mov    $0x0,%eax
  10147a:	e9 d6 00 00 00       	jmp    101555 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10147f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101484:	83 e0 40             	and    $0x40,%eax
  101487:	85 c0                	test   %eax,%eax
  101489:	74 11                	je     10149c <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10148b:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10148f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101494:	83 e0 bf             	and    $0xffffffbf,%eax
  101497:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014a7:	0f b6 d0             	movzbl %al,%edx
  1014aa:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014af:	09 d0                	or     %edx,%eax
  1014b1:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014b6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ba:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014c1:	0f b6 d0             	movzbl %al,%edx
  1014c4:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c9:	31 d0                	xor    %edx,%eax
  1014cb:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014d0:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d5:	83 e0 03             	and    $0x3,%eax
  1014d8:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014df:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e3:	01 d0                	add    %edx,%eax
  1014e5:	0f b6 00             	movzbl (%eax),%eax
  1014e8:	0f b6 c0             	movzbl %al,%eax
  1014eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014ee:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f3:	83 e0 08             	and    $0x8,%eax
  1014f6:	85 c0                	test   %eax,%eax
  1014f8:	74 22                	je     10151c <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014fa:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014fe:	7e 0c                	jle    10150c <kbd_proc_data+0x13e>
  101500:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101504:	7f 06                	jg     10150c <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101506:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10150a:	eb 10                	jmp    10151c <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10150c:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101510:	7e 0a                	jle    10151c <kbd_proc_data+0x14e>
  101512:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101516:	7f 04                	jg     10151c <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101518:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10151c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101521:	f7 d0                	not    %eax
  101523:	83 e0 06             	and    $0x6,%eax
  101526:	85 c0                	test   %eax,%eax
  101528:	75 28                	jne    101552 <kbd_proc_data+0x184>
  10152a:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101531:	75 1f                	jne    101552 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101533:	c7 04 24 2f 36 10 00 	movl   $0x10362f,(%esp)
  10153a:	e8 d3 ed ff ff       	call   100312 <cprintf>
  10153f:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101545:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101549:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10154d:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101551:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101552:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101555:	c9                   	leave  
  101556:	c3                   	ret    

00101557 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101557:	55                   	push   %ebp
  101558:	89 e5                	mov    %esp,%ebp
  10155a:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10155d:	c7 04 24 ce 13 10 00 	movl   $0x1013ce,(%esp)
  101564:	e8 a6 fd ff ff       	call   10130f <cons_intr>
}
  101569:	c9                   	leave  
  10156a:	c3                   	ret    

0010156b <kbd_init>:

static void
kbd_init(void) {
  10156b:	55                   	push   %ebp
  10156c:	89 e5                	mov    %esp,%ebp
  10156e:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101571:	e8 e1 ff ff ff       	call   101557 <kbd_intr>
    pic_enable(IRQ_KBD);
  101576:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10157d:	e8 17 01 00 00       	call   101699 <pic_enable>
}
  101582:	c9                   	leave  
  101583:	c3                   	ret    

00101584 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101584:	55                   	push   %ebp
  101585:	89 e5                	mov    %esp,%ebp
  101587:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10158a:	e8 93 f8 ff ff       	call   100e22 <cga_init>
    serial_init();
  10158f:	e8 74 f9 ff ff       	call   100f08 <serial_init>
    kbd_init();
  101594:	e8 d2 ff ff ff       	call   10156b <kbd_init>
    if (!serial_exists) {
  101599:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10159e:	85 c0                	test   %eax,%eax
  1015a0:	75 0c                	jne    1015ae <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015a2:	c7 04 24 3b 36 10 00 	movl   $0x10363b,(%esp)
  1015a9:	e8 64 ed ff ff       	call   100312 <cprintf>
    }
}
  1015ae:	c9                   	leave  
  1015af:	c3                   	ret    

001015b0 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015b0:	55                   	push   %ebp
  1015b1:	89 e5                	mov    %esp,%ebp
  1015b3:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b9:	89 04 24             	mov    %eax,(%esp)
  1015bc:	e8 a3 fa ff ff       	call   101064 <lpt_putc>
    cga_putc(c);
  1015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c4:	89 04 24             	mov    %eax,(%esp)
  1015c7:	e8 d7 fa ff ff       	call   1010a3 <cga_putc>
    serial_putc(c);
  1015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1015cf:	89 04 24             	mov    %eax,(%esp)
  1015d2:	e8 f9 fc ff ff       	call   1012d0 <serial_putc>
}
  1015d7:	c9                   	leave  
  1015d8:	c3                   	ret    

001015d9 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015d9:	55                   	push   %ebp
  1015da:	89 e5                	mov    %esp,%ebp
  1015dc:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015df:	e8 cd fd ff ff       	call   1013b1 <serial_intr>
    kbd_intr();
  1015e4:	e8 6e ff ff ff       	call   101557 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015e9:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015ef:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015f4:	39 c2                	cmp    %eax,%edx
  1015f6:	74 36                	je     10162e <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015f8:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015fd:	8d 50 01             	lea    0x1(%eax),%edx
  101600:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101606:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  10160d:	0f b6 c0             	movzbl %al,%eax
  101610:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101613:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101618:	3d 00 02 00 00       	cmp    $0x200,%eax
  10161d:	75 0a                	jne    101629 <cons_getc+0x50>
            cons.rpos = 0;
  10161f:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101626:	00 00 00 
        }
        return c;
  101629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162c:	eb 05                	jmp    101633 <cons_getc+0x5a>
    }
    return 0;
  10162e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101633:	c9                   	leave  
  101634:	c3                   	ret    

00101635 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101635:	55                   	push   %ebp
  101636:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101638:	fb                   	sti    
    sti();
}
  101639:	5d                   	pop    %ebp
  10163a:	c3                   	ret    

0010163b <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10163b:	55                   	push   %ebp
  10163c:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  10163e:	fa                   	cli    
    cli();
}
  10163f:	5d                   	pop    %ebp
  101640:	c3                   	ret    

00101641 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101641:	55                   	push   %ebp
  101642:	89 e5                	mov    %esp,%ebp
  101644:	83 ec 14             	sub    $0x14,%esp
  101647:	8b 45 08             	mov    0x8(%ebp),%eax
  10164a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10164e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101652:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101658:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  10165d:	85 c0                	test   %eax,%eax
  10165f:	74 36                	je     101697 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101661:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101665:	0f b6 c0             	movzbl %al,%eax
  101668:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10166e:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101671:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101675:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101679:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10167a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10167e:	66 c1 e8 08          	shr    $0x8,%ax
  101682:	0f b6 c0             	movzbl %al,%eax
  101685:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10168b:	88 45 f9             	mov    %al,-0x7(%ebp)
  10168e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101692:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101696:	ee                   	out    %al,(%dx)
    }
}
  101697:	c9                   	leave  
  101698:	c3                   	ret    

00101699 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101699:	55                   	push   %ebp
  10169a:	89 e5                	mov    %esp,%ebp
  10169c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10169f:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a2:	ba 01 00 00 00       	mov    $0x1,%edx
  1016a7:	89 c1                	mov    %eax,%ecx
  1016a9:	d3 e2                	shl    %cl,%edx
  1016ab:	89 d0                	mov    %edx,%eax
  1016ad:	f7 d0                	not    %eax
  1016af:	89 c2                	mov    %eax,%edx
  1016b1:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016b8:	21 d0                	and    %edx,%eax
  1016ba:	0f b7 c0             	movzwl %ax,%eax
  1016bd:	89 04 24             	mov    %eax,(%esp)
  1016c0:	e8 7c ff ff ff       	call   101641 <pic_setmask>
}
  1016c5:	c9                   	leave  
  1016c6:	c3                   	ret    

001016c7 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016c7:	55                   	push   %ebp
  1016c8:	89 e5                	mov    %esp,%ebp
  1016ca:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016cd:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016d4:	00 00 00 
  1016d7:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016dd:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016e1:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e5:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e9:	ee                   	out    %al,(%dx)
  1016ea:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f0:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016f4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016f8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016fc:	ee                   	out    %al,(%dx)
  1016fd:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101703:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101707:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10170b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10170f:	ee                   	out    %al,(%dx)
  101710:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101716:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10171a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10171e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101722:	ee                   	out    %al,(%dx)
  101723:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101729:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10172d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101731:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101735:	ee                   	out    %al,(%dx)
  101736:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10173c:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101740:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101744:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101748:	ee                   	out    %al,(%dx)
  101749:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10174f:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101753:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101757:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10175b:	ee                   	out    %al,(%dx)
  10175c:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101762:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101766:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10176a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10176e:	ee                   	out    %al,(%dx)
  10176f:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101775:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101779:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10177d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101781:	ee                   	out    %al,(%dx)
  101782:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101788:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10178c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101790:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101794:	ee                   	out    %al,(%dx)
  101795:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10179b:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10179f:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017a3:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017a7:	ee                   	out    %al,(%dx)
  1017a8:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017ae:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017b2:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017b6:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017ba:	ee                   	out    %al,(%dx)
  1017bb:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017c1:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017c5:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017c9:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017cd:	ee                   	out    %al,(%dx)
  1017ce:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017d4:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017d8:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017dc:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017e0:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017e1:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e8:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017ec:	74 12                	je     101800 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017ee:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017f5:	0f b7 c0             	movzwl %ax,%eax
  1017f8:	89 04 24             	mov    %eax,(%esp)
  1017fb:	e8 41 fe ff ff       	call   101641 <pic_setmask>
    }
}
  101800:	c9                   	leave  
  101801:	c3                   	ret    

00101802 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101802:	55                   	push   %ebp
  101803:	89 e5                	mov    %esp,%ebp
  101805:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101808:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10180f:	00 
  101810:	c7 04 24 60 36 10 00 	movl   $0x103660,(%esp)
  101817:	e8 f6 ea ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10181c:	c9                   	leave  
  10181d:	c3                   	ret    

0010181e <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10181e:	55                   	push   %ebp
  10181f:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101821:	5d                   	pop    %ebp
  101822:	c3                   	ret    

00101823 <trapname>:

static const char *
trapname(int trapno) {
  101823:	55                   	push   %ebp
  101824:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101826:	8b 45 08             	mov    0x8(%ebp),%eax
  101829:	83 f8 13             	cmp    $0x13,%eax
  10182c:	77 0c                	ja     10183a <trapname+0x17>
        return excnames[trapno];
  10182e:	8b 45 08             	mov    0x8(%ebp),%eax
  101831:	8b 04 85 c0 39 10 00 	mov    0x1039c0(,%eax,4),%eax
  101838:	eb 18                	jmp    101852 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  10183a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10183e:	7e 0d                	jle    10184d <trapname+0x2a>
  101840:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101844:	7f 07                	jg     10184d <trapname+0x2a>
        return "Hardware Interrupt";
  101846:	b8 6a 36 10 00       	mov    $0x10366a,%eax
  10184b:	eb 05                	jmp    101852 <trapname+0x2f>
    }
    return "(unknown trap)";
  10184d:	b8 7d 36 10 00       	mov    $0x10367d,%eax
}
  101852:	5d                   	pop    %ebp
  101853:	c3                   	ret    

00101854 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101854:	55                   	push   %ebp
  101855:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101857:	8b 45 08             	mov    0x8(%ebp),%eax
  10185a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10185e:	66 83 f8 08          	cmp    $0x8,%ax
  101862:	0f 94 c0             	sete   %al
  101865:	0f b6 c0             	movzbl %al,%eax
}
  101868:	5d                   	pop    %ebp
  101869:	c3                   	ret    

0010186a <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  10186a:	55                   	push   %ebp
  10186b:	89 e5                	mov    %esp,%ebp
  10186d:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101870:	8b 45 08             	mov    0x8(%ebp),%eax
  101873:	89 44 24 04          	mov    %eax,0x4(%esp)
  101877:	c7 04 24 be 36 10 00 	movl   $0x1036be,(%esp)
  10187e:	e8 8f ea ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  101883:	8b 45 08             	mov    0x8(%ebp),%eax
  101886:	89 04 24             	mov    %eax,(%esp)
  101889:	e8 a1 01 00 00       	call   101a2f <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  10188e:	8b 45 08             	mov    0x8(%ebp),%eax
  101891:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101895:	0f b7 c0             	movzwl %ax,%eax
  101898:	89 44 24 04          	mov    %eax,0x4(%esp)
  10189c:	c7 04 24 cf 36 10 00 	movl   $0x1036cf,(%esp)
  1018a3:	e8 6a ea ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1018ab:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1018af:	0f b7 c0             	movzwl %ax,%eax
  1018b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018b6:	c7 04 24 e2 36 10 00 	movl   $0x1036e2,(%esp)
  1018bd:	e8 50 ea ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1018c5:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1018c9:	0f b7 c0             	movzwl %ax,%eax
  1018cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018d0:	c7 04 24 f5 36 10 00 	movl   $0x1036f5,(%esp)
  1018d7:	e8 36 ea ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1018df:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1018e3:	0f b7 c0             	movzwl %ax,%eax
  1018e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018ea:	c7 04 24 08 37 10 00 	movl   $0x103708,(%esp)
  1018f1:	e8 1c ea ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1018f9:	8b 40 30             	mov    0x30(%eax),%eax
  1018fc:	89 04 24             	mov    %eax,(%esp)
  1018ff:	e8 1f ff ff ff       	call   101823 <trapname>
  101904:	8b 55 08             	mov    0x8(%ebp),%edx
  101907:	8b 52 30             	mov    0x30(%edx),%edx
  10190a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10190e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101912:	c7 04 24 1b 37 10 00 	movl   $0x10371b,(%esp)
  101919:	e8 f4 e9 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  10191e:	8b 45 08             	mov    0x8(%ebp),%eax
  101921:	8b 40 34             	mov    0x34(%eax),%eax
  101924:	89 44 24 04          	mov    %eax,0x4(%esp)
  101928:	c7 04 24 2d 37 10 00 	movl   $0x10372d,(%esp)
  10192f:	e8 de e9 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101934:	8b 45 08             	mov    0x8(%ebp),%eax
  101937:	8b 40 38             	mov    0x38(%eax),%eax
  10193a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10193e:	c7 04 24 3c 37 10 00 	movl   $0x10373c,(%esp)
  101945:	e8 c8 e9 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  10194a:	8b 45 08             	mov    0x8(%ebp),%eax
  10194d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101951:	0f b7 c0             	movzwl %ax,%eax
  101954:	89 44 24 04          	mov    %eax,0x4(%esp)
  101958:	c7 04 24 4b 37 10 00 	movl   $0x10374b,(%esp)
  10195f:	e8 ae e9 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101964:	8b 45 08             	mov    0x8(%ebp),%eax
  101967:	8b 40 40             	mov    0x40(%eax),%eax
  10196a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10196e:	c7 04 24 5e 37 10 00 	movl   $0x10375e,(%esp)
  101975:	e8 98 e9 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  10197a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101981:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101988:	eb 3e                	jmp    1019c8 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  10198a:	8b 45 08             	mov    0x8(%ebp),%eax
  10198d:	8b 50 40             	mov    0x40(%eax),%edx
  101990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101993:	21 d0                	and    %edx,%eax
  101995:	85 c0                	test   %eax,%eax
  101997:	74 28                	je     1019c1 <print_trapframe+0x157>
  101999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10199c:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  1019a3:	85 c0                	test   %eax,%eax
  1019a5:	74 1a                	je     1019c1 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  1019a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019aa:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  1019b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019b5:	c7 04 24 6d 37 10 00 	movl   $0x10376d,(%esp)
  1019bc:	e8 51 e9 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1019c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1019c5:	d1 65 f0             	shll   -0x10(%ebp)
  1019c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019cb:	83 f8 17             	cmp    $0x17,%eax
  1019ce:	76 ba                	jbe    10198a <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  1019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d3:	8b 40 40             	mov    0x40(%eax),%eax
  1019d6:	25 00 30 00 00       	and    $0x3000,%eax
  1019db:	c1 e8 0c             	shr    $0xc,%eax
  1019de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019e2:	c7 04 24 71 37 10 00 	movl   $0x103771,(%esp)
  1019e9:	e8 24 e9 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  1019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f1:	89 04 24             	mov    %eax,(%esp)
  1019f4:	e8 5b fe ff ff       	call   101854 <trap_in_kernel>
  1019f9:	85 c0                	test   %eax,%eax
  1019fb:	75 30                	jne    101a2d <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  1019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101a00:	8b 40 44             	mov    0x44(%eax),%eax
  101a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a07:	c7 04 24 7a 37 10 00 	movl   $0x10377a,(%esp)
  101a0e:	e8 ff e8 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101a13:	8b 45 08             	mov    0x8(%ebp),%eax
  101a16:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101a1a:	0f b7 c0             	movzwl %ax,%eax
  101a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a21:	c7 04 24 89 37 10 00 	movl   $0x103789,(%esp)
  101a28:	e8 e5 e8 ff ff       	call   100312 <cprintf>
    }
}
  101a2d:	c9                   	leave  
  101a2e:	c3                   	ret    

00101a2f <print_regs>:

void
print_regs(struct pushregs *regs) {
  101a2f:	55                   	push   %ebp
  101a30:	89 e5                	mov    %esp,%ebp
  101a32:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101a35:	8b 45 08             	mov    0x8(%ebp),%eax
  101a38:	8b 00                	mov    (%eax),%eax
  101a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3e:	c7 04 24 9c 37 10 00 	movl   $0x10379c,(%esp)
  101a45:	e8 c8 e8 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4d:	8b 40 04             	mov    0x4(%eax),%eax
  101a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a54:	c7 04 24 ab 37 10 00 	movl   $0x1037ab,(%esp)
  101a5b:	e8 b2 e8 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101a60:	8b 45 08             	mov    0x8(%ebp),%eax
  101a63:	8b 40 08             	mov    0x8(%eax),%eax
  101a66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6a:	c7 04 24 ba 37 10 00 	movl   $0x1037ba,(%esp)
  101a71:	e8 9c e8 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101a76:	8b 45 08             	mov    0x8(%ebp),%eax
  101a79:	8b 40 0c             	mov    0xc(%eax),%eax
  101a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a80:	c7 04 24 c9 37 10 00 	movl   $0x1037c9,(%esp)
  101a87:	e8 86 e8 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8f:	8b 40 10             	mov    0x10(%eax),%eax
  101a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a96:	c7 04 24 d8 37 10 00 	movl   $0x1037d8,(%esp)
  101a9d:	e8 70 e8 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa5:	8b 40 14             	mov    0x14(%eax),%eax
  101aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aac:	c7 04 24 e7 37 10 00 	movl   $0x1037e7,(%esp)
  101ab3:	e8 5a e8 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  101abb:	8b 40 18             	mov    0x18(%eax),%eax
  101abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac2:	c7 04 24 f6 37 10 00 	movl   $0x1037f6,(%esp)
  101ac9:	e8 44 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ace:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad1:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad8:	c7 04 24 05 38 10 00 	movl   $0x103805,(%esp)
  101adf:	e8 2e e8 ff ff       	call   100312 <cprintf>
}
  101ae4:	c9                   	leave  
  101ae5:	c3                   	ret    

00101ae6 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ae6:	55                   	push   %ebp
  101ae7:	89 e5                	mov    %esp,%ebp
  101ae9:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101aec:	8b 45 08             	mov    0x8(%ebp),%eax
  101aef:	8b 40 30             	mov    0x30(%eax),%eax
  101af2:	83 f8 2f             	cmp    $0x2f,%eax
  101af5:	77 1e                	ja     101b15 <trap_dispatch+0x2f>
  101af7:	83 f8 2e             	cmp    $0x2e,%eax
  101afa:	0f 83 bf 00 00 00    	jae    101bbf <trap_dispatch+0xd9>
  101b00:	83 f8 21             	cmp    $0x21,%eax
  101b03:	74 40                	je     101b45 <trap_dispatch+0x5f>
  101b05:	83 f8 24             	cmp    $0x24,%eax
  101b08:	74 15                	je     101b1f <trap_dispatch+0x39>
  101b0a:	83 f8 20             	cmp    $0x20,%eax
  101b0d:	0f 84 af 00 00 00    	je     101bc2 <trap_dispatch+0xdc>
  101b13:	eb 72                	jmp    101b87 <trap_dispatch+0xa1>
  101b15:	83 e8 78             	sub    $0x78,%eax
  101b18:	83 f8 01             	cmp    $0x1,%eax
  101b1b:	77 6a                	ja     101b87 <trap_dispatch+0xa1>
  101b1d:	eb 4c                	jmp    101b6b <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101b1f:	e8 b5 fa ff ff       	call   1015d9 <cons_getc>
  101b24:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101b27:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b2b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b2f:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b37:	c7 04 24 14 38 10 00 	movl   $0x103814,(%esp)
  101b3e:	e8 cf e7 ff ff       	call   100312 <cprintf>
        break;
  101b43:	eb 7e                	jmp    101bc3 <trap_dispatch+0xdd>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101b45:	e8 8f fa ff ff       	call   1015d9 <cons_getc>
  101b4a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101b4d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b51:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b55:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b59:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5d:	c7 04 24 26 38 10 00 	movl   $0x103826,(%esp)
  101b64:	e8 a9 e7 ff ff       	call   100312 <cprintf>
        break;
  101b69:	eb 58                	jmp    101bc3 <trap_dispatch+0xdd>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101b6b:	c7 44 24 08 35 38 10 	movl   $0x103835,0x8(%esp)
  101b72:	00 
  101b73:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  101b7a:	00 
  101b7b:	c7 04 24 45 38 10 00 	movl   $0x103845,(%esp)
  101b82:	e8 23 f1 ff ff       	call   100caa <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101b87:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b8e:	0f b7 c0             	movzwl %ax,%eax
  101b91:	83 e0 03             	and    $0x3,%eax
  101b94:	85 c0                	test   %eax,%eax
  101b96:	75 2b                	jne    101bc3 <trap_dispatch+0xdd>
            print_trapframe(tf);
  101b98:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9b:	89 04 24             	mov    %eax,(%esp)
  101b9e:	e8 c7 fc ff ff       	call   10186a <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ba3:	c7 44 24 08 56 38 10 	movl   $0x103856,0x8(%esp)
  101baa:	00 
  101bab:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101bb2:	00 
  101bb3:	c7 04 24 45 38 10 00 	movl   $0x103845,(%esp)
  101bba:	e8 eb f0 ff ff       	call   100caa <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101bbf:	90                   	nop
  101bc0:	eb 01                	jmp    101bc3 <trap_dispatch+0xdd>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
  101bc2:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101bc3:	c9                   	leave  
  101bc4:	c3                   	ret    

00101bc5 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101bc5:	55                   	push   %ebp
  101bc6:	89 e5                	mov    %esp,%ebp
  101bc8:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bce:	89 04 24             	mov    %eax,(%esp)
  101bd1:	e8 10 ff ff ff       	call   101ae6 <trap_dispatch>
}
  101bd6:	c9                   	leave  
  101bd7:	c3                   	ret    

00101bd8 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101bd8:	1e                   	push   %ds
    pushl %es
  101bd9:	06                   	push   %es
    pushl %fs
  101bda:	0f a0                	push   %fs
    pushl %gs
  101bdc:	0f a8                	push   %gs
    pushal
  101bde:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101bdf:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101be4:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101be6:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101be8:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101be9:	e8 d7 ff ff ff       	call   101bc5 <trap>

    # pop the pushed stack pointer
    popl %esp
  101bee:	5c                   	pop    %esp

00101bef <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101bef:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101bf0:	0f a9                	pop    %gs
    popl %fs
  101bf2:	0f a1                	pop    %fs
    popl %es
  101bf4:	07                   	pop    %es
    popl %ds
  101bf5:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101bf6:	83 c4 08             	add    $0x8,%esp
    iret
  101bf9:	cf                   	iret   

00101bfa <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101bfa:	6a 00                	push   $0x0
  pushl $0
  101bfc:	6a 00                	push   $0x0
  jmp __alltraps
  101bfe:	e9 d5 ff ff ff       	jmp    101bd8 <__alltraps>

00101c03 <vector1>:
.globl vector1
vector1:
  pushl $0
  101c03:	6a 00                	push   $0x0
  pushl $1
  101c05:	6a 01                	push   $0x1
  jmp __alltraps
  101c07:	e9 cc ff ff ff       	jmp    101bd8 <__alltraps>

00101c0c <vector2>:
.globl vector2
vector2:
  pushl $0
  101c0c:	6a 00                	push   $0x0
  pushl $2
  101c0e:	6a 02                	push   $0x2
  jmp __alltraps
  101c10:	e9 c3 ff ff ff       	jmp    101bd8 <__alltraps>

00101c15 <vector3>:
.globl vector3
vector3:
  pushl $0
  101c15:	6a 00                	push   $0x0
  pushl $3
  101c17:	6a 03                	push   $0x3
  jmp __alltraps
  101c19:	e9 ba ff ff ff       	jmp    101bd8 <__alltraps>

00101c1e <vector4>:
.globl vector4
vector4:
  pushl $0
  101c1e:	6a 00                	push   $0x0
  pushl $4
  101c20:	6a 04                	push   $0x4
  jmp __alltraps
  101c22:	e9 b1 ff ff ff       	jmp    101bd8 <__alltraps>

00101c27 <vector5>:
.globl vector5
vector5:
  pushl $0
  101c27:	6a 00                	push   $0x0
  pushl $5
  101c29:	6a 05                	push   $0x5
  jmp __alltraps
  101c2b:	e9 a8 ff ff ff       	jmp    101bd8 <__alltraps>

00101c30 <vector6>:
.globl vector6
vector6:
  pushl $0
  101c30:	6a 00                	push   $0x0
  pushl $6
  101c32:	6a 06                	push   $0x6
  jmp __alltraps
  101c34:	e9 9f ff ff ff       	jmp    101bd8 <__alltraps>

00101c39 <vector7>:
.globl vector7
vector7:
  pushl $0
  101c39:	6a 00                	push   $0x0
  pushl $7
  101c3b:	6a 07                	push   $0x7
  jmp __alltraps
  101c3d:	e9 96 ff ff ff       	jmp    101bd8 <__alltraps>

00101c42 <vector8>:
.globl vector8
vector8:
  pushl $8
  101c42:	6a 08                	push   $0x8
  jmp __alltraps
  101c44:	e9 8f ff ff ff       	jmp    101bd8 <__alltraps>

00101c49 <vector9>:
.globl vector9
vector9:
  pushl $0
  101c49:	6a 00                	push   $0x0
  pushl $9
  101c4b:	6a 09                	push   $0x9
  jmp __alltraps
  101c4d:	e9 86 ff ff ff       	jmp    101bd8 <__alltraps>

00101c52 <vector10>:
.globl vector10
vector10:
  pushl $10
  101c52:	6a 0a                	push   $0xa
  jmp __alltraps
  101c54:	e9 7f ff ff ff       	jmp    101bd8 <__alltraps>

00101c59 <vector11>:
.globl vector11
vector11:
  pushl $11
  101c59:	6a 0b                	push   $0xb
  jmp __alltraps
  101c5b:	e9 78 ff ff ff       	jmp    101bd8 <__alltraps>

00101c60 <vector12>:
.globl vector12
vector12:
  pushl $12
  101c60:	6a 0c                	push   $0xc
  jmp __alltraps
  101c62:	e9 71 ff ff ff       	jmp    101bd8 <__alltraps>

00101c67 <vector13>:
.globl vector13
vector13:
  pushl $13
  101c67:	6a 0d                	push   $0xd
  jmp __alltraps
  101c69:	e9 6a ff ff ff       	jmp    101bd8 <__alltraps>

00101c6e <vector14>:
.globl vector14
vector14:
  pushl $14
  101c6e:	6a 0e                	push   $0xe
  jmp __alltraps
  101c70:	e9 63 ff ff ff       	jmp    101bd8 <__alltraps>

00101c75 <vector15>:
.globl vector15
vector15:
  pushl $0
  101c75:	6a 00                	push   $0x0
  pushl $15
  101c77:	6a 0f                	push   $0xf
  jmp __alltraps
  101c79:	e9 5a ff ff ff       	jmp    101bd8 <__alltraps>

00101c7e <vector16>:
.globl vector16
vector16:
  pushl $0
  101c7e:	6a 00                	push   $0x0
  pushl $16
  101c80:	6a 10                	push   $0x10
  jmp __alltraps
  101c82:	e9 51 ff ff ff       	jmp    101bd8 <__alltraps>

00101c87 <vector17>:
.globl vector17
vector17:
  pushl $17
  101c87:	6a 11                	push   $0x11
  jmp __alltraps
  101c89:	e9 4a ff ff ff       	jmp    101bd8 <__alltraps>

00101c8e <vector18>:
.globl vector18
vector18:
  pushl $0
  101c8e:	6a 00                	push   $0x0
  pushl $18
  101c90:	6a 12                	push   $0x12
  jmp __alltraps
  101c92:	e9 41 ff ff ff       	jmp    101bd8 <__alltraps>

00101c97 <vector19>:
.globl vector19
vector19:
  pushl $0
  101c97:	6a 00                	push   $0x0
  pushl $19
  101c99:	6a 13                	push   $0x13
  jmp __alltraps
  101c9b:	e9 38 ff ff ff       	jmp    101bd8 <__alltraps>

00101ca0 <vector20>:
.globl vector20
vector20:
  pushl $0
  101ca0:	6a 00                	push   $0x0
  pushl $20
  101ca2:	6a 14                	push   $0x14
  jmp __alltraps
  101ca4:	e9 2f ff ff ff       	jmp    101bd8 <__alltraps>

00101ca9 <vector21>:
.globl vector21
vector21:
  pushl $0
  101ca9:	6a 00                	push   $0x0
  pushl $21
  101cab:	6a 15                	push   $0x15
  jmp __alltraps
  101cad:	e9 26 ff ff ff       	jmp    101bd8 <__alltraps>

00101cb2 <vector22>:
.globl vector22
vector22:
  pushl $0
  101cb2:	6a 00                	push   $0x0
  pushl $22
  101cb4:	6a 16                	push   $0x16
  jmp __alltraps
  101cb6:	e9 1d ff ff ff       	jmp    101bd8 <__alltraps>

00101cbb <vector23>:
.globl vector23
vector23:
  pushl $0
  101cbb:	6a 00                	push   $0x0
  pushl $23
  101cbd:	6a 17                	push   $0x17
  jmp __alltraps
  101cbf:	e9 14 ff ff ff       	jmp    101bd8 <__alltraps>

00101cc4 <vector24>:
.globl vector24
vector24:
  pushl $0
  101cc4:	6a 00                	push   $0x0
  pushl $24
  101cc6:	6a 18                	push   $0x18
  jmp __alltraps
  101cc8:	e9 0b ff ff ff       	jmp    101bd8 <__alltraps>

00101ccd <vector25>:
.globl vector25
vector25:
  pushl $0
  101ccd:	6a 00                	push   $0x0
  pushl $25
  101ccf:	6a 19                	push   $0x19
  jmp __alltraps
  101cd1:	e9 02 ff ff ff       	jmp    101bd8 <__alltraps>

00101cd6 <vector26>:
.globl vector26
vector26:
  pushl $0
  101cd6:	6a 00                	push   $0x0
  pushl $26
  101cd8:	6a 1a                	push   $0x1a
  jmp __alltraps
  101cda:	e9 f9 fe ff ff       	jmp    101bd8 <__alltraps>

00101cdf <vector27>:
.globl vector27
vector27:
  pushl $0
  101cdf:	6a 00                	push   $0x0
  pushl $27
  101ce1:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ce3:	e9 f0 fe ff ff       	jmp    101bd8 <__alltraps>

00101ce8 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ce8:	6a 00                	push   $0x0
  pushl $28
  101cea:	6a 1c                	push   $0x1c
  jmp __alltraps
  101cec:	e9 e7 fe ff ff       	jmp    101bd8 <__alltraps>

00101cf1 <vector29>:
.globl vector29
vector29:
  pushl $0
  101cf1:	6a 00                	push   $0x0
  pushl $29
  101cf3:	6a 1d                	push   $0x1d
  jmp __alltraps
  101cf5:	e9 de fe ff ff       	jmp    101bd8 <__alltraps>

00101cfa <vector30>:
.globl vector30
vector30:
  pushl $0
  101cfa:	6a 00                	push   $0x0
  pushl $30
  101cfc:	6a 1e                	push   $0x1e
  jmp __alltraps
  101cfe:	e9 d5 fe ff ff       	jmp    101bd8 <__alltraps>

00101d03 <vector31>:
.globl vector31
vector31:
  pushl $0
  101d03:	6a 00                	push   $0x0
  pushl $31
  101d05:	6a 1f                	push   $0x1f
  jmp __alltraps
  101d07:	e9 cc fe ff ff       	jmp    101bd8 <__alltraps>

00101d0c <vector32>:
.globl vector32
vector32:
  pushl $0
  101d0c:	6a 00                	push   $0x0
  pushl $32
  101d0e:	6a 20                	push   $0x20
  jmp __alltraps
  101d10:	e9 c3 fe ff ff       	jmp    101bd8 <__alltraps>

00101d15 <vector33>:
.globl vector33
vector33:
  pushl $0
  101d15:	6a 00                	push   $0x0
  pushl $33
  101d17:	6a 21                	push   $0x21
  jmp __alltraps
  101d19:	e9 ba fe ff ff       	jmp    101bd8 <__alltraps>

00101d1e <vector34>:
.globl vector34
vector34:
  pushl $0
  101d1e:	6a 00                	push   $0x0
  pushl $34
  101d20:	6a 22                	push   $0x22
  jmp __alltraps
  101d22:	e9 b1 fe ff ff       	jmp    101bd8 <__alltraps>

00101d27 <vector35>:
.globl vector35
vector35:
  pushl $0
  101d27:	6a 00                	push   $0x0
  pushl $35
  101d29:	6a 23                	push   $0x23
  jmp __alltraps
  101d2b:	e9 a8 fe ff ff       	jmp    101bd8 <__alltraps>

00101d30 <vector36>:
.globl vector36
vector36:
  pushl $0
  101d30:	6a 00                	push   $0x0
  pushl $36
  101d32:	6a 24                	push   $0x24
  jmp __alltraps
  101d34:	e9 9f fe ff ff       	jmp    101bd8 <__alltraps>

00101d39 <vector37>:
.globl vector37
vector37:
  pushl $0
  101d39:	6a 00                	push   $0x0
  pushl $37
  101d3b:	6a 25                	push   $0x25
  jmp __alltraps
  101d3d:	e9 96 fe ff ff       	jmp    101bd8 <__alltraps>

00101d42 <vector38>:
.globl vector38
vector38:
  pushl $0
  101d42:	6a 00                	push   $0x0
  pushl $38
  101d44:	6a 26                	push   $0x26
  jmp __alltraps
  101d46:	e9 8d fe ff ff       	jmp    101bd8 <__alltraps>

00101d4b <vector39>:
.globl vector39
vector39:
  pushl $0
  101d4b:	6a 00                	push   $0x0
  pushl $39
  101d4d:	6a 27                	push   $0x27
  jmp __alltraps
  101d4f:	e9 84 fe ff ff       	jmp    101bd8 <__alltraps>

00101d54 <vector40>:
.globl vector40
vector40:
  pushl $0
  101d54:	6a 00                	push   $0x0
  pushl $40
  101d56:	6a 28                	push   $0x28
  jmp __alltraps
  101d58:	e9 7b fe ff ff       	jmp    101bd8 <__alltraps>

00101d5d <vector41>:
.globl vector41
vector41:
  pushl $0
  101d5d:	6a 00                	push   $0x0
  pushl $41
  101d5f:	6a 29                	push   $0x29
  jmp __alltraps
  101d61:	e9 72 fe ff ff       	jmp    101bd8 <__alltraps>

00101d66 <vector42>:
.globl vector42
vector42:
  pushl $0
  101d66:	6a 00                	push   $0x0
  pushl $42
  101d68:	6a 2a                	push   $0x2a
  jmp __alltraps
  101d6a:	e9 69 fe ff ff       	jmp    101bd8 <__alltraps>

00101d6f <vector43>:
.globl vector43
vector43:
  pushl $0
  101d6f:	6a 00                	push   $0x0
  pushl $43
  101d71:	6a 2b                	push   $0x2b
  jmp __alltraps
  101d73:	e9 60 fe ff ff       	jmp    101bd8 <__alltraps>

00101d78 <vector44>:
.globl vector44
vector44:
  pushl $0
  101d78:	6a 00                	push   $0x0
  pushl $44
  101d7a:	6a 2c                	push   $0x2c
  jmp __alltraps
  101d7c:	e9 57 fe ff ff       	jmp    101bd8 <__alltraps>

00101d81 <vector45>:
.globl vector45
vector45:
  pushl $0
  101d81:	6a 00                	push   $0x0
  pushl $45
  101d83:	6a 2d                	push   $0x2d
  jmp __alltraps
  101d85:	e9 4e fe ff ff       	jmp    101bd8 <__alltraps>

00101d8a <vector46>:
.globl vector46
vector46:
  pushl $0
  101d8a:	6a 00                	push   $0x0
  pushl $46
  101d8c:	6a 2e                	push   $0x2e
  jmp __alltraps
  101d8e:	e9 45 fe ff ff       	jmp    101bd8 <__alltraps>

00101d93 <vector47>:
.globl vector47
vector47:
  pushl $0
  101d93:	6a 00                	push   $0x0
  pushl $47
  101d95:	6a 2f                	push   $0x2f
  jmp __alltraps
  101d97:	e9 3c fe ff ff       	jmp    101bd8 <__alltraps>

00101d9c <vector48>:
.globl vector48
vector48:
  pushl $0
  101d9c:	6a 00                	push   $0x0
  pushl $48
  101d9e:	6a 30                	push   $0x30
  jmp __alltraps
  101da0:	e9 33 fe ff ff       	jmp    101bd8 <__alltraps>

00101da5 <vector49>:
.globl vector49
vector49:
  pushl $0
  101da5:	6a 00                	push   $0x0
  pushl $49
  101da7:	6a 31                	push   $0x31
  jmp __alltraps
  101da9:	e9 2a fe ff ff       	jmp    101bd8 <__alltraps>

00101dae <vector50>:
.globl vector50
vector50:
  pushl $0
  101dae:	6a 00                	push   $0x0
  pushl $50
  101db0:	6a 32                	push   $0x32
  jmp __alltraps
  101db2:	e9 21 fe ff ff       	jmp    101bd8 <__alltraps>

00101db7 <vector51>:
.globl vector51
vector51:
  pushl $0
  101db7:	6a 00                	push   $0x0
  pushl $51
  101db9:	6a 33                	push   $0x33
  jmp __alltraps
  101dbb:	e9 18 fe ff ff       	jmp    101bd8 <__alltraps>

00101dc0 <vector52>:
.globl vector52
vector52:
  pushl $0
  101dc0:	6a 00                	push   $0x0
  pushl $52
  101dc2:	6a 34                	push   $0x34
  jmp __alltraps
  101dc4:	e9 0f fe ff ff       	jmp    101bd8 <__alltraps>

00101dc9 <vector53>:
.globl vector53
vector53:
  pushl $0
  101dc9:	6a 00                	push   $0x0
  pushl $53
  101dcb:	6a 35                	push   $0x35
  jmp __alltraps
  101dcd:	e9 06 fe ff ff       	jmp    101bd8 <__alltraps>

00101dd2 <vector54>:
.globl vector54
vector54:
  pushl $0
  101dd2:	6a 00                	push   $0x0
  pushl $54
  101dd4:	6a 36                	push   $0x36
  jmp __alltraps
  101dd6:	e9 fd fd ff ff       	jmp    101bd8 <__alltraps>

00101ddb <vector55>:
.globl vector55
vector55:
  pushl $0
  101ddb:	6a 00                	push   $0x0
  pushl $55
  101ddd:	6a 37                	push   $0x37
  jmp __alltraps
  101ddf:	e9 f4 fd ff ff       	jmp    101bd8 <__alltraps>

00101de4 <vector56>:
.globl vector56
vector56:
  pushl $0
  101de4:	6a 00                	push   $0x0
  pushl $56
  101de6:	6a 38                	push   $0x38
  jmp __alltraps
  101de8:	e9 eb fd ff ff       	jmp    101bd8 <__alltraps>

00101ded <vector57>:
.globl vector57
vector57:
  pushl $0
  101ded:	6a 00                	push   $0x0
  pushl $57
  101def:	6a 39                	push   $0x39
  jmp __alltraps
  101df1:	e9 e2 fd ff ff       	jmp    101bd8 <__alltraps>

00101df6 <vector58>:
.globl vector58
vector58:
  pushl $0
  101df6:	6a 00                	push   $0x0
  pushl $58
  101df8:	6a 3a                	push   $0x3a
  jmp __alltraps
  101dfa:	e9 d9 fd ff ff       	jmp    101bd8 <__alltraps>

00101dff <vector59>:
.globl vector59
vector59:
  pushl $0
  101dff:	6a 00                	push   $0x0
  pushl $59
  101e01:	6a 3b                	push   $0x3b
  jmp __alltraps
  101e03:	e9 d0 fd ff ff       	jmp    101bd8 <__alltraps>

00101e08 <vector60>:
.globl vector60
vector60:
  pushl $0
  101e08:	6a 00                	push   $0x0
  pushl $60
  101e0a:	6a 3c                	push   $0x3c
  jmp __alltraps
  101e0c:	e9 c7 fd ff ff       	jmp    101bd8 <__alltraps>

00101e11 <vector61>:
.globl vector61
vector61:
  pushl $0
  101e11:	6a 00                	push   $0x0
  pushl $61
  101e13:	6a 3d                	push   $0x3d
  jmp __alltraps
  101e15:	e9 be fd ff ff       	jmp    101bd8 <__alltraps>

00101e1a <vector62>:
.globl vector62
vector62:
  pushl $0
  101e1a:	6a 00                	push   $0x0
  pushl $62
  101e1c:	6a 3e                	push   $0x3e
  jmp __alltraps
  101e1e:	e9 b5 fd ff ff       	jmp    101bd8 <__alltraps>

00101e23 <vector63>:
.globl vector63
vector63:
  pushl $0
  101e23:	6a 00                	push   $0x0
  pushl $63
  101e25:	6a 3f                	push   $0x3f
  jmp __alltraps
  101e27:	e9 ac fd ff ff       	jmp    101bd8 <__alltraps>

00101e2c <vector64>:
.globl vector64
vector64:
  pushl $0
  101e2c:	6a 00                	push   $0x0
  pushl $64
  101e2e:	6a 40                	push   $0x40
  jmp __alltraps
  101e30:	e9 a3 fd ff ff       	jmp    101bd8 <__alltraps>

00101e35 <vector65>:
.globl vector65
vector65:
  pushl $0
  101e35:	6a 00                	push   $0x0
  pushl $65
  101e37:	6a 41                	push   $0x41
  jmp __alltraps
  101e39:	e9 9a fd ff ff       	jmp    101bd8 <__alltraps>

00101e3e <vector66>:
.globl vector66
vector66:
  pushl $0
  101e3e:	6a 00                	push   $0x0
  pushl $66
  101e40:	6a 42                	push   $0x42
  jmp __alltraps
  101e42:	e9 91 fd ff ff       	jmp    101bd8 <__alltraps>

00101e47 <vector67>:
.globl vector67
vector67:
  pushl $0
  101e47:	6a 00                	push   $0x0
  pushl $67
  101e49:	6a 43                	push   $0x43
  jmp __alltraps
  101e4b:	e9 88 fd ff ff       	jmp    101bd8 <__alltraps>

00101e50 <vector68>:
.globl vector68
vector68:
  pushl $0
  101e50:	6a 00                	push   $0x0
  pushl $68
  101e52:	6a 44                	push   $0x44
  jmp __alltraps
  101e54:	e9 7f fd ff ff       	jmp    101bd8 <__alltraps>

00101e59 <vector69>:
.globl vector69
vector69:
  pushl $0
  101e59:	6a 00                	push   $0x0
  pushl $69
  101e5b:	6a 45                	push   $0x45
  jmp __alltraps
  101e5d:	e9 76 fd ff ff       	jmp    101bd8 <__alltraps>

00101e62 <vector70>:
.globl vector70
vector70:
  pushl $0
  101e62:	6a 00                	push   $0x0
  pushl $70
  101e64:	6a 46                	push   $0x46
  jmp __alltraps
  101e66:	e9 6d fd ff ff       	jmp    101bd8 <__alltraps>

00101e6b <vector71>:
.globl vector71
vector71:
  pushl $0
  101e6b:	6a 00                	push   $0x0
  pushl $71
  101e6d:	6a 47                	push   $0x47
  jmp __alltraps
  101e6f:	e9 64 fd ff ff       	jmp    101bd8 <__alltraps>

00101e74 <vector72>:
.globl vector72
vector72:
  pushl $0
  101e74:	6a 00                	push   $0x0
  pushl $72
  101e76:	6a 48                	push   $0x48
  jmp __alltraps
  101e78:	e9 5b fd ff ff       	jmp    101bd8 <__alltraps>

00101e7d <vector73>:
.globl vector73
vector73:
  pushl $0
  101e7d:	6a 00                	push   $0x0
  pushl $73
  101e7f:	6a 49                	push   $0x49
  jmp __alltraps
  101e81:	e9 52 fd ff ff       	jmp    101bd8 <__alltraps>

00101e86 <vector74>:
.globl vector74
vector74:
  pushl $0
  101e86:	6a 00                	push   $0x0
  pushl $74
  101e88:	6a 4a                	push   $0x4a
  jmp __alltraps
  101e8a:	e9 49 fd ff ff       	jmp    101bd8 <__alltraps>

00101e8f <vector75>:
.globl vector75
vector75:
  pushl $0
  101e8f:	6a 00                	push   $0x0
  pushl $75
  101e91:	6a 4b                	push   $0x4b
  jmp __alltraps
  101e93:	e9 40 fd ff ff       	jmp    101bd8 <__alltraps>

00101e98 <vector76>:
.globl vector76
vector76:
  pushl $0
  101e98:	6a 00                	push   $0x0
  pushl $76
  101e9a:	6a 4c                	push   $0x4c
  jmp __alltraps
  101e9c:	e9 37 fd ff ff       	jmp    101bd8 <__alltraps>

00101ea1 <vector77>:
.globl vector77
vector77:
  pushl $0
  101ea1:	6a 00                	push   $0x0
  pushl $77
  101ea3:	6a 4d                	push   $0x4d
  jmp __alltraps
  101ea5:	e9 2e fd ff ff       	jmp    101bd8 <__alltraps>

00101eaa <vector78>:
.globl vector78
vector78:
  pushl $0
  101eaa:	6a 00                	push   $0x0
  pushl $78
  101eac:	6a 4e                	push   $0x4e
  jmp __alltraps
  101eae:	e9 25 fd ff ff       	jmp    101bd8 <__alltraps>

00101eb3 <vector79>:
.globl vector79
vector79:
  pushl $0
  101eb3:	6a 00                	push   $0x0
  pushl $79
  101eb5:	6a 4f                	push   $0x4f
  jmp __alltraps
  101eb7:	e9 1c fd ff ff       	jmp    101bd8 <__alltraps>

00101ebc <vector80>:
.globl vector80
vector80:
  pushl $0
  101ebc:	6a 00                	push   $0x0
  pushl $80
  101ebe:	6a 50                	push   $0x50
  jmp __alltraps
  101ec0:	e9 13 fd ff ff       	jmp    101bd8 <__alltraps>

00101ec5 <vector81>:
.globl vector81
vector81:
  pushl $0
  101ec5:	6a 00                	push   $0x0
  pushl $81
  101ec7:	6a 51                	push   $0x51
  jmp __alltraps
  101ec9:	e9 0a fd ff ff       	jmp    101bd8 <__alltraps>

00101ece <vector82>:
.globl vector82
vector82:
  pushl $0
  101ece:	6a 00                	push   $0x0
  pushl $82
  101ed0:	6a 52                	push   $0x52
  jmp __alltraps
  101ed2:	e9 01 fd ff ff       	jmp    101bd8 <__alltraps>

00101ed7 <vector83>:
.globl vector83
vector83:
  pushl $0
  101ed7:	6a 00                	push   $0x0
  pushl $83
  101ed9:	6a 53                	push   $0x53
  jmp __alltraps
  101edb:	e9 f8 fc ff ff       	jmp    101bd8 <__alltraps>

00101ee0 <vector84>:
.globl vector84
vector84:
  pushl $0
  101ee0:	6a 00                	push   $0x0
  pushl $84
  101ee2:	6a 54                	push   $0x54
  jmp __alltraps
  101ee4:	e9 ef fc ff ff       	jmp    101bd8 <__alltraps>

00101ee9 <vector85>:
.globl vector85
vector85:
  pushl $0
  101ee9:	6a 00                	push   $0x0
  pushl $85
  101eeb:	6a 55                	push   $0x55
  jmp __alltraps
  101eed:	e9 e6 fc ff ff       	jmp    101bd8 <__alltraps>

00101ef2 <vector86>:
.globl vector86
vector86:
  pushl $0
  101ef2:	6a 00                	push   $0x0
  pushl $86
  101ef4:	6a 56                	push   $0x56
  jmp __alltraps
  101ef6:	e9 dd fc ff ff       	jmp    101bd8 <__alltraps>

00101efb <vector87>:
.globl vector87
vector87:
  pushl $0
  101efb:	6a 00                	push   $0x0
  pushl $87
  101efd:	6a 57                	push   $0x57
  jmp __alltraps
  101eff:	e9 d4 fc ff ff       	jmp    101bd8 <__alltraps>

00101f04 <vector88>:
.globl vector88
vector88:
  pushl $0
  101f04:	6a 00                	push   $0x0
  pushl $88
  101f06:	6a 58                	push   $0x58
  jmp __alltraps
  101f08:	e9 cb fc ff ff       	jmp    101bd8 <__alltraps>

00101f0d <vector89>:
.globl vector89
vector89:
  pushl $0
  101f0d:	6a 00                	push   $0x0
  pushl $89
  101f0f:	6a 59                	push   $0x59
  jmp __alltraps
  101f11:	e9 c2 fc ff ff       	jmp    101bd8 <__alltraps>

00101f16 <vector90>:
.globl vector90
vector90:
  pushl $0
  101f16:	6a 00                	push   $0x0
  pushl $90
  101f18:	6a 5a                	push   $0x5a
  jmp __alltraps
  101f1a:	e9 b9 fc ff ff       	jmp    101bd8 <__alltraps>

00101f1f <vector91>:
.globl vector91
vector91:
  pushl $0
  101f1f:	6a 00                	push   $0x0
  pushl $91
  101f21:	6a 5b                	push   $0x5b
  jmp __alltraps
  101f23:	e9 b0 fc ff ff       	jmp    101bd8 <__alltraps>

00101f28 <vector92>:
.globl vector92
vector92:
  pushl $0
  101f28:	6a 00                	push   $0x0
  pushl $92
  101f2a:	6a 5c                	push   $0x5c
  jmp __alltraps
  101f2c:	e9 a7 fc ff ff       	jmp    101bd8 <__alltraps>

00101f31 <vector93>:
.globl vector93
vector93:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $93
  101f33:	6a 5d                	push   $0x5d
  jmp __alltraps
  101f35:	e9 9e fc ff ff       	jmp    101bd8 <__alltraps>

00101f3a <vector94>:
.globl vector94
vector94:
  pushl $0
  101f3a:	6a 00                	push   $0x0
  pushl $94
  101f3c:	6a 5e                	push   $0x5e
  jmp __alltraps
  101f3e:	e9 95 fc ff ff       	jmp    101bd8 <__alltraps>

00101f43 <vector95>:
.globl vector95
vector95:
  pushl $0
  101f43:	6a 00                	push   $0x0
  pushl $95
  101f45:	6a 5f                	push   $0x5f
  jmp __alltraps
  101f47:	e9 8c fc ff ff       	jmp    101bd8 <__alltraps>

00101f4c <vector96>:
.globl vector96
vector96:
  pushl $0
  101f4c:	6a 00                	push   $0x0
  pushl $96
  101f4e:	6a 60                	push   $0x60
  jmp __alltraps
  101f50:	e9 83 fc ff ff       	jmp    101bd8 <__alltraps>

00101f55 <vector97>:
.globl vector97
vector97:
  pushl $0
  101f55:	6a 00                	push   $0x0
  pushl $97
  101f57:	6a 61                	push   $0x61
  jmp __alltraps
  101f59:	e9 7a fc ff ff       	jmp    101bd8 <__alltraps>

00101f5e <vector98>:
.globl vector98
vector98:
  pushl $0
  101f5e:	6a 00                	push   $0x0
  pushl $98
  101f60:	6a 62                	push   $0x62
  jmp __alltraps
  101f62:	e9 71 fc ff ff       	jmp    101bd8 <__alltraps>

00101f67 <vector99>:
.globl vector99
vector99:
  pushl $0
  101f67:	6a 00                	push   $0x0
  pushl $99
  101f69:	6a 63                	push   $0x63
  jmp __alltraps
  101f6b:	e9 68 fc ff ff       	jmp    101bd8 <__alltraps>

00101f70 <vector100>:
.globl vector100
vector100:
  pushl $0
  101f70:	6a 00                	push   $0x0
  pushl $100
  101f72:	6a 64                	push   $0x64
  jmp __alltraps
  101f74:	e9 5f fc ff ff       	jmp    101bd8 <__alltraps>

00101f79 <vector101>:
.globl vector101
vector101:
  pushl $0
  101f79:	6a 00                	push   $0x0
  pushl $101
  101f7b:	6a 65                	push   $0x65
  jmp __alltraps
  101f7d:	e9 56 fc ff ff       	jmp    101bd8 <__alltraps>

00101f82 <vector102>:
.globl vector102
vector102:
  pushl $0
  101f82:	6a 00                	push   $0x0
  pushl $102
  101f84:	6a 66                	push   $0x66
  jmp __alltraps
  101f86:	e9 4d fc ff ff       	jmp    101bd8 <__alltraps>

00101f8b <vector103>:
.globl vector103
vector103:
  pushl $0
  101f8b:	6a 00                	push   $0x0
  pushl $103
  101f8d:	6a 67                	push   $0x67
  jmp __alltraps
  101f8f:	e9 44 fc ff ff       	jmp    101bd8 <__alltraps>

00101f94 <vector104>:
.globl vector104
vector104:
  pushl $0
  101f94:	6a 00                	push   $0x0
  pushl $104
  101f96:	6a 68                	push   $0x68
  jmp __alltraps
  101f98:	e9 3b fc ff ff       	jmp    101bd8 <__alltraps>

00101f9d <vector105>:
.globl vector105
vector105:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $105
  101f9f:	6a 69                	push   $0x69
  jmp __alltraps
  101fa1:	e9 32 fc ff ff       	jmp    101bd8 <__alltraps>

00101fa6 <vector106>:
.globl vector106
vector106:
  pushl $0
  101fa6:	6a 00                	push   $0x0
  pushl $106
  101fa8:	6a 6a                	push   $0x6a
  jmp __alltraps
  101faa:	e9 29 fc ff ff       	jmp    101bd8 <__alltraps>

00101faf <vector107>:
.globl vector107
vector107:
  pushl $0
  101faf:	6a 00                	push   $0x0
  pushl $107
  101fb1:	6a 6b                	push   $0x6b
  jmp __alltraps
  101fb3:	e9 20 fc ff ff       	jmp    101bd8 <__alltraps>

00101fb8 <vector108>:
.globl vector108
vector108:
  pushl $0
  101fb8:	6a 00                	push   $0x0
  pushl $108
  101fba:	6a 6c                	push   $0x6c
  jmp __alltraps
  101fbc:	e9 17 fc ff ff       	jmp    101bd8 <__alltraps>

00101fc1 <vector109>:
.globl vector109
vector109:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $109
  101fc3:	6a 6d                	push   $0x6d
  jmp __alltraps
  101fc5:	e9 0e fc ff ff       	jmp    101bd8 <__alltraps>

00101fca <vector110>:
.globl vector110
vector110:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $110
  101fcc:	6a 6e                	push   $0x6e
  jmp __alltraps
  101fce:	e9 05 fc ff ff       	jmp    101bd8 <__alltraps>

00101fd3 <vector111>:
.globl vector111
vector111:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $111
  101fd5:	6a 6f                	push   $0x6f
  jmp __alltraps
  101fd7:	e9 fc fb ff ff       	jmp    101bd8 <__alltraps>

00101fdc <vector112>:
.globl vector112
vector112:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $112
  101fde:	6a 70                	push   $0x70
  jmp __alltraps
  101fe0:	e9 f3 fb ff ff       	jmp    101bd8 <__alltraps>

00101fe5 <vector113>:
.globl vector113
vector113:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $113
  101fe7:	6a 71                	push   $0x71
  jmp __alltraps
  101fe9:	e9 ea fb ff ff       	jmp    101bd8 <__alltraps>

00101fee <vector114>:
.globl vector114
vector114:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $114
  101ff0:	6a 72                	push   $0x72
  jmp __alltraps
  101ff2:	e9 e1 fb ff ff       	jmp    101bd8 <__alltraps>

00101ff7 <vector115>:
.globl vector115
vector115:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $115
  101ff9:	6a 73                	push   $0x73
  jmp __alltraps
  101ffb:	e9 d8 fb ff ff       	jmp    101bd8 <__alltraps>

00102000 <vector116>:
.globl vector116
vector116:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $116
  102002:	6a 74                	push   $0x74
  jmp __alltraps
  102004:	e9 cf fb ff ff       	jmp    101bd8 <__alltraps>

00102009 <vector117>:
.globl vector117
vector117:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $117
  10200b:	6a 75                	push   $0x75
  jmp __alltraps
  10200d:	e9 c6 fb ff ff       	jmp    101bd8 <__alltraps>

00102012 <vector118>:
.globl vector118
vector118:
  pushl $0
  102012:	6a 00                	push   $0x0
  pushl $118
  102014:	6a 76                	push   $0x76
  jmp __alltraps
  102016:	e9 bd fb ff ff       	jmp    101bd8 <__alltraps>

0010201b <vector119>:
.globl vector119
vector119:
  pushl $0
  10201b:	6a 00                	push   $0x0
  pushl $119
  10201d:	6a 77                	push   $0x77
  jmp __alltraps
  10201f:	e9 b4 fb ff ff       	jmp    101bd8 <__alltraps>

00102024 <vector120>:
.globl vector120
vector120:
  pushl $0
  102024:	6a 00                	push   $0x0
  pushl $120
  102026:	6a 78                	push   $0x78
  jmp __alltraps
  102028:	e9 ab fb ff ff       	jmp    101bd8 <__alltraps>

0010202d <vector121>:
.globl vector121
vector121:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $121
  10202f:	6a 79                	push   $0x79
  jmp __alltraps
  102031:	e9 a2 fb ff ff       	jmp    101bd8 <__alltraps>

00102036 <vector122>:
.globl vector122
vector122:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $122
  102038:	6a 7a                	push   $0x7a
  jmp __alltraps
  10203a:	e9 99 fb ff ff       	jmp    101bd8 <__alltraps>

0010203f <vector123>:
.globl vector123
vector123:
  pushl $0
  10203f:	6a 00                	push   $0x0
  pushl $123
  102041:	6a 7b                	push   $0x7b
  jmp __alltraps
  102043:	e9 90 fb ff ff       	jmp    101bd8 <__alltraps>

00102048 <vector124>:
.globl vector124
vector124:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $124
  10204a:	6a 7c                	push   $0x7c
  jmp __alltraps
  10204c:	e9 87 fb ff ff       	jmp    101bd8 <__alltraps>

00102051 <vector125>:
.globl vector125
vector125:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $125
  102053:	6a 7d                	push   $0x7d
  jmp __alltraps
  102055:	e9 7e fb ff ff       	jmp    101bd8 <__alltraps>

0010205a <vector126>:
.globl vector126
vector126:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $126
  10205c:	6a 7e                	push   $0x7e
  jmp __alltraps
  10205e:	e9 75 fb ff ff       	jmp    101bd8 <__alltraps>

00102063 <vector127>:
.globl vector127
vector127:
  pushl $0
  102063:	6a 00                	push   $0x0
  pushl $127
  102065:	6a 7f                	push   $0x7f
  jmp __alltraps
  102067:	e9 6c fb ff ff       	jmp    101bd8 <__alltraps>

0010206c <vector128>:
.globl vector128
vector128:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $128
  10206e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102073:	e9 60 fb ff ff       	jmp    101bd8 <__alltraps>

00102078 <vector129>:
.globl vector129
vector129:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $129
  10207a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10207f:	e9 54 fb ff ff       	jmp    101bd8 <__alltraps>

00102084 <vector130>:
.globl vector130
vector130:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $130
  102086:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10208b:	e9 48 fb ff ff       	jmp    101bd8 <__alltraps>

00102090 <vector131>:
.globl vector131
vector131:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $131
  102092:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102097:	e9 3c fb ff ff       	jmp    101bd8 <__alltraps>

0010209c <vector132>:
.globl vector132
vector132:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $132
  10209e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1020a3:	e9 30 fb ff ff       	jmp    101bd8 <__alltraps>

001020a8 <vector133>:
.globl vector133
vector133:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $133
  1020aa:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1020af:	e9 24 fb ff ff       	jmp    101bd8 <__alltraps>

001020b4 <vector134>:
.globl vector134
vector134:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $134
  1020b6:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1020bb:	e9 18 fb ff ff       	jmp    101bd8 <__alltraps>

001020c0 <vector135>:
.globl vector135
vector135:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $135
  1020c2:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1020c7:	e9 0c fb ff ff       	jmp    101bd8 <__alltraps>

001020cc <vector136>:
.globl vector136
vector136:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $136
  1020ce:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1020d3:	e9 00 fb ff ff       	jmp    101bd8 <__alltraps>

001020d8 <vector137>:
.globl vector137
vector137:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $137
  1020da:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1020df:	e9 f4 fa ff ff       	jmp    101bd8 <__alltraps>

001020e4 <vector138>:
.globl vector138
vector138:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $138
  1020e6:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1020eb:	e9 e8 fa ff ff       	jmp    101bd8 <__alltraps>

001020f0 <vector139>:
.globl vector139
vector139:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $139
  1020f2:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1020f7:	e9 dc fa ff ff       	jmp    101bd8 <__alltraps>

001020fc <vector140>:
.globl vector140
vector140:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $140
  1020fe:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102103:	e9 d0 fa ff ff       	jmp    101bd8 <__alltraps>

00102108 <vector141>:
.globl vector141
vector141:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $141
  10210a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10210f:	e9 c4 fa ff ff       	jmp    101bd8 <__alltraps>

00102114 <vector142>:
.globl vector142
vector142:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $142
  102116:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10211b:	e9 b8 fa ff ff       	jmp    101bd8 <__alltraps>

00102120 <vector143>:
.globl vector143
vector143:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $143
  102122:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102127:	e9 ac fa ff ff       	jmp    101bd8 <__alltraps>

0010212c <vector144>:
.globl vector144
vector144:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $144
  10212e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102133:	e9 a0 fa ff ff       	jmp    101bd8 <__alltraps>

00102138 <vector145>:
.globl vector145
vector145:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $145
  10213a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10213f:	e9 94 fa ff ff       	jmp    101bd8 <__alltraps>

00102144 <vector146>:
.globl vector146
vector146:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $146
  102146:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10214b:	e9 88 fa ff ff       	jmp    101bd8 <__alltraps>

00102150 <vector147>:
.globl vector147
vector147:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $147
  102152:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102157:	e9 7c fa ff ff       	jmp    101bd8 <__alltraps>

0010215c <vector148>:
.globl vector148
vector148:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $148
  10215e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102163:	e9 70 fa ff ff       	jmp    101bd8 <__alltraps>

00102168 <vector149>:
.globl vector149
vector149:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $149
  10216a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10216f:	e9 64 fa ff ff       	jmp    101bd8 <__alltraps>

00102174 <vector150>:
.globl vector150
vector150:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $150
  102176:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10217b:	e9 58 fa ff ff       	jmp    101bd8 <__alltraps>

00102180 <vector151>:
.globl vector151
vector151:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $151
  102182:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102187:	e9 4c fa ff ff       	jmp    101bd8 <__alltraps>

0010218c <vector152>:
.globl vector152
vector152:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $152
  10218e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102193:	e9 40 fa ff ff       	jmp    101bd8 <__alltraps>

00102198 <vector153>:
.globl vector153
vector153:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $153
  10219a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10219f:	e9 34 fa ff ff       	jmp    101bd8 <__alltraps>

001021a4 <vector154>:
.globl vector154
vector154:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $154
  1021a6:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1021ab:	e9 28 fa ff ff       	jmp    101bd8 <__alltraps>

001021b0 <vector155>:
.globl vector155
vector155:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $155
  1021b2:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1021b7:	e9 1c fa ff ff       	jmp    101bd8 <__alltraps>

001021bc <vector156>:
.globl vector156
vector156:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $156
  1021be:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1021c3:	e9 10 fa ff ff       	jmp    101bd8 <__alltraps>

001021c8 <vector157>:
.globl vector157
vector157:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $157
  1021ca:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1021cf:	e9 04 fa ff ff       	jmp    101bd8 <__alltraps>

001021d4 <vector158>:
.globl vector158
vector158:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $158
  1021d6:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1021db:	e9 f8 f9 ff ff       	jmp    101bd8 <__alltraps>

001021e0 <vector159>:
.globl vector159
vector159:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $159
  1021e2:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1021e7:	e9 ec f9 ff ff       	jmp    101bd8 <__alltraps>

001021ec <vector160>:
.globl vector160
vector160:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $160
  1021ee:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1021f3:	e9 e0 f9 ff ff       	jmp    101bd8 <__alltraps>

001021f8 <vector161>:
.globl vector161
vector161:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $161
  1021fa:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1021ff:	e9 d4 f9 ff ff       	jmp    101bd8 <__alltraps>

00102204 <vector162>:
.globl vector162
vector162:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $162
  102206:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10220b:	e9 c8 f9 ff ff       	jmp    101bd8 <__alltraps>

00102210 <vector163>:
.globl vector163
vector163:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $163
  102212:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102217:	e9 bc f9 ff ff       	jmp    101bd8 <__alltraps>

0010221c <vector164>:
.globl vector164
vector164:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $164
  10221e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102223:	e9 b0 f9 ff ff       	jmp    101bd8 <__alltraps>

00102228 <vector165>:
.globl vector165
vector165:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $165
  10222a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10222f:	e9 a4 f9 ff ff       	jmp    101bd8 <__alltraps>

00102234 <vector166>:
.globl vector166
vector166:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $166
  102236:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10223b:	e9 98 f9 ff ff       	jmp    101bd8 <__alltraps>

00102240 <vector167>:
.globl vector167
vector167:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $167
  102242:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102247:	e9 8c f9 ff ff       	jmp    101bd8 <__alltraps>

0010224c <vector168>:
.globl vector168
vector168:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $168
  10224e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102253:	e9 80 f9 ff ff       	jmp    101bd8 <__alltraps>

00102258 <vector169>:
.globl vector169
vector169:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $169
  10225a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10225f:	e9 74 f9 ff ff       	jmp    101bd8 <__alltraps>

00102264 <vector170>:
.globl vector170
vector170:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $170
  102266:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10226b:	e9 68 f9 ff ff       	jmp    101bd8 <__alltraps>

00102270 <vector171>:
.globl vector171
vector171:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $171
  102272:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102277:	e9 5c f9 ff ff       	jmp    101bd8 <__alltraps>

0010227c <vector172>:
.globl vector172
vector172:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $172
  10227e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102283:	e9 50 f9 ff ff       	jmp    101bd8 <__alltraps>

00102288 <vector173>:
.globl vector173
vector173:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $173
  10228a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10228f:	e9 44 f9 ff ff       	jmp    101bd8 <__alltraps>

00102294 <vector174>:
.globl vector174
vector174:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $174
  102296:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10229b:	e9 38 f9 ff ff       	jmp    101bd8 <__alltraps>

001022a0 <vector175>:
.globl vector175
vector175:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $175
  1022a2:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1022a7:	e9 2c f9 ff ff       	jmp    101bd8 <__alltraps>

001022ac <vector176>:
.globl vector176
vector176:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $176
  1022ae:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1022b3:	e9 20 f9 ff ff       	jmp    101bd8 <__alltraps>

001022b8 <vector177>:
.globl vector177
vector177:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $177
  1022ba:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1022bf:	e9 14 f9 ff ff       	jmp    101bd8 <__alltraps>

001022c4 <vector178>:
.globl vector178
vector178:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $178
  1022c6:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1022cb:	e9 08 f9 ff ff       	jmp    101bd8 <__alltraps>

001022d0 <vector179>:
.globl vector179
vector179:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $179
  1022d2:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1022d7:	e9 fc f8 ff ff       	jmp    101bd8 <__alltraps>

001022dc <vector180>:
.globl vector180
vector180:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $180
  1022de:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1022e3:	e9 f0 f8 ff ff       	jmp    101bd8 <__alltraps>

001022e8 <vector181>:
.globl vector181
vector181:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $181
  1022ea:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1022ef:	e9 e4 f8 ff ff       	jmp    101bd8 <__alltraps>

001022f4 <vector182>:
.globl vector182
vector182:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $182
  1022f6:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1022fb:	e9 d8 f8 ff ff       	jmp    101bd8 <__alltraps>

00102300 <vector183>:
.globl vector183
vector183:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $183
  102302:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102307:	e9 cc f8 ff ff       	jmp    101bd8 <__alltraps>

0010230c <vector184>:
.globl vector184
vector184:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $184
  10230e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102313:	e9 c0 f8 ff ff       	jmp    101bd8 <__alltraps>

00102318 <vector185>:
.globl vector185
vector185:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $185
  10231a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10231f:	e9 b4 f8 ff ff       	jmp    101bd8 <__alltraps>

00102324 <vector186>:
.globl vector186
vector186:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $186
  102326:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10232b:	e9 a8 f8 ff ff       	jmp    101bd8 <__alltraps>

00102330 <vector187>:
.globl vector187
vector187:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $187
  102332:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102337:	e9 9c f8 ff ff       	jmp    101bd8 <__alltraps>

0010233c <vector188>:
.globl vector188
vector188:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $188
  10233e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102343:	e9 90 f8 ff ff       	jmp    101bd8 <__alltraps>

00102348 <vector189>:
.globl vector189
vector189:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $189
  10234a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10234f:	e9 84 f8 ff ff       	jmp    101bd8 <__alltraps>

00102354 <vector190>:
.globl vector190
vector190:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $190
  102356:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10235b:	e9 78 f8 ff ff       	jmp    101bd8 <__alltraps>

00102360 <vector191>:
.globl vector191
vector191:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $191
  102362:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102367:	e9 6c f8 ff ff       	jmp    101bd8 <__alltraps>

0010236c <vector192>:
.globl vector192
vector192:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $192
  10236e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102373:	e9 60 f8 ff ff       	jmp    101bd8 <__alltraps>

00102378 <vector193>:
.globl vector193
vector193:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $193
  10237a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10237f:	e9 54 f8 ff ff       	jmp    101bd8 <__alltraps>

00102384 <vector194>:
.globl vector194
vector194:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $194
  102386:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10238b:	e9 48 f8 ff ff       	jmp    101bd8 <__alltraps>

00102390 <vector195>:
.globl vector195
vector195:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $195
  102392:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102397:	e9 3c f8 ff ff       	jmp    101bd8 <__alltraps>

0010239c <vector196>:
.globl vector196
vector196:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $196
  10239e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1023a3:	e9 30 f8 ff ff       	jmp    101bd8 <__alltraps>

001023a8 <vector197>:
.globl vector197
vector197:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $197
  1023aa:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1023af:	e9 24 f8 ff ff       	jmp    101bd8 <__alltraps>

001023b4 <vector198>:
.globl vector198
vector198:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $198
  1023b6:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1023bb:	e9 18 f8 ff ff       	jmp    101bd8 <__alltraps>

001023c0 <vector199>:
.globl vector199
vector199:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $199
  1023c2:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1023c7:	e9 0c f8 ff ff       	jmp    101bd8 <__alltraps>

001023cc <vector200>:
.globl vector200
vector200:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $200
  1023ce:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1023d3:	e9 00 f8 ff ff       	jmp    101bd8 <__alltraps>

001023d8 <vector201>:
.globl vector201
vector201:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $201
  1023da:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1023df:	e9 f4 f7 ff ff       	jmp    101bd8 <__alltraps>

001023e4 <vector202>:
.globl vector202
vector202:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $202
  1023e6:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1023eb:	e9 e8 f7 ff ff       	jmp    101bd8 <__alltraps>

001023f0 <vector203>:
.globl vector203
vector203:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $203
  1023f2:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1023f7:	e9 dc f7 ff ff       	jmp    101bd8 <__alltraps>

001023fc <vector204>:
.globl vector204
vector204:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $204
  1023fe:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102403:	e9 d0 f7 ff ff       	jmp    101bd8 <__alltraps>

00102408 <vector205>:
.globl vector205
vector205:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $205
  10240a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10240f:	e9 c4 f7 ff ff       	jmp    101bd8 <__alltraps>

00102414 <vector206>:
.globl vector206
vector206:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $206
  102416:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10241b:	e9 b8 f7 ff ff       	jmp    101bd8 <__alltraps>

00102420 <vector207>:
.globl vector207
vector207:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $207
  102422:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102427:	e9 ac f7 ff ff       	jmp    101bd8 <__alltraps>

0010242c <vector208>:
.globl vector208
vector208:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $208
  10242e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102433:	e9 a0 f7 ff ff       	jmp    101bd8 <__alltraps>

00102438 <vector209>:
.globl vector209
vector209:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $209
  10243a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10243f:	e9 94 f7 ff ff       	jmp    101bd8 <__alltraps>

00102444 <vector210>:
.globl vector210
vector210:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $210
  102446:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10244b:	e9 88 f7 ff ff       	jmp    101bd8 <__alltraps>

00102450 <vector211>:
.globl vector211
vector211:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $211
  102452:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102457:	e9 7c f7 ff ff       	jmp    101bd8 <__alltraps>

0010245c <vector212>:
.globl vector212
vector212:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $212
  10245e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102463:	e9 70 f7 ff ff       	jmp    101bd8 <__alltraps>

00102468 <vector213>:
.globl vector213
vector213:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $213
  10246a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10246f:	e9 64 f7 ff ff       	jmp    101bd8 <__alltraps>

00102474 <vector214>:
.globl vector214
vector214:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $214
  102476:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10247b:	e9 58 f7 ff ff       	jmp    101bd8 <__alltraps>

00102480 <vector215>:
.globl vector215
vector215:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $215
  102482:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102487:	e9 4c f7 ff ff       	jmp    101bd8 <__alltraps>

0010248c <vector216>:
.globl vector216
vector216:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $216
  10248e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102493:	e9 40 f7 ff ff       	jmp    101bd8 <__alltraps>

00102498 <vector217>:
.globl vector217
vector217:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $217
  10249a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10249f:	e9 34 f7 ff ff       	jmp    101bd8 <__alltraps>

001024a4 <vector218>:
.globl vector218
vector218:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $218
  1024a6:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1024ab:	e9 28 f7 ff ff       	jmp    101bd8 <__alltraps>

001024b0 <vector219>:
.globl vector219
vector219:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $219
  1024b2:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1024b7:	e9 1c f7 ff ff       	jmp    101bd8 <__alltraps>

001024bc <vector220>:
.globl vector220
vector220:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $220
  1024be:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1024c3:	e9 10 f7 ff ff       	jmp    101bd8 <__alltraps>

001024c8 <vector221>:
.globl vector221
vector221:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $221
  1024ca:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1024cf:	e9 04 f7 ff ff       	jmp    101bd8 <__alltraps>

001024d4 <vector222>:
.globl vector222
vector222:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $222
  1024d6:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1024db:	e9 f8 f6 ff ff       	jmp    101bd8 <__alltraps>

001024e0 <vector223>:
.globl vector223
vector223:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $223
  1024e2:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1024e7:	e9 ec f6 ff ff       	jmp    101bd8 <__alltraps>

001024ec <vector224>:
.globl vector224
vector224:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $224
  1024ee:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1024f3:	e9 e0 f6 ff ff       	jmp    101bd8 <__alltraps>

001024f8 <vector225>:
.globl vector225
vector225:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $225
  1024fa:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1024ff:	e9 d4 f6 ff ff       	jmp    101bd8 <__alltraps>

00102504 <vector226>:
.globl vector226
vector226:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $226
  102506:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10250b:	e9 c8 f6 ff ff       	jmp    101bd8 <__alltraps>

00102510 <vector227>:
.globl vector227
vector227:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $227
  102512:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102517:	e9 bc f6 ff ff       	jmp    101bd8 <__alltraps>

0010251c <vector228>:
.globl vector228
vector228:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $228
  10251e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102523:	e9 b0 f6 ff ff       	jmp    101bd8 <__alltraps>

00102528 <vector229>:
.globl vector229
vector229:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $229
  10252a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10252f:	e9 a4 f6 ff ff       	jmp    101bd8 <__alltraps>

00102534 <vector230>:
.globl vector230
vector230:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $230
  102536:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10253b:	e9 98 f6 ff ff       	jmp    101bd8 <__alltraps>

00102540 <vector231>:
.globl vector231
vector231:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $231
  102542:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102547:	e9 8c f6 ff ff       	jmp    101bd8 <__alltraps>

0010254c <vector232>:
.globl vector232
vector232:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $232
  10254e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102553:	e9 80 f6 ff ff       	jmp    101bd8 <__alltraps>

00102558 <vector233>:
.globl vector233
vector233:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $233
  10255a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10255f:	e9 74 f6 ff ff       	jmp    101bd8 <__alltraps>

00102564 <vector234>:
.globl vector234
vector234:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $234
  102566:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10256b:	e9 68 f6 ff ff       	jmp    101bd8 <__alltraps>

00102570 <vector235>:
.globl vector235
vector235:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $235
  102572:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102577:	e9 5c f6 ff ff       	jmp    101bd8 <__alltraps>

0010257c <vector236>:
.globl vector236
vector236:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $236
  10257e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102583:	e9 50 f6 ff ff       	jmp    101bd8 <__alltraps>

00102588 <vector237>:
.globl vector237
vector237:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $237
  10258a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10258f:	e9 44 f6 ff ff       	jmp    101bd8 <__alltraps>

00102594 <vector238>:
.globl vector238
vector238:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $238
  102596:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10259b:	e9 38 f6 ff ff       	jmp    101bd8 <__alltraps>

001025a0 <vector239>:
.globl vector239
vector239:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $239
  1025a2:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1025a7:	e9 2c f6 ff ff       	jmp    101bd8 <__alltraps>

001025ac <vector240>:
.globl vector240
vector240:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $240
  1025ae:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1025b3:	e9 20 f6 ff ff       	jmp    101bd8 <__alltraps>

001025b8 <vector241>:
.globl vector241
vector241:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $241
  1025ba:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1025bf:	e9 14 f6 ff ff       	jmp    101bd8 <__alltraps>

001025c4 <vector242>:
.globl vector242
vector242:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $242
  1025c6:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1025cb:	e9 08 f6 ff ff       	jmp    101bd8 <__alltraps>

001025d0 <vector243>:
.globl vector243
vector243:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $243
  1025d2:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1025d7:	e9 fc f5 ff ff       	jmp    101bd8 <__alltraps>

001025dc <vector244>:
.globl vector244
vector244:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $244
  1025de:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1025e3:	e9 f0 f5 ff ff       	jmp    101bd8 <__alltraps>

001025e8 <vector245>:
.globl vector245
vector245:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $245
  1025ea:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1025ef:	e9 e4 f5 ff ff       	jmp    101bd8 <__alltraps>

001025f4 <vector246>:
.globl vector246
vector246:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $246
  1025f6:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1025fb:	e9 d8 f5 ff ff       	jmp    101bd8 <__alltraps>

00102600 <vector247>:
.globl vector247
vector247:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $247
  102602:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102607:	e9 cc f5 ff ff       	jmp    101bd8 <__alltraps>

0010260c <vector248>:
.globl vector248
vector248:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $248
  10260e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102613:	e9 c0 f5 ff ff       	jmp    101bd8 <__alltraps>

00102618 <vector249>:
.globl vector249
vector249:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $249
  10261a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10261f:	e9 b4 f5 ff ff       	jmp    101bd8 <__alltraps>

00102624 <vector250>:
.globl vector250
vector250:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $250
  102626:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10262b:	e9 a8 f5 ff ff       	jmp    101bd8 <__alltraps>

00102630 <vector251>:
.globl vector251
vector251:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $251
  102632:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102637:	e9 9c f5 ff ff       	jmp    101bd8 <__alltraps>

0010263c <vector252>:
.globl vector252
vector252:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $252
  10263e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102643:	e9 90 f5 ff ff       	jmp    101bd8 <__alltraps>

00102648 <vector253>:
.globl vector253
vector253:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $253
  10264a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10264f:	e9 84 f5 ff ff       	jmp    101bd8 <__alltraps>

00102654 <vector254>:
.globl vector254
vector254:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $254
  102656:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10265b:	e9 78 f5 ff ff       	jmp    101bd8 <__alltraps>

00102660 <vector255>:
.globl vector255
vector255:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $255
  102662:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102667:	e9 6c f5 ff ff       	jmp    101bd8 <__alltraps>

0010266c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10266c:	55                   	push   %ebp
  10266d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10266f:	8b 45 08             	mov    0x8(%ebp),%eax
  102672:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102675:	b8 23 00 00 00       	mov    $0x23,%eax
  10267a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10267c:	b8 23 00 00 00       	mov    $0x23,%eax
  102681:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102683:	b8 10 00 00 00       	mov    $0x10,%eax
  102688:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10268a:	b8 10 00 00 00       	mov    $0x10,%eax
  10268f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102691:	b8 10 00 00 00       	mov    $0x10,%eax
  102696:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102698:	ea 9f 26 10 00 08 00 	ljmp   $0x8,$0x10269f
}
  10269f:	5d                   	pop    %ebp
  1026a0:	c3                   	ret    

001026a1 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1026a1:	55                   	push   %ebp
  1026a2:	89 e5                	mov    %esp,%ebp
  1026a4:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1026a7:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  1026ac:	05 00 04 00 00       	add    $0x400,%eax
  1026b1:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1026b6:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1026bd:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1026bf:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1026c6:	68 00 
  1026c8:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1026cd:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1026d3:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1026d8:	c1 e8 10             	shr    $0x10,%eax
  1026db:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1026e0:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026e7:	83 e0 f0             	and    $0xfffffff0,%eax
  1026ea:	83 c8 09             	or     $0x9,%eax
  1026ed:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026f2:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026f9:	83 c8 10             	or     $0x10,%eax
  1026fc:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102701:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102708:	83 e0 9f             	and    $0xffffff9f,%eax
  10270b:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102710:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102717:	83 c8 80             	or     $0xffffff80,%eax
  10271a:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10271f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102726:	83 e0 f0             	and    $0xfffffff0,%eax
  102729:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10272e:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102735:	83 e0 ef             	and    $0xffffffef,%eax
  102738:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10273d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102744:	83 e0 df             	and    $0xffffffdf,%eax
  102747:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10274c:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102753:	83 c8 40             	or     $0x40,%eax
  102756:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10275b:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102762:	83 e0 7f             	and    $0x7f,%eax
  102765:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10276a:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10276f:	c1 e8 18             	shr    $0x18,%eax
  102772:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102777:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10277e:	83 e0 ef             	and    $0xffffffef,%eax
  102781:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102786:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  10278d:	e8 da fe ff ff       	call   10266c <lgdt>
  102792:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102798:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10279c:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10279f:	c9                   	leave  
  1027a0:	c3                   	ret    

001027a1 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1027a1:	55                   	push   %ebp
  1027a2:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1027a4:	e8 f8 fe ff ff       	call   1026a1 <gdt_init>
}
  1027a9:	5d                   	pop    %ebp
  1027aa:	c3                   	ret    

001027ab <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1027ab:	55                   	push   %ebp
  1027ac:	89 e5                	mov    %esp,%ebp
  1027ae:	83 ec 58             	sub    $0x58,%esp
  1027b1:	8b 45 10             	mov    0x10(%ebp),%eax
  1027b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1027b7:	8b 45 14             	mov    0x14(%ebp),%eax
  1027ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1027bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1027c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1027c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1027c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1027c9:	8b 45 18             	mov    0x18(%ebp),%eax
  1027cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1027cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1027d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1027d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1027d8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1027db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1027de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1027e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1027e5:	74 1c                	je     102803 <printnum+0x58>
  1027e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1027ea:	ba 00 00 00 00       	mov    $0x0,%edx
  1027ef:	f7 75 e4             	divl   -0x1c(%ebp)
  1027f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1027f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1027f8:	ba 00 00 00 00       	mov    $0x0,%edx
  1027fd:	f7 75 e4             	divl   -0x1c(%ebp)
  102800:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102803:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102806:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102809:	f7 75 e4             	divl   -0x1c(%ebp)
  10280c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10280f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102815:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102818:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10281b:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10281e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102821:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102824:	8b 45 18             	mov    0x18(%ebp),%eax
  102827:	ba 00 00 00 00       	mov    $0x0,%edx
  10282c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10282f:	77 56                	ja     102887 <printnum+0xdc>
  102831:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102834:	72 05                	jb     10283b <printnum+0x90>
  102836:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102839:	77 4c                	ja     102887 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10283b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10283e:	8d 50 ff             	lea    -0x1(%eax),%edx
  102841:	8b 45 20             	mov    0x20(%ebp),%eax
  102844:	89 44 24 18          	mov    %eax,0x18(%esp)
  102848:	89 54 24 14          	mov    %edx,0x14(%esp)
  10284c:	8b 45 18             	mov    0x18(%ebp),%eax
  10284f:	89 44 24 10          	mov    %eax,0x10(%esp)
  102853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102856:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102859:	89 44 24 08          	mov    %eax,0x8(%esp)
  10285d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102861:	8b 45 0c             	mov    0xc(%ebp),%eax
  102864:	89 44 24 04          	mov    %eax,0x4(%esp)
  102868:	8b 45 08             	mov    0x8(%ebp),%eax
  10286b:	89 04 24             	mov    %eax,(%esp)
  10286e:	e8 38 ff ff ff       	call   1027ab <printnum>
  102873:	eb 1c                	jmp    102891 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102875:	8b 45 0c             	mov    0xc(%ebp),%eax
  102878:	89 44 24 04          	mov    %eax,0x4(%esp)
  10287c:	8b 45 20             	mov    0x20(%ebp),%eax
  10287f:	89 04 24             	mov    %eax,(%esp)
  102882:	8b 45 08             	mov    0x8(%ebp),%eax
  102885:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102887:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10288b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10288f:	7f e4                	jg     102875 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102891:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102894:	05 90 3a 10 00       	add    $0x103a90,%eax
  102899:	0f b6 00             	movzbl (%eax),%eax
  10289c:	0f be c0             	movsbl %al,%eax
  10289f:	8b 55 0c             	mov    0xc(%ebp),%edx
  1028a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1028a6:	89 04 24             	mov    %eax,(%esp)
  1028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ac:	ff d0                	call   *%eax
}
  1028ae:	c9                   	leave  
  1028af:	c3                   	ret    

001028b0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1028b0:	55                   	push   %ebp
  1028b1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1028b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1028b7:	7e 14                	jle    1028cd <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1028bc:	8b 00                	mov    (%eax),%eax
  1028be:	8d 48 08             	lea    0x8(%eax),%ecx
  1028c1:	8b 55 08             	mov    0x8(%ebp),%edx
  1028c4:	89 0a                	mov    %ecx,(%edx)
  1028c6:	8b 50 04             	mov    0x4(%eax),%edx
  1028c9:	8b 00                	mov    (%eax),%eax
  1028cb:	eb 30                	jmp    1028fd <getuint+0x4d>
    }
    else if (lflag) {
  1028cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1028d1:	74 16                	je     1028e9 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1028d6:	8b 00                	mov    (%eax),%eax
  1028d8:	8d 48 04             	lea    0x4(%eax),%ecx
  1028db:	8b 55 08             	mov    0x8(%ebp),%edx
  1028de:	89 0a                	mov    %ecx,(%edx)
  1028e0:	8b 00                	mov    (%eax),%eax
  1028e2:	ba 00 00 00 00       	mov    $0x0,%edx
  1028e7:	eb 14                	jmp    1028fd <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ec:	8b 00                	mov    (%eax),%eax
  1028ee:	8d 48 04             	lea    0x4(%eax),%ecx
  1028f1:	8b 55 08             	mov    0x8(%ebp),%edx
  1028f4:	89 0a                	mov    %ecx,(%edx)
  1028f6:	8b 00                	mov    (%eax),%eax
  1028f8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1028fd:	5d                   	pop    %ebp
  1028fe:	c3                   	ret    

001028ff <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1028ff:	55                   	push   %ebp
  102900:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102902:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102906:	7e 14                	jle    10291c <getint+0x1d>
        return va_arg(*ap, long long);
  102908:	8b 45 08             	mov    0x8(%ebp),%eax
  10290b:	8b 00                	mov    (%eax),%eax
  10290d:	8d 48 08             	lea    0x8(%eax),%ecx
  102910:	8b 55 08             	mov    0x8(%ebp),%edx
  102913:	89 0a                	mov    %ecx,(%edx)
  102915:	8b 50 04             	mov    0x4(%eax),%edx
  102918:	8b 00                	mov    (%eax),%eax
  10291a:	eb 28                	jmp    102944 <getint+0x45>
    }
    else if (lflag) {
  10291c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102920:	74 12                	je     102934 <getint+0x35>
        return va_arg(*ap, long);
  102922:	8b 45 08             	mov    0x8(%ebp),%eax
  102925:	8b 00                	mov    (%eax),%eax
  102927:	8d 48 04             	lea    0x4(%eax),%ecx
  10292a:	8b 55 08             	mov    0x8(%ebp),%edx
  10292d:	89 0a                	mov    %ecx,(%edx)
  10292f:	8b 00                	mov    (%eax),%eax
  102931:	99                   	cltd   
  102932:	eb 10                	jmp    102944 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102934:	8b 45 08             	mov    0x8(%ebp),%eax
  102937:	8b 00                	mov    (%eax),%eax
  102939:	8d 48 04             	lea    0x4(%eax),%ecx
  10293c:	8b 55 08             	mov    0x8(%ebp),%edx
  10293f:	89 0a                	mov    %ecx,(%edx)
  102941:	8b 00                	mov    (%eax),%eax
  102943:	99                   	cltd   
    }
}
  102944:	5d                   	pop    %ebp
  102945:	c3                   	ret    

00102946 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102946:	55                   	push   %ebp
  102947:	89 e5                	mov    %esp,%ebp
  102949:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10294c:	8d 45 14             	lea    0x14(%ebp),%eax
  10294f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102955:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102959:	8b 45 10             	mov    0x10(%ebp),%eax
  10295c:	89 44 24 08          	mov    %eax,0x8(%esp)
  102960:	8b 45 0c             	mov    0xc(%ebp),%eax
  102963:	89 44 24 04          	mov    %eax,0x4(%esp)
  102967:	8b 45 08             	mov    0x8(%ebp),%eax
  10296a:	89 04 24             	mov    %eax,(%esp)
  10296d:	e8 02 00 00 00       	call   102974 <vprintfmt>
    va_end(ap);
}
  102972:	c9                   	leave  
  102973:	c3                   	ret    

00102974 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102974:	55                   	push   %ebp
  102975:	89 e5                	mov    %esp,%ebp
  102977:	56                   	push   %esi
  102978:	53                   	push   %ebx
  102979:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10297c:	eb 18                	jmp    102996 <vprintfmt+0x22>
            if (ch == '\0') {
  10297e:	85 db                	test   %ebx,%ebx
  102980:	75 05                	jne    102987 <vprintfmt+0x13>
                return;
  102982:	e9 d1 03 00 00       	jmp    102d58 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102987:	8b 45 0c             	mov    0xc(%ebp),%eax
  10298a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10298e:	89 1c 24             	mov    %ebx,(%esp)
  102991:	8b 45 08             	mov    0x8(%ebp),%eax
  102994:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102996:	8b 45 10             	mov    0x10(%ebp),%eax
  102999:	8d 50 01             	lea    0x1(%eax),%edx
  10299c:	89 55 10             	mov    %edx,0x10(%ebp)
  10299f:	0f b6 00             	movzbl (%eax),%eax
  1029a2:	0f b6 d8             	movzbl %al,%ebx
  1029a5:	83 fb 25             	cmp    $0x25,%ebx
  1029a8:	75 d4                	jne    10297e <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1029aa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1029ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1029b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1029b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1029bb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1029c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029c5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1029c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1029cb:	8d 50 01             	lea    0x1(%eax),%edx
  1029ce:	89 55 10             	mov    %edx,0x10(%ebp)
  1029d1:	0f b6 00             	movzbl (%eax),%eax
  1029d4:	0f b6 d8             	movzbl %al,%ebx
  1029d7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1029da:	83 f8 55             	cmp    $0x55,%eax
  1029dd:	0f 87 44 03 00 00    	ja     102d27 <vprintfmt+0x3b3>
  1029e3:	8b 04 85 b4 3a 10 00 	mov    0x103ab4(,%eax,4),%eax
  1029ea:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1029ec:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1029f0:	eb d6                	jmp    1029c8 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1029f2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1029f6:	eb d0                	jmp    1029c8 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1029f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1029ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102a02:	89 d0                	mov    %edx,%eax
  102a04:	c1 e0 02             	shl    $0x2,%eax
  102a07:	01 d0                	add    %edx,%eax
  102a09:	01 c0                	add    %eax,%eax
  102a0b:	01 d8                	add    %ebx,%eax
  102a0d:	83 e8 30             	sub    $0x30,%eax
  102a10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102a13:	8b 45 10             	mov    0x10(%ebp),%eax
  102a16:	0f b6 00             	movzbl (%eax),%eax
  102a19:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102a1c:	83 fb 2f             	cmp    $0x2f,%ebx
  102a1f:	7e 0b                	jle    102a2c <vprintfmt+0xb8>
  102a21:	83 fb 39             	cmp    $0x39,%ebx
  102a24:	7f 06                	jg     102a2c <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102a26:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102a2a:	eb d3                	jmp    1029ff <vprintfmt+0x8b>
            goto process_precision;
  102a2c:	eb 33                	jmp    102a61 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  102a31:	8d 50 04             	lea    0x4(%eax),%edx
  102a34:	89 55 14             	mov    %edx,0x14(%ebp)
  102a37:	8b 00                	mov    (%eax),%eax
  102a39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102a3c:	eb 23                	jmp    102a61 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102a3e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a42:	79 0c                	jns    102a50 <vprintfmt+0xdc>
                width = 0;
  102a44:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102a4b:	e9 78 ff ff ff       	jmp    1029c8 <vprintfmt+0x54>
  102a50:	e9 73 ff ff ff       	jmp    1029c8 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102a55:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102a5c:	e9 67 ff ff ff       	jmp    1029c8 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102a61:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a65:	79 12                	jns    102a79 <vprintfmt+0x105>
                width = precision, precision = -1;
  102a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102a6d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102a74:	e9 4f ff ff ff       	jmp    1029c8 <vprintfmt+0x54>
  102a79:	e9 4a ff ff ff       	jmp    1029c8 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102a7e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102a82:	e9 41 ff ff ff       	jmp    1029c8 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102a87:	8b 45 14             	mov    0x14(%ebp),%eax
  102a8a:	8d 50 04             	lea    0x4(%eax),%edx
  102a8d:	89 55 14             	mov    %edx,0x14(%ebp)
  102a90:	8b 00                	mov    (%eax),%eax
  102a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a95:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a99:	89 04 24             	mov    %eax,(%esp)
  102a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9f:	ff d0                	call   *%eax
            break;
  102aa1:	e9 ac 02 00 00       	jmp    102d52 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  102aa9:	8d 50 04             	lea    0x4(%eax),%edx
  102aac:	89 55 14             	mov    %edx,0x14(%ebp)
  102aaf:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102ab1:	85 db                	test   %ebx,%ebx
  102ab3:	79 02                	jns    102ab7 <vprintfmt+0x143>
                err = -err;
  102ab5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102ab7:	83 fb 06             	cmp    $0x6,%ebx
  102aba:	7f 0b                	jg     102ac7 <vprintfmt+0x153>
  102abc:	8b 34 9d 74 3a 10 00 	mov    0x103a74(,%ebx,4),%esi
  102ac3:	85 f6                	test   %esi,%esi
  102ac5:	75 23                	jne    102aea <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102ac7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102acb:	c7 44 24 08 a1 3a 10 	movl   $0x103aa1,0x8(%esp)
  102ad2:	00 
  102ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ada:	8b 45 08             	mov    0x8(%ebp),%eax
  102add:	89 04 24             	mov    %eax,(%esp)
  102ae0:	e8 61 fe ff ff       	call   102946 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102ae5:	e9 68 02 00 00       	jmp    102d52 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102aea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102aee:	c7 44 24 08 aa 3a 10 	movl   $0x103aaa,0x8(%esp)
  102af5:	00 
  102af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102af9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102afd:	8b 45 08             	mov    0x8(%ebp),%eax
  102b00:	89 04 24             	mov    %eax,(%esp)
  102b03:	e8 3e fe ff ff       	call   102946 <printfmt>
            }
            break;
  102b08:	e9 45 02 00 00       	jmp    102d52 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102b0d:	8b 45 14             	mov    0x14(%ebp),%eax
  102b10:	8d 50 04             	lea    0x4(%eax),%edx
  102b13:	89 55 14             	mov    %edx,0x14(%ebp)
  102b16:	8b 30                	mov    (%eax),%esi
  102b18:	85 f6                	test   %esi,%esi
  102b1a:	75 05                	jne    102b21 <vprintfmt+0x1ad>
                p = "(null)";
  102b1c:	be ad 3a 10 00       	mov    $0x103aad,%esi
            }
            if (width > 0 && padc != '-') {
  102b21:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b25:	7e 3e                	jle    102b65 <vprintfmt+0x1f1>
  102b27:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102b2b:	74 38                	je     102b65 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102b2d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b37:	89 34 24             	mov    %esi,(%esp)
  102b3a:	e8 15 03 00 00       	call   102e54 <strnlen>
  102b3f:	29 c3                	sub    %eax,%ebx
  102b41:	89 d8                	mov    %ebx,%eax
  102b43:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b46:	eb 17                	jmp    102b5f <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102b48:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b4f:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b53:	89 04 24             	mov    %eax,(%esp)
  102b56:	8b 45 08             	mov    0x8(%ebp),%eax
  102b59:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102b5b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102b5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b63:	7f e3                	jg     102b48 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102b65:	eb 38                	jmp    102b9f <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102b67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102b6b:	74 1f                	je     102b8c <vprintfmt+0x218>
  102b6d:	83 fb 1f             	cmp    $0x1f,%ebx
  102b70:	7e 05                	jle    102b77 <vprintfmt+0x203>
  102b72:	83 fb 7e             	cmp    $0x7e,%ebx
  102b75:	7e 15                	jle    102b8c <vprintfmt+0x218>
                    putch('?', putdat);
  102b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b7e:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102b85:	8b 45 08             	mov    0x8(%ebp),%eax
  102b88:	ff d0                	call   *%eax
  102b8a:	eb 0f                	jmp    102b9b <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b93:	89 1c 24             	mov    %ebx,(%esp)
  102b96:	8b 45 08             	mov    0x8(%ebp),%eax
  102b99:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102b9b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102b9f:	89 f0                	mov    %esi,%eax
  102ba1:	8d 70 01             	lea    0x1(%eax),%esi
  102ba4:	0f b6 00             	movzbl (%eax),%eax
  102ba7:	0f be d8             	movsbl %al,%ebx
  102baa:	85 db                	test   %ebx,%ebx
  102bac:	74 10                	je     102bbe <vprintfmt+0x24a>
  102bae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102bb2:	78 b3                	js     102b67 <vprintfmt+0x1f3>
  102bb4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102bb8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102bbc:	79 a9                	jns    102b67 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102bbe:	eb 17                	jmp    102bd7 <vprintfmt+0x263>
                putch(' ', putdat);
  102bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bc7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102bce:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd1:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102bd3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102bd7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102bdb:	7f e3                	jg     102bc0 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102bdd:	e9 70 01 00 00       	jmp    102d52 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102be2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102be5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102be9:	8d 45 14             	lea    0x14(%ebp),%eax
  102bec:	89 04 24             	mov    %eax,(%esp)
  102bef:	e8 0b fd ff ff       	call   1028ff <getint>
  102bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bf7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c00:	85 d2                	test   %edx,%edx
  102c02:	79 26                	jns    102c2a <vprintfmt+0x2b6>
                putch('-', putdat);
  102c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c0b:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102c12:	8b 45 08             	mov    0x8(%ebp),%eax
  102c15:	ff d0                	call   *%eax
                num = -(long long)num;
  102c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c1d:	f7 d8                	neg    %eax
  102c1f:	83 d2 00             	adc    $0x0,%edx
  102c22:	f7 da                	neg    %edx
  102c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c27:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102c2a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102c31:	e9 a8 00 00 00       	jmp    102cde <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102c36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c3d:	8d 45 14             	lea    0x14(%ebp),%eax
  102c40:	89 04 24             	mov    %eax,(%esp)
  102c43:	e8 68 fc ff ff       	call   1028b0 <getuint>
  102c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c4b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102c4e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102c55:	e9 84 00 00 00       	jmp    102cde <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c61:	8d 45 14             	lea    0x14(%ebp),%eax
  102c64:	89 04 24             	mov    %eax,(%esp)
  102c67:	e8 44 fc ff ff       	call   1028b0 <getuint>
  102c6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102c72:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102c79:	eb 63                	jmp    102cde <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c82:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102c89:	8b 45 08             	mov    0x8(%ebp),%eax
  102c8c:	ff d0                	call   *%eax
            putch('x', putdat);
  102c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c91:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c95:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9f:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102ca1:	8b 45 14             	mov    0x14(%ebp),%eax
  102ca4:	8d 50 04             	lea    0x4(%eax),%edx
  102ca7:	89 55 14             	mov    %edx,0x14(%ebp)
  102caa:	8b 00                	mov    (%eax),%eax
  102cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102caf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102cb6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102cbd:	eb 1f                	jmp    102cde <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102cbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cc6:	8d 45 14             	lea    0x14(%ebp),%eax
  102cc9:	89 04 24             	mov    %eax,(%esp)
  102ccc:	e8 df fb ff ff       	call   1028b0 <getuint>
  102cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cd4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102cd7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102cde:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ce5:	89 54 24 18          	mov    %edx,0x18(%esp)
  102ce9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102cec:	89 54 24 14          	mov    %edx,0x14(%esp)
  102cf0:	89 44 24 10          	mov    %eax,0x10(%esp)
  102cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  102cfe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d05:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d09:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0c:	89 04 24             	mov    %eax,(%esp)
  102d0f:	e8 97 fa ff ff       	call   1027ab <printnum>
            break;
  102d14:	eb 3c                	jmp    102d52 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d1d:	89 1c 24             	mov    %ebx,(%esp)
  102d20:	8b 45 08             	mov    0x8(%ebp),%eax
  102d23:	ff d0                	call   *%eax
            break;
  102d25:	eb 2b                	jmp    102d52 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d2e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102d35:	8b 45 08             	mov    0x8(%ebp),%eax
  102d38:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102d3a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102d3e:	eb 04                	jmp    102d44 <vprintfmt+0x3d0>
  102d40:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102d44:	8b 45 10             	mov    0x10(%ebp),%eax
  102d47:	83 e8 01             	sub    $0x1,%eax
  102d4a:	0f b6 00             	movzbl (%eax),%eax
  102d4d:	3c 25                	cmp    $0x25,%al
  102d4f:	75 ef                	jne    102d40 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102d51:	90                   	nop
        }
    }
  102d52:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102d53:	e9 3e fc ff ff       	jmp    102996 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102d58:	83 c4 40             	add    $0x40,%esp
  102d5b:	5b                   	pop    %ebx
  102d5c:	5e                   	pop    %esi
  102d5d:	5d                   	pop    %ebp
  102d5e:	c3                   	ret    

00102d5f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102d5f:	55                   	push   %ebp
  102d60:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d65:	8b 40 08             	mov    0x8(%eax),%eax
  102d68:	8d 50 01             	lea    0x1(%eax),%edx
  102d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d6e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d74:	8b 10                	mov    (%eax),%edx
  102d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d79:	8b 40 04             	mov    0x4(%eax),%eax
  102d7c:	39 c2                	cmp    %eax,%edx
  102d7e:	73 12                	jae    102d92 <sprintputch+0x33>
        *b->buf ++ = ch;
  102d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d83:	8b 00                	mov    (%eax),%eax
  102d85:	8d 48 01             	lea    0x1(%eax),%ecx
  102d88:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d8b:	89 0a                	mov    %ecx,(%edx)
  102d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  102d90:	88 10                	mov    %dl,(%eax)
    }
}
  102d92:	5d                   	pop    %ebp
  102d93:	c3                   	ret    

00102d94 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102d94:	55                   	push   %ebp
  102d95:	89 e5                	mov    %esp,%ebp
  102d97:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102d9a:	8d 45 14             	lea    0x14(%ebp),%eax
  102d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102da3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102da7:	8b 45 10             	mov    0x10(%ebp),%eax
  102daa:	89 44 24 08          	mov    %eax,0x8(%esp)
  102dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  102db1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102db5:	8b 45 08             	mov    0x8(%ebp),%eax
  102db8:	89 04 24             	mov    %eax,(%esp)
  102dbb:	e8 08 00 00 00       	call   102dc8 <vsnprintf>
  102dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102dc6:	c9                   	leave  
  102dc7:	c3                   	ret    

00102dc8 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102dc8:	55                   	push   %ebp
  102dc9:	89 e5                	mov    %esp,%ebp
  102dcb:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102dce:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  102dda:	8b 45 08             	mov    0x8(%ebp),%eax
  102ddd:	01 d0                	add    %edx,%eax
  102ddf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102de2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102ded:	74 0a                	je     102df9 <vsnprintf+0x31>
  102def:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102df5:	39 c2                	cmp    %eax,%edx
  102df7:	76 07                	jbe    102e00 <vsnprintf+0x38>
        return -E_INVAL;
  102df9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102dfe:	eb 2a                	jmp    102e2a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102e00:	8b 45 14             	mov    0x14(%ebp),%eax
  102e03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e07:	8b 45 10             	mov    0x10(%ebp),%eax
  102e0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102e11:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e15:	c7 04 24 5f 2d 10 00 	movl   $0x102d5f,(%esp)
  102e1c:	e8 53 fb ff ff       	call   102974 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102e21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e24:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102e2a:	c9                   	leave  
  102e2b:	c3                   	ret    

00102e2c <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102e2c:	55                   	push   %ebp
  102e2d:	89 e5                	mov    %esp,%ebp
  102e2f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102e32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102e39:	eb 04                	jmp    102e3f <strlen+0x13>
        cnt ++;
  102e3b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e42:	8d 50 01             	lea    0x1(%eax),%edx
  102e45:	89 55 08             	mov    %edx,0x8(%ebp)
  102e48:	0f b6 00             	movzbl (%eax),%eax
  102e4b:	84 c0                	test   %al,%al
  102e4d:	75 ec                	jne    102e3b <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102e4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102e52:	c9                   	leave  
  102e53:	c3                   	ret    

00102e54 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102e54:	55                   	push   %ebp
  102e55:	89 e5                	mov    %esp,%ebp
  102e57:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102e5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102e61:	eb 04                	jmp    102e67 <strnlen+0x13>
        cnt ++;
  102e63:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102e67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e6a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102e6d:	73 10                	jae    102e7f <strnlen+0x2b>
  102e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e72:	8d 50 01             	lea    0x1(%eax),%edx
  102e75:	89 55 08             	mov    %edx,0x8(%ebp)
  102e78:	0f b6 00             	movzbl (%eax),%eax
  102e7b:	84 c0                	test   %al,%al
  102e7d:	75 e4                	jne    102e63 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102e82:	c9                   	leave  
  102e83:	c3                   	ret    

00102e84 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102e84:	55                   	push   %ebp
  102e85:	89 e5                	mov    %esp,%ebp
  102e87:	57                   	push   %edi
  102e88:	56                   	push   %esi
  102e89:	83 ec 20             	sub    $0x20,%esp
  102e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e95:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102e98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e9e:	89 d1                	mov    %edx,%ecx
  102ea0:	89 c2                	mov    %eax,%edx
  102ea2:	89 ce                	mov    %ecx,%esi
  102ea4:	89 d7                	mov    %edx,%edi
  102ea6:	ac                   	lods   %ds:(%esi),%al
  102ea7:	aa                   	stos   %al,%es:(%edi)
  102ea8:	84 c0                	test   %al,%al
  102eaa:	75 fa                	jne    102ea6 <strcpy+0x22>
  102eac:	89 fa                	mov    %edi,%edx
  102eae:	89 f1                	mov    %esi,%ecx
  102eb0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102eb3:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102eb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102ebc:	83 c4 20             	add    $0x20,%esp
  102ebf:	5e                   	pop    %esi
  102ec0:	5f                   	pop    %edi
  102ec1:	5d                   	pop    %ebp
  102ec2:	c3                   	ret    

00102ec3 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102ec3:	55                   	push   %ebp
  102ec4:	89 e5                	mov    %esp,%ebp
  102ec6:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102ecf:	eb 21                	jmp    102ef2 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ed4:	0f b6 10             	movzbl (%eax),%edx
  102ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102eda:	88 10                	mov    %dl,(%eax)
  102edc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102edf:	0f b6 00             	movzbl (%eax),%eax
  102ee2:	84 c0                	test   %al,%al
  102ee4:	74 04                	je     102eea <strncpy+0x27>
            src ++;
  102ee6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102eea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102eee:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ef6:	75 d9                	jne    102ed1 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102ef8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102efb:	c9                   	leave  
  102efc:	c3                   	ret    

00102efd <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102efd:	55                   	push   %ebp
  102efe:	89 e5                	mov    %esp,%ebp
  102f00:	57                   	push   %edi
  102f01:	56                   	push   %esi
  102f02:	83 ec 20             	sub    $0x20,%esp
  102f05:	8b 45 08             	mov    0x8(%ebp),%eax
  102f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102f11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f17:	89 d1                	mov    %edx,%ecx
  102f19:	89 c2                	mov    %eax,%edx
  102f1b:	89 ce                	mov    %ecx,%esi
  102f1d:	89 d7                	mov    %edx,%edi
  102f1f:	ac                   	lods   %ds:(%esi),%al
  102f20:	ae                   	scas   %es:(%edi),%al
  102f21:	75 08                	jne    102f2b <strcmp+0x2e>
  102f23:	84 c0                	test   %al,%al
  102f25:	75 f8                	jne    102f1f <strcmp+0x22>
  102f27:	31 c0                	xor    %eax,%eax
  102f29:	eb 04                	jmp    102f2f <strcmp+0x32>
  102f2b:	19 c0                	sbb    %eax,%eax
  102f2d:	0c 01                	or     $0x1,%al
  102f2f:	89 fa                	mov    %edi,%edx
  102f31:	89 f1                	mov    %esi,%ecx
  102f33:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f36:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102f39:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102f3f:	83 c4 20             	add    $0x20,%esp
  102f42:	5e                   	pop    %esi
  102f43:	5f                   	pop    %edi
  102f44:	5d                   	pop    %ebp
  102f45:	c3                   	ret    

00102f46 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102f46:	55                   	push   %ebp
  102f47:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102f49:	eb 0c                	jmp    102f57 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102f4b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102f4f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102f53:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102f57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f5b:	74 1a                	je     102f77 <strncmp+0x31>
  102f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f60:	0f b6 00             	movzbl (%eax),%eax
  102f63:	84 c0                	test   %al,%al
  102f65:	74 10                	je     102f77 <strncmp+0x31>
  102f67:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6a:	0f b6 10             	movzbl (%eax),%edx
  102f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f70:	0f b6 00             	movzbl (%eax),%eax
  102f73:	38 c2                	cmp    %al,%dl
  102f75:	74 d4                	je     102f4b <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102f77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f7b:	74 18                	je     102f95 <strncmp+0x4f>
  102f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f80:	0f b6 00             	movzbl (%eax),%eax
  102f83:	0f b6 d0             	movzbl %al,%edx
  102f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f89:	0f b6 00             	movzbl (%eax),%eax
  102f8c:	0f b6 c0             	movzbl %al,%eax
  102f8f:	29 c2                	sub    %eax,%edx
  102f91:	89 d0                	mov    %edx,%eax
  102f93:	eb 05                	jmp    102f9a <strncmp+0x54>
  102f95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f9a:	5d                   	pop    %ebp
  102f9b:	c3                   	ret    

00102f9c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102f9c:	55                   	push   %ebp
  102f9d:	89 e5                	mov    %esp,%ebp
  102f9f:	83 ec 04             	sub    $0x4,%esp
  102fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102fa8:	eb 14                	jmp    102fbe <strchr+0x22>
        if (*s == c) {
  102faa:	8b 45 08             	mov    0x8(%ebp),%eax
  102fad:	0f b6 00             	movzbl (%eax),%eax
  102fb0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102fb3:	75 05                	jne    102fba <strchr+0x1e>
            return (char *)s;
  102fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb8:	eb 13                	jmp    102fcd <strchr+0x31>
        }
        s ++;
  102fba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc1:	0f b6 00             	movzbl (%eax),%eax
  102fc4:	84 c0                	test   %al,%al
  102fc6:	75 e2                	jne    102faa <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102fc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102fcd:	c9                   	leave  
  102fce:	c3                   	ret    

00102fcf <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102fcf:	55                   	push   %ebp
  102fd0:	89 e5                	mov    %esp,%ebp
  102fd2:	83 ec 04             	sub    $0x4,%esp
  102fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fd8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102fdb:	eb 11                	jmp    102fee <strfind+0x1f>
        if (*s == c) {
  102fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe0:	0f b6 00             	movzbl (%eax),%eax
  102fe3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102fe6:	75 02                	jne    102fea <strfind+0x1b>
            break;
  102fe8:	eb 0e                	jmp    102ff8 <strfind+0x29>
        }
        s ++;
  102fea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102fee:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff1:	0f b6 00             	movzbl (%eax),%eax
  102ff4:	84 c0                	test   %al,%al
  102ff6:	75 e5                	jne    102fdd <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  102ff8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102ffb:	c9                   	leave  
  102ffc:	c3                   	ret    

00102ffd <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102ffd:	55                   	push   %ebp
  102ffe:	89 e5                	mov    %esp,%ebp
  103000:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  103003:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10300a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103011:	eb 04                	jmp    103017 <strtol+0x1a>
        s ++;
  103013:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103017:	8b 45 08             	mov    0x8(%ebp),%eax
  10301a:	0f b6 00             	movzbl (%eax),%eax
  10301d:	3c 20                	cmp    $0x20,%al
  10301f:	74 f2                	je     103013 <strtol+0x16>
  103021:	8b 45 08             	mov    0x8(%ebp),%eax
  103024:	0f b6 00             	movzbl (%eax),%eax
  103027:	3c 09                	cmp    $0x9,%al
  103029:	74 e8                	je     103013 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  10302b:	8b 45 08             	mov    0x8(%ebp),%eax
  10302e:	0f b6 00             	movzbl (%eax),%eax
  103031:	3c 2b                	cmp    $0x2b,%al
  103033:	75 06                	jne    10303b <strtol+0x3e>
        s ++;
  103035:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103039:	eb 15                	jmp    103050 <strtol+0x53>
    }
    else if (*s == '-') {
  10303b:	8b 45 08             	mov    0x8(%ebp),%eax
  10303e:	0f b6 00             	movzbl (%eax),%eax
  103041:	3c 2d                	cmp    $0x2d,%al
  103043:	75 0b                	jne    103050 <strtol+0x53>
        s ++, neg = 1;
  103045:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103049:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103050:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103054:	74 06                	je     10305c <strtol+0x5f>
  103056:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10305a:	75 24                	jne    103080 <strtol+0x83>
  10305c:	8b 45 08             	mov    0x8(%ebp),%eax
  10305f:	0f b6 00             	movzbl (%eax),%eax
  103062:	3c 30                	cmp    $0x30,%al
  103064:	75 1a                	jne    103080 <strtol+0x83>
  103066:	8b 45 08             	mov    0x8(%ebp),%eax
  103069:	83 c0 01             	add    $0x1,%eax
  10306c:	0f b6 00             	movzbl (%eax),%eax
  10306f:	3c 78                	cmp    $0x78,%al
  103071:	75 0d                	jne    103080 <strtol+0x83>
        s += 2, base = 16;
  103073:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103077:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10307e:	eb 2a                	jmp    1030aa <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103080:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103084:	75 17                	jne    10309d <strtol+0xa0>
  103086:	8b 45 08             	mov    0x8(%ebp),%eax
  103089:	0f b6 00             	movzbl (%eax),%eax
  10308c:	3c 30                	cmp    $0x30,%al
  10308e:	75 0d                	jne    10309d <strtol+0xa0>
        s ++, base = 8;
  103090:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103094:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10309b:	eb 0d                	jmp    1030aa <strtol+0xad>
    }
    else if (base == 0) {
  10309d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030a1:	75 07                	jne    1030aa <strtol+0xad>
        base = 10;
  1030a3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ad:	0f b6 00             	movzbl (%eax),%eax
  1030b0:	3c 2f                	cmp    $0x2f,%al
  1030b2:	7e 1b                	jle    1030cf <strtol+0xd2>
  1030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b7:	0f b6 00             	movzbl (%eax),%eax
  1030ba:	3c 39                	cmp    $0x39,%al
  1030bc:	7f 11                	jg     1030cf <strtol+0xd2>
            dig = *s - '0';
  1030be:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c1:	0f b6 00             	movzbl (%eax),%eax
  1030c4:	0f be c0             	movsbl %al,%eax
  1030c7:	83 e8 30             	sub    $0x30,%eax
  1030ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030cd:	eb 48                	jmp    103117 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d2:	0f b6 00             	movzbl (%eax),%eax
  1030d5:	3c 60                	cmp    $0x60,%al
  1030d7:	7e 1b                	jle    1030f4 <strtol+0xf7>
  1030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1030dc:	0f b6 00             	movzbl (%eax),%eax
  1030df:	3c 7a                	cmp    $0x7a,%al
  1030e1:	7f 11                	jg     1030f4 <strtol+0xf7>
            dig = *s - 'a' + 10;
  1030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e6:	0f b6 00             	movzbl (%eax),%eax
  1030e9:	0f be c0             	movsbl %al,%eax
  1030ec:	83 e8 57             	sub    $0x57,%eax
  1030ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030f2:	eb 23                	jmp    103117 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f7:	0f b6 00             	movzbl (%eax),%eax
  1030fa:	3c 40                	cmp    $0x40,%al
  1030fc:	7e 3d                	jle    10313b <strtol+0x13e>
  1030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103101:	0f b6 00             	movzbl (%eax),%eax
  103104:	3c 5a                	cmp    $0x5a,%al
  103106:	7f 33                	jg     10313b <strtol+0x13e>
            dig = *s - 'A' + 10;
  103108:	8b 45 08             	mov    0x8(%ebp),%eax
  10310b:	0f b6 00             	movzbl (%eax),%eax
  10310e:	0f be c0             	movsbl %al,%eax
  103111:	83 e8 37             	sub    $0x37,%eax
  103114:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10311a:	3b 45 10             	cmp    0x10(%ebp),%eax
  10311d:	7c 02                	jl     103121 <strtol+0x124>
            break;
  10311f:	eb 1a                	jmp    10313b <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  103121:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103125:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103128:	0f af 45 10          	imul   0x10(%ebp),%eax
  10312c:	89 c2                	mov    %eax,%edx
  10312e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103131:	01 d0                	add    %edx,%eax
  103133:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  103136:	e9 6f ff ff ff       	jmp    1030aa <strtol+0xad>

    if (endptr) {
  10313b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10313f:	74 08                	je     103149 <strtol+0x14c>
        *endptr = (char *) s;
  103141:	8b 45 0c             	mov    0xc(%ebp),%eax
  103144:	8b 55 08             	mov    0x8(%ebp),%edx
  103147:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  103149:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10314d:	74 07                	je     103156 <strtol+0x159>
  10314f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103152:	f7 d8                	neg    %eax
  103154:	eb 03                	jmp    103159 <strtol+0x15c>
  103156:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103159:	c9                   	leave  
  10315a:	c3                   	ret    

0010315b <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10315b:	55                   	push   %ebp
  10315c:	89 e5                	mov    %esp,%ebp
  10315e:	57                   	push   %edi
  10315f:	83 ec 24             	sub    $0x24,%esp
  103162:	8b 45 0c             	mov    0xc(%ebp),%eax
  103165:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103168:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10316c:	8b 55 08             	mov    0x8(%ebp),%edx
  10316f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103172:	88 45 f7             	mov    %al,-0x9(%ebp)
  103175:	8b 45 10             	mov    0x10(%ebp),%eax
  103178:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10317b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10317e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103182:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103185:	89 d7                	mov    %edx,%edi
  103187:	f3 aa                	rep stos %al,%es:(%edi)
  103189:	89 fa                	mov    %edi,%edx
  10318b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10318e:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103191:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103194:	83 c4 24             	add    $0x24,%esp
  103197:	5f                   	pop    %edi
  103198:	5d                   	pop    %ebp
  103199:	c3                   	ret    

0010319a <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10319a:	55                   	push   %ebp
  10319b:	89 e5                	mov    %esp,%ebp
  10319d:	57                   	push   %edi
  10319e:	56                   	push   %esi
  10319f:	53                   	push   %ebx
  1031a0:	83 ec 30             	sub    $0x30,%esp
  1031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031af:	8b 45 10             	mov    0x10(%ebp),%eax
  1031b2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1031b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1031bb:	73 42                	jae    1031ff <memmove+0x65>
  1031bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1031c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1031c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1031cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1031d2:	c1 e8 02             	shr    $0x2,%eax
  1031d5:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1031d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1031da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031dd:	89 d7                	mov    %edx,%edi
  1031df:	89 c6                	mov    %eax,%esi
  1031e1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1031e3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1031e6:	83 e1 03             	and    $0x3,%ecx
  1031e9:	74 02                	je     1031ed <memmove+0x53>
  1031eb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1031ed:	89 f0                	mov    %esi,%eax
  1031ef:	89 fa                	mov    %edi,%edx
  1031f1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1031f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1031f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1031fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031fd:	eb 36                	jmp    103235 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1031ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103202:	8d 50 ff             	lea    -0x1(%eax),%edx
  103205:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103208:	01 c2                	add    %eax,%edx
  10320a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10320d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103213:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  103216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103219:	89 c1                	mov    %eax,%ecx
  10321b:	89 d8                	mov    %ebx,%eax
  10321d:	89 d6                	mov    %edx,%esi
  10321f:	89 c7                	mov    %eax,%edi
  103221:	fd                   	std    
  103222:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103224:	fc                   	cld    
  103225:	89 f8                	mov    %edi,%eax
  103227:	89 f2                	mov    %esi,%edx
  103229:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10322c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10322f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  103232:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103235:	83 c4 30             	add    $0x30,%esp
  103238:	5b                   	pop    %ebx
  103239:	5e                   	pop    %esi
  10323a:	5f                   	pop    %edi
  10323b:	5d                   	pop    %ebp
  10323c:	c3                   	ret    

0010323d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10323d:	55                   	push   %ebp
  10323e:	89 e5                	mov    %esp,%ebp
  103240:	57                   	push   %edi
  103241:	56                   	push   %esi
  103242:	83 ec 20             	sub    $0x20,%esp
  103245:	8b 45 08             	mov    0x8(%ebp),%eax
  103248:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10324b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10324e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103251:	8b 45 10             	mov    0x10(%ebp),%eax
  103254:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103257:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10325a:	c1 e8 02             	shr    $0x2,%eax
  10325d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10325f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103265:	89 d7                	mov    %edx,%edi
  103267:	89 c6                	mov    %eax,%esi
  103269:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10326b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10326e:	83 e1 03             	and    $0x3,%ecx
  103271:	74 02                	je     103275 <memcpy+0x38>
  103273:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103275:	89 f0                	mov    %esi,%eax
  103277:	89 fa                	mov    %edi,%edx
  103279:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10327c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10327f:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103282:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103285:	83 c4 20             	add    $0x20,%esp
  103288:	5e                   	pop    %esi
  103289:	5f                   	pop    %edi
  10328a:	5d                   	pop    %ebp
  10328b:	c3                   	ret    

0010328c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10328c:	55                   	push   %ebp
  10328d:	89 e5                	mov    %esp,%ebp
  10328f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103292:	8b 45 08             	mov    0x8(%ebp),%eax
  103295:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103298:	8b 45 0c             	mov    0xc(%ebp),%eax
  10329b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10329e:	eb 30                	jmp    1032d0 <memcmp+0x44>
        if (*s1 != *s2) {
  1032a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1032a3:	0f b6 10             	movzbl (%eax),%edx
  1032a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032a9:	0f b6 00             	movzbl (%eax),%eax
  1032ac:	38 c2                	cmp    %al,%dl
  1032ae:	74 18                	je     1032c8 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1032b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1032b3:	0f b6 00             	movzbl (%eax),%eax
  1032b6:	0f b6 d0             	movzbl %al,%edx
  1032b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032bc:	0f b6 00             	movzbl (%eax),%eax
  1032bf:	0f b6 c0             	movzbl %al,%eax
  1032c2:	29 c2                	sub    %eax,%edx
  1032c4:	89 d0                	mov    %edx,%eax
  1032c6:	eb 1a                	jmp    1032e2 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1032c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1032cc:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1032d0:	8b 45 10             	mov    0x10(%ebp),%eax
  1032d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1032d6:	89 55 10             	mov    %edx,0x10(%ebp)
  1032d9:	85 c0                	test   %eax,%eax
  1032db:	75 c3                	jne    1032a0 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1032dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032e2:	c9                   	leave  
  1032e3:	c3                   	ret    
