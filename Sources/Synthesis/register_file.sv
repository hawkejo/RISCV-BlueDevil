`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Central Connecticut State University - CET 497/498 Capstone
// Engineer: Joseph A. Hawker
// 
// Create Date: 10/14/2024 11:55:05 AM
// Design Name: RISC-V Integer Register File
// Module Name: register_file
// Project Name: RISCV-BlueDevil
// Target Devices: Nexys 4 DDR, Nexys Video
// Tool Versions: Vivado 2024.2.1
// Description:     Dual-ported register file with independent program counter
//              control. Nothing too fancy.
// 
// Dependencies:    rv32i.vh - Used to define parameters in central location
// 
// Revision: 0.1
// Revision 0.1  - Base register file created, but unverified. (JAH: 2025-02-17)
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
`include "rv64i.svh"

module register_file(
    output [`MAX_XLEN_INDEX:0] rs1_data, rs2_data,          // Register outputs
    output reg[`MAX_XLEN_INDEX:0] pc,                       // Program counter output
    input [`MAX_XLEN_INDEX:0] rd_data, pc_write_data,       // Write data inputs
    input [`REG_MAX_ADDR:0] rs1_addr, rs2_addr, rd_addr,    // Register file addresses
    input rfile_we, pc_we, pc_increment, rst, clk,          // Control signals
    input ebreak_set, ebreak_clear                          // Signals for EBREAK instruction
);
    reg [`MAX_XLEN_INDEX:0] register_file [0:`NUM_REGS-1];  // The register file itself
    reg ebreak_state;                                       // Used for ebreak instruction
    
    // Initialize everything
    reg [`REG_MAX_ADDR+1:0] i;
    
    // Handle the outputs
    assign rs1_data = register_file[rs1_addr];
    assign rs2_data = register_file[rs2_addr];

    // Now handle program counter. Note the output for the PC is always exposed.
    always_ff @ (posedge clk, negedge rst) begin
        if (~rst) begin
            pc <= (~`XLEN'h0) - `STARTUP_OFFSET + `XLEN'h4;
        end
        else if (clk) begin
            if (pc_we)
                pc <= pc_write_data;
            else if (pc_increment)
                pc <= pc + (`IALIGN_BYTES);
            else
                pc <= pc;
        end
        else begin
            pc <= pc;
        end
    end
    
    // Finally, handle the rest of the register file
    always_ff @ (posedge clk, negedge rst) begin
        if (~rst) begin
            for(i = 0; i < `NUM_REGS; i=i+1) begin
                register_file[i] <= `XLEN'h0;
            end
        end
        else if (rfile_we) begin
            if(rd_addr == 5'h00) begin // x0 is always 0
                register_file[rd_addr] <= `XLEN'h0;
            end else begin
                register_file[rd_addr] <= rd_data;
            end
        end
        else begin
            register_file[rd_addr] <= register_file[rd_addr];
        end
    end
    
    always_ff @ (posedge clk, negedge rst, posedge ebreak_clear) begin
        if (~rst) begin
            ebreak_state <= 1'b0;
        end
        else if (ebreak_clear) begin
            ebreak_state <= 1'b0;
        end
        else if (ebreak_set) begin
            ebreak_state <= 1'b1;
        end
        else begin
            ebreak_state <= ebreak_state;
        end
    end
endmodule
