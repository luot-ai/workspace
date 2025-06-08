import re

def align64(addr_str):
    return hex(int(addr_str, 16) & ~0x3F)

def parse_trace_file(input_path, output_path, raw_output_path):
    with open(input_path, 'r') as f:
        lines = f.readlines()

    A = []  # 存储 (aligned_cacheline_addr, tick)
    B = []  # 用于流水线可视化
    C = []  # 某一wf的raw trace

    # 第一步：构建 A 列表
    pattern_fetch = re.compile(
        r'(?P<tick>\d+): CU(?P<cu>\d+): WF\[(?P<simd_id>\d+)\]\[(?P<wf_slot>\d+)\]: Id(?P<wf_id>\d+): Initiate fetch from pc: (?P<pc>\d+), tlb translation for cache line addr: (?P<addr>0x[0-9a-fA-F]+)'
    )

    for line in lines:
        m = pattern_fetch.match(line)
        if m:
            if m.group("simd_id") != "0" or m.group("wf_slot") != "0" or m.group("wf_id") != "1":
                continue  # 不符合 WF[0][0]:wave[1] 就跳过
            addr = m.group("addr").lower()
            tick = m.group("tick")
            #print(f"[✓] 处理地址: {addr} (tick: {tick})")
            A.append((addr, tick))

    # 第二步：匹配执行指令和阶段
    pattern_exec = re.compile(
        r'.*WF\[(?P<simd_id>\d+)\]\[(?P<wf_slot>\d+)\]: wave\[(?P<wf_id>\d+)\] Executing inst: (?P<assm>.+?) \(pc: (?P<pc>0x[0-9a-fA-F]+); seqNum: (?P<seqnum>\d+)\)'
    )

    stage_patterns = {
        'decode': re.compile(r'GPUView:decode:(\d+)'),
        'scb': re.compile(r'GPUView:scb:(\d+)'),
        'sch': re.compile(r'GPUView:sch:(\d+)'),
        'issue': re.compile(r'GPUView:issue:(\d+)'),
        'macc': re.compile(r'GPUView:macc:(\d+)'),
        'stlbReturn': re.compile(r'GPUView:stlbReturn:(\d+)'),
        'reqScache': re.compile(r'GPUView:reqScache:(\d+)'),
        'ScacheResp': re.compile(r'GPUView:ScacheResp:(\d+)'),
        'dtlbReturn': re.compile(r'GPUView:dtlbReturn: (\d+)'),
        'reqTcp': re.compile(r'GPUView:reqTcp: (\d+)'),
        'tcpResp': re.compile(r'GPUView:tcpResp: (\d+)'),
        'mc': re.compile(r'GPUView:mc:(\d+)'),
    }

    i = 0
    sn = 1
    while i < len(lines):
        line = lines[i]
        m = pattern_exec.search(line)
        if m:
            if m.group("simd_id") != "0" or m.group("wf_slot") != "0" or m.group("wf_id") != "1":
                i += 1
                continue  # 不符合 WF[0][0]:wave[1] 就跳过
            pc_raw = m.group("pc").lower()
            pc_aligned = align64(pc_raw)
            assm = m.group("assm")
            seqnum = m.group("seqnum")
            print(f"[✓] 处理指令: {assm} (pc: {pc_raw}, seqNum: {sn})")
            # 查找对应 tick
            fetchtick = next((tick for addr, tick in A if addr == pc_aligned), "0")
            # 提取阶段 tick
            decode = scb = sch = issue = macc = tlbR = reqCache = cacheResp = mc = "0"
            
            j = 0
            flag = 0
            while True:
                j += 1
                if i + j >= len(lines): break
                l = lines[i + j]
                ifSearch = 0
                # 将当前行进行匹配，如果 不是[macc -> mc]之间的某行 并且 没匹配上，则break
                for stage, pat in stage_patterns.items():
                    s = pat.search(l)
                    if s:
                        ifSearch = 1
                        if stage == 'decode': decode = s.group(1)
                        elif stage == 'scb': scb = s.group(1)
                        elif stage == 'sch': sch = s.group(1)
                        elif stage == 'issue': issue = s.group(1)
                        elif stage == 'macc': 
                            macc = s.group(1)
                            flag = 1
                        elif stage == 'stlbReturn': tlbR = s.group(1)
                        elif stage == 'reqScache': reqCache = s.group(1)
                        elif stage == 'ScacheResp': cacheResp = s.group(1)
                        elif stage == 'dtlbReturn': tlbR = s.group(1)
                        elif stage == 'reqTcp': reqCache = s.group(1)
                        elif stage == 'tcpResp': cacheResp = 0#cacheResp = s.group(1)
                        elif stage == 'mc': 
                            mc = s.group(1)
                            flag = 0
                if ifSearch == 0 and flag == 0:    
                    break
                        

            # 写入 B
            B.append(f"O3PipeView:fetch:{int(decode)-1000}:{pc_raw}:0:{seqnum}:{assm}")
            B.append(f"O3PipeView:decode:{decode}")
            B.append(f"O3PipeView:rename:{scb}")
            B.append(f"O3PipeView:dispatch:{sch}")
            B.append(f"O3PipeView:issue:{issue}")
            if (macc == "0"):
                B.append(f"O3PipeView:complete:{int(issue)+4000}")
                B.append(f"O3PipeView:retire:{int(issue)+5000}:store:0")
            else:
                B.append(f"O3PipeView:complete:{tlbR}")
                B.append(f"O3PipeView:retire:{reqCache}:store:{mc}")

            # 写入 C
            C.append(f"\nseqnum:{seqnum}")
            C.append(f"inst:{assm}")
            C.append(f"fetchStart:{fetchtick},pc:{pc_raw}")
            C.append(f"fetch:{str(int(decode)-int(fetchtick))[:-3]}")
            C.append(f"decode:{str(int(scb)-int(decode))[:-3]}")
            C.append(f"scb:{str(int(sch)-int(scb))[:-3]}")
            C.append(f"sch:{str(int(issue)-int(sch))[:-3]}")
            if (macc == "0"):
                C.append(f"issue:{4}")
            else:
                C.append(f"issue:{str(int(macc)-int(issue))[:-3]}")
                C.append(f"tlbacc:{str(int(tlbR)-int(macc))[:-3]}")
                C.append(f"reqCache:{str(int(cacheResp)-int(tlbR))[:-3]}")

            i += j
            sn+=1
        else:
            i += 1

    with open(output_path, 'w') as f:
        f.write("\n".join(B))
        print(f"[✓] 输出已写入: {output_path}")

    with open(raw_output_path, 'w') as f:
        f.write("\n".join(C))
        print(f"[✓] 原始输出已写入: {raw_output_path}")
    print(sn)

