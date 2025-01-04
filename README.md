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

# List of Example-projects:

1. **[Project Blink LED](blink_led/)**  
    It blinks the led in different colours. It is using an internal oscillator as a time source for blinking.

2. **[blink_hw](blink_hw/)**   
   It blinks the led in different colours by using the crystal hardware osscilator on the board. 

3. **[led_red](led_red/)**  
    Constantly lights up the RGB led with red light.

4. **[led_blue](led_blue/)**  
    Constantly lights up the RGB led with blue light.

5. **[led_green](led_green/)**  
    Constantly lights up the RGB led with green light.

6. **[led_white](led_white/)**  
    Constantly lights up the RGB led with white light.

7. **[uart_tx](uart_tx/)**   
    It sends the 'D' characters repeatedly from the FPGA through USB to the computer. 

8. **[uart_tx_sense](uart_tx_sense/)**  
    It sends the 'D' characters repeatedly from the FPGA through USB to the computer, and lights up the LED whenever a character is received from the PC

9. **[uart_loopback](uart_loopback/)**  
   It just receives the signal directly from the PC to the FPGA. So whatever character we type on the keyboard appears as the output.

10. **[simpleuart](simpleuart/)**   
    Its a controller that accepts commands from the PC keyboard. It parses the input and plays with the output.

11. **[nandcontroller](nandcontroller/)**   
    Its a controller to interface with NAND Flash memory, for USB pen drives.
    
12. **[RISCV](RISCV/)**   
     Its a CPU based on RISC-V instruction set architecture.

    
Happy hacking! 🚀

