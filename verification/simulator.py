"""
A 5 stage RISCV Simulator in Python.
Behavioral and Semi-Structural simulator.
"""
from instruction import NOP_Class

class FE_DE():
    def __init__(self):
        self.rs1_value = None
        self.rs2_value = None
        self.imm_value = None


class DE_EX():
    def __init__(self):
        self.rs1_value = None
        self.rs2_value = None
        self.imm_value = None

class EX_MEM():
    def __init__(self):
        self.rs2_value = None
        self.addr = None
        pass

class MEM_WB():
    def __init__(self):
        pass

class DECODE():
    def __init__(self):
        from register_file import RegisterFileClass
        from shifter import ShifterModule
        self.RF = RegisterFileClass()
        self.Shifter = ShifterModule()
        self.DECODE_INSTR = NOP_Class()
        self.DECODE_EN = 1
        self.DECODE_SIGNALS_INPUT = FE_DE()

class EXECUTE():
    def __init__(self):
        from adder import Adder
        self.Adder = Adder()
        self.EXECUTE_INSTR = NOP_Class()
        self.EXECUTE_EN = 1
        self.EXECUTE_SIGNALS_INPUT = DE_EX()

class MEMORY():
    def __init__(self):
        from memory import Memory
        self.Memory = Memory(ADDR_WIDTH=6, DATA_WIDTH=32, DELAY=0)
        self.MEMORY_INSTR = NOP_Class()
        self.MEMORY_EN = 1
        self.MEMORY_SIGNALS_INPUT = EX_MEM()

class WRITEBACK():
    def __init__(self):
        self.WRITEBACK_INSTR = NOP_Class()
        self.WRITEBACK_EN = 1
        self.WRITEBACK_SIGNALS_INPUT = MEM_WB()

class PipelineClass():

    def __init__(self):
        
        self.FETCH_INSTR = NOP_Class()
        self.FETCH_EN = 1

        self.DECODE = DECODE()
        self.EXECUTE = EXECUTE()
        self.MEMORY = MEMORY()
        self.WRITEBACK = WRITEBACK()
    
    def update_stages_enable_signal_before_clock_pulse(self):
        rs1_addr = self.DECODE.DECODE_SIGNALS_INPUT.rs1_value
        rs2_addr = self.DECODE.DECODE_SIGNALS_INPUT.rs2_value
        imm_value = self.DECODE.DECODE_SIGNALS_INPUT.imm_value
        decode_return = self.DECODE.DECODE_INSTR.decode_stage(rs1=rs1_addr, rs2=rs2_addr, imm=imm_value, RF=self.DECODE.RF, shifter=self.DECODE.Shifter)
        self.DECODE_SIGNALS = decode_return
        
        rs1_value = self.EXECUTE.EXECUTE_SIGNALS_INPUT.rs1_value
        imm = self.EXECUTE.EXECUTE_SIGNALS_INPUT.imm_value
        adder = self.EXECUTE.Adder
        execute_return = self.EXECUTE.EXECUTE_INSTR.execute_stage(rs1=rs1_value, imm=imm, adder=adder)
        self.EXECUTE_SIGNALS = execute_return

        rs2_value = self.MEMORY.MEMORY_SIGNALS_INPUT.rs2_value
        addr = self.MEMORY.MEMORY_SIGNALS_INPUT.addr
        memory = self.MEMORY.Memory
        self.MEMORY.MEMORY_INSTR.memory_stage(addr=addr, rs2=rs2_value, memory=memory)
        
        self.WRITEBACK.WRITEBACK_INSTR.writeback_stage()

    def clockPulse(self, FETCH_INSTR):
        """_summary_

        Args:
            FETCH_INSTR (Instruction): _description_
        """
        self.update_stages_enable_signal_before_clock_pulse()
        
        # The instruction in the writeback is allowed to write in the register file
        if self.WRITEBACK.WRITEBACK_EN:
            self.WRITEBACK.WRITEBACK_INSTR = self.MEMORY.MEMORY_INSTR
        else:
            self.WRITEBACK.WRITEBACK_INSTR = NOP_Class()
        
        # The instruction in the memory can write/read from the memory
        if self.MEMORY.MEMORY_EN:
            self.MEMORY.MEMORY_INSTR = self.EXECUTE.EXECUTE_INSTR
        else:
            self.MEMORY.MEMORY_INSTR = NOP_Class()

        # The instruction in the execute can compute the value
        if self.EXECUTE.EXECUTE_EN:
            self.EXECUTE.EXECUTE_INSTR = self.DECODE.DECODE_INSTR
        else:
            self.EXECUTE.EXECUTE_INSTR = NOP_Class()

        # The instruction in the decode can take the value from the register file
        if self.DECODE.DECODE_EN:
            self.DECODE.DECODE_INSTR = self.FETCH_INSTR
        else:
            self.DECODE.DECODE_INSTR = NOP_Class()

        # The instruction in the fetch stage can read the instruction from the memory
        if self.FETCH_EN:
            # MUST CONVERT FETCH_INST INTO A INSTRUCTION CLASS
            from hex_to_assembly import instruction_decoder
            # instr_class = instruction_decoder(FETCH_INSTR) 
            self.FETCH_INSTR = instr_class
        else:
            self.FETCH_INSTR = NOP_Class()

PC = 0

if __name__ == "__main__":
    Pipeline = PipelineClass()

    Pipeline.clockPulse(0x1fc18197) ## AUIPC R3, #130072
    for i in range(0, 100, 1):
        Pipeline.clockPulse(0x00000000) ## NOP

