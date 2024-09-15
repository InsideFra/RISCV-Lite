import my_pkg::*;
module FSM(
		input chipselect,
		input write_enable,
		input chipselect_EX,
		input write_enable_EX,
		input clk,
		input rstn,

		input reg [31:0] TEST_MEM_DATA,

		output reg enable_cs,
		output reg STOP_Pipelinen,
		
		output reg TEST_EN,
		output reg TEST_MEM_CSB,
		output reg TEST_MEM_WE
);


		FSM_MEM_states_reg 	current_state;
		FSM_MEM_states_reg 	next_state;

		reg [3:0] counter;
		reg enable_counter;
		reg reset_cnt;
		reg [3:0] max_cnt;

		reg [3:0] TEST_counter;
		reg EN_TEST_counter;
		reg RST_TEST_counter;
		
		assign max_cnt = 2;

		always @ (posedge clk) begin
			if (!rstn)
				current_state <= STARTUP;
			else
				current_state <= next_state;
		end
		
		always @ (posedge clk) begin
			if (rstn == 1'b0 || reset_cnt == 1'b1)
				counter = 4'b0000;
			else begin
				if (enable_counter == 1'b1)
					counter = counter + 1;
				else
					counter = counter;
			end
		end
		
		always @ (posedge clk) begin
			if (rstn == 1'b0 || RST_TEST_counter == 1'b1)
				TEST_counter = 4'b0000;
			else begin
				if (EN_TEST_counter == 1'b1)
					TEST_counter = TEST_counter + 1;
				else
					TEST_counter = TEST_counter;
			end
		end

		always @ (*) begin
			next_state = current_state;
			case (current_state)
				STARTUP: 
					next_state = STARTUP0;
				STARTUP0: 
					next_state = STARTUP1;
				STARTUP1:
					if (TEST_counter == 4'b1101)
						next_state = STARTUP2;
				STARTUP2:
					next_state = STARTUP3;
				STARTUP3:
					next_state = STARTUP4;
				STARTUP4:
					if (TEST_MEM_DATA == 32'hFFFFFFFF)
						next_state = IDLE;
				IDLE: begin
					if (chipselect_EX == 1'b0 & write_enable_EX == 1'b1)
						next_state = MEMREAD1;
					else
						next_state = IDLE;
				end
				MEMREAD1: begin
					if (max_cnt == 0)
						next_state = RESTART;
					else
						next_state = MEMREAD2;
				end
				MEMREAD2: begin
					if (counter == max_cnt)
						next_state = RESTART;
				end
				RESTART: begin
					next_state = IDLE;
				end
			endcase
		end

		always @ (*) begin
			enable_counter 	= 1'b0;
			reset_cnt 		= 1'b1;
			STOP_Pipelinen 	= 1'b1;
			enable_cs 		= 1'b0; // Do not influence the CSB
		
			EN_TEST_counter  = 1'b0;
			RST_TEST_counter = 1'b0;
		
			TEST_EN 		= 1'b0;
			TEST_MEM_CSB 	= 1'b1;
			TEST_MEM_WE 	= 1'b0;
			
			case (current_state) 
				STARTUP: begin // Waiting for the ENABLE signal from testbench
					TEST_EN	 		= 1'b1; // Initialize the TEST Phase
					
					TEST_MEM_CSB 	= 1'b1;	// Enable Memory
					TEST_MEM_WE 	= 1'b0; // Select Read Operation
					
					STOP_Pipelinen 	= 1'b0;
				end
				STARTUP0: begin // Reading address 0x1
					TEST_EN	 		= 1'b1; // Initialize the TEST Phase
					
					TEST_MEM_CSB 	= 1'b1;	// Enable Memory
					TEST_MEM_WE 	= 1'b0; // Select Read Operation
					
					STOP_Pipelinen 	= 1'b0;
			
					EN_TEST_counter = 1'b1;
				end
				STARTUP1: begin // Waiting for ~32cc
					TEST_EN 		= 1'b1; // Initialize the TEST Phase
					
					TEST_MEM_CSB 	= 1'b0; // Disable Memory 
					TEST_MEM_WE 	= 1'b0;
					
					STOP_Pipelinen 	= 1'b0;
					
					EN_TEST_counter = 1'b1;
				end
				STARTUP2: begin // Writing address 0x1
					TEST_EN 		= 1'b1; // Initialize the TEST Phase
					
					TEST_MEM_CSB 	= 1'b1; // Enable Memory
					TEST_MEM_WE 	= 1'b1; // Select Write operation
					
					STOP_Pipelinen 	= 1'b0;

					EN_TEST_counter = 1'b0;
				end
				STARTUP3: begin // Reading address 0x1
					TEST_EN 		= 1'b1; // Initialize the TEST Phase
					
					TEST_MEM_CSB 	= 1'b1; // Enable Memory
					TEST_MEM_WE 	= 1'b0; // Select Read operation
					
					STOP_Pipelinen 	= 1'b0;

					EN_TEST_counter = 1'b1;
				end
				STARTUP4: begin // Waiting for reading
					TEST_EN 		= 1'b1; // Initialize the TEST Phase
					
					TEST_MEM_CSB 	= 1'b1; // Enable Memory
					TEST_MEM_WE 	= 1'b0; // Select Read operation
					
					STOP_Pipelinen 	= 1'b0;

					EN_TEST_counter = 1'b1;
				end
				IDLE: begin 
					EN_TEST_counter = 1'b0;	
				end
				MEMREAD1: begin
					enable_counter 	= 1'b1;
					reset_cnt 		= 1'b0;
					
					STOP_Pipelinen 	= 1'b0;
					
					enable_cs 	= 1'b0;
				end
				MEMREAD2: begin
					enable_counter 	= 1'b1;
					reset_cnt 		= 1'b0;
					
					STOP_Pipelinen 	= 1'b0;
					
					enable_cs 	= 1'b1; // Force CSB to 1
				end
				RESTART: begin
					enable_cs = 1'b1;
					
					reset_cnt 	= 1'b1;
				end
			endcase
		end
endmodule
