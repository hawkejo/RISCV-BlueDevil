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


module cpu_main(
    output [`MAX_XLEN_INDEX:0] io_addr,
    output [`MAX_XLEN_INDEX:0] mem_out,
    output pc_out,
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
    
    register_file reg_file0(
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .pc(pc_out),
        .rd_data(rd_data),
        .pc_write_data(pc_write_data),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .rfile_we(rfile_we),
        .pc_we(pc_we),
        .pc_increment(pc_increment),
        .rst(rst),
        .clk(clk),
        .ebreak_set(ebreak_set),
        .ebreak_clear(ebreak_clear)
    );
    
    alu arith0(
        .rd(rd_data),
        .pc_out(pc_write_data),
        .io_addr(io_addr),
        .ecall(),
        .ebreak(ebreak_set),
        .alu_op_group(op_group),
        .op(op),
        .rs1(rs1_data),
        .rs2(rs2_data),
        .low_imm(low_imm),
        .pc_in(pc_out),
        .mem_in(mem_in),
        .upper_imm(upper_imm),
        .fence_sig(),
        .fence_mode()
    );
    
    instruction_decoder dec0(
        .rs1_addr(rs1_addr), 
        .rs2_addr(rs2_addr), 
        .rd_addr(rd_addr),
        .rfile_we(rfile_we), 
        .pc_we(pc_we), 
        .pc_increment(pc_increment), 
        .memory_we(memory_we), 
        .memory_re(memory_re),
        .low_imm(low_imm),
        .alu_op_group(op_group),
        .op(op),
        .upper_imm(upper_imm),
        .fence_sig (fence_sig),
        .fence_mode(fence_mode),
        .instruction(instruction)
    );
        
endmodule
