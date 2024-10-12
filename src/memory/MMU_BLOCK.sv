module MMU_Block #(
    parameter ROM_ADDR_SIZE = 16,
    parameter ROM_N_ROWS = 512
)
(
    input           EN,
    input           CLK,
    input           RSTn,
    input   [31:0]  PC,
    input   reg     PC_Changed,

    // Input signals related to DATA
    input   [31:0]  DATA_ADDR,
    input   [31:0]  DATA_BUS,
    input   [31:0]  DATA_WRITE,
    input   [31:0]  DATA_ENABLE,

    // Output signals related to DATA
    output  [31:0]  data_out,

    // Output signals related to INSTRUCTION
    output  reg [31:0]  instruction_out,

    output  reg read_data_valid,
    output  reg read_data_out,

    output  reg write_ready,
    output  reg read_ready,

    inout   reg  [7:0]   ddr3_dq,
    inout   reg  [0:0]   ddr3_dqs_n,
    inout   reg  [0:0]   ddr3_dqs_p,

    output  reg  [14:0]  ddr3_addr,
    output  reg  [2:0]   ddr3_ba,
    output  reg          ddr3_ras_n,
    output  reg          ddr3_cas_n,
    output  reg          ddr3_we_n,
    output  reg          ddr3_reset_n,
    output  reg  [0:0]   ddr3_ck_p,
    output  reg  [0:0]   ddr3_ck_n,
    output  reg  [0:0]   ddr3_cke,
    output  reg  [0:0]   ddr3_dm,
    output  reg  [0:0]   ddr3_odt
);

// RAM Signals
reg [19:0] _instr_ram_address;
reg [31:0] _instr_ram_din;
reg [31:0] _instr_ram_dout;
reg _instr_ram_wea;
reg _instr_ram_ena;

// ROM Signals
reg [ROM_ADDR_SIZE - 1:0] _instr_rom_address;

reg [31:0] _instr_rom_data_out;

reg _I_RAM_SELECTED;

// blk_mem_gen_0 instr_mem0(

// I_FSM I_FSM0(
//   .MEM_WE      (_instr_ram_wea),
//   .clk         (CLK        ),
//   .rstn        (RSTn       ),
//   .PC_changed  (_PC_Changed),
//   .TEST_MEM_DATA(TEST_MEM_DATA),
//   .I_RAM_SELECTED(_I_RAM_SELECTED),

//   .MEM_CSB_OUT (_instr_ram_ena),
//   .I_FSM_STALL_FETCH    (_I_FSM_STALL_FETCH),
//   .TEST_EN	   (TEST_EN),
//   .TEST_MEM_WE (TEST_MEM_WE)
// );

ram ram0 (
    .clk            (CLK),
    .rst_n          (RSTn),
    .en             (EN),
    .addr_in        (DATA_ADDR),
    .write_data_in  (DATA_BUS),
    .read_req       (DATA_ENABLE & ~DATA_WRITE),
    .write_req      (DATA_ENABLE & DATA_WRITE),
    .bit32_select   (1'b0),

    .read_data_valid    (read_data_valid),
    .read_data_out      (read_data_out),

    .write_ready    (write_ready),
    .read_ready     (read_ready),

    .ddr3_dq        (ddr3_dq),
    .ddr3_dqs_n     (ddr3_dqs_n),
    .ddr3_dqs_p     (ddr3_dqs_p),

    .ddr3_addr      (ddr3_aadr),
    .ddr3_ba        (ddr3_ba),
    .ddr3_ras_n     (ddr3_ras_n),
    .ddr3_cas_n     (ddr3_cas_n),
    .ddr3_we_n      (ddr3_we_n),
    .ddr3_reset_n   (ddr3_reset_n),
    .ddr3_ck_p      (ddr3_ck_p),
    .ddr3_ck_n      (ddr3_ck_n),
    .ddr3_cke       (ddr3_cke),
    .ddr3_dm        (ddr3_dm),
    .ddr3_odt       (ddr3_odt)
);

rom #(
    .INPUT_SIZE(ROM_ADDR_SIZE),
    .OUTPUT_SIZE(32),
    .N_ROWS(ROM_N_ROWS)
) instr_rom(
    .a      (_instr_rom_address),
    .spo    (_instr_rom_data_out)
);

always @ (*) begin
    // RAM Signals
    _instr_ram_address  <= 32'bZ;
    _instr_ram_din      <= 32'bZ;
    _instr_ram_wea      <= 1'b0;

    // ROM Signals
    _instr_rom_address  <= 32'bZ;

    // Select ROM
    if ((PC >= 0) & (PC <= 32'hffff)) begin
        _instr_rom_address  <= {2'b00, PC[ROM_ADDR_SIZE:2]};

        _I_RAM_SELECTED     <= 1'b0;

        instruction_out     <= _instr_rom_data_out;
    end
    // Select RAM
    else begin
        instruction_out     <= _instr_ram_dout;

        _I_RAM_SELECTED     <= 1'b1;
		_instr_ram_address  <= PC[19:0];
        _instr_ram_din      <= 32'h0;
        _instr_ram_wea      <= 1'b0;
    end
end

assign busy_reading = 1'b0;

reg [63:0] _mtime_value;

mtime mtime_reg(
    .CLK(CLK),
    .EN(EN),
    .RSTn(RSTn),
    .mtime_value(_mtime_value)
);

endmodule