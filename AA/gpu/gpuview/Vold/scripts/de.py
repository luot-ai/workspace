import argparse
import re

def main():
    parser = argparse.ArgumentParser(description="Extract specific lines from a trace file.")
    parser.add_argument('--input', required=True, help='Path to the input trace file')
    parser.add_argument('--output', required=True, help='Path to the output file')
    args = parser.parse_args()

    patterns = [
        # r'WF\[0\]\[0\]:\s*wave\[1\]', #EXE
        # r'WF\[0\]\[0\]:\s*wave1',


        r'schList\[\d+\]:\s*Adding:\s*SIMD\[0\]\s*WV\[1\]:', #SCH
        # r'schList\[\d+\]:\s*Added:\s*SIMD\[0\]\s*WV\[1\]:',
        r'schList\[\d+\]:\s*Could not add:\s*SIMD\[0\]\s*WV\[1\]:',
        # r'WV\[1\] operands'

        r'CUs01.ScoreboardCheckStage:\s*Adding\s*to\s*readyList\[\d+\]:\s*SIMD\[0\]\s*WV\[1\]:',
        

        r'Id1\s*decoded',
        # r'WF\[0\]\[0\]:\s*Id1:',         # 严格匹配 WF[0][0]: Id1 
        # r'CU1:\s*WF\[0\]\[0\]:',        # 严格匹配 CU1: WF[0][0]:
        # r'SIMD\[0\]\s*WV\[1\]:\s*1:',    # 严格匹配 SIMD[0] WV[1]: 1:
    ]

    # 编译正则表达式（提高效率）
    regex_patterns = [re.compile(p) for p in patterns]

    # 读取输入文件，写入输出文件
    with open(args.input, 'r') as inf, open(args.output, 'w') as outf:
        for line in inf:
            if any(p.search(line) for p in regex_patterns):
                outf.write(line)

if __name__ == '__main__':
    main()