* BASIC
  * 基于3D点云做分类/分割
  * 输入为n*3的二维tensor，n是点云数量，3对应xyz坐标
  * 数据是3D点云，就是3维坐标系下一系列点的集合，可以是雷达扫描获得的
  * CUDA
    * grid block thread
    * 同一个block的thread会被分组，每个组就是一个warp，warp是执行指令的单元，同一个warp里的线程会执行相同指令
    * bank conflict
      * 同一个warp中的thread访问同一个bank中的值
* 优化
  * 主要使用nvprof去看当前执行的瓶颈
  * kernel融合【简单的fuse：batchnorm relu】【紧耦合：maxpooling】
    * 减少kernel启动回收时间，减少访存
    * maxpooling紧耦合减少存/取量
  * 带batch：50s->20s
    * 利用并行性
  * 减少cudamalloc/cudamemcpy/cudafree：20s->12s
    * 之前为了编程简单，每次调用内核时进行分配
    * 后来改为先在device端统一分配好
      * 包括参数
      * 包括中间feature，原来是每个kernel都有对应的malloc，现改为一次malloc+偏移读取
  * kernel优化
    * gemm：9s->1.6s
    * maxpooling：1s内
    * fbr
* kernel
* 一维卷积：实际上就是矩阵乘
  * 优化

    * 这是耗时最多，然后可优化点最多的一个算子，所以耗费时间最多，使用的优化方法包括朴素/常规一些的方法包括block_tiling/thread_tiling/double_buffer，然后还有像算子融合这样的方法，包括把他和后续的batchnorm/relu/池化算子融合
      * 池化就是在写回主存前加一个求最大值的过程，比如说我是一个block负责一个输出中的小矩阵，然后我们这里池化要求的是求某个维度上的最大值，那么我这个block在写回时就是写的一列（或者一行）
      * 当然这里池化是没算完的，这样可以减少数据的加载，然后不算完的原因和数据的
    * shared mem：用一个block去做一个子矩阵乘，block内复用内存
    * memory coalescing：让同一个warp里的thread访问连续的数据，可以聚合访问
    * thread tiling：一个thread做一个小的子矩阵乘，减少从shared mem访问，复用thread寄存器
    * warp tiling：增大计算访存比
    * double buffer：thread指令级并行
* 池化
  * 使用warp原语指令shfl_down_sync
    * 直接将数据送给同一个warp中的其他thread
  * 避免warp_divergence
    * 忽略一些点，避免出现if（从而导致同一warp内出现不同的分支路径）
* 全连接
  * 使用warp原语指令shfl_down_sync
    * 乘-规约加
