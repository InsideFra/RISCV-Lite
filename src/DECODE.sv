import my_pkg::*;
module DECODE_Block (
	input CLK, EN, RSTn, START,

	input [31:0] ID_in_instr,
	input [4:0]	 WB_in_Rd,
	input [31:0] WB_Mux_Mux_out,
	input HAZARD_ctrl_o HAZARD_BP_o,
	input WB_ctrl	WB_in_WB,

	output WB_ctrl	ID_in_WB,
	output M_ctrl 	ID_in_M,
	output EX_ctrl	ID_in_EX,
	output [31:0] 	ID_imm,
	output [31:0] 	ID_reg_data_1,
	output [31:0] 	ID_reg_data_2,
	output [4:0] 	ID_Rs1,
	output 			ID_sel_mux,
	// testbench
	output [31:0] 	EX_in_instr,
	// end testbench
	output 			ID_Rd_EQ0
);

//---------------------- Decode Stage VAR---------------------------------//
	
	wire 		ID_RegWrite;
	wire [6:0] 	ID_opcode;
	WB_ctrl 	ID_WB_c;
	M_ctrl 		ID_M_c;
	EX_ctrl 	ID_EX_c;
	
	reg [4:0] MUX_ID_Rs1;
	reg [31:0] ID_reg_data_1_BM, ID_reg_data_2_BM; // Before Mux
	
	reg [4:0] ID_Rs2;	
	reg [4:0] ID_Rd;
	reg [3:0] ID_in_ALU_ctrl;
	//assign DECODE_INSTRUCTION = Instruction_Enum'(ID_in_instr);

//END

	assign ID_Rs2 = ID_in_instr [24:20];
	assign ID_Rd  = ID_in_instr [11:7];
	assign ID_in_ALU_ctrl = {ID_in_instr[30], ID_in_instr[14:12]};
	
	assign MUX_ID_Rs1 = ID_in_instr[6:2] == 5'b01101 ? 5'b0 : ID_in_instr [19:15];
	assign ID_Rs1 = MUX_ID_Rs1;

	assign ID_reg_data_1 = (ID_Rs1 == 5'b00000) ? 32'h00000000 : 
						((ID_Rs1 == WB_in_Rd) ? WB_Mux_Mux_out : ID_reg_data_1_BM);
	
	assign ID_reg_data_2 = (ID_Rs2 == 5'b00000) ? 32'h00000000 :
						((ID_Rs2 == WB_in_Rd) ? WB_Mux_Mux_out : ID_reg_data_2_BM);

	assign ID_Rd_EQ0 = (ID_Rd == 5'b00000) ? 1'b0 : 1'b1;

	assign ID_RegWrite = WB_in_WB.RegWrite;
	register_file ID_RF (
           .rs1(ID_Rs1),
           .rs2(ID_Rs2), 
           .rd(WB_in_Rd),  
           .write_data(WB_Mux_Mux_out), 
           .RegWrite(WB_in_WB.RegWrite),
           .RSTn(RSTn),
           .clk(CLK),
		   .en(EN & START),
           .read_data1(ID_reg_data_1_BM),
           .read_data2(ID_reg_data_2_BM)
	);					
	
	assign ID_opcode = ID_in_instr [6:0];
	control ID_CRTL (.opcode(ID_opcode), .WB(ID_WB_c), .M(ID_M_c), .EX(ID_EX_c));

	imm_gen ID_IG (.instruction_i(ID_in_instr), .immediate_o(ID_imm));

	assign ID_in_WB = ID_WB_c;
	assign ID_in_M = ID_M_c;
	assign ID_in_EX = ID_EX_c;

	assign ID_sel_mux = HAZARD_BP_o.Ctrl_Mux_DE;
	
	// testbench - can be deleted 
	flip_flop id_ex_instr (
			.d(ID_in_instr), 
			.rstn(RSTn & ID_sel_mux), 
			.clk(CLK), 
			.en(EN), 
			.q(EX_in_instr)
	);
	// end
	
endmodule
