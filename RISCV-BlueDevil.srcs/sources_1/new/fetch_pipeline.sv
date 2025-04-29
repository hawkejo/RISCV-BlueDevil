`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2025 08:30:38 AM
// Design Name: 
// Module Name: fetch_pipeline
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
`include "rv64i_inst.vh"

module fetch_pipeline(
    output reg [`IALIGN-1:0] ifetch_out,
    output reg [`MAX_XLEN_INDEX:0] pc_next_out,
    output reg decode_invalid,
    input [`IALIGN-1:0] ifetch_in,
    input [`MAX_XLEN_INDEX:0] pc_next_in,
    input clk,
    input rst,
    input stall,
    input invalid
    );
    
    always_ff @(posedge clk, negedge rst) begin
        if(~rst) begin
            ifetch_out  <= `IALIGN'h0000_0013;
            pc_next_out <= ~`STARTUP_OFFSET;
            decode_invalid <= 1'b0;
        end
        else if(stall) begin
            ifetch_out <= ifetch_out;
            pc_next_out <= pc_next_out;
            decode_invalid <= 1'b0;
        end
        else if(invalid) begin
            ifetch_out <= ifetch_out;
            pc_next_out <= pc_next_out;
            decode_invalid <= 1'b1;
        end
        else begin
            ifetch_out <= ifetch_in;
            pc_next_out <= pc_next_in;
            decode_invalid <= 1'b0;
        end
    end
    
endmodule
