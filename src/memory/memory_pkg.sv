package memory_pkg;

typedef struct packed {
    reg [21:0] ppn;
    reg [11:0] offset;

} pa_t;

typedef struct packed {
    reg [9:0]   vpn_1;
    reg [9:0]   vpn_2;
    reg [11:0]  offset;
} va_t;

endpackage