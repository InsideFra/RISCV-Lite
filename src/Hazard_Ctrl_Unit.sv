import my_pkg::*;
`timescale 1 ns / 100 ps
module Hazard_Ctrl_Unit (
	input HAZARD_ctrl_i HAZARD_i, 
	output HAZARD_ctrl_o HAZARD_o
);
	
	//mask hazard fo correct prediction
	
	//PCsrc logic
	// MEM_in_M_jump comes from the execution stage and tells that there's a jump instruction
	// MEM_in_M_branch comes from the execution stage and tells that there's a branch instruction
	// MEM_in_bit_branch comes from the execution stage and tells if the branch must be executed or not
	assign branch = 
		 HAZARD_i.MEM_in_M_jump | 
		(HAZARD_i.MEM_in_M_branch & HAZARD_i.MEM_in_bit_branch);  
	
	reg Ctrl_Mux_EX; 
	reg Ctrl_Mux_DE; 
	reg En_IFID; 
	reg En_PC;
	
	always @ (HAZARD_i.MemRead, HAZARD_i.rs1, HAZARD_i.rs2, branch) begin
			if (branch) begin
					// Need to stall the pipeline due to a branch taken.
					Ctrl_Mux_EX <= 0; 	// next cycle nop in memory
					Ctrl_Mux_DE <= 0; 	// next cycle nop in execute
					En_IFID <= 0; 		// next cycle nop in decode
					En_PC <= 1;		// next cycle branch in fetch
			end
			else if (HAZARD_i.MemRead) begin
				if ((HAZARD_i.rd == HAZARD_i.rs1) || (HAZARD_i.rd == HAZARD_i.rs2)) begin
					// Need to stall the pipeline
					Ctrl_Mux_EX <= 0;	// next cycle nop in memory
					Ctrl_Mux_DE <= 0;	// next cycle nop in execute
					En_IFID <= 0;    	// next cycle nop in decode
					En_PC <= 0;      	// next cycle branch in fetch
				end else begin
					Ctrl_Mux_EX <= 1;	// next cycle next instruction in memory
					Ctrl_Mux_DE <= 1;	// next cycle next instruction in execute
					En_IFID <= 1;    	// next cycle next instruction in decode
					En_PC <= 1;      	// next cycle pc+4 instruction in fetch
				end	
			end else begin
					Ctrl_Mux_EX <= 1;	// next cycle next instruction in memory
					Ctrl_Mux_DE <= 1;	// next cycle next instruction in execute
					En_IFID <= 1;    	// next cycle next instruction in decode
					En_PC <= 1;      	// next cycle pc+4 instruction in fetch
			end
	end
	
	assign HAZARD_o.Ctrl_Mux_EX 	= Ctrl_Mux_EX; 	// next cycle nop in memory
	assign HAZARD_o.Ctrl_Mux_DE 	= Ctrl_Mux_DE; 	// next cycle nop in execute
	assign HAZARD_o.En_IFID 		= En_IFID; 		// next cycle nop in decode
	assign HAZARD_o.En_PC 			= En_PC & HAZARD_i.FSM_PCSrc;	// next cycle branch in fetch
	
	assign HAZARD_o.PCSrc			= HAZARD_i.FSM_PCSrc == 1'b1 ? (branch == 1'b1 ? (HAZARD_i.MEM_in_M_AddtoPC ? branch_alu : branch_pc_jump) : next_pc) : nop;
endmodule
