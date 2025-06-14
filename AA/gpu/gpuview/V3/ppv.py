import re

def format_stage_string(prev_stage, time, ori_time, enlarged):
    if enlarged:
        return f"{prev_stage}:{time} (原{ori_time})"
    else:
        return f"{prev_stage}:{time}"

def align64(addr_str):
    return hex(int(addr_str, 16) & ~0x3F)

def parse_trace_file(input_path, output_path, raw_output_path):
    with open(input_path, 'r') as f:
        lines = f.readlines()

    A = []  
    B = []  
    C = []  
    WFID = "1"
    # 第一步：构建 取指信息列表
    pattern_fetch = re.compile(
        r'(?P<tick>\d+): CU(?P<cu>\d+): WF\[(?P<simd_id>\d+)\]\[(?P<wf_slot>\d+)\]: Id(?P<wf_id>\d+): Initiate fetch from pc: (?P<pc>\d+), tlb translation for cache line addr: (?P<addr>0x[0-9a-fA-F]+)'
    )

    for line in lines:
        m = pattern_fetch.match(line)
        if m:
            if m.group("wf_id") != WFID: #匹配特定wave
                continue  
            addr = m.group("addr").lower()
            tick = int(m.group("tick"))//1000
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
        'tlbReq': (re.compile(r'GPUView:macc:(\d+)'), 'tlbReq'),
        'sCacheReq': (re.compile(r'GPUView:stlbReturn:(\d+)'), 'sCacheReq'),
        'sCacheResp': (re.compile(r'GPUView:ScacheResp:(\d+)'), 'sCacheResp'),
        # 'dtlbReturn': (re.compile(r'GPUView:dtlbReturn:(\d+)'), 'dtlbReturn'),
        'tcpReq': (re.compile(r'GPUView:dtlbReturn:(\d+):([0-9a-fA-FxX]+)'), 'tcpReq'),
        'tcpResp': (re.compile(r'GPUView:tcpResp:(\d+):([0-9a-fA-FxX]+)'), 'tcpResp'),
        'tcpRespSt': (re.compile(r'GPUView:tcpRespStore:(\d+):([0-9a-fA-FxX]+)'), 'tcpRespSt'),
        'mc': (re.compile(r'GPUView:mc:(\d+)'), 'mc'),
    }

    instruction_info ={}
    i = 0
    sn = 1 
    while i < len(lines):
        line = lines[i]
        m = pattern_exec.search(line)
        if m:
            if m.group("wf_id") != WFID: # 匹配特定wave
                i += 1
                continue  
            # 1:查找对应 fetchTick
            pc_raw = m.group("pc").lower()
            pc_aligned = align64(pc_raw)
            assm = m.group("assm")
            seqnum = m.group("seqnum")
            fetchtick = next((tick for addr, tick in A if addr == pc_aligned), 0) 
            # 2:提取各流水级tick
            variables = {
                'decode': 0, 
                'scb': 0, 
                'sch': 0, 
                'issue': 0, 
                'tlbReq': 0, 
                'sCacheReq': 0,
                'sCacheResp': 0,
                'dtlbReturn': 0,
                'tcpAcc': {},
                'mc': 0
            }
            j = 0
            flag = 0
            ifTcp = 0
            ifTcpSt = 0
            while True: # 匹配接下来的若干行
                j += 1
                if i + j >= len(lines): break
                l = lines[i + j]
                ifSearch = 0
                for stage, (pattern, var_name) in stage_patterns.items(): # 将当前行 与 某流水级正则项匹配
                    match = pattern.search(l)
                    if match:
                        ifSearch = 1
                        if var_name in ['tcpReq', 'tcpResp', 'tcpRespSt']:
                            ifTcp = 1
                            if var_name == 'tcpRespSt':
                                ifTcpSt = 1
                            tick = int(match.group(1)) // 1000
                            addr = match.group(2)
                            if addr not in variables['tcpAcc']:
                                variables['tcpAcc'][addr] = []
                            variables['tcpAcc'][addr].append(tick)
                        else:
                            variables[var_name] = int(match.group(1)) // 1000
                        if stage == 'tlbReq': flag = 1
                        elif stage == 'mc': flag = 0
                if not ifSearch and not flag: #在tlbReq和mc之间可能会有未匹配的行，允许跳过TODO
                    break
            decode, scb, sch, issue, tlbReq, sCacheReq, sCacheResp, dtlbReturn, tcpAcc, mc = (
                variables['decode'], variables['scb'], variables['sch'], variables['issue'],
                variables['tlbReq'], variables['sCacheReq'], variables['sCacheResp'],
                variables['dtlbReturn'], variables['tcpAcc'],variables['mc']
            )
            scb = decode+1
            # 3:保存指令信息，后续要重排序
            instruction_info[seqnum] = {
                'assm': assm,
                'pc_raw': pc_raw,
                'fetch': fetchtick,
                'decode': decode,
                'scb': scb,
                'sch': sch,
                'issue': issue,
                'tlbReq': tlbReq,
                'mc': mc,
                'sCacheReq': sCacheReq,
                'sCacheResp': sCacheResp,
                'dtlbReturn': dtlbReturn,
                'tcpAcc': tcpAcc,
                'ifTcp': ifTcp,
                'ifTcpSt': ifTcpSt,
            }
            i += j
            sn+=1
        else:
            i += 1

    # === 1:指令序号排序压缩 ===
    sorted_seqnums = sorted(instruction_info.keys(), key=int)
    new_seqnum_map = {str(seq): str(i+1) for i, seq in enumerate(sorted_seqnums)}

    # === 2:时间压缩 ===
    # 2.0：获取排序ticks
    ori_ticks = [] 
    for seqnum in sorted_seqnums:
        data = instruction_info[seqnum]
        for stage in ['fetch', 'decode', 'scb', 'sch', 'issue', 'tlbReq', 'mc', 'sCacheReq', 'sCacheResp', 'dtlbReturn']:
            if data[stage] != 0:
                data[f'original_{stage}'] = data[stage]  
                ori_ticks.append(data[stage])
        if data['ifTcp']:
            for addr, ticks in data['tcpAcc'].items():
                for tick in ticks:
                    ori_ticks.append(tick)
    sort_ticks = sorted(set(ori_ticks))
    # 2.1：获取压缩ticks
    comp_ticks = sorted(list(set(ori_ticks)))  
    i = 0
    while i < len(comp_ticks) - 1:
        gap = comp_ticks[i + 1] - comp_ticks[i]
        if gap >= 16:
            for j in range(i + 1, len(comp_ticks)):
                comp_ticks[j] -= (gap - 16)  #后续整体时间左移
        i += 1  
    # 2.2：建立映射表：排序ticks -> 压缩ticks
    time_map = {}
    for orig, compressed in zip(sort_ticks, comp_ticks):
        time_map[orig] = compressed
    # 2.3：保存压缩tick，是否压缩，当前间隔，原始间隔    
    for seqnum in sorted_seqnums:
        data = instruction_info[seqnum]
        stages = ['fetch', 'decode', 'scb', 'sch', 'issue', 'tlbReq', 'sCacheReq', 'sCacheResp', 'dtlbReturn','mc']
        prev_stage = None  
        prev_ori_tick = None  
        prev_comp_tick = None  
        for stage in stages:
            if data[stage] == 0:
                continue  
            ori_tick = int(data[stage])
            comp_tick = time_map.get(ori_tick, ori_tick)
            data[stage] = comp_tick
            if stage!='mc' and prev_stage is not None:
                ori_time = ori_tick - prev_ori_tick
                comp_time = comp_tick - prev_comp_tick
                data[f"{prev_stage}_enlarged"] = comp_time < ori_time
                data[f"{prev_stage}_time"] = comp_time
                data[f"{prev_stage}_ori_time"] = ori_time
            prev_stage = stage
            prev_ori_tick = ori_tick
            prev_comp_tick = comp_tick
        # tcpAcc
        if data['ifTcp']:
            print(data['assm'])
            time = []
            for addr, ticks in data['tcpAcc'].items():
                timeCur = []
                timeCur.append(addr)
                print(addr)
                prev = 0
                prev_comp_tick = 0
                prev_ori_tick = 0
                for tick in ticks:
                    comp_tick = time_map.get(tick,tick)
                    print(tick)
                    if prev:
                        ori_time = tick - prev_ori_tick
                        comp_time = comp_tick - prev_comp_tick
                        timeCur.append([comp_time, ori_time, comp_time < ori_time])
                    prev = 1
                    prev_comp_tick = comp_tick
                    prev_ori_tick = tick
                time.append(timeCur)
            data['tcpAccTime'] = time

    # 生成 B 列表（按新顺序）``
    B_sorted = []
    for original_seq,new_seq in new_seqnum_map.items():
        data = instruction_info[original_seq]
        B_sorted.extend([
            f"O3PipeView:fetch:{data['fetch']}:{data['pc_raw']}:0:{new_seq}:{data['assm']}",
            *[f"O3PipeView:{stage}:{value}" for stage, value in [
                ("decode", data['decode']),
                ("rename", data['scb']),
                ("dispatch", data['sch']),
                ("issue", data['issue'])
            ]]
        ])

        if data['tlbReq'] == 0:
            B_sorted.extend([
                f"O3PipeView:retire:{data['issue']+4}:store:0"
            ])
        elif data['ifTcp'] == 0:
            B_sorted.extend([
                f"O3PipeView:complete:{data['sCacheReq']}",
                f"O3PipeView:retire:{data['mc']-1}:store:{data['mc']}"
            ])
        elif data['ifTcpSt'] == 0:
            B_sorted.extend([
                f"O3PipeView:complete:{data['dtlbReturn']}",
                f"O3PipeView:retire:{data['mc']-1}:store:{data['mc']}"
            ])
        else:
            B_sorted.extend([
                f"O3PipeView:complete:{data['dtlbReturn']}",
                f"O3PipeView:retire:{data['mc']-1}:store:{data['mc']}" #todo:firTcpResp->mc-1
            ])
        


    # 生成新的输出列表 C_sorted
    C_sorted = []
    for original_seq, new_seq in new_seqnum_map.items():
        data = instruction_info[original_seq]
        C_sorted.append(f"\n{new_seq}: {data['assm']}: {data['pc_raw']}")
        prev_stage = 'fetch'
        stages = ['decode', 'scb', 'sch', 'issue', 'tlbReq', 'sCacheReq', 'sCacheResp', 'dtlbReturn']
        for stage in stages:
            if data[stage] == 0:
                continue  
            enlarged = data.get(f"{prev_stage}_enlarged")
            time = data[f"{prev_stage}_time"]
            if enlarged:
                ori_time = data[f"{prev_stage}_ori_time"]
                C_sorted.append(f"{prev_stage}:{time} (原{ori_time})")
            else:
                C_sorted.append(f"{prev_stage}:{time}")
            prev_stage = stage

        if data['tlbReq'] == 0:
            C_sorted.append("issue:4") 
        elif data['ifTcp']:
            time = data['tcpAccTime']
            for tc in time:
                addr = tc[0]
                C_sorted.append(f"addr:{addr}")
                reqTcp = tc[1]
                C_sorted.append(format_stage_string('   reqTcp',reqTcp[0],reqTcp[1],reqTcp[2]))
                if data['ifTcpSt']:
                    wt = tc[2]
                    C_sorted.append(format_stage_string('   writeThrough',wt[0],wt[1],wt[2]))

    with open(output_path, 'w') as f:
        f.write("\n".join(B_sorted))
        print(f"[✓] 输出已写入: {output_path}")

    with open(raw_output_path, 'w') as f:
        f.write("\n".join(C_sorted))
        print(f"[✓] 原始输出已写入: {raw_output_path}")
    print(sn)

# 示例用法：/home/intern/luot/gem5/trace_square_pipe/trace
parse_trace_file("/home/intern/luot/gem5/trace_square_pipe/trace", "trace1.out", "trace.raw")