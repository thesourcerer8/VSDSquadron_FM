
//----------------------------------------------------------------------------
//                                                                          --
//                         Module Declaration                               --
//                                                                          --
//----------------------------------------------------------------------------
module top(hw_clk,io0);
	output wire io0;
	input hw_clk;

	reg [16:0] counter=0;

	reg [7:0] page_param [255:0] /* synthesis syn_ram_style = "block" */ /* synthesis syn_ramstyle = "no_rw_check" */;
	initial page_param[0] <= 255;  // I was told that yosys wants this,
	//but it doesnt seem to work
	reg [7:0] io_rd_data_out = 14;
	reg [7:0] data_out;

	reg [7:0] page_idx;

	assign io0=data_out[0]; // Make sure it doesn't get optimized away
	
always @(posedge hw_clk) begin

	counter<=counter+1;
	if(counter==0)
	begin
    		page_idx<=3;
		data_out<=0;
	end
	else if(counter==1)
	begin
		page_param[page_idx]	<= io_rd_data_out[7:0];
	end
        else if (counter==2)
	begin
		data_out <= page_param[page_idx];
		io_rd_data_out <= io_rd_data_out +1;
	end
	else if (counter==3)
	begin
		page_idx<=page_idx+1;
	end
	else if (counter==4)
	begin
		page_param[page_idx]	<= io_rd_data_out[7:0];
	end
        else if (counter==5)
	begin
		data_out <= page_param[page_idx];
	end

end

endmodule

