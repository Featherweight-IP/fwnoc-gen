
/****************************************************************************
 * fwnoc_l2_dbg_bfm.v
 ****************************************************************************/
 
`ifndef NOC_DATA_WIDTH
`define NOC_DATA_WIDTH 64
`endif

  
/**
 * Module: fwnoc_l2_dbg_bfm
 * 
 * TODO: Add module documentation
 */
module fwnoc_l2_dbg_bfm(
		input						clk,
		input						rst_n,
		input						noc1_valid_in,
		input[`NOC_DATA_WIDTH-1:0]	noc1_data_in,
		input						noc1_ready_in,
		
		input						noc2_valid_out,
		input[`NOC_DATA_WIDTH-1:0]	noc2_data_out,
		input						noc2_ready_out,
		
		input						noc3_valid_in,
		input[`NOC_DATA_WIDTH-1:0]	noc3_data_in,
		input						noc3_ready_in		
		);

	reg have_reset = 0;
	reg in_reset = 0;
	
	always @(posedge clk) begin
		if (!rst_n) begin
			in_reset <= 1;
		end else begin
			if (in_reset) begin
				in_reset <= 0;
				have_reset <= 1;
			end
		end
	end

	always @(posedge clk) begin
		if (have_reset) begin
			if (noc1_valid_in && noc1_ready_in) begin
				_recv_data(1, noc1_data_in);
			end
			if (noc2_valid_out && noc2_ready_out) begin
				_recv_data(2, noc2_data_out);
			end
			if (noc3_valid_in && noc3_ready_in) begin
				_recv_data(3, noc3_data_in);
			end
		end
	end
		
	task init;
		$display("init");
	endtask
	
    // Auto-generated code to implement the BFM API
`ifdef PYBFMS_GEN
${pybfms_api_impl}
`endif

endmodule


