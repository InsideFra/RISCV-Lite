module rom (
    input  logic [15:0] a,
    output reg [31:0] spo
);

    // Memory array
    logic [31:0] mem [0:511];

    // Read the hex file into the memory array
    initial begin
        mem[0] = 32'h00000033;
        mem[1] = 32'h00000033;
        mem[2] = 32'h00000033;
        mem[3] = 32'h00000033;
        mem[4] = 32'h30200073;
        mem[5] = 32'h00000033;
        mem[6] = 32'h00000033;
    end

    // Output the data at the given address
    always @(a) begin
        spo <= mem[a];
    end

endmodule