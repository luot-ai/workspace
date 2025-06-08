04: global: WF[0][0]: Id1 decoded s_load_dwordx4 s[4:7], s[0:1], 0x00 (8 bytes). 56 bytes remain.
04: global: WF[0][0]: Id1 decoded s_load_dwordx4 s[8:11], s[0:1], 0x10 (8 bytes). 48 bytes remain.
04: global: WF[0][0]: Id1 decoded s_load_dwordx4 s[12:15], s[0:1], 0x20 (8 bytes). 40 bytes remain.
04: global: WF[0][0]: Id1 decoded s_load_dwordx4 s[16:19], s[0:1], 0x30 (8 bytes). 32 bytes remain.
04: global: WF[0][0]: Id1 decoded s_load_dwordx4 s[20:23], s[0:1], 0x40 (8 bytes). 24 bytes remain.
04: global: WF[0][0]: Id1 decoded s_load_dword s24, s[0:1], 0x50 (8 bytes). 16 bytes remain.
WfdynId

05: sys.Shader.CUs01.ScoreboardCheckStage: CU1: WF[0][0]: Checking Ready for Inst : s_load_dwordx4 s[4:7], s[0:1], 0x00
05: sys.Shader.CUs01.ScoreboardCheckStage: CU1: WF[0][0]: Ready Inst : s_load_dwordx4 s[4:7], s[0:1], 0x00
05: sys.Shader.CUs01.ScoreboardCheckStage: Adding to readyList[7]: SIMD[0] WV[1]: 1: s_load_dwordx4 s[4:7], s[0:1], 0x00
05: sys.Shader.CUs01.ScoreboardCheckStage: CU1: WF[1][0]: Checking Ready for Inst : s_load_dwordx4 s[4:7], s[0:1], 0x00
05: sys.Shader.CUs01.ScoreboardCheckStage: CU1: WF[1][0]: Ready Inst : s_load_dwordx4 s[4:7], s[0:1], 0x00
05: sys.Shader.CUs01.ScoreboardCheckStage: Adding to readyList[7]: SIMD[1] WV[41]: 10: s_load_dwordx4 s[4:7], s[0:1], 0x00
05: sys.Shader.CUs01.ScoreboardCheckStage: CU1: WF[2][0]: Checking Ready for Inst : s_load_dwordx4 s[4:7], s[0:1], 0x00
05: sys.Shader.CUs01.ScoreboardCheckStage: CU1: WF[2][0]: Ready Inst : s_load_dwordx4 s[4:7], s[0:1], 0x00
05: sys.Shader.CUs01.ScoreboardCheckStage: Adding to readyList[7]: SIMD[2] WV[81]: 19: s_load_dwordx4 s[4:7], s[0:1], 0x00
05: sys.Shader.CUs01.ScoreboardCheckStage: CU1: WF[3][0]: Checking Ready for Inst : s_load_dwordx4 s[4:7], s[0:1], 0x00
05: sys.Shader.CUs01.ScoreboardCheckStage: CU1: WF[3][0]: Ready Inst : s_load_dwordx4 s[4:7], s[0:1], 0x00
05: sys.Shader.CUs01.ScoreboardCheckStage: Adding to readyList[7]: SIMD[3] WV[121]: 28: s_load_dwordx4 s[4:7], s[0:1], 0x00


06: sys.Shader.CUs01.ScheduleStage: schList[7]: Adding: SIMD[0] WV[1]: 1: s_load_dwordx4 s[4:7], s[0:1], 0x00
06: sys.Shader.CUs01.ScheduleStage: schList[7]: Added: SIMD[0] WV[1]: 1: s_load_dwordx4 s[4:7], s[0:1], 0x00
06: sys.Shader.CUs01.ScheduleStage: schList[7]: WV[1] operands ready for: 1: s_load_dwordx4 s[4:7], s[0:1], 0x00 
06: sys.Shader.CUs01.ScheduleStage: schList[7]: WV[1] RFBUSY->RFREADY
06: sys.Shader.CUs01.ScheduleStage: dispatchList[7]: fillDispatchList: EMPTY->EXREADY
06: sys.Shader.CUs01.ScheduleStage: dispatchList[7]: SIMD[0] WV[1]: 1: s_load_dwordx4 s[4:7], s[0:1], 0x00    Reserving ExeRes[ 7 ]
dyn_inst_id
一次只checkRfOperandReadComplete/filldispatch一条
filldispatch最多只有一条指令
reserve：取的是IB第一条指令，execUnitIds.push_back(execUnitId);根据指令类型设置需要reserve的资源，可能是多个



然后ExecStage::exec()

先dumpDispList

sys.Shader.CUs01.ExecStage: Dispatch List:
0: EMPTY
1: EMPTY
2: EMPTY
3: EMPTY
4: EMPTY
5: EMPTY
6: EMPTY
7: EXREADY SIMD[0] WV[1]: 1: s_load_dwordx4 s[4:7], s[0:1], 0x00



