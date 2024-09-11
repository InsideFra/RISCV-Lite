import my_pkg::*;
module DataPath (
	input reg 			TB_LOAD_PROGRAM_CTRL,
	input reg [9:0] 	TB_LOAD_PROGRAM_ADDR,
	input reg [31:0]	TB_LOAD_PROGRAM_DATA,
	input reg 			TB_LOAD_DATA_CTRL,
	input reg [9:0] 	TB_LOAD_DATA_ADDR,
	input reg [31:0]	TB_LOAD_DATA_DATA,
	input reg 			CLK, 	// General Architecture Clock
	input reg 			EN,		// General Architecture Enable
	input reg 			START,	// General Architecture Start
	input reg 			RSTn, 	// General Architecture Reset Signal
	output reg 			OK,
	output reg [31:0] 	TB_Instr
);

//---------------------- General Unit VAR---------------------------------//

	//Instruction_Enum FETCH_INSTRUCTION;
	//Instruction_Enum DECODE_INSTRUCTION;
	//Instruction_Enum EXECUTE_INSTRUCTION;
	//Instruction_Enum MEM_INSTRUCTION;
	//Instruction_Enum WB_INSTRUCTION;

// END

//---------------------- Hazard Control Unit VAR ---------------------//
	HAZARD_ctrl_o HAZARD_o;
	HAZARD_ctrl_i HAZARD_i;
//---------------------- Hazard Control Unit VAR END -----------------//

//---------------------- Forward Control Unit VAR---------------------//
	
	FU_ctrl_i Forward_i;
	FU_ctrl_o Forward_o;
  
//---------------------- Forward Control Unit VAR END ----------------//

//---------------------- WB Stage VAR---------------------------------//

	WB_ctrl		WB_in_WB;
	reg [31:0] 	WB_in_PC_link;
	reg [31:0] 	WB_in_ALU_res; 
	reg [4:0] 	WB_in_Rd;
	wire [31:0] WB_Mux_out; 
	wire [31:0] WB_Mux_Mux_out;
	
	reg [31:0] WB_in_instr;
	//assign WB_INSTRUCTION = Instruction_Enum'(WB_in_instr);

//---------------------- WB Stage VAR END ----------------------------//

//---------------------- Data FSM VAR---------------------------------//

	reg [31:0] TEST_MEM_DATA;
	reg TEST_EN, TEST_MEM_CSB, TEST_MEM_WE;
	wire enable_general;

//---------------------- END Data FSM VAR ----------------------------//

//---------------------- Fetch Stage ---------------------------------//

	wire [31:0] IF_PC_LINK;
	wire [31:0] IF_PC_ADD;
	wire [31:0] IF_INSTR;
	reg		IF_FETCH_P;
	assign IF_FETCH_P = 1'b0; 

	wire [31:0] MEM_in_PC_jump;
	wire [31:0]	MEM_in_ALU_res;

	wire TEST_FE_EN;
	wire FSM_PCSrc;

	FETCH_Block FE0 (
		// input
		.CLK(CLK),
		.RSTn(RSTn),
		.EN(EN & enable_general),
		.START(START),

		.HAZARD	(HAZARD_o),
		.TB_LOAD_PROGRAM_CTRL(TB_LOAD_PROGRAM_CTRL),
		.TB_LOAD_PROGRAM_ADDR(TB_LOAD_PROGRAM_ADDR),
		.TB_LOAD_PROGRAM_DATA(TB_LOAD_PROGRAM_DATA),

		.MEM_in_PC_jump(MEM_in_PC_jump),
		.MEM_in_ALU_res(MEM_in_ALU_res),
		
		// output
		.PC_link(IF_PC_LINK),
		.PC_add(IF_PC_ADD),
		.instr(IF_INSTR),
		.TEST_EN_OUT(TEST_FE_EN),
		.FSM_PCSrc(FSM_PCSrc)
	);

// END

//IF_ID Reg//
	wire [31:0] ID_in_PC_link;
	wire [31:0] ID_in_PC_add;
	wire [31:0] ID_in_instr;
	wire 		ID_in_P;

	//always @ (*)
	//	if (IF_INSTR != 0)
	//		$display($time, " instruction: %0h", IF_INSTR);

	IF_ID_Reg if_id_reg0(
	  .in_PC_link  (IF_PC_LINK),
	  .in_PC_add   (IF_PC_ADD),
	  .in_instr    (IF_INSTR),
	  .in_P        (IF_FETCH_P),
	  .clk         (CLK),
	  .rstn        (HAZARD_o.En_IFID & RSTn),
	  .en          (EN & START & enable_general & TEST_FE_EN),
	  
	  .out_PC_link (ID_in_PC_link),
	  .out_PC_add  (ID_in_PC_add),
	  .out_instr   (ID_in_instr),
	  .out_P       (ID_in_P)
	);

