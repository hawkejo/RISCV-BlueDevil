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
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_main(
    input clk, rst
);
    wire [`MAX_XLEN_INDEX:0] pc_out, pc_write_data;
    wire [`MAX_XLEN_INDEX:0] rs1_data, rs2_data;
    wire ebreak_set;
    
    register_file reg_file0(
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .pc(pc_out),
        .rd_data(),
        .pc_write_data(pc_write_data),
        .rs1_addr(),
        .rs2_addr(),
        .rd_addr(),
        .rfile_we(),
        .pc_we(),
        .pc_increment(),
        .rst(rst),
        .clk(clk),
        .ebreak_set(ebreak_set),
        .ebreak_clear()
    );
    
    alu arith0(
        .rd(),
        .pc_out(pc_write_data),
        .io_addr(),
        .ecall(),
        .ebreak(ebreak_set),
        .alu_op_group(),
        .op(),
        .rs1(rs1_data),
        .rs2(rs2_data),
        .low_imm(),
        .pc_in(pc_out),
        .mem_in(),
        .upper_imm(),
        .fence_sig(),
        .fence_mode()
    );
        
endmodule
