# 记录

1. 包含：
   1. col+gemm
   2. deconv
   3. 扩展的dilated github项目
2. 从darknet.c入手，结合[https://blog.csdn.net/just_sort/article/details/100037805](https://blog.csdn.net/just_sort/article/details/100037805)这个和github上那个带注释的
3. parser负责填充，forward代表计算逻辑

## FORWARD

1. 分组卷积

   1. ifmap和ofmap按group在channel上分，独立完成卷积后再拼接


