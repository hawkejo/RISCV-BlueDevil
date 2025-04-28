`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2025 05:13:40 PM
// Design Name: 
// Module Name: execute_pipeline
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


module execute_pipeline(
    output reg [`MAX_XLEN_INDEX:0] rd_out, new_pc_out, io_out_addr_out,
    output reg [`REG_MAX_ADDR:0] rd_addr_out,
    output reg rfile_we_out,
    output reg pc_we_out,
    output reg pc_increment_out,
    output reg memory_we_out,
    output reg ebreak_out,
    output reg [7:0] fence_sig_out,
    output reg [3:0] fence_mode_out,
    
    output reg [`MAX_XLEN_INDEX:0] current_pc_out,
    output reg [`IALIGN-1:0] current_inst_out,
    output reg stall,
    output reg invalid,
    
    input [`MAX_XLEN_INDEX:0] rd_in, new_pc_in, io_out_addr_in,
    input [`REG_MAX_ADDR:0] rs1_addr_in, rs2_addr_in, rd_addr_in,
    input rfile_we_in,
    input pc_we_in,
    input pc_increment_in,
    input memory_we_in,
    input ebreak_in,
    input [7:0] fence_sig_in,
    input [3:0] fence_mode_in,
    
    input [`MAX_XLEN_INDEX:0] current_pc_in,
    input [`IALIGN-1:0] current_inst_in,
    input mem_ready,
    
    input clk,
    input rst
    );
    
    //reg load_inst;
    
    // Handle stall signal
    always_comb begin
        // Memory hazards
        if((current_inst_in[6:0] == `LOAD_INST) && !mem_ready) begin
            stall = 1'b1;
//            load_inst = 1'b1;
        end
//        else if(load_inst && !mem_ready) begin
//            stall = 1'b1;
//            load_inst = 1'b1;
//        end
        // ALU hazards
        else if((rd_addr_out == rs1_addr_in) && (rd_addr_out != 5'h00) /*&& !load_inst*/) begin
            stall = 1'b1;
//            load_inst = 1'b0;
        end
        else if((rd_addr_out == rs2_addr_in) && (rd_addr_out != 5'h00) /*&& !load_inst*/) begin
            stall = 1'b1;
//            load_inst = 1'b0;
        end
        else begin
            stall = 1'b0;
//            load_inst = 1'b0;
        end
    end
    
    // Invalid logic
    always_comb begin
        if(current_inst_out[6:0] == `JAL_INST) begin
            invalid = 1'b1;
        end
        else if(current_inst_out[6:0] == `JALR_INST) begin
            invalid = 1'b1;
        end
        else if(current_inst_out[6:0] == `BRANCH_INST) begin
            invalid = 1'b1;
        end
        else begin
            invalid = 1'b1;
        end
    end
    
    // Pipeline registers
    always_ff @(posedge clk, negedge rst) begin
        if(~rst) begin
            rd_out              <= `XLEN'h0;
            io_out_addr_out     <= `XLEN'h0;
            new_pc_out          <= (~`XLEN'h0) - `STARTUP_OFFSET - `XLEN'h8;
            rd_addr_out         <= 5'h00;
            rfile_we_out        <= 1'b0;
            pc_we_out           <= 1'b0;
            pc_increment_out    <= 1'b0;
            memory_we_out       <= 1'b0;
            ebreak_out          <= 1'b0;
            fence_sig_out       <= 8'b0000_0000;
            fence_mode_out      <= 4'b0000;
            current_pc_out      <= (~`XLEN'h0) - `STARTUP_OFFSET - `XLEN'h8;
            current_inst_out    <= `IALIGN'h0000_0013;
        end
        else if(stall) begin
            rd_out              <= `XLEN'h0;
            rd_addr_out         <= 5'h00;
            io_out_addr_out     <= `XLEN'h0;
            rfile_we_out        <= 1'b0;
            pc_we_out           <= 1'b0;
            pc_increment_out    <= 1'b0;
            memory_we_out       <= 1'b0;
            ebreak_out          <= 1'b0;
            fence_sig_out       <= 8'b0000_0000;
            fence_mode_out      <= 4'b0000;
            current_pc_out      <= current_pc_out;
            current_inst_out    <= current_inst_out;
        end
        else begin
            rd_out              <= rd_in;
            new_pc_out          <= new_pc_in;
            io_out_addr_out     <= io_out_addr_in;
            rd_addr_out         <= rd_addr_in;
            rfile_we_out        <= rfile_we_in;
            pc_we_out           <= pc_we_in;
            pc_increment_out    <= pc_increment_in;
            memory_we_out       <= memory_we_in;
            ebreak_out          <= ebreak_in;
            fence_sig_out       <= fence_sig_in;
            fence_mode_out      <= fence_mode_in;
            current_pc_out      <= current_pc_in;
            current_inst_out    <= current_inst_in;
        end
    end
endmodule
