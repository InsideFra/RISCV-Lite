import my_pkg::*;
module FETCH_Block (
		input 	CLK, RSTn, EN, START,

		input 	HAZARD_ctrl_o 	HAZARD,
		input 					TB_LOAD_PROGRAM_CTRL,
		input 	[31:0] 			TB_LOAD_PROGRAM_DATA,
		input 	[9:0]			TB_LOAD_PROGRAM_ADDR,

		input 	[31:0] 	MEM_in_PC_jump,
		input 	[31:0] 	MEM_in_ALU_res,

		output 		[31:0] 	PC_link,
		output 		[31:0] 	PC_add,
	    output 	reg [31:0] 	instr,
		output 				TEST_EN_OUT,
		output 	FSM_PCSrc
);

//---------------------- Fetch Stage VAR---------------------------------//
	reg [31:0]		PC_Input;
	
	wire [31:0] 	FETCH_BF_data_out; // Target ADD by Cache_Branch
	wire [31:0] 	FETCH_PC_toMUX; // From PC to MUX
	CACHE_BRANCH 	FETCH_in_BF;

	// Instruction Memory Port MAP
	reg 			INSTR_MEM_RE; 	// Instruction Memory Read Enable (== 1 read, else write)
	reg [9:0] 		INSTR_MEM_ADDR;
	reg [31:0] 		INSTR_MEM_DIN;
	reg [31:0] 		INSTR_MEM_DOUT;
	reg 			TEST_EN;

	// FSM Things
	reg 			TEST_MEM_CSB;
	reg 			TEST_MEM_WE;
	reg [9:0] 		TEST_MEM_ADDR;
	reg [31:0] 		TEST_MEM_DATA;
	wire _FSM_PCSrc;
	wire MEM_CSB_OUT;
	wire MEM_WE;
	wire ICACHE_WEn;
	reg TEST_MEM_MUX;
	FSM_Control_Enum FSM_SEL;

	// Cache
	reg enable_PC;
	wire match;
// END

//---------------------- Fetch Stage---------------------------------//

	// keep PC procede in sequence (correct prediction)
	assign PC_add = FETCH_PC_toMUX;
	assign PC_link = FETCH_PC_toMUX + 4;
	assign FSM_PCSrc = _FSM_PCSrc;
	
	always @ (*)
		if (HAZARD.PCSrc == next_pc)
			PC_Input = FETCH_PC_toMUX + 4;
		else if (HAZARD.PCSrc == branch_alu)
			PC_Input = MEM_in_ALU_res;
		else if (HAZARD.PCSrc == branch_pc_jump)
			PC_Input = MEM_in_PC_jump; 
		else if (HAZARD.PCSrc == nop)
			PC_Input = 32'h00000000;
		else
			PC_Input = 32'h00000000;
	

	always @ (*) begin
		enable_PC = HAZARD.En_PC & EN & TEST_EN;
	end

	flip_flop_pc PC0 (
			.d(PC_Input),
			.rstn(RSTn),
			.clk(CLK),
			.en(enable_PC),
			.q(FETCH_PC_toMUX)
	);

	assign MEM_WE = INSTR_MEM_RE;
	assign TEST_MEM_MUX = !TEST_EN;
	assign TEST_EN_OUT = TEST_EN;

	I_FSM I_FSM0(
	  .MEM_WE      (MEM_WE     ),
	  .clk         (CLK        ),
	  .rstn        (RSTn       ),
	  .match       (match      ),
	  .PC_changed  (1'b0),
	  .TEST_MEM_DATA(TEST_MEM_DATA),

	  .FSM_SEL     (FSM_SEL    ),
	  .ICACHE_WEn  (ICACHE_WEn ),
	  .MEM_CSB_OUT (MEM_CSB_OUT),
	  .PCSrc       (_FSM_PCSrc  ),
	  .TEST_EN	   (TEST_EN),     		
	  .TEST_MEM_WE (TEST_MEM_WE)
	);

	always @ (*) begin
		if (TB_LOAD_PROGRAM_CTRL == 1'b1)
			INSTR_MEM_ADDR = TB_LOAD_PROGRAM_ADDR;
		else if (TEST_MEM_MUX == 1'b1)
			INSTR_MEM_ADDR = 10'b1;
		else
			INSTR_MEM_ADDR = FETCH_PC_toMUX[9:0];
	end
	
	always @ (*) begin
		if (TB_LOAD_PROGRAM_CTRL == 1'b1)
			INSTR_MEM_DIN = TB_LOAD_PROGRAM_DATA;
		else if (TEST_MEM_MUX == 1'b1)
			INSTR_MEM_DIN = 32'hFFFFFFFF;
		else
			INSTR_MEM_DIN = 32'b0;
	end
	
	always @ (*) begin
		if (TB_LOAD_PROGRAM_CTRL == 1'b1)
			INSTR_MEM_RE = 1'b0;
		else if (TEST_MEM_MUX == 1'b1)
			INSTR_MEM_RE = TEST_MEM_WE;
		else
			INSTR_MEM_RE = 1'b1;
	end

	sram_32_1024_freepdk45 instr_mem0(
   		.clk0  (CLK),
   		.csb0  (MEM_CSB_OUT),
   		.web0  (INSTR_MEM_RE),
   		.addr0 (INSTR_MEM_ADDR),
   		.din0  (INSTR_MEM_DIN),
   		.dout0 (INSTR_MEM_DOUT)
  	);

	assign TEST_MEM_DATA = INSTR_MEM_DOUT;

	wire [31:0] data_cache_out;

	ICACHE ICACHE0(
	  .offset         (FETCH_PC_toMUX[5:2]),
	  .TAG_in         (FETCH_PC_toMUX[9:6]),
	  .write_enable_n (ICACHE_WEn	 ),
	  .write_data     (instr		 ),
	  .RSTn           (RSTn          ),
	  //.RSTn           (1'b0          ),
	  .CLK            (CLK           ),
	  .EN			  (EN & TEST_EN),
	  //.EN			  (1'b0			 ),
	  .match          (match         ),
	  .data           (data_cache_out)
	);

	always @ (*) begin
		if (!HAZARD.En_IFID & !RSTn)
			instr = 32'b0;
		else if (match == 1'b1)
			instr = data_cache_out;
		else if (FSM_SEL == NOP)
			instr = 32'b0;
		else if (FSM_SEL == IMEM)
			instr = INSTR_MEM_DOUT;
		else
			instr = 32'b0;
	end

	//assign instr = INSTR_MEM_DOUT;

// END

endmodule
