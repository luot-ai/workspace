# record

1. 编写脚本(来自网站)
   1. configs/dknet.py负责声明配置,参数
   2. /run_darknet.sh方便路径的设定,以及一些小参数(例如-I，最大指令数)
      1. 在里头会进入到run_dir，所以执行程序在该目录下即可
      2. 会指定gem5.opt的路径
      3. 输出在run_dir下的output中
      4. 命令行中还是会有一些用于【darknet】的参数，但没关系
   3. 切换到gem5/scripts下./run_darknet.sh xxx【xxx得在darknet下】
      1. xxx可以是darknet main，前者是跑 `大程序`，后者就是咱们自己写的 `demo`
2. 修改makefile
   1. 原脚本中既有动态库，又有静态库
   2. 使用静态库，编译选项加上-static
   3. 静态库中只有用到的算子.o文件会被链接，这就是静态库的意义
      1. exeobj就是相当于main函数，可以改成自己需要的就行
      2. exeobj 在EXEC=darknet时会是原脚本中的一堆，否则为指定程序xx.o
         1. make时指定EXEC，否则默认为main
3. 合并winograd后的脚本
   1. darknet中的makefile新增 条件变量 REF
      1. 编译变量COMMON新增 convoFlavor -I.h【.h搜索路径】
      2. VPATH大坑，增加相关.c路径
      3. OBJ增加自己需要的文件，这些文件会一起被ar进入.a库
      4. DEPS是要被当做依赖项的.h文件
      5. **必须得注意同名文件，否则会出现只包含先出现的那个的情况**
   2. gem5/scrpits中有main.sh
      1. ./main.sh xxx   xxx默认为main
      2. 进入darknet中编译xxx，反汇编入./obj/important
      3. 回到本目录，执行./run xxx
4. 开始深入汇编
   1. m5_dump_reset_stats
      1. .c文件中include头文件，在需要的地方加入m5_dump_reset_stats
      2. makefile中COMMON加入-I，LDFLAGS加入相应库的路径-Lxxx -lm5
      3. 效果就是stat会被切分