# 示例用法：
parse_trace_file("traceV3", "trace.out", "trace.raw")


# * 正则项1：{tick}:CU1: WF[0][0]: Id1: Initiate fetch from pc: { }, tlb translation for cache line addr: {cache line addr}
#   * 遇到这个正则项（注意，确保这里的几个数字要对应上CU1: WF[0][0]: Id1）
#   * 新建一个多元组，记录cache line addr作为元素1,tick作为元素2
#   * 这个多元组插入列表A
# * 正则项2： WF[0][0]:wave[1] Executinginst:{指令汇编} (pc:{pc}; seqNum:{seqnum})
#   * 对如此匹配的每一行（WF[0][0]:wave[1]要对应上）
#   * 进行拆解得到一个多元组elm：pc 指令汇编assm seqnum
#   * 匹配上之后，根据pc【记得弄成64bytes对齐】去列表1中找到对应的line addr，提取元素2tick作为elm的一个元素fetchtick
#   * 然后这个匹配行的下面五行是五个阶段fetch decode rename dispatch issue
#     * fetch可以忽略
#     * 另外四个阶段的tick分别提取到elm中
#   * 多元组加入列表B
# * 列表B每一个元素写入output file，格式
#   * O3PipeView:fetch:{fetchtick}:{pc}:0:{seqnum}:{assm}
#   * O3PipeView:decode:{decodetick}
#     O3PipeView:rename:{renametick}
#     O3PipeView:dispatch:{dispatchtick}
#     O3PipeView:issue:{retiretick}
#     O3PipeView:retire:0:store:0