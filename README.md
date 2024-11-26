# VSDSquadron_FM

This repository contains projects for VSDSquadron_FM, utilizing open-source FPGA tools for development.

## Toolchain Requirements

Ensure the following tools are installed and configured:

1. **[Project IceStorm](https://github.com/YosysHQ/icestorm)**  
   Toolchain for Lattice iCE40 FPGAs. Install this first.

2. **[Yosys](https://github.com/YosysHQ/yosys)**  
   Open-source synthesis tool.

3. **[nextpnr](https://github.com/YosysHQ/nextpnr)**  
   Open-source Place & Route (P&R) tool.

## Running a Project

Follow these steps to build and flash a project:

1. Navigate to the specific project folder:
   ```bash
   cd <project-folder>
   ```

2. Build the binaries:
   ```bash
   make build
   ```

3. Flash the code to external SRAM:
   ```bash
   make flash
   ```

For cleanup, use:
```bash
make clean
```

---

Happy hacking! 🚀