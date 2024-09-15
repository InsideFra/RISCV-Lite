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
    input [3:0]		imm_funct,

	input [31:0]	WB_Mux_Mux_out,
	output [31:0] 	MEM_in_instr,	
	input [31:0]	MEM_in_ALU_res,

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
    
// END	

	// Add unit used to calculate PC
	wire [31:0] add_uni_op2 = {EX_in_imm[31], EX_in_imm[29:0], 1'b0};
	add_unit add_unit1(
	  .op1    (EX_in_PC_add),
	  .op2    (add_uni_op2), // Shift Arithmetic Left by 1
	  .result (EX_PC_jump)
	);

	// ALU Unit for Arithmetic operations
	ALU alu_unit0(
	  .op1        (EX_Mux_ALUIN1),
	  .op2        (EX_Mux_ALUIN2),
	  .ALUControl (EX_in_EX.ALUop),
	  
	  .ALUResult  (EX_ALUResult),
	  .BIT_Branch (EX_bit_branch)
	);
	
	always @(posedge CLK) begin
		if ( (EN) & (RSTn)) begin
			if (EX_in_PC_add != 32'h0) begin
				// $display("[ALU 	PC: %h] op1: %h\t\top2: %h\t\tALUOp: %s\t\tResult: %h", EX_in_PC_add, EX_Mux_ALUIN1, EX_Mux_ALUIN2, EX_in_EX.ALUop.name(), EX_ALUResult);
				// $display("[ADD 	PC: %h] op2: %h, Result: %h", EX_in_PC_add, add_uni_op2, EX_PC_jump);
				// $display("[FWD 	PC: %h] FWA: %s, FWB: %s"	, EX_in_PC_add, Forward_o.ForwardA.name(), Forward_o.ForwardB.name());
			end
		end
	end

	assign EX_Mux_Mux_Mux_ALUIN1 = (Forward_o.ForwardA == FWA_ALURSLT) ? MEM_in_ALU_res : WB_Mux_Mux_out; 
	assign EX_Mux_Mux_Mux_ALUIN2 = (Forward_o.ForwardB == FWB_ALURSLT) ? MEM_in_ALU_res : WB_Mux_Mux_out; 

	assign EX_Mux_Mux_ALUIN1 = (EX_in_EX.ALUsrc[0] == 1'b1) ? EX_in_PC_add 	: EX_in_reg_data_1;
	assign EX_Mux_Mux_ALUIN2 = (EX_in_EX.ALUsrc[1] == 1'b1) ? EX_in_imm 	: EX_in_reg_data_2;

	assign EX_Mux_ALUIN1 = 	(Forward_o.ForwardA == NOFWA) ? EX_Mux_Mux_ALUIN1 : EX_Mux_Mux_Mux_ALUIN1;
	assign EX_Mux_ALUIN2 =	(Forward_o.ForwardB == NOFWB) ? EX_Mux_Mux_ALUIN2 : EX_Mux_Mux_Mux_ALUIN2;
			
endmodule
