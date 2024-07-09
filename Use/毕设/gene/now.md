# Q

* 想想怎么问

  * 想结合RTL写的写上去
* 乘法32-64

  * 31-16:0 15-0:16bit
  * 感觉应该是在ld的时候去整，会比较好，16bit外还有数就直接max-16？
  * 乘法只要低32bit
* CPAD MTFCR是否需要实现

  * CPAD算了 MTFCR想想
* 模拟器测试的合理性
* * 访存ld4？
* RTL是否需要功能验证

  * 直接综合功耗？

# 模拟器

* 待
  * 跑完resnet18 -> vgg16
    * 保存
  * 实现MAXF指令
  * 跑加速
    * 保存
* other
  * 虚地址错误大概是 padding & stride=2导致的
  * 脚本混乱，脚本说明在runGem5中
    * sortdata里面的玩意儿

## 论文

* big

  * 结合RTL想想怎么说
    * 译码？
    * 计算部件？
      * 各流水级
      * 操作数选择
      * 互锁
  * 那三条指令的 pic descrip
  * 指令编码
  * 预留指令说法（rsvd也是）
  * MTFCR改成一个会好点
    * 如果还要的话
* small

  * ch3 inst num of 编译
* other

  * ref
  * ckt
    * 大小写（table/pic/inst）

## 软件

* maxf
  * 改写池化层
* RTL新指令

## RTL

* 实现-看白纸
* 综合功耗
* 功能？性能
  * 看perf.txt

## 跑网络

* 模型

  * tiny-darknet分类
  * tiny-yolo目标检测
  * resnet分类
  * vgg实在太大，yolo都已经很大
* 跑法

  * 出尺寸，查一查，k=3且为偶数
  * 方案

    * if=4，全跑im2col
    * wino_cus改一下，区分原始和改动
  * 换咱的跑，下载验证

    * 确保有扩展指令执行
    * 功能验证 - 检测或者分类，有个prediction_png
    * 加速效果
* 目前

  * width=4
  * 乘法给他调成multi了
  * 后续可能还得查一下【不过也还要进行性能提升】
    * 尺寸的原因？
    * 在框架里跑就是不如直接裸跑
* ## OOO
* 实验没有达到理想结果

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
