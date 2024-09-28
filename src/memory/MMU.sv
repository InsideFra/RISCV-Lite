module single_port_ram #(
    parameter ADDR_WIDTH = 20,
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 1048576
)(
    input logic clka,
    input logic ena,
    input logic [DATA_WIDTH-1:0] dina,
    input logic [ADDR_WIDTH-1:0] addra,
    input logic wea,
    output logic [DATA_WIDTH-1:0] douta
);

    // Memory array
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [ADDR_WIDTH-1:0] addr_reg;

    // Write operation
    always_ff @(posedge clka) begin
        if (ena) begin
            if (wea) begin
                mem[addra] <= dina;
            end
        end
    end

    // Read operation
    always @(*) begin
        if (ena) begin
            douta <= mem[addra];
        end
    end

endmodule

module ram (
    input  wire         clk,               // Clock signal
    input  wire         rst_n,             // Active-low reset
    input  wire [28:0]  addr_in,           // Address input for read/write
    input  wire [31:0]  write_data_in,     // 32-bit data input for write
    input  wire         read_req,          // Read request signal
    input  wire         write_req,         // Write request signal
    input  wire         bit32_select,      // 1 for upper 32 bits, 0 for lower 32 bits

    output reg          read_data_valid,   // Read data valid output
    output reg [31:0]   read_data_out,     // Read data output (32-bit)

    output reg          write_ready,       // Indicates when the controller is ready for a new write request
    output reg          read_ready,        // Indicates when the controller is ready for a new read request

    inout  [7:0]   ddr3_dq,
    inout  [0:0]   ddr3_dqs_n,
    inout  [0:0]   ddr3_dqs_p,

    output reg  [14:0]  ddr3_addr,
    output reg  [2:0]   ddr3_ba,
    output reg          ddr3_ras_n,
    output reg          ddr3_cas_n,
    output reg          ddr3_we_n,
    output reg          ddr3_reset_n,
    output reg  [0:0]   ddr3_ck_p,
    output reg  [0:0]   ddr3_ck_n,
    output reg  [0:0]   ddr3_cke,
    output reg  [0:0]   ddr3_dm,
    output reg  [0:0]   ddr3_odt
);


    wire            sys_clk_p;
    wire            sys_clk_n;

    wire            clk_ref_p;
    wire            clk_ref_n;

    wire    [28:0]  app_addr; // This input indicates the address for the current request.
    wire    [2:0]   app_cmd; // This input selects the command for the current request.
    wire            app_en;  // This is the active-High strobe for the app_addr[], app_cmd[2:0], app_sz, and app_hi_pri inputs.
    wire    [63:0]  app_wdf_data; // This provides the data for write commands.

    // This active-High input indicates that the current clock cycle is the last cycle of input data on app_wdf_data[].
    wire            app_wdf_end;

    wire    [7:0]   app_wdf_mask; // This provides the mask for app_wdf_data[].
    wire            app_wdf_wren; // This is the active-High strobe for app_wdf_data[].
    wire    [63:0]  app_rd_data; // This provides the output data from read commands.

    // This active-High output indicates that the current clock cycle is the last cycle of output data on app_rd_data[].
    //This is valid only when app_rd_data_valid is active-High.
    wire            app_rd_data_end;

    wire            app_rd_data_valid; // This active-High output indicates that app_rd_data[] is valid.

    // This output indicates that the UI is ready to accept commands.
    //If the signal is deasserted when app_en is enabled, the current app_cmd and app_addr must be retried until app_rdy is asserted.
    wire            app_rdy;

    // This output indicates that the write data FIFO is ready to receive data.
    // Write data is accepted when app_wdf_rdy = 1’b1 and app_wdf_wren = 1’b1.
    wire            app_wdf_rdy;

    wire            app_sr_req; // This input is reserved and should be tied to 0.
    wire            app_ref_req; // This active-High input requests that a refresh command be issued to the DRAM.
    wire            app_zq_req; // This active-High input requests that a ZQ calibration command be issued to the DRAM.
    wire            app_sr_active; // This output is reserved.

    // This active-High output indicates that the Memory Controller has sent the requested refresh command to the PHY interface.
    wire            app_ref_ack;

    // This active-High output indicates that the Memory Controller has sent the requested ZQ calibration command to the PHY interface.
    wire            app_zq_ack;

    wire            ui_clk; // This UI clock must be a half or quarter of the DRAM clock.
    wire            ui_clk_sync_rst; // This is the active-High UI reset.

    wire            init_calib_complete; // PHY asserts init_calib_complete when calibration is finished.
    wire    [11:0]  device_temp;


    mig_7series_0 u_mig_7series_0_mig (
        // Memory interface ports
        .ddr3_addr                      (ddr3_addr),
        .ddr3_ba                        (ddr3_ba),
        .ddr3_cas_n                     (ddr3_cas_n),
        .ddr3_ck_n                      (ddr3_ck_n),
        .ddr3_ck_p                      (ddr3_ck_p),
        .ddr3_cke                       (ddr3_cke),
        .ddr3_ras_n                     (ddr3_ras_n),
        .ddr3_reset_n                   (ddr3_reset_n),
        .ddr3_we_n                      (ddr3_we_n),
        .ddr3_dq                        (ddr3_dq),
        .ddr3_dqs_n                     (ddr3_dqs_n),
        .ddr3_dqs_p                     (ddr3_dqs_p),
        .init_calib_complete            (init_calib_complete),

        .ddr3_dm                        (ddr3_dm),
        .ddr3_odt                       (ddr3_odt),

        // Application interface ports
        .app_addr                       (app_addr),
        .app_cmd                        (app_cmd),
        .app_en                         (app_en),
        .app_wdf_data                   (app_wdf_data),
        .app_wdf_end                    (app_wdf_end),
        .app_wdf_wren                   (app_wdf_wren),
        .app_rd_data                    (app_rd_data),
        .app_rd_data_end                (app_rd_data_end),
        .app_rd_data_valid              (app_rd_data_valid),
        .app_rdy                        (app_rdy),
        .app_wdf_rdy                    (app_wdf_rdy),
        .app_sr_req                     (app_sr_req),
        .app_ref_req                    (app_ref_req),
        .app_zq_req                     (app_zq_req),
        .app_sr_active                  (app_sr_active),
        .app_ref_ack                    (app_ref_ack),
        .app_zq_ack                     (app_zq_ack),
        .ui_clk                         (ui_clk),
        .ui_clk_sync_rst                (ui_clk_sync_rst),
        .app_wdf_mask                   (app_wdf_mask),

        // System Clock Ports
        .sys_clk_p                      (sys_clk_p),
        .sys_clk_n                      (sys_clk_n),

        // Reference Clock Ports
        .clk_ref_p                      (clk_ref_p),
        .clk_ref_n                      (clk_ref_n),
        .device_temp                    (device_temp),
        .sys_rst                        (sys_rst)
    );

    ddr3_controller_fsm ddr3_fsm (
        .clk(clk),
        .rst_n(rst_n),
        .addr_in(addr_in),
        .write_data_in(write_data_in),
        .read_req(read_req),
        .write_req(write_req),
        .bit32_select(bit32_select),

        .app_addr(app_addr),
        .app_cmd(app_cmd),
        .app_en(app_en),
        .app_wdf_data(app_wdf_data),
        .app_wdf_wren(app_wdf_wren),
        .app_wdf_mask(app_wdf_mask),

        .app_rdy(app_rdy),
        .app_wdf_rdy(app_wdf_rdy),
        .app_wdf_end(app_wdf_end),
        .app_rd_data(app_rd_data),
        .app_rd_data_valid(app_rd_data_valid),
        .read_data_valid(read_data_valid),
        .read_data_out(read_data_out),

        .write_ready(write_ready),
        .read_ready(read_ready)
);

endmodule

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
    _instr_ram_address  <= Z;
    _instr_ram_din      <= Z;
    _instr_ram_wea      <= 1'b0;

    // ROM Signals
    _instr_rom_address  <= Z;

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