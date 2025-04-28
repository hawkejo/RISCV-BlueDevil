`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Central Connecticut State University - CET 497/498 Capstone
// Engineer: Joseph A. Hawker
// 
// Create Date: 10/14/2024 11:55:05 AM
// Design Name: RISC-V Processor
// Module Name: cpu_main
// Project Name: RISCV-BlueDevil
// Target Devices: Nexys 4 DDR, Nexys A7, Nexys Video
// Tool Versions: Vivado 2024.2.1
// Description:     Top module used to create the actual CPU core. 
// 
// Dependencies:    rv32i.vh - Used to define implementation parameters
//                  in central location.
//                  rv32i_inst.vh - Used to define parameters for the RV32I opcodes.
// 
// Revision: 0.1
// Revision 0.1 - File completed, but not verified.
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "rv32i.vh"
`include "rv32i_inst.vh"

module cpu_main(
    output [`MAX_XLEN_INDEX:0] io_in_addr,
    output [`MAX_XLEN_INDEX:0] io_out_addr,
    output [`MAX_XLEN_INDEX:0] mem_out,
    output [`MAX_XLEN_INDEX:0] pc_out,
    output [7:0] fence_sig, // Signals for memory ordering: PI, PO, PR, PW, SI, SO, SR, SW
    output [3:0] fence_mode,
    output memory_we, memory_re,
    input [`MAX_XLEN_INDEX:0] mem_in,
    input mem_ready,        // Only applies to read signals. Write signals should be buffered
    input [`IALIGN-1:0] instruction,    // by the memory controller.
    input clk, rst,
    input ebreak_clear
);
//    wire [`MAX_XLEN_INDEX:0]  pc_write_data;
//    wire [`MAX_XLEN_INDEX:0] rs1_data, rs2_data, store_rd_data;
    
//    wire [`IMM_MAX_INDEX:0] low_imm;
//    wire [`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX] upper_imm;
    
//    wire [`REG_MAX_ADDR:0] rs1_addr, rs2_addr, rd_addr;
    
//    wire [`OPS_MAX_INDEX:0] op;
//    wire [`OP_GROUP_MAX_INDEX:0] op_group;
    
