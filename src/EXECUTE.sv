import my_pkg::*; // Import the package my_pkg which likely contains definitions for control signals and other modules.

module EXECUTE_Block (
    input CLK,        // Clock signal
    input EN,         // Enable signal
    input RSTn,       // Reset signal (active low)

    input EX_ctrl EX_in_EX,           // Execute control signals input
    input FU_ctrl_o Forward_o,        // Forwarding control signals
    input HAZARD_ctrl_o HAZARD_BP_o,  // Hazard control and bypass control signals

    input [31:0] EX_in_PC_add,        // PC address input
    input [31:0] EX_in_imm,           // Immediate value input
    input [31:0] EX_in_reg_data_2,    // Register data 2 input
    input [31:0] EX_in_reg_data_1,    // Register data 1 input
    input [3:0] EX_in_ALU_ctrl,       // ALU control input

    input [31:0] WB_Mux_Mux_out,      // Write-back MUX output
    output [31:0] MEM_in_instr,       // Instruction output for MEM stage
    input [31:0] MEM_in_ALU_res,      // ALU result input from MEM stage

    input [31:0] EX_in_instr,         // Instruction input for EX stage

    output [31:0] EX_PC_jump,         // PC jump address output
    output [31:0] EX_ALUResult,       // ALU result output
    output EX_bit_branch              // Branch bit output
);

//---------------------- Execution Stage VAR ------------------------//
    wire [31:0] EX_Mux_ALUIN1;       // ALU input 1 after MUX
    wire [31:0] EX_Mux_ALUIN2;       // ALU input 2 after MUX
    wire [31:0] EX_Mux_Mux_ALUIN1;   // Intermediate ALU input 1 after MUX
    wire [31:0] EX_Mux_Mux_ALUIN2;  // Intermediate ALU input 2 after MUX
    wire [31:0] EX_Mux_Mux_Mux_ALUIN1; // Final ALU input 1 after MUX
    wire [31:0] EX_Mux_Mux_Mux_ALUIN2; // Final ALU input 2 after MUX
    ALUControl_Enum EX_ALUControl;  // ALU control signals

    // Assigns instruction for the EXECUTE stage (can be uncommented if needed)
    // assign EXECUTE_INSTRUCTION = Instruction_Enum'(EX_in_instr);

// END    

    // Add unit to calculate PC jump address
    add_unit add_unit1(
        .op1    (EX_in_PC_add),                                 // PC address
        .op2    ({EX_in_imm[31], EX_in_imm[29:0], 1'b0}),       // Immediate value shifted left by 1
        .result (EX_PC_jump)                                    // PC jump address output
    );

    // ALU control unit to generate control signals for the ALU
    ALUControl alu_control0(
        .ALUOp        (EX_in_EX.ALUop),       // ALU operation control signal
        .imm_func3    (EX_in_ALU_ctrl),       // Immediate function control signal
        .ALUControl_o (EX_ALUControl)         // ALU control signals output
    );

    // ALU unit for arithmetic and logical operations
    ALU alu_unit0(
        .op1        (EX_Mux_ALUIN1),      // ALU input 1
        .op2        (EX_Mux_ALUIN2),      // ALU input 2
        //.op2_n    (~EX_Mux_ALUIN2),     // (optional) ALU input 2 negated (if needed)
        .ALUControl (EX_ALUControl),      // ALU control signals
        .ALUResult  (EX_ALUResult),       // ALU result output
        .BIT_Branch (EX_bit_branch)       // Branch bit output
    );

    // Forwarding logic to handle data hazards
    assign EX_Mux_Mux_Mux_ALUIN1 = (Forward_o.ForwardA[2] == FWA_ALURSLT[2]) ? MEM_in_ALU_res : WB_Mux_Mux_out; 
    assign EX_Mux_Mux_Mux_ALUIN2 = (Forward_o.ForwardB[2] == FWB_ALURSLT[2]) ? MEM_in_ALU_res : WB_Mux_Mux_out; 

    // Select ALU inputs based on ALU source control signals
    assign EX_Mux_Mux_ALUIN1 = (EX_in_EX.ALUsrc[0] == 1'b1) ? EX_in_PC_add : EX_in_reg_data_1;
    assign EX_Mux_Mux_ALUIN2 = (EX_in_EX.ALUsrc[1] == 1'b1) ? EX_in_imm : EX_in_reg_data_2;

    // Final MUX selection for ALU inputs
    assign EX_Mux_ALUIN1 = (Forward_o.ForwardA[0] == NOFWA[0]) ? EX_Mux_Mux_ALUIN1 : EX_Mux_Mux_Mux_ALUIN1;
    assign EX_Mux_ALUIN2 = (Forward_o.ForwardB[0] == NOFWB[0]) ? EX_Mux_Mux_ALUIN2 : EX_Mux_Mux_Mux_ALUIN2;
    
    // Flip-flop to latch instruction for the MEM stage
    flip_flop ex_mem_instr (
        .d(EX_in_instr), 
        .rstn(RSTn & HAZARD_BP_o.Ctrl_Mux_EX), // Reset signal with hazard control
        .clk(CLK), 
        .en(EN), 
        .q(MEM_in_instr)  // Instruction output for MEM stage
    );

endmodule