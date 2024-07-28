from register_file import RegisterFileClass
from memory import DataMemory
from adder import Adder
from shifter import ShifterModule

class Instruction():
    def __init__(self):
        self.opcode =  get_opcode_from_pseudo(self.pseudo)
        self.I_Type =  get_I_type_from_pseudo(self.pseudo)
    
    def decode_stage(self, rs1: int, rs2: int, imm: int, RF: RegisterFileClass, shifter: ShifterModule):
        from simulator import DE_EX
        self.DE_EX = DE_EX()
        self._decode_stage(rs1=rs1, rs2=rs2, imm=imm, RF=RF, shifter=shifter)
        return self.DE_EX
    
    def execute_stage(self, rs1: int, imm: int, adder: Adder, pc: int, imm_shifted: int):
        from simulator import EX_MEM
        self.EX_MEM = EX_MEM()
        self._execute_stage(rs1=rs1, imm=imm, adder=adder, pc=pc, imm_shifted=imm_shifted)
        return self.EX_MEM
    
    def memory_stage(self, addr: int, rs2: int, memory: DataMemory):
        from simulator import MEM_WB
        self.MEM_WB = MEM_WB()
        self._memory_stage(addr=addr, rs2=rs2, memory=memory)
        return self.MEM_WB
    
    def writeback_stage(self) -> None:
        pass

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

        self.rs1_value_buffer = None
        self.rs2_value_buffer = None
    
    def _SW(self, rs1, rs2, imm, RF: RegisterFileClass, Memory: DataMemory, adder: Adder):
        """Behavioral description of the SW instruction

        Args:
            rs1 (_type_): rs1 address
            rs2 (_type_): rs2 address
            imm (_type_): Value of the immediate field in the instruction 
            RF (RegisterFileClass): The register file class
            Memory (DataMemory): The memory class
            adder (Adder): The adder class
        """
        assert type(rs1) == int
        assert type(rs2) == int
        assert type(imm) == int
        assert type(RF) == RegisterFileClass
        
        rs1_value = RF.get_value_from_register(rs1)
        rs2_value = RF.get_value_from_register(rs2)
        addr_value = adder.sum(rs1_value, imm)
        Memory.store(addr_value, rs2_value)

    def decode_stage(self, rs1: int, rs2: int, RF: RegisterFileClass) -> tuple[int, int]:
        """Call this function to know what the function does in the decode stage

        Args:
            rs1 (int): rs1 address
            rs2 (int): rs2 address
            RF (RegisterFileClass): Register File Class
        
        Returns:
            tuple: ..
        """
        assert type(rs1) == int
        assert type(rs2) == int
        
        rs1_value = RF.get_value_from_register(rs1)
        rs2_value = RF.get_value_from_register(rs2)
        return (rs1_value, rs2_value)
    
    def execute_stage(self, rs1: int, imm: int, adder: Adder) -> int:
        """Call this function to know what the function does in the decode stage

        Args:
            rs1 (int): rs1 value from pipeline registers
            imm (int): imm value from pipeline registers
            adder (Adder): The adder class in the Execution stage

        Returns:
            int: The result of the adder
        """
        assert type(rs1) == int
        assert type(imm) == int
        
        addr_value = adder.sum(rs1, imm)
        return addr_value
    
    def memory_stage(self, addr: int, rs2: int, memory: DataMemory) -> None:
        """Call this function to know what the function does in the writeback stage

        Args:
            addr (int): The result of the adder from the pipeline register
            rs2 (int): The rs2 register value from the pipeline register
            memory (DataMemory): The memory class
        """
        assert type(addr) == int
        assert type(rs2) == int

        memory.store(addr, rs2)
    
    def writeback_stage(self) -> None:
        """Call this function to know what the function does in the writeback stage

        Returns:
            None: No return
        """
        return None

