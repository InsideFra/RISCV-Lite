import my_pkg::*;
module MEMORY_Block #(
	parameter MEM_ADDR_SIZE = 10,
	parameter MEM_DATA_SIZE = 32
)(
	input 	CLK,
	input	EN,
	input	RSTn,
	input 	START,

    input 	[31:0]	MEM_in_ALU_res,
	input 	[31:0]	MEM_in_instr,

	input 	M_ctrl 	MEM_in_M,
	input 	wire	enable_cs,
    input 	[31:0] 	MEM_in_reg_data_2,

	output 	reg	MEM_csb0,
	output	reg	MEM_web0,
	output 	reg [MEM_ADDR_SIZE-1:0] MEM_addr0,
	output 	reg	[MEM_DATA_SIZE-1:0]	MEM_din0,

 	output reg OK
);

//---------------------- Memory Stage VAR---------------------------------//
	reg [31:0] WB_in_instr;
//---------------------- Memory Stage VAR END-----------------------------//

	assign TB_Instr = WB_in_instr;

	always @ (*) begin
		MEM_web0 = ~MEM_in_M.MemRead;
	end


	always @ (*) begin
		if (enable_cs == 1'b1)
			MEM_csb0 = 1'b1;
		else
			MEM_csb0 = ~MEM_in_M.CS;
	end

	always @ (*) begin
		MEM_addr0 = {MEM_in_ALU_res[8:0]};
	end

	always @ (*) begin
		MEM_din0 = MEM_in_reg_data_2;
	end

	//Data memory
	// blk_mem_gen_1 data_mem0(
	// .clka  	(CLK),
	// .ena  	(MEM_csb0),
	// .wea  	(MEM_web0),
 	// .addra 	(MEM_addr0),
	// .dina  	(MEM_din0),
   	// .douta 	(MEM_mem_data)
  	// );

	always @ (posedge CLK) begin
	if(!RSTn)
		WB_in_instr <= 32'b0;
	else if (EN & START == 1'b1)
		WB_in_instr <= MEM_in_instr;
	else
		WB_in_instr <= WB_in_instr;
	end

always @ (CLK)
	if (MEM_csb0 == 1'b1 &
		MEM_web0 == 1'b1 &
		MEM_addr0 == 9'h038 &
		MEM_din0 == 32'h000000002)
		OK <= 1'b1;
	else
		OK <= 1'b0;
endmodule
