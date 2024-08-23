# 资料

* rocc.pdf在yjs
* 源码两份在0arch，chipyard在ubuntu

  * rocc_example里有**测试用的样例**，pk和汇编
  * chipyard中有详细的文档docs
    * tests下make可得**测试样例**
  * chipyard和原始的rocket代码似乎不太一样
* csdn两份教程

  * 一份比较全，也有**测试样例**甚至还debug了accumlator
  * 一份是在chipyard上整的，有重要信息，而且也有测试样例
* github上的教程

  * chipyard
  * deca也可以参考

# 问题

* 模拟
* csr的问题

# 先放下

* ccache先暂时放下，因为会占用大量内存

  * docker下怎么用ccache还得研究
* docker的sshfs直连也先放下
* chipyard相关的暂时放下：

  * 服务器上手工+docker chipyard，有余力可以探索deca
  * 下次仿真查查chipyard文档，如何指示fst文件:应该修改下waveformFLAG就行
  * 波形图结合tesharness-haslzayrocc结合V文件
  * csr pk
  * chipyard文档
  * boom-rocc
