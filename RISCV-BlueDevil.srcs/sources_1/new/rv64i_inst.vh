`ifndef RV64I_INST
`define RV64I_INST

// Opcode listings
`define LUI_INST             7'b0110111
`define AUIPC_INST           7'b0010111
`define JAL_INST             7'b1101111
`define JALR_INST            7'b1100111
`define BRANCH_INST          7'b1100011
`define LOAD_INST            7'b0000011
`define STORE_INST           7'b0100011
`define OP_IMM_INST          7'b0010011
`define OP_INST              7'b0110011
`define FENCE_INST           7'b0001111
`define SYSTEM_INST          7'b1110011

// BRANCH function codes
`define BEQ_INST             3'b000
`define BNE_INST             3'b001
`define BLT_INST             3'b100
`define BGE_INST             3'b101
`define BLTU_INST            3'b110
`define BGEU_INST            3'b111

// LOAD width codes
`define LB_INST              3'b000
`define LH_INST              3'b001
`define LW_INST              3'b010
`define LBU_INST             3'b100
`define LHU_INST             3'b101

// STORE width codes
`define SB_INST              3'b000
`define SH_INST              3'b001
`define SW_INST              3'b010

// OP_IMM function codes
`define ADDI_INST            3'b000
`define SLTI_INST            3'b010
`define SLTIU_INST           3'b011
`define XORI_INST            3'b100
`define ORI_INST             3'b110
`define ANDI_INST            3'b111
`define SLLI_INST            3'b001
`define SRI_INST             3'b101
`define SRLI_INST            7'b0000000
`define SRAI_INST            7'b0100000

// OP function codes
`define ADD_SUB_INST         3'b000
`define ADD_INST             7'b0000000
`define SUB_INST             7'b0100000
`define SLL_INST             3'b001
`define SLT_INST             3'b010
`define SLTU_INST            3'b011
`define XOR_INST             3'b100
`define SR_INST              3'b101
`define SRL_INST             7'b0000000
`define SRA_INST             7'b0100000
`define OR_INST              3'b110
`define AND_INST             3'b111

// System function codes
`define ECALL_INST           12'h000
`define EBREAK_INST          12'h001

`endif // RV64I_INST