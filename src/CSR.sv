import my_pkg::*;

// WARL -> Write Any Values, Reads Legal Values
// Implementations will not raise an exception on writes of unsupported values to a WARL field.
// Implementations can return any legal value on the read of a WARL field when the last write was of an
// illegal value, but the legal value returned should deterministically depend on the illegal written value
// and the architectural state of the hart.

module CSR_misa (
    input CLK, EN, RSTn,
    input [127:0] d,

    output [1:0] CSR_misa_MXL,
    output [25:0] CSR_misa_Extensions
);

typedef enum logic [25:0] { 
    Atomic_extension = 26'b1
    Compressed_extension = 26'b100
    Double-precision_floating-point_extension = 26'b1000
    RV32E_base_ISA = 26'b10000
    Single-precision_floating-point_extension = 26'b100000
    Hypervisor_extension = 26'b10000000
    RV32I/64I/128I_base_ISA = 26'b100000000
    Integer_Multiply/Divide_extension = 26'b100000000000
    Quad-precision_floating-point_extension = 26'b100000000000000
    Supervisor_mode_implemented = 26'b10000000000000000
    User_mode_implemented = 26'b1000000000000000000
    Vector_extension_implemented = 26'b10000000000000000000
    Non-standard_extensions_present = 26'b1000000000000000000000
} CSR_misa_Extensions_enum;

reg [1:0] _CSR_misa_MXL;
reg CSR_misa_Extensions_enum _CSR_misa_Extensions;

always @(posedge CLK) begin
    if (RSTn == 0) begin
        _CSR_misa_MXL <= 2'h3;
        _CSR_misa_Extensions <= (
            Atomic_extension |
            Single-precision_floating-point_extension |
            RV32I/64I/128I_base_ISA |
            Integer_Multiply/Divide_extension |
            Superivosr_mode_implemented |
            User_mode_implemented 
        );
    end
    else begin
        if (EN == 0) begin
            _CSR_misa_MXL <= _CSR_misa_MXL;
            _CSR_misa_Extensions <= _CSR_misa_Extensions;
        end
        else begin
            _CSR_misa_MXL <= d[127:126];
            _CSR_misa_Extensions <= d[25:0];
        end
    end
end

assign CSR_misa_Extensions <= _CSR_misa_Extensions;
assign CSR_misa_MXL <= _CSR_misa_Extensions;

endmodule

module CSR_mvendorid (
    input CLK, EN, RSTn,
    input [31:0] d,

    output [25:0] CSR_mvendorid_bank,
    output [6:0]  CSR_mvendorid_offset
);

reg [25:0] _CSR_mvendorid_bank;
reg [6:0]  _CSR_mvendorid_offset;

always @(posedge CLK) begin
    if (RSTn == 0) begin
        _CSR_mvendorid_bank     <= 26'h0;
        _CSR_mvendorid_offset   <= 6'h0;
    end
    else begin
        if (EN == 0) begin
            _CSR_mvendorid_bank     <= _CSR_mvendorid_bank;
            _CSR_mvendorid_offset   <= _CSR_mvendorid_offset;
        end
        else begin
            _CSR_mvendorid_bank     <= d[31:7];
            _CSR_mvendorid_offset   <= d[6:0];
        end
    end
end

assign CSR_mvendorid_bank   <= _CSR_mvendorid_bank;
assign CSR_mvendorid_offset <= _CSR_mvendorid_offset;

endmodule

module CSR_marchid (
    input CLK, EN, RSTn,
    input [127:0] d,

    output CSR_marchid_struct CSR_marchid
);

reg CSR_marchid_struct _CSR_marchid;

always @(posedge CLK) begin
    if (RSTn == 0) begin
        _CSR_marchid    <= 127'h0;
    end
    else begin
        if (EN == 0) begin
            _CSR_marchid    <= _CSR_marchid;
        end
        else begin
            _CSR_marchid    <= d[127:0];
        end
    end
end

assign CSR_marchid  <= _CSR_marchid;

endmodule


module CSR_mimpid (
    input CLK, EN, RSTn,
    input [127:0] d,

    output CSR_mimpid_struct CSR_mimpid
);

// The mimpid CSR provides a unique encoding of the version of the processor implementation. This
// register must be readable in any implementation, but a value of 0 can be returned to indicate that the
// field is not implemented. The Implementation value should reflect the design of the RISC-V processor
// itself and not any surrounding system.

reg CSR_mimpid_struct _CSR_mimpid;

always @(posedge CLK) begin
    if (RSTn == 0) begin
        _CSR_mimpid    <= 127'h1;
    end
    else begin
        if (EN == 0) begin
            _CSR_mimpid    <= _CSR_mimpid;
        end
        else begin
            _CSR_mimpid    <= d[127:0];
        end
    end
end

assign CSR_mimpid  <= _CSR_mimpid;
endmodule

module CSR_hartid (
    input CLK, EN, RSTn,
    input [127:0] d,

    output CSR_hartid_struct CSR_hartid
);

// The mhartid CSR is an MXLEN-bit read-only register containing the integer ID of the hardware
// thread running the code. This register must be readable in any implementation. Hart IDs might not
// necessarily be numbered contiguously in a multiprocessor system, but at least one hart must have a
// hart ID of zero. Hart IDs must be unique within the execution environment.

reg CSR_hartid_struct _CSR_hartid;

always @(posedge CLK) begin
    if (RSTn == 0) begin
        _CSR_hartid    <= 127'h0;
    end
    else begin
        if (EN == 0) begin
            _CSR_hartid    <= _CSR_hartid;
        end
        else begin
            _CSR_hartid    <= d[127:0];
        end
    end
end

assign CSR_hartid  <= _CSR_hartid;
endmodule

module CSR_mstatus (
    input CLK, EN, RSTn,
    input [31:0] d,

    output CSR_mstatus_struct CSR_mstatus
);

// The mstatus register is an MXLEN-bit read/write register formatted as shown in Figure 7 for RV32
// and Figure 8 for RV64. The mstatus register keeps track of and controls the hart’s current operating
// state. A restricted view of mstatus appears as the sstatus register in the S-level ISA.

reg CSR_mstatus_struct _CSR_mstatus;

always @(posedge CLK) begin
    if (RSTn == 0) begin
        _CSR_mstatus    <= 31'h0;
    end
    else begin
        if (EN == 0) begin
            _CSR_mstatus    <= _CSR_mstatus;
        end
        else begin
            _CSR_mstatus    <= d[31:0];
        end
    end
end

assign CSR_mstatus  <= _CSR_mstatus;
endmodule