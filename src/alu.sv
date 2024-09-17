`timescale 1 ns / 100 ps
import my_pkg::*;

module ALU (input wire [31:0] op1, 
			input wire [31:0] op2,
			//input wire [31:0] op2_n, 
			input alu_ops_t ALUControl,
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
	
	wire [31:0] AND_Result;
	assign AND_Result = op1 & op2;

	wire [31:0] SRA_Result;
	assign SRA_Result = $signed(op1) >>> op2;
	
	wire [31:0] SLT_Result;
	assign SLT_Result = ($signed(op1) < $signed(op2)) ? 32'b1 : 32'b0;
	
	wire [31:0] SLTU_Result;
	assign SLTU_Result = ($unsigned(op1) < $unsigned(op2)) ? 32'b1 : 32'b0; // SLTU

	wire [31:0] SLLI_Result;
	assign SLLI_Result = op1 << op2;
	
	wire [31:0] SRL_Result;
	assign SRL_Result = op1 >> op2;
	
	wire [31:0] OR_Result;
	assign OR_Result = op1 | op2;
	
	always_comb begin
		BIT_Branch = 1'b0;
		ALUResult = 32'h0; 
		
		case (ALUControl)
			ALU_ADD: begin
				ALUResult = ADD_Result; 
			end
			ALU_SUB: begin
				ALUResult = SUB_Result;
			end
			ALU_AND: begin
		    	ALUResult = AND_Result;	
			end
			ALU_OR: begin
		    	ALUResult = OR_Result;	
			end
			ALU_XOR: begin
		    	ALUResult = XOR_Result;	
			end
			ALU_SLL: begin
				ALUResult = SLLI_Result;
				assert (op2 >= 0 && op2 <= 32) else $error("[ALU] SLL: op2 out of range %d", op2);
				// $display("[ALU] SLL: Input: %h, Shift Amount: %h, Output: %h", op1, op2, SLLI_Result);
			end
			ALU_SRL: begin
				ALUResult = SRL_Result;
				assert (op2 >= 0 && op2 <= 32) else $error("[ALU] SRL: op2 out of range %d", op2);
				// $display("[ALU] SRL: Input: %h, Shift Amount: %h, Output: %h", op1, op2, SRL_Result);
			end
			ALU_SRA: begin
				ALUResult = SRA_Result;
			end
			ALU_SLT: begin
				ALUResult = SLT_Result;
			end
			ALU_SLTU: begin
				ALUResult = SLTU_Result;
			end
			ALU_BEQ: begin
				BIT_Branch = (op1 == op2);
			end
			ALU_BNE: begin
				BIT_Branch = (op1 != op2);
			end
			ALU_BLT: begin
				BIT_Branch = ($signed(op1) < $signed(op2));
			end
			ALU_BGE: begin
				BIT_Branch = ($signed(op1) > $signed(op2));
			end
			ALU_BLTU: begin
				BIT_Branch = ($unsigned(op1) < $unsigned(op2));
			end
			ALU_BGEU: begin
				BIT_Branch = ($unsigned(op1) > $unsigned(op2));
			end
		endcase
	end
endmodule
