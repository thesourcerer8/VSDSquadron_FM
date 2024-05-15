
module switch(  input CLK,
                output LED,
                output LED2
                );
      
   reg [25:0] counter;

  //  assign LED = 1;
   assign LED = ~counter[23];
   assign LED2 = ~counter[4];

   //assign LED = ~counter[21];

   initial begin
      counter = 0;
   end

   always @(posedge CLK)
   begin
      counter <= counter + 1;
   end


endmodule
