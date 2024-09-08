import my_pkg::*;

module control (
	input  wire [6:0] opcode,
	output WB_ctrl WB, 
	output M_ctrl M,
	output EX_ctrl EX 
);

always @ (opcode) begin
	WB.RegWrite = 1'b0; 
	WB.PCtoReg  = 1'b0; 
	WB.MemtoReg = 1'b0; 
	M.MemRead   = 1'b0;
	M.CS        = 1'b1;
	M.branch    = 1'b0;
	M.jump      = 1'b0;
	M.AddtoPC   = 1'b0;
	EX.ALUsrc   = 2'b00;
	EX.ALUop    = DOADD; 

	case(opcode) // opcode is Bit [6:0]
		7'b0110111:begin WB.RegWrite=1'b1; EX.ALUsrc=2'b10; end 	
		7'b0010111:begin WB.RegWrite=1'b1; EX.ALUsrc=2'b11; end	
		7'b0100011:begin EX.ALUsrc=2'b10; M.CS=1'b0; end	
		7'b0110011:begin WB.RegWrite=1'b1; EX.ALUop=TAKE4BIT; end	
		7'b0010011:begin WB.RegWrite=1'b1; EX.ALUsrc=2'b10; EX.ALUop=TAKE3BIT; end	
		7'b0000011:begin WB.RegWrite=1'b1; WB.MemtoReg=1'b1; M.MemRead=1'b1; M.CS=1'b0; EX.ALUsrc=2'b10; end	
		7'b1100111:begin WB.RegWrite=1'b1; WB.PCtoReg=1'b1; M.AddtoPC=1'b1; M.jump=1'b1; EX.ALUsrc=2'b10; end	
		7'b1101111:begin WB.RegWrite=1'b1; WB.PCtoReg=1'b1; M.jump=1'b1; end	
		7'b1100011:begin M.branch=1'b1; EX.ALUop=BRANCH; end
	endcase
end
endmodule

