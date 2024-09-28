import my_pkg::*;
module FETCH_Block (
		input 	CLK, RSTn, EN, START,

		input	[31:0]	INSTR_MEM_DOUT,

		input 	HAZARD_ctrl_o 	HAZARD,

		input 	[31:0] 	MEM_in_PC_jump,
		input 	[31:0] 	MEM_in_ALU_res,

		input FSM_SEL,
		input TEST_EN,

		input [31:0] xepc_value,

		output 	[31:0] 	PC_link,
		output 	[31:0] 	PC_add,
	    output 	reg [31:0] 	instr,
		output	PC_Changed
);

//---------------------- Fetch Stage VAR---------------------------------//
	reg [31:0] PC_Input;
	reg [31:0] FETCH_PC_toMUX; // From PC to MUX

	reg enable_PC;

	reg _PC_Changed;
//	reg [31:0] instr;
// END

//---------------------- Fetch Stage---------------------------------//

	// keep PC procede in sequence (correct prediction)
	assign PC_add = FETCH_PC_toMUX;
	assign PC_link = FETCH_PC_toMUX + 4;

	always @ (*)
		if (HAZARD.PCSrc == next_pc) begin
			PC_Input <= FETCH_PC_toMUX + 4;
			_PC_Changed <= 1'b0;
		end
		else if (HAZARD.PCSrc == branch_alu) begin
			PC_Input <= MEM_in_ALU_res;
			_PC_Changed <= 1'b1;
		end
		else if (HAZARD.PCSrc == branch_pc_jump) begin
			PC_Input <= MEM_in_PC_jump;
			_PC_Changed <= 1'b1;
		end
		else if (HAZARD.PCSrc == trap_illegal) begin
			PC_Input <= 32'h0;
			_PC_Changed <= 1'b1;
		end
		else if (HAZARD.PCSrc == xepc) begin
			PC_Input <= xepc_value + 4;
			_PC_Changed <= 1'b1;
		end
		else if (HAZARD.PCSrc == Z) begin
			PC_Input <= 32'bz;
			_PC_Changed <= 1'b0;
		end
		else begin
			PC_Input <= 32'bx;
			_PC_Changed <= 1'b0;
		end


	always @ (*) begin
		enable_PC = HAZARD.En_PC & EN & TEST_EN;
	end

	// PC
	always @ (posedge CLK) begin
		if(!RSTn)
			FETCH_PC_toMUX <= 32'h400000;
		else if (enable_PC == 1'b1)
			FETCH_PC_toMUX <= PC_Input;
		else
			FETCH_PC_toMUX <= FETCH_PC_toMUX;
	end

	always @ (*) begin
		if (!HAZARD.En_IFID & !RSTn)
			instr = 32'b0;
		else if (FSM_SEL == 1'b1)
			instr = 32'b0;
		else if (FSM_SEL == 1'b0)
			instr = INSTR_MEM_DOUT;
		else
			instr = 32'b0;
	end

	assign PC_Changed = _PC_Changed;

// END
endmodule
