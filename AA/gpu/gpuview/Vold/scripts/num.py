import sys

def extract_instruction_numbers(log_lines):
    instruction_numbers = set()
    for line in log_lines:
        line = line.strip()
        if not line:
            continue
        parts = line.split(':')
        if len(parts) < 2:
            continue
        try:
            number_str = parts[-2].strip()
            number = int(number_str)
            instruction_numbers.add(number)
        except (ValueError, IndexError):
            # Skip lines with invalid format or non-numeric instruction number
            continue
    return instruction_numbers

def main():
    # Read from stdin
    log_lines = [line for line in sys.stdin]

    # Extract and count unique instruction numbers
    unique_numbers = extract_instruction_numbers(log_lines)

    # Output result
    print(f"Total unique instruction numbers: {len(unique_numbers)}")
    print("Unique instruction numbers:", sorted(unique_numbers))

if __name__ == "__main__":
    main()