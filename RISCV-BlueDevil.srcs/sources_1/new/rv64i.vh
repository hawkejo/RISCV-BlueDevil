//////////////////////////////////////////////////////////////////////////////////
// Company: Central Connecticut State University - CET 497/498 Capstone
// Engineer: Joseph A. Hawker
// 
// Create Date: 10/14/2024 11:55:05 AM
// Design Name: RISC-V RV32I header file
// Project Name: RISCV-BlueDevil
// Target Devices: Nexys 4 DDR, Nexys Video
// Tool Versions: Vivado 2024.1.2
// Description:     Header file for base 32 bit instruction set of the RISC-V
//              Processor architecture. Can be changed between RV32I and RV32E by
//              changing the specific define statement.
//
//              Note that minimum address indices are always 0 unless otherwise
//              noted
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
`ifndef RV64I
`define RV64I
`define RVxxI // Used to specify number of integer registers

// Base definitions
`define XLEN                64
`define MAX_XLEN_INDEX      63

`ifdef RVxxI
    `define NUM_REGS        32
    `define REG_MAX_ADDR     4
`endif // RVxxI

`define IALIGN_BYTES         4
`define IALIGN              32
`define IALIGN_MULTIPLIER    1
`define ILEN_MAX            32

`define IMM_MAX_INDEX       11
`define UPPER_IMM_LOW_INDEX 0
`define UPPER_IMM_MAX_INDEX 19

`define STARTUP_OFFSET      `XLEN'h00FF // The offset from the max possible address
                                    // for when the CPU boots up or is reset.

/* 
 * All of the following definitions are used as internal signal definitions.
 * These are not to be used for the actual instruction encodings, which will
 * be in a separate *.vh header file.
 */ 
// ALU definitions
`define NUM_OP_GROUPS        9
`define OP_GROUP_MAX_INDEX   3
`define NUM_OPERATIONS      16
`define OPS_MAX_INDEX        3

// Instruction group declarations
`define IMM_INST            `NUM_OP_GROUPS'h0
`define SHIFT_INST          `NUM_OP_GROUPS'h1
`define UI_INST             `NUM_OP_GROUPS'h2
`define RR_INST             `NUM_OP_GROUPS'h3
`define JMP_INST            `NUM_OP_GROUPS'h4
`define BNCH_INST           `NUM_OP_GROUPS'h5
`define LDST_INST           `NUM_OP_GROUPS'h6
`define MEM_INST            `NUM_OP_GROUPS'h7
`define SYS_INST            `NUM_OP_GROUPS'h8

// Instruction opcode declarations
// Immediate instructions
`define ADDI                `NUM_OPERATIONS'h0
`define SLTI                `NUM_OPERATIONS'h1
`define SLTIU               `NUM_OPERATIONS'h2
`define ANDI                `NUM_OPERATIONS'h3
`define ORI                 `NUM_OPERATIONS'h4
`define XORI                `NUM_OPERATIONS'h5
// Shift instructions
`define SLLI                `NUM_OPERATIONS'h0
`define SRLI                `NUM_OPERATIONS'h1
`define SRAI                `NUM_OPERATIONS'h2
`define SLL                 `NUM_OPERATIONS'h3
`define SRL                 `NUM_OPERATIONS'h4
`define SRA                 `NUM_OPERATIONS'h5
// Upper Immediate Instructions
`define LUI                 `NUM_OPERATIONS'h0
`define AUIPC               `NUM_OPERATIONS'h1
// Register-register Instructions
`define ADD                 `NUM_OPERATIONS'h0
`define SUB                 `NUM_OPERATIONS'h1
`define SLT                 `NUM_OPERATIONS'h2
`define SLTU                `NUM_OPERATIONS'h3
`define AND                 `NUM_OPERATIONS'h4
`define OR                  `NUM_OPERATIONS'h5
`define XOR                 `NUM_OPERATIONS'h6
// Unconditional jump instructions
`define JAL                 `NUM_OPERATIONS'h0
`define JALR                `NUM_OPERATIONS'h1
// Conditional branch instructions
`define BEQ                 `NUM_OPERATIONS'h0
`define BNE                 `NUM_OPERATIONS'h1
`define BLT                 `NUM_OPERATIONS'h2
`define BLTU                `NUM_OPERATIONS'h3
`define BGE                 `NUM_OPERATIONS'h4
`define BGEU                `NUM_OPERATIONS'h5
// Load and store instructions
`define LD                  `NUM_OPERATIONS'h0 // Used only in 64-bit implementation
`define LW                  `NUM_OPERATIONS'h1
`define LWU                 `NUM_OPERATIONS'h2 // Used only in 64-bit implementation
`define LH                  `NUM_OPERATIONS'h3
`define LHU                 `NUM_OPERATIONS'h4
`define LB                  `NUM_OPERATIONS'h5
`define LBU                 `NUM_OPERATIONS'h6
`define SD                  `NUM_OPERATIONS'h7 // Used only in 64-bit implementation
`define SW                  `NUM_OPERATIONS'h8
`define SH                  `NUM_OPERATIONS'h9
`define SB                  `NUM_OPERATIONS'hA
// Memory ordering and control instructions
`define FENCE               `NUM_OPERATIONS'h0
// Environment (system) call and breakpoint instructions
`define ECALL               `NUM_OPERATIONS'h0
`define EBREAK              `NUM_OPERATIONS'h1

`endif //RV64I
