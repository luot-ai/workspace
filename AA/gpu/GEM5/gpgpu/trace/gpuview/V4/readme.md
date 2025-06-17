* TODO:代码详细说明
* /input：包含gem5生成的trace
* /stage1：
  * parser.py：使用input/trace 生成traceout traceraw，支持tick压缩
  * traceout：某WF各指令 各流水级发生tick
  * traceraw：某WF各指令 各流水级占用ticks
* /stage2:
  * trace_to_kanata.py：使用stage1/traceout 生成 final.out，支持自定义流水级名称
  * final.out：原生kanata trace格式，使用konata打开即可可视化