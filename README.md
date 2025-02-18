# RISCV-BlueDevil
### RV32I 32-bit integer instruction set

This is an implementation of the RISC-V processor architecture for the CCSU Capstone class. The intent is to create a design that will be scalable and viable for use in production. This branch implements the 32-bit RV32I integer instruction set in a non-pipelined manner.

This processor is intended to be a real-time processor where each instruction has a predictible time to completion and should be used for applications requiring that predictibility. Additionally, while the design contained in this repository is intended to be deployed on a Xilinx Artix-7 FPGA, the processor core can be utilized anywhere with just a change in the top module to provide the requisite I/O interface.

The project was done in the most recent version of Xilinx Vivado, which at the time of creation of this repository is at version 2024.2.1. To use Vivado with Github, reference the following documents provided by AMD (Xilinx) [here](https://adaptivesupport.amd.com/s/article/Revision-Control-with-a-Vivado-Project?language=en_US).
