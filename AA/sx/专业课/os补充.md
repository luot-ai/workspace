# Q & A

0. 硬件资源：CPU/存储器/总线/IO
1. 中断
   1. 中断控制是计算机发展中一种重要的技术。 最初**它是为克服对I/O接口控制采用程序查询所带来的处理器效率低而产生的**。
        中断控制的主要优点是`只有在I/O需要服务时才能得到处理器的响应，而不需要处理器不断地进行查询`
        由此，最初的中断全部是对外部设备而言的，称为外部中断(或硬件中断)。
        但随着计算机系统结构的不断改进以及应用技术的日益提高，中断的适用范围也随之扩大,出现了所谓的内部中断(或叫异常),
        它是为解决机器运行时所出现的某些`随机事件及编程方便`而出现的。因而形成了一个完整的中断系统。
   2. 处理流程：首先硬件负责关中断和保存断点，随后需要寻址例外处理程序的入口地址，这一步骤可以由硬件完成，也可以由软硬件协同完成。接下来，软件负责保存现场，执行中断服务程序，结束之后需要恢复现场，开中断，并且进行中断返回。
    中断处理需要硬件和软件配合执行，我以MIPS为例进行说明：首先，硬件需要负责关中断和保存断点(通过写CP0寄存器中的某些位完成)；然后`，需要跳转到例外处理程序入口地址，这一步骤可以通过软硬件协同完成：在MIPS中，CPU发现例外时，简单地`跳转到一个统一的入口地址，这时候就进入软件负责的部分了。软件需要保存现场，主要就是通用寄存器的值。并根据CP0寄存器中的EXCCODE跳转到具体的例外处理程序中执行。
   3. 分为`软中断`和`外部中断`，软中断一般是由执行的指令导致的，外部中断一般是从外部中断引脚输入的

2. 系统调用
   1. 系统调用是操作系统提供给用户访问硬件资源的唯一接口
      1. 设计的目的是为了更好更安全地管理有限的硬件资源，把用户从硬件设备的低级编程特性中解放出来
   2. 一般来说，系统调用都是通过中断实现的，比如，linux下中断号0x80用于进行系统调用的。
      1. 用户在进行系统调用的时候，系统就会根据中断号0x80索引中断向量表，得到系统调用处理程序入口地址。并根据用户向内核传递的具体的调用号从系统调用表中找到相应的内核函数执行，最后返回  
   3. 举例：假设现在有一个应用程序需要使用到内存分配的功能，那么首先该应用程序会调用到系统提供的内存分配的接口（系统调用），此时CPU就会切换到内核态，并执行内存分配相关的代码。内核里的内存管理代码按照特定的算法，分配一块内存。并将分配的内存块的首地址，返回给内存分配的接口函数。当内存分配的接口函数返回时，此时CPU又会切换回用户态，应用程序会得到返回的内存块首地址，并开始使用该内存

3. 内核模式
   1. 大内核：把OS所有的功能都整合在一起。我们可以把进程管理、内存管理、I/O设备……这些功能看作一个个模块。在宏内核中，这些模块都是集成在一起的，运行在内核进程中，只有处于内核态下才能运行。
      1. 性能十分好，像Linux就是传统的宏内核结构。缺点是其耦合度高，一旦其中一个模块出现问题，其他所有的模块都可能会受到影响
   2. 而微内核则恰恰相反，为了降低耦合，内核中只会允许一些核心功能的存在，而其余所有功能都会被移出内核，变成一种特殊的用户进程——服务进程。其优点就是各个模块之间是独立的，不会相互影响，但其性能相比宏内核会大幅度下降

4. **大的来了**
   1. 进程的定义：进程是一个正在计算机上执行的程序实例，是`系统进行资源分配和调度`的一个独立单位。可以通过以下元素来表征：`标识符`用于区分其他进程，<PC、内存指针、寄存器的值>（其中内存指针包括了程序代码和进程相关数据的指针，以及与其他进程共享内存块的指针），<优先级、状态>和进程调度有关，然后还包括IO状态信息和记账信息等，上述列表的信息存放在`进程控制块PCB`中，由操作系统创建和管理
   2. 线程是操作系统能够进行运算调度的最小单位，是被包含在进程之中的，是进程中的实际运作单位。包括处理器上下文环境(程序计数器和栈指针)和栈中自身的数据区域
      1. 线程可以理解为“轻量级进程”，是一个基本的 CPU 执行单元，也是程序执行流的最小单元。
      2. 它可以减小程序在并发执行时所付出的时空开销(切换、创建、终止、通信效率)，提高操作系统的并发性能。
      3. 线程共享进程拥有的`全部资源`，它不拥有系统资源，但是它可以访问进程所拥有的系统资源。线程没有自己`独立的地址空间`，它共享它所属的进程的空间
   3. 多线程技术是指把执行一个应用程序的进程划分为可以同时运行的多个线程

