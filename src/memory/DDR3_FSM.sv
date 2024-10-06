module ddr3_controller_fsm #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 128
)
(
    input  wire         clk,               // Clock signal
    input  wire         rst_n,             // Active-low reset
    input  wire         EN,

    input [DATA_WIDTH-1:0]      write_fifo_data,
    input                       write_fifo_empty,
    input [ADDRESS_WIDTH-1:0]   write_fifo_address,

    input [ADDRESS_WIDTH-1:0]   read_in_fifo_address,
    input                       read_in_fifo_empty,

    output reg  [28:0]  app_addr,          // Address to memory controller
    output reg  [2:0]   app_cmd,           // Command to memory controller
    output reg          app_en,            // Enable signal to memory controller
    output reg  [127:0] app_wdf_data,      // Write data to memory controller (127-bit wide)
    output reg          app_wdf_wren,      // Write data strobe
    output reg  [15:0]  app_wdf_mask,      // Write data mask

    input  wire         app_rdy,           // Controller ready for command
    input  wire         app_wdf_rdy,       // Write FIFO ready for data
    input  wire         app_wdf_end,       // Write data end signal
    input  wire [127:0] app_rd_data,       // Read data from memory controller (64-bit wide)
    input  wire         app_rd_data_valid, // Read data valid

    output      [ADDRESS_WIDTH-1:0] read_out_fifo_address,
    output                          read_out_fifo_full,
    output      [DATA_WIDTH-1:0]    read_out_fifo_data,

    output              write_fifo_read,
    output              read_in_fifo_read,
    output              read_out_fifo_address_write,
    output              read_out_fifo_data_write
);

    // DDR3 Command definitions
    localparam CMD_WRITE = 3'b000;
    localparam CMD_READ  = 3'b001;

    // FSM states
    typedef enum logic [3:0] {
        IDLE,
        WRITE,
        READ,
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
                if (read_in_fifo_empty == 1'b0) begin
                    if (app_rdy == 1'b1) begin
                        next_state = READ0;
                    end
                end
            end

            READ0: begin
                next_state = READ1;
            end

            READ1: begin
                if read_in_fifo_empty == 1'b0 begin
                    next_state = READ1;
                end
                else begin
                    next_state = IDLE;
                end
            end

            // WRITE_CMD: begin
            //     if (app_rdy && app_wdf_rdy)
            //         next_state = WRITE_DATA;
            // end

            // WRITE_DATA: begin
            //     if (app_wdf_rdy)
            //         next_state = WAIT_WRITE_COMPLETE;
            // end

            // WAIT_WRITE_COMPLETE: begin
            //     if (app_wdf_end)
            //         next_state = DONE;
            // end

            // READ_CMD: begin
            //     if (app_rdy)
            //         next_state = WAIT_READ_DATA;
            // end

            // WAIT_READ_DATA: begin
            //     if (app_rd_data_valid)
            //         next_state = DONE;
            // end

            // DONE: begin
            //     next_state = IDLE;
            // end
        endcase
    end

    // FSM: Output logic and control signals
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            app_addr        <= 29'b0;
            app_cmd         <= 3'b0;
            app_en          <= 1'b0;
            app_wdf_data    <= 128'b0;
            app_wdf_wren    <= 1'b0;
            app_wdf_mask    <= 16'hFF;

            read_in_fifo_read <= 1'b0;
        end else begin

            app_en          <= 1'b0;
            app_wdf_wren    <= 1'b0;

            read_in_fifo_read <= 1'b0;

            case (state)
                IDLE: begin

                end

                // WRITE_CMD: begin
                //     if (app_rdy && app_wdf_rdy) begin
                //         // app_addr <= addr_in;
                //         app_cmd  <= CMD_WRITE;
                //         app_en   <= 1'b1;
                //     end
                // end

                // WRITE_DATA: begin
                //     if (app_wdf_rdy) begin
                //         // Assign the appropriate 32-bit data to the 64-bit bus
                //         app_wdf_data <= write_fifo_data;
                //         app_wdf_mask <= 8'hFF;
                //         app_wdf_wren <= 1'b1;
                //     end
                // end

                // WAIT_WRITE_COMPLETE: begin
                //     // Wait for the write completion signal (app_wdf_end)
                //     if (app_wdf_end) begin
                //     end
                // end

                READ0: begin
                    read_in_fifo_read <= 1'b1;
                end

                READ1: begin
                    if (app_rdy) begin
                        if (read_out_fifo_full != 1'b0) begin
                            app_addr <= read_in_fifo_address[28:0];
                            app_cmd  <= CMD_READ;
                            app_en   <= 1'b1;

                            read_out_fifo_address <= read_in_fifo_address;
                            read_out_fifo_address_write <= 1'b1;

                            if read_in_fifo_empty == 1'b0 begin
                                read_in_fifo_read <= 1'b1;
                            end
                        end
                        else begin
                            read_in_fifo_read <= 1'b0;
                        end
                    end
                    else begin
                        read_in_fifo_read <= 1'b0;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        if (app_rd_data_valid) begin
            read_out_fifo_data <= app_rd_data;
            read_out_fifo_data_write <= 1'b1;
        end
    end

endmodule