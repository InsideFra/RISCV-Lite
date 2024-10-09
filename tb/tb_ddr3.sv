module DP_DDR3();

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
        .odt    (ddr3_odt),
    );

endmodule