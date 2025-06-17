import re
import sys
from typing import List, Dict

def format_stage_string(stage: str, time: int, ori_time: int, enlarged: bool) -> str:
    if stage == 'cacheDone':
        stage = 'mc'
    return f"{stage}:{time} (原{ori_time})" if enlarged else f"{stage}:{time}"

STAGE_ORDER = [
    'fetch', 'decode', 'scb', 'sch', 'issue',
    'tlbReq', 'cacheAcc', 'writeThrough', 'cacheDone', 'mc'
]

STAGE_REGEX = {
    'decode':    (re.compile(r'GPUView:decode:(\d+)'), 'decode'),
    'scb':       (re.compile(r'GPUView:scb:(\d+)'), 'scb'),
    'sch':       (re.compile(r'GPUView:sch:(\d+)'), 'sch'),
    'issue':     (re.compile(r'GPUView:issue:(\d+)'), 'issue'),
    'tlbReq':    (re.compile(r'GPUView:macc:(\d+)'), 'tlbReq'),
    'sCacheReq': (re.compile(r'GPUView:stlbReturn:(\d+)'), 'cacheAcc'),
    'sCacheResp':(re.compile(r'GPUView:ScacheResp:(\d+)'), 'cacheDone'),
    'tcpReq':    (re.compile(r'GPUView:dtlbReturn:(\d+):([0-9a-fxA-F]+)'), 'cacheAcc'),
    'tcpResp':   (re.compile(r'GPUView:tcpResp:(\d+):([0-9a-fxA-F]+)'), 'cacheDone'),
    'tcpRespSt': (re.compile(r'GPUView:tcpRespStore:(\d+):([0-9a-fxA-F]+)'), 'writeThrough'),
    'mc':        (re.compile(r'GPUView:mc:(\d+)'), 'mc'),
}

FETCH_RE = re.compile(
    r'(?P<tick>\d+): CU(?P<cu>\d+): WF\[(?P<simd_id>\d+)\]\[(?P<wf_slot>\d+)\]: Id(?P<wf_id>\d+): Initiate fetch from pc: (?P<pc>\d+), tlb translation for cache line addr: (?P<addr>0x[0-9a-fA-F]+)'
)

EXEC_RE = re.compile(
    r'.*WF\[(?P<simd_id>\d+)\]\[(?P<wf_slot>\d+)\]: wave\[(?P<wf_id>\d+)\] Executing inst: (?P<assm>.+?) \(pc: (?P<pc>0x[0-9a-fA-F]+); seqNum: (?P<seqnum>\d+)\)'
)

class Instruction:
    def __init__(self, seqnum: str, pc: str, assm: str):
        self.seqnum = seqnum
        self.pc = pc
        self.assm = assm
        self.stages: Dict[str, int] = {}
        self.tcp_access: Dict[str, List[int]] = {}
        self.if_tcp = False
        self.if_tcp_store = False

    def add_stage(self, name: str, tick: int):
        self.stages[name] = tick

    def add_tcp_stage(self, addr: str, tick: int, store=False):
        self.if_tcp = True
        self.if_tcp_store |= store
        if addr not in self.tcp_access:
            self.tcp_access[addr] = []
        self.tcp_access[addr].append(tick)

