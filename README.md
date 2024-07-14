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
 
 - XOR: Performs a XOR operation between **RS1** and **RS2** and store the result in **RD**.
 - ADD: Adds **RS1** and **RS2** and stores the result in **RD**.
 - SUB: Subtracts **RS1** and **RS2** and stores the result in **RD**.
 - ADDI: Adds **RS1** and **IMM** and stores the result in **RD**.
 - LI: Is an alias of **ADDI** that loads the value **IMM** in the register **RD** (**RS1** is set to 0)
 - MV: Is an alias of **ADDI** that loads the value **RS1** in the register **RD** (**IMM** is set to 0)
 - SRAI: Performs an arithmetic right shift on **RS1** equal to the value stored in the lower 5 bits of **IMM**
 - SLLI: Performs an arithmetic left shift on **RS1** equal to the value stored in the lower 5 bits of **IMM**
 - RET: Is an alias of **JALR** performs a jump in the register **RA** (at the address 1)
 - LW: Loads in the register **RD** from the memory at the address **RS1**+**IMM**
 - SW: Loads in the memory the value in **RS2** at the address **RS1**+**IMM** 
 - BLE: Takes the branch if register **RS1** is low or equal at the register **RS2**
 - BNE: Takes the branch if registers **RS1** and **RS2** are not equal
 - AUIPC: Loads in the register **RD** the value **IMM** shifted by 12 added to the value stored in the **PC**
 - LUI: Loads in the register **RD** the value **IMM** shifted by 12
 - JAL: Performs a jump (increment the **PC** by the value in **IMM**) and stores **PC**+4 in **RS1**
 - J: Is an alias of **JAL** and performs a jump (**RS1** is set to 0) 
 
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