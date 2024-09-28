import memory_pkg::*;

module page_table_entry #(
    parameter PAGE_ROWS = 1024,
    parameter PAGE_OFFSET = 4096
)(
    input CLK, EN, RSTn,
    input va_t virtual_address,

    input is_read,
    input is_write,
    input is_execute,
    input [1:0] priviledge_mode,

    input is_M_mode,

    output pa_t physical_address,
    output page_fault_exception,
    output access_fault_exception
);

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
} pte_2_format;

typedef struct packed {
    reg [9:0] PPN;
    reg X;
    reg W;
    reg R;
    reg V;
} pte_1_format;

pte_1_format _pte_1 [0:PAGE_ROWS-1];
pte_2_format _pte_2 [0:PAGE_ROWS-1];

// First Level Page
always_ff @(posedge CLK) begin
    if (RSTn == 1'b0) begin
		for (reg i = 1; i < PAGE_ROWS; i = i+1) begin
            _pte_1[i] <= '{default: 0};
            _pte_1[i].V <= 1'b1;
            _pte_1[i].PPN <= i;
		end
    end
    else begin
        // TODO
    end
end

// Second Level Page
always_ff @(posedge CLK) begin
    if (RSTn == 1'b0) begin
		for (reg i = 1; i < PAGE_ROWS; i = i+1) begin
            _pte_2[i] <= '{default: 0};
            _pte_2[i].V <= 1'b1;
            _pte_2[i].PPN <= '{default: i*4};
		end
    end
    else begin
        // TODO
    end
end

always @ (*) begin
    reg [9:0] offset;
    offset = _pte_1[virtual_address.vpn_1].PPN;
    
    if ( (_pte_1[virtual_address.vpn_1].R) & (_pte_1[virtual_address.vpn_1].W) & (_pte_1[virtual_address.vpn_1].X) == 1'b0) begin
        // TODO: PAGE FAULT
    end
    else if (_pte_2[offset].V == 1'b1) begin
        if (is_write == 1'b1) begin
            if (_pte_2[offset].W == 1'b1) begin

            end
            else begin
                // TODO: NOT WRITABLE
            end
        end
        else if (is_execute == 1'b1) begin
            if (_pte_2[offset].X == 1'b1) begin

            end
            else begin
                // TODO: NOT EXECUTABLE
            end
        end
        else if (is_read == 1'b1) begin
            if (_pte_2[offset].R == 1'b1) begin

            end
            else begin
                // TODO: Not Readable
            end
        end
    end else begin
        // TODO: NOT VALID
    end

end

endmodule