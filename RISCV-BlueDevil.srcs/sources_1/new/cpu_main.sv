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
    output [`MAX_XLEN_INDEX:0] io_addr,
    output [`MAX_XLEN_INDEX:0] mem_out,
    output [`MAX_XLEN_INDEX:0] pc_out,
    output [7:0] fence_sig, // Signals for memory ordering: PI, PO, PR, PW, SI, SO, SR, SW
    output [3:0] fence_mode,
    input [`MAX_XLEN_INDEX:0] mem_in,
    input [`IALIGN-1:0] instruction,
    input clk, rst,
    input ebreak_clear
);
    wire [`MAX_XLEN_INDEX:0]  pc_write_data;
    wire [`MAX_XLEN_INDEX:0] rs1_data, rs2_data, rd_data;
    
    wire [`IMM_MAX_INDEX:0] low_imm;
    wire [`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX] upper_imm;
    
    wire [`REG_MAX_ADDR:0] rs1_addr, rs2_addr, rd_addr;
    wire rfile_we, pc_we, pc_increment, memory_we, memory_re;
    
    wire [`OPS_MAX_INDEX:0] op;
    wire [`OP_GROUP_MAX_INDEX:0] op_group;
    
    wire ebreak_set;
    
    assign mem_out = rd_data;
    
    // Instruction Fetch
    wire [`IALIGN:0] instruction_f_out;
    wire [`MAX_XLEN_INDEX:0] pc_next_f_in;
    
    fetch_pipeline pipe_f0(
        .ifetch_out(instruction_f_out),
        .pc_next_out(pc_out),
        .ifetch_in(instruction),
        .pc_next_in(pc_next_f_in),
        .clk(clk),
        .rst(rst)
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
        .fence_mode(),
        .instruction(instruction_f_out)
    );
    
    decode_pipeline pipe_d0(
        // Pipeline signals
        .rs1_addr_out(),
        .rs2_addr_out(),
        .rd_addr_out(),
        .rfile_we_out(),
        .pc_we_out(),
        .pc_increment_out(),
        .memory_we_out(),
        .memory_re_out(),
        .low_imm_out(),
        .alu_op_group_out(),
        .op_out(),
        .upper_imm_out(),
        .fence_sig_out(),
        .fence_mode_out(),
        
        .current_pc_out(),
        .current_inst_out(),
        
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
        .invalid(),
        .stall()
    ); // Phew...
    
    // Instruction Execute
    alu arith0(
        .rd(),
        .pc_out(),
        .io_addr(),
        .ecall(),
        .ebreak(),
        .alu_op_group(),
        .op(),
        .rs1(),
        .rs2(),
        .low_imm(),
        .pc_in(),
        .mem_in(),
        .upper_imm(),
        .fence_sig(),
        .fence_mode()
    );
    
    // Instruction Store
    register_file reg_file0(
        .rs1_data(),
        .rs2_data(),
        .pc(pc_next_f_in),
        .rd_data(),
        .pc_write_data(),
        .rs1_addr(),
        .rs2_addr(),
        .rd_addr(),
        .rfile_we(),
        .pc_we(),
        .pc_increment(),
        .rst(rst),
        .clk(clk),
        .ebreak_set(),
        .ebreak_clear()
    );
    
    // Instruction Store
           
endmodule
