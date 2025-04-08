# 抛弃

* 其他卷积
  * `dilated_conv`有在darknet上现成的开源，
  * `transpose_conv`例如fcn有在caffe上实现
    * 学caffe工作量大，不过darknet是个好的入手点
    * 也可以看着源码来搭建？-darknet里可能已经有 `deconv`
    * 亦或是做一个简单的demo单纯验证功能性，到后期在尝试跑大的网络
  * `deformable_conv`量大，可能会是个好点，不过估计不好验证
* im2col+gemm
  * gemm找到gem5中一个依赖性预测bug（详见memdep里的pre啥的，根据pc查表，有论文），然后发现有错误的预测导致sw后的lw发射过晚
* 服务器的事情【暂时不管】
  * 代码 环境【gem5和rv-tool和konata】
  * 可能要把 `所有代码zip和konata和rv工具链`压缩下来让他传
  * 不如用下面这个网页里的docker
  * 不知道这个网页[gem5bootcamp/gem5-bootcamp-env (github.com)](https://github.com/gem5bootcamp/gem5-bootcamp-env)上的有没有用，毕竟有prebuilt好的玩意儿，可能可以直接跑

## OODATE


* ## OOO
* 实验没有达到理想结果
  * width 乘法multi
  * 尺寸？ 框架里就是不如裸跑？
  * 并且还有bug
    * 宽度目前opt应该是8
    * 填充为1的时候
      * c=3 n=3 hw变化可以
      * c=3时，n从32开始以8为倍数好像不行
    * 填充为零没遇到不可以
* 后续
  * 目前一个最大的问题就是控制逻辑【精细调控vs改为通用方法直接调参】

    * 寄存器的数量，怎么样是最合适的，这里主要讲的是对性能的影响【啥时候置为“可取数”对性能有影响】
    * 寄存器数量改了，控制逻辑也改，有没有通用的方法，像重命名那样;通用的话可能方便设计空间探索
    * 感觉后期得大改，像重命名那样或者什么方法，目前就先这样
    * 感觉能做到数据流的唤醒方式?
  * 如何把问题迁移到darknet上，darknet是一款轻量级神经网络，适合部署在边缘端，但该框架没有winograd
  * 可能做算法上的探索：winograd和im2col如何搭配+一些扩展指令的点
  * 寄存器的数量以及winograd+im2col=设计空间探索，参考V-extension这篇文章【里头有rfline】
* 性能调优
  * hard

    * 增加一些寄存器进行细致的访存-计算调优，因为ld_output实在太慢【这个不急，因为现在也有加速效果】
    * 简单改成oacc 0和3都就绪后续迭代就load的话应该会好些？因为等ld_output太慢了
* 隐患
  * ld8_fault 错误路径却写cvec，异常恢复后同一指令继续写
  * branch_mispredict
  * notrdySn可能有小问题，主要是squash对ldk的影响
* 小调整
  * debugflag，custom的打印信息
  * 写的丑的地方模板化
  * notrdylist和notrdyldk有歧义
  * 目前notrdyldk基本能维护只有至多一个inst在list里，所以pop_front和push_back用得有些不对也无所谓，但有机会还是得改改吧【换个数据结构】
  * 设置vloaddestvec=idx1
  * 前提太多了，若无必要勿增实体
