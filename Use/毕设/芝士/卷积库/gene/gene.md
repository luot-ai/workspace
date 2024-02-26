# GENE

1. 小程序段性能调优 --- 大程序功能验证
2. 方法论

   1. 目前使用reset可以把输出截断，优化等级就用-O2
   2. 要切分基本块的话，感觉借助模拟器的输出pc写个python脚本应该不难实现
   3. 乱序内部结构不了解，不便分析，可以选择

      1. GEM5学习：ckpt  +  debugging +  statics  +  tracingCPU
      2. 了解gem5乱序，找瓶颈
3. 各维度

   1. 卷积：目前是 `col+gemmING`,`winogradING` ~~vectorized~~待，也可以都搞
   2. `dilated_conv`有在darknet上现成的开源，待
   3. `transpose_conv`例如fcn有在caffe上实现
      1. 学caffe工作量大，不过darknet是个好的入手点
      2. 也可以看着源码来搭建？-darknet里可能已经有 `deconv`
      3. 亦或是做一个简单的demo单纯验证功能性，到后期在尝试跑大的网络
   4. `deformable_conv`量大，可能会是个好点，不过估计不好验证
4. 想到的点

   1. im2col可能涉及到load-store这样的指令，可以设计扩展指令
   2. 稀疏-流水-pingpong
   3. 0winograd那篇文章把大矩阵拆成若干wino其实可能很容易超过
5. now

   1. 二月份：
      1. ①winograd上工程【内可能含 图形转换 可以结合im2col】   	【26号】
      2. ②im2col上工程									【27号】
      3. ①gemm细致分析，涉及到2.2方法论学一学				【剩下那一周】
   2. 三月份：
      1. 结合二月所做，稍微写点东西，应对中期
   3. 最后阶段
      1. 看看中期前做的效果吧
      2. 还是比较希望加上 ③扩张和④转置，做这四个的通用，或者每个都有个点
         1. 可形变是一个美好的愿景
         2. vec不知要不要
      3. 完整的实验对比啥的
