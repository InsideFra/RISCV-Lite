`timescale	1 ns/100 ps
import my_pkg::*;

module imm_gen (input reg [31:0] instruction_i, 
 		output reg [31:0] immediate_o
);

 reg [4:0] op_code; 
 reg [2:0] func_3;

  assign op_code = instruction_i[6:2];
  assign func_3 = instruction_i[14:12];	

always@(op_code, func_3, instruction_i) begin

	if(op_code == 5'b01101) begin							//lui
		immediate_o = {instruction_i[31:12], 12'b0};
	end
	else if(op_code == 5'b00101) begin 	            	//auipc
		immediate_o = {instruction_i[31:12], 12'b0};  
   	end
	else if(op_code == 5'b01000 && func_3 == 3'b010) begin 	//sw
		immediate_o = {instruction_i[31] ? 20'hFFFFF : 20'b0, instruction_i[31:25], instruction_i[11:7]};
	end
	else if(op_code == 5'b00100 && func_3 == 3'b001)begin     //slli
		immediate_o = {instruction_i[31] ? 27'hFFFFFFF : 27'b0, instruction_i[24:20]};
	end 
	else if(op_code == 5'b00100 && func_3 == 3'b101) begin 	//srai
		immediate_o = {instruction_i[31] ? 27'hFFFFFFF : 27'b0, instruction_i[24:20]};
	end
	else if(op_code == 5'b00100 && func_3 == 3'b000) begin    //addi
		immediate_o = {instruction_i[31] ? 20'hFFFFF : 20'b0, instruction_i[31:20]};
	end 
	else if(op_code == 5'b00000 && func_3 ==  3'b010) begin	//lw
		immediate_o = {instruction_i[31] ? 20'hFFFFF : 20'b0, instruction_i[31:20]};
	end
	else if(op_code == 5'b11001 && func_3 == 3'b000) begin	//jarl
		immediate_o = {instruction_i[31] ? 20'hFFFFF : 20'b0, instruction_i[31:20]};
	end
	else if(op_code == 5'b11011) begin						//jal
		immediate_o = {instruction_i[31] ? 12'hFFF : 12'b0, instruction_i[31], instruction_i[19:12], instruction_i[20], instruction_i[30:21]};
	end
	else if (op_code == 5'b11000) begin	//bne
		immediate_o = {instruction_i[31] ? 20'hFFFFF : 20'b0, instruction_i[31], instruction_i[7], instruction_i[30:25], instruction_i[11:8]};
	end else 
		immediate_o = 0;
	end

endmodule