def parse_trace(lines: List[str], wfid='1') -> List[Instruction]:
    fetch_map = {}
    # fetch 匹配阶段
    for line in lines:
        m = FETCH_RE.match(line)
        if m and m.group('wf_id') == wfid:
            addr_int = int(m.group('addr'), 16)
            addr_aligned = hex(addr_int & ~0x3F)
            tick = int(m.group('tick')) // 1000
            fetch_map.setdefault(addr_aligned, []).append(tick)

    instructions = []
    i = 0
    while i < len(lines):
        line = lines[i]
        m = EXEC_RE.search(line)
        if m and m.group("wf_id") == wfid:
            pc_hex = m.group("pc").lower()
            pc_int = int(pc_hex, 16)
            pc_aligned = hex(pc_int & ~0x3F)
            candidates = fetch_map.get(pc_aligned, [])
            assm = m.group("assm")
            seqnum = m.group("seqnum")
            inst = Instruction(seqnum, pc_hex, assm)
            j = 0
            while i + j < len(lines):
                j += 1
                next_line = lines[i + j]
                matched = False
                for key, (pattern, stage_name) in STAGE_REGEX.items():
                    mm = pattern.search(next_line)
                    if mm:
                        tick = int(mm.group(1)) // 1000
                        if 'tcp' in key:
                            addr = mm.group(2).lower()
                            inst.add_tcp_stage(addr, tick, 'St' in key)
                            if key == 'tcpReq' and 'cacheAcc' not in inst.stages:
                                inst.add_stage('cacheAcc', tick)
                            if key == 'tcpResp':
                                inst.add_stage('cacheDone', tick)
                                if 'writeThrough' not in inst.stages:
                                    inst.add_stage('writeThrough', tick)
                            if key == 'tcpRespSt':
                                inst.if_tcp_store = True
                                inst.add_stage('cacheDone', tick)
                        else:
                            inst.add_stage(stage_name, tick)
                        matched = True
                        break
                if not matched and ('mc' in inst.stages or 'tlbReq' not in inst.stages ):
                    break
            #后处理
            if not inst.if_tcp_store and 'writeThrough' in inst.stages:
                del inst.stages['writeThrough']
            inst.stages['scb']= inst.stages['decode']+1
            fetch_tick = max([t for t in candidates if t <= inst.stages['decode']], default=0)
            inst.add_stage('fetch', fetch_tick)
            instructions.append(inst)
            print(f"[✓] 解析指令: {inst.seqnum} (PC: {inst.pc}) (Assm: {inst.assm}), fetch tick: {inst.stages['fetch']}, decode tick: {inst.stages.get('decode', 'N/A')}, stages: {list(inst.stages.keys())}")
            i += j
        else:
            i += 1
    return instructions

def compress_ticks(tick_list: List[int]) -> Dict[int, int]:
    sorted_ticks = sorted(set(tick_list))
    comp_ticks = sorted_ticks[:]
    for i in range(len(comp_ticks) - 1):
        gap = comp_ticks[i + 1] - comp_ticks[i]
        if gap >= 8:
            for j in range(i + 1, len(comp_ticks)):
                comp_ticks[j] -= (gap - 8)
    return dict(zip(sorted_ticks, comp_ticks))

def gather_all_ticks(instructions: List[Instruction]) -> List[int]:
    ticks = []
    for inst in instructions:
        for tick in inst.stages.values():
            if tick:
                ticks.append(tick)
        for ticks_list in inst.tcp_access.values():
            ticks.extend(ticks_list)
    return ticks

# 添加压缩间隔记录
def update_instruction_ticks(instructions: List[Instruction], time_map: Dict[int, int]):
    for inst in instructions:
        stage_ticks = {}
        for stage in inst.stages:
            ori_tick = inst.stages[stage]
            comp_tick = time_map.get(ori_tick, ori_tick)
            inst.stages[stage] = comp_tick
            stage_ticks[stage] = (ori_tick, comp_tick)
        prev_stage = None
        for stage in STAGE_ORDER:
            if stage in stage_ticks:
                ori_tick, comp_tick = stage_ticks[stage]
                if prev_stage:
                    prev_ori, prev_comp = stage_ticks[prev_stage]
                    inst.stages[f"{prev_stage}_enlarged"] = comp_tick - prev_comp < ori_tick - prev_ori
                    inst.stages[f"{prev_stage}_time"] = comp_tick - prev_comp
                    inst.stages[f"{prev_stage}_ori_time"] = ori_tick - prev_ori
                prev_stage = stage
        if inst.if_tcp:
            tcp_time_list = []
            for addr, ticks in inst.tcp_access.items():
                timeCur = [addr]
                prev_ori_tick = None
                prev_comp_tick = None
                for i, ori_tick in enumerate(ticks):
                    comp_tick = time_map.get(ori_tick, ori_tick)
                    if i > 0:
                        ori_time = ori_tick - prev_ori_tick
                        comp_time = comp_tick - prev_comp_tick
                        enlarged = comp_time < ori_time
                        timeCur.append([comp_time, ori_time, enlarged])
                    prev_ori_tick = ori_tick
                    prev_comp_tick = comp_tick
                tcp_time_list.append(timeCur)
            inst.tcpAccTime = tcp_time_list  # 存入实例


