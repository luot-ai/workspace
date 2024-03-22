# POINT

* 首先这些CPU都是ISA无关的
  * ISA相关的东西在一个专门的地方写（除了译码肯定还有其他问题

## SimpleCpu

* 纯功能，顺序执行
* base-:就是定义了基本上除了执行以外的所有东西吧，是要被继承的
* atomic-：原子访存
* timing-：

## O3Cpu

* 特点
  * 基于alpha21264的乱序
  * **模板化template策略**
  * 低级别的模块在此处实现，高级别的就相当于ISA相关了呗（得另外实现
  * very configurable
* 代码
  * general
    * 在cpu.cc中实例化构造各成员时，会将params赋给相应的成员
      * setTBuf是设置backward，setXX是正向
      * 结合trace可知**tick是每周期最开始做的事情**
        * 0302结合trace文字版捋了一遍，gem5官网上也有一些说明
        * 前端就忽略了，rename一共两拍，第二拍被写入rob
        * 下一阶段是IS，进入IQ中，根据操作数是否就绪 `add2RdyList` `scheduleRdyInst`进行issue
          * rdyLIst按op进行排布，此外还维护一个orderList判断就绪指令的顺序
          * **单周期(包括ldst)放入2issue，多周期交给schedule-event-process机制，简而言之就是opLat-1周期后push入2issue**
            * 发射时去fupool找该op对应的可用fu_idx
        * 下一阶段来到Exe
          * 普通指令直接执行，调用生成的函数【具体怎么生成的看下面】，会访问寄存器，设置寄存器的值；同时会调用 `inst2commit`和 `wbinst`，sending to commit，**关键是这里会唤醒IQ中的指令**
          * load会调用read，若可以从SQ中读则下一周期调用wb，否则发包至cache，若干周期recv后会像普通指令一样，调用 `inst2commit`和 `wbinst`，**唤醒**
            * initiateAcc大概是算地址并检查，经过层层调用来到read
          * store懒得打了
        * 来到commit
          * 会把头部指令退休掉，把rob中rdy的指令mark一下
    * baseO3CPU中包含各种delay和width，并且使用的是defaultFupool
  * Fu相关
    * 省流
      * 逻辑是 `FuPool`包含 `Fu`包含 `op`；fu有个count，op有个lat(1)和pipe(T)
      * 进入config.ini可以查看，要更改请移步fupool.py或fuconfig.py
    * 代码编写
      * 一个fupool包含了几个列表，长度为num_opclasses，分别记录了maxOpLat pipe capable【fu是oplat pipe capable】
        * 以及一个fupercaplist，包含属于各op的Fu编号【用一个循环队列实现，可以方便读取空闲的fu】

## MinorCpu

* 顺序的四级流水fetch12 decode execute
* 代码框架

  * cpu.hh中定义了一个pipeline，在pipeline中具体实现
  * cpu.cc中实例化该pipeline
  * pipeline中实例化 `各流水级`和流水级寄存器
* 关键的数据结构

  * InstId：
  * `MinorDynInst`指令在流水线中的执行进展，指令分为bubble/fault/normal三类
    * 类中声明了诸如 instorebuffer 这样的成员变量,作为指令的特性
  * 各种data
    * 大部分是流水级间传递的数据结构
      * forwardLine:传递的以cacheline为主的数据结构，f1-f2
      * forwardInst:f2-decode-exe，宽度为width的指令包
  * fetchReq & lsqReq
* Pipeline

  * 各级之间的延迟是可以参数配置的，这和minorBuffer有关
    * 除了正向以外，反向数据传递也通过buffer实现
    * if2 decode exe还设置ibf
* 事件处理：minorActivityRecorder

  * minor是按时钟周期调用的模型，外部事件通过调用函数来触发
  * pipeline继承自tick，后者 `事件驱动`：每周期上升沿会调用evaluate函数
  * pipeline `override`evaluate函数，这个函数里头会调用各stage的evaluate
    * 各stage可以调用一个函数来signal下一周期的activity
