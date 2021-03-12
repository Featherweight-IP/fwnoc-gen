/****************************************************************************
 * bfm_driven_tb.sv
 ****************************************************************************/
`ifdef NEED_TIMESCALE
`timescale 1ns/1ns
`endif

`include "l2.h"
`include "define.h"
`include "iop.h"
  
/**
 * Module: bfm_driven_tb
 * 
 * TODO: Add module documentation
 */
module bfm_driven_tb(input clock);
	
`ifdef HAVE_HDL_CLOCKGEN
	reg clock_r = 0;
	initial begin
		forever begin
`ifdef NEED_TIMESCALE
			#10;
`else
			#10ns;
`endif
			clock_r <= ~clock_r;
		end
	end
	assign clock = clock_r;
`endif
	
`ifdef IVERILOG
	`include "iverilog_control.svh"
`endif
	
	reg 		reset /* verilator public */= 0;
	reg[7:0] 	reset_cnt = 0;
	
	always @(posedge clock) begin
		case (reset_cnt)
			2: begin
				reset <= 1;
				reset_cnt <= reset_cnt + 1;
			end
			100: begin
				reset <= 0;
			end
			default: reset_cnt <= reset_cnt + 1;
		endcase
	end
	
	wire                                       processor_offchip_noc1_valid;
	wire [`NOC_DATA_WIDTH-1:0]                 processor_offchip_noc1_data;
	wire                                       processor_offchip_noc1_yummy;
	wire                                       processor_offchip_noc2_valid;
	wire [`NOC_DATA_WIDTH-1:0]                 processor_offchip_noc2_data;
	wire                                       processor_offchip_noc2_yummy;
	wire                                       processor_offchip_noc3_valid;
	wire [`NOC_DATA_WIDTH-1:0]                 processor_offchip_noc3_data;
	wire                                       processor_offchip_noc3_yummy;

	wire                                       offchip_processor_noc1_valid;
	wire  [`NOC_DATA_WIDTH-1:0]                offchip_processor_noc1_data;
	wire                                       offchip_processor_noc1_yummy;
	wire                                       offchip_processor_noc2_valid;
	wire  [`NOC_DATA_WIDTH-1:0]                offchip_processor_noc2_data;
	wire                                       offchip_processor_noc2_yummy;
	wire                                       offchip_processor_noc3_valid;
	wire  [`NOC_DATA_WIDTH-1:0]                offchip_processor_noc3_data;
	wire                                       offchip_processor_noc3_yummy;	

	chip u_dut(
		.slew(1'b1),
		.impsel1(1'b1),
		.impsel2(1'b1),
		.pll_rst_n(1'b1),
		.core_ref_clk(clock),
		.io_clk(clock),
		.rst_n(~reset),
		.clk_en(1'b1),
		.pll_bypass(1'b1), // More or less copy FPGA settings
		.pll_rangea(5'b0),
		.clk_mux_sel(2'b0),
		.jtag_clk(1'b0),
		.jtag_rst_l(1'b1),
		.jtag_modesel(1'b1),
		.jtag_datain(1'b0),
		.async_mux(1'b1),
		.oram_on(1'b0),
		.oram_traffic_gen(1'b0),
		.oram_dummy_gen(1'b0),

		.processor_offchip_noc1_valid(             processor_offchip_noc1_valid),
		.processor_offchip_noc1_data(              processor_offchip_noc1_data),
		.processor_offchip_noc1_yummy(             processor_offchip_noc1_yummy),
		.processor_offchip_noc2_valid(             processor_offchip_noc2_valid),
		.processor_offchip_noc2_data(              processor_offchip_noc2_data),
		.processor_offchip_noc2_yummy(             processor_offchip_noc2_yummy),
		.processor_offchip_noc3_valid(             processor_offchip_noc3_valid),
		.processor_offchip_noc3_data(              processor_offchip_noc3_data),
		.processor_offchip_noc3_yummy(             processor_offchip_noc3_yummy),

		.offchip_processor_noc1_valid(             offchip_processor_noc1_valid),
		.offchip_processor_noc1_data(              offchip_processor_noc1_data),
		.offchip_processor_noc1_yummy(             offchip_processor_noc1_yummy),
		.offchip_processor_noc2_valid(             offchip_processor_noc2_valid),
		.offchip_processor_noc2_data(              offchip_processor_noc2_data),
		.offchip_processor_noc2_yummy(             offchip_processor_noc2_yummy),
		.offchip_processor_noc3_valid(             offchip_processor_noc3_valid),
		.offchip_processor_noc3_data(              offchip_processor_noc3_data),
		.offchip_processor_noc3_yummy(             offchip_processor_noc3_yummy)
		);
	
	fwnoc_l2_dbg_bfm u_dbg_procoff (
			.clk(clock),
			.rst_n(~reset),
			.noc1_valid_in(processor_offchip_noc1_valid),
			.noc1_data_in(processor_offchip_noc1_data),
			.noc1_ready_in(1'b1),
			.noc2_valid_out(processor_offchip_noc2_valid),
			.noc2_data_out(processor_offchip_noc2_data),
			.noc2_ready_out(1'b1),
			.noc3_valid_in(processor_offchip_noc3_valid),
			.noc3_data_in(processor_offchip_noc3_data),
			.noc3_ready_in(1'b1)
		);
	
	fwnoc_l2_dbg_bfm u_dbg_offproc (
			.clk(clock),
			.rst_n(~reset),
			.noc1_valid_in(offchip_processor_noc1_valid),
			.noc1_data_in(offchip_processor_noc1_data),
			.noc1_ready_in(1'b1),
			.noc2_valid_out(offchip_processor_noc2_valid),
			.noc2_data_out(offchip_processor_noc2_data),
			.noc2_ready_out(1'b1),
			.noc3_valid_in(offchip_processor_noc3_valid),
			.noc3_data_in(offchip_processor_noc3_data),
			.noc3_ready_in(1'b1)
		);
	

	fwnoc_memtarget_bfm u_mem(
			.clock(clock),
			.reset(reset),
		
			// Messages from chip -> bridge
			.c2b_noc1_valid(processor_offchip_noc1_valid),
			.c2b_noc1_data(processor_offchip_noc1_data),
			.c2b_noc1_yummy(processor_offchip_noc1_yummy),
			.c2b_noc2_valid(processor_offchip_noc2_valid),
			.c2b_noc2_data(processor_offchip_noc2_data),
			.c2b_noc2_yummy(processor_offchip_noc2_yummy),
			.c2b_noc3_valid(processor_offchip_noc3_valid),
			.c2b_noc3_data(processor_offchip_noc3_data),
			.c2b_noc3_yummy(processor_offchip_noc3_yummy),
			
			// Messages from bridge -> chip
			.b2c_noc1_valid(offchip_processor_noc1_valid),
			.b2c_noc1_data(offchip_processor_noc1_data),
			.b2c_noc1_yummy(offchip_processor_noc1_yummy),
			.b2c_noc2_valid(offchip_processor_noc2_valid),
			.b2c_noc2_data(offchip_processor_noc2_data),
			.b2c_noc2_yummy(offchip_processor_noc2_yummy),
			.b2c_noc3_valid(offchip_processor_noc3_valid),
			.b2c_noc3_data(offchip_processor_noc3_data),
			.b2c_noc3_yummy(offchip_processor_noc3_yummy)
		);


endmodule


