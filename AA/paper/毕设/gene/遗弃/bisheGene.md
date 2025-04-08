<!--
 * @Author: lt 1035768203@qq.com
 * @Date: 2024-02-26 14:09:02
 * @LastEditors: lt 1035768203@qq.com
 * @LastEditTime: 2024-03-05 10:10:14
 * @FilePath: \workspace\Use\毕设\芝士\卷积库\gene\gene.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->

# GENE

1. 最后阶段【实现+实验】

   1. 0317完成指令和具体的做法
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
