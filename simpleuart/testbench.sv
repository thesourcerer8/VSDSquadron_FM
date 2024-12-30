`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps


module SB_HFOSC #(parameter integer CLKHF_DIV=1) (
  input CLKHFPU,
  input CLKHFEN,
  output CLKHF
)
;
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

endmodule



`include "top.v"

module testbench ();
reg clk;
reg uartrx;

always
begin
        clk = 1'b1;
        #1.25ns;
        clk = 1'b0;
        #1.25ns;
end

top mytop(.hw_clk(clk),.uartrx(uartrx));

initial
begin
	uartrx<=0;
        $dumpfile("testbench.vcd");
        $dumpvars(0,testbench);
        $timeformat(-9, 0, "ns", 8);

        $display ("T=%0t Start of simulation", $realtime);

	#260ns
	uartrx<=1;
	#20ns
	//uartrx<=0;

        #102000ns

        $display ("T=%0t End of simulation", $realtime);
        $finish;

end


endmodule