* 各流水级：（只看了比较关心的部分）

  * 执行级
    * 指令可能需要多周期执行，其精确的时序由一个**FU-PIPELINE**来建模
      * 每个FU通过 参数 executeFuncUnits 来配置
    * **FU-PIPELINE**
      * 继承自selfStallPipeline和Funcunit
        * 主要是selfstallpp这个
          * 声明类的时候用了模板参数：就是类似于咱之前写那个pipeconnect那种感觉
          * 关键点有push、pop、advance，还有一个stall
      * 成员变量MinorFU提供描述
        * opClasses
        * oplatency（issue->end
        * issuelatency（两次issue的最小间隔
        * **timings**
      * sspp继承自minorBuf-timeBuf,实现为一个环形队列
        * 有点类似于ringBuffer
        * 槽的数量=opLatency
        * advance(pop)实际上就是把base++，push口的偏移不变，相当于整个环转动了下
        * 此外，只有advance才会改变base，这也就是说如果push但不advance的话，push口那玩意儿是会被覆盖的
    * **execute.cc**
      * inputbuffer是一个容器，有 `线程数`个 `InputBuffer`
        * 其中InputBuffer大概也是个队列似的玩意儿，以 `forwardInstdata`即一组指令为单位
      * fuDescriptions，通过参数executeFU来配置
        * 本质上是一个装了MInorFU的vector
        * 每个MInorFU都对应着一个FUpp的描述
        * 在Execute构造函数(即 `构建这个流水级`)中用一个循环来使用fuDescriptions实例化一个个fu，并填到execute的成员变量中
      * **`就是得自顶向下看，被教程误导了`**
        * 先处理中断，然后commit->issue->各fuAdvance(交杂着判断need_tick->下一拍有没有事情)->设置mightCommit
      * commit
        * 涉及 `drain`，必要的话可以关注自动机
        * 正常情况的话，从inFightInsts中将满足条件的指令 `按序`退休，涉及到访存就会有些复杂
        * 然后退休的话，首先会 `unstall`相应的FU，允许其advance(adv后，若队头非空泡就会stall)
          * 有空泡的话会触发一个need_to_tick,也就是可以让这个fu继续前进吧
      * issue
        * 整体效果就是将insts_in中的指令都尝试找到一个 `FU`来issue，会有数量上的限制
          * 相应的规则包括
            * 是否找到可发射的fu
            * 数据相关
        * 注意到有个thread.ipidx,体现出在一个线程内是按顺序来issue的
        * issue的效果：
          * 指令push入对应的fu
          * 指令push进入这个线程对应的inflightinst，这个就是为什么**单周期能发到多FU然而却可以按序提交**的原因

### 进阶部分

* 接口
  * cpu通过**static instruction objects**接口来处理指令
    * 静态信息
    * **不同ISA指令**会继承这玩意儿，并且实现其中的virtual function
  * 指令通过**Execution Context**接口来使用CPU
    * 实例化这玩意儿时会把dyninst放进去
    * 这玩意儿主要就是给inst提供了一个操作 `CPU资源`的接口
      * 例如可以用来写寄存器
* Decode
  * decodeInst是在build的过程中根据指定的ISA生成的
    * 怎么生成的不用管，用的DSL(类似chisel)
      * **在 `decoder.isa`中有不同的OP**
        * `def format XXX`查看模式，他们可能继承于basic里的一些模板template(也可能就在同一代码文件中)
          * 注意看，那些逗号就是放进模板的参数
          * instobjparams包含了模板template中需要被替代的参数【.subst替换】
          * 以IOP为例
            * 除了code**参数之一**外，还有几个源操作数和写回的代码小模块(不清楚在哪声明的)
          * 再以一个flw(LOAD)为例
            * initiateAcc都是差不多
            * memaccode是用在completeAcc中
      * bitfield查看指令码各区域含义
      * operand查看一些字母代表的含义(寄存器、类型)
    * 生成的函数是比较傻的，就是switch各个域，比对指令
