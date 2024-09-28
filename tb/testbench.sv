`timescale 1 ns / 1 ps
module DP_TB ();
	reg CLK;
	reg RSTn;
	reg EN;
	reg START;

	reg OK;

	//***************************************************************************
	// The following parameters refer to width of various ports
	//***************************************************************************
	parameter COL_WIDTH             = 10;
	                                  // # of memory Column Address bits.
	parameter CS_WIDTH              = 1;
	                                  // # of unique CS outputs to memory.
	parameter DM_WIDTH              = 1;
	                                  // # of DM (data mask)
	parameter DQ_WIDTH              = 8;
	                                  // # of DQ (data)
	parameter DQS_WIDTH             = 1;
	parameter DQS_CNT_WIDTH         = 1;
	                                  // = ceil(log2(DQS_WIDTH))
	parameter DRAM_WIDTH            = 8;
	                                  // # of DQ per DQS
	parameter ECC                   = "OFF";
	parameter RANKS                 = 1;
	                                  // # of Ranks.
	parameter ODT_WIDTH             = 1;
	                                  // # of ODT outputs to memory.
	parameter ROW_WIDTH             = 15;
	                                  // # of memory Row Address bits.
	parameter ADDR_WIDTH            = 29;
	                                  // # = RANK_WIDTH + BANK_WIDTH
	                                  //     + ROW_WIDTH + COL_WIDTH;
	                                  // Chip Select is always tied to low for
	                                  // single rank devices

	wire 	[DQ_WIDTH-1:0]      ddr3_dq;
  	reg 	[ROW_WIDTH-1:0]     ddr3_addr [0:1];
  	reg		[7-1:0]             ddr3_ba [0:1];
  	reg                       	ddr3_ras_n;
  	reg                       	ddr3_cas_n;
  	reg                       	ddr3_we_n;
  	wire 	[(CS_WIDTH*1)-1:0] 	ddr3_cs_n;
  	wire 	[ODT_WIDTH-1:0]   	ddr3_odt;
  	reg 	[1-1:0]             ddr3_cke;
  	wire 	[DM_WIDTH-1:0]      ddr3_dm;
  	wire 	[DQS_WIDTH-1:0]     ddr3_dqs_p;
  	wire 	[DQS_WIDTH-1:0]     ddr3_dqs_n;
  	reg 	[1-1:0]             ddr3_ck_p;
  	reg 	[1-1:0]             ddr3_ck_n;

	DataPath DP_uut(
	  	.CLK        (CLK),
	  	.EN         (EN),
	  	.START		(START),
	  	.RSTn       (RSTn),
	  	.OK			(OK),

		// DDR3
		.ddr3_reset_n   (ddr3_reset_n),
		.ddr3_ck_p      (ddr3_ck_p),
		.ddr3_ck_n      (ddr3_ck_n),
		.ddr3_cke       (ddr3_cke),
		.ddr3_ras_n     (ddr3_ras_n),
		.ddr3_cas_n     (ddr3_cas_n),
		.ddr3_we_n      (ddr3_we_n),
		.ddr3_dm	  	(ddr3_dm),
		.ddr3_ba        (ddr3_ba),
		.ddr3_addr      (ddr3_addr),
		.ddr3_dq        (ddr3_dq),
		.ddr3_dqs_p     (ddr3_dqs_p),
		.ddr3_dqs_n     (ddr3_dqs_n),
		.ddr3_odt       (ddr3_odt)
	);

	assign ddr3_cs_n =  {(CS_WIDTH*1){1'b0}};

	ddr3_model ddr3 (
        .rst_n      (ddr3_reset_n),
        .ck         (ddr3_ck_p),
        .ck_n       (ddr3_ck_n),
        .cke        (ddr3_cke),
        .cs_n       (ddr3_cs_n),
        .ras_n      (ddr3_ras_n),
        .cas_n      (ddr3_cas_n),
        .we_n       (ddr3_we_n),
        .dm_tdqs    (ddr3_dm),
        .ba         (ddr3_ba),
        .addr       (ddr3_addr),
        .dq         (ddr3_dq),
        .dqs        (ddr3_dqs_p),
        .dqs_n      (ddr3_dqs_n),
        .tdqs_n     (),
        .odt        (ddr3_odt)
    );

	integer instr_file;
	integer instr_toload[2 << (16)];
	integer instr_cnt = 0;

	integer data_file;
	integer data_toload[2 << (16)];
	integer data_cnt = 0;

	initial begin
		RSTn 	= 1'b1;	// Resetting the architecture while loading data
		#1
		RSTn 	= 1'b0;	// Resetting the architecture while loading data
		EN 		= 1'b0;	// Disable the whole architecture
		START 	= 1'b1;

		instr_file = $fopen("./main_hex.txt", "r");
		if (!instr_file) begin
				$display("Error while opening instruction file");
				$stop;
		end

		data_file = $fopen("./data_hex.txt", "r");
		if (!data_file) begin
				$display("Error while opening data file");
				$stop;
		end

		CLK = 1'b0;
	end

	integer instr_load_finish = 0;
	integer instr_address = 0;

	integer data_load_finish = 0;
	integer data_address = 0;

	integer CLK_Count = 0;
	integer CLK_Count1 = 0;

	integer TB_CLOCK = 5;

	always begin
		if (data_load_finish == 0) begin
			#TB_CLOCK; CLK = ~CLK;
		end
		else begin
			#TB_CLOCK; CLK = ~CLK;
			if (OK == 1'b1) begin
				$display("The total numer of clock rising edges is %d", CLK_Count);
				$display("The total amount of instruction is 69, ALU: 43, Jump: 3, Branch: 13, Memory: 10");
				$display("The CPI\t is %f", shortreal'(CLK_Count)/69);
				$display("The CPI1\t is %f", shortreal'(CLK_Count1)/69);
				$stop;
			end
		end
	end

	always @ (posedge CLK) begin
		CLK_Count = CLK_Count + 1;
	end

endmodule
