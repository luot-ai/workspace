# 卷积

## darknet：col+gemm

* 开-O2能省去很多代码【好像是-Ofast，雾
  ![Alt text](image/1708526192781.png)
  ![Alt text](image/1708526147978.png)
  ![Alt text](image/1708526434235.png)

* 研究gemm所得：0229 0845-1012
  * 发现第二个lw总是长时间处在DS
    * 看log memDep显示waking...
    * 到对应代码下去看，发觉应该和前面的store有关
    * 在到store的log去查看，可以看到store添加了这lw(以及下面一个sw)到他的depende列表里
    * 结合searching for producing的代码，发觉可能是一个错误的访存预测导致了这个结果
    * 虽说是个无聊的bug，但是也熟悉了代码

## favour：winograd

* 目前是学了一下概念，下面应该看看代码，跑一跑

# 扩张卷积

## darknet：


# 转置卷积

## darknet：deconv？

## caffe：fcn？

## diy：build by uself


# 可形变卷积