07: sys.Shader.CUs01.ExecStage: Exec[7]: SIMD[0] WV[1]: s_load_dwordx4 s[4:7], s[0:1], 0x00
07: sys.Shader.CUs01.ExecStage: dispatchList[7] EXREADY->EMPTY
然后Wavefront::exec()执行,同样是取IB队头指令：
07: sys.Shader.CUs01.wavefronts00: CU1: WF[0][0]: wave[1] Executing inst: s_load_dwordx4 s[4:7], s[0:1], 0x00 (pc: 0x7fd1b6c06100; seqNum: 1)
然后是GPUDynInst::execute(GPUDynInstPtr gpuDynInst)，execute(GPUDynInstPtr gpuDynInst) override
然后是Inst_SMEM__S_LOAD_DWORDX4::execute
operand.read->srf.printReg
07: global: Read s[0]
07: sys.Shader.CUs01.scalar_register_file0: WF[0][0]: Id1 s[0] = 0xb6c08000
07: global: Read s[1]
07: sys.Shader.CUs01.scalar_register_file0: WF[0][0]: Id1 s[1] = 0x7fd1
这里已经来到wf:exec的末尾
07: sys.Shader.CUs01.wavefronts00: CU1: WF[0][0]: wave[1] (pc: 0x7fd1b6c06108)
    // --- description from .arch file ---
    // Read 4 dwords from scalar data cache. See S_LOAD_DWORD for details on
    // the offset input.
    void
    Inst_SMEM__S_LOAD_DWORDX4::execute(GPUDynInstPtr gpuDynInst)
    {
        Wavefront *wf = gpuDynInst->wavefront();
        gpuDynInst->execUnitId = wf->execUnitId;
        gpuDynInst->latency.init(gpuDynInst->computeUnit());
        gpuDynInst->latency.set(gpuDynInst->computeUnit()->clockPeriod());
        ScalarRegU32 offset(0);
        ConstScalarOperandU64 addr(gpuDynInst, instData.SBASE << 1);

        addr.read();

        if (instData.IMM) {
            offset = extData.OFFSET;
        } else {
            ConstScalarOperandU32 off_sgpr(gpuDynInst, extData.OFFSET);
            off_sgpr.read();
            offset = off_sgpr.rawData();
        }

        calcAddr(gpuDynInst, addr, offset);

        gpuDynInst->computeUnit()->scalarMemoryPipe.
            issueRequest(gpuDynInst);
    } // execute
这个execute函数会把这令指令推到全局的FIFO的issuedRequests


下一个周期ScalarMemPipeline::exec()
会调用issuedRequests里第一条指令的mp->initiateAcc(mp);【要确保inflightLoads<=p.scalar_mem_queue_size】
08: global: CU1: WF[0][0]: mempacket status bitvector=1111111111111111111111111111111111111111111111111111111111111111
initiateAcc->initMemRead->initMemReqScalarHelper
    得到请求size：4个ScalarRegU32数
    检查是否cacheline对齐
    封装request：虚地址+size+wfDynId
    封装pkt：req+mem_req_type
调用ComputeUnit::sendScalarRequest
scalarDTLBPort.sendTimingReq
08: sys.scalar_coalescer0: mustStallCUPort: downstream = 0, max = 64
08: sys.scalar_coalescer0-port1: receiving pkt w/ req_cnt 1
08: sys.scalar_coalescer0-port1: coalescerFIFO[10867111708000] now has 1 coalesced reqs after push
08: sys.Shader.CUs01: sent scalar read translation request for addr 0x7fd1b6c08000：先发起tlb请求（从initiateAcc一路点过来）
initiateAcc(mp)执行结束issuedRequests.pop();
08: sys.Shader.CUs01.ScalarMemPipeline: CU1: WF[0][0] Popping scalar mem_op


