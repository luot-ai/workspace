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
