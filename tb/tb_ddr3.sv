`timescale 1 ns / 1 ps
module DP_DDR3();

    reg CLK;
    reg RSTn;

    // Control and Data Signals
    reg [31:0] DATA_ADDR;
    reg [31:0] DATA_BUS;
    reg DATA_ENABLE;
    reg DATA_WRITE;

    reg ENABLE;

    wire [31:0] read_data_out;

    integer i;

    // Clock Generation
    initial begin
        CLK = 0;
        forever #2.5 CLK = ~CLK; // 100 MHz clock
    end

    // Test Procedure
    initial begin
        // Initialize signals
        RSTn = 0;
        ENABLE = 0;
        DATA_ADDR = 32'h0;
        DATA_BUS = 32'h0;
        DATA_ENABLE = 0;
        DATA_WRITE = 0;

        // Reset sequence
        #10 RSTn = 1; // Release reset

        // Write data test
        // #500;
        #120000
        ENABLE = 1;

        for(i=0; i < 256*4; i += 4) begin
            wait(~please_stall_everything);
            wait(CLK == 1'b0);
            wait(CLK == 1'b1);
            DATA_ADDR = i;
            DATA_BUS = 32'hDEAD_BEEF;
            DATA_ENABLE = 1;
            DATA_WRITE = 1;
        end

        wait(~please_stall_everything);
        wait(CLK == 1'b0);
        wait(CLK == 1'b1);
        DATA_ADDR = 32'h70000000;
        DATA_BUS = 32'hDEAD_BEEF;
        DATA_ENABLE = 1;
        DATA_WRITE = 1;

        wait(~please_stall_everything);
        wait(CLK == 1'b0);
        wait(CLK == 1'b1);

        // Read data test
        #20;
        for(i=0; i < 256*4; i += 4) begin
            wait(~please_stall_everything);
            wait(CLK == 1'b0)
            wait(CLK == 1'b1);
            DATA_ADDR = i;
            DATA_ENABLE = 1;
            DATA_WRITE = 0;
        end

        // Wait for read to complete and check data
        // wait(read_ready);
        // if (read_data_out == 32'hDEAD_BEEF) begin
        //     $display("Read successful: 0x%h", read_data_out);
        // end else begin
        //     $display("Read failed: 0x%h", read_data_out);
        // end

        // Finish simulation
        #1000;
        $stop;
    end

    wire [15:0] ddr3_dq_fpga;
    wire [15:0] ddr3_dq_sdram;
    wire [1:0]  ddr3_dqs_p_fpga;
    wire [1:0]  ddr3_dqs_p_sdram;
    wire [1:0]  ddr3_dqs_n_fpga;
    wire [1:0]  ddr3_dqs_n_sdram;
    wire [1:0]  ddr3_dm;
    wire [14:0] ddr3_addr;
    wire [2:0]  ddr3_ba;


    ram ram0 (
        .clk            (CLK),
        .rst_n          (RSTn),
        .en             (ENABLE),
        .addr_in        (DATA_ADDR[28:0]),
        .write_data_in  (DATA_BUS),
        .read_req       (DATA_ENABLE & ~DATA_WRITE),
        .write_req      (DATA_ENABLE & DATA_WRITE),

        .read_data_valid    (read_data_valid),
        .read_data_out      (read_data_out),

        .write_ready    (write_ready),
        .read_ready     (read_ready),

        .please_stall_everything    (please_stall_everything),

        .ddr3_dq        (ddr3_dq_fpga),
        .ddr3_dqs_n     (ddr3_dqs_n_fpga),
        .ddr3_dqs_p     (ddr3_dqs_p_fpga),

        .ddr3_addr      (ddr3_addr),
        .ddr3_ba        (ddr3_ba),
        .ddr3_ras_n     (ddr3_ras_n),
        .ddr3_cas_n     (ddr3_cas_n),
        .ddr3_we_n      (ddr3_we_n),
        .ddr3_reset_n   (ddr3_reset_n),
        .ddr3_ck_p      (ddr3_ck_p),
        .ddr3_ck_n      (ddr3_ck_n),
        .ddr3_cke       (ddr3_cke),
        .ddr3_dm        (ddr3_dm),
        .ddr3_odt       (ddr3_odt),
        .init_calib_complete    (init_calib_complete)
    );

    ddr3_model ddr3(
        .rst_n  (ddr3_reset_n),
        .ck     (ddr3_ck_p),
        .ck_n   (ddr3_ck_n),
        .cke    (ddr3_cke),
        .cs_n   (1'b0),
        .ras_n  (ddr3_ras_n),
        .cas_n  (ddr3_cas_n),
        .we_n   (ddr3_we_n),
        .dm_tdqs(ddr3_dm),
        .ba     (ddr3_ba),
        .addr   (ddr3_addr),
        .dq     (ddr3_dq_sdram),
        .dqs    (ddr3_dqs_p_sdram),
        .dqs_n  (ddr3_dqs_n_sdram),
        .tdqs_n (),
        .odt    (ddr3_odt)
    );

    // Controlling the bi-directional BUS
    parameter DQ_WIDTH              = 16;
    parameter DQS_WIDTH             = 2;

    //**************************************************************************//
    // Local parameters Declarations
    //**************************************************************************//

    localparam real TPROP_DQS          = 0.00;
                                         // Delay for DQS signal during Write Operation
    localparam real TPROP_DQS_RD       = 0.00;
                         // Delay for DQS signal during Read Operation
    localparam real TPROP_PCB_CTRL     = 0.00;
                         // Delay for Address and Ctrl signals
    localparam real TPROP_PCB_DATA     = 0.00;
                         // Delay for data signal during Write operation
    localparam real TPROP_PCB_DATA_RD  = 0.00;
                         // Delay for data signal during Read operation

    genvar dqwd;
    generate
      for (dqwd = 1;dqwd < DQ_WIDTH;dqwd = dqwd+1) begin : dq_delay
        WireDelay #
         (
          .Delay_g    (TPROP_PCB_DATA),
          .Delay_rd   (TPROP_PCB_DATA_RD),
          .ERR_INSERT ("OFF")
         )
        u_delay_dq
         (
          .A             (ddr3_dq_fpga[dqwd]),
          .B             (ddr3_dq_sdram[dqwd]),
          .reset         (RSTn),
          .phy_init_done (init_calib_complete)
         );
      end
            WireDelay #
         (
          .Delay_g    (TPROP_PCB_DATA),
          .Delay_rd   (TPROP_PCB_DATA_RD),
          .ERR_INSERT ("OFF")
         )
        u_delay_dq_0
         (
          .A             (ddr3_dq_fpga[0]),
          .B             (ddr3_dq_sdram[0]),
          .reset         (RSTn),
          .phy_init_done (init_calib_complete)
         );
    endgenerate

    genvar dqswd;
    generate
      for (dqswd = 0;dqswd < DQS_WIDTH;dqswd = dqswd+1) begin : dqs_delay
        WireDelay #
         (
          .Delay_g    (TPROP_DQS),
          .Delay_rd   (TPROP_DQS_RD),
          .ERR_INSERT ("OFF")
         )
        u_delay_dqs_p
         (
          .A             (ddr3_dqs_p_fpga[dqswd]),
          .B             (ddr3_dqs_p_sdram[dqswd]),
          .reset         (RSTn),
          .phy_init_done (init_calib_complete)
         );

        WireDelay #
         (
          .Delay_g    (TPROP_DQS),
          .Delay_rd   (TPROP_DQS_RD),
          .ERR_INSERT ("OFF")
         )
        u_delay_dqs_n
         (
          .A             (ddr3_dqs_n_fpga[dqswd]),
          .B             (ddr3_dqs_n_sdram[dqswd]),
          .reset         (RSTn),
          .phy_init_done (init_calib_complete)
         );
      end
    endgenerate

endmodule