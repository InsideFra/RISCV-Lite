import my_pkg::*;
`timescale 1 ns / 100 ps
module Hazard_Ctrl_Unit (	input HAZARD_ctrl_i HAZARD_i, 
							output HAZARD_ctrl_o HAZARD_o);
		always @ (HAZARD_i.MemRead, HAZARD_i.rs1, HAZARD_i.rs2, HAZARD_i.Pcsrc) begin
				if (HAZARD_i.Pcsrc) begin
						// Need to stall the pipeline due to a branch taken.
						HAZARD_o.Ctrl_Mux_EX <= 0; 	// next cycle nop in memory
						HAZARD_o.Ctrl_Mux_DE <= 0; 	// next cycle nop in execute
						HAZARD_o.En_IFID <= 0; 		// next cycle nop in decode
						HAZARD_o.En_PC <= 1;		// next cycle branch in fetch
				end
				else if (HAZARD_i.MemRead) begin
					if ((HAZARD_i.rd == HAZARD_i.rs1) || (HAZARD_i.rd == HAZARD_i.rs2)) begin
						// Need to stall the pipeline
						HAZARD_o.Ctrl_Mux_EX <= 0;	// next cycle nop in memory
						HAZARD_o.Ctrl_Mux_DE <= 0;	// next cycle nop in execute
						HAZARD_o.En_IFID <= 0;    	// next cycle nop in decode
						HAZARD_o.En_PC <= 0;      	// next cycle branch in fetch
					end else begin
						HAZARD_o.Ctrl_Mux_EX <= 1;	// next cycle next instruction in memory
						HAZARD_o.Ctrl_Mux_DE <= 1;	// next cycle next instruction in execute
						HAZARD_o.En_IFID <= 1;    	// next cycle next instruction in decode
						HAZARD_o.En_PC <= 1;      	// next cycle pc+4 instruction in fetch
					end	
				end else begin
						HAZARD_o.Ctrl_Mux_EX <= 1;	// next cycle next instruction in memory
						HAZARD_o.Ctrl_Mux_DE <= 1;	// next cycle next instruction in execute
						HAZARD_o.En_IFID <= 1;    	// next cycle next instruction in decode
						HAZARD_o.En_PC <= 1;      	// next cycle pc+4 instruction in fetch
				end
		end
endmodule
