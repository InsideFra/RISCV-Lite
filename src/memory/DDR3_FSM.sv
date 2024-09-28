module ddr3_controller_fsm (
    input  wire         clk,               // Clock signal
    input  wire         rst_n,             // Active-low reset
    input  wire [28:0]  addr_in,           // Address input for read/write
    input  wire [31:0]  write_data_in,     // 32-bit data input for write
    input  wire         read_req,          // Read request signal
    input  wire         write_req,         // Write request signal
    input  wire         bit32_select,      // 1 for upper 32 bits, 0 for lower 32 bits

    output reg  [28:0]  app_addr,          // Address to memory controller
    output reg  [2:0]   app_cmd,           // Command to memory controller
    output reg          app_en,            // Enable signal to memory controller
    output reg  [63:0]  app_wdf_data,      // Write data to memory controller (64-bit wide)
    output reg          app_wdf_wren,      // Write data strobe
    output reg  [7:0]   app_wdf_mask,      // Write data mask

    input  wire         app_rdy,           // Controller ready for command
    input  wire         app_wdf_rdy,       // Write FIFO ready for data
    input  wire         app_wdf_end,       // Write data end signal
    input  wire [63:0]  app_rd_data,       // Read data from memory controller (64-bit wide)
    input  wire         app_rd_data_valid, // Read data valid
    output reg          read_data_valid,   // Read data valid output
    output reg [31:0]   read_data_out,     // Read data output (32-bit)

    output reg          write_ready,       // Indicates when the controller is ready for a new write request
    output reg          read_ready         // Indicates when the controller is ready for a new read request
);

    // DDR3 Command definitions
    localparam CMD_WRITE = 3'b000;
    localparam CMD_READ  = 3'b001;

    // FSM states
    typedef enum logic [3:0] {
        IDLE,
        WRITE_CMD,
        WRITE_DATA,
        WAIT_WRITE_COMPLETE,
        READ_CMD,
        WAIT_READ_DATA,
        DONE
    } state_t;

    state_t state, next_state;

    // FSM: State transition
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM: State transition logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (write_req)
                    next_state = WRITE_CMD;
                else if (read_req)
                    next_state = READ_CMD;
            end

            WRITE_CMD: begin
                if (app_rdy && app_wdf_rdy)
                    next_state = WRITE_DATA;
            end

            WRITE_DATA: begin
                if (app_wdf_rdy)
                    next_state = WAIT_WRITE_COMPLETE;
            end

            WAIT_WRITE_COMPLETE: begin
                if (app_wdf_end)
                    next_state = DONE;
            end

            READ_CMD: begin
                if (app_rdy)
                    next_state = WAIT_READ_DATA;
            end

            WAIT_READ_DATA: begin
                if (app_rd_data_valid)
                    next_state = DONE;
            end

            DONE: begin
                next_state = IDLE;
            end
        endcase
    end

    // FSM: Output logic and control signals
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            app_addr        <= 29'b0;
            app_cmd         <= 3'b0;
            app_en          <= 1'b0;
            app_wdf_data    <= 64'b0;
            app_wdf_wren    <= 1'b0;
            app_wdf_mask    <= 8'hFF;
            read_data_out   <= 32'b0;
            read_data_valid <= 1'b0;
            write_ready     <= 1'b0;
            read_ready      <= 1'b0;
        end else begin
            app_en          <= 1'b0; // Default is disabled
            app_wdf_wren    <= 1'b0;
            read_data_valid <= 1'b0;

            case (state)
                IDLE: begin
                    // Signal readiness for new read/write operations
                    write_ready <= (app_rdy && app_wdf_rdy);
                    read_ready  <= app_rdy;
                end

                WRITE_CMD: begin
                    if (app_rdy && app_wdf_rdy) begin
                        app_addr <= addr_in;
                        app_cmd  <= CMD_WRITE;
                        app_en   <= 1'b1;
                        write_ready <= 1'b0; // Writing now, not ready for new request
                    end
                end

                WRITE_DATA: begin
                    if (app_wdf_rdy) begin
                        // Assign the appropriate 32-bit data to the 64-bit bus
                        if (bit32_select)
                            app_wdf_data <= {write_data_in, 32'b0}; // Upper 32 bits
                        else
                            app_wdf_data <= {32'b0, write_data_in}; // Lower 32 bits

                        // Set the mask to only allow writing 32 bits
                        if (bit32_select)
                            app_wdf_mask <= 8'b00001111;  // Mask lower 32 bits, write upper 32 bits
                        else
                            app_wdf_mask <= 8'b11110000;  // Mask upper 32 bits, write lower 32 bits

                        app_wdf_wren <= 1'b1;
                    end
                end

                WAIT_WRITE_COMPLETE: begin
                    // Wait for the write completion signal (app_wdf_end)
                    if (app_wdf_end) begin
                        write_ready <= 1'b1; // Ready for a new write request
                    end
                end

                READ_CMD: begin
                    if (app_rdy) begin
                        app_addr <= addr_in;
                        app_cmd  <= CMD_READ;
                        app_en   <= 1'b1;
                        read_ready <= 1'b0; // Reading now, not ready for new request
                    end
                end

                WAIT_READ_DATA: begin
                    if (app_rd_data_valid) begin
                        // Extract the correct 32 bits based on the select signal
                        if (bit32_select)
                            read_data_out <= app_rd_data[63:32]; // Upper 32 bits
                        else
                            read_data_out <= app_rd_data[31:0];  // Lower 32 bits

                        read_data_valid <= 1'b1;
                        read_ready <= 1'b1; // Ready for a new read request
                    end
                end

                DONE: begin
                    // Return to IDLE, reset signals
                    write_ready <= 1'b1; // Ready for a new write request
                    read_ready  <= 1'b1; // Ready for a new read request
                end
            endcase
        end
    end

endmodule