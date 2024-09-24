import memory_package::*;

module page_table_entry #(
    parameter PAGE_ROWS = 15625
    parameter PAGE_OFFSET = 4096
)(
    input CLK, EN, RSTn,
    input va_t virtual_address,

    input is_read,
    input is_write,
    input is_execute,
    input [1:0] priviledge_mode,

    output pa_t physical_address,
    output page_fault_exception,
    output access_fault_exception,
)

typedef struct packed {
    reg [21:0] PPN;
    reg [1:0] RSW;
    reg D; // Dirty
    reg A; // Accessed
    reg G; // Global Mapping
    reg U; // Usermode
    reg X; // Executable
    reg W; // Writable
    reg R; // Readable
    reg V; // Valid
} pte_format

pte_format _pte [0:PAGE_ROWS-1];

always_ff @(posedge CLK) begin
    if (RSTn == 1'b0) begin
		for (i = 1; i < PAGE_ROWS; i = i+1) begin
            _pte[i] <= '{default: 0};
            _pte[i].PPN <= i*PAGE_OFFSET;
            _pte[i].X = 1'b1;
            _pte[i].W = 1'b1;
            _pte[i].R = 1'b1;
            _pte[i].V = 1'b1;
		end
    end
    else begin
        // TODO
    end
end

always @ (*) begin
    if (_pte[virtual_address.vpn].V == 1'b1) begin
        
    end else begin
        // NOT VALID
    end

end

endmodule