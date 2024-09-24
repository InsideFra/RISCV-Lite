import my_pkg::*;

module TRAP_Block (
    input EN, RSTn, CLK,

    input DECODE_TRAP_STRUCT TRAP_DECODE_i,
    input reg [31:0] DECODE_INSTR,

    input reg MIE, // Machine Interrupt Enable
    input reg SIE, // Supervisor Interrupt Enable

    input reg MPIE, // MIE bit before the trap
    input reg SPIE, // SIE bit before the trap

    // When a trap is taken from privilege mode y
    // into privilege mode x, xPIE is set to the value of xIE; xIE is set to 0; and xPP is set to y.
    input reg [1:0] MPP, // previous privilege mode
    input reg SPP, // previous privilege mode

    input MRET_DETECTED,
    input SRET_DETECTED,

    output TRAP_STRUCT TRAP_o,
    output reg [31:0] xreg_value,

    output reg EXECUTE_MRET,
    output reg EXECUTE_SRET
);

reg [31:0] xreg;

always @(posedge CLK) begin
    if (RSTn == 1'b0)
        xreg = 32'h0;
    else begin
        if (TRAP_DECODE_i.ILLEGAL_INSTR == 1'b1)
            xreg = DECODE_INSTR;
        else
            xreg = xreg;
    end
end

always @(TRAP_DECODE_i) begin
    if (EN == 1'b1) begin
        if (TRAP_DECODE_i.ILLEGAL_INSTR == 1'b1) begin
            TRAP_o.DECODE_TRAP = 1'b1;
        end
        else begin
            TRAP_o.DECODE_TRAP = 1'b0;
            xreg = xreg;
        end
    end
    else begin
        TRAP_o.DECODE_TRAP = 1'b0;
        xreg = xreg;
    end
end

always @(MRET_DETECTED) begin
    if (MRET_DETECTED == 1'b1) begin
        EXECUTE_MRET = 1'b1;
    end
    else begin
        EXECUTE_MRET = 1'b0;
    end
end

assign xreg_value = xreg;

endmodule