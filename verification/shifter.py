import numpy as np
class ShifterModule():
    def __init__(self):
        pass

    def _shift12(self, value1: np.int32) -> np.int32:
        return value1 << 12
    
    def shift12(self, value1: np.int32):
        self._shift12(value1)