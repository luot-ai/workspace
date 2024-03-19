<!--
 * @Author: lt 1035768203@qq.com
 * @Date: 2024-02-26 14:09:02
 * @LastEditors: lt 1035768203@qq.com
 * @LastEditTime: 2024-03-05 10:10:14
 * @FilePath: \workspace\Use\毕设\芝士\卷积库\gene\gene.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->

# GENE

1. 各维度

   1. 卷积： `col+gemmING`,`winogradING`
   2. 忘却
      1. `dilated_conv`有在darknet上现成的开源，
      2. `transpose_conv`例如fcn有在caffe上实现
         1. 学caffe工作量大，不过darknet是个好的入手点
         2. 也可以看着源码来搭建？-darknet里可能已经有 `deconv`
         3. 亦或是做一个简单的demo单纯验证功能性，到后期在尝试跑大的网络
      3. `deformable_conv`量大，可能会是个好点，不过估计不好验证
2. 想到的点

   1. gemm找到gem5中一个依赖性预测bug（详见memdep里的pre啥的，根据pc查表，有论文），然后发现有错误的预测导致sw后的lw发射过晚
   2. im2col和wino5见那几张纸
      1. wino除了现在核心循环那，其实还可以分析下其他部分
3. 服务器还没好，在那之前两种方法都可以试下：

   1. 代码 环境【gem5和rv和konata】
   2. 可能要把 `所有代码zip和konata和rv工具链`压缩下来让他传
   3. 不如用下面这个网页里的docker
   4. 不知道这个网页[gem5bootcamp/gem5-bootcamp-env (github.com)](https://github.com/gem5bootcamp/gem5-bootcamp-env)上的有没有用，毕竟有prebuilt好的玩意儿，可能可以直接跑？![1709542940223](image/gene/1709542940223.png)
4. 最后阶段【实现+实验】

   1. 0317完成指令和具体的做法

      1. 扩展指令的实现可以结合数据流吗
   2. 0324改动C源码
   3. 0407Gem5源码
   4. 0414DEBUG
   5. 0421小程序性能调优，对比tick

      1. 调参-发射宽度
      2. 调编译选项，改为O2
      3. 调网络结构
      4. gemm那里可能不好说，不过他也有漏洞
   6. 0428跑通大程序，希望既有加速效果，又能功能正确
   7. 开始写论文，进行一些分析什么的
   8. gem5的课程以及官网教程，有需要时使用【不过直接上网查也ok】

      1. 官网教程

         1. doc/debugging ckpt tracing_cpu statics
      2. 我看那几个PPT可能有比较重要的部分

         1. 06中有详细的ISA相关，可查；还有训练，可练；还有个assembler没看懂
         2. 03slide27有m5动态编译的东西
         3. 02最后有访存发包啥的，前面是simObject【可以结合rvv.pdf去理解事件驱动编程】
         4. 04是cache什么的
      3. ![1709637132079](image/gene/1709637132079.png)降序
   9. 想peach

      1. 加上 ③扩张和④转置，
         1. 做这四个的通用，或者每个都有个点
         2. 可形变是一个美好的愿景
         3. wino3和wino4有通用的部分，就是一维wino，看看有没有必要做，然后可能也有一些其他的点
            1. 大概是没有必要了，毕竟wino其实只需要一种就好了
   10. 回顾龙芯和毕设历程，结合dia
   11. 整理workspace
   12. 结合纸和wrkspace，做个gem5教程
