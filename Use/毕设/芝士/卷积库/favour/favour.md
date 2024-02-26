# 这是另一个库

1. 内含多种计算卷积的方法，其中比较感兴趣的是 `winograd`  
2. 在darknet的makefile中进行了些许修改，`使得darknet可以用到该库`

## 代码组织

1. 提供了一些好的api
   1. ref是caffe官方的(其实就是col+gemm)
   2. testVectorConv可以测试两种winograd/vec
