
//----------------------------------------------------------------------------
//                                                                          --
//                         Module Declaration                               --
//                                                                          --
//----------------------------------------------------------------------------
module top(hw_clk,io0);
	output wire io0;
	input hw_clk;

	reg [16:0] counter=0;

	reg [7:0] page_param [20550:0];
	reg [7:0] io_rd_data_out = 14;
	reg [7:0] data_out;

	reg [16:0] page_idx;

	assign io0=data_out[0]; // Make sure it doesn't get optimized away
	
always @(posedge hw_clk) begin

	counter<=counter+1;
	if(counter==0)
	begin
		page_idx<=19993;
	end
	else if(counter==1)
	begin
		page_param[page_idx]	<= io_rd_data_out[7:0];
	end
        else if (counter==2)
	begin
		data_out <= page_param[page_idx];
	end

end

endmodule

