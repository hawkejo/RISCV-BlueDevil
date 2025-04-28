`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2025 09:07:42 AM
// Design Name: 
// Module Name: decode_pipeline
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "rv32i.vh"
`include "rv32i_inst.vh"

module decode_pipeline(
    // Pipeline signals
    output reg [`REG_MAX_ADDR:0] rs1_addr_out,
    output reg [`REG_MAX_ADDR:0] rs2_addr_out,
    output reg [`REG_MAX_ADDR:0] rd_addr_out,
    output reg rfile_we_out,
    output reg pc_we_out,
    output reg pc_increment_out,
    output reg memory_we_out,
    output reg memory_re_out,
    output reg [`IMM_MAX_INDEX:0] low_imm_out,
    output reg [`OP_GROUP_MAX_INDEX:0] alu_op_group_out,
    output reg [`OPS_MAX_INDEX:0] op_out,
    output reg [`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX]upper_imm_out,
    output reg [7:0] fence_sig_out,
    output reg [3:0] fence_mode_out,
    
    output reg [`MAX_XLEN_INDEX:0] current_pc_out,
    output reg [`IALIGN-1:0] current_inst_out,
    
    input [`REG_MAX_ADDR:0] rs1_addr_in,
    input [`REG_MAX_ADDR:0] rs2_addr_in,
    input [`REG_MAX_ADDR:0] rd_addr_in,
    input rfile_we_in,
    input pc_we_in,
    input pc_increment_in,
    input memory_we_in,
    input memory_re_in,
    input [`IMM_MAX_INDEX:0] low_imm_in,
    input [`OP_GROUP_MAX_INDEX:0] alu_op_group_in,
    input [`OPS_MAX_INDEX:0] op_in,
    input [`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX] upper_imm_in,
    input [7:0] fence_sig_in,
    input [3:0] fence_mode_in,
    
    input [`MAX_XLEN_INDEX:0] current_pc_in,
    input [`IALIGN-1:0] current_inst_in,
    
    // Control signals
    input clk,
    input rst,  // Low asserted
    input invalid,
    input stall
    );
    
    // Initialize to a modified NOP instruction
    initial begin
        rs1_addr_out        <= 5'h00;
        rs2_addr_out        <= 5'h00;
        rd_addr_out         <= 5'h00;
        rfile_we_out        <= 1'b0;
        pc_we_out           <= 1'b0;
        pc_increment_out    <= 1'b0;
        memory_we_out       <= 1'b0;
        memory_re_out       <= 1'b0;
        low_imm_out         <= 12'h000;
        alu_op_group_out    <= `IMM_INST;
        op_out              <= `ADDI;
        upper_imm_out       <= 20'h0_0000;
        fence_sig_out       <= 8'b0000_0000;
        fence_mode_out      <= 4'b0000;
        current_pc_out      <= (~`XLEN'h0) - `STARTUP_OFFSET - `XLEN'h4;
        current_inst_out    <= `IALIGN'h0000_0013;
    end
    
    always_ff @(posedge clk, negedge rst) begin
        if(~rst) begin
            rs1_addr_out        <= 5'h00;
            rs2_addr_out        <= 5'h00;
            rd_addr_out         <= 5'h00;
            rfile_we_out        <= 1'b0;
            pc_we_out           <= 1'b0;
            pc_increment_out    <= 1'b0;
            memory_we_out       <= 1'b0;
            memory_re_out       <= 1'b0;
            low_imm_out         <= 12'h000;
            alu_op_group_out    <= `IMM_INST;
            op_out              <= `ADDI;
            upper_imm_out       <= 20'h0_0000;
            fence_sig_out       <= 8'b0000_0000;
            fence_mode_out      <= 4'b0000;
            current_pc_out      <= (~`XLEN'h0) - `STARTUP_OFFSET - `XLEN'h4;
            current_inst_out    <= `IALIGN'h0000_0013;
        end
        else if(stall) begin
            rs1_addr_out        <= rs1_addr_out;
            rs2_addr_out        <= rs2_addr_out;
            rd_addr_out         <= rd_addr_out;
            rfile_we_out        <= rfile_we_out;
            pc_we_out           <= pc_we_out;
            pc_increment_out    <= pc_increment_out;
            memory_we_out       <= memory_we_out;
            memory_re_out       <= memory_re_out;
            low_imm_out         <= low_imm_out;
            alu_op_group_out    <= alu_op_group_out;
            op_out              <= op_out;
            upper_imm_out       <= upper_imm_out;
            fence_sig_out       <= fence_sig_out;
            fence_mode_out      <= fence_mode_out;
            current_pc_out      <= current_pc_out;
            current_inst_out    <= current_inst_out;
        end
        else if(invalid) begin
            rs1_addr_out        <= rs1_addr_in;
            rs2_addr_out        <= rs2_addr_in;
            rd_addr_out         <= 5'h00;
            rfile_we_out        <= 1'b0;
            pc_we_out           <= 1'b0;
            pc_increment_out    <= 1'b0;
            memory_we_out       <= 1'b0;
            memory_re_out       <= 1'b0;
            low_imm_out         <= low_imm_in;
            alu_op_group_out    <= alu_op_group_in;
            op_out              <= op_in;
            upper_imm_out       <= upper_imm_in;
            fence_sig_out       <= fence_sig_in;
            fence_mode_out      <= fence_mode_in;
            current_pc_out      <= current_pc_in;
            current_inst_out    <= current_inst_in;
        end
        else begin
            rs1_addr_out        <= rs1_addr_in;
            rs2_addr_out        <= rs2_addr_in;
            rd_addr_out         <= rd_addr_in;
            rfile_we_out        <= rfile_we_in;
            pc_we_out           <= pc_we_in;
            pc_increment_out    <= pc_increment_in;
            memory_we_out       <= memory_we_in;
            memory_re_out       <= memory_re_in;
            low_imm_out         <= low_imm_in;
            alu_op_group_out    <= alu_op_group_in;
            op_out              <= op_in;
            upper_imm_out       <= upper_imm_in;
            fence_sig_out       <= fence_sig_in;
            fence_mode_out      <= fence_mode_in;
            current_pc_out      <= current_pc_in;
            current_inst_out    <= current_inst_in;
        end
    end
endmodule
