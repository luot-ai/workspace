* [ ] 访存：

  * [ ] systemReq
  * [X] 目前tcpReq使用dtlbReturn正则匹配，这样子tcpReq的时间包括50+访存堵塞的拍数（可能发送端和接收端都有）
  * [ ] 白皮书：cache响应拍数
  * [ ] 白皮书/分支：寄存器读写冲突【canscheduleRead/Write】
  * [ ] 访存资源相关：memPipe->exec下面的bus和unit占用都只是一周期

---

MustTodo

* [X] trace清晰

  * [X] 名称
  * [X] tick压缩
  * [X] 压缩时间 cacheacc 和 writethrough在图上显示会比较宽
* [X] 访存：目前已完成多拍打印
* [ ] divergence
* [ ] 取指：目前是匹配decodetick之前最近的fetchtick，不一定对
* [ ] waitcnt指令有问题
* [ ] 联通梳理

---

TODO

* [ ] 或许可以写写另一个debugFlag，用于分析停顿原因（下周）
* [ ] 支持miss指令（下周）
* [ ] 各simd（下周）
