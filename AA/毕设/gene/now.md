# TODO

* Paper
  * paper_wonder.md：cache
    * paper_arch：reference
* Experiment

## Paper

* CKT->见下
* ld4和16和合理性
* 有些表格乱了
* 图1XTF
* 
* 
* 介绍和摘要
* ckt

  * 括号前后空格
  * 大小写（table/pic/inst）
  * 过去式
* 
* 细改文章

## Experiment

* 实验

  * 以迎合文章需求为主
  * 当然后面有时间为了锻炼也可以自己做着，下面的东西可以参考
  * 性能 / 功耗数据
    * 简单：估算 / 需要的东西去问师兄，这个真别花时间在上面
    * 复杂：跑实验 / 需要的话就看一下docker大小然后直接问hgh，windows上实在太复杂
      * 跑仿真AXI不是那个拍数我们也可以整成那个拍数
  * 注意的点
    * 要考虑模拟器上跑出来的值吗？

      * 要意识到模拟器上是非ppbuf，可能需要大概算一下
    * 虽然方差大 但单层平均25也合理 我们上下5

### 非必要实验

* 模拟器【DEBUG要有抽离性】【差不多得了，因为RTL才是真】

  * 实现ppbuf

    * 调试性能
  * 滑窗法

    * DEBUG【指令序列啥的】
    * 跑三个网络【其实vgg没必要】
  * 加速法

    * 记得换成滑窗+wino
  * 池化层效果测试

    * 编译器
    * 内联
    * debug
    * 跑池化层测试
* RTL搞好也是一种学习，verilator仿真弄好可以让他去综合

  * 参考下面的点

#### 模拟器

* other

  * 虚地址错误大概是 padding & stride=2导致的
  * 脚本混乱，脚本说明在runGem5中
    * sortdata里面的玩意儿

#### RTL-算是deprecated-可以放在初稿之后-白纸上有些笔记

* oacc对于src2需要加个偏移
* 已完成

  * 译码
  * ACC computing-unit
    * 流水级-互锁
    * 操作数选择
* 功能性能测试都再说

  * 要跑的话编译器那得改动
  * 借机搭一下差分测试？
  * 看perf.txt可以参考些东西
