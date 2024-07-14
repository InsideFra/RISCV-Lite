from enum import Enum

class FSM_MEM_states_re(Enum):
    STARTUP = 0
    STARTUP0 = 1
    STARTUP1 = 2
    STARTUP2 = 3
    STARTUP3 = 4
    STARTUP4 = 5
    IDLE = 6
    MEMREAD = 7
    RESTART = 8 
 
class InstructionFSM():
    def __init__(self):
        self.current_state = FSM_MEM_states_re.STARTUP 
        pass