`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2024 11:55:05 AM
// Design Name: 
// Module Name: nexys4ddr_interface
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


module nexys4ddr_interface(

    );
    
    cpu_main cpu0(
        .io_in_addr(),
        .io_out_addr(),
        .mem_out(),
        .pc_out(),
        .fence_sig(),
        .fence_mode(),
        .memory_we(),
        .memory_re(),
        .mem_in(),
        .mem_ready(),
        .instruction(),
        .clk(),
        .rst(),
        .ebreak_clear()
    );
endmodule
