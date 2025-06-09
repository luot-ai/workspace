import re

def align64(addr_str):
    return hex(int(addr_str, 16) & ~0x3F)

def parse_trace_file(input_path, output_path, raw_output_path):
    with open(input_path, 'r') as f:
        lines = f.readlines()

    A = []  
    B = []  
    C = []  

    # 第一步：构建 取指信息列表
    pattern_fetch = re.compile(
        r'(?P<tick>\d+): CU(?P<cu>\d+): WF\[(?P<simd_id>\d+)\]\[(?P<wf_slot>\d+)\]: Id(?P<wf_id>\d+): Initiate fetch from pc: (?P<pc>\d+), tlb translation for cache line addr: (?P<addr>0x[0-9a-fA-F]+)'
    )

    for line in lines:
        m = pattern_fetch.match(line)
        if m:
            if m.group("simd_id") != "0" or m.group("wf_slot") != "0" or m.group("wf_id") != "1": #匹配特定wave
                continue  
            addr = m.group("addr").lower()
            tick = m.group("tick")
            A.append((addr, tick))

    # 第二步：匹配 执行指令和阶段
    pattern_exec = re.compile(
        r'.*WF\[(?P<simd_id>\d+)\]\[(?P<wf_slot>\d+)\]: wave\[(?P<wf_id>\d+)\] Executing inst: (?P<assm>.+?) \(pc: (?P<pc>0x[0-9a-fA-F]+); seqNum: (?P<seqnum>\d+)\)'
    )

    # example: x is actually the cycle of requesting cache
    #     tlbReturn:0,schedule cache req after x cycle
    #     reqCache:x
    #     cacheResp:x
    #     mc:x+1
    stage_patterns = {
        'decode': (re.compile(r'GPUView:decode:(\d+)'), 'decode'),
        'scb': (re.compile(r'GPUView:scb:(\d+)'), 'scb'),
        'sch': (re.compile(r'GPUView:sch:(\d+)'), 'sch'),
        'issue': (re.compile(r'GPUView:issue:(\d+)'), 'issue'),
        'macc': (re.compile(r'GPUView:macc:(\d+)'), 'macc'),
        'mc': (re.compile(r'GPUView:mc:(\d+)'), 'mc'),
        # Scalar Cache
        'stlbReturn': (re.compile(r'GPUView:stlbReturn:(\d+)'), 'tlbR'),
        'reqScache': (re.compile(r'GPUView:reqScache:(\d+)'), 'reqCache'),
        'ScacheResp': (re.compile(r'GPUView:ScacheResp:(\d+)'), 'cacheResp'),
        # TCP
        'dtlbReturn': (re.compile(r'GPUView:dtlbReturn: (\d+)'), 'tlbR'),
        'reqTcp': (re.compile(r'GPUView:reqTcp: (\d+)'), 'reqCache'),
        'tcpResp': (re.compile(r'GPUView:tcpResp: (\d+)'), 'cacheResp'),
    }

    i = 0
    sn = 1 
    while i < len(lines):
        line = lines[i]
        m = pattern_exec.search(line)
        if m:
            if m.group("simd_id") != "0" or m.group("wf_slot") != "0" or m.group("wf_id") != "1": # 匹配特定wave
                i += 1
                continue  
            # 1:查找对应 fetchTick
            pc_raw = m.group("pc").lower()
            pc_aligned = align64(pc_raw)
            assm = m.group("assm")
            seqnum = m.group("seqnum")
            fetchtick = next((tick for addr, tick in A if addr == pc_aligned), "0") 
            # 2:提取各流水级tick
            variables = {'decode': '0', 'scb': '0', 'sch': '0', 'issue': '0', 'macc': '0', 'mc': '0', 'tlbR': '0', 'reqCache': '0', 'cacheResp': '0'}
            j = 0
            flag = 0
            while True: # 匹配接下来的若干行
                j += 1
                if i + j >= len(lines): break
                l = lines[i + j]
                ifSearch = 0
                for stage, (pattern, var_name) in stage_patterns.items(): # 将当前行 与 某流水级正则项匹配
                    match = pattern.search(l)
                    if match:
                        ifSearch = 1
                        variables[var_name] = match.group(1)
                        if stage == 'macc': flag = 1
                        elif stage == 'mc': flag = 0
                if not ifSearch and not flag: #在macc和mc之间可能会有未匹配的行，允许跳过TODO
                    break
            decode, scb, sch, issue, macc, mc, tlbR, reqCache, cacheResp = (
                variables['decode'], variables['scb'], variables['sch'], variables['issue'],
                variables['macc'], variables['mc'], variables['tlbR'], variables['reqCache'], variables['cacheResp']
            )
            scb = str(int(decode)+1000)
            # 3:pipeView
            B.extend([
                f"O3PipeView:fetch:{int(decode)-1000}:{pc_raw}:0:{seqnum}:{assm}", #取指可以换成fetchTick
                *[f"O3PipeView:{stage}:{value}" for stage, value in [
                    ("decode", decode),
                    ("rename", scb),
                    ("dispatch", sch),
                    ("issue", issue)
                ]]
            ])
            if macc == "0":
                B.extend([
                    f"O3PipeView:complete:{int(issue)+4000}", #计算指令4cycle
                    f"O3PipeView:retire:{int(issue)+5000}:store:0" #TODO
                ])
            else:
                B.extend([
                    f"O3PipeView:complete:{tlbR[:-3]+'000'}", # issue+tlb访问 = {tlbR-issue} ---可视化---> is阶段 = {complete-issue}
                    f"O3PipeView:retire:{int(mc)-1000}:store:{mc}" # cache访问 = {cacheResp[:-3]+'000'-tlbR} ---可视化---> cm阶段 = {retire-complete}
                ])
            # 4:trace analysis
            C.extend([
                f"\nseqnum:{seqnum}",
                f"inst:{assm}",
                f"fetchStart:{fetchtick},pc:{pc_raw}",
                *[f"{stage}:{str(int(end) - int(start))[:-3]}" for stage, start, end in [
                    ("fetch", fetchtick, decode),
                    ("decode", decode, scb),
                    ("scb", scb, sch),
                    ("sch", sch, issue)
                ]]
            ])
            if macc == "0":
                C.append("issue:4")
            else:
                C.extend([
                    f"issue:{str(int(macc) - int(issue))[:-3]}",
                    f"tlbacc:{str(int(tlbR) - int(macc))[:-3]}",
                    f"reqCache:{str(int(cacheResp) - int(tlbR))[:-3]}"
                ])

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

# 示例用法：/home/intern/luot/gem5/trace_square_pipe/trace
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