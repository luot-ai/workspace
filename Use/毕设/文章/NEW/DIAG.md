# 点

1. 为 直接印在硬件中的应用 手工制作数据路径
2. 将函数或程序 流水化，加速器就可利用其中的 数据级并行 On the hand, accelerators can effectively exploit data-level parallelism (DLP) by pipelining entire functions and programs.
3. 执行程序时 构建指令数据流图 - 开发指令级并行
   1. 还可线程级并行
4. 一排功能单元+寄存器通道
   1. 寄存器通道 充当 前递单元+物理寄存器堆+ROB
   2. 每个寄存器都是一个bundle of wire
   3. 传统：将DFG映射到PE阵列中     DIAG：按指令顺序映射到PE中，使用寄存器通道互联动态构建DFG
5. 不显示重命名/乱序发射，而是在硬件中 动态构建 程序的 受限DFG
   1. 当指令按顺序排列时，会自动出现
6. We can treat DiAG’s design
    as a temporal record of a processor’s back-end laid out spatially in
    hardware with register lanes traveling in the direction of time