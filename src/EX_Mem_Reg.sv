import my_pkg::*;	

module EX_Mem_Reg (
	input WB_ctrl 		in_WB,
	input M_ctrl 		in_M,
	input reg [31:0] 	in_PC_link,
	input reg [31:0] 	in_PC_jump, 
	input reg [31:0] 	in_PC, 
	input reg 			in_bit_branch, 
	input reg [31:0] 	in_ALU_res, 
	input reg [31:0] 	in_reg_data_2, 
	input reg [4:0] 	in_Rd,
	input reg 		 	in_Rd_EQ0,
	input reg 			clk,
	input reg 			in_P,
	input reg 			rstn,
	input reg 			en,
	output WB_ctrl		out_WB,
	output M_ctrl 		out_M,
	output reg [31:0] 	out_PC_link,
	output reg [31:0] 	out_PC_jump, 
	output reg [31:0] 	out_PC, 
	output reg 			out_bit_branch, 
	output reg [31:0] 	out_reg_data_2, 
	output reg [31:0] 	out_ALU_res, 
	output reg 			out_P,
	output reg [4:0] 	out_Rd,
	output reg 		 	out_Rd_EQ0
); 
always @ (posedge clk) begin
	if(!rstn) begin
		out_WB 		  <= 3'b0;
		out_M.CS 	  <= 1'b1;
		out_M.branch  <= 1'b0;
		out_M.MemRead <= 1'b0;
		out_M.jump    <= 1'b0;
		out_M.AddtoPC <= 1'b0;
		out_PC_link   <= 2'b0;
		out_PC_jump   <= 32'b0;
		out_PC			<= 32'b0;
		out_reg_data_2<= 32'b0;
		out_bit_branch<= 1'b0;
		out_ALU_res   <= 32'b0;
		out_Rd 		  <= 5'b0;
		out_Rd_EQ0	  <= 1'b0;
        out_P		  <= 1'b0;  
	end
	else if(en) begin
		out_WB 		  <= in_WB;
		out_M 		  <= in_M;
		out_PC_link   <= in_PC_link;
		out_PC_jump   <= in_PC_jump;
		out_PC			<= in_PC;
		out_bit_branch<= in_bit_branch;
		out_reg_data_2<= in_reg_data_2;
		out_ALU_res   <= in_ALU_res;
		out_Rd 		  <= in_Rd;
		out_Rd_EQ0	  <= in_Rd_EQ0;
        out_P   	  <= in_P;  
	end
end
endmodule
