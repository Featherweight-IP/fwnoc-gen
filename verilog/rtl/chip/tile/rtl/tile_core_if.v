
/****************************************************************************
 * tile_core_if.v
 ****************************************************************************/

  
/**
 * Module: tile_core_if
 * 
 * TODO: Add module documentation
 */
module tile_core_if(
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


endmodule


