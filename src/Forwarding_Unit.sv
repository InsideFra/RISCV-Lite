import my_pkg::*;

module FU_Unit (input 	FU_ctrl_i 	FU_i,
				output 	FU_ctrl_o 	FU_o
);

always @ (FU_i) begin
	// Only if forwarding instruction will write to a register
	if (FU_i.Mem_RegWrite == 1'b1 || FU_i.WB_RegWrite  == 1'b1) begin
		// Only if Rd for that instruction is not R0
		if (FU_i.MEM_in_Rd_EQ0 != 1'b0 || FU_i.WB_in_Rd_EQ0 != 1'b0) begin
			if(FU_i.ALU_src[0]==1'b0)
				case (FU_i.EX_rs1)
					5'b0000 : begin
						FU_o.ForwardA = NOFWA;
					end
					FU_i.Mem_rd : begin
						FU_o.ForwardA = FWA_ALURSLT;
					end
					FU_i.WB_rd : begin
						FU_o.ForwardA = FWA_MEMD;
					end
					default: begin
						FU_o.ForwardA = NOFWA;
					end
				endcase
			else begin
				FU_o.ForwardA = NOFWA;
			end
		end else begin // Default Case = Both Rd are zero
			FU_o.ForwardA = NOFWA;
		end		
	end else begin // Default Case
		FU_o.ForwardA = NOFWA;
	end	
end

always @ (FU_i) begin
	// Only if forwarding instruction will write to a register
	if (FU_i.Mem_RegWrite == 1 || FU_i.WB_RegWrite  == 1) begin
		// Only if Rd for that instruction is not R0
		if (FU_i.MEM_in_Rd_EQ0 != 1'b0 || FU_i.WB_in_Rd_EQ0 != 1'b0) begin
			if(FU_i.ALU_src[1]==1'b0)
				case (FU_i.EX_rs2)
					5'b00000 : begin
						FU_o.ForwardB = NOFWB;
					end
					FU_i.Mem_rd : begin
						FU_o.ForwardB = FWB_ALURSLT;
					end
					FU_i.WB_rd : begin
						FU_o.ForwardB = FWB_MEMD;
					end
					default: begin
						FU_o.ForwardB = NOFWB;
					end
				endcase
			else begin
				FU_o.ForwardB = NOFWB;
			end
		end else begin // Default Case = Both Rd are zero
			FU_o.ForwardB = NOFWB;
		end		
	end else begin // Default Case
		FU_o.ForwardB = NOFWB;
	end	
end
endmodule
