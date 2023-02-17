import my_pkg::*;

module Branch_Fetch (
	input wire[5:0] TAG_PC, // to check if the address is correct
	input wire[31:0] next_add_PC, // next address in case of wrong taken prediction
	input CACHE_BRANCH data_out_CACHE,
	input wire wrong_P, // raise when prediction is not correct (branch is not taken)
	output reg sel_MUX_Branch_P, // change value of PC in case of prediction or correction
	output reg [31:0] add_P, // new value of PC by prediction o correction
	output reg P // bit to memorize a prediction (it is necessary to check correctness)
);

always @(wrong_P,add_P,next_add_PC,data_out_CACHE) begin
	if(wrong_P) begin // if previus prediction is wrong it is necessary to store old PC value
		add_P <= next_add_PC; // old PC value (incremented)
		sel_MUX_Branch_P <= 1'b1;
		P <= 1'b0;
	end
	else begin
		if (data_out_CACHE.V==1'b1 && TAG_PC==data_out_CACHE.TAG && data_out_CACHE.T==1'b1)
			begin // prediction taken branch
			sel_MUX_Branch_P <= 1'b1; // change value PC
			add_P <= data_out_CACHE.TA; // target address in cache
			P <= 1'b1;
		end
		else
			begin // prediction untaken branch
			sel_MUX_Branch_P <= 1'b0; 
			add_P <= 32'b0;
			P <= 1'b0;
		end
	end		
end
endmodule
