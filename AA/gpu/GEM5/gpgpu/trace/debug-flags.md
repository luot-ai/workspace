## 1. 获取trace

1. 如何得到，确定时间是个问题TODO
- GPU内部信息(--debug-flags=GPUALL)
   ```bash
   build/VEGA_X86/gem5.opt -d trace_square_all --debug-flags=GPUALL --debug-start=10852362985000 --debug-file=trace configs/example/gpufs/mi300.py -m 288622406500 --disk-image gem5-resources/src/x86-ubuntu-gpu-ml/disk-image/x86-ubuntu-gpu-ml --kernel gem5-resources/src/x86-ubuntu-gpu-ml/vmlinux-gpu-ml --app gem5-resources/src/gpu/square/bin.default/square.default --restore-dir square-cpt
   ```
- 用于得到访存信息(--debug-flags=RubyGenerated,RubySlicc)
    ```bash
    build/VEGA_X86/gem5.opt -d trace_square_tr --debug-flags=RubyGenerated,RubySlicc --debug-start=10852362985000 --debug-file=trace configs/example/gpufs/mi300.py -m 288622406500 --disk-image gem5-resources/src/x86-ubuntu-gpu-ml/disk-image/x86-ubuntu-gpu-ml --kernel gem5-resources/src/x86-ubuntu-gpu-ml/vmlinux-gpu-ml --app gem5-resources/src/gpu/square/bin.default/square.default --restore-dir square-cpt
    ```

   build/VEGA_X86/gem5.opt -d trace_square_pipe --debug-flags=GPUView --debug-file=trace configs/example/gpufs/mi300.py --disk-image gem5-resources/src/x86-ubuntu-gpu-ml/disk-image/x86-ubuntu-gpu-ml --kernel gem5-resources/src/x86-ubuntu-gpu-ml/vmlinux-gpu-ml --app gem5-resources/src/gpu/square/bin.default/square.default --restore-dir square-cpt


1. flags中不要GPUcoalescer GPUTLB
   
## 2. 处理trace

1.  sed -i 's/system/sys/g' trace
2.  tail -n +60400 trace > ntrace
3.  sed -E 's/[0-9]{9}([0-9]{5}):/\1:/' ntrace > st
4.  sed -E 's/^([0-9]{2})[0-9]*:/\1:/' st > st1


## 3. flags解析

1. `Inst`：指令的操作数
```C
    DPRINTF(GPUInst, "%s: generating operand info for %d operands\n",
            disassemble(), getNumOperands());

    DPRINTF(GPUInst, "%s adding %s %s (%d->%d) operand that uses "
            "%d registers.\n", disassemble(),
            (opType == OpType::SRC_VEC || opType == OpType::DST_VEC) ?
            "vector" : "scalar",
            (opType == OpType::SRC_VEC || opType == OpType::SRC_SCALAR) ?
            "src" : "dst", virt_idxs[0], phys_idxs[0], num_dwords);

```

2. exec
