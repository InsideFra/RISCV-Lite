import numpy as np
class Adder():
    def __init__(self):
        pass

    def _sum(self, value1: np.int32, value2: np.int32):
        return value1 + value2
    
    def sum(self, value1: np.int32, value2: np.int32):
        return self._sum(value1, value2)