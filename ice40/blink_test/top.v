
module switch(  input CLK,
                output LED,
                output LED2,
                output LED3
                );
      
   reg [25:0] counter;

   // assign LED = ~counter[2];
   
   // assign LED = 1;
   // assign LED2 = 1;
   // assign LED3 = 0;

   assign LED = 0;
   assign LED2 = 0;
   assign LED3 = 1;

   initial begin
      counter = 0;
   end

   always @(posedge CLK)
   begin
      counter <= counter + 1;
   end


endmodule
