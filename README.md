# RISCV-Lite
 A first implementation of a RISC V Processor.
 
 Developed with @andreads21 and @WilliamBaisi
 
 ## Description
 
 The architecture contains an SSRAM for both data and instruction. 
 
 To get higher performance, we added: 
 - an INSTRUCTION CACHE.
 - a Branch Prediction Unit. 
 - a Forwarding Unit. 
 
 To handle Branch and Jump instructions, we used an **Hazard Control Unit**.
 
 This architecture has been developed to execute a very specific assembly code, with the following instruction being implemented: 
 
 # RISCV32I Instructions

  ### R-Type Instructions
 - [x] **XOR**: Performs a XOR operation between **RS1** and **RS2** and stores the result in **RD**.
 - [x] **ADD**: Adds **RS1** and **RS2** and stores the result in **RD**.
 - [x] **SUB**: Subtracts **RS1** and **RS2** and stores the result in **RD**.
 - [ ] **AND**: Performs a bitwise AND between **RS1** and **RS2** and stores the result in **RD**.
 - [ ] **OR**: Performs a bitwise OR between **RS1** and **RS2** and stores the result in **RD**.
 - [ ] **SLL**: Performs a logical left shift on **RS1** by the value in **RS2** and stores the result in **RD**.
 - [ ] **SRL**: Performs a logical right shift on **RS1** by the value in **RS2** and stores the result in **RD**.
 - [ ] **SRA**: Performs an arithmetic right shift on **RS1** by the value in **RS2** and stores the result in **RD**.
 - [ ] **SLT**: Sets **RD** to 1 if **RS1** is less than **RS2**, otherwise sets **RD** to 0.
 - [ ] **SLTU**: Sets **RD** to 1 if **RS1** is less than **RS2** (unsigned comparison), otherwise sets **RD** to 0.
 
 ### I-Type Instructions
 - [x] **ADDI**: Adds **RS1** and **IMM** and stores the result in **RD**.
 - [x] **LI**: Is an alias of **ADDI** that loads the value **IMM** in the register **RD** (**RS1** is set to 0).
 - [x] **MV**: Is an alias of **ADDI** that loads the value **RS1** in the register **RD** (**IMM** is set to 0).
 - [x] **SRAI**: Performs an arithmetic right shift on **RS1** equal to the value stored in the lower 5 bits of **IMM**.
 - [x] **SLLI**: Performs an arithmetic left shift on **RS1** equal to the value stored in the lower 5 bits of **IMM**.
 - [x] **LW**: Loads in the register **RD** from the memory at the address **RS1** + **IMM**.
 - [ ] **LB**: Loads a 8-bit value from the memory at the address **RS1** + **IMM** and sign-extends this to 32bits before storing in into the register **RD**.
 - [ ] **LBU**: Loads a 8-bit value from the memory at the address **RS1** + **IMM** and zero-extends this to 32bits before storing in into the register **RD**.
 - [ ] **LH**: Loads a 16-bit value from the memory at the address **RS1** + **IMM** and sign-extends this to 32bits before storing in into the register **RD**.
 - [ ] **LHU**: Loads a 16-bit value from the memory at the address **RS1** + **IMM** and zero-extends this to 32bits before storing in into the register **RD**.
 - [ ] **ANDI**: Performs a bitwise AND between **RS1** and **IMM** and stores the result in **RD**.
 - [ ] **ORI**: Performs a bitwise OR between **RS1** and **IMM** and stores the result in **RD**.
 - [ ] **SLTI**: Sets **RD** to 1 if **RS1** is less than **IMM**, otherwise sets **RD** to 0.
 - [ ] **SLTIU**: Sets **RD** to 1 if **RS1** is less than **IMM** (unsigned comparison), otherwise sets **RD** to 0.
 - [ ] **JALR**: Jumps to the address **RS1** + **IMM** and stores **PC** + 4 in **RD**.
 
 ### S-Type Instructions
 - [x] **SW**: Loads in the memory the value in **RS2** at the address **RS1** + **IMM**.
 - [ ] **SB**: Loads in the memory the low 8 bits value in **RS2** at the address **RS1** + **IMM**.
 - [ ] **SH**: Loads in the memory the low 16 bits value in **RS2** at the address **RS1** + **IMM**.
 
 ### U-Type Instructions
 - [x] **AUIPC**: Loads in the register **RD** the value **IMM** shifted by 12 added to the value stored in the **PC**.
 - [x] **LUI**: Loads in the register **RD** the value **IMM** shifted by 12.
 
 ### B-Type Instructions
 - [x] **BLE**: Takes the branch if register **RS1** is lower or equal to the register **RS2**.
 - [x] **BNE**: Takes the branch if registers **RS1** and **RS2** are not equal.
 - [ ] **BEQ**: Takes the branch if **RS1** is equal to **RS2**.
 - [ ] **BLT**: Takes the branch if **RS1** is less than **RS2**.
 - [ ] **BLTU**: Takes the branch if **RS1** is less than **RS2** (unsigned comparison).
 - [ ] **BGE**: Takes the branch if **RS1** is greater than or equal to **RS2**.
 - [ ] **BGEU**: Takes the branch if **RS1** is greater than or equal to **RS2** (unsigned comparison).
 
 ### J-Type Instructions
 - [x] **JAL**: Performs a jump (increments the **PC** by the value in **IMM**) and stores **PC** + 4 in **RS1**.
 - [x] **J**: Is an alias of **JAL** and performs a jump (**RS1** is set to 0).
 - [x] **RET**: Is an alias of **JALR** and performs a jump in the register **RA** (at the address 1). 

 ### ADDITIONAL
 - [ ] **CSRRW**:
 - [ ] **CSRRS**:
 - [ ] **CSRRC**:
 - [ ] **CSRRWI**:
 - [ ] **CSRRSI**:
 - [ ] **CSRRCI**:

 - [ ] **RDCYCLE**:
 - [ ] **RDTIME**:
 - [ ] **RDINSTRET**:

 - [ ] **ECALL**:
 - [ ] **EBREAK**:

 # RISCV HARTS related

 - [ ] **FENCE**: Used to order device I/O and memory accesses as viewed by other RISC-V harts and external devices or coprocessors.
 - [ ] **FENCE.I**: Provides explicit synchronization between writes to instruction memory and instruction fetches on the same hart.
 - [ ] **WFI**: Provides a hint to the implementation that the current hart can be stalled until an interrupt might need servicing.
 - [ ] **SFENCE.VMA**: Guarantees that any previous stores already visible to the current RISC-V hart are ordered before all subsequent implicit references from that hart to the memory-management data structures.
 
 # RISCV TRAPS related 
 - [ ] **URET**: Return from traps in U-mode, and URET copies UPIE into UIE, then sets UPIE.
 - [ ] **SRET**: Return from traps in S-mode, and SRET copies SPIE into SIE, then sets SPIE.
 - [ ] **MRET**: Return from traps in M-mode, and MRET copies MPIE into MIE, then sets MPIE.
 
 # RISCV32M Instructions:
 - [ ] **MUL**:
 - [ ] **MULH**:
 - [ ] **MULHSU**:
 - [ ] **MULHU**:
 - [ ] **DIV**:
 - [ ] **DIVU**:
 - [ ] **REM**:
 - [ ] **REMU**:
 
 # RISCV32A Instructions:
 - [ ] **lr.w**: Load a word from the address in rs1, places the sign-extended value in rd, and registers a reservation on the memory address. 
 - [ ] **sc.w**: 
 - [ ] **amoswap.w**:
 - [ ] **amoadd.w**: Atomically load a 32-bit signed data value from the address in **RS1**, place the value into register **RD**, apply add the loaded value and the original 32-bit signed value in **RS2**, then store the result back to the address in **RS1**.
 - [ ] **amoadd.w**: 
 - [ ] **amoxor.w**: 
 - [ ] **amoand.w**: 
 - [ ] **amoor.w**: 
 - [ ] **amomin.w**: 
 - [ ] **amomax.w**: 
 - [ ] **amominu.w**: 
 - [ ] **amoaxu.w**: 
 

 
 The architecture is mainly written as Behavioral, with few pieces written in a structural form.

 # Architecture description

 The architecture is composed of a 5 stage pipeline:
 - FETCH
   - Cache Branch
   - Branch Fetch
   - PC (Program Counter)
   - I_FSM0 (Instruction Finite State Machine)
   - SRAM freepdk45
   - ICACHE
   - add_unit1
 - DECODE
    - register_file
    - control (control unit)
    - imm_gen (immediate generator)
 - EXECUTE
    - add_unit (Used to compute the PC jump address)
    - ALUControl
    - ALU
 - MEMORY
 - WRITEBACK

 The architecture is provided with **32 registers** that can be accessed by the CPU.
 The registers goes from 0 to 31, the address length is 5 bits.


 # How to run the simulation

 ```
 cd sim
 vsim -do run_sim.tcl
 ```

 This simulation will execute the DP_TB module inside the tb/testbench.sv.

 In the first phase, the instruction memory will be loaded. Then, the data memory will be loaded. Then, the CPU is started.
 
 At the end, the OK signal is checked. If it is equal to 1, everything went well.