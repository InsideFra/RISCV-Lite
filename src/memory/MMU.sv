module ram (
    input  wire         clk,               // Clock signal
    input  wire         rst_n,             // Active-low reset
    input  wire         en,
    input  wire [28:0]  addr_in,           // Address input for read/write
    input  wire [31:0]  write_data_in,     // 32-bit data input for write
    input  wire         read_req,          // Read request signal
    input  wire         write_req,         // Write request signal

    output reg          read_data_valid,   // Read data valid output
    output reg [31:0]   read_data_out,     // Read data output (32-bit)

    output reg          write_ready,       // Indicates when the controller is ready for a new write request
    output reg          read_ready,        // Indicates when the controller is ready for a new read request

    output reg          please_stall_everything,

    inout  [15:0]   ddr3_dq,
    inout  [1:0]    ddr3_dqs_n,
    inout  [1:0]    ddr3_dqs_p,

    output reg  [14:0]  ddr3_addr,
    output reg  [2:0]   ddr3_ba,
    output reg          ddr3_ras_n,
    output reg          ddr3_cas_n,
    output reg          ddr3_we_n,
    output reg          ddr3_reset_n,
    output reg  [0:0]   ddr3_ck_p,
    output reg  [0:0]   ddr3_ck_n,
    output reg  [0:0]   ddr3_cke,
    output reg  [1:0]   ddr3_dm,
    output reg  [0:0]   ddr3_odt,
    output reg          init_calib_complete
);

    wire    sys_rst;
    assign sys_rst = rst_n;

    assign write_ready = 1'b1;
    assign read_ready   = 1'b1;

    wire    [28:0]  app_addr; // This input indicates the address for the current request.
    wire    [2:0]   app_cmd; // This input selects the command for the current request.
    wire            app_en;  // This is the active-High strobe for the app_addr[], app_cmd[2:0], app_sz, and app_hi_pri inputs.
    wire    [127:0] app_wdf_data; // This provides the data for write commands.

    // This active-High input indicates that the current clock cycle is the last cycle of input data on app_wdf_data[].
    wire            app_wdf_end;

    wire    [15:0]  app_wdf_mask; // This provides the mask for app_wdf_data[].
    wire            app_wdf_wren; // This is the active-High strobe for app_wdf_data[].
    wire    [127:0] app_rd_data; // This provides the output data from read commands.

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
    wire            app_ref_req = 1'b0; // This active-High input requests that a refresh command be issued to the DRAM.
    wire            app_zq_req = 1'b0; // This active-High input requests that a ZQ calibration command be issued to the DRAM.
    wire            app_sr_active; // This output is reserved.

    // This active-High output indicates that the Memory Controller has sent the requested refresh command to the PHY interface.
    wire            app_ref_ack;

    // This active-High output indicates that the Memory Controller has sent the requested ZQ calibration command to the PHY interface.
    wire            app_zq_ack;

    wire            ui_clk; // This UI clock must be a half or quarter of the DRAM clock.
    wire            ui_clk_sync_rst; // This is the active-High UI reset.

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
        .app_sr_req                     (1'b0),
        .app_ref_req                    (1'b0),
        .app_zq_req                     (1'b0),
        .app_sr_active                  (app_sr_active),
        .app_ref_ack                    (app_ref_ack),
        .app_zq_ack                     (app_zq_ack),
        .ui_clk                         (ui_clk),
        .ui_clk_sync_rst                (ui_clk_sync_rst),
        .app_wdf_mask                   (app_wdf_mask),

        // System Clock Ports
        .sys_clk_i                      (clk), // TODO: Fix the clocks

        // Reference Clock Ports
        .device_temp                    (device_temp),
        .sys_rst                        (sys_rst)
    );

    reg _read_data_valid;
    assign read_data_valid = _read_data_valid;

    reg [31:0] _read_data_out;
    assign read_data_out = _read_data_out;

    wire write_fifo_full;
    wire write_fifo_empty;

    wire read_in_fifo_full;
    wire read_in_fifo_empty;

    wire [127:0]    write_fifo_data_out;
    wire [31:0]     write_fifo_address;

    wire [31:0]     read_in_fifo_data_out;
    wire [31:0]     read_out_fifo_address_in;
    wire [127:0]    read_out_fifo_data_in;

    ddr3_controller_fsm #(
        .ADDRESS_WIDTH(32),
        .DATA_WIDTH(128)
    ) ddr3_fsm(
        .clk    (clk),
        .EN     (en),
        .rst_n  (rst_n),

        .write_fifo_data        (write_fifo_data_out),
        .write_fifo_empty       (write_fifo_empty),
        .write_fifo_address     (write_fifo_address),

        .read_in_fifo_address   (read_in_fifo_data_out),
        .read_in_fifo_empty     (read_in_fifo_empty),
        .read_out_fifo_empty    (read_out_fifo_empty),
        .read_out_fifo_full     (read_out_fifo_full),

        // OUT
        .read_out_fifo_address  (read_out_fifo_address_in),
        .read_out_fifo_data     (read_out_fifo_data_in),

        .write_fifo_read        (write_fifo_read_en),
        .read_in_fifo_read      (read_in_fifo_read),
        .read_out_fifo_address_write    (read_out_fifo_address_write),
        .read_out_fifo_data_write       (read_out_fifo_data_write),

        .app_addr       (app_addr),
        .app_cmd        (app_cmd),
        .app_en         (app_en),
        .app_wdf_data   (app_wdf_data),
        .app_wdf_wren   (app_wdf_wren),
        .app_wdf_mask   (app_wdf_mask),

        .app_rdy        (app_rdy),
        .app_wdf_rdy    (app_wdf_rdy),
        .app_wdf_end    (app_wdf_end),
        .app_rd_data        (app_rd_data),
        .app_rd_data_valid  (app_rd_data_valid)
    );

    wire [31:0] cache_address;
    assign cache_address = {4'b0, addr_in};

    reg [31:0] cache_write_data;
    assign cache_write_data = write_data_in;
    reg cache_write;
    assign cache_write = write_req;

    reg cache_read;
    assign cache_read = read_req;
    reg [31:0] cache_read_data;

    wire cache_hit;

    wire [31:0]     read_out_fifo_address_out;
    wire [127:0]    read_out_fifo_data;

    wire [31:0]     write_into_write_fifo_address;
    wire [127:0]    write_into_write_fifo_data;
    wire [31:0]     read_in_fifo_data_in;

    ddr3_cache ddr3_cache(
        .clk        (clk),
        .rst_n      (rst_n),
        .address    (cache_address),
        .write_data (cache_write_data),
        .read       (cache_read),
        .write      (cache_write),
        .write_fifo_full        (write_fifo_full),
        .read_in_fifo_full      (read_in_fifo_full),
        .read_out_fifo_full     (read_out_fifo_full),
        .read_out_fifo_data     (read_out_fifo_data),
        .read_out_fifo_address  (read_out_fifo_address_out),

        .write_into_write_fifo_address  (write_into_write_fifo_address),
        .write_into_write_fifo_data     (write_into_write_fifo_data),
        .write_into_write_fifo          (write_into_write_fifo),

        .write_into_read_in_fifo_address(read_in_fifo_data_in),
        .write_into_read_in_fifo        (write_into_read_in_fifo),

        .read_into_read_out_fifo        (read_into_read_out_fifo),

        .read_data  (cache_read_data),
        .hit        (cache_hit),
        .please_stall_everything(please_stall_everything)
    );

    // During a READ to the DRAM, we check if the data is in the Cache
    always @ (posedge clk) begin
        if (read_req == 1'b1) begin
            if (cache_hit == 1'b1) begin
                _read_data_valid    <= 1'b1;
                _read_data_out      <= cache_read_data;
            end
            else begin
                _read_data_valid    <=  1'b0;
                _read_data_out      <=  32'bZ;
            end
        end
        else begin
            _read_data_valid    <= 1'b0;
            _read_data_out      <= 32'bZ;
        end
    end

    fifo_address_data #(
        .N(2048),
        .ADDRESS_WIDTH(32),
        .DATA_WIDTH(128)
    ) write_fifo_data (
        .clk        (clk),
        .rst_n      (rst_n),

        .wr_en      (write_into_write_fifo),
        .rd_en      (write_fifo_read_en),
        .data_in    (write_into_write_fifo_data),
        .address_in (write_into_write_fifo_address),

        .data_out   (write_fifo_data_out),
        .address_out(write_fifo_address),
        .full       (write_fifo_full),
        .empty      (write_fifo_empty)
    );

    fifo_address #(
        .N(2048),
        .WIDTH(128)
    ) read_out_fifo (
        .clk        (clk),
        .rst_n        (rst_n),
        .wr_en      (read_out_fifo_data_write),
        .rd_en      (read_into_read_out_fifo),
        .data_in    (read_out_fifo_data_in),

        .data_out   (read_out_fifo_data),
        .full       (read_out_fifo_full),
        .empty      (read_out_fifo_empty)
    );

    fifo_address #(
        .N(2048),
        .WIDTH(32)
    ) read_out_fifo_address (
        .clk        (clk),
        .rst_n        (rst_n),
        .wr_en      (read_out_fifo_address_write),
        .rd_en      (read_into_read_out_fifo),
        .data_in    (read_out_fifo_address_in),
        .data_out   (read_out_fifo_address_out),
        .full       (),
        .empty      ()
    );

    fifo_address #(
        .N(2048),
        .WIDTH(32)
    ) read_in_fifo (
        .clk        (clk),
        .rst_n        (rst_n),
        .wr_en      (write_into_read_in_fifo),
        .rd_en      (read_in_fifo_read),
        .data_in    (read_in_fifo_data_in),
        .data_out   (read_in_fifo_data_out),
        .full       (read_in_fifo_full),
        .empty      (read_in_fifo_empty)
    );
endmodule

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
