import sys
print (sys.path)
sys.path.append("/home/francesco/RISCV-Lite/")

from instruction import instruction_list

def instruction_decoder(instr: int):
    
    # Read the OPCODE
    opcode_mask = 0b1111111
    opcode = instr & opcode_mask
    
    funct7_mask = 0xFE000000
    funct7 = (instr & funct7_mask) >> 25
    
    funct3_mask = 0x7000
    funct3 = (instr & funct3_mask) >> 12 

    rs1_mask = 0xF8000
    rs1 = (instr & rs1_mask) >> 15

    rs2_mask = 0x1F00000
    rs2 = (instr & rs2_mask) >> 20
    
    rd_mask = 0xF80
    rd = (instr & rd_mask) >> 7
    
    # Get the type of the instruction
    instr_type = None
    pseudo = None
    instr_class = None
    return_buffer = {
        "instr_class": None,
        "rs1_addr": rs1,
        "rs2_addr": rs2,
        "imm_value": None
    }
    for i_type, item1 in instruction_list.items():
        for i_pseudo, item2 in item1.items():
            if item2["opcode"] == opcode:
                if item2["funct3"] == None:
                    instr_type = i_type
                    pseudo = i_pseudo
                    instr_class = item2["class"]
                    break
        
                if item2["funct3"] == funct3:
                    if item2["funct7"] == None:
                        instr_type = i_type
                        pseudo = i_pseudo
                        instr_class = item2["class"]
                        break
                    
                    if item2["funct7"] == funct7:
                        instr_type = i_type
                        pseudo = i_pseudo
                        instr_class = item2["class"]
                        break
            else:
                continue
    
    assert instr_type != None
    assert pseudo != None 
    return_buffer["instr_class"] = instr_class
    instr_type = instr_type[0]
    if instr_type == "R":
        # print(f"({line.strip()}) - ", end="")
        print(f"{pseudo:5} R{rd:<2}, R{rs1}, R{rs2}")
    elif instr_type == "I":
        imm_mask = 0xFFF00000
        imm = (instr & imm_mask) >> 20
        # Check if the number is in the negative range for a 12-bit signed integer
        if imm & (1 << 11):  # Check the sign bit
            imm = imm - (1 << 12)  # Convert from unsigned to signed
        # print(f"({line.strip()}) - ", end="")
        return_buffer["imm_value"] = imm
        print(f"{pseudo:5} R{rd:<2}, R{rs1}, #{imm}")
    elif instr_type == "S":
        imm_mask = 0xFE000000
        imm = (instr & imm_mask) >> 20
        imm_mask = 0xF80
        imm += ((instr & imm_mask) >> 7)
        if imm & (1 << 12):  # Check the sign bit
            imm = imm - (1 << 12)  # Convert from unsigned to signed
        # print(f"({line.strip()}) - ", end="")
        return_buffer["imm_value"] = imm
        print(f"{pseudo:5} R{rs2:<2}, {imm}(R{rs1})")
    elif instr_type == "U":
        imm_mask = 0xFFFFF000
        imm = (instr & imm_mask) >> 12
        if imm & (1 << 19):  # Check the sign bit
            imm = imm - (1 << 20)  # Convert from unsigned to signed
        # print(f"({line.strip()}) - ", end="")
        return_buffer["imm_value"] = imm
        print(f"{pseudo:5} R{rd:<2}, #{imm}")
    elif instr_type == "J":
        # Extract the bits
        instr = instr >> 11
        bit_20 = (instr >> 20) & 1
        bits_10_to_1 = (instr >> 10) & 0x3FF  # 0x3FF is 10 bits mask (1111111111)
        bit_11 = (instr >> 9) & 1
        bits_19_to_12 = instr & 0xFF  # 0xFF is 8 bits mask (11111111)
    
        # Rearrange the bits into the new number
        imm = (bit_20 << 20) | (bits_10_to_1 << 1) | (bit_11 << 11) | (bits_19_to_12 << 12)
    
        # print(f"({line.strip()}) - ", end="")
        return_buffer["imm_value"] = imm
        print(f"{pseudo:5} R{rd:<2}, #{imm}")
    elif instr_type == "B":
        # Bit 31 = bit 11
        bit_31 = (instr >> 31)

        # Bit 30 to 25 = bit 9 to 4
        bit_30_to_25 = (instr >> 25) & 0b11111

        # Bit 11 to 8 = bit 3 to 0
        bit_11_to_8 = (instr >> 8) & 0b1111

        # Bit 7 = bit 10
        bit_7 = (instr >> 7) & 0b1
    
        # Rearrange the bits into the new number
        imm = (bit_31 << 11) | (bit_7 << 10) | (bit_30_to_25 << 4) | (bit_11_to_8)
    
        # print(f"({line.strip()}) - ", end="")
        return_buffer["imm_value"] = imm
        print(f"{pseudo:5} R{rd:<2}, #{imm}")
    elif instr_type == "N":
        print(f"{pseudo:5}")
    else:
        raise NotImplementedError()

    return return_buffer

if __name__ == "__main__":
    with open('sim/main_hex.txt', 'r') as file:
        for line in file:
            instruction_decoder(int(line.strip(), 16))  # strip() is used to remove any trailing newline characters())