//    wire ebreak_set;
//    wire is_invalid;
//    wire set_stall;
    
    
    
    // Instruction Fetch
    wire [`IALIGN-1:0] instruction_f_out;
    wire [`IALIGN-1:0] pc_next_f_in;
    wire decode_invalid;
    
    fetch_pipeline pipe_f0(
        .ifetch_out(instruction_f_out),
        .pc_next_out(pc_out),
        .decode_invalid(decode_invalid),
        .ifetch_in(instruction),
        .pc_next_in(pc_next_f_in),
        .clk(clk),
        .rst(rst),
        .stall(set_stall),
        .invalid(is_invalid)
    );
    
    // Instruction Decode
    wire [`REG_MAX_ADDR:0] rs1_addr_in, rs2_addr_in, rd_addr_in;
    wire rfile_we_in, pc_we_in, pc_increment_in, memory_we_in, memory_re_in;
    wire [`IMM_MAX_INDEX:0] low_imm_in;
    wire [`OP_GROUP_MAX_INDEX:0] alu_op_group_in;
    wire [`OPS_MAX_INDEX:0] op_in;
    wire [`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX] upper_imm_in;
    wire [7:0] fence_sig_in;
    wire [3:0] fence_mode_in;
    
    instruction_decoder dec0(
        .rs1_addr(rs1_addr_in), 
        .rs2_addr(rs2_addr_in), 
        .rd_addr(rd_addr_in),
        .rfile_we(rfile_we_in), 
        .pc_we(pc_we_in), 
        .pc_increment(pc_increment_in), 
        .memory_we(memory_we_in), 
        .memory_re(memory_re_in),
        .low_imm(low_imm_in),
        .alu_op_group(alu_op_group_in),
        .op(op_in),
        .upper_imm(upper_imm_in),
        .fence_sig (fence_sig_in),
        .fence_mode(fence_mode_in),
        .instruction(instruction_f_out)
    );
    
    wire [`REG_MAX_ADDR:0] rs1_addr_out, rs2_addr_out, rd_addr_dec_out;
    wire rfile_we_dec_out, pc_we_dec_out, pc_increment_dec_out, memory_we_dec_out, memory_re_dec_out;
    wire [`IMM_MAX_INDEX:0] low_imm_out;
    wire [`OP_GROUP_MAX_INDEX:0] alu_op_group_out;
    wire [`OPS_MAX_INDEX:0] op_out;
    wire [`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX] upper_imm_out;
    wire [7:0] fence_sig_dec_out;
    wire [3:0] fence_mode_dec_out;
    
    wire [`IALIGN-1:0] instruction_d_out;
    wire [`IALIGN-1:0] dec_current_pc_out;
    
    decode_pipeline pipe_d0(
        // Pipeline signals
        .rs1_addr_out(rs1_addr_out),
        .rs2_addr_out(rs2_addr_out),
        .rd_addr_out(rd_addr_dec_out),
        .rfile_we_out(rfile_we_dec_out),
        .pc_we_out(pc_we_dec_out),
        .pc_increment_out(pc_increment_dec_out),
        .memory_we_out(memory_we_dec_out),
        .memory_re_out(memory_re_dec_out),
        .low_imm_out(low_imm_out),
        .alu_op_group_out(alu_op_group_out),
        .op_out(op_out),
        .upper_imm_out(upper_imm_out),
        .fence_sig_out(fence_sig_dec_out),
        .fence_mode_out(fence_mode_dec_out),
        
        .current_pc_out(dec_current_pc_out),
        .current_inst_out(instruction_d_out),
        
        .rs1_addr_in(rs1_addr_in),
        .rs2_addr_in(rs2_addr_in),
        .rd_addr_in(rd_addr_in),
        .rfile_we_in(rfile_we_in),
        .pc_we_in(pc_we_in),
        .pc_increment_in(pc_increment_in),
        .memory_we_in(memory_we_in),
        .memory_re_in(memory_re_in),
        .low_imm_in(low_imm_in),
        .alu_op_group_in(alu_op_group_in),
        .op_in(op_in),
        .upper_imm_in(upper_imm_in),
        .fence_sig_in(fence_sig_in),
        .fence_mode_in(fence_mode_in),
        
        .current_pc_in(pc_out),
        .current_inst_in(instruction_f_out),
        
        // Control signals
        .clk(clk),
        .rst(rst),  // Low asserted
        .invalid(decode_invalid | is_invalid), // Determined by execute stage
        .stall(set_stall)    // Determined by execute stage
    ); // Phew...
    
    assign memory_re = memory_re_dec_out;
    
    // Instruction Execute
    wire [`MAX_XLEN_INDEX:0] rs1, rs2, alu_rd, alu_pc_out, alu_io_out_addr;
    wire ecall_out, alu_ebreak_out;
    
    alu arith0(
        .rd(alu_rd),
        .pc_out(alu_pc_out),
        .io_in_addr(io_in_addr),
        .io_out_addr(alu_io_out_addr),
        .ecall(ecall_out),
        .ebreak(ebreak_out),
        
        .alu_op_group(alu_op_group_out),
        .op(op_out),
        .rs1(rs1),
        .rs2(rs2),
        .low_imm(low_imm_out),
        .pc_in(dec_current_pc_out),
        .mem_in(mem_in),
        .upper_imm(upper_imm_out),
        .fence_sig(fence_sig_dec_out),
        .fence_mode(fence_mode_dec_out)
    );
    
    wire [`MAX_XLEN_INDEX:0] rd_exe_out, exe_new_pc, exe_io_out_addr;
    wire [`REG_MAX_ADDR:0] exe_rd_addr;
    wire exe_rfile_we, exe_pc_we, exe_pc_increment, exe_memory_we, exe_ebreak_out;
    wire [`MAX_XLEN_INDEX:0] exe_current_pc;
    wire [`IALIGN-1:0] exe_current_inst;
    
    // Pipeline control logic is in the execute stage!
    // It is implemented as combinatoral logic
    execute_pipeline pipe_e0(
        .rd_out(rd_exe_out),
        .new_pc_out(exe_new_pc),
        .io_out_addr_out(exe_io_out_addr),
        .rd_addr_out(exe_rd_addr),
        .rfile_we_out(exe_rfile_we),
        .pc_we_out(exe_pc_we),
        .pc_increment_out(exe_pc_increment),
        .memory_we_out(exe_memory_we),
        .ebreak_out(exe_ebreak_out),
        .fence_sig_out(fence_sig_dec_out),
        .fence_mode_out(fence_mode_dec_out),
        
        .current_pc_out(),
        .current_inst_out(),
        .stall(set_stall),
        .invalid(is_invalid),
        
        .rd_in(alu_rd),
        .new_pc_in(alu_pc_out),
        .io_out_addr_in(alu_io_out_addr),
        .rs1_addr_in(rs1_addr_out), 
        .rs2_addr_in(rs2_addr_in),
        .rd_addr_in(rd_addr_dec_out),
        .rfile_we_in(rfile_we_dec_out),
        .pc_we_in(pc_we_dec_out),
        .pc_increment_in(pc_increment_dec_out),
        .memory_we_in(memory_we_dec_out),
        .ebreak_in(alu_ebreak_out),
        .fence_sig_in(fence_sig_in),
        .fence_mode_in(fence_mode_in),
        
        .current_pc_in(dec_current_pc_out),
        .current_inst_in(instruction_d_out),
        .mem_ready(mem_ready),
        
        .clk(clk),
        .rst(rst)
    );
    
    // Instruction Store
    register_file reg_file0(
        .rs1_data(rs1),
        .rs2_data(rs2),
        .pc(pc_next_f_in),
        .rd_data(rd_exe_out),
        .pc_write_data(exe_new_pc),
        .rs1_addr(rs1_addr_out),
        .rs2_addr(rs2_addr_out),
        .rd_addr(exe_rd_addr),
        .rfile_we(exe_rfile_we),
        .pc_we(exe_pc_we),
        .pc_increment(exe_pc_increment),
        .rst(rst),
        .clk(clk),
        .ebreak_set(exe_ebreak_out),
        .ebreak_clear(ebreak_clear) // Signal not synchronized to clock!
    );
    
    // Some invalid logic here too
    store_pipeline pipe_s0(
        .rd_out(mem_out),
        .io_out_addr(io_out_addr),
        .memory_we_out(memory_we),
        .fence_sig_out(fence_sig),
        .fence_mode_out(fence_mode),
        
        .rd_in(rd_exe_out),
        .io_out_addr_in(exe_io_out_addr),
        .memory_we_in(exe_memory_we),
        .ebreak_set_in(exe_ebreak_out),
        .fence_sig_in(fence_sig_dec_out),
        .fence_mode_in(fence_mode_dec_out),
        
        .clk(clk),
        .rst(rst)
    );
           
endmodule
