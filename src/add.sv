module add_unit (
		input wire [31:0] op1,
		input wire [31:0] op2,
		output wire [31:0] result
);
		assign result = op1 + op2;
endmodule

module add_unit1 (
		input wire [31:0] op1,
		output wire [31:0] result
);
		assign result = op1 + 4;
endmodule
