# RISCV-BlueDevil

This is an implementation of the RISC-V processor architecture for the CCSU Capstone class. The intent is to create a design that will be scalable and viable for use in production.

This processor is intended to be a real-time processor where each instruction has a predictible time to completion and should be used for applications requiring that predictibility. Additionally, while the design contained in this repository is intended to be deployed on a Xilinx Artix-7 FPGA, the processor core can be utilized anywhere with just a change in the top module to provide the requisite I/O interface.

The project was done in the most recent version of Xilinx Vivado, which at the time of creation of this repository is at version 2024.1.2. To use Vivado with Github, the following open source scripts created by Ricardo Barbedo are required and can either be found [here](https://github.com/barbedo/vivado-git) or [here](https://github.com/hawkejo/vivado-git).
