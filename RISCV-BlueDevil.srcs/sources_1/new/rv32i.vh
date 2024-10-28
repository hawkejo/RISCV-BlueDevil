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
`ifndef RV32I
`define RV32I
`define RVxxI // Used to specify number of integer registers

// Base definitions
`define XLEN                32
`define MAX_XLEN_INDEX      `XLEN-1

`ifdef RVxxI
    `define NUM_REGS        32
    `define REG_MAX_ADDR     4
`endif // RVxxI
`ifdef RVxxE
    `define NUM_REGS        16
    `define REG_MAX_ADDR     3
`endif // RVxxE

`define IALIGN_BYTES         4
`define IALIGN              `IALIGN_BYTES * 8
`define IALIGN_MULTIPLIER    1
`define ILEN_MAX            `IALIGN * `IALIGN_MULTIPLIER

`define STARTUP_OFFSET      `XLEN'h00FF // The offset from the max possible address
                                    // for when the CPU boots up or is reset.
// ALU definitions
`define NUM_OP_GROUPS       9
`define OP_GROUP_MAX_INDEX  3
`define NUM_OPERATIONS     16
`define OPS_MAX_INDEX       3

// Instruction group declarations
`define IMM_INST           `NUM_OP_GROUPS'h0
`define SHIFT_INST         `NUM_OP_GROUPS'h1
`define UI_INST            `NUM_OP_GROUPS'h2
`define RR_INST            `NUM_OP_GROUPS'h3
`define JMP_INST           `NUM_OP_GROUPS'h4
`define BNCH_INST          `NUM_OP_GROUPS'h5
`define LDST_INST          `NUM_OP_GROUPS'h6
`define MEM_INST           `NUM_OP_GROUPS'h7
`define SYS_INST           `NUM_OP_GROUPS'h8

// Instruction opcode declarations
// Immediate instructions
`define ADDI               `NUM_OPERATIONS'h0
`define SLTI               `NUM_OPERATIONS'h1
`define SLTIU              `NUM_OPERATIONS'h2
`define ANDI               `NUM_OPERATIONS'h3
`define ORI                `NUM_OPERATIONS'h4
`define XORI               `NUM_OPERATIONS'h5
// Shift instructions

`endif //RV32I