// END

//---------------------- Decode Stage---------------------------------//
	
	WB_ctrl	ID_in_WB;
	M_ctrl 	ID_in_M;
	EX_ctrl	ID_in_EX;
	
	wire [31:0] 	ID_imm;
	wire [31:0] 	ID_reg_data_1;
	wire [31:0] 	ID_reg_data_2;
	wire [3:0] 		ID_in_ALU_ctrl;
	wire [4:0] 		ID_Rs1;
	wire [4:0] 		ID_Rs2;
	wire [4:0] 		ID_Rd;
	wire 			ID_Rd_EQ0;
	wire 			ID_sel_mux;
	
	reg [31:0]	EX_in_instr; // this wire is for test purpose
	
	assign ID_Rs2 = ID_in_instr [24:20];
	assign ID_Rd  = ID_in_instr [11:7];
	assign ID_in_ALU_ctrl = {ID_in_instr[30], ID_in_instr[14:12]};

	DECODE_Block DE0(
	  .CLK            (CLK           ),
	  .EN             (EN & enable_general & TEST_FE_EN),
	  .RSTn           (RSTn          ),
	  .START          (START         ),
	  .ID_in_instr    (ID_in_instr   ),
	  .WB_in_Rd       (WB_in_Rd      ),
	  .WB_Mux_Mux_out (WB_Mux_Mux_out),
	  .HAZARD_BP_o 	  (HAZARD_o   ),
	  .WB_in_WB		  (WB_in_WB      ),
	  
	  .ID_in_WB       (ID_in_WB      ),
	  .ID_in_M        (ID_in_M       ),
	  .ID_in_EX       (ID_in_EX      ),
	  .ID_imm         (ID_imm        ),
	  .ID_reg_data_1  (ID_reg_data_1 ),
	  .ID_reg_data_2  (ID_reg_data_2 ),
	  .ID_Rs1         (ID_Rs1        ),
	  .ID_sel_mux	  (ID_sel_mux	 ),
	  .ID_Rd_EQ0      (ID_Rd_EQ0	 ),
	  .EX_in_instr    (EX_in_instr   ) // this wire is for test purpose
	);

//ID_EX Reg//

	EX_ctrl 	EX_in_EX;
    WB_ctrl 	EX_in_WB;
    M_ctrl		EX_in_M;
	wire [31:0]	EX_in_PC_add;
	wire [31:0] EX_in_PC_link;
	wire [31:0] EX_in_imm;
	wire [31:0] EX_in_reg_data_2;
    reg  [31:0] EX_in_reg_data_1;
    reg  [3:0] 	EX_in_ALU_ctrl;
    reg  [4:0] 	EX_in_Rd;
	reg			EX_in_Rd_EQ0;
    reg      	EX_in_P;
    reg  [4:0] 	EX_in_Rs1;
    reg  [4:0] 	EX_in_Rs2;        

	
	ID_EX_Reg ID_EX_M_r (
		.in_WB(ID_in_WB),        	
        .in_M(ID_in_M),
        .in_EX(ID_in_EX),
        .in_PC_link(ID_in_PC_link),
        .in_PC_add(ID_in_PC_add), 
        .in_imm(ID_imm),
		.in_reg_data_1(ID_reg_data_1),
		.in_reg_data_2(ID_reg_data_2),	
        .in_ALU_ctrl(ID_in_ALU_ctrl),
        .in_Rd(ID_Rd),
		.in_Rd_EQ0(ID_Rd_EQ0),
        .in_Rs1(ID_Rs1),
        .in_Rs2(ID_Rs2),
    	.in_P  (ID_in_P),
        .clk(CLK),
        .rstn(RSTn & ID_sel_mux),
        .en(EN & START & enable_general & TEST_FE_EN),
        
		// output
		.out_WB(EX_in_WB),
        .out_M(EX_in_M),
        .out_EX(EX_in_EX),
        .out_PC_link(EX_in_PC_link),
        .out_PC_add(EX_in_PC_add), 
        .out_imm(EX_in_imm),
		.out_reg_data_1(EX_in_reg_data_1),	
		.out_reg_data_2(EX_in_reg_data_2),	
        .out_ALU_ctrl(EX_in_ALU_ctrl),
        .out_Rd(EX_in_Rd),
		.out_Rd_EQ0(EX_in_Rd_EQ0),
        .out_Rs1(EX_in_Rs1),
        .out_Rs2(EX_in_Rs2),       
    	.out_P  (EX_in_P)
	); 
	
// END

