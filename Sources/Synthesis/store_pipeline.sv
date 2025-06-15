`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2025 05:20:01 PM
// Design Name: 
// Module Name: store_pipeline
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
`include "rv64i.vh"

module store_pipeline(
    output reg [`MAX_XLEN_INDEX:0] rd_out,
    output reg [`MAX_XLEN_INDEX:0] io_out_addr,
    output reg memory_we_out,
    output reg [7:0] fence_sig_out,
    output reg [3:0] fence_mode_out,
    
    input [`MAX_XLEN_INDEX:0] rd_in,
    input [`MAX_XLEN_INDEX:0] io_out_addr_in,
    input memory_we_in,
    input ebreak_set_in,
    input [7:0] fence_sig_in,
    input [3:0] fence_mode_in,
    
    input clk,
    input rst
    );
    
    always_ff @(posedge clk, negedge rst) begin
        if(~rst) begin
            rd_out          <= `XLEN'h0;
            io_out_addr     <= `XLEN'h0;
            memory_we_out   <= 1'b0;
            fence_sig_out   <= 8'b0000_0000;
            fence_mode_out  <= 4'b0000;
        end
        else begin
            rd_out          <= rd_in;
            io_out_addr     <= io_out_addr_in;
            memory_we_out   <= memory_we_in;
            fence_sig_out   <= fence_sig_in;
            fence_mode_out  <= fence_mode_in;
        end
    end
endmodule
