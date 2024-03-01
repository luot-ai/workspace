# FIRST

* 使用scons，选用buildopt下的配置编译出可执行文件
  * 大概就是一些ISA相关或无关的模块
* configs里是用于构建仿真系统的配置脚本文件
  * 搭积木，编写仿真配置文件，最后这些py里的simObjects会被编译成对应的c++
  * 将CPU指向tests中待执行的可执行文件
    * 可执行文件+仿真配置脚本=结果
  * 仿真类型：SE和FS(全系统仿真)
    * 仿真结果m5out
      * config.ini用于检查系统的最终配置
        * **这里每一个Type都直接对应到相应的.py，可以对照查看代码；然后children可能要查看py中所对应的.h**
      * stats.txt
  * 目录介绍
    * common下的options**命令行中可指定的参数**
      * 涉及到manymanycore【homework6中有众核】
      * simulation涉及到checkpoint
      * 所有的选项被addXXOptions包含，其他代码文件基本会调用该函数
    * example下有se和fs，比较重要
  * 参数介绍
    * --cpu-type
      * minor O3支持乱序 
      * Timing 时序，但
    * -m
      * 指定运行ticks数
      * 从检查点恢复时有用
      * 相似的是-I，指定运行的指令数
* 创造自己的simObject
  * .py包装c文件方便参数传递啥的 .cc实现 .hh声明
    * 这个参数也就是在configs里写.py搭建系统时要赋值的参数（如果没赋值那就用default
  * **DEBUGGING**
  * 在相关目录下搞一个sconscript，里面声明DebugFlag('')，（同时object也是在此声明）
    * 在命令行里--debug-flags=`XX`（其中Exec是打印指令，可以head -n 50）
      * 就会显示出你在.c代码里写的DPRINTF(`XX`,......)
    * 直接 <.opt --debug-help> 可以查看帮助【直接.opt是另外一些参数的帮助】
    * .opt 【gem5参数（主要是指定输出以及debug啥的）】 .py 【py参数（addCommonOptions||py里addArgument）】
* GEM5 STDLIB
  * configs/example/gem5_lib下面有挺多示例
  * 包括三个基本组件：CPU MEM CACHE
  * 程序和镜像之类的东西从RESOURCES中获得
  * 使用标准库，类似于pytorch呗；不使用，那就是得实现一些小东西
  * 看x86FS那篇，还可以通过exit函数实现cpu的切换
  * 既然是库，那咱们肯定也可以继承一些东西来实现自己的玩意儿
