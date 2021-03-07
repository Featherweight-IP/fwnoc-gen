/****************************************************************************
 * tile_core_if.v
 ****************************************************************************/

`include "define.h"
`include "dmbr_define.v"
`include "l15.h"
  
/**
 * Module: tile_core_if
 * 
 * TODO: Add module documentation
 */
module tile_core_if #(
		parameter CHIPID   = 0,
		parameter COREID_X = 0,
		parameter COREID_Y = 0
		) (
		input                           clk,
		input                           rst_n,

		input                           l15_transducer_ack,
		input                           l15_transducer_header_ack,

		/**
		 * Request channel (Core -> L1.5)
		 */
		output [4:0]                    transducer_l15_rqtype,
		output [`L15_AMO_OP_WIDTH-1:0]  transducer_l15_amo_op,
		output [2:0]                    transducer_l15_size,
		output                          transducer_l15_val,
		output [`PHY_ADDR_WIDTH-1:0]    transducer_l15_address,
		output [63:0]                   transducer_l15_data,
		output                          transducer_l15_nc,


		// outputs pico doesn't use                    
		output [0:0]                    transducer_l15_threadid,
		output                          transducer_l15_prefetch,
		output                          transducer_l15_invalidate_cacheline,
		output                          transducer_l15_blockstore,
		output                          transducer_l15_blockinitstore,
		output [1:0]                    transducer_l15_l1rplway,
		output [63:0]                   transducer_l15_data_next_entry,
		output [32:0]                   transducer_l15_csm_data,

		/**
		 * Response channel (L1.5 -> Core)
		 */
		input                           l15_transducer_val,
		input [3:0]                     l15_transducer_returntype,
    
		input [63:0]                    l15_transducer_data_0,
		input [63:0]                    l15_transducer_data_1,
   
		output                          transducer_l15_req_ack
		);

	///////////////////
	// PicoRV32 Core //
	///////////////////
	wire         pico_transducer_mem_valid;
	wire         transducer_pico_mem_ready;
	wire [31:0]  pico_transducer_mem_addr;
	wire [31:0]  pico_transducer_mem_wdata;
	wire [ 3:0]  pico_transducer_mem_wstrb;
	wire [`L15_AMO_OP_WIDTH-1:0] pico_transducer_mem_amo_op;
	wire [31:0]  transducer_pico_mem_rdata;
	wire         pico_int;

//	picorv32 core(
//			.clk        (clk_gated),
//			.reset_l    (rst_n_f),
//			.trap       (),
//			.mem_valid  (pico_transducer_mem_valid),
//			.mem_instr  (),
//			.mem_ready  (transducer_pico_mem_ready),
//			.mem_addr   (pico_transducer_mem_addr),
//			.mem_wdata  (pico_transducer_mem_wdata),
//			.mem_wstrb  (pico_transducer_mem_wstrb),
//			.mem_amo_op (pico_transducer_mem_amo_op),
//			.mem_rdata  (transducer_pico_mem_rdata),
//
//			.pico_int   (pico_int)
//		);

//	pico_reset pico_reset(
//			.gclk(clk_gated),
//			.rst_n(rst_n_f),
//			.spc_grst_l(spc_grst_l)
//		);
	
	wire we;
	
	initial begin
		$display("tile_core: %m");
	end

	rv_addr_line_en_initiator_bfm #(
			.ADR_WIDTH(32),
			.DAT_WIDTH(32)
			) u_bfm (
			.clock(							clk),
			.reset(							~rst_n),
			.adr(                           pico_transducer_mem_addr),
			.dat_w(                         pico_transducer_mem_wdata),
			.dat_r(                         transducer_pico_mem_rdata),
			.we(                            we),
			.valid(							pico_transducer_mem_valid),
			.ready(                         transducer_pico_mem_ready)
			);
	
	assign pico_transducer_mem_wstrb = (we)?4'hF:4'h0;
	assign pico_transducer_mem_amo_op = 0;

	pico_l15_transducer pico_l15_transducer(
			.clk                                (clk),
			.rst_n                              (rst_n),

			.pico_transducer_mem_valid          (pico_transducer_mem_valid),
			.pico_transducer_mem_addr           (pico_transducer_mem_addr),
			.pico_transducer_mem_wstrb          (pico_transducer_mem_wstrb),
			.pico_transducer_mem_wdata          (pico_transducer_mem_wdata),
			.pico_transducer_mem_amo_op         (pico_transducer_mem_amo_op),
			.l15_transducer_ack                 (l15_transducer_ack),
			.l15_transducer_header_ack          (l15_transducer_header_ack),

			.transducer_l15_rqtype              (transducer_l15_rqtype),
			.transducer_l15_amo_op              (transducer_l15_amo_op),
			.transducer_l15_size                (transducer_l15_size),
			.transducer_l15_val                 (transducer_l15_val),
			.transducer_l15_address             (transducer_l15_address),
			.transducer_l15_data                (transducer_l15_data),

			.transducer_l15_nc                  (transducer_l15_nc),
			.transducer_l15_threadid            (transducer_l15_threadid),
			.transducer_l15_prefetch            (transducer_l15_prefetch),
			.transducer_l15_blockstore          (transducer_l15_blockstore),
			.transducer_l15_blockinitstore      (transducer_l15_blockinitstore),
			.transducer_l15_l1rplway            (transducer_l15_l1rplway),
			.transducer_l15_invalidate_cacheline(transducer_l15_invalidate_cacheline),
			.transducer_l15_csm_data            (transducer_l15_csm_data),
			.transducer_l15_data_next_entry     (transducer_l15_data_next_entry),

			.l15_transducer_val                 (l15_transducer_val),
			.l15_transducer_returntype          (l15_transducer_returntype),

			.l15_transducer_data_0              (l15_transducer_data_0),
			.l15_transducer_data_1              (l15_transducer_data_1),

			.transducer_pico_mem_ready          (transducer_pico_mem_ready),
			.transducer_pico_mem_rdata          (transducer_pico_mem_rdata),

			.transducer_l15_req_ack             (transducer_l15_req_ack),
			.pico_int                           (pico_int)
		);

endmodule


