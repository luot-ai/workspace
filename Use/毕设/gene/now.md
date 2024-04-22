* 跑网络

  * 模型

    * tiny-darknet
    * tiny-yolo
    * 以上两个最基础，分类还可以加个resnet?vgg实在太大，yolo都已经很大
  * 跑法

    * cv_layer改一下if=4，origin跑网络
    * 出尺寸，查一查，k=3且为偶数，下载
    * 换咱的跑，下载验证

      * 确保有扩展指令执行
      * 功能验证-检测或者分类，有个prediction_png
      * 加速效果
  * 发现错误？
* 写文档
* 写论文

  * ch3
    * 看看别人，布局，写，分层也得测
  * 结论摘要致谢
  * 目录、字体
  * ckt与小改
* 性能调优

  * hard
    * 增加一些寄存器进行细致的访存-计算调优，因为ld_output实在太慢【这个不急，因为现在也有加速效果】
    * 简单改成oacc 0和3都就绪后续迭代就load的话应该会好些？因为等ld_output太慢了
  * easy
    * 调参-发射宽度
    * 调编译选项，改为O2
* 隐患

  * branch_mispredict
  * notrdySn可能有小问题，主要是squash对ldk的影响
* 小调整

  * debugflag，custom的打印信息
  * 写的丑的地方模板化
  * notrdylist和notrdyldk有歧义
  * 目前notrdyldk基本能维护只有至多一个inst在list里，所以pop_front和push_back用得有些不对也无所谓，但有机会还是得改改吧【换个数据结构】
  * 设置vloaddestvec=idx1
  * 前提太多了，若无必要勿增实体
* 后续

  * 目前一个最大的问题就是控制逻辑【精细调控vs改为通用方法直接调参】

    * 寄存器的数量，怎么样是最合适的，这里主要讲的是对性能的影响【啥时候置为“可取数”对性能有影响】
    * 寄存器数量改了，控制逻辑也改，有没有通用的方法，像重命名那样;通用的话可能方便设计空间探索
    * 感觉后期得大改，像重命名那样或者什么方法，目前就先这样
    * 感觉能做到数据流的唤醒方式?
  * 如何把问题迁移到darknet上，darknet是一款轻量级神经网络，适合部署在边缘端，但该框架没有winograd
  * 可能做算法上的探索：winograd和im2col如何搭配+一些扩展指令的点
  * 寄存器的数量以及winograd+im2col=设计空间探索，参考V-extension这篇文章【里头有rfline】
