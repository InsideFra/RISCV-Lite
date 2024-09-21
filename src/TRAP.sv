import my_pkg::*;

module TRAP_Block (
    input EN, RSTn, CLK,

    input DECODE_TRAP_STRUCT TRAP_DECODE_i,
    input reg [31:0] DECODE_INSTR,
    
    input MRET_DETECTED,
    input SRET_DETECTED,

    output TRAP_STRUCT TRAP_o,
    output reg [31:0] xreg_value,
    
    output reg EXECUTE_MRET,
    output reg EXECUTE_SRET
);

reg [31:0] xreg;

always @(TRAP_DECODE_i) begin
    if (EN == 1'b1) begin
        if (TRAP_DECODE_i.ILLEGAL_INSTR == 1'b1) begin
            TRAP_o.DECODE_TRAP = 1'b1;
            xreg = DECODE_INSTR;
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