# U-Type
class AUIPC_Class(Instruction):
    pseudo = "AUIPC"
    def __init__(self):
        self.description =  "AUIPC: Loads **imm << 12** + **PC** in **RD**."
        self.func =  self._AUIPC
        self.arg1 =  "imm"
        self.arg2 =  "rd"
        self.arg3 =  "RF"
        super().__init__()
    
    def _AUIPC(self, pc: int, imm: int , rd: int , RF: RegisterFileClass):
        assert type(int) == int
        assert type(imm) == int
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        imm_shifted = imm << 12 
        value = pc + imm_shifted
        RF.write_value_into_register(rd, value)
    
    def _decode_stage(self, shifter: ShifterModule, **kwargs) -> int:
        """Call this function to know what the function does in the decode stage
        Args:
            imm (int): The immediate value
        
        Returns:
            int: The immediate shifted left by 12 positions
        """
        imm = kwargs["imm"]
        imm_value = shifter.shift12(imm)
        
        self.DE_EX.imm_value = imm_value 
    
    def _execute_stage(self, pc: int, imm_shifted: int, adder: Adder, **kwargs) -> int:
        """Call this function to know what the function does in the decode stage

        Args:
            pc (int): Program Counter value from pipeline registers
            imm_shifted (int): imm value (shifted) from pipeline registers
            adder (Adder): The adder class in the Execution stage

        Returns:
            int: The result of the adder
        """
        assert type(pc) == int
        assert type(imm_shifted) == int
        
        value = adder.sum(pc, imm_shifted)
        return value
    
    def _memory_stage(self) -> None:
        """Call this function to know what the function does in the writeback stage
        """
        return None
    
    def _writeback_stage(self, rd: int, value: int, RF: RegisterFileClass) -> None:
        """Call this function to know what the function does in the writeback stage
        Args:
            rd (int): The rd address from pipeline register
            value (int): Adder result from pipeline register
            RF (RegisterFileClass): RegisterFileClass 

        Returns:
            None: No return
        """
        RF.write_value_into_register(rd, value)
        return None

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
    
    def _decode_stage(self, **kwargs) -> None:
        """Call this function to know what the function does in the decode stage
        """
    
    def _execute_stage(self, **kwargs) -> None:
        """Call this function to know what the function does in the decode stage
        """
    
    def _memory_stage(self, **kwargs) -> None:
        """Call this function to know what the function does in the writeback stage
        """
        return None
    
    def _writeback_stage(self, **kwargs) -> None:
        """Call this function to know what the function does in the writeback stage
        """

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

class BEQ_Class(Instruction):
    pseudo = "BEQ"
    def __init__(self):
        self.description =  "BEQ: Jump to **PC+imm** if **RS1 == RS2**."
        self.func =  self._BEQ
        self.arg1 =  "rs1"
        self.arg2 =  "rs2"
        self.arg3 =  "rd"
        self.arg4 =  "RF"
        self.funct3 =  0b000
        self.funct7 =  0b00000
    
    def _BEQ(self, rs1, rs2, rd, RF: RegisterFileClass):
        assert type(rs1) == int
        assert type(rs2) == int
        assert type(rd) == int
        assert type(RF) == RegisterFileClass
        
        # TODO: Implement _BEQ function
        raise NotImplementedError()

instruction_list = {
    # R-Type
    "R-Type": {
        "ADD": {"class": ADD_Class,     "opcode": 0b0110011, "funct3": 0b000, "funct7": 0b0000000},
        "XOR": {"class": XOR_Class,     "opcode": 0b0110011, "funct3": 0b100, "funct7": 0b0000000},
        "SUB": {"class": SUB_Class,     "opcode": 0b0110011, "funct3": 0b000, "funct7": 0b0100000},
    },

    # I-Type
    "I-Type": {
        "SLLI": {"class": SLLI_Class,   "opcode": 0b0010011, "funct3": 0b001, "funct7": None},
        "SRAI": {"class": SRAI_Class,   "opcode": 0b0010011, "funct3": 0b101, "funct7": None},
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
        "BNE":  {"class": BNE_Class,    "opcode": 0b1100011, "funct3": 0b001, "funct7": None},
        "BLE":  {"class": BLE_Class,    "opcode": 0b1100011, "funct3": 0b101, "funct7": None},
    },

    "N-TYPE": {
        "NOP":  {"class": NOP_Class,    "opcode": 0b0000000, "funct3": 0b000, "funct7": None},
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