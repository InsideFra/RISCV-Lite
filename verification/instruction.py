from verification.register_file import RegisterFileClass
class Instruction():
    def __init__(self):
        self.opcode =  get_opcode_from_pseudo(self.pseudo)
        self.I_Type =  get_I_type_from_pseudo(self.pseudo)

# S-Type
class SW_Class(Instruction):
    pseudo = "SW"
    def __init__(self):
        self.description =  "SW: Store the word (32bit) inside **RS2** into Memory Address **RS1 + IMM**."
        self.func =  self._SW
        self.arg1 =  "rs1"
        self.arg2 =  "rs2"
        self.arg3 =  "imm"
        self.arg4 =  "RF"
        self.arg5 =  "Memory"
    
    def _SW(self, rs1, rs2, imm, RF: RegisterFileClass, Memory):
        assert type(rs1) == int
        assert type(rs2) == int
        assert type(imm) == int
        assert type(RF) == RegisterFileClass
        # TODO: Implement _SW function
        raise NotImplementedError()

# U-Type
class AUIPC_Class(Instruction):
    pseudo = "AUIPC"
    def __init__(self):
        self.description =  "AUIPC: Loads **imm << 12** + **PC** in **RD**."
        self.func =  self._LUI
        self.arg1 =  "imm"
        self.arg2 =  "rd"
        self.arg3 =  "RF"
        super().__init__()
    
    def _AUIPC(self, imm, rd, RF: RegisterFileClass):
        assert type(imm) == int
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        # TODO: Implement _AUIPC function
        raise NotImplementedError()

class LUI_Class(Instruction):
    pseudo = "LUI"
    def __init__(self):
        self.description =  "LUI: Loads **imm << 12** in **RD**."
        self.func =  self._LUI
        self.arg1 =  "imm"
        self.arg2 =  "rd"
        self.arg4 =  "RF"
    
    def _LUI(self, imm, rd, RF: RegisterFileClass):
        assert type(imm) == int
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        # TODO: Implement _LUI functions
        raise NotImplementedError()

