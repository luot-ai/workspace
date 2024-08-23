# 译码

* Declare <.hh>
  * declare的模板会继承一个base_class，我们需要**在arch/riscv/insts中声明相应的base_class**
    * 所有这些base_class继承自riscvStaticInst，后者会包含很多***静态信息和可用的函数***
    * 这些base_class通常会包含generateAsm
    * 一般来说declare时会 reg_idx_arr_decl；重载execute/init/complete；using一下generateAsm
      * generateAsm蛮简单，就是根据操作数啥的去弄弄
* constrctor <.cc>
  * 这里就是完成一个构造
  * 有个小细节是op_class，**是在isa_parser.py中生成的，根据decoder.isa中的optargs生成**
    * funcunit.py中要相应地声明opclass，op_class.hh中要再声明一下
  * 完成reg_idx_arr的设置
  * constructor构建reg_idx_arr，flags
* decode
  * 很简单，就是根据decoder.isa中写的动态生成一个switch
    * 根据指令码完成一个return new %classname(machinst)的操作
      * 也就是实例化了上面介绍的 指令【classname】，其经过重重继承，实际上也就是一个静态指令
  * 此外，decode实际上是在fetch.cc中调用的，应该是为每条指令都整了个decoder，每条指令调用它完成静态指令的创建
* 执行
  * 执行的话没啥好说的了，各条指令在iew会调用自己的execute去执行

## OpClass

* 在src/cpu/op_class/hh中
  * include的是enums/Opclass.hh，这个文件是由build_tools/enum_hh.py动态生成的
    * 是根据cpu/funcunit.py生成的，要查看XX.hh可以搜索class XX
    * 大概是多添了个Num_XX在最后
  * using enums::OpClass表示可以直接使用枚举类型OpClass
    * 这里的语法不太清楚，但是含义很明确，添加的话也很方便
* 若需新增，先在enum_hh.py里加，再在op_class.hh里加
