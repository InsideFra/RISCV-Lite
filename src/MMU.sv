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

module MMU_Block (
    input EN, CLK, RSTn,
    input [31:0] PC,

    // For writing into the Instruction Memory
    input           TB_LOAD_PROGRAM_CTRL,
	input 	[31:0] 	TB_LOAD_PROGRAM_DATA,
	input 	[19:0]	TB_LOAD_PROGRAM_ADDR,

    input   PC_Changed,

    output  [31:0]  data,
    output  busy_reading,
    output  TEST_EN_OUT,

    output I_FSM_STALL_FETCH
);

reg [31:0] _data;
reg _busy_reading;

reg _PC_Changed;
reg _FSM_PCSrc;

assign _PC_Changed = PC_Changed;

reg [19:0] _instr_ram_address;
reg [31:0] _instr_ram_din;
reg [31:0] _instr_ram_dout;
reg _instr_ram_wea;
reg _instr_ram_ena;
reg TEST_MEM_MUX;

reg TEST_EN;
reg TEST_MEM_WE;
reg [31:0] TEST_MEM_DATA;
assign TEST_MEM_MUX = !TEST_EN;
assign TEST_MEM_DATA = _instr_ram_dout;
assign TEST_EN_OUT = TEST_EN;

reg _I_FSM_STALL_FETCH;
wire FSM_STALL_FETCH;
reg _I_RAM_SELECTED;

// blk_mem_gen_0 instr_mem0(
single_port_ram instr_mem0(
	.clka  	(CLK),
	.ena  	(_instr_ram_ena),
	.wea  	(_instr_ram_wea),
	.addra 	(_instr_ram_address),
	.dina  	(_instr_ram_din),
	.douta 	(_instr_ram_dout)
);

I_FSM I_FSM0(
  .MEM_WE      (_instr_ram_wea),
  .clk         (CLK        ),
  .rstn        (RSTn       ),
  .PC_changed  (_PC_Changed),
  .TEST_MEM_DATA(TEST_MEM_DATA),
  .I_RAM_SELECTED(_I_RAM_SELECTED),

  .MEM_CSB_OUT (_instr_ram_ena),
  .I_FSM_STALL_FETCH    (_I_FSM_STALL_FETCH),
  .TEST_EN	   (TEST_EN),
  .TEST_MEM_WE (TEST_MEM_WE)
);

reg [15:0] _instr_rom_address;
reg [31:0] _instr_rom_data_out;
rom instr_rom(
    .a (_instr_rom_address),
    .spo (_instr_rom_data_out)
);

// always @(posedge CLK) begin
always @ (*) begin
    if (TB_LOAD_PROGRAM_CTRL == 1'b1) begin
        _instr_rom_address  <= Z;

        _I_RAM_SELECTED <= 1'b1;
        _instr_ram_address  <= TB_LOAD_PROGRAM_ADDR;
        _instr_ram_din      <= TB_LOAD_PROGRAM_DATA;
        _instr_ram_wea      <= 1'b1;

        _data               <= Z;
    end

    else if ((PC >= 0) & (PC <= 32'hffff)) begin
        _instr_rom_address  <= {2'b00, PC[15:2]};

        _I_RAM_SELECTED     <= 1'b0;
        _instr_ram_address  <= Z;
        _instr_ram_din      <= Z;
        _instr_ram_wea      <= 1'b0;

        _data               <= _instr_rom_data_out;
    end
    else begin
        _instr_rom_address  <= Z;
        _data               <= _instr_ram_dout;

        if (TEST_MEM_MUX == 1'b1) begin
            _I_RAM_SELECTED     <= 1'b1;
            _instr_ram_address  <= 20'b1;
            _instr_ram_din      <= 32'hFFFFFFFF;
            _instr_ram_wea      <= TEST_MEM_WE;
        end
		else begin
            _I_RAM_SELECTED     <= 1'b1;
			_instr_ram_address  <= PC[19:0];
            _instr_ram_din      <= 32'h0;
            _instr_ram_wea      <= 1'b0;
        end
    end
end

assign data = _data;
assign busy_reading = _busy_reading;
assign I_FSM_STALL_FETCH = _I_FSM_STALL_FETCH & _I_RAM_SELECTED;

reg [63:0] _mtime_value;

mtime mtime_reg(
    .CLK(CLK),
    .EN(EN),
    .RSTn(RSTn),
    .mtime_value(_mtime_value)
);

endmodule