module DP_DDR3();

    reg CLK;
    reg RSTn;

    // Control and Data Signals
    reg [31:0] DATA_ADDR;
    reg [127:0] DATA_BUS;
    reg DATA_ENABLE;
    reg DATA_WRITE;

    // Clock Generation
    initial begin
        CLK = 0;
        forever #2.5 CLK = ~CLK; // 100 MHz clock
    end

    // Test Procedure
    initial begin
        // Initialize signals
        RSTn = 0;
        DATA_ADDR = 32'h0;
        DATA_BUS = 128'h0;
        DATA_ENABLE = 0;
        DATA_WRITE = 0;

        // Reset sequence
        #10 RSTn = 1; // Release reset

        // Write data test
        #10;
        DATA_ADDR = 32'h0000_0004;
        DATA_BUS = 128'hDEAD_BEEF;
        DATA_ENABLE = 1;
        DATA_WRITE = 1;

        // Wait for write to complete
        wait(write_ready);

        // Read data test
        #20;
        DATA_ADDR = 32'h0000_0004;
        DATA_ENABLE = 1;
        DATA_WRITE = 0;

        // Wait for read to complete and check data
        wait(read_ready);
        if (read_data_out == 32'hDEAD_BEEF) begin
            $display("Read successful: 0x%h", read_data_out);
        end else begin
            $display("Read failed: 0x%h", read_data_out);
        end

        // Finish simulation
        #100;
        $stop;
    end

    wire [15:0] ddr3_dq;
    wire [1:0]  ddr3_dqs;
    wire [1:0]  ddr3_dqs_n;
    wire [1:0]  ddr3_dm;

    ram ram0 (
        .clk            (CLK),
        .rst_n          (RSTn),
        .addr_in        (DATA_ADDR),
        .write_data_in  (DATA_BUS),
        .read_req       (DATA_ENABLE & ~DATA_WRITE),
        .write_req      (DATA_ENABLE & DATA_WRITE),

        .read_data_valid    (read_data_valid),
        .read_data_out      (read_data_out),

        .write_ready    (write_ready),
        .read_ready     (read_ready),

        .ddr3_dq        (ddr3_dq),
        .ddr3_dqs_n     (ddr3_dqs_n),
        .ddr3_dqs_p     (ddr3_dqs_p),

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
        .ddr3_odt       (ddr3_odt)
    );

    ddr3_model ddr3(
        .rst_n  (ddr3_reset_n),
        .ck     (ddr3_ck_p),
        .ck_n   (ddr3_ck_n),
        .cke    (ddr3_cke),
        .cs_n   (ddr3_),
        .ras_n  (ddr3_ras_n),
        .cas_n  (ddr3_cas_n),
        .we_n   (ddr3_we_n),
        .dm_tdqs(ddr3_dm),
        .ba     (ddr3_ba),
        .addr   (ddr3_addr),
        .dq     (ddr3_dq),
        .dqs    (ddr3_dqs_p),
        .dqs_n  (ddr3_dqs_n),
        .tdqs_n (),
        .odt    (ddr3_odt)
    );

endmodule