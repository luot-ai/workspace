import sys
from collections import defaultdict

class Instruction:
    def __init__(self, id_in_file, seqnum, pc, disasm, fetched_tick):
        self.id = id_in_file
        self.seqnum = seqnum
        self.pc = pc
        self.disasm = disasm
        self.fetched_tick = fetched_tick
        self.stages = []  # List of (stage_name, tick)
        self.retired_tick = None
        self.is_flushed = False

    def add_stage(self, name, tick):
        self.stages.append((name, tick))

def parse_trace_file(filepath):
    instructions = []
    current_inst = None
    id_counter = 0

    with open(filepath, 'r') as f:
        for line in f:
            if not line.strip().startswith("O3PipeView:"):
                continue

            parts = line.strip().split(":")
            tag = parts[1]

            if tag == "fetch":
                if current_inst:
                    instructions.append(current_inst)
                tick = int(parts[2])
                pc = parts[3]
                seqnum = int(parts[5])
                disasm = ":".join(parts[6:]).strip()
                current_inst = Instruction(id_counter, seqnum, pc, disasm, tick)
                id_counter += 1
                stage_name = stage_map.get(tag, tag)
                current_inst.add_stage(stage_name, tick) 
            elif tag == "retire":
                tick = int(parts[2])
                if current_inst:
                    current_inst.retired_tick = tick
            else:
                tick = int(parts[2])
                stage_name = stage_map.get(tag, tag)
                if current_inst:
                    current_inst.add_stage(stage_name, tick)

    if current_inst:
        instructions.append(current_inst)
    return instructions

def detect_ticks_per_cycle(instructions):
    ticks = set()
    for inst in instructions:
        ticks.add(inst.fetched_tick)
        if inst.retired_tick:
            ticks.add(inst.retired_tick)
        for _, tick in inst.stages:
            ticks.add(tick)
    ticks = sorted(ticks)
    deltas = [ticks[i+1] - ticks[i] for i in range(len(ticks)-1) if ticks[i+1] > ticks[i]]
    return min(deltas) if deltas else 1

def generate_kanata_log(instructions, output_file):
    ticks_per_cycle = detect_ticks_per_cycle(instructions)
    min_tick = min(inst.fetched_tick for inst in instructions)
    current_cycle = 0
    last_tick = None

    with open(output_file, 'w') as f:
        f.write("Kanata\t0004\n")
        f.write(f"C=\t{0}\n")

        all_events = []

        for inst in instructions:
            all_events.append(("I", inst.fetched_tick, inst))
            all_events.append(("L0", inst.fetched_tick, inst))
            all_events.append(("L1", inst.fetched_tick, inst))
            for stage_name, tick in inst.stages:
                all_events.append(("S", tick, inst, stage_name))
            if inst.retired_tick:
                all_events.append(("R", inst.retired_tick, inst))

        all_events.sort(key=lambda x: x[1])  # sort by tick

        last_tick = None
        for event in all_events:
            tick = event[1]
            cycle = (tick - min_tick) // ticks_per_cycle
            if last_tick is None:
                delta = cycle
            else:
                delta = cycle - current_cycle

            if delta > 0:
                f.write(f"C\t{delta}\n")
                current_cycle += delta
            last_tick = tick

            cmd = event[0]
            if cmd == "I":
                inst = event[2]
                f.write(f"I\t{inst.id}\t{inst.seqnum}\t0\n")
            elif cmd == "L0":
                inst = event[2]
                f.write(f"L\t{inst.id}\t0\t{inst.pc}: {inst.disasm}\n")
            elif cmd == "L1":
                inst = event[2]
                f.write(f"L\t{inst.id}\t1\tfetched @ tick {inst.fetched_tick}\n")
            elif cmd == "S":
                inst = event[2]
                stage_name = event[3]
                f.write(f"S\t{inst.id}\t0\t{stage_name}\n")
            elif cmd == "E":
                inst = event[2]
                stage_name = event[3]
                f.write(f"E\t{inst.id}\t0\t{stage_name}\n")
            elif cmd == "R":
                inst = event[2]
                f.write(f"R\t{inst.id}\t{inst.id}\t0\n")  # type = 0: retire

# Stage abbreviation for Kanata
stage_map = {
    "fetch": "F",
    "decode": "Dc",
    "rename": "Rn",
    "scb": "Scb",
    "sch": "Sch",
    "issue": "Is",
    "tlbReq": "Tlb",
    "cacheAcc": "Acc",
    "writeThrough": "Wt",
    "cacheDone": "Md",
    "mc": "Mc",
}

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python trace_to_kanata.py input_trace.txt output.log")
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2]

    instructions = parse_trace_file(input_path)
    generate_kanata_log(instructions, output_path)
    print(f"✅ Kanata log written to {output_path}")
