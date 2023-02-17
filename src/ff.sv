module flip_flop (input wire [31:0] d, input wire rstn, clk, en, output reg [31:0] q);
	always @ (posedge clk) begin
	if(!rstn)
		q <= 32'b0;
	else if (en == 1'b1)
		q <= d;
	else 
		q <= q;
	end
endmodule

module flip_flop_pc (input wire [31:0] d, input wire rstn, clk, en, output reg [31:0] q);
	always @ (posedge clk) begin
	if(!rstn)
		q <= 32'h400000;
	else if (en == 1'b1)
		q <= d;
	else 
		q <= q;
	end
endmodule

module flip_flop1 (input wire d, input wire rstn, clk, en, output reg q);
	always @ (posedge clk) begin
	if(!rstn)
		q <= 1'h0;
	else if (en == 1'b1)
		q <= d;
	else 
		q <= q;
	end
endmodule

module flip_flop_falling (input wire d, input wire rstn, clk, en, output reg q);
	always @ (negedge clk) begin
	if(!rstn)
		q <= 1'h0;
	else if (en == 1'b1)
		q <= d;
	else 
		q <= q;
	end
endmodule