5. 进程和程序的区别
（1）程序是永存的；进程是暂时的，是程序在数据集上的一次执行，有创建有撤销，存在是暂时的；
（2）程序是静态的观念，进程是动态的观念；
（3）进程具有并发性，而程序没有；
（4）进程是竞争计算机资源的基本单位，程序不是。
（5）进程和程序不是一一对应的： 一个程序可对应多个进程即多个进程可执行同一程序； 一个
进程可以执行一个或几个程序

6. 进程和线程的区别
    根本区别：进程是`操作系统资源分配`的基本单位，而线程是`任务调度和执行`的基本单位。

    资源：进程是资源分配的基本单位；线程不拥有资源(只拥有少量寄存器的值)，多个线程共享所属进程的资源

    系统开销：每个进程都有独立的代码和数据空间（程序上下文），程序之间的切换会有较大的开销；线程可以看做轻量级的进程，同一类线程共享代码和数据空间，每个线程都有自己独立的运行栈和程序计数器（PC），线程之间切换的开销小。

    通信：进程间通信需要**进程同步和互斥手段**的辅助，以保证数据的一致性，而线程间可以通过直接读/写进程数据段（如全局变量）来进行通信,无需操作系统的干预(同一进程内的多个线程共享进程的地址空间)

7. 进程间通信
   1. 共享内存-依靠某种同步机制(互斥锁和信号量)
   2. 信号是一种软件形式的异常，一个进程可以通过发送信号给另外一个进程来完成进程之间的通信
   3. 套接字：完成客户端与服务器端的进程通信
   4. 管道
   5. 消息队列

8. 进程的状态
   1. 最基本的3态模型：就绪/运行/阻塞
      1. 就绪是指进程具备执行条件，等待系统调度运行
      2. 阻塞是指进程不具备执行条件，正在等待某事件的发生（IO请求）
      3. 运行->就绪(达到运行时间片)     运行->阻塞(等待使用资源)   阻塞->就绪(事件发生)   就绪->运行(`短程调度`)
   2. 5态：
      1. 加入新建态(尚未进入就绪态，`长程调度决定是否把进程添加到当前活跃的进程集`)
      2. 加入终止态(指进程完成任务到达正常结束点，或出现无法克服的错误而异常终止，或被操作系统及有终止权的进程所终止时所处的状态。)
   3. 7态：
      1. 35态都是假设所有进程都能够被存放在内存中，然而实际并不是这样。那么当系统资源，特别是内存资源不足时，就需要将某些进程挂起，将其移入到外存中，达到平滑操作系统负载的目的。因此，多加入了两个状态，分别是阻塞挂起态和就绪挂起态(`中程调度负责将挂起态的进程添加到相应的状态集中`)

9. 进程调度算法
   1. 抢占/非抢占：当前运行进程可能被操作系统打断。一个新进程到达时、或中断发生后把一个阻塞态进程置为就绪态，或出现周期性的时间中断时，需要进行抢占决策
   2. 算法补充
      1. 先来先服务FCFS:对短进程不利，对IO密集型不利
      2. 最短进程优先：预估、非抢占
      3. 最短剩余时间：预估、`抢占`发生在新进程加入就绪队列时
      4. 最高响应比优先
      5. 反馈`抢占时间片用完时`：设置多个就绪队列，当进程首次进入系统中时，会放在RQ0中；随后每次他被抢占，都会降入低一级的就绪队列。每个队列各自用FCFS方式策略，只有上一级队列空才能调度本级队列。
      6. 时间片轮转：`抢占时间片用完时`周期性地产生时钟中断，出现中断时，当前正在运行的进程会放置到就绪队列中，然后基于FCFS策略选择下一个就绪作业运行

10. 常用的并发机制是信号量  (信号量是内核对象，它允许同一时刻多个线程访问同一资源，但是需要控制同一时刻访问此资源的最大线程数量)
    - 信号量对象保存了某一资源的`最大资源计数`和当前`可用资源计数`，每增加一个线程对共享资源的访问，当前可用资源计数就减1，只要当前可用资源计数大于0，就可以发出信号量信号，如果为0，则将线程放入一个队列中等待。
    - 线程处理完共享资源后，应在离开的同时通过 ReleaseSemaphore 函数将当前可用资源数加1。
    - 如果信号量的取值只能为0或1，那么信号量就成为了互斥量

11. 大小不等的固定分区和大小可变的分区技术在内存的使用上都是低效的，前者会产生内部碎片，后者会产生外部碎片。
    1. 分页就是把`内存划分成大小固定/相等的块，且块较小`，每个进程也被分成同样大小的小块，则进程中称为`页的块`可以分配到内存中称为`页框的可用块`,没有外部碎片，仅有部分内部碎片
    2. 进程中的页在内存中不必连续存放，可以用页表来解决这个问题，OS为每个进程维护一个页表
       1. 页表给出了该进程每一页对应页框的位置

12. 页和段
    1. 页大小固定OS 段大小不定
    2. 页对编程透明 段not,编程人员决定，方便编程人员使用(DATA CODE)