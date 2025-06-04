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