# R-Type
class SUB_Class(Instruction):
    pseudo = "SUB"
    def __init__(self):
        self.description =  "SUB: Performs a SUB operation between **RS1** and **RS2** and store the result in **RD**."
        self.func =  self._SUB
        self.arg1 =  "rs1"
        self.arg2 =  "rs2"
        self.arg3 =  "rd"
        self.arg4 =  "RF"
        self.funct3 =  0b000
        self.funct7 =  0b01000
    
    def _SUB(self, rs1, rs2, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(rs2) == int
        assert type(rd) == int
        assert type(RF) == RegisterFileClass

        rs1_value = RF.get_value_from_register(rs1)
        rs2_value = RF.get_value_from_register(rs2)
        result = rs1_value - rs2_value

        RF.write_value_into_register(rd, result)

class ADD_Class(Instruction):
    pseudo = "ADD"
    def __init__(self):
        self.description =  "ADD: Performs a ADD operation between **RS1** and **RS2** and store the result in **RD**."
        self.func =  self._ADD
        self.arg1 =  "rs1"
        self.arg2 =  "rs2"
        self.arg3 =  "rd"
        self.arg4 =  "RF"
        self.funct3 =  0b000
        self.funct7 =  0b00000
    
    def _ADD(self, rs1, rs2, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(rs2) == int
        assert type(rd) == int
        assert type(RF) == RegisterFileClass

        rs1_value = RF.get_value_from_register(rs1)
        rs2_value = RF.get_value_from_register(rs2)
        result = rs1_value + rs2_value

        RF.write_value_into_register(rd, result)

class XOR_Class(Instruction):
    pseudo = "XOR"
    def __init__(self):
        self.description =  "XOR: Performs a XOR operation between **RS1** and **RS2** and store the result in **RD**."
        self.func =  self._XOR
        self.arg1 =  "rs1"
        self.arg2 =  "rs2"
        self.arg3 =  "rd"
        self.arg4 =  "RF"
        self.funct3 =  0b100
        self.funct7 =  0b00000
    
    def _XOR(self, rs1, rs2, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(rs2) == int
        assert type(rd) == int
        assert type(RF) == RegisterFileClass

        rs1_value = RF.get_value_from_register(rs1)
        rs2_value = RF.get_value_from_register(rs2)
        result = rs1_value ^ rs2_value

        RF.write_value_into_register(rd, result)

# I-Type
class LW_Class(Instruction):
    pseudo = "LW"
    def __init__(self):
        self.description =  "LW: Load from memory address **RS1 + IMM** (32 bit) in **RD**."
        self.func =  self._LW
        self.arg1 =  "rs1"
        self.arg2 =  "imm"
        self.arg3 =  "rd"
        self.arg4 =  "RF"
        self.funct3 =  0b010
        self.funct7 =  None
    
    def _LW(self, rs1, imm, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(imm) == int
        assert (imm & 0b111111100000) == 0
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        # TODO: Implement _LW function
        raise NotImplementedError()

class SRAI_Class(Instruction):
    pseudo = "SRAI"
    def __init__(self):
        self.description =  "SRAI: Performs a Shift Arithmetic Right Immediate operation between **RS1** and **imm** and store the result in **RD**."
        self.func =  self._SRAI
        self.arg1 =  "rs1"
        self.arg2 =  "imm"
        self.arg3 =  "rd"
        self.arg4 =  "RF"
        self.funct3 =  0b101
        self.funct7 =  0b01000
    
    def _SRAI(self, rs1, imm, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(imm) == int
        assert (imm & 0b111111100000) == 0
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        # TODO: Implement _SRAI function
        raise NotImplementedError()

class ADDI_Class(Instruction):
    pseudo = "ADDI"
    def __init__(self):
        self.description =  "ADDI: Performs a ADD operation between **RS1** and **imm** and store the result in **RD**."
        self.func =  self._SLLI
        self.arg1 =  "rs1"
        self.arg2 =  "imm"
        self.arg3 =  "rd"
        self.arg4 =  "RF"
        self.funct3 =  0b000
        self.funct7 =  0b00000
    
    def _SLLI(self, rs1, imm, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(imm) == int
        assert (imm & 0b111111100000) == 0
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        # TODO: Implement _SLLI function
        raise NotImplementedError()

class SLLI_Class(Instruction):
    pseudo = "SLLI"
    def __init__(self):
        self.description =  "SLLI: Performs a Shift Logical Left Immediate operation between **RS1** and **imm** and store the result in **RD**."
        self.func =  self._SLLI
        self.arg1 =  "rs1"
        self.arg2 =  "imm"
        self.arg3 =  "rd"
        self.arg4 =  "RF"
        self.funct3 =  0b001
        self.funct7 =  0b00000
    
    def _SLLI(self, rs1, imm, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(imm) == int
        assert (imm & 0b111111100000) == 0
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        # TODO: Implement _SLLI function
        raise NotImplementedError()

class JALR_Class(Instruction):
    pseudo = "JALR"
    def __init__(self):
        self.description =  "JALR: Jump to **RS1 + IMM** and store **PC + 4** in **RD**."
        self.func =  self._JALR
        self.arg1 =  "rs1"
        self.arg2 =  "imm"
        self.arg3 =  "rd"
        self.arg4 =  "RF"
        self.funct3 =  0b001
        self.funct7 =  0b00000
    
    def _JALR(self, rs1, imm, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(imm) == int
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        # TODO: Implement _JALR function
        raise NotImplementedError()

class NOP_Class(Instruction):
    pseudo = "NOP"
    def __init__(self):
        self.description =  "The NOP instruction does not change any user-visible state, except for advancing the pc. NOP is encodedas ADDIx0,x0,0"
        self.func =  self._NOP
        self.arg1 =  "rs1"
        self.arg2 =  "imm"
        self.arg3 =  "rd"
        self.arg4 =  "RF"
        self.funct3 =  0b000
        self.funct7 =  None
    
    def _NOP(self, rs1, imm, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(imm) == int
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        # TODO: Implement _NOP class
        raise NotImplementedError()

# J-TYPE
class JAL_Class(Instruction):
    pseudo = "JAL"
    def __init__(self):
        self.description =  "JAL: Jump to **PC+RS1** and store **PC + 4** in **RD**."
        self.func =  self._JAL
        self.arg1 =  "rs1"
        self.arg2 =  "rd"
        self.arg3 =  "RF"
        self.funct3 =  0b001
        self.funct7 =  0b00000
    
    def _JAL(self, rs1, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        
        # TODO: Implement _JAL function
        raise NotImplementedError()

# B-TYPE
class BNE_Class(Instruction):
    pseudo = "BNE"
    def __init__(self):
        self.description =  "BNE: Jump to **PC+imm** if **RS1 != RS2**."
        self.func =  self._BNE
        self.arg1 =  "rs1"
        self.arg2 =  "rs2"
        self.arg3 =  "rd"
        self.arg4 =  "RF"
        self.funct3 =  0b001
        self.funct7 =  0b00000
    
    def _BNE(self, rs1, rs2, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(rs2) == int
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        
        # TODO: Implement _BNE function
        raise NotImplementedError()

class BLE_Class(Instruction):
    pseudo = "BLE"
    def __init__(self):
        self.description =  "BNE: Jump to **PC+imm** if **RS1 <= RS2**."
        self.func =  self._BLE
        self.arg1 =  "rs1"
        self.arg2 =  "rs2"
        self.arg3 =  "rd"
        self.arg4 =  "RF"
        self.funct3 =  0b101
        self.funct7 =  0b00000
    
    def _BLE(self, rs1, rs2, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(rs2) == int
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        
        # TODO: Implement _BLE function
        raise NotImplementedError()

instruction_list = {
    # R-Type
    "R-Type": {
        "ADD": {"class": ADD_Class,     "opcode": 0b0110011, "funct3": 0b000, "funct7": 0b00000},
        "XOR": {"class": XOR_Class,     "opcode": 0b0110011, "funct3": 0b100, "funct7": 0b00000},
        "SUB": {"class": SUB_Class,     "opcode": 0b0110011, "funct3": 0b000, "funct7": 0b01000},
    },

    # I-Type
    "I-Type": {
        "SLLI": {"class": SLLI_Class,   "opcode": 0b0010011, "funct3": 0b001, "funct7": 0b00000},
        "SRAI": {"class": SRAI_Class,   "opcode": 0b0010011, "funct3": 0b101, "funct7": 0b01000},
        "ADDI": {"class": ADDI_Class,   "opcode": 0b0010011, "funct3": 0b000, "funct7": None},
        "LW":   {"class": LW_Class,     "opcode": 0b0000011, "funct3": 0b010, "funct7": None},
        "JALR": {"class": JALR_Class,   "opcode": 0b1100111, "funct3": 0b000, "funct7": None},
    },
    
    # U-Type
    "U-Type" : { 
        "LUI":  {"class": LUI_Class,    "opcode": 0b0110111, "funct3": None, "funct7": None},
        "AUIPC":{"class": AUIPC_Class,  "opcode": 0b0010111, "funct3": None, "funct7": None},
    },

    # S-Type
    "S-Type": {
        "SW":   {"class": SW_Class,     "opcode": 0b0100011, "funct3": None, "funct7": None},
    },

    # J-Type
    "J-Type": {
        "JAL":   {"class": JAL_Class,   "opcode": 0b1101111, "funct3": None, "funct7": None},
    },

    # B-Type
    "B-Type": {
        "BNE":   {"class": BNE_Class,   "opcode": 0b1100011, "funct3": 0b001, "funct7": None},
        "BLE":   {"class": BLE_Class,   "opcode": 0b1100011, "funct3": 0b101, "funct7": None},
    }
}

def get_opcode_from_pseudo(pseudo: str) -> int:
    opcode = -1
    for _, item in instruction_list.items():
        if pseudo in item.keys():
            opcode = item[pseudo]["opcode"]
    assert opcode != -1
    return opcode

def get_funct3_from_pseudo(pseudo: str) -> int:
    pass

def get_I_type_from_pseudo(pseudo: str) -> str:
    I_type = ""
    for key, item in instruction_list.items():
        if pseudo in item.keys():
            I_type = key
    assert I_type != ""
    return I_type