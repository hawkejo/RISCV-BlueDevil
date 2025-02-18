`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Central Connecticut State University - CET 497/498 Capstone
// Engineer: Joseph A. Hawker
// 
// Create Date: 10/14/2024 11:55:05 AM
// Design Name: RISC-V Instruction Decoder
// Module Name: instruction_decoder
// Project Name: RISCV-BlueDevil
// Target Devices: Nexys 4 DDR, Nexys A7, Nexys Video
// Tool Versions: Vivado 2024.2.1
// Description:     Decoder (LUT) to generate internal signals to control the memory
//              I/O pins, ALU, and register file.
// 
// Dependencies: rv32i.vh - Used to define parameters in central location for
//                          control signals.
//               rv32i_inst.vh - Used to define parameters for the RV32I opcodes.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "rv32i.vh"

module instruction_decoder(
    output reg[`REG_MAX_ADDR:0] rs1_addr, rs2_addr, rd_addr,
    output reg rfile_we, pc_we, pc_increment, memory_we, memory_re,
    output reg [`IMM_MAX_INDEX:0] low_imm,
    output reg [`OP_GROUP_MAX_INDEX:0] alu_op_group,
    output reg [`OPS_MAX_INDEX:0] op,
    output reg [`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX] upper_imm,
    output reg [7:0] fence_sig, // Signals for memory ordering: PI, PO, PR, PW, SI, SO, SR, SW
    output reg [3:0] fence_mode,
    input [`IALIGN:0] instruction
    );
    wire [6:0] inst_opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    
    assign inst_opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    
    always_comb begin
        case(inst_opcode)
            default begin // Default to NOP pseudoinstruction
                alu_op_group <= `IMM_INST;
                op <= `ADDI;
                rs1_addr <= 5'h00;
                rs2_addr <= 5'h00;
                rd_addr <= 5'h00;
                rfile_we <= 1'b1;
                pc_we <= 1'b0;
                pc_increment <= 1'b1;
                memory_we <= 1'b0;
                memory_re <= 1'b0;
                low_imm <= instruction[`MAX_XLEN_INDEX:20];
                upper_imm <= 20'h0;
                fence_sig <= 8'h00;
                fence_mode <= 4'h0;
            end
        endcase
    end
    
endmodule
