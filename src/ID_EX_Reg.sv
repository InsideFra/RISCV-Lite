import my_pkg::*;

module ID_EX_Reg (
	input WB_ctrl 		in_WB,
	input M_ctrl 		in_M,
	input EX_ctrl 		in_EX,
	input reg [31:0] 	in_PC_link,
	input reg [31:0] 	in_PC_add, 
	input reg [31:0] 	in_imm,
	input reg [31:0]	in_reg_data_1,	
	input reg [31:0]	in_reg_data_2,	
	input reg [3:0] 	in_ALU_ctrl,
	input reg [4:0]		in_Rd,
	input reg [4:0] 	in_Rs1,
	input reg [4:0] 	in_Rs2,
	input reg			in_Rd_EQ0,
	input reg 			in_P,
	input reg 			clk,
	input reg 			rstn,
	input reg 			en,
	output WB_ctrl 		out_WB,
	output M_ctrl		out_M,
	output EX_ctrl 		out_EX,
	output reg [31:0] 	out_PC_link,
	output reg [31:0] 	out_PC_add, 
	output reg [31:0] 	out_imm, 
	output reg [31:0]	out_reg_data_1,	
	output reg [31:0]	out_reg_data_2,	
	output reg [3:0] 	out_ALU_ctrl,
	output reg 			out_P,
	output reg [4:0] 	out_Rd,
	output reg [4:0] 	out_Rs1,
	output reg [4:0] 	out_Rs2,
	output reg 			out_Rd_EQ0		
); 
always @ (posedge clk) begin
	if(!rstn) begin
		out_WB			<= 3'b0;
		out_M.CS 	    <= 1'b1;
		out_M.branch    <= 1'b0;
		out_M.MemRead   <= 1'b0;
		out_M.jump      <= 1'b0;
		out_M.AddtoPC   <= 1'b0;
        out_EX			<= 4'b0;
        out_PC_link		<= 32'b0;
        out_PC_add 		<= 32'b0;
        out_imm			<= 32'b0;
        out_reg_data_1	<= 32'b0;
        out_reg_data_2	<= 32'b0;
        out_ALU_ctrl	<= 4'b0;
        out_Rd			<= 5'b0;
        out_Rd_EQ0		<= 5'b0;
        out_P			<= 5'b0;
        out_Rs1			<= 5'b0;
        out_Rs2       	<= 5'b0;
	end
	else if(en) begin
		out_WB			<=in_WB		;  
        out_M			<=in_M		    ; 
        out_EX			<=in_EX		;  
        out_PC_link		<=in_PC_link	;  
        out_PC_add 		<=in_PC_add 	;  
        out_reg_data_1	<=in_reg_data_1;
        out_reg_data_2	<=in_reg_data_2;
        out_imm			<=in_imm		;  
        out_ALU_ctrl	<=in_ALU_ctrl  ;
        out_Rd			<=in_Rd;  
        out_Rd_EQ0		<=in_Rd_EQ0;  
        out_P			<=in_P;  
        out_Rs1			<=in_Rs1;  
        out_Rs2       	<=in_Rs2;
	end
end
endmodule
