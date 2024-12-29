`include "simpleuart.v"
`include "nand_master.sv"

//----------------------------------------------------------------------------
//                                                                          --
//                         Module Declaration                               --
//                                                                          --
//----------------------------------------------------------------------------
module top (
  // outputs
  output wire led_red  , // Red
  output wire led_blue , // Blue
  output wire led_green , // Green
  output wire uarttx , // UART Transmission pin
  input wire uartrx , // UART Receiving pin
  input wire hw_clk,  // Hardware Oscillator with 12 MHz, not the internal oscillator
  
  /* NAND Flash Interface */
  output nand_cle,
  output nand_ale,
  output nand_nwe,
  output nand_nwp,
  output nand_nce,
  output nand_nre,
  input wire nand_rnb,
  inout io0,
  inout io1,
  inout io2,
  inout io3,
  inout io4,
  inout io5,
  inout io6,
  inout io7
);



    SB_IO_OD #(
		.PIN_TYPE(6'b010001),
		.NEG_TRIGGER(1'b0)
	) IO_PIN_I (
		.PACKAGEPIN(38),
		.LATCHINPUTVALUE(),
		.CLOCKENABLE(),
		.INPUTCLK(),
		.OUTPUTCLK(),
		.OUTPUTENABLE(),
		.DOUT0(io0),
		.DOUT1(),
		.DIN0(),
		.DIN1()
	);


  // NAND Flash Interface
  wire [15:0]nand_data;
  assign io0 =nand_data[0];
  assign io1 =nand_data[1];
  assign io2 =nand_data[2];
  assign io3 =nand_data[3];
  assign io4 =nand_data[4];
  assign io5 =nand_data[5];
  assign io6 =nand_data[6];
  assign io7 =nand_data[7];
  reg [5:0] cmd_in;
  reg [7:0] nand_data_out;
  reg [7:0] nand_data_in;
  reg nand_busy;
  reg nand_activate;
  nand_master NM (
		.clk      (hw_clk), // !!! TODO: We have to check the clock and it's speed
		.nand_cle (nand_cle),
		.nand_ale (nand_ale),
		.nand_nwe (nand_nwe),
		.nand_nwp (nand_nwp),
		.nand_nce (nand_nce),
		.nand_nre (nand_nre),
		.nand_rnb (~nand_rnb),
		.nand_data(nand_data),
		.nreset   (resetn),
		.data_out (nand_data_out),
		.data_in  (nand_data_in),
		.busy     (nand_busy),
		.activate (nand_activate),
		.cmd_in   (cmd_in),
		.enable   (1'b0)
	);


  wire        int_osc            ; // Internal oscillator, configurable speed
  reg  [27:0] frequency_counter_i;
  
/* 9600 Hz clock generation (from 12 MHz) */
    reg clk_9600 = 0;
    reg [31:0] cntr_9600 = 32'b0;
    parameter period_9600 = 625;

  /* Interface to the UART module */
  reg        reg_dat_we;
  reg        reg_dat_re;
  reg [31:0] reg_dat_di;
  wire [31:0] reg_dat_do;
  wire        reg_dat_wait;

  /* Switches for switching the colors of the RGB LED */
  reg rgb_red = 1;
  reg rgb_blue = 0;
  reg rgb_green = 0;

  /* Reset Logic needed for the UART */
  reg [4:0] reset_cnt = 0;
  wire resetn = &reset_cnt; // negated reset, 0 means we are in reset, 1 means we are in normal operation
  always @(posedge hw_clk) begin
    reset_cnt <= reset_cnt + !resetn; // It increases the reset counter until all bits are set
  end


  // We have to set the DEFAULT_DIV to the correct divider for the baudrate:
  // 1250 -> 9600 Baud
  simpleuart #(.DEFAULT_DIV(1250)) DanUART 
  (
    .clk (hw_clk), 
    .resetn(resetn),
    .ser_tx(uarttx), 
    .ser_rx(uartrx), 
    .reg_dat_we(reg_dat_we), 
    .reg_dat_re(reg_dat_re), 
    .reg_dat_di(reg_dat_di), 
    .reg_dat_do(reg_dat_do), 
    .reg_dat_wait(reg_dat_wait),
    .reg_div_we(4'b0), // We don't want to change the default baudrate during operation, so we keep the write-enable for it low
    .reg_div_di(0)
  );

  reg [3:0] mystate = 0; // State-Machine for UART command handling
  reg prevbit = 0;

  always @(negedge reg_dat_do[8]) begin // When we receive a character the dat_do should go from -1 to a value between 0-255, so the 8th bit should go from 1 to 0
              //rgb_red <= 0; This would be a conflicting driver!
              //rgb_blue <= 1;
              //rgb_green <= 1;
	      //reg_dat_di <= reg_dat_di+1;

  end
  reg [31:0] wedelay = 0;
  reg [31:0] actdelay = 0;

//----------------------------------------------------------------------------
//                                                                          --
//                       Counter                                            --
//                                                                          --
//----------------------------------------------------------------------------
  always @(posedge hw_clk) begin

    if(wedelay) begin
      wedelay <= wedelay-1;
      if(!wedelay) begin
	reg_dat_we <= 0;
      end
    end	    
    if(actdelay) begin
      actdelay <= actdelay-1;
      if(!actdelay) begin
	nand_activate <= 0;
      end
    end	    

    case(mystate)
      0: begin
        reg_dat_we <=0;
        reg_dat_re <=0;
        reg_dat_di <=0;
        rgb_red <= 0;
        rgb_blue <= 0;
        rgb_green <= 1;
        if(resetn) mystate <= 1;
        end
      1: begin
	reg_dat_di <="P";
	reg_dat_we<=1;
        mystate<=2;
        end
      2: begin
         //if(reg_dat_do[8]== && prevbit==1) begin // We received a Byte
          case (reg_dat_do)
            -1: begin
		end
            "0": begin  // black
              rgb_red <= 0;
              rgb_blue <= 0;
              rgb_green <= 0;
	      reg_dat_we <= 0;
              end
            "1": begin // red
              rgb_red <= 1;
              rgb_blue <= 0;
              rgb_green <= 0;
	      reg_dat_we <= 1;
              end
            "2": begin // red ?!?
              rgb_red <= 1;
              rgb_blue <= 0;
              rgb_green <= 1;
              end
            "3": begin // green
              rgb_red <= 0;
              rgb_blue <= 0;
              rgb_green <= 1;
              end
            "4": begin // red ?!?
              rgb_red <= 1;
              rgb_blue <= 1;
              rgb_green <= 1;
              end
            "5": begin // blue
              rgb_red <= 0;
              rgb_blue <= 1;
              rgb_green <= 0;
              end
            "6": begin // green
              rgb_red <= 0;
              rgb_blue <= 1;
              rgb_green <= 1;
              end
            "7": begin // 
              rgb_red <= 1;
              rgb_blue <= 1;
              rgb_green <= 0;
              end
            "R": begin // This reads a resulting nand data and sends one byte
              reg_dat_di <= nand_data_out;
	      reg_dat_we <= 1;
	      wedelay <= 1000;
              end
	    "S": begin // This reads a byte from UART and sends it to the NAND controller
	      mystate<=4;
	      end
            default: begin
              cmd_in <= reg_dat_do; // DO a NAND command
              nand_activate <= 1; 
	      actdelay <= 2;
              reg_dat_di <= reg_dat_do+1; // We choose what character we want to write
              reg_dat_we <= 1; // We start writing
	      wedelay <= 1000;
	      //mystate<= 3;
	    end
          endcase
         //end
         prevbit <= reg_dat_do[8];
	end
   	3: begin
  	  reg_dat_we <= 0; // In the next state we switch the writing off again and start reading again
	  mystate<=1;
	end
	4: begin
          if (reg_dat_do!=-1) begin
	    nand_data_in <= reg_dat_do[7:0];
	    mystate<=2;
	  end
	end
      default: mystate<=0;
    endcase
  end

//----------------------------------------------------------------------------
//                                                                          --
//                       Internal Oscillator                                --
//                                                                          --
//----------------------------------------------------------------------------
  SB_HFOSC #(.CLKHF_DIV ("0b10")) u_SB_HFOSC ( .CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));


//----------------------------------------------------------------------------
//                                                                          --
//                       Instantiate RGB primitive                          --
//                                                                          --
//----------------------------------------------------------------------------
  SB_RGBA_DRV RGB_DRIVER (
    .RGBLEDEN(1'b1      ),
    .RGB0PWM (rgb_red   ),
    .RGB1PWM (rgb_green ),
    .RGB2PWM (rgb_blue  ),
    .CURREN  (1'b1      ),
    .RGB0    (led_red   ), //Actual Hardware connection
    .RGB1    (led_green ),
    .RGB2    (led_blue  )
  );
  defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";

endmodule
