# Define project-specific variables
PROJECTNAME=SOC
BOARD=squadronfm
BOARD_FREQ=10
CPU_FREQ=10
FPGA_VARIANT=lp1k
FPGA_PACKAGE=cm36
VERILOGS= riscv.v

#Uart Var	
PICO_DEVICE=/dev/ttyUSB0   # replace by the terminal used by your device
BAUDS=1000000


build:
	yosys -q -DICE_SUGAR -DNEGATIVE_RESET -DBOARD_FREQ=$(BOARD_FREQ) -p "synth_ice40 -relut -top $(PROJECTNAME) -json $(PROJECTNAME).json" $(VERILOGS)
	nextpnr-ice40 --force --json $(PROJECTNAME).json --pcf $(BOARD).pcf --asc $(PROJECTNAME).asc --freq $(BOARD_FREQ) --$(FPGA_VARIANT) --package $(FPGA_PACKAGE) --pcf-allow-unconstrained
	icetime -p $(BOARD).pcf -P $(FPGA_PACKAGE) -r $(PROJECTNAME).timings -d $(FPGA_VARIANT) -t $(PROJECTNAME).asc
	icepack $(PROJECTNAME).asc $(PROJECTNAME).bin

flash_external:
	iceprog -S $(PROJECTNAME).bin

clean:
	rm -rf $(filename).blif $(filename).asc $(filename).bin $(filename).json

terminal:
	sudo picocom -b $(BAUDS) $(PICO_DEVICE) --imap lfcrlf,crcrlf --omap delbs,crlf --send-cmd "ascii-xfr -s -l 30 -n"