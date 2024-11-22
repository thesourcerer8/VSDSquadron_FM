rgb_blink.bin: rgb_blink.asc
	icepack rgb_blink.asc rgb_blink.bin

rgb_blink.asc: rgb_blink.json ./upduino.pcf
	nextpnr-ice40 --up5k --package sg48 --json rgb_blink.json --pcf ./upduino.pcf --asc rgb_blink.asc   # run place and route

rgb_blink.json: rgb_blink.v
	yosys -q -p "synth_ice40 -json rgb_blink.json" rgb_blink.v

.PHONY: flash
flash:
	iceprog rgb_blink.bin

.PHONY: clean
clean:
	$(RM) -f rgb_blink.json rgb_blink.asc rgb_blink.bin
