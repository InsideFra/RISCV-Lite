import my_pkg::*;
module MEMORY_Block (
	input CLK, EN, RSTn, START,
	
	input 			TB_LOAD_DATA_CTRL,
	input [9:0]		TB_LOAD_DATA_ADDR,
	input [31:0] 	TB_LOAD_DATA_DATA,

    input [31:0]   	MEM_in_ALU_res,
	input [31:0]	MEM_in_instr,

	input M_ctrl 	MEM_in_M,
	input wire		enable_cs,
    input [31:0]   	MEM_in_reg_data_2,
	
	input 			TEST_EN,
	input 			TEST_MEM_CSB,
	input 			TEST_MEM_WE,

	output [31:0] MEM_mem_data,
	output [31:0] TB_Instr,
 	output reg OK	
);

//---------------------- Memory Stage VAR---------------------------------//
	reg MEM_web0;
	reg MEM_csb0;
	reg [9:0] MEM_addr0;
	reg [31:0] MEM_din0;
	reg [31:0] WB_in_instr;
	//assign MEM_INSTRUCTION = Instruction_Enum'(MEM_in_instr);

//---------------------- Memory Stage VAR END-----------------------------//
	
	assign TB_Instr = WB_in_instr;

	always @ (*) begin
		if (TB_LOAD_DATA_CTRL == 1'b1)
			MEM_web0 = 1'b0;
		else if (TEST_EN == 1'b1)
			MEM_web0 = TEST_MEM_WE;
		else
			MEM_web0 = MEM_in_M.MemRead;
	end
	
	
	always @ (*) begin
		if (TB_LOAD_DATA_CTRL == 1'b1)
			MEM_csb0 = 1'b0;
		else if (TEST_EN == 1'b1)
			MEM_csb0 = TEST_MEM_CSB;
		else if (enable_cs == 1'b1)
			MEM_csb0 = 1'b1;
		else
			MEM_csb0 = MEM_in_M.CS;
	end
	
	always @ (*) begin
		if (TB_LOAD_DATA_CTRL == 1'b1)
			MEM_addr0 = TB_LOAD_DATA_ADDR;
		else if (TEST_EN == 1'b1)
			MEM_addr0 = 10'b1;
		else
			MEM_addr0 = MEM_in_ALU_res[9:0];
	end
	
	always @ (*) begin
		if (TB_LOAD_DATA_CTRL == 1'b1)
			MEM_din0 = TB_LOAD_DATA_DATA;
		else if (TEST_EN == 1'b1)
			MEM_din0 = 32'hFFFFFFFF;
		else
			MEM_din0 = MEM_in_reg_data_2;
	end
	
	//Data memory 	
	sram_32_1024_freepdk45 data_mem0(
	.clk0  (CLK),
	.csb0  (MEM_csb0),
	.web0  (MEM_web0),
 	.addr0 (MEM_addr0),
	.din0  (MEM_din0),
   	.dout0 (MEM_mem_data)
  	);
	
	flip_flop mem_wb_instr (
		.d(MEM_in_instr), 
		.rstn(RSTn), 
		.clk(CLK), 
		.en(EN & START), 
		.q(WB_in_instr)
	);

always @ (*)
	if (MEM_csb0 == 1'b0 & 
		MEM_web0 == 1'b0 & 
		MEM_addr0 == 10'h01c &
		MEM_din0 == 32'h2)
		OK <= 1'b1;
	else 
		OK <= 1'b0;
endmodule
