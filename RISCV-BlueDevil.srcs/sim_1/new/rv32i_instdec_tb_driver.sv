`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2025 09:48:45 AM
// Design Name: 
// Module Name: rv32i_instdec_tb_driver
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

module rv32i_instdec_tb_driver(
    output [`REG_MAX_ADDR:0] rs1_addr, rs2_addr, rd_addr,
    output rfile_we, pc_we, pc_increment, memory_we, memory_re,
    output [`IMM_MAX_INDEX:0] low_imm,
    output [`UPPER_IMM_MAX_INDEX:`UPPER_IMM_LOW_INDEX] upper_imm,
    output [`OP_GROUP_MAX_INDEX:0] op_group,
    output [`OPS_MAX_INDEX:0] op,
    output [7:0] fence_sig,
    output [3:0] fence_mode
    );
    reg [`IALIGN-1:0] instruction;
    
    // UUT
    instruction_decoder dec0(
        .rs1_addr(rs1_addr), 
        .rs2_addr(rs2_addr), 
        .rd_addr(rd_addr),
        .rfile_we(rfile_we), 
        .pc_we(pc_we), 
        .pc_increment(pc_increment), 
        .memory_we(memory_we), 
        .memory_re(memory_re),
        .low_imm(low_imm),
        .alu_op_group(op_group),
        .op(op),
        .upper_imm(upper_imm),
        .fence_sig (fence_sig),
        .fence_mode(fence_mode),
        .instruction(instruction)
    );
    
    initial begin
        instruction = `IALIGN'hFFFF_FFFF;   // Should return a NOP
        #5 $display("Initial state:\nrs1_addr: %h, rs2_addr: %h, rd_addr: %h", rs1_addr, rs2_addr, rd_addr);
        $display("rfile_we: %b, pc_we: %b, pc_increment: %b, memory_we: %b, memory_re: %b", rfile_we,
            pc_we, pc_increment, memory_we, memory_re);
        
        // LUI
        #5 instruction = {20'hCAD69, 5'b10101, `LUI_INST};
        #5 $display("Initial state:\nrs1_addr: %h, rs2_addr: %h, rd_addr: %h", rs1_addr, rs2_addr, rd_addr);
        $display("rfile_we: %b, pc_we: %b, pc_increment: %b, memory_we: %b, memory_re: %b", rfile_we,
            pc_we, pc_increment, memory_we, memory_re);
            
        // AUIPC
        #5 instruction = {20'h69CAD, 5'b01010, `AUIPC_INST};
        #5 $display("Initial state:\nrs1_addr: %h, rs2_addr: %h, rd_addr: %h", rs1_addr, rs2_addr, rd_addr);
        $display("rfile_we: %b, pc_we: %b, pc_increment: %b, memory_we: %b, memory_re: %b", rfile_we,
            pc_we, pc_increment, memory_we, memory_re);
        
        // JAL
        #5 instruction = {20'h69CAD, 5'b01010, `AUIPC_INST};
        #5 $display("Initial state:\nrs1_addr: %h, rs2_addr: %h, rd_addr: %h", rs1_addr, rs2_addr, rd_addr);
        $display("rfile_we: %b, pc_we: %b, pc_increment: %b, memory_we: %b, memory_re: %b", rfile_we,
            pc_we, pc_increment, memory_we, memory_re);
        
        // JALR
        
        
        //
    end
    
endmodule
