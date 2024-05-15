filename = top
pcf_file = ./io.pcf

build:
	yosys -p "synth_ice40 -json $(filename).json -blif $(filename).blif" $(filename).v
	nextpnr-ice40 --lp1k --package cm36 --json $(filename).json --pcf $(pcf_file) --asc $(filename).asc --freq 48
	icepack $(filename).asc $(filename).bin

prog_flash:
	iceprog -S $(filename).bin


clean:
	rm -rf $(filename).blif $(filename).asc $(filename).bin $(filename).json
