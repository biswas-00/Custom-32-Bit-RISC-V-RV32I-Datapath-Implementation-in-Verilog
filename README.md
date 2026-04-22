## 📌 Project Overview
This repository contains the complete RTL source code, Gowin EDA project files, and physical constraint mappings for a custom 32-bit RISC-V microprocessor. This processor has been successfully synthesized, routed, and physically verified on a **Gowin GW5A-25 FPGA** (Tang Primer 25K). 

The design implements the base integer instruction set (RV32I) using a classic 5-stage pipeline architecture. Special focus was given to physical hardware deployment, including managing JTAG dual-purpose pin multiplexing and bypassing aggressive EDA synthesizer logic-sweeping optimizations through hardcoded silicon deployment.

## ✨ Key Technical Features
* **RV32I Instruction Set:** Implements core computational, memory-access, and control-flow instructions.
* **5-Stage Datapath:** Modularized Verilog implementation separating Fetch, Decode, Execute, Memory, and Writeback stages.
* **Silicon Verification:** Internal CPU databuses are tapped and routed to physical PMOD GPIOs, allowing real-time visual verification of ALU arithmetic and memory states via custom LED latch circuitry (see `/docs` for physical breadboard verification).
* **EDA Optimization Management:** Overcame Gowin EDA memory-inference bugs by hardcoding machine-level assembly directly into the Verilog ROM, preventing the synthesizer from sweeping the Control Unit and ALU.
* **JTAG/IO Multiplexing:** Successfully reconfigured standard JTAG programming pins for regular LVCMOS33 I/O usage post-SRAM programming.

## 📂 Repository Structure

```text
├── docs/           # Physical hardware verification (Breadboard LED output photos)
├── fpga/           # Physical deployment files
│   ├── project.gprj # Gowin FPGA Designer Project File
│   └── risc-v.cst  # Physical pin constraints mapping Verilog to Gowin GW5A pins
├── src/            # Core RTL modules (Verilog)
│   ├── alu.v
│   ├── control_unit.v
│   ├── datapath_stages/ # Fetch, Decode, Execute, Memory, Writeback modules
│   └── riscv_core.v     # Top-level wrapper module
└── .gitignore      # Excludes generated synthesis logs and simulation binaries
