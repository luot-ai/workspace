# Q

1. 如果从卷积类入手，那么扩展指令仅作为粗粒度的调控方式（配置、开启）什么的？
   1. 此外，感觉问题会转移到一个 比较大的计算单元 的设计（因为大部分卷积都比较规律），那么资源是否需要有什么限制
      1. 相关论文设计中PE往往和`输入`的尺寸有关
2. 如果是从卷积累入手，感觉不可避免地需要大一些的规模，单纯在流水线上改感觉加速的效果不会特别好
   1. 还是说只要有效果就行？但是卷积本身也不适合在流水线上做

## 想法

1. 探索在较小PE数量下，如何高效计算？
2. 不过分追求加速性能？考虑扩展指令带来的可编程性
3. 还得继续看看应用，可形变卷积似乎不太规则，说不定在流水线上可以做做
4. 或者关注卷积网络中的一些结构：skip_connect之类的
