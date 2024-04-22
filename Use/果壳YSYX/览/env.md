<!--
 * @Author: lt 1035768203@qq.com
 * @Date: 2023-10-17 21:37:08
 * @LastEditors: lt 1035768203@qq.com
 * @LastEditTime: 2023-11-03 20:07:03
 * @FilePath: \undefinedc:\Users\86177\Desktop\工作台.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->

# 1.linux

**YSYX 和 Nutshell 的 NEMU 现在得用2个环境变量**
ysyx下有独立的nemu啥的，就在下面整ysyx    ~下有NEMU，设置一下就可以跑NUTSHELL仿真：

记录下果壳的问题：
1.mill安装按教程中说的manual安装来(不过其实原来那样也只是导致命令不同)
2.更新子仓库
3.verilator make的时候可以-j

4.先 **make** 得到sim_top.v----->作为依赖，送入difftest中去 **make emu**，得到emu，emu是一个可执行文件，和cpu有关
**具体得看difftest的makefile了，可能就是包装一下吧**

5.查看emu --help知道得放一个.bin作为映像文件输入
6.查看nemu的教程知道怎么配出来一个正确的so文件：make xxconfig,make

总结就是CPU+DIFF=EMU，程序=BIN，NEMU=动态链接库，三者合并跑仿真

# record

1. /home/lt7203610626/.cache/mill/download/0.11.2: 48: exec: /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java/bin/java: not found
   1. 莫名其妙，改了脚本里JAVACMD="$JAVA_HOME"（原来多了个/bin/java）
2. 先 git submodule init,再git submodule update --recursive
3. 源码有问题就是网络有问题
