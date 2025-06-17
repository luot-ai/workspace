# TODO

* 程序控制流
* 访存
* 可视化
* 总线
* 总梳理

- 本周完成：
  - 程序控制流
  - 访存 总结图

## 程序控制流

* [ ] 中间代码生成
* [ ] Branch Divergence
* [ ] waitCnt指令

---

## 访存
* [ ] 总结：图
* [ ] LDS
* Pending
  * [ ] systemReq
  * [ ] 白皮书：cache响应拍数
  * [ ] 白皮书/分支：寄存器读写冲突【canscheduleRead/Write】
  * [ ] 访存资源相关：memPipe->exec下面的bus和unit占用都只是一周期

---

## 可视化

* [ ] waitcnt指令有问题
* [ ] 多线程
* Pending
  * [ ] 写另一个debugFlag，用于分析停顿原因
  * [ ] 支持miss指令
  * [ ] 取指：目前是匹配decodetick之前最近的fetchtick，不一定对
  * [X] 目前tcpReq使用dtlbReturn正则匹配，所以tcpReq的时间 = 50+访存堵塞的拍数（可能发送端和接收端都有）