def generate_outputs(instructions: List[Instruction]):
    sorted_insts = sorted(instructions, key=lambda inst: int(inst.seqnum))
    new_seq_map = {inst.seqnum: str(i+1) for i, inst in enumerate(sorted_insts)}
    B_list = []
    C_list = []

    for inst in sorted_insts:
        new_seq = new_seq_map[inst.seqnum]
        B_list.append(f"O3PipeView:fetch:{inst.stages['fetch']}:{inst.pc}:0:{new_seq}:{inst.assm}")
        for stage in STAGE_ORDER[1:-1]:
            if stage in inst.stages :
                printStage = stage
                if stage == 'cacheDone':
                    printStage = 'mc'
                B_list.append(f"O3PipeView:{stage}:{inst.stages[stage]}")
        retire_tick = inst.stages.get('mc', inst.stages.get('issue', inst.stages['fetch'])) + (0 if 'mc' in inst.stages else 4)
        B_list.append(f"O3PipeView:retire:{retire_tick}")
        #generate C
        C_list.append(f"\n{new_seq}: {inst.assm}: {inst.pc}")
        prev_stage = 'fetch'
        for stage in STAGE_ORDER[1:]:
            if stage in inst.stages :
                enlarged = inst.stages.get(f"{prev_stage}_enlarged", False)
                delta = inst.stages.get(f"{prev_stage}_time", 0)
                ori = inst.stages.get(f"{prev_stage}_ori_time", delta)
                C_list.append(format_stage_string(prev_stage, delta, ori, enlarged))
                prev_stage = stage
        if 'tlbReq' not in inst.stages:
            C_list.append("issue:4")              
        # TCP 访问输出
        if hasattr(inst, 'tcpAccTime'):
            for entry in inst.tcpAccTime:
                addr = entry[0]
                C_list.append(f"addr:{addr}:reqTick:{inst.tcp_access[addr][0]}")
                if len(entry) >= 2:
                    reqTcp = entry[1]
                    C_list.append(format_stage_string("   cacheAcc", reqTcp[0], reqTcp[1], reqTcp[2]))
                if inst.if_tcp_store and len(entry) >= 3:
                    writeThrough = entry[2]
                    C_list.append(format_stage_string("   writeThrough", writeThrough[0], writeThrough[1], writeThrough[2]))
    return B_list, C_list

def main():
    if len(sys.argv) != 4:
        print("Usage: python trace_to_prekanata.py trace.txt trace1.out trace.raw")
        return

    input_path = sys.argv[1]
    output_path = sys.argv[2]
    raw_output_path = sys.argv[3]

    with open(input_path, 'r') as f:
        lines = f.readlines()

    instructions = parse_trace(lines)
    ticks = gather_all_ticks(instructions)
    time_map = compress_ticks(ticks)
    update_instruction_ticks(instructions, time_map)
    B, C = generate_outputs(instructions)

    with open(output_path, 'w') as f:
        f.write("\n".join(B))
    print(f"[✓] 输出已写入: {output_path}")

    with open(raw_output_path, 'w') as f:
        f.write("\n".join(C))
    print(f"[✓] 原始输出已写入: {raw_output_path}")

if __name__ == "__main__":
    main()
