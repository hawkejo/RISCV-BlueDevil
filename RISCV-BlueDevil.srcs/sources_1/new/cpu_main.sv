`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2024 11:55:05 AM
// Design Name: 
// Module Name: cpu_main
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


module cpu_main(
    input clk, rst
);    
    register_file reg_file0(
        .rs1_data(),
        .rs2_data(),
        .pc(),
        .rd_data(),
        .pc_write_data(),
        .rs1_addr(),
        .rs2_addr(),
        .rd_addr(),
        .rfile_we(),
        .pc_we(),
        .pc_increment(),
        .rst(rst),
        .clk(clk)
    );
        
endmodule
