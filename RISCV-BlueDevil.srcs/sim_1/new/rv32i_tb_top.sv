`timescale 1ns / 1ps    // Time unit/ Simulation resolution
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2025 09:48:45 AM
// Design Name: 
// Module Name: rv32i_tb_top
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

wire [`MAX_XLEN_INDEX:0] rs1,rs2,pc;
rv32i_regfile_tb_driver tb0(
    .clk(clk),
    .rst(rst),
    .rs1_data(rs1),
    .rs2_data(rs2),
    .pc_out(pc)
);

endmodule
