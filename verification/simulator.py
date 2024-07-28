"""
A 5 stage RISCV Simulator in Python.
Behavioral and Semi-Structural simulator.
"""
from instruction import NOP_Class

class Register():
    def __init__(self):
        self.current_value = 0
        self.new_value = 0
        self.enable = 1
    
    def clockPulse(self):
        self.current_value = self.new_value
    
    def update_new_value(self, new_value):
        self.new_value = new_value
    
    def get_value(self):
        return self.current_value

register_list = []
def create_new_register() -> Register:
    register_list.append(Register())
    return register_list[-1]

class FE_DE():
    def __init__(self):
        self.rs1_reg = create_new_register()
        self.rs2_reg = create_new_register()
        self.rd_reg = create_new_register()
        self.imm_reg = create_new_register()
        self.pc = create_new_register()
        self.decode_instr = create_new_register()

class DE_EX():
    def __init__(self):
        self.rs1_reg = create_new_register()
        self.rs2_reg = create_new_register()
        self.imm_reg = create_new_register()
        self.rd_reg = create_new_register()
        self.pc = create_new_register()
        self.execute_instr = create_new_register()

class EX_MEM():
    def __init__(self):
        self.rs2_reg = create_new_register()
        self.rd_reg = create_new_register()
        self.addr_reg = create_new_register()
        self.memory_instr = create_new_register()

class MEM_WB():
    def __init__(self):
        self.rd_reg = create_new_register()
        self.writeback_instr = create_new_register()

class DECODE():
    def __init__(self):
        from register_file import RegisterFileClass
        from shifter import ShifterModule
        self.RF = RegisterFileClass()
        self.Shifter = ShifterModule()
        self.DECODE_EN = 1

class EXECUTE():
    def __init__(self):
        from adder import Adder
        self.Adder = Adder()
        self.EXECUTE_EN = 1

class MEMORY():
    def __init__(self):
        from memory import Memory
        self.Memory = Memory(ADDR_WIDTH=6, DATA_WIDTH=32, DELAY=0)
        self.MEMORY_EN = 1

class WRITEBACK():
    def __init__(self):
        self.WRITEBACK_EN = 1

class PipelineClass():
    def __init__(self):
        self.FETCH_INSTR = NOP_Class()
        self.FETCH_EN = 1
        self.PC = 0

        self.FE_DE = FE_DE()
        self.DE_EX = DE_EX()
        self.EX_MEM = EX_MEM()
        self.MEM_WB = MEM_WB()

        self.DECODE = DECODE()
        self.EXECUTE = EXECUTE()
        self.MEMORY = MEMORY()
        self.WRITEBACK = WRITEBACK()
    
    def update_stages_enable_signal_before_clock_pulse(self):
        from hex_to_assembly import instruction_decoder
        rs1_addr = self.FE_DE.rs1_reg.get_value()
        rs2_addr = self.FE_DE.rs2_reg.get_value()
        imm_value = self.FE_DE.imm_reg.get_value()
        print("DE: ", end="")
        instruction_return = instruction_decoder(self.FE_DE.decode_instr.get_value()) 
        instr_class = instruction_return["instr_class"]
        decode_instr = instr_class()
        decode_instr.decode_stage(rs1=rs1_addr, rs2=rs2_addr, imm=imm_value, RF=self.DECODE.RF, shifter=self.DECODE.Shifter, DE_EX=self.DE_EX)

        self.DE_EX.pc.update_new_value(self.FE_DE.pc.get_value())
        self.DE_EX.execute_instr.update_new_value(self.FE_DE.decode_instr.get_value())
        
        rs1_value = self.DE_EX.rs1_reg.get_value()
        imm = self.DE_EX.imm_reg.get_value()
        pc = self.DE_EX.pc.get_value()
        adder = self.EXECUTE.Adder
        print("EX: ", end="")
        instruction_return = instruction_decoder(self.DE_EX.execute_instr.get_value()) 
        instr_class = instruction_return["instr_class"]
        execute_instr = instr_class()
        execute_instr.execute_stage(rs1=rs1_value, imm=imm, adder=adder, pc=pc, imm_shifted=imm, EX_MEM=self.EX_MEM)

        self.EX_MEM.memory_instr.update_new_value(self.DE_EX.execute_instr.get_value())

        rs2_value = self.EX_MEM.rs2_reg.get_value()
        addr = self.EX_MEM.addr_reg.get_value()
        memory = self.MEMORY.Memory
        print("MEM: ", end="")
        instruction_return = instruction_decoder(self.EX_MEM.memory_instr.get_value()) 
        instr_class = instruction_return["instr_class"]
        memory_instr = instr_class()
        memory_instr.memory_stage(addr=addr, rs2=rs2_value, memory=memory, MEM_WB=self.MEM_WB)

        self.MEM_WB.writeback_instr.update_new_value(self.EX_MEM.memory_instr.get_value())
        
        print("WB: ", end="")
        instruction_return = instruction_decoder(self.MEM_WB.writeback_instr.get_value()) 
        instr_class = instruction_return["instr_class"]
        writeback_instr = instr_class()
        writeback_instr.writeback_stage()
        print("")

    def clockPulse(self, FETCH_INSTR):
        """_summary_

        Args:
            FETCH_INSTR (Instruction): _description_
        """
        self.update_stages_enable_signal_before_clock_pulse()
        
        # The instruction in the fetch stage can read the instruction from the memory
        from hex_to_assembly import instruction_decoder
        print("FE ", end="")
        instruction_return = instruction_decoder(FETCH_INSTR) 
        imm_value = instruction_return["imm_value"]
        self.FE_DE.imm_reg.update_new_value(imm_value)
        self.FE_DE.decode_instr.update_new_value(FETCH_INSTR)

        for register in register_list:
            register.clockPulse()
        
        # Update PC
        self.PC = self.PC + 4
        
if __name__ == "__main__":
    Pipeline = PipelineClass()

    Pipeline.clockPulse(0x1fc18197) ## AUIPC R3, #130072
    for i in range(0, 5, 1):
        Pipeline.clockPulse(0x00000000) ## NOP

