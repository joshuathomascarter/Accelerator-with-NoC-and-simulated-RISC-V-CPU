package isa_pkg;

    typedef enum logic [7:0] {
        OP_WRITE_CSR = 8'h00,  // Write data to register:  [WRITE][xx ][xx ][rd ] + 4 data bytes
        OP_READ_CSR = 8'h01,  // Read register, send back: [READ ][xx ][xx ][rd ]
        OP_WRITE_WEIGHT = 8'h02,
        OP_WRITE_ACTIVATION =8'h03,
        OP_LAST_WEIGHT = 8'h04,
        OP_LAST_ACTIVATION = 8'h05,
        OP_READ_OUTPUT = 8'h06
    } opcode_t;

    typedef struct packed {
        logic [7:0]  opcode;  // bits [31:24] — byte 0 over UART
        logic [3:0]  rs1;     // bits [23:20] — source 1 (activations) \
        logic [3:0]  rs2;     // bits [19:16] — source 2 (weights)      } byte 1
        logic [3:0]  rd;      // bits [15:12] — destination             \
        logic [11:0] pad;     // bits [11:0]  — reserved                 } bytes 2-3
    } instr_t;                // 32 bits total = 4 UART bytes

endpackage
