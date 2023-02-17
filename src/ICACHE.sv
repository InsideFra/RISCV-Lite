module ICACHE (
		input unsigned [3:0] offset,
		input [3:0] TAG_in,
		input write_enable_n,
		input [31:0] write_data,
		input RSTn,
		input CLK,
		input EN,
	   	
		output reg match,
		output reg [31:0] data
);

		reg [31:0] 	row [15:0];
		reg			valid [15:0];
		reg [3:0]	TAG [15:0];

		integer i;

		always @ (*) begin
			if (valid[offset] == 1'b1) begin // Addressed Valid data in cache
				if(TAG[offset] == TAG_in) begin // Valid data in cache matches the TAG
					match = 1'b1;
					data = row[offset];	
				end
				else begin // Valid data in cache does not matches the TAG
					match = 1'b0;
					data = 32'bX;
				end
			end
			else begin // Addressed Not Valid data in cache
				match = 1'b0;
				data = 32'bX;
			end
			
		end

		always @ (posedge CLK) begin
			if (RSTn == 1'b0) begin
				for (i = 0; i < 16; i++) begin
					row[i] 		<= 31'b0;
					valid[i] 	<= 1'b0;
					TAG[i] 		<= 1'b0;
				end
			end
			if (write_enable_n == 1'b0 && EN == 1'b1) begin // Writing
					//$display($time, " Writing %0h in row %0d", write_data, offset);
					valid[offset] <= 1'b1;
					row[offset] <= write_data;
					TAG[offset] <= TAG_in;	
			end	
		end
endmodule
