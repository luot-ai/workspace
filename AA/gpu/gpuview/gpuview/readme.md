sch和exe都是唯一
scb和decode不是唯一，可能会对应错误执行的指令，所以通过唯一的sch和exe确定
	decode原本没有seq，但是是可以加seq的
【B：还得再看看想想为什么scb也会有错误的->分析branchIB】



√先用trace搞，测试konata的接口
再用dprintf，好处是不用管时间(法1确实很大)
然后才是各个simd的，这个可能下周再说




目前是按照仿照o3的方法
【A：还得细究一下cycle->分析SCBSCH sch何时pop】
	【3√：写另一个debugFlag，用于分析停顿原因】
1.取指目前只有pc们，还得想想【2√】
2.译码需要改源码，输出seqnum【1√√】
3.rn就是scb
4.sch就是dispatch
5.issue就是执行
6.cm就当做是影响到其他【4这个访存相关，所以后续还要再弄】












阅读input：
①
正则项1匹配到的每一行，例如
10867111705000: system.Shader.CUs01.ScoreboardCheckStage: Adding to readyList[7]: SIMD[0] WV[1]: 1: s_load_dwordx4 s[4:7], s[0:1], 0x00
进行拆解得到一个六元组元素：scb_tick(最左侧数字提取)+指令序号(最右侧冒号左边的那个1)+指令名字（字符串，最右侧冒号右边）+ sch_tick(先不填) + exe_tick(先不填)+print(bool型，置为false)
每一个匹配行对应一个元素，所有匹配行对应一个列表A

②
正则项2匹配到的每一行，例如
10867111775000: system.Shader.CUs01.ScheduleStage: schList[4]: Adding: SIMD[0] WV[1]: 7: s_waitcnt lgkmcnt(0)
根据指令seqnum去列表A中看有没有一致的，如果没有报错！
如果有，就根据这里最左侧数字填写sch_tick,print置为true

③
正则项3匹配到的每一行，例如
6190: system.Shader.CUs01.wavefronts00: CU1: WF[0][0]: wave[1] Executing inst: s_endpgm (pc: 0x7fd1b6c062ec; seqNum: 831)
根据指令seqnum去列表A中看有没有一致的，如果没有报错！
如果有，就根据这里最左侧数字填写exe_tick,print置为true

最后，将列表A中所有print=true的元素，打印一下


