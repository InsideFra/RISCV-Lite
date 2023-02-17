`timescale 1 ns / 100 ps
import my_pkg::*;

module ALU (input wire [31:0] op1, 
			input wire [31:0] op2,
			//input wire [31:0] op2_n, 
			input ALUControl_Enum ALUControl,
			output reg [31:0] ALUResult, 
			output reg BIT_Branch
);

	wire [31:0] ADD_Result;
	assign ADD_Result = op1 + op2;

	wire [31:0] XOR_Result;
	assign XOR_Result = op1 ^ op2;

	wire [31:0] SUB_Result;
	//assign SUB_Result = op1 + !op2 + 1'b1;
	assign SUB_Result = op1 - op2;

	wire [31:0] SRAI_Result;
	assign SRAI_Result = $signed(op1) >>> 31;

	wire [31:0] SLLI_Result;
	assign SLLI_Result = op1 << 2;
	
	always @ (op1, op2, ALUControl) begin
		case (ALUControl)
			ADD: begin
				ALUResult = ADD_Result; 
				BIT_Branch = 1'b0;
			end
			XOR: begin
		    	ALUResult = XOR_Result;	
				BIT_Branch = 1'b0;
			end
			SUB: begin
				ALUResult = SUB_Result;
				BIT_Branch = 1'b0;
			end
			SLL: begin
				ALUResult = SLLI_Result;
				BIT_Branch = 1'b0;
			end
			SRA: begin
				ALUResult = SRAI_Result;
				BIT_Branch = 1'b0;
			end
			BNE: begin
				ALUResult = SUB_Result; 
				BIT_Branch = (op1 != op2);
			end
			BLE: begin
				ALUResult = SUB_Result;
				BIT_Branch = (op1 >= op2);
			end
			default : begin
				ALUResult = SUB_Result;
				BIT_Branch = 1'b0;
			end
		endcase
	end
endmodule
