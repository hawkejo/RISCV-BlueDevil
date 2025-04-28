# RISCV-BlueDevil
### RV64I 64-bit integer instruction set

This is an implementation of the RISC-V processor architecture for the CCSU Capstone class. The intent is to create a design that will be scalable and viable for use in production. This branch implements the 64-bit RV64I integer instruction set in a non-pipelined manner.

This processor is intended to be a real-time processor where each instruction has a predictible time to completion and should be used for applications requiring that predictibility. Additionally, while the design contained in this repository is intended to be deployed on a Xilinx Artix-7 FPGA, the processor core can be utilized anywhere with just a change in the top module to provide the requisite I/O interface.

The project was done in the most recent version of Xilinx Vivado, which at the time of creation of this repository is at version 2024.2.2. To use Vivado with Github, reference the following documents provided by AMD (Xilinx) [here](https://adaptivesupport.amd.com/s/article/Revision-Control-with-a-Vivado-Project?language=en_US). While Vivado does not support git commands natively, the repository can be cloned directly. If running synthesis, make sure the setting to allow incremental synthesis is disabled for the first run.

While the 64-bit architecture is verified via testbench, the 32-bit architecture in previous branches is not verified directly. However, the logic behind the instructions (barring 32-bit specific instructions in the 64-bit architecture specifically) is identical and accuracy can be implied. The 32-bit branches are _**not**_ maintained.
