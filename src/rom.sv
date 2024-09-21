module rom (
    input  logic [15:0] a,
    output reg [31:0] spo
);

    // Memory array
    logic [31:0] mem [0:511];

    // Read the hex file into the memory array
    initial begin
        $readmemh("rom.hex", mem);
    end

    // Output the data at the given address
    always @(a) begin
        spo <= mem[a];
    end

endmodule