`timescale 1ns / 1ps    // Time unit / Simulation resolution
//////////////////////////////////////////////////////////////////////////////////
// Company: Central Connecticut State University - CET 497/498 Capstone
// Engineer: Joseph A. Hawker
// 
// Create Date: 03/04/2025 09:48:45 AM
// Design Name: RISC-V Processor
// Module Name: rv32i_tb_top
// Project Name: RISC-V Blue Devil
// Target Devices: Nexys 4 DDR
// Tool Versions: Vivado 2024.2.1
// Description: Top module for testing individual processor components. Nothing too
//          fancy.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "rv32i.vh"

module rv32i_tb_top();

// Clock driver
reg clk;
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;      // Simulate a 100 MHz Clk
end

// Initial reset signal
reg rst;
initial begin
    rst = 1'b0;
    #20 rst = 1'b1;
end

wire [`MAX_XLEN_INDEX:0] rs1_data_test,rs2_data_test,pc_data_test;
rv32i_regfile_tb_driver tb0(
    .clk(clk),
    .rst(rst),
    .rs1_data(rs1_data_test),
    .rs2_data(rs2_data_test),
    .pc_out(pc_data_test)
);

endmodule
