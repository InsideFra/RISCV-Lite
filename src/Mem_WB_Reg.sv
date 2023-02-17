import my_pkg::*;	

module Mem_WB_Reg (
	input WB_ctrl 		in_WB,
	input reg [31:0] 	in_PC_link,
	input reg [31:0] 	in_mem_data, 
	input reg [31:0] 	in_ALU_res, 
	input reg [4:0] 	in_Rd,
	input reg  			in_Rd_EQ0,
	input reg 			clk,
	input reg 			rstn,
	input reg 			en,
	output WB_ctrl		out_WB,
	output reg [31:0] 	out_PC_link,
	output reg [31:0] 	out_ALU_res, 
	output reg [31:0] 	out_mem_data, 
	output reg [4:0] 	out_Rd,
	output reg  		out_Rd_EQ0
); 
always @ (posedge clk) begin
	if(!rstn) begin
		out_WB 		  <= 3'b0;
		out_PC_link   <= 2'b0;
		out_ALU_res   <= 32'b0;
		out_mem_data  <= 32'b0;
		out_Rd 		  <= 5'b0;
		out_Rd_EQ0 	  <= 1'b0;
	end
	else if(en) begin
		out_WB 		  <= in_WB;
		out_PC_link   <= in_PC_link;
		out_ALU_res   <= in_ALU_res;
		out_mem_data  <= in_mem_data;
		out_Rd 		  <= in_Rd;
		out_Rd_EQ0 	  <= out_Rd_EQ0;
	end
	else begin
		out_WB 		  <= out_WB;
		out_PC_link   <= out_PC_link;
		out_ALU_res   <= out_ALU_res;
		out_mem_data  <= out_mem_data;
		out_Rd 		  <= out_Rd;
		out_Rd_EQ0 	  <= out_Rd_EQ0;
	end
end
endmodule
