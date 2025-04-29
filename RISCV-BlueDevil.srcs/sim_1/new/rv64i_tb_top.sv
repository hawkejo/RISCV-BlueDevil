`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2025 01:53:20 PM
// Design Name: 
// Module Name: rv64i_tb_top
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

module rv64i_tb_top();
    reg clk, rst;
    wire [`MAX_XLEN_INDEX:0] pc_out;
    reg [`IALIGN-1:0] instruction;
    wire mem_we;
    wire [`MAX_XLEN_INDEX:0] mem_out, io_out_addr;
    
    localparam startAddr = ~`STARTUP_OFFSET;
    
    // Instantiate UUT
    cpu_main cpu0( // RV64I
        .io_in_addr(),
        .mem_in(`XLEN'h0),
        .memory_re(),
        .mem_ready(1'b1),
        
        .io_out_addr(io_out_addr),
        .mem_out(mem_out),
        .memory_we(mem_we),
        
        .pc_out(pc_out),
        .instruction(instruction),
        
        .fence_sig(),
        .fence_mode(),
        .ebreak_clear(1'b0),
        
        .clk(clk),
        .rst(rst)
    );
    
    // Generate clock signal
    initial begin
        clk = 1'b0;
        forever
            #5      clk = ~clk;
    end
    
    // Driving program
    initial begin
        // Reset the processor core
        rst = 1'b0;
        #20     rst = 1'b1;
    end
    
    // Display logic
    always_ff @(posedge mem_we) begin
        if(io_out_addr == `XLEN'h0) begin
            $display("Data: %x\n", mem_out);
        end
    end
    
    // Program ROM
    always_comb begin
        case(pc_out)
            // Something to test basic functionality
            // This should verify the instructions: addi, lui, slli, add, sd
            startAddr:              instruction = {20'h0_F0F0,5'd05,`LUI_INST};                         // lui x5,#0x0F0F0
            (startAddr+ 64'h10):     instruction = {12'h7F0, 5'd05,`ADDI_INST,5'd06,`OP_IMM_INST};       // addi x6,x5,#0x7f0
            (startAddr+ 64'h20):     instruction = {6'h00,6'd32,5'd06,`SLLI_INST,5'd07,`OP_IMM_INST};    // slli x7,x6,#32
            (startAddr+ 64'h30):     instruction = {20'h0_F0F0,5'd08,`LUI_INST};                         // lui x8,#0x0F0F0
            (startAddr+ 64'h40):    instruction = {12'h7F0, 5'd08,`ADDI_INST,5'd09,`OP_IMM_INST};       // addi x9,x8,#0x7f0
            (startAddr+ 64'h50):    instruction = {`ADD_INST,5'd09,5'd07,`ADD_SUB_INST,5'd10,`OP_INST}; // add x10,x7,x9
            (startAddr+ 64'h60):    instruction = {7'h00,5'd10,5'd00,`SD_INST,5'h00,`STORE_INST};       // sd 0(x0),x10
            
            default:            instruction = {12'h000, 5'd00,`ADDI_INST,5'd00,`OP_IMM_INST};       //addi x0,x0,x0 ; nop
        endcase
    end
endmodule
