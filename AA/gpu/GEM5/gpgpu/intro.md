# Basic

* 模型简介
   * 定位：模拟 `AMD VEGA` 架构 GPU 的硬件行为，直接工作在 VEGA ISA 指令集层级（非高级中间语言）。
   * 适用场景：
      * 研究 GPU 微架构（如缓存、流水线）
      * 验证 ROCm 软件栈的兼容性。
* 仿真模式
  * 系统仿真`SE`模式
    * 仅模拟用户态程序
    * GPU类型：`APU`
    * 驱动：简化的 `ioctl` 模拟
  * 全系统`FS`模式
    * 运行完整操作系统
    * GPU类型：`dGPU`
      * 支持X86 KVM/Atomic CPU
      * 主机要求为支持KVM的X86
    * 使用真实 Linux 驱动
      * 建模了DMA和packet处理单元
      * 支持GPU虚拟存储
    * 仿真更快（因为CPU模型更简单）
* ROCm 软件栈支持

    SE模式支持v4.0 FS模式支持v6.1
    | 组件 | 作用                                           | 模式支持       |
    | ---- | ---------------------------------------------- | -------------- |
    | HCC  | 编译器	将 HIP 代码编译为 GPU 指令（类似 NVCC） | SE / FS        |
    | ROCr | 运行时	管理 GPU 执行上下文和内存               | SE / FS        |
    | ROCt | 通信层	连接用户态和内核态驱动                  | SE（模拟驱动） |
    | HIP  | AMD的GPU编程框架（兼容 CUDA 语法）             | SE / FS        |

* GPU 支持

    * Vega (gfx900 – dGPU, gfx902 – APU)
    * MI200 (gfx90a – dGPU), MI300 (gfx942 – dGPU)
      * 支持tensor core
      * MI200目前兼容性更好
    * 强制使用`Ruby`协议

## HardWare
* 相当于对官网白皮书里面的架构图进行了模拟器的划分模块实现
* APU
![Alt text](image.png)
* Kernel Execution
  * 流程
    * 用户空间触发任务：应用程序调用 HIP 或 rocBLAS 接口 → 生成 AQL 包并提交到 HSA 软件队列。
    * 驱动层处理：ROCk 驱动通过 ioctl 接收任务 → HSAPP 将软件队列映射到硬件队列。
    * 硬件调度与执行：HSAPP 调度队列 → Workgroup Dispatcher 将Work Groups分派到 CU
      * Dispatcher会跟踪kernel的状态
        * 若WG不能被分派 → 排队等待资源充足
        * 若某一任务的所有WG执行完成 → dispatcher释放CU资源并通知主机
    * CU 执行 GPU 内核代码 → 结果写回内存。
  * 模块代码解析
* 执行流水级
  * 取指：为**已派发的**Wavefronts取指令 - fetch_stage.[hh|cc] and fetch_unit.[hh|cc]
  * 记分牌：检查哪个WFs已经就绪 - scoreboard_check_stage.[hh|cc]
  * 调度：从就绪队列中选择一个WF - schedule_stage.[hh|cc]
  * 执行：运行WF - exec_stage.[hh|cc]
  * 访存流水线：执行LDS/全局访存操作
    * local_memory_pipeline.[hh|cc]
    * global_memory_pipeline.[hh|cc]
    * scalar_memory_pipeline.[hh|cc]

 
