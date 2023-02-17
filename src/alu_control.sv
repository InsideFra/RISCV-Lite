import my_pkg::*;

module ALUControl (
	input ALUOP_Enum ALUOp,
	input  bit [3:0] imm_func3,
	output ALUControl_Enum ALUControl_o	
);
		always @ (ALUOp, imm_func3) begin
			case (ALUOp)
					DOADD: begin
							ALUControl_o = ADD;
					end
					TAKE4BIT: begin
							ALUControl_o = ALUControl_Enum'(imm_func3);
					end
					TAKE3BIT: begin
							ALUControl_o = ALUControl_Enum'({1'b0, imm_func3[2:0]});
					end
					BRANCH: begin
							ALUControl_o = ALUControl_Enum'({1'b1, imm_func3[2:0]});
					end
					//default: ALUControl_o = 4'b0000; // Not needed because we already cover
					//	all the possible combination of ALUOp
			endcase
		end
endmodule

module ALUControl_TB;
		ALUOP_Enum ALUOp;
		bit [3:0] imm_func3;
		reg [3:0] ALUControl_o;
		ALUControl aluc_uut (
    		.ALUOp        (ALUOp       ),
    		.imm_func3    (imm_func3   ),
    		.ALUControl_o (ALUControl_o)
);
endmodule
