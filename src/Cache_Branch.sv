import my_pkg::*;

module Cache_Branch (
	input wire [7:2] op1,
	output CACHE_BRANCH data_out
);
	reg [2:0] add;

	always_comb begin
		if(op1[4:2] != 3'b101) begin
			add <= op1[4:2];
		end 
		else begin
			if(op1[7] == 1'b0) begin
				add <= op1[4:2];
			end 
			else begin 
				add <= 3'b111;
			end 
		end
	end

always @ (add) begin
	data_out.V		= 1'b0; 
	data_out.TAG	= 6'b0; 
	data_out.TA		= 32'b0; 
	data_out.T		= 1'b0;
	case(add)
		//branch
		3'b000: begin data_out.V=1'b1; data_out.TAG=6'b000011; data_out.TA=32'b0; data_out.T=1'b0; end   //ble a1, a4, minv 0x0400060
		3'b001: begin data_out.V=1'b1; data_out.TAG=6'b000100; data_out.TA=32'h40008c; data_out.T=1'b1; end	//ble a2, a5, minv2 0x0400084
		3'b011: begin data_out.V=1'b1; data_out.TAG=6'b000100; data_out.TA=32'h400070; data_out.T=1'b1; end	//bne a0, a4, minv3 0x040008c

		//jump
		3'b101: begin data_out.V=1'b1; data_out.TAG=6'b000000; data_out.TA=32'h40001c; data_out.T=1'b1; end	//jal ra, main 0x0400014 
		3'b100: begin data_out.V=1'b1; data_out.TAG=6'b000001; data_out.TA=32'h40004c; data_out.T=1'b1; end	//jal ra, minv 0x0400030
		3'b110: begin data_out.V=1'b1; data_out.TAG=6'b000000; data_out.TA=32'h400018; data_out.T=1'b1; end	//j el         0x0400018
		3'b111: begin data_out.V=1'b1; data_out.TAG=6'b000100; data_out.TA=32'h400034; data_out.T=1'b1; end	//jarl / ret   0x0400094
		3'b010: begin data_out.V=1'b1; data_out.TAG=6'b000010; data_out.TA=32'h400018; data_out.T=1'b1; end	//jarl / ret   0x0400048
	endcase
end
endmodule
