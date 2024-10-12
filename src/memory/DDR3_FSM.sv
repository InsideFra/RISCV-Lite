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

    input  reg                  read_out_fifo_empty,

    input  reg                  read_out_fifo_full,

    output reg  [28:0]  app_addr,          // Address to memory controller
    output reg  [2:0]   app_cmd,           // Command to memory controller
    output reg          app_en,            // Enable signal to memory controller
    output reg  [127:0] app_wdf_data,      // Write data to memory controller (127-bit wide)
    output reg          app_wdf_wren,      // Write data strobe
    output reg  [15:0]  app_wdf_mask,      // Write data mask

    input  wire         app_rdy,           // Controller ready for command
    input  wire         app_wdf_rdy,       // Write FIFO ready for data
    input  wire [127:0] app_rd_data,       // Read data from memory controller (64-bit wide)
    input  wire         app_rd_data_valid, // Read data valid

    output reg          app_wdf_end,       // Write data end signal

    output reg  [ADDRESS_WIDTH-1:0] read_out_fifo_address,
    output reg  [DATA_WIDTH-1:0]    read_out_fifo_data,

    output reg          write_fifo_read,
    output reg          read_in_fifo_read,
    output reg          read_out_fifo_address_write,
    output reg          read_out_fifo_data_write
);

    // DDR3 Command definitions
    localparam CMD_WRITE = 3'b000;
    localparam CMD_READ  = 3'b001;

    // FSM states
    typedef enum logic [3:0] {
        IDLE,
        WRITE0,
        WRITE1,
        READ0,
        READ1
    } state_t;

    state_t state, next_state;

    // FSM: State transition
    always_ff @(posedge clk) begin
        if (!EN | !rst_n)
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
                else if (write_fifo_empty == 1'b0) begin
                    if (app_wdf_rdy == 1'b1) begin
                        next_state = WRITE0;
                    end
                end
            end

            READ0: begin
                next_state = READ1;
            end

            READ1: begin
                if (read_in_fifo_empty == 1'b0) begin
                    next_state = READ1;
                end
                else begin
                    next_state = IDLE;
                end
            end

            WRITE0: begin
                next_state = WRITE1;
            end

            WRITE1: begin
                if (write_fifo_empty == 1'b0) begin
                    next_state = WRITE1;
                end
                else begin
                    next_state = IDLE;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // FSM: Output logic and control signals
    always_ff @(posedge clk) begin
        app_addr        <= 29'b0;
        app_cmd         <= 3'b0;
        app_en          <= 1'b0;
        app_wdf_data    <= 128'b0;
        app_wdf_wren    <= 1'b0;
        app_wdf_mask    <= 16'hFFFF;
        app_wdf_end     <= 1'b0;

        read_in_fifo_read   <= 1'b0;
        write_fifo_read     <= 1'b0;

        read_out_fifo_address       <= 0;
        read_out_fifo_address_write <= 1'b0;

        if (!EN | !rst_n) begin
            ;
        end else begin
            case (state)
                IDLE: begin

                end

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

                            if (read_in_fifo_empty == 1'b0) begin
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

                WRITE0: begin
                    write_fifo_read <= 1'b1;
                end

                WRITE1: begin
                    // if (app_rdy & app_wdf_rdy) begin
                            // Assign the appropriate 32-bit data to the 64-bit bus
                            app_wdf_data <= write_fifo_data;
                            app_wdf_mask <= 16'hFFFF;
                            app_wdf_wren <= 1'b1;

                            app_addr <= write_fifo_address[28:0];
                            app_cmd  <= CMD_WRITE;
                            app_en   <= 1'b1;

                            if (write_fifo_empty == 1'b0) begin
                                write_fifo_read <= 1'b1;
                            end
                    // end
                    else begin
                        write_fifo_read <= 1'b0;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        if (EN == 1'b0) begin
            read_out_fifo_data          <= 0;
            read_out_fifo_data_write    <= 1'b0;
        end
        else begin
            if (app_rd_data_valid) begin
                read_out_fifo_data          <= app_rd_data;
                read_out_fifo_data_write    <= 1'b1;
            end
            else begin
                read_out_fifo_data          <= 0;
                read_out_fifo_data_write    <= 1'b0;
            end
        end
    end

endmodule