58: sys.l2_coalescer: triggered VegaTLBCoalescer processProbeTLBEvent
58: sys.l2_coalescer: coalescedReq_cnt is 1 for tick_index 10867111709000
58: sys.l2_tlb: Translation req. for virt. page addr 0x7fd1b6c08000
58: sys.l2_tlb: TLB Lookup for vaddr 0x7fd1b6c08000.
58: sys.l2_tlb: Matched vaddr 0x7fd1b6c08000 to entry starting at 0x7fd1b6c08000 with size 0x1000.
58: sys.l2_tlb: Matched vaddr 0x7fd1b6c08000 to entry starting at 0x7fd1b6c08000 with size 0x1000.
58: sys.l2_tlb: schedule translationReturnEvent @ curTick 10867113027001
58: sys.l2_coalescer: sys.l2_coalescer sending pkt w/ req_cnt 2
58: sys.l2_coalescer: Successfully sent TLB request for page 0x7fd1b6c08000
58: sys.l2_coalescer: coalescedReq_cnt is 1 for tick_index 10867111710000
58: sys.l2_coalescer: Cannot issue - There are pending reqs for page 0x7fd1b6c08000
58: sys.l2_coalescer: coalescedReq_cnt is 1 for tick_index 10867111712000
58: sys.l2_coalescer: Cannot issue - There are pending reqs for page 0x7fd1b6c08000
58: sys.l2_coalescer: coalescedReq_cnt is 1 for tick_index 10867111713000
58: sys.l2_coalescer: Cannot issue - There are pending reqs for page 0x7fd1b6c08000
58: sys.l2_coalescer: coalescedReq_cnt is 1 for tick_index 10867111714000
58: sys.l2_coalescer: Cannot issue - There are pending reqs for page 0x7fd1b6c08000
58: sys.l2_coalescer: coalescedReq_cnt is 1 for tick_index 10867111716000
58: sys.l2_coalescer: Cannot issue - There are pending reqs for page 0x7fd1b6c08000
58: sys.l2_coalescer: coalescedReq_cnt is 1 for tick_index 10867111717000
58: sys.l2_coalescer: Cannot issue - There are pending reqs for page 0x7fd1b6c08000
58: sys.l2_coalescer: coalescedReq_cnt is 1 for tick_index 10867111718000
58: sys.l2_coalescer: Cannot issue - There are pending reqs for page 0x7fd1b6c08000
58: sys.l2_coalescer: coalescedReq_cnt is 1 for tick_index 10867111720000
58: sys.l2_coalescer: Cannot issue - There are pending reqs for page 0x7fd1b6c08000
58: sys.scalar_tlb0: Triggered TLBEvent for addr 0x7fd1b6c08000
58: sys.scalar_tlb0: Translation Done - TLB Miss for addr 0x7fd1b6c08000
58: sys.scalar_tlb0: allocating entry w/ addr 0x7fd1b6c08000 of size 0x1000
58: sys.scalar_tlb0: Inserted 0x7fd1b6c08000 -> 0x130a3d000 of size 0x1000 into set 0
58: sys.scalar_tlb0: Entry found with vaddr 0x7fd1b6c08000,  doing protection checks while paddr was 0x130a3d000.
58: sys.scalar_tlb0: Translated 0x7fd1b6c08000 -> 0x130a3d000.
58: sys.scalar_coalescer0: Update phys. addr. for 3 coalesced reqs for page 0x7fd1b6c08000


这个是ComputeUnit::ScalarDTLBPort::recvTimingResp(PacketPtr pkt)
58: sys.Shader.CUs01-port: CU1: WF[0][0][wv=0]: scalar DTLB port received translation: PA 0x7fd1b6c08000 -> 0x130a3d000
58: sys.Shader.CUs02-port: CU2: WF[0][0][wv=0]: scalar DTLB port received translation: PA 0x7fd1b6c08000 -> 0x130a3d000
58: sys.Shader.CUs03-port: CU3: WF[0][0][wv=0]: scalar DTLB port received translation: PA 0x7fd1b6c08000 -> 0x130a3d000
58: sys.scalar_coalescer0-port0: recvTimingReq: clscr = 0x55bcc1fb7800, numDownstream = 0, max = 64
58: sys.scalar_tlb0: Scheduled 0x7fd1b6c08000 for cleanup
58: sys.scalar_tlb0: Deleting return event for 0x7fd1b6c08000
58: sys.scalar_coalescer0: Cleanup - Delete coalescer entry with key 0x7fd1b6c08000

1708发送tlb请求->2958得到响应


1086711 2958001

2958
3009
中间的因为是memruby，所以看不到了

ComputeUnit::ScalarDataPort::recvTimingResp(PacketPtr pkt)
{
    return handleResponse(pkt);
}
bool
ComputeUnit::ScalarDataPort::handleResponse(PacketPtr pkt)
会把请求东西放入returnLoads中


->3009：ScalarMemPipeline::exec()
        说明是什么东西放入returnLoads中了
    GPUDynInstPtr m = !returnedLoads.empty() ? returnedLoads.front() :
        !returnedStores.empty() ? returnedStores.front() : nullptr;



completeAcc
dyn
10867113009000: global: CU1: WF[0][0]: mempacket status bitvector=1111111111111111111111111111111111111111111111111111111111111111 complete
_staticInst->completeAcc
1086711 3009000: global: Write s[4]
10867113009000: system.Shader.CUs01.scalar_register_file0: WF[0][0]: Id1 s[4] = 0xb6c18000
10867113009000: global: Write s[5]
10867113009000: system.Shader.CUs01.scalar_register_file0: WF[0][0]: Id1 s[5] = 0x7fd1
10867113009000: global: Write s[6]
10867113009000: system.Shader.CUs01.scalar_register_file0: WF[0][0]: Id1 s[6] = 0xb6c1c000
10867113009000: global: Write s[7]
10867113009000: system.Shader.CUs01.scalar_register_file0: WF[0][0]: Id1 s[7] = 0x7fd1
82: global: sys.ruby.tcp_cntrl0.coalescer checking remaining pkts for 186
82: global: Returning token seqNum 186



