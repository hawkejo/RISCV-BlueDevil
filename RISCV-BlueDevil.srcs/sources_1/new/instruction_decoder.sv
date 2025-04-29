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
`include "rv64i.vh"
`include "rv64i_inst.vh"

module instruction_decoder(
    output reg[`REG_MAX_ADDR:0] rs1_addr, rs2_addr, rd_addr,
    output reg rfile_we, pc_we, pc_increment, memory_we, memory_re,
    output reg [`IMM_MAX_INDEX:0] low_imm,
    output reg [`OP_GROUP_MAX_INDEX:0] alu_op_group,
    output reg [`OPS_MAX_INDEX:0] op,
    output reg [`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX] upper_imm,
    output reg [7:0] fence_sig, // Signals for memory ordering: PI, PO, PR, PW, SI, SO, SR, SW
    output reg [3:0] fence_mode,
    input [`IALIGN-1:0] instruction
    );
    wire [6:0] inst_opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    
    assign inst_opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    
    always_comb begin
        case(inst_opcode)
            `LUI_INST: begin
                alu_op_group <= `UI_INST;
                op <= `LUI;
                rs1_addr <= 5'h00;
                rs2_addr <= 5'h00;
                rd_addr <= instruction[11:7];
                rfile_we <= 1'b1;
                pc_we <= 1'b0;
                pc_increment <= 1'b1;
                memory_we <= 1'b0;
                memory_re <= 1'b0;
                low_imm <= 12'h0;
                upper_imm <= instruction[`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX];
                fence_sig <= 8'h00;
                fence_mode <= 4'h0;
            end
            `AUIPC_INST: begin
                alu_op_group <= `UI_INST;
                op <= `AUIPC;
                rs1_addr <= 5'h00;
                rs2_addr <= 5'h00;
                rd_addr <= instruction[11:7];
                rfile_we <= 1'b1;
                pc_we <= 1'b0;
                pc_increment <= 1'b1;
                memory_we <= 1'b0;
                memory_re <= 1'b0;
                low_imm <= 12'h0;
                upper_imm <= instruction[`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX];
                fence_sig <= 8'h00;
                fence_mode <= 4'h0;
            end
            `JAL_INST: begin
                alu_op_group <= `JMP_INST;
                op <= `JAL;
                rs1_addr <= 5'h00;
                rs2_addr <= 5'h00;
                rd_addr <= instruction[11:7];
                rfile_we <= 1'b1;
                pc_we <= 1'b1;
                pc_increment <= 1'b0;
                memory_we <= 1'b0;
                memory_re <= 1'b0;
                low_imm <= 12'h0;
                upper_imm <= instruction[`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX];
                fence_sig <= 8'h00;
                fence_mode <= 4'h0;
            end
            `JALR_INST: begin
                alu_op_group <= `JMP_INST;
                op <= `JALR;
                rs1_addr <= instruction[19:15];
                rs2_addr <= 5'h00;
                rd_addr <= instruction[11:7];
                rfile_we <= 1'b1;
                pc_we <= 1'b1;
                pc_increment <= 1'b0;
                memory_we <= 1'b0;
                memory_re <= 1'b0;
                low_imm <= instruction[31:20];
                upper_imm <= 20'h0;
                fence_sig <= 8'h00;
                fence_mode <= 4'h0;
            end
            `BRANCH_INST: begin
                case(funct3)
                    `BEQ_INST: begin
                        alu_op_group <= `BNCH_INST;
                        op <= `BEQ;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= 5'h0;
                        rfile_we <= 1'b0;
                        pc_we <= 1'b1;
                        pc_increment <= 1'b0;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `BNE_INST: begin
                        alu_op_group <= `BNCH_INST;
                        op <= `BNE;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= 5'h0;
                        rfile_we <= 1'b0;
                        pc_we <= 1'b1;
                        pc_increment <= 1'b0;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `BLT_INST: begin
                        alu_op_group <= `BNCH_INST;
                        op <= `BLT;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= 5'h0;
                        rfile_we <= 1'b0;
                        pc_we <= 1'b1;
                        pc_increment <= 1'b0;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `BGE_INST: begin
                        alu_op_group <= `BNCH_INST;
                        op <= `BGE;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= 5'h0;
                        rfile_we <= 1'b0;
                        pc_we <= 1'b1;
                        pc_increment <= 1'b0;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `BLTU_INST: begin
                        alu_op_group <= `BNCH_INST;
                        op <= `BLTU;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= 5'h0;
                        rfile_we <= 1'b0;
                        pc_we <= 1'b1;
                        pc_increment <= 1'b0;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `BGEU_INST: begin
                        alu_op_group <= `BNCH_INST;
                        op <= `BGEU;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= 5'h0;
                        rfile_we <= 1'b0;
                        pc_we <= 1'b1;
                        pc_increment <= 1'b0;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    default: begin
                        alu_op_group <= `BNCH_INST;
                        op <= `BEQ;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= 5'h0;
                        rfile_we <= 1'b0;
                        pc_we <= 1'b1;
                        pc_increment <= 1'b0;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                endcase
            end
            `LOAD_INST: begin
                case(funct3)
                    `LW_INST: begin
                        alu_op_group <= `LDST_INST;
                        op <= `LW;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b1;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `LH_INST: begin
                        alu_op_group <= `LDST_INST;
                        op <= `LH;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b1;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `LHU_INST: begin
                        alu_op_group <= `LDST_INST;
                        op <= `LHU;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b1;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `LB_INST: begin
                        alu_op_group <= `LDST_INST;
                        op <= `LB;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b1;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `LBU_INST: begin
                        alu_op_group <= `LDST_INST;
                        op <= `LBU;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b1;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    default: begin
                        alu_op_group <= `LDST_INST;
                        op <= `LW;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b1;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                endcase
            end
            `STORE_INST: begin
                case(funct3)
                    `SW_INST: begin
                        alu_op_group <= `LDST_INST;
                        op <= `SW;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= 5'h0;
                        rfile_we <= 1'b0;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b1;
                        memory_re <= 1'b0;
                        low_imm <= {instruction[31:25],instruction[11:7]};
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                        end
                    `SH_INST: begin
                        alu_op_group <= `LDST_INST;
                        op <= `SB;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= 5'h0;
                        rfile_we <= 1'b0;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b1;
                        memory_re <= 1'b0;
                        low_imm <= {instruction[31:25],instruction[11:7]};
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                        end
                    `SB_INST: begin
                        alu_op_group <= `LDST_INST;
                        op <= `SB;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= 5'h0;
                        rfile_we <= 1'b0;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b1;
                        memory_re <= 1'b0;
                        low_imm <= {instruction[31:25],instruction[11:7]};
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                        end
                    default: begin
                        alu_op_group <= `LDST_INST;
                        op <= `SW;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= 5'h0;
                        rfile_we <= 1'b0;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b1;
                        memory_re <= 1'b0;
                        low_imm <= {instruction[31:25],instruction[11:7]};
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                        end
                endcase
            end
            `OP_IMM_INST: begin
                case(funct3)
                    `ADDI_INST: begin
                        alu_op_group <= `IMM_INST;
                        op <= `ADDI;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                        end
                    `SLTI_INST: begin
                        alu_op_group <= `IMM_INST;
                        op <= `SLTI;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                        end
                    `SLTIU_INST: begin
                        alu_op_group <= `IMM_INST;
                        op <= `SLTIU;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `XORI_INST: begin
                        alu_op_group <= `IMM_INST;
                        op <= `XORI;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `ORI_INST: begin
                        alu_op_group <= `IMM_INST;
                        op <= `ORI;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `ANDI_INST: begin
                        alu_op_group <= `IMM_INST;
                        op <= `ANDI;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `SLLI_INST: begin
                        alu_op_group <= `SHIFT_INST;
                        op <= `SLLI;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= {7'h00, instruction[24:20]};
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `SRI_INST: begin
                        if (funct7 == `SRAI_INST) begin // SRAI
                            alu_op_group <= `SHIFT_INST;
                            op <= `SRAI;
                            rs1_addr <= instruction[19:15];
                            rs2_addr <= 5'h0;
                            rd_addr <= instruction[11:7];
                            rfile_we <= 1'b1;
                            pc_we <= 1'b0;
                            pc_increment <= 1'b1;
                            memory_we <= 1'b0;
                            memory_re <= 1'b0;
                            low_imm <= {7'h00, instruction[24:20]};
                            upper_imm <= 20'h0;
                            fence_sig <= 8'h00;
                            fence_mode <= 4'h0;
                        end
                        else if (funct7 == `SRLI_INST) begin // SRLI
                            alu_op_group <= `SHIFT_INST;
                            op <= `SRLI;
                            rs1_addr <= instruction[19:15];
                            rs2_addr <= 5'h0;
                            rd_addr <= instruction[11:7];
                            rfile_we <= 1'b1;
                            pc_we <= 1'b0;
                            pc_increment <= 1'b1;
                            memory_we <= 1'b0;
                            memory_re <= 1'b0;
                            low_imm <= {7'h00, instruction[24:20]};
                            upper_imm <= 20'h0;
                            fence_sig <= 8'h00;
                            fence_mode <= 4'h0;
                        end
                        else begin // SRLI as default
                            alu_op_group <= `SHIFT_INST;
                            op <= `SRLI;
                            rs1_addr <= instruction[19:15];
                            rs2_addr <= 5'h0;
                            rd_addr <= instruction[11:7];
                            rfile_we <= 1'b1;
                            pc_we <= 1'b0;
                            pc_increment <= 1'b1;
                            memory_we <= 1'b0;
                            memory_re <= 1'b0;
                            low_imm <= {7'h00, instruction[24:20]};
                            upper_imm <= 20'h0;
                            fence_sig <= 8'h00;
                            fence_mode <= 4'h0;
                        end
                    end
                    default: begin
                        alu_op_group <= `IMM_INST;
                        op <= `ADDI;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= 5'h0;
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= instruction[31:20];
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                endcase
            end
            `OP_INST: begin
                case(funct3)
                    `ADD_SUB_INST: begin
                        if(funct7 == `ADD_INST) begin
                            alu_op_group <= `RR_INST;
                            op <= `ADD;
                            rs1_addr <= instruction[19:15];
                            rs2_addr <= instruction[24:20];
                            rd_addr <= instruction[11:7];
                            rfile_we <= 1'b1;
                            pc_we <= 1'b0;
                            pc_increment <= 1'b1;
                            memory_we <= 1'b0;
                            memory_re <= 1'b0;
                            low_imm <= 12'h0;
                            upper_imm <= 20'h0;
                            fence_sig <= 8'h00;
                            fence_mode <= 4'h0;
                        end
                        else if (funct7 == `SUB_INST) begin
                            alu_op_group <= `RR_INST;
                            op <= `SUB;
                            rs1_addr <= instruction[19:15];
                            rs2_addr <= instruction[24:20];
                            rd_addr <= instruction[11:7];
                            rfile_we <= 1'b1;
                            pc_we <= 1'b0;
                            pc_increment <= 1'b1;
                            memory_we <= 1'b0;
                            memory_re <= 1'b0;
                            low_imm <= 12'h0;
                            upper_imm <= 20'h0;
                            fence_sig <= 8'h00;
                            fence_mode <= 4'h0;
                        end
                        else begin // Default to ADD
                            alu_op_group <= `RR_INST;
                            op <= `ADD;
                            rs1_addr <= instruction[19:15];
                            rs2_addr <= instruction[24:20];
                            rd_addr <= instruction[11:7];
                            rfile_we <= 1'b1;
                            pc_we <= 1'b0;
                            pc_increment <= 1'b1;
                            memory_we <= 1'b0;
                            memory_re <= 1'b0;
                            low_imm <= 12'h0;
                            upper_imm <= 20'h0;
                            fence_sig <= 8'h00;
                            fence_mode <= 4'h0;
                        end
                    end
                    `SLT_INST: begin
                        alu_op_group <= `RR_INST;
                        op <= `SLT;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= 12'h0;
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `SLTU_INST: begin
                        alu_op_group <= `RR_INST;
                        op <= `SLTU;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= 12'h0;
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `AND_INST: begin
                        alu_op_group <= `RR_INST;
                        op <= `AND;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= 12'h0;
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `OR_INST: begin
                        alu_op_group <= `RR_INST;
                        op <= `OR;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= 12'h0;
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `XOR_INST: begin
                        alu_op_group <= `RR_INST;
                        op <= `XOR;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= 12'h0;
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `SLL_INST: begin
                        alu_op_group <= `SHIFT_INST;
                        op <= `SLL;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= 12'h0;
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                    `SR_INST: begin
                        if (funct7 == `SRL_INST) begin
                            alu_op_group <= `SHIFT_INST;
                            op <= `SRL;
                            rs1_addr <= instruction[19:15];
                            rs2_addr <= instruction[24:20];
                            rd_addr <= instruction[11:7];
                            rfile_we <= 1'b1;
                            pc_we <= 1'b0;
                            pc_increment <= 1'b1;
                            memory_we <= 1'b0;
                            memory_re <= 1'b0;
                            low_imm <= 12'h0;
                            upper_imm <= 20'h0;
                            fence_sig <= 8'h00;
                            fence_mode <= 4'h0;
                        end
                        else if (funct7 == `SRA_INST) begin
                            alu_op_group <= `SHIFT_INST;
                            op <= `SRA;
                            rs1_addr <= instruction[19:15];
                            rs2_addr <= instruction[24:20];
                            rd_addr <= instruction[11:7];
                            rfile_we <= 1'b1;
                            pc_we <= 1'b0;
                            pc_increment <= 1'b1;
                            memory_we <= 1'b0;
                            memory_re <= 1'b0;
                            low_imm <= 12'h0;
                            upper_imm <= 20'h0;
                            fence_sig <= 8'h00;
                            fence_mode <= 4'h0;
                        end
                        else begin
                            alu_op_group <= `SHIFT_INST;
                            op <= `SRL;
                            rs1_addr <= instruction[19:15];
                            rs2_addr <= instruction[24:20];
                            rd_addr <= instruction[11:7];
                            rfile_we <= 1'b1;
                            pc_we <= 1'b0;
                            pc_increment <= 1'b1;
                            memory_we <= 1'b0;
                            memory_re <= 1'b0;
                            low_imm <= 12'h0;
                            upper_imm <= 20'h0;
                            fence_sig <= 8'h00;
                            fence_mode <= 4'h0;
                        end
                    end
                    default: begin
                        alu_op_group <= `RR_INST;
                        op <= `ADD;
                        rs1_addr <= instruction[19:15];
                        rs2_addr <= instruction[24:20];
                        rd_addr <= instruction[11:7];
                        rfile_we <= 1'b1;
                        pc_we <= 1'b0;
                        pc_increment <= 1'b1;
                        memory_we <= 1'b0;
                        memory_re <= 1'b0;
                        low_imm <= 12'h0;
                        upper_imm <= 20'h0;
                        fence_sig <= 8'h00;
                        fence_mode <= 4'h0;
                    end
                endcase
            end
            `FENCE_INST: begin
                alu_op_group <= `MEM_INST;
                op <= `FENCE;
                rs1_addr <= 5'h0; //instruction[19:15];
                rs2_addr <= 5'h0;
                rd_addr <= 5'h0; //instruction[11:7];
                rfile_we <= 1'b0;
                pc_we <= 1'b0;
                pc_increment <= 1'b1;
                memory_we <= 1'b0;
                memory_re <= 1'b0;
                low_imm <= 12'h0;
                upper_imm <= 20'h0;
                fence_sig <= instruction[27:20];
                fence_mode <= instruction[31:28];
            end
            `SYSTEM_INST: begin
                if (instruction[31:20] == `ECALL_INST) begin
                    alu_op_group <= `SYS_INST;
                    op <= `ECALL;
                    rs1_addr <= 5'h0; //instruction[19:15];
                    rs2_addr <= 5'h0;
                    rd_addr <= 5'h0; //instruction[11:7];
                    rfile_we <= 1'b0;
                    pc_we <= 1'b0;
                    pc_increment <= 1'b1;
                    memory_we <= 1'b0;
                    memory_re <= 1'b0;
                    low_imm <= 12'h0;
                    upper_imm <= 20'h0;
                    fence_sig <= 8'h00;
                    fence_mode <= 4'h0;
                end
                else if (instruction[31:20] == `EBREAK_INST) begin
                    alu_op_group <= `SYS_INST;
                    op <= `ECALL;
                    rs1_addr <= 5'h0; //instruction[19:15];
                    rs2_addr <= 5'h0;
                    rd_addr <= 5'h0; //instruction[11:7];
                    rfile_we <= 1'b0;
                    pc_we <= 1'b0;
                    pc_increment <= 1'b1;
                    memory_we <= 1'b0;
                    memory_re <= 1'b0;
                    low_imm <= 12'h0;
                    upper_imm <= 20'h0;
                    fence_sig <= 8'h00;
                    fence_mode <= 4'h0;
                end
                else begin
                    alu_op_group <= `SYS_INST;
                    op <= `ECALL;
                    rs1_addr <= 5'h0; //instruction[19:15];
                    rs2_addr <= 5'h0;
                    rd_addr <= 5'h0; //instruction[11:7];
                    rfile_we <= 1'b0;
                    pc_we <= 1'b0;
                    pc_increment <= 1'b1;
                    memory_we <= 1'b0;
                    memory_re <= 1'b0;
                    low_imm <= 12'h0;
                    upper_imm <= 20'h0;
                    fence_sig <= 8'h00;
                    fence_mode <= 4'h0;
                end
            end
            default: begin // Default to NOP pseudoinstruction
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
                low_imm <= instruction[`IALIGN-1:20];
                upper_imm <= 20'h0;
                fence_sig <= 8'h00;
                fence_mode <= 4'h0;
            end
        endcase
    end
    
endmodule
