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
    input [`OP_GROUP_MAX_INDEX:0] alu_op_group, // Control signals
    input [`OPS_MAX_INDEX:0] op,
    input [`MAX_XLEN_INDEX:0] rs1, rs2,         // Register inputs
    input [`IMM_MAX_INDEX:0] low_imm,           // 
    input [`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX] upper_imm
    );
    wire [`MAX_XLEN_INDEX:0] sign_xt_low_imm;
    
    assign sign_xt_low_imm = {{20{low_imm[11]}}, low_imm};
    assign full_upper_imm = {upper_imm, 12'h000};
    
    always_comb begin
        case (alu_op_group)
            `IMM_INST: begin
                case (op)
                    `ADDI: begin rd = rs1 + sign_xt_low_imm; end
                    `SLTI: begin rd = ($signed(rs1) < $signed(sign_xt_low_imm))?
                        `XLEN'b1:`XLEN'b0; end
                    `SLTIU: begin rd = ($unsigned(rs1) < $unsigned(sign_xt_low_imm))?
                        `XLEN'b1:`XLEN'b0; end
                    `ANDI: begin rd = rs1 & sign_xt_low_imm; end
                    `ORI: begin rd = rs1 | sign_xt_low_imm; end
                    `XORI: begin rd = rs1 ^ sign_xt_low_imm; end
                    default rd = ~(`XLEN'h0);
                endcase
            end
            `SHIFT_INST: begin
            end
            default: begin
                rd = `XLEN'h0;
            end
        endcase
    end
endmodule