//---------------------- Execution Stage---------------------------------//

	wire [31:0] EX_PC_jump;
	wire [31:0] EX_ALUResult;
	wire 		EX_bit_branch;	
	
	wire [31:0] MEM_in_instr;

	EXECUTE_Block EX0(
	  .CLK              (CLK             ),
	  .EN               (EN & enable_general & TEST_FE_EN),
	  //.START            (START           ),
	  .RSTn             (RSTn            ),
	  .EX_in_EX         (EX_in_EX        ),
	  .Forward_o        (Forward_o       ),
	  .HAZARD_BP_o     	(HAZARD_o     ),
	  .EX_in_PC_add     (EX_in_PC_add    ),
	  .EX_in_imm        (EX_in_imm       ),
	  .EX_in_reg_data_2 (EX_in_reg_data_2),
	  .EX_in_reg_data_1 (EX_in_reg_data_1),
	  .EX_in_ALU_ctrl   (EX_in_ALU_ctrl  ),
	  .WB_Mux_Mux_out   (WB_Mux_Mux_out  ),
	  .MEM_in_instr     (MEM_in_instr    ),
	  .MEM_in_ALU_res   (MEM_in_ALU_res  ),
	  .EX_in_instr      (EX_in_instr     ),
	  
	  // output
	  .EX_PC_jump       (EX_PC_jump      ),
	  .EX_ALUResult     (EX_ALUResult    ),
	  .EX_bit_branch    (EX_bit_branch   )
	);

	M_ctrl 	MEM_in_M;
	WB_ctrl MEM_in_WB;
	wire 		MEM_in_bit_branch;
	wire [31:0] MEM_in_reg_data_2;
	wire [4:0]	MEM_in_Rd;
	wire 		MEM_in_Rd_EQ0;
	wire 		MEM_in_P;
	wire [31:0] MEM_in_PC_link;
	wire [31:0] MEM_in_PC;

	// Pipeline Register
	EX_Mem_Reg ex_mem_reg (
    	.in_WB          (EX_in_WB         ),
    	.in_M           (EX_in_M          ),
    	.in_PC_link     (EX_in_PC_link    ),
    	.in_PC_jump     (EX_PC_jump    ),
    	.in_PC     		(EX_in_PC_add),			// This signal is here because I would like to bring the PC until the WB stage
    	.in_bit_branch  (EX_bit_branch ),
    	.in_ALU_res     (EX_ALUResult),
    	.in_reg_data_2  (EX_in_reg_data_2),
    	.in_Rd          (EX_in_Rd),
		.in_Rd_EQ0      (EX_in_Rd_EQ0),
    	.in_P           (EX_in_P),
    	.clk            (CLK),
    	.rstn           (RSTn & HAZARD_o.Ctrl_Mux_EX),
		.en 	        (EN & START & enable_general & TEST_FE_EN),
		
		//output
    	.out_WB         (MEM_in_WB),
    	.out_M          (MEM_in_M),
    	.out_PC_link    (MEM_in_PC_link),
    	.out_PC_jump    (MEM_in_PC_jump),
    	.out_PC		    (MEM_in_PC),
    	.out_bit_branch (MEM_in_bit_branch),
    	.out_reg_data_2 (MEM_in_reg_data_2),
    	.out_ALU_res    (MEM_in_ALU_res),
    	.out_Rd         (MEM_in_Rd),
		.out_Rd_EQ0		(MEM_in_Rd_EQ0),
    	.out_P          (MEM_in_P)
	); 
	
// END


