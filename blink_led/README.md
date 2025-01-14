# What it does

The blink led is used to blink the led in different colours, by blinking one colour at a time.
The order of the led colour blinking is white, red, green, blue, cyan, yellow, purple and black. Each colour blinks for 0.7 seconds.
It could be used to factory test the LEDs, whether they are working properly or not.

# Simulation

To run a simulation of the project you need to have iverilog and gtkwave installed, to install them you can use the following command:
```sudo apt install iverilog gtkwave```

To run the simulation you can use the test target in the makefile:
```make test```
This command compiles the ![testbench.sv](testbench.sv) from SystemVerilog, then runs the simulation. The simulation writes the waveform to the file waveform.fst which is then opened in gtkwave for viewing:
![waveform](waveform.png)

