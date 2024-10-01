for loop_count in range(1, 20, 1):
    clock_cycles = 50 + loop_count*32
    number_of_instruction = 36 * loop_count
    print("N Instruction: ", number_of_instruction, "instruction x clock: ", number_of_instruction/clock_cycles)

