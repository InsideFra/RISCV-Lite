import my_pkg::*;

module control (
	input  logic [31:0] instruction, // 32-bit instruction
    
	output WB_ctrl WB, 
	output M_ctrl M,
	output EX_ctrl EX 
);

    // Extract fields from the instruction
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];

    always_comb begin
        // Default values
        EX.ALUop = ALU_NOP;	// ALU OP
        EX.ALUsrc = 2'b00; // Default to rs2, rs1
  
		M.branch = 1'b0;	// Branch Instruction
        M.jump = 1'b0;		// Jump signal
        M.MemRead = 1'b0;	// Memory read signal
        M.CS = 1'b1;		// Memory select
        M.AddtoPC = 1'b0;   // TODO
        
		WB.RegWrite = 1'b0;	// Register file write signal
        WB.PCtoReg = 1'b0;	// Program counter will be written into the register
        WB.MemtoReg = 1'b0; // Content from the memory will be written into the register

        case (opcode)
            7'b0110011: begin // R-type instructions
                WB.RegWrite = 1'b1;
                case (funct3)
                    3'b000: EX.ALUop = (funct7 == 7'b0000000) ? ALU_ADD : ALU_SUB;
                    3'b111: EX.ALUop = ALU_AND;
                    3'b110: EX.ALUop = ALU_OR;
                    3'b100: EX.ALUop = ALU_XOR;
                    3'b010: EX.ALUop = ALU_SLT;
                    3'b011: EX.ALUop = ALU_SLTU;
                    3'b001: EX.ALUop = ALU_SLL;
                    3'b101: EX.ALUop = (funct7 == 7'b0000000) ? ALU_SRL : ALU_SRA;
                    default: EX.ALUop = ALU_NOP;
                endcase
            end
            7'b0010011: begin // I-type instructions
                EX.ALUsrc = 2'b10; // imm, rs1
                WB.RegWrite = 1'b1;
                case (funct3)
                    3'b000: EX.ALUop = ALU_ADD;
                    3'b111: EX.ALUop = ALU_AND;
                    3'b110: EX.ALUop = ALU_OR;
                    3'b100: EX.ALUop = ALU_XOR;
                    3'b010: EX.ALUop = ALU_SLT;
                    3'b011: EX.ALUop = ALU_SLTU;
                    3'b001: EX.ALUop = ALU_SLL;
                    3'b101: EX.ALUop = (funct7 == 7'b0000000) ? ALU_SRL : ALU_SRA;
                    default: EX.ALUop = ALU_NOP;
                endcase
            end
            7'b0010111: begin // U-type instructions (AUIPC)
                WB.RegWrite = 1'b1;
                EX.ALUsrc = 2'b11; // imm, pc
                EX.ALUop = ALU_ADD;	// ALU OP
            end
            7'b0110111: begin // U-type instructions (LUI)
                WB.RegWrite = 1'b1;
                EX.ALUsrc = 2'b10; // imm, rs1
                EX.ALUop = ALU_ADD;	// ALU OP
                M.CS = 1'b0;
                M.MemRead = 1'b1;
            end
            7'b1100011: begin // B-type instructions (branch)
                M.branch = 1'b1;
                case (funct3)
                    3'b000: EX.ALUop = ALU_BEQ; // BEQ
                    3'b001: EX.ALUop = ALU_BNE; // BNE
                    3'b100: EX.ALUop = ALU_BLT; // BLT
                    3'b101: EX.ALUop = ALU_BGE; // BGE
                    3'b110: EX.ALUop = ALU_BLTU; // BLTU
                    3'b111: EX.ALUop = ALU_BGEU; // BGEU
                    default: EX.ALUop = ALU_NOP;
                endcase
            end
            7'b1101111: begin // JAL (jump and link)
                M.jump = 1'b1;
                EX.ALUsrc = 2'b11; // imm, pc
                WB.RegWrite = 1'b1;
                EX.ALUop = ALU_ADD;
				WB.PCtoReg=1'b1;
            end
            7'b1100111: begin // JALR (jump and link register)
                M.jump = 1'b1;
                EX.ALUsrc = 2'b10; // imm, rs1
                WB.RegWrite = 1'b1;
                EX.ALUop = ALU_ADD;
				
				WB.PCtoReg=1'b1; 
				M.AddtoPC=1'b1;
            end
            7'b0000011: begin // Load instructions
                EX.ALUsrc = 2'b10; // imm, rs1
                WB.RegWrite = 1'b1;
                WB.MemtoReg = 1'b1;
                M.MemRead = 1'b1;
				M.CS = 1'b0;
                EX.ALUop = ALU_ADD;
            end
            7'b0100011: begin // Store instructions
                EX.ALUsrc = 2'b10; // imm, rs1
                M.CS = 1'b0;
                EX.ALUop = ALU_ADD;
            end
            default: begin
                EX.ALUop = ALU_NOP;
            end
        endcase
    end

    assign EX.branch = M.branch;
	
endmodule
