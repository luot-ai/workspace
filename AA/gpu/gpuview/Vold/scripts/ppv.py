import argparse
import re
from dataclasses import dataclass

@dataclass
class Record:
    scb_tick: str
    seq_num: str
    inst_name: str
    sch_tick: str = ''
    exe_tick: str = ''
    print_flag: bool = False

def extract_seq_and_inst(line: str):
    # 匹配 seq_num 和 指令名
    match = re.search(r'SIMD\[0\]\s*WV\[1\]:\s*(\d+):\s*(.+)', line)
    if match:
        return match.group(1), match.group(2).strip()
    return None, None

def extract_seq_from_sch(line: str):
    match = re.search(r'SIMD\[0\]\s*WV\[1\]:\s*(\d+):', line)
    if match:
        return match.group(1)
    return None

def extract_seq_from_exe(line: str):
    match = re.search(r'seqNum:\s*(\d+)', line)
    if match:
        return match.group(1)
    return None

def main():
    parser = argparse.ArgumentParser(description="Extract and relate trace records.")
    parser.add_argument('--input', required=True, help='Path to the input trace file')
    parser.add_argument('--output', required=True, help='Path to the output result file')
    args = parser.parse_args()


    
    patterns = {
        'scb' : re.compile(r'^(\d+):.*ScoreboardCheckStage.*SIMD\[0\]\s*WV\[1\]:\s*(\d+):\s*(.+)$'),
        'sch' : re.compile(r'^(\d+):.*ScheduleStage.*SIMD\[0\]\s*WV\[1\]:\s*(\d+):'),
        'exe' : re.compile(r'^(\d+):.*wavefronts.*wave\[1\].*Executing inst:\s*.+?seqNum:\s*(\d+)')
    }

    A = {}  # key: seq_num, value: Record

    with open(args.input, 'r') as inf:
        for line in inf:
            line = line.strip()
            if patterns['scb'].search(line):
                tick = line.split(':')[0].strip()
                seq_num, inst_name = extract_seq_and_inst(line)
                if seq_num is None:
                    raise ValueError(f"Cannot extract seq_num in SCB line: {line}")
                A[seq_num] = Record(scb_tick=tick, seq_num=seq_num, inst_name=inst_name)
            elif patterns['sch'].search(line):
                tick = line.split(':')[0].strip()
                seq_num = extract_seq_from_sch(line)
                if seq_num is None or seq_num not in A:
                    raise ValueError(f"Schedule match but seq_num missing or not found: {line}")
                A[seq_num].sch_tick = tick
                A[seq_num].print_flag = True
            elif patterns['exe'].search(line):
                tick = line.split(':')[0].strip()
                seq_num = extract_seq_from_exe(line)
                if seq_num is None or seq_num not in A:
                    raise ValueError(f"Execute match but seq_num missing or not found: {line}")
                A[seq_num].exe_tick = tick
                A[seq_num].print_flag = True
    with open(args.output, 'w') as outf:
        for record in A.values():
            if record.print_flag:
                if record.scb_tick:
                    outf.write(f"O3PipeView:fetch:{int(record.scb_tick) - 2000}:0x00000000:0:{record.seq_num}:{record.inst_name}\n")
                if record.sch_tick:
                    outf.write(f"O3PipeView:decode:{int(record.scb_tick) - 1000}\n")
                if record.exe_tick:
                    outf.write(f"O3PipeView:rename:{record.scb_tick}\n")
                    outf.write(f"O3PipeView:dispatch:{record.sch_tick}\n")
                    outf.write(f"O3PipeView:issue:{record.exe_tick}\n")
                    outf.write(f"O3PipeView:complete:{int(record.exe_tick)+4000}\n")
                    outf.write(f"O3PipeView:retire:{int(record.exe_tick)+5000}:store:0\n")
    # with open(args.output, 'w') as outf:
    #     for record in A.values():
    #         if record.print_flag:
    #             if record.scb_tick:
    #                 outf.write(f"O3PipeView:scb:{record.scb_tick}:{record.seq_num}:{record.inst_name}\n")
    #             if record.sch_tick:
    #                 outf.write(f"sch:{record.sch_tick}:{record.seq_num}:{record.inst_name}\n")
    #             if record.exe_tick:
    #                 outf.write(f"exe:{record.exe_tick}:{record.seq_num}:{record.inst_name}\n")


if __name__ == '__main__':
    main()


# 阅读input：
# ①
# 正则项1匹配到的每一行，例如
# 10867111705000: system.Shader.CUs01.ScoreboardCheckStage: Adding to readyList[7]: SIMD[0] WV[1]: 1: s_load_dwordx4 s[4:7], s[0:1], 0x00
# 进行拆解得到一个六元组元素：scb_tick(最左侧数字提取)+指令序号(最右侧冒号左边的那个1)+指令名字（字符串，最右侧冒号右边）+ sch_tick(先不填) + exe_tick(先不填)+print(bool型，置为false)
# 每一个匹配行对应一个元素，所有匹配行对应一个列表A

# ②
# 正则项2匹配到的每一行，例如
# 10867111775000: system.Shader.CUs01.ScheduleStage: schList[4]: Adding: SIMD[0] WV[1]: 7: s_waitcnt lgkmcnt(0)
# 根据指令seqnum去列表A中看有没有一致的，如果没有报错！
# 如果有，就根据这里最左侧数字填写sch_tick,print置为true

# ③
# 正则项3匹配到的每一行，例如
# 6190: system.Shader.CUs01.wavefronts00: CU1: WF[0][0]: wave[1] Executing inst: s_endpgm (pc: 0x7fd1b6c062ec; seqNum: 831)
# 根据指令seqnum去列表A中看有没有一致的，如果没有报错！
# 如果有，就根据这里最左侧数字填写exe_tick,print置为true

# 最后，将列表A中所有print=true的元素，打印一下