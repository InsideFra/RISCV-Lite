module ddr3_cache (
    input clk,
    input rst_n,
    input [31:0] address,
    input [31:0] write_data,
    input read,
    input write,

    // Write FIFO
    input reg write_fifo_full,

    // Read IN FIFO
    input reg read_in_fifo_full,

    // Read OUT FIFO
    input reg read_out_fifo_full,
    input reg [127:0]   read_out_fifo_data,
    input reg [31:0]    read_out_fifo_address,

    // Write FIFO
    output reg  [31:0]  write_into_write_fifo_address,
    output reg  [127:0] write_into_write_fifo_data,
    output reg  write_into_write_fifo,

    // Read IN FIFO
    output reg  [31:0]  write_into_read_in_fifo_address,
    output reg  write_into_read_in_fifo,

    // READ OUT FIFO
    output reg read_into_read_out_fifo,

    output reg [31:0] read_data,
    output reg hit,

    output reg  please_stall_everything
);

    // Cache parameters
    parameter CACHE_SIZE = 256;
    parameter BLOCK_SIZE = 4 + 2;
    parameter TAG_SIZE = 18;
    parameter INDEX_SIZE = 8;

    // Cache storage
    reg [31:0] cache_data[CACHE_SIZE-1:0];
    reg [TAG_SIZE-1:0] cache_tag[CACHE_SIZE-1:0];
    reg cache_valid[CACHE_SIZE-1:0];
    reg cache_dirty[CACHE_SIZE-1:0]; // Dirty bit to indicate modified data
    reg cache_read_in_fifo_request[CACHE_SIZE-1:0];

    // Address breakdown
    wire        [TAG_SIZE-1:0]      tag       = address[31:32-TAG_SIZE];
    wire signed [INDEX_SIZE-1:0]    index     = address[INDEX_SIZE+BLOCK_SIZE-1:BLOCK_SIZE];
    wire        [BLOCK_SIZE-1:2]    offset    = address[BLOCK_SIZE-1:2];

    // Task to handle cache miss
    task handle_cache_miss;
        input [TAG_SIZE-1:0] tag;
        input [INDEX_SIZE-1:0] index;
        integer i;
        begin
            if (cache_valid[index] == 1'b1) begin
                if (write_fifo_full == 1'b0) begin
                    please_stall_everything <= 1'b1;
                    write_into_write_fifo <= 1'b1;
                    write_into_write_fifo_address <= {tag, index, offset};
                    write_into_write_fifo_data <= {cache_data[index], cache_data[index+1], cache_data[index+2], cache_data[index+3]};

                    for (i = 0; i < 4; i = i + 1) begin
                        cache_dirty[index+i] <= 1'b0;
                        cache_valid[index+i] <= 1'b0;
                    end
                end
                else begin
                    please_stall_everything <= 1'b1;
                end
            end
            else begin
                if (read_in_fifo_full == 1'b0) begin
                    please_stall_everything <= 1'b1;
                    write_into_read_in_fifo <= 1'b1;
                    write_into_read_in_fifo_address <= address;
                    for (i=0; i < 4; i = i + 1) begin
                        cache_read_in_fifo_request[index+i] <= 1'b1;
                    end
                end
                else begin
                    please_stall_everything <= 1'b1;
                end
                // else if (read_out_fifo_full == 1'b1) begin
                //     read_into_read_out_fifo <= 1'b1;
                //     for (i=0; i < 4; i = i + 1) begin
                //         cache_dirty[index+i] <= 1'b0;
                //         cache_valid[index+i] <= 1'b1;
                //         cache_data[index+i] <= read_out_fifo_data[31+(32*i):0+(32*i)];
                //         cache_tag[index+i]  <= tag;
                //     end
                // end
            end
        end
    endtask

    always @(posedge clk) begin
        please_stall_everything <= 1'b0;

        // FIFO related
        // WRITE INTO FIFO
        write_into_write_fifo         <= 1'b0;
        write_into_write_fifo_address <= 32'b0;
        write_into_write_fifo_data    <= 128'b0;

        // READ IN FIFO
        write_into_read_in_fifo <= 1'b0;
        write_into_read_in_fifo_address <= 32'b0;

        // READ OUT FIFO
        read_into_read_out_fifo <= 1'b0;

        if (~rst_n) begin
            // Initialize cache
            integer i;
            for (i = 0; i < CACHE_SIZE; i = i + 1) begin
                cache_data[i]   <= 0;
                cache_tag[i]    <= 0;
                cache_valid[i]  <= 0;
                cache_dirty[i]  <= 0;
                cache_read_in_fifo_request[i] <= 0;
            end
            hit <= 0;
            read_data <= 32'b0;
        end else begin
            if (read) begin
                if (cache_valid[index] && cache_tag[index] == tag) begin
                    // Cache hit
                    hit <= 1;
                    read_data <= cache_data[index*16+offset];
                end
                else begin
                    // Cache miss
                    hit <= 0;
                    handle_cache_miss(tag, index);
                end
            end else if (write) begin
                if (cache_dirty[index] && cache_tag[index] != tag) begin
                    // Write back to DDR3 RAM (not implemented here)
                    // ddr3_write({cache_tag[index], index, offset}, cache_data[index]);

                    handle_cache_miss(tag, index);
                end
                else begin
                    // Write data to cache
                    cache_data[index*16+offset]    <= write_data;
                    cache_tag[index*16+offset]     <= tag;
                    cache_valid[index*16+offset]   <= 1;
                    cache_dirty[index*16+offset]   <= 1;
                end
            end
        end
    end
endmodule