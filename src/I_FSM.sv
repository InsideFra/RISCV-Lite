import my_pkg::*;
module I_FSM(
		input MEM_WE,
		input clk, rstn,
		input match,

		input PC_changed,

		input reg [31:0] TEST_MEM_DATA,

		output FSM_Control_Enum FSM_SEL,
		
		output reg ICACHE_WEn,
		output reg MEM_CSB_OUT,
		output reg PCSrc,

		output reg TEST_EN,
		output reg TEST_MEM_WE
);


		FSM_MEM_states_reg 	current_state;
		FSM_MEM_states_reg 	next_state;

		reg [3:0] counter;
		reg enable_counter;
		reg reset_cnt;
		reg [3:0] max_cnt;

		reg [3:0] counter1;
		reg enable_counter1;
		reg reset_cnt1;
		assign max_cnt = counter1;

		always @ (posedge clk or negedge rstn) begin
			if (!rstn)
				current_state <= STARTUP;
			else
				current_state <= next_state;
		end

		always @ (posedge clk or negedge rstn) begin
			if (!rstn)
				counter  <= 4'b0000;
			else begin
				if (reset_cnt)
					counter  <= 4'b0000;
				else if (enable_counter)
					counter <= counter + 1;
				else
					counter <= counter;
			end
		end
		
		always @ (posedge clk or negedge rstn) begin
			if (!rstn)
				counter1 <= 4'b0000;
			else begin
				if (reset_cnt1)
					counter1 <= 4'b0000;
				else if (enable_counter1)
					counter1 <= counter1 + 1;
				else
					counter1 <= counter1;
			end
		end
		
		always @ (counter, counter1, TEST_MEM_DATA, MEM_WE, PC_changed) begin
			next_state = current_state;
			case (current_state) 
				STARTUP: begin // Wait for reset
					next_state = STARTUP0;
				end
				STARTUP0: begin // Start reading address 1
					next_state = STARTUP1;
				end
				STARTUP1: begin // Wait for ~2^5cc
					if (counter1 == 4'b1101)
						next_state = STARTUP2;
				end
				STARTUP2: begin // Start writing address 1
					next_state = STARTUP3;
				end
				STARTUP3: begin // Start reading address 1
					next_state = STARTUP4;
				end
				STARTUP4: begin // Wait until data valid
					if (TEST_MEM_DATA == 32'hFFFFFFFF)
						next_state = IDLE;
				end
				IDLE: begin
					if (max_cnt == 4'hF)
						next_state = RESTART;
					else if (MEM_WE == 1'b1)
						next_state = MEMREAD;
					else
						next_state = IDLE;
				end
				MEMREAD: begin
					if (PC_changed == 1'b1)
						next_state = IDLE;
					else if (counter == max_cnt)
						next_state = RESTART;
					else
						next_state = MEMREAD;
				end
				RESTART: begin
						next_state = IDLE;
				end
			endcase
		end
		
		always @ (current_state) begin
			TEST_EN 		= 1'b1;
			//TEST_MEM_MUX 	= 1'b0;
			MEM_CSB_OUT 	= 1'b0;
			TEST_MEM_WE 	= 1'b0;
			
			enable_counter1 = 1'b0;
			reset_cnt1 		= 1'b0;
			
			PCSrc 		= 1'b0;
			ICACHE_WEn 	= 1'b1;
			FSM_SEL 	= NOP;
			
			enable_counter  = 1'b0;
			reset_cnt 		= 1'b0;

			case (current_state) 
				STARTUP: begin
					//TEST_EN 		= 1'b1;
					//TEST_MEM_MUX 	= 1'b0;
					//MEM_CSB_OUT		= 1'b0;
					TEST_MEM_WE 	= 1'b1;
					
					reset_cnt = 1'b1;
					reset_cnt1 = 1'b1;
				end
				STARTUP0: begin
					TEST_EN 		= 1'b0;
					//TEST_MEM_MUX 	= 1'b1;
					//MEM_CSB_OUT		= 1'b0;
					TEST_MEM_WE 	= 1'b1;
					
					enable_counter1 = 1'b1;
					
					reset_cnt = 1'b1;
				end
				STARTUP1: begin
					TEST_EN 		= 1'b0;
					//TEST_MEM_MUX 	= 1'b1;
					MEM_CSB_OUT		= 1'b1;
					TEST_MEM_WE 	= 1'b1;
					
					enable_counter1 = 1'b1;
					
					reset_cnt = 1'b1;
				end
				STARTUP2: begin
					TEST_EN 		= 1'b0;
					//TEST_MEM_MUX 	= 1'b1;
					//MEM_CSB_OUT 	= 1'b0;
					//TEST_MEM_WE 	= 1'b0;
					
					//enable_counter1 = 1'b0;
					
					reset_cnt = 1'b1;
				end
				STARTUP3: begin
					TEST_EN 		= 1'b0;
					//TEST_MEM_MUX 	= 1'b1;
					//MEM_CSB_OUT 	= 1'b0;
					TEST_MEM_WE 	= 1'b1;
					
					enable_counter1 = 1'b1;
					
					reset_cnt = 1'b1;
				end
				STARTUP4: begin
					TEST_EN 		= 1'b0;
					//TEST_MEM_MUX 	= 1'b1;
					MEM_CSB_OUT 	= 1'b1;
					TEST_MEM_WE 	= 1'b1;
					
					enable_counter1 = 1'b1;
					
					reset_cnt = 1'b1;
				end
				IDLE: begin
					//MEM_CSB_OUT = 1'b0;
					PCSrc = 1'b0;
					ICACHE_WEn = 1'b1;
					FSM_SEL = NOP;
					
					enable_counter = 1'b0;
					reset_cnt = 1'b1;
				end
				MEMREAD: begin
					MEM_CSB_OUT = 1'b1;
					PCSrc = 1'b0;
					ICACHE_WEn = 1'b1;
					FSM_SEL = NOP;
					
					enable_counter = 1'b1;
					reset_cnt = 1'b0;
				end
				RESTART: begin
					MEM_CSB_OUT = 1'b1;
					PCSrc = 1'b1;
					ICACHE_WEn = 1'b0;
					FSM_SEL = IMEM;	
					
					enable_counter = 1'b0;
					reset_cnt = 1'b1;
				end
			endcase
		end

endmodule
