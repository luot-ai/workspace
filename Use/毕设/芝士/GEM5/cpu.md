# POINT

* 首先这些CPU都是ISA无关的
  * ISA相关的东西在一个专门的地方写（除了译码肯定还有其他问题
  
## SimpleCpu

* 纯功能，顺序执行
* base-:就是定义了基本上除了执行以外的所有东西吧，是要被继承的
* atomic-：原子访存
* timing-：

## O3Cpu

* 基于alpha21264的乱序
* **模板化template策略**
* 低级别的模块在此处实现，高级别的就相当于ISA相关了呗（得另外实现
* very configurable

## MinorCpu

* 顺序的四级流水fetch12 decode execute
* 代码框架
  * cpu.hh中定义了一个pipeline，在pipeline中具体实现
  * cpu.cc中实例化该pipeline
  * pipeline中实例化`各流水级`和流水级寄存器
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
  * pipeline继承自tick，后者`事件驱动`：每周期上升沿会调用evaluate函数
  * pipeline`override`evaluate函数，这个函数里头会调用各stage的evaluate
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
      * inputbuffer是一个容器，有`线程数`个`InputBuffer`
        * 其中InputBuffer大概也是个队列似的玩意儿，以`forwardInstdata`即一组指令为单位
      * fuDescriptions，通过参数executeFU来配置
        * 本质上是一个装了MInorFU的vector
        * 每个MInorFU都对应着一个FUpp的描述
        * 在Execute构造函数(即`构建这个流水级`)中用一个循环来使用fuDescriptions实例化一个个fu，并填到execute的成员变量中
      * **`就是得自顶向下看，被教程误导了`**
        * 先处理中断，然后commit->issue->各fuAdvance(交杂着判断need_tick->下一拍有没有事情)->设置mightCommit
      * commit
        * 涉及`drain`，必要的话可以关注自动机
        * 正常情况的话，从inFightInsts中将满足条件的指令`按序`退休，涉及到访存就会有些复杂
        * 然后退休的话，首先会`unstall`相应的FU，允许其advance(adv后，若队头非空泡就会stall)
          * 有空泡的话会触发一个need_to_tick,也就是可以让这个fu继续前进吧
      * issue
        * 整体效果就是将insts_in中的指令都尝试找到一个`FU`来issue，会有数量上的限制
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
    * 这玩意儿主要就是给inst提供了一个操作`CPU资源`的接口
* 一条指令如何被执行
  * 会调用一个decode->decodeInst
    * decodeInst是在build的过程中根据指定的ISA生成的
      * 怎么生成的不用管，用的DSL(类似chisel)
        * 不同的OP会有不同的代码生成模板，模板之下又是模板
        * 对于访存
          * 可以直接execute
          * 也可以initiate complete
      * 生成的函数是比较傻的，就是switch各个域，比对指令
  * 执行的话是commitInst的时候调用生成的 inst->staticInst->execute函数做的
    * 使用context接口去读写寄存器
  