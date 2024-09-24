module clock_divider (
    input logic clk_in,    // Input clock
    input logic reset,     // Reset signal
    output logic clk_out   // Output clock
);

    parameter DIV_FACTOR = 1; // Division factor
    logic [31:0] counter;       // Counter to keep track of clock cycles

    always_ff @(posedge clk_in) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == (DIV_FACTOR - 1)) begin
                counter <= 0;
                clk_out <= ~clk_out; // Toggle the output clock
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule

module mtime (
    input CLK, EN, RSTn,
    // input [63:0] d,

    output [63:0] mtime_value
);

    reg _internal_clock;

    clock_divider CLK_DIV(
        .clk_in(CLK),
        .reset(~RSTn),
        .clk_out(_internal_clock)
    );

    reg [63:0] _mtime_value;

    always @(_internal_clock, RSTn) begin
        if (RSTn == 0) begin
            _mtime_value    <= 63'h0;
        end
        else begin
            if (_internal_clock == 1'b1) begin
                if (EN == 1) begin
                    _mtime_value    <= _mtime_value + 1;
                end
            end
        end
    end

    assign mtime_value  = _mtime_value;
endmodule