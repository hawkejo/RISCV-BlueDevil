`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2024 11:55:05 AM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies:    rv32i.vh - Used to define parameters in central location
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "rv32i.vh"

module alu(
    output reg [`MAX_XLEN_INDEX:0] rd,          // Output value
    output reg [`MAX_XLEN_INDEX:0] pc_out,      // New PC value if needed
    input [`OP_GROUP_MAX_INDEX:0] alu_op_group, // Control signals
    input [`OPS_MAX_INDEX:0] op,
    input [`MAX_XLEN_INDEX:0] rs1, rs2,         // Register inputs
    input [`IMM_MAX_INDEX:0] low_imm,           // Immediate values
    input [`MAX_XLEN_INDEX:0] pc_in,            // Current program counter value
    input [`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX] upper_imm
    );
    wire [`MAX_XLEN_INDEX:0] sign_xt_low_imm;
    
    assign sign_xt_low_imm = {{20{low_imm[11]}}, low_imm};
    assign full_upper_imm = {upper_imm, 12'h000};
    
    always_comb begin
        case (alu_op_group)
            `IMM_INST: begin
                case (op)
                    `ADDI: begin rd = rs1 + sign_xt_low_imm; pc_out = 0; end
                    `SLTI: begin rd = ($signed(rs1) < $signed(sign_xt_low_imm))?
                        `XLEN'b1:`XLEN'b0; pc_out = 0; end
                    `SLTIU: begin rd = ($unsigned(rs1) < $unsigned(sign_xt_low_imm))?
                        `XLEN'b1:`XLEN'b0; pc_out = 0; end
                    `ANDI: begin rd = rs1 & sign_xt_low_imm; pc_out = 0; end
                    `ORI: begin rd = rs1 | sign_xt_low_imm; pc_out = 0; end
                    `XORI: begin rd = rs1 ^ sign_xt_low_imm; pc_out = 0; end
                    default begin rd = ~(`XLEN'h0); pc_out = 0; end
                endcase
            end
            `SHIFT_INST: begin
                case (op)
                    `SLLI: begin rd = rs1 << {low_imm[4:0]}; pc_out = 0; end
                    `SRLI: begin rd = rs1 >> {low_imm[4:0]}; pc_out = 0; end
                    `SRAI: begin rd = rs1 >>> {low_imm[4:0]}; pc_out = 0; end
                    `SLL:  begin rd = rs1 << {rs2[4:0]}; pc_out = 0; end
                    `SRL:  begin rd = rs1 >> {rs2[4:0]}; pc_out = 0; end
                    `SRA:  begin rd = rs1 >>> {rs2[4:0]}; pc_out = 0; end
                    default begin rd = ~(`XLEN'h1); pc_out = 0; end
                endcase
            end
            `UI_INST: begin
                case (op)
                    `LUI: begin rd = {upper_imm, {12{1'b0}}};  pc_out = 0; end
                    `AUIPC: begin rd = ({upper_imm, {12{1'b0}}} + pc_in) & (~12'hFFF); 
                            pc_out = 0;
                            end
                    default begin rd = ~(`XLEN'h2); pc_out = 0; end
                endcase
            end
            `RR_INST: begin
                case (op)
                    default begin rd = ~(`XLEN'h4); pc_out = 0; end
                endcase
            end
            `JMP_INST: begin
                case (op)
                    default begin rd = ~(`XLEN'h8); pc_out = 0; end
                endcase
            end
            `BNCH_INST: begin
                case (op)
                    default begin rd = ~(`XLEN'h16); pc_out = 0; end
                endcase
            end
            `LDST_INST: begin
                case (op)
                    default begin rd = ~(`XLEN'h32); pc_out = 0; end
                endcase
            end
            `MEM_INST: begin
                case (op)
                    default begin rd = ~(`XLEN'h64); pc_out = 0; end
                endcase
            end
            `SYS_INST: begin
                case (op)
                    default begin rd = ~(`XLEN'h128); pc_out = 0; end
                endcase
            end
            default: begin
                rd = `XLEN'h0;
                pc_out = ~(`XLEN'b0);
            end
        endcase
    end
endmodule
