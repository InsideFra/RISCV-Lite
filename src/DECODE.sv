import my_pkg::*; // Import the package my_pkg which likely contains definitions for WB_ctrl, M_ctrl, EX_ctrl, and other modules.

module DECODE_Block (
    input CLK,        // Clock signal
    input EN,         // Enable signal
    input RSTn,       // Reset signal (active low)
    input START,      // Start signal

    input [31:0] ID_in_instr,  // 32-bit instruction input
    input [4:0]  WB_in_Rd,     // 5-bit write-back register destination input
    input [31:0] WB_Mux_Mux_out, // 32-bit write-back data from MUX output
    input HAZARD_ctrl_o HAZARD_BP_o, // Hazard control and bypass control
    input WB_ctrl  WB_in_WB,    // Write-back control input

    output WB_ctrl ID_in_WB,    // Write-back control output for ID stage
    output M_ctrl  ID_in_M,     // Memory control output for ID stage
    output EX_ctrl ID_in_EX,    // Execute control output for ID stage
    output [31:0]  ID_imm,      // Immediate value generated from instruction
    output [31:0]  ID_reg_data_1, // Register data 1
    output [31:0]  ID_reg_data_2, // Register data 2
    output [4:0]   ID_Rs1,      // Source register 1
    output         ID_sel_mux,  // MUX select signal
    // Testbench
    output [31:0]  EX_in_instr, // Instruction output for EX stage (for testbench)
    // End testbench
    output         ID_Rd_EQ0    // Indicates if destination register is not zero
);

//---------------------- Decode Stage VAR---------------------------------//

    wire        ID_RegWrite;     // Signal for register write enable
    wire [6:0]  ID_opcode;       // Opcode extracted from instruction
    WB_ctrl     ID_WB_c;         // Write-back control for ID stage
    M_ctrl      ID_M_c;          // Memory control for ID stage
    EX_ctrl     ID_EX_c;         // Execute control for ID stage

    reg [4:0]   MUX_ID_Rs1;      // MUX output for source register 1
    reg [31:0]  ID_reg_data_1_BM, ID_reg_data_2_BM; // Data before MUX for source registers

    reg [4:0]   ID_Rs2;          // Source register 2
    reg [4:0]   ID_Rd;           // Destination register
    reg [3:0]   ID_in_ALU_ctrl;  // ALU control signals

// Extract fields from instruction
    assign ID_Rs2 = ID_in_instr[24:20];       // Source register 2
    assign ID_Rd  = ID_in_instr[11:7];        // Destination register
    assign ID_in_ALU_ctrl = {ID_in_instr[30], ID_in_instr[14:12]}; // ALU control

// Determine source register 1, considering specific opcode
    assign MUX_ID_Rs1 = (ID_in_instr[6:2] == 5'b01101) ? 5'b0 : ID_in_instr[19:15];
    assign ID_Rs1 = MUX_ID_Rs1;

// Select data for source register 1 based on various conditions
    assign ID_reg_data_1 = (ID_Rs1 == 5'b00000) ? 32'h00000000 :
                          ((ID_Rs1 == WB_in_Rd) ? WB_Mux_Mux_out : ID_reg_data_1_BM);

// Select data for source register 2 based on various conditions
    assign ID_reg_data_2 = (ID_Rs2 == 5'b00000) ? 32'h00000000 :
                          ((ID_Rs2 == WB_in_Rd) ? WB_Mux_Mux_out : ID_reg_data_2_BM);

// Check if destination register is zero
    assign ID_Rd_EQ0 = (ID_Rd == 5'b00000) ? 1'b0 : 1'b1;

// Write enable signal for register file
    assign ID_RegWrite = WB_in_WB.RegWrite;

// Instantiate the register file
    register_file ID_RF (
           .rs1(ID_Rs1),
           .rs2(ID_Rs2),
           .rd(WB_in_Rd),
           .write_data(WB_Mux_Mux_out),
           .RegWrite(WB_in_WB.RegWrite),
           .RSTn(RSTn),
           .clk(CLK),
           .en(EN & START),
           .read_data1(ID_reg_data_1_BM),
           .read_data2(ID_reg_data_2_BM)
    );

// Extract opcode from instruction
    assign ID_opcode = ID_in_instr[6:0];

// Instantiate control unit
    control ID_CRTL (.opcode(ID_opcode), .WB(ID_WB_c), .M(ID_M_c), .EX(ID_EX_c));

// Instantiate immediate generator
    imm_gen ID_IG (.instruction_i(ID_in_instr), .immediate_o(ID_imm));

// Assign control signals to outputs
    assign ID_in_WB = ID_WB_c;
    assign ID_in_M = ID_M_c;
    assign ID_in_EX = ID_EX_c;

// Select signal for MUX based on hazard control
    assign ID_sel_mux = HAZARD_BP_o.Ctrl_Mux_DE;

// Testbench - to be deleted in final design
    flip_flop id_ex_instr (
            .d(ID_in_instr),
            .rstn(RSTn & ID_sel_mux),
            .clk(CLK),
            .en(EN),
            .q(EX_in_instr)
    );
// End testbench

endmodule