package my_pkg;

typedef enum bit [1:0] 	{DOADD,TAKE4BIT,TAKE3BIT,BRANCH} ALUOP_Enum;
typedef enum bit [3:0] 	{ADD = 4'b0000, XOR=4'b0100,SUB=4'b1000,SLL=4'b0001, SRA=4'b0101, BNE=4'b1001, BLE=4'b1101} ALUControl_Enum;
typedef enum bit [2:0] 	{NOFWA=3'b001, FWA_MEMD=3'b010, FWA_ALURSLT=3'b100} ForwardA_Control_Enum;
typedef enum bit [2:0] 	{NOFWB=3'b001, FWB_MEMD=3'b010, FWB_ALURSLT=3'b100} ForwardB_Control_Enum;
typedef enum reg [31:0] {LUIOP, AUIPCOP, SWOP, ADDOP, XOROP, SUBOP, SLLIOP, SRAIOP, ADDIOP, LWOP, JALROP, JALOP, BNEOP, BLEOP, NOPOP} 
		Instruction_Enum;
typedef enum reg   [3:0] 	{STARTUP, STARTUP0,STARTUP1,STARTUP2,STARTUP3,STARTUP4,IDLE, MEMREAD,RESTART} FSM_MEM_states_reg;

typedef enum bit [1:0]	{NOP = 2'b01, IMEM = 2'b10} FSM_Control_Enum;

typedef struct packed {
	reg RegWrite;
	reg PCtoReg;
	reg MemtoReg;
} WB_ctrl;

typedef struct packed {
		bit [4:0] opcode;
		bit [2:0] func3;
		bit bit30;
} instr_struct;

typedef struct packed{
	reg MemRead;
	reg CS;
	reg branch;
	reg jump;
	reg AddtoPC;
}M_ctrl;

typedef struct packed {
	reg [1:0] ALUsrc;
	ALUOP_Enum ALUop;
}EX_ctrl;

typedef struct packed {
	reg Pcsrc;
	reg [4:0] rs1;
	reg [4:0] rs2;	
	reg [4:0] rd;
	reg MemRead;
} HAZARD_ctrl_i;

typedef struct packed {
	reg Ctrl_Mux_DE;
	reg Ctrl_Mux_EX;
	reg En_IFID;
	reg En_PC;
} HAZARD_ctrl_o;

typedef struct packed {
	reg V;
	reg [5:0] TAG;
	reg [31:0] TA;
	reg T;
} CACHE_BRANCH;

typedef struct packed {
		reg [4:0] 	Mem_rd;
		reg [4:0] 	WB_rd;
		reg [4:0] 	EX_rs1;
		reg [4:0] 	EX_rs2;
		reg       	Mem_RegWrite;
		reg [1:0]  	ALU_src;
		reg		  	WB_RegWrite;
		reg			MEM_in_Rd_EQ0;
		reg			WB_in_Rd_EQ0;
} FU_ctrl_i;

typedef struct packed {
		ForwardA_Control_Enum	ForwardA;
		ForwardB_Control_Enum 	ForwardB;
} FU_ctrl_o;

endpackage
