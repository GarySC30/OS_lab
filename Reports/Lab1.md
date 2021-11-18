### 练习1

- 操作系统镜像文件ucore.img是如何一步一步生成的？

  运行指令 `make v= ` ，阅读其结果：

  ![1](/Users/gary/OneDrive/大三上/OSLab/Reports/Pics/1.png)

  发现调用了 GCC，ld，dd

  - make执行将所有的源代码编译成对象文件，并分别链接形成kernal，bootblock文件。

  ![2](/Users/gary/OneDrive/大三上/OSLab/Reports/Pics/2.png)

  - dd程序将c程序编译，转换成可执行文件，将Bootloader转移至虚拟硬盘ucore.img中

  ![3](/Users/gary/OneDrive/大三上/OSLab/Reports/Pics/3.png)

- 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？

  - 打开 sign.c

    <img src="/Users/gary/OneDrive/大三上/OSLab/Reports/Pics/4.png" alt="4" style="zoom:50%;" />

    可以发现：符合规范的MBR特征是其512字节数据的最后两个字节是 0x55、0xAA

    ![5](/Users/gary/OneDrive/大三上/OSLab/Reports/Pics/5.png)

### 练习2

- 从CPU加电后执行的第一条指令开始，单步跟踪BIOS的执行。

  - 使用指令 `less` 进入Makefile，并查看<img src="/Users/gary/OneDrive/大三上/OSLab/Reports/Pics/6.png" alt="6" style="zoom:33%;" />相关代码

    ![7](/Users/gary/OneDrive/大三上/OSLab/Reports/Pics/7.png)

  - 查看lab1init的内容

    ![8](/Users/gary/OneDrive/大三上/OSLab/Reports/Pics/8.png)

    - 加载符号
    - 连接qemu
    - BIOS进入8086的实模式
    - Bootloader第一条指令在0x7c00，打一个断点
    - 继续运行
    - 打印两条指令寄存器的地址

  - 执行指令 ` make lab1-mon` 

    - 进入QEMU

      ![9](/Users/gary/OneDrive/大三上/OSLab/Reports/Pics/9.png)

      

- 在初始化位置0x7c00设置实地址断点,测试断点正常。

- 从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较。

- 自己找一个bootloader或内核中的代码位置，设置断点并进行测试。

