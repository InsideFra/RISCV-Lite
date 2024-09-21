package my_pkg;

// ALU operation codes
typedef enum logic [4:0] {
	ALU_ADD  = 5'b00000,
	ALU_SUB  = 5'b00001,
	ALU_AND  = 5'b00010,
	ALU_OR   = 5'b00011,
	ALU_XOR  = 5'b00100,
	ALU_SLT  = 5'b00101,
	ALU_SLTU = 5'b00110,
	ALU_SLL  = 5'b00111,
	ALU_SRL  = 5'b01000,
	ALU_SRA  = 5'b01001,
	ALU_NOP  = 5'b01111,
    ALU_BEQ  = 5'b10000,
    ALU_BNE  = 5'b10001,
    ALU_BLT  = 5'b10010,
    ALU_BGE  = 5'b10011,
    ALU_BLTU = 5'b10100,
    ALU_BGEU = 5'b10101
} alu_ops_t;

typedef enum bit [2:0] 	{NOFWA=3'b001, FWA_MEMD=3'b010, FWA_ALURSLT=3'b100} ForwardA_Control_Enum;
typedef enum bit [2:0] 	{NOFWB=3'b001, FWB_MEMD=3'b010, FWB_ALURSLT=3'b100} ForwardB_Control_Enum;

typedef enum reg [31:0] {
	LUIOP,
	AUIPCOP,
	SWOP,
	ADDOP,
	XOROP,
	ANDOP,
	SUBOP,
	SLLIOP,
	SRAIOP,
	ADDIOP,
	LWOP,
	JALROP,
	JALOP,
	BNEOP,
	BLEOP,
	NOPOP
}	Instruction_Enum;

typedef enum reg   [3:0] {
	STARTUP, STARTUP0, STARTUP1, STARTUP2, STARTUP3, STARTUP4,
	IDLE, MEMREAD, MEMREAD1, MEMREAD2, RESTART} FSM_MEM_states_reg;

typedef enum bit [1:0]	{NOP = 2'b01, IMEM = 2'b10} FSM_Control_Enum;

typedef enum bit [2:0] {
	next_pc,
	Z,
	branch_alu,
	branch_pc_jump,
	trap_illegal,
	xepc

} PCSrc_Enum;

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
	alu_ops_t ALUop;
	reg branch;
}EX_ctrl;

typedef struct packed {
	reg Pcsrc;
	reg [4:0] rs1;
	reg [4:0] rs2;
	reg [4:0] rd;
	reg MemRead;
	reg MEM_in_M_jump;
	reg MEM_in_M_branch;
	reg MEM_in_bit_branch;
	reg MEM_in_P;
	reg MEM_in_M_AddtoPC;
	reg MEM_in_ALU_res;
	reg MEM_in_PC_jump;
	reg EX_in_PC_add;
	reg I_FSM_STALL_FETCH;

	reg DECODE_TRAP;

	reg EXECUTE_MRET;
	reg EXECUTE_SRET;

} HAZARD_ctrl_i;

typedef struct packed {
	reg Ctrl_Mux_DE;
	reg Ctrl_Mux_EX;
	reg En_IFID;
	reg En_PC;
	PCSrc_Enum PCSrc;
} HAZARD_ctrl_o;

typedef struct packed {
	reg V;
	reg [5:0] TAG;
	reg [31:0] TA;
	reg T;
} CACHE_BRANCH;

typedef struct packed {
	reg ILLEGAL_INSTR;
} DECODE_TRAP_STRUCT;

typedef struct packed {
	reg DECODE_TRAP;
} TRAP_STRUCT;

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

/*
CSRs
*/
typedef struct packed {
	reg [127:0] arch_id;
} CSR_marchid_struct;

typedef struct packed {
	reg [127:0] impl;
} CSR_mimpid_struct;

typedef struct packed {
	reg [127:0] hart_id;
} CSR_hart_id_struct;

typedef struct packed {
	reg SD;
	reg [7:0] WPRI_1;
	reg TSR;
	reg TW;
	reg TVM;
	reg MXR;
	reg SUM;
	reg MPRV;
	reg [1:0] XS;
	reg [1:0] FS;
	reg [1:0] MMP;
	reg [1:0] VS;
	reg SPP;
	reg MPIE;
	reg UBE;
	reg SPIE;
	reg WPRI_2;
	reg MIE;
	reg WPRI_3;
	reg SIE;
	reg WPRI_4; 
} CSR_mstatus_struct;

endpackage
