import numpy as np
class Memory:
    def __init__(self, ADDR_WIDTH, DATA_WIDTH, DELAY):
        self.ADDR_WIDTH = ADDR_WIDTH
        self.DATA_WIDTH = DATA_WIDTH
        self.DELAY = DELAY

        assert not self.ADDR_WIDTH is None
        assert self.DATA_WIDTH == 32
        
        self.data = np.zeros(2**self.ADDR_WIDTH, dtype=np.int32)

    def _store(self, addr: np.int32, value: np.int32):
        assert addr > 0
        assert addr < 2**self.ADDR_WIDTH
        self.data[2**addr] = value
    
    def store(self, addr: np.int32, value: np.int32):
        raise NotImplementedError()
    
    def _load(self, addr: np.int32) -> np.int32:
        assert addr > 0
        assert addr < 2**self.ADDR_WIDTH
        return self.data[2**addr]
    
    def load(self, addr: np.int32) -> np.int32:
        raise NotImplementedError()

class DataMemory(Memory):
    def __init__(self):
        self.DATA_WIDTH = 32
        self.ADDR_WIDTH = 10
        self.DELAY = 1.83
        super().__init__()