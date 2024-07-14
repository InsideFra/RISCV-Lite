from verification.register_file import RegisterFileClass
from verification.instruction import NOP_Class
from verification.instruction import Instruction
from verification import instruction

class PipelineClass():
    def __init__(self):
        
        self.FETCH_INSTR = NOP_Class()
        self.FETCH_EN = 1
        self.DECODE_INSTR = NOP_Class()
        self.DECODE_EN = 1
        self.EXECUTE_INSTR = NOP_Class()
        self.EXECUTE_EN = 1
        self.MEMORY_INSTR = NOP_Class()
        self.MEMORY_EN = 1
        self.WRITEBACK_INSTR = NOP_Class()
        self.WRITEBACK_EN = 1
    
    def update_stages_enable_signal_before_clock_pulse(self):
        raise NotImplementedError()
        pass

    def clockPulse(self, FETCH_INSTR: Instruction):
        """_summary_

        Args:
            FETCH_INSTR (Instruction): _description_
        """
        self.update_stages_enable_signal_before_clock_pulse()
        
        # The instruction in the writeback is allowed to write in the register file
        pass
        if self.WRITEBACK_EN:
            self.WRITEBACK_INSTR = self.MEMORY_INSTR
        else:
            self.WRITEBACK_INSTR = NOP_Class()
        
        # The instruction in the memory can write/read from the memory
        pass
        if self.MEMORY_EN:
            self.MEMORY_INSTR = self.EXECUTE_INSTR
        else:
            self.MEMORY_INSTR = NOP_Class()

        # The instruction in the execute can compute the value
        pass
        if self.EXECUTE_EN:
            self.EXECUTE_INSTR = self.DECODE_INSTR
        else:
            self.EXECUTE_INSTR = NOP_Class()

        # The instruction in the decode can take the value from the register file
        pass
        if self.DECODE_EN:
            self.DECODE_INSTR = self.FETCH_INSTR
        else:
            self.DECODE_INSTR = NOP_Class()

        # The instruction in the fetch stage can read the instruction from the memory
        pass
        if self.FETCH_EN:
            self.FETCH_INSTR = FETCH_INSTR
        else:
            self.FETCH_INSTR = NOP_Class()


if __name__ == "__main__":
    RF = RegisterFileClass()
    Pipeline = PipelineClass()

