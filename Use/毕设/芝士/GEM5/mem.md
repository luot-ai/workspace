# 基础知识

* /** Pointer to the data for the memory access. */*

  * uint8_t*  memData=nullptr;
  * 来自dyn_inst，还有个effsize，所以返回的数据是一个以字节为单位的数组
* 来自completeAcc

  * memcpy(Mem.as<uint8_t>(), pkt->getPtr<uint8_t>(), pkt->getSize());
  * 即将读取的数据按字节copy到Mem那
