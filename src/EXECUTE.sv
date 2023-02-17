import my_pkg::*;
module EXECUTE_Block (
	input CLK, EN, RSTn,

    input EX_ctrl 	EX_in_EX,
	input FU_ctrl_o Forward_o,
	input HAZARD_ctrl_o HAZARD_BP_o,
	
	input [31:0]	EX_in_PC_add,
	input [31:0] 	EX_in_imm,
	input [31:0] 	EX_in_reg_data_2,
    input [31:0] 	EX_in_reg_data_1,
    input [3:0] 	EX_in_ALU_ctrl,

	input [31:0]	WB_Mux_Mux_out,
	output [31:0] 	MEM_in_instr,	
	input [31:0]	MEM_in_ALU_res,

	input [31:0]	EX_in_instr,

	output [31:0] 	EX_PC_jump,
	output [31:0] 	EX_ALUResult,
	output EX_bit_branch	
);

//---------------------- Execution Stage VAR ------------------------//
	wire [31:0]	EX_Mux_ALUIN1;
	wire [31:0]	EX_Mux_ALUIN2;
	wire [31:0] EX_Mux_Mux_ALUIN1;
	wire [31:0] EX_Mux_Mux_ALUIN2;
	wire [31:0] EX_Mux_Mux_Mux_ALUIN1;
	wire [31:0] EX_Mux_Mux_Mux_ALUIN2;
	ALUControl_Enum	EX_ALUControl;
    
	//assign EXECUTE_INSTRUCTION = Instruction_Enum'(EX_in_instr);

// END	

	// Add unit used to calculate PC
	add_unit add_unit1(
	  .op1    (EX_in_PC_add),
	  .op2    ({EX_in_imm[31], EX_in_imm[29:0], 1'b0} ), // Shift Arithmetic Left by 1
	  .result (EX_PC_jump)
	);

	ALUControl alu_control0(
	  .ALUOp        (EX_in_EX.ALUop),
	  .imm_func3    (EX_in_ALU_ctrl),
	  .ALUControl_o (EX_ALUControl)
	);

	// ALU Unit for Arithmetic operations
	ALU alu_unit0(
	  .op1        (EX_Mux_ALUIN1),
	  .op2        (EX_Mux_ALUIN2),
	  //.op2_n	  (~EX_Mux_ALUIN2),
	  .ALUControl (EX_ALUControl),
	  .ALUResult  (EX_ALUResult),
	  .BIT_Branch (EX_bit_branch)
	);

	assign EX_Mux_Mux_Mux_ALUIN1 = (Forward_o.ForwardA[2] == FWA_ALURSLT[2]) ? MEM_in_ALU_res : WB_Mux_Mux_out; 
	assign EX_Mux_Mux_Mux_ALUIN2 = (Forward_o.ForwardB[2] == FWB_ALURSLT[2]) ? MEM_in_ALU_res : WB_Mux_Mux_out; 

	assign EX_Mux_Mux_ALUIN1 = (EX_in_EX.ALUsrc[0] == 1'b1) ? EX_in_PC_add : EX_in_reg_data_1;
	assign EX_Mux_Mux_ALUIN2 = (EX_in_EX.ALUsrc[1] == 1'b1) ? EX_in_imm : EX_in_reg_data_2;

	assign EX_Mux_ALUIN1 = 	(Forward_o.ForwardA[0] == NOFWA[0]) ? EX_Mux_Mux_ALUIN1 : EX_Mux_Mux_Mux_ALUIN1;
	assign EX_Mux_ALUIN2 =	(Forward_o.ForwardB[0] == NOFWB[0]) ? EX_Mux_Mux_ALUIN2 : EX_Mux_Mux_Mux_ALUIN2;
			
	
	flip_flop ex_mem_instr (
			.d(EX_in_instr), 
			.rstn(RSTn & HAZARD_BP_o.Ctrl_Mux_EX), 
			.clk(CLK), 
			.en(EN), 
			.q(MEM_in_instr)
	);

endmodule