//----------------------- Memory Stage ---------------------------------//
	wire [31:0] WB_in_mem_data;
 	wire [31:0] MEM_mem_data;
 	wire  		WB_in_Rd_EQ0;
	
	wire enable_cs;

	MEMORY_Block ME0(
	  .CLK               (CLK              ),
	  .EN                (EN & enable_general & TEST_FE_EN),
	  .RSTn              (RSTn             ),
	  .START             (START            ),
	  .TB_LOAD_DATA_CTRL (TB_LOAD_DATA_CTRL),
	  .TB_LOAD_DATA_ADDR (TB_LOAD_DATA_ADDR),
	  .TB_LOAD_DATA_DATA (TB_LOAD_DATA_DATA),
	  
	  .MEM_in_ALU_res    (MEM_in_ALU_res   ),
	  .MEM_in_instr      (MEM_in_instr     ),
	  .MEM_in_M          (MEM_in_M         ),
	  .enable_cs		 (enable_cs        ),
	  .MEM_in_reg_data_2 (MEM_in_reg_data_2),
	
	  .TEST_EN			 (TEST_EN		   ),
	  .TEST_MEM_CSB		 (TEST_MEM_CSB	   ),
	  .TEST_MEM_WE		 (TEST_MEM_WE	   ),
	  
	  // output
	  .MEM_mem_data      (MEM_mem_data     ),
	  .TB_Instr          (TB_Instr         ),
	  .OK				 (OK			   )
	);

	assign TEST_MEM_DATA = MEM_mem_data;

	//MEM_WB pipe register
	Mem_WB_Reg MEM_WB_r(
	.in_WB(MEM_in_WB),
	.in_PC_link(MEM_in_PC_link),
	.in_ALU_res(MEM_in_ALU_res),
	.in_mem_data(MEM_mem_data),
	.in_Rd(MEM_in_Rd),
	.in_Rd_EQ0(MEM_in_Rd_EQ0),
	.clk(CLK),
	.rstn(RSTn),
	.en(1'b1 & enable_general & TEST_FE_EN),
	.out_WB(WB_in_WB),
	.out_PC_link(WB_in_PC_link),
	.out_ALU_res(WB_in_ALU_res),
	.out_mem_data(WB_in_mem_data),
	.out_Rd(WB_in_Rd),
	.out_Rd_EQ0(WB_in_Rd_EQ0)
	); 

//END

//---------------------- Write Back stage --------------------------------//
	//first mux select MemtoReg
	assign WB_Mux_out = WB_in_WB.MemtoReg ? WB_in_mem_data : WB_in_ALU_res; 
	
	//second mux select Pctoreg
	assign WB_Mux_Mux_out = WB_in_WB.PCtoReg ? WB_in_PC_link : WB_Mux_out;

//END

//---------------------- Forwarding Unit ---------------------------------//
	assign Forward_i.Mem_rd 		= MEM_in_Rd;
	assign Forward_i.WB_rd 			= WB_in_Rd;
	assign Forward_i.EX_rs1 		= EX_in_Rs1;
	assign Forward_i.EX_rs2 		= EX_in_Rs2;
	assign Forward_i.ALU_src 		= EX_in_EX.ALUsrc;
	assign Forward_i.Mem_RegWrite 	= MEM_in_WB.RegWrite;
	assign Forward_i.WB_RegWrite 	= WB_in_WB.RegWrite;
	assign Forward_i.MEM_in_Rd_EQ0	= MEM_in_Rd_EQ0;
	assign Forward_i.WB_in_Rd_EQ0	= WB_in_Rd_EQ0;
		   	
	FU_Unit fu_unit0(
	  .FU_i (Forward_i),
	  .FU_o (Forward_o)
	);

// END

//---------------------- Hazard Unit ---------------------------------//
	// if prediction is wrong it is necessary to change PC address
	assign HAZARD_i.rs1 = ID_Rs1;
	assign HAZARD_i.rs2 = ID_Rs2;
	assign HAZARD_i.rd = EX_in_Rd;
	assign HAZARD_i.MemRead = EX_in_M.MemRead;
	assign HAZARD_i.MEM_in_M_jump = MEM_in_M.jump;
	assign HAZARD_i.MEM_in_M_branch = MEM_in_M.branch;
	assign HAZARD_i.MEM_in_bit_branch = MEM_in_bit_branch;
	assign HAZARD_i.MEM_in_P = MEM_in_P;
	assign HAZARD_i.EX_in_PC_add = EX_in_PC_add;
	
	assign HAZARD_i.MEM_in_M_AddtoPC = MEM_in_M.AddtoPC;
	assign HAZARD_i.MEM_in_ALU_res = MEM_in_ALU_res;
	assign HAZARD_i.MEM_in_PC_jump = MEM_in_PC_jump;
	assign HAZARD_i.FSM_PCSrc = FSM_PCSrc;
	
	Hazard_Ctrl_Unit HZRD_0(
	 .HAZARD_i (HAZARD_i),
	 .HAZARD_o (HAZARD_o)
	);

//---------------------- Hazard Unit END ----------------------------//

//---------------------- FSM ---------------------------------//
	FSM fsm0(
	  .chipselect     (MEM_in_M.CS),
	  .write_enable   (MEM_in_M.MemRead),
	  
	  .chipselect_EX  (EX_in_M.CS),
	  .write_enable_EX(EX_in_M.MemRead),
	  .clk            (CLK),
	  .rstn           (RSTn),
	  .TEST_MEM_DATA  (TEST_MEM_DATA),

	  .enable_cs	  (enable_cs),
	  .STOP_Pipelinen (enable_general),
	  
	  .TEST_EN		  (TEST_EN),
	  .TEST_MEM_CSB	  (TEST_MEM_CSB),
	  .TEST_MEM_WE    (TEST_MEM_WE)
	);
//---------------------- END FSM -----------------------------//
endmodule
