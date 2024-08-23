# 卷积

## darknet：col+gemm

* 开-O2能省去很多代码【好像是-Ofast，雾
  ![Alt text](image/1708526192781.png)
  ![Alt text](image/1708526147978.png)
  ![Alt text](image/1708526434235.png)

* 研究gemm所得：0229 0845-1012【0302补充，图直观但是并不全对，看out】
  * gem5里面mem指令来到IQ时会进行dependency检查
    * 用的是一篇论文里的，具体目的是预测某memref指令是否依赖于前面的store【store为啥会依赖于store】
      * 若预测依赖，则即使该指令操作数就绪也不能issue...
    * 但是在矩阵乘的时候总是预测错误，sw->sw sw->lw2
    * 这属于啥问题...

## favour：winograd

* winograd5的im2col用fast和O2没啥区别，直接在O2上分析，此外还得结合col2im
  * 向量扩展去做也挺好的，不知道编译上如何支持，以及gem5是否支持
    * gem5是支持`RVV`，输出里有RVV enabled VLEN ELEN可以顺着代码看下
    * 记得老师也说过可以去看看RVV做得不好的地方
    * 也就是说就算gem5支持，也可以模仿他的改一下
    * 此外`RVV`和`SIMD`的区别，然后感觉gem5的simd有点扯，怎么lat=1？
  * 或者，想点新奇的招数？

* winograd5的Ofast比O2快很多
  * Ofast
    * multi他是有行列边界的判断，所以其实是有点浪费，这里其实写一个for循环做乘法会更好
      * 用向量乘替代，同时向量乘可能也可以用到转置卷积中，问题又回到了向量扩展的问题上
      * 当然这里可以直接把multi和后面的结合起来做，多周期就是了

# 扩张卷积

## darknet：


# 转置卷积

## darknet：deconv？

## caffe：fcn？

## diy：build by uself


# 可形变卷积
