`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Central Connecticut State University - CET 497/498 Capstone
// Engineer: Joseph A. Hawker
// 
// Create Date: 10/14/2024 11:55:05 AM
// Design Name: RISC-V Integer ALU
// Module Name: alu
// Project Name: RISCV-BlueDevil
// Target Devices: Nexys 4 DDR, Nexys A7, Nexys Video
// Tool Versions: Vivado 2024.2.1
// Description:     ALU implementing the base integer instruction set for the RV32I
//              ISA.
// 
// Dependencies:    rv32i.vh - Used to define parameters in central location
// 
// Revision: 0.1
// Revision 0.1  - Base ALU created, but unverified. (JAH: 2025-02-17)
// Revision 0.01 - File Created
// Additional Comments: It is noted that ECALL and EBREAK are not fully implemented
//              as a complete implementation depends on the Zicsr extension.
//////////////////////////////////////////////////////////////////////////////////
`include "rv32i.vh"

module alu(
    output reg [`MAX_XLEN_INDEX:0] rd,          // Output value
    output reg [`MAX_XLEN_INDEX:0] pc_out,      // New PC value if needed
    output reg [`MAX_XLEN_INDEX:0] io_addr,     // Address signal for load store instructions
    output reg ecall, ebreak,
    input [`OP_GROUP_MAX_INDEX:0] alu_op_group, // Control signals
    input [`OPS_MAX_INDEX:0] op,
    input [`MAX_XLEN_INDEX:0] rs1, rs2,         // Register inputs
    input [`IMM_MAX_INDEX:0] low_imm,           // Immediate values
    input [`MAX_XLEN_INDEX:0] pc_in,            // Current program counter value
    input [`MAX_XLEN_INDEX:0] mem_in,           // Data value from main memory
    input [`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX] upper_imm,
    input [7:0] fence_sig, // Signals for memory ordering: PI, PO, PR, PW, SI, SO, SR, SW
    input [3:0] fence_mode 
    );
    
    // Sign extended lower immediate
    wire [`MAX_XLEN_INDEX:0] sign_xt_low_imm;
    
    // Variables for branch conditionals
    reg c;
    reg [`MAX_XLEN_INDEX:0] res;
    
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
                    default: begin rd = ~(`XLEN'h0); end
                endcase
                pc_out = 0;
                io_addr = 0;
                ecall = 0;
                ebreak = 0;
            end
            `SHIFT_INST: begin
                case (op)
                    `SLLI: begin rd = rs1 << {low_imm[4:0]}; end
                    `SRLI: begin rd = rs1 >> {low_imm[4:0]}; end
                    `SRAI: begin rd = rs1 >>> {low_imm[4:0]}; end
                    `SLL:  begin rd = rs1 << {rs2[4:0]}; end
                    `SRL:  begin rd = rs1 >> {rs2[4:0]}; end
                    `SRA:  begin rd = rs1 >>> {rs2[4:0]}; end
                    default: begin rd = ~(`XLEN'h1); end
                endcase
                pc_out = 0;
                io_addr = 0;
                ecall = 0;
                ebreak = 0;
            end
            `UI_INST: begin
                case (op)
                    `LUI:   begin rd = full_upper_imm; end
                    `AUIPC: begin rd = (full_upper_imm + pc_in) & (~12'hFFF); 
                        end
                    default: begin rd = ~(`XLEN'h2); end
                endcase
                pc_out = 0;
                io_addr = 0;
                ecall = 0;
                ebreak = 0;
            end
            `RR_INST: begin
                case (op)
                    `ADD:   begin rd = rs2 + rs1; end
                    `SUB:   begin rd = rs2 - rs1; end
                    `SLT: begin rd = ($signed(rs1) < $signed(rs2))?
                        `XLEN'b1:`XLEN'b0; end
                    `SLTU: begin rd = ($unsigned(rs1) < $unsigned(rs2))?
                        `XLEN'b1:`XLEN'b0; end
                    `AND:   begin rd = rs2 & rs1; end
                    `OR:    begin rd = rs2 | rs1; end
                    `XOR:   begin rd = rs2 ^ rs1; end
                    default: begin rd = ~(`XLEN'h4); end
                endcase
                pc_out = 0;
                io_addr = 0;
                ecall = 0;
                ebreak = 0;
            end
            `JMP_INST: begin
                case (op)
                    `JAL:   begin rd = pc_in + 4;
                        pc_out = pc_in + {{(11){upper_imm[`UPPER_IMM_MAX_INDEX]}},
                        upper_imm[`UPPER_IMM_MAX_INDEX-12:`UPPER_IMM_MAX_INDEX-19],
                        upper_imm[`UPPER_IMM_MAX_INDEX-11],
                        upper_imm[`UPPER_IMM_MAX_INDEX-1:`UPPER_IMM_MAX_INDEX-10],
                        1'b0    // Holy moly that was ugly. Why can't they just use
                        };      // the same encoding as the upper immediate isntruction?
                        end
                    `JALR:  begin rd = pc_in + 4;
                        pc_out = rs1 + {sign_xt_low_imm[`MAX_XLEN_INDEX-1:0], 1'b0};
                        end
                    default: begin rd = ~(`XLEN'h8); pc_out = 0; end
                endcase
                io_addr = 0;
                ecall = 0;
                ebreak = 0;
            end
            `BNCH_INST: begin
                rd = 0;
                case (op)
                    `BEQ: begin pc_out = (rs2-rs1) == 0 ?
                        pc_in + {sign_xt_low_imm[`MAX_XLEN_INDEX-1:0], 1'b0} :
                        pc_in + `XLEN'h4;
                     end
                     `BNE: begin pc_out = (rs2-rs1) != 0 ?
                        pc_in + {sign_xt_low_imm[`MAX_XLEN_INDEX-1:0], 1'b0} :
                        pc_in + `XLEN'h4;
                     end
                     `BLT: begin pc_out = (rs2-rs1) > 0 ?
                        pc_in + {sign_xt_low_imm[`MAX_XLEN_INDEX-1:0], 1'b0} :
                        pc_in + `XLEN'h4;
                     end
                     `BLTU: begin {c,res} = rs2-rs1;
                        pc_out = !c && (res > 0) ?
                        pc_in + {sign_xt_low_imm[`MAX_XLEN_INDEX-1:0], 1'b0} :
                        pc_in + `XLEN'h4;
                     end
                     `BGE: begin pc_out = (rs1-rs2) >= 0 ?
                        pc_in + {sign_xt_low_imm[`MAX_XLEN_INDEX-1:0], 1'b0} :
                        pc_in + `XLEN'h4;
                     end
                     `BGEU: begin {c,res} = rs1-rs2;
                        pc_out = !c && (res > 0) ?
                        pc_in + {sign_xt_low_imm[`MAX_XLEN_INDEX-1:0], 1'b0} :
                        pc_in + `XLEN'h4;
                     end
                    default: begin pc_out = 0; rd = ~(`XLEN'h16); end
                endcase
                io_addr = 0;
                ecall = 0;
                ebreak = 0;
            end
            `LDST_INST: begin
                case (op)
                    `LW: begin io_addr = rs1 + sign_xt_low_imm;
                        rd = {mem_in[31:0]};
                    end
                    `LH: begin io_addr = rs1 + sign_xt_low_imm;
                        rd = {{16{mem_in[15]}}, mem_in[15:0]};  // There is no nice way to do this...
                    end
                    `LHU: begin io_addr = rs1 + sign_xt_low_imm;
                        rd = {16'h0, mem_in[15:0]};
                    end
                    `LB: begin io_addr = rs1 + sign_xt_low_imm;
                        rd = {{24{mem_in[15]}}, mem_in[7:0]};
                    end
                    `LBU: begin io_addr = rs1 + sign_xt_low_imm;
                        rd = {24'h0, mem_in[7:0]};
                    end
                    // rd is always wired to the I/O pins on the processor and
                    // is controlled by the write enable signal from the instruction decoder
                    `SW: begin io_addr = rs1 + sign_xt_low_imm;
                        rd = rs2;
                    end
                    `SH: begin io_addr = rs1 + sign_xt_low_imm;
                        rd = {16'h0, rs2[15:0]};
                    end
                    `SB: begin io_addr = rs1 + sign_xt_low_imm;
                        rd = {24'h0, rs2[7:0]};
                    end
                    default: begin
                        rd = ~(`XLEN'h32);
                        io_addr = `XLEN'h0;
                    end
                endcase
                pc_out = 0;
                ecall = 0;
                ebreak = 0;
            end
            `MEM_INST: begin
                case (op)
                    `FENCE: begin
                        rd = {fence_mode, 16'b0, fence_sig}; // Fence mode always in high bits,
                    end                                       // signals always in low bits.
                    default: begin rd = ~(`XLEN'h64); end      // Fence signal from instruction decoder.
                endcase
                pc_out = 0;
                io_addr = 0;
                ecall = 0;
                ebreak = 0;
            end
            `SYS_INST: begin // Not fully implemented in unprivileged architecture
                case (op)
                    `ECALL: begin
                        rd = rs1;
                        ecall = 1'b1;
                        ebreak = 1'b0;
                    end
                    `EBREAK: begin
                        rd = 0;
                        ecall = 1'b0;
                        ebreak = 1'b1;
                    end
                    default: begin
                        rd = ~(`XLEN'h128);
                        ecall = 1'b0;
                        ebreak = 1'b0;
                    end
                endcase
                pc_out = 0;
                io_addr = 0;
            end
            default: begin
                rd = `XLEN'h0;
                pc_out = ~(`XLEN'b0);
                io_addr = 0;
                ecall = 1'b0;
                ebreak = 1'b0;
            end
        endcase
    end
endmodule
