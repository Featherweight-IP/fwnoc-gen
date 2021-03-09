/****************************************************************************
 * l2_dbg.v
 ****************************************************************************/
`include "define.h"

  
/**
 * Module: l2_dbg
 * 
 * TODO: Add module documentation
 */
module l2_dbg(
		input				clk,
		input				rst_n,
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
	
`ifdef L2_DBG_MODULE
		`L2_DBG_MODULE u_dbg(
			.clk(clk),
			.rst_n(rst_n),
			.noc1_valid_in(noc1_valid_in),
			.noc1_data_in(noc1_data_in),
			.noc1_ready_in(noc1_ready_in),
			.noc2_valid_out(noc2_valid_out),
			.noc2_data_out(noc2_data_out),
			.noc2_ready_out(noc2_ready_out),
			.noc3_valid_in(noc3_valid_in),
			.noc3_data_in(noc3_data_in),
			.noc3_ready_in(noc3_ready_in)
		);
`endif


endmodule


