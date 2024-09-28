module rom #(
    parameter INPUT_SIZE = 16,
    parameter OUTPUT_SIZE = 32,
    parameter N_ROWS = 512
)
(
    input  logic    [INPUT_SIZE-1:0]    a,
    output reg      [OUTPUT_SIZE-1:0]   spo
);

    // Memory array
    logic [OUTPUT_SIZE:0] mem [0:N_ROWS-1];

    // Read the hex file into the memory array
    initial begin
        // mem[0] = 32'h00000033;
        // mem[1] = 32'h00000033;
        // mem[2] = 32'h00000033;
        // mem[3] = 32'h00000033;
        // mem[4] = 32'h30200073;
        // mem[5] = 32'h00000033;
        // mem[6] = 32'h00000033;
        $readmemh("main_hex.txt", mem);
    end

    // Output the data at the given address
    always @(a) begin
        spo <= mem[a];
    end

endmodule