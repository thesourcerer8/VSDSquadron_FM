`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps


module SB_HFOSC #(parameter integer CLKHF_DIV=1) (
  input CLKHFPU,
  input CLKHFEN,
  output reg CLKHF
)
;
always
begin
	if(CLKHFEN==1)
	begin
          CLKHF <= 1'b1;
          #1ns;
          CLKHF <= 1'b0;
          #1ns;
        end 
end
endmodule

	

module SB_RGBA_DRV #(parameter integer RGB0_CURRENT=1, parameter integer RGB1_CURRENT=1,parameter integer RGB2_CURRENT=1) (
    input RGBLEDEN,
    input RGB0PWM,
    input RGB1PWM,
    input RGB2PWM,
    input CURREN,
    output RGB0, //Actual Hardware connection
    output RGB1,
    output RGB2
);
assign RGB0=RGB0PWM;
assign RGB1=RGB1PWM;
assign RGB2=RGB2PWM;
endmodule



`include "rgb_blink.v"

module testbench ();
reg clk;
reg red;
reg blue;
reg green;

always
begin
        clk = 1'b1;
        #1.25ns;
        clk = 1'b0;
        #1.25ns;
end

rgb_blink mytop(.led_red(red),.led_blue(blue),.led_green(green));

initial
begin
        $dumpfile("testbench.fst");
        $dumpvars(0,testbench);
        $timeformat(-9, 0, "ns", 8);

        $display ("T=%0t Start of simulation", $realtime);

        #100100100ns

        $display ("T=%0t End of simulation", $realtime);
        $finish;

end


endmodule
