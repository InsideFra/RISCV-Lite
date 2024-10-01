module fifo_address #(
    parameter N = 1,
    parameter WIDTH = 128
) (
    input   clk,
    input   rst,
    input   wr_en,
    input   rd_en,
    input       [WIDTH-1:0] data_in,
    output  reg [WIDTH-1:0] data_out,
    output  reg             full,
    output  reg             empty
);

    reg [WIDTH-1:0]     fifo_mem [0:N-1];
    reg [clog2(N)-1:0]  wr_ptr, rd_ptr;
    reg [clog2(N):0]    fifo_count;

    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            fifo_count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (wr_en && !full) begin
                fifo_mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                fifo_count <= fifo_count + 1;
            end
            if (rd_en && !empty) begin
                data_out <= fifo_mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                fifo_count <= fifo_count - 1;
            end
            full <= (fifo_count == N);
            empty <= (fifo_count == 0);
        end
    end

    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

endmodule

module fifo_address_data #(
    parameter N = 1,
    parameter ADDRESS_WIDTH = 128,
    parameter DATA_WIDTH = 128
) (
    input   clk,
    input   rst,
    input   wr_en,
    input   rd_en,
    input       [ADDRESS_WIDTH-1:0] address_in,
    output  reg [ADDRESS_WIDTH-1:0] address_out,

    input       [DATA_WIDTH-1:0] data_in,
    output  reg [DATA_WIDTH-1:0] data_out,

    output  reg             full,
    output  reg             empty
);

    reg [ADDRESS_WIDTH-1:0]     address_fifo_mem [0:N-1];
    reg [DATA_WIDTH-1:0]        data_fifo_mem [0:N-1];
    reg [clog2(N)-1:0]  wr_ptr, rd_ptr;
    reg [clog2(N):0]    fifo_count;

    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            fifo_count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (wr_en && !full) begin
                address_fifo_mem[wr_ptr]    <= address_in;
                data_fifo_mem[wr_ptr]       <= data_in;
                wr_ptr <= wr_ptr + 1;
                fifo_count <= fifo_count + 1;
            end
            if (rd_en && !empty) begin
                address_out <= address_fifo_mem[rd_ptr];
                data_out    <= data_fifo_mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                fifo_count <= fifo_count - 1;
            end
            full <= (fifo_count == N);
            empty <= (fifo_count == 0);
        end
    end

    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

endmodule