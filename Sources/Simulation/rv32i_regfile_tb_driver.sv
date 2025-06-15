`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Central Connecticut State University - CET 497/498 Capstone
// Engineer: Joseph A. Hawker
// 
// Create Date: 03/04/2025 09:48:45 AM
// Design Name: RISC-V Processor
// Module Name: rv32i_regfile_tb_driver
// Project Name: RISC-V Blue Devil
// Target Devices: Nexys 4 DDR
// Tool Versions: Vivado 2024.2.1
// Description: Driver module for testing the RISC-V register file. It is noted
//          that the ebreak functionality is not tested in the processor.
// 
// Dependencies: register_file.sv   - The UUT
//               rv32i.vh           - Header file containing useful macros
// 
// Revision: 1.00
// Revision 1.00 - Basic functionality of register file verified
// Revision 0.01 - File Created
// Additional Comments: More test cases should be implemented via loops to more
//      thouroghly test the accuracy of the device.
//////////////////////////////////////////////////////////////////////////////////
`include "rv64i.vh"

module rv32i_regfile_tb_driver(
    output reg [`MAX_XLEN_INDEX:0]rs1_data, rs2_data, pc_out,
    input clk, rst
);

// Internal signals
reg [`MAX_XLEN_INDEX:0] rd_data;
reg [`REG_MAX_ADDR:0] rd_addr, rs1_addr, rs2_addr;
reg rfile_we;
reg pc_increment, pc_we;
reg [`MAX_XLEN_INDEX:0] pc_write_data;

// UUT
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

integer i;
initial begin    
    // Test storing data to the register file
    // Register 0 should always return 0
    // Wait on reset and verify everything's cleared
    $display("Initializing register file");
    #40 rs1_addr = 5'h00;
    for(i = 0; i < `NUM_REGS; i=i+1) begin
        #5  rs1_addr = i;
            rs2_addr = i;
    end
    
    // Test the program counter function
    $display("\n Testing Program Counter");
    $display("Initial PC after reset signal: %h", pc_out);
    pc_increment = 1'b1;
    #10 pc_increment = 1'b0;
    $display("PC after increment signal: %h", pc_out);
    pc_write_data = `XLEN'hDEAD_BEEF;
    #4 pc_we = 1'b1;
    #10 pc_we = 1'b0;
    $display("PC after load: %h", pc_out);
    
    // Start the writing sequence
    // x0 must always be 0
    $display("Testing Register File");
    $display("Writing data to registers...");
    rd_data = `XLEN'hFFFF;
    rd_addr = 5'h00;
    #10 rfile_we = 1'b1;
    #10 rfile_we = 1'b0;
    rs1_addr = 5'h00;
    rs2_addr = 5'h00;
    
    // Write to all the other registers
    for (i = 1; i < `NUM_REGS; i=i+1) begin
        rd_data = `XLEN'h0F00+i;
        rd_addr = i[`REG_MAX_ADDR:0];
        #10 rfile_we = 1'b1;
        #10 rfile_we = 1'b0;
    end
    
    // Now read the written data asynchronous to the clock
    $display("Reading data from rs1");
    for (i = 0; i < `NUM_REGS; i=i+1) begin
        #5 rs1_addr = i[`REG_MAX_ADDR:0];
        #5 $display("rs1_addr: %h, rs1: %h", rs1_addr, rs1_data);
    end
    $display("Reading data from rs2");
    for (i = 0; i < `NUM_REGS; i=i+1) begin
        #5 rs2_addr = i[`REG_MAX_ADDR:0];
        #5 $display("rs2_addr: %h, rs2: %h", rs2_addr, rs2_data);
    end
end

endmodule
