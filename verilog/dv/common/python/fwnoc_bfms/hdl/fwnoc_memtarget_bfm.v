/****************************************************************************
 * fwnoc_memtarget_bfm.v
 ****************************************************************************/

`include "l2.h"
`include "define.h"
`include "iop.h"
  
/**
 * Module: fwnoc_memtarget_bfm
 * 
 * TODO: Add module documentation
 */
module fwnoc_memtarget_bfm(
		input 			clock,
		input			reset,
		// chip -> bridge
		input			c2b_noc1_valid,
		input[63:0]		c2b_noc1_data,
		output			c2b_noc1_yummy,
		input			c2b_noc2_valid,
		input[63:0]		c2b_noc2_data,
		output			c2b_noc2_yummy,
		input			c2b_noc3_valid,
		input[63:0]		c2b_noc3_data,
		output			c2b_noc3_yummy,
		
		// bridge <- chip
		output			b2c_noc1_valid,
		output[63:0]	b2c_noc1_data,
		input			b2c_noc1_yummy,
		output			b2c_noc2_valid,
		output[63:0]	b2c_noc2_data,
		input			b2c_noc2_yummy,
		output			b2c_noc3_valid,
		output[63:0]	b2c_noc3_data,
		input			b2c_noc3_yummy		
		);

	// Messages coming from the bridge back to the chip
	wire[63:0] 	b2c_data_noc1 = {64{1'b0}};
	wire[63:0] 	b2c_data_noc2 = {64{1'b0}};
	reg[63:0] 	b2c_data_noc3;
	
	// These are b->c controls, letting chip
	// know whether we have valid data to pass
	wire		b2c_val_noc1 = 1'b0;
	wire		b2c_val_noc2 = 1'b0;
	reg			b2c_val_noc3;
	wire		b2c_rdy_noc1;
	wire		b2c_rdy_noc2;
	wire		b2c_rdy_noc3;
	
	// Messages coming from the chip to the bridge
	wire[63:0] 	c2b_data_noc1;
	wire[63:0] 	c2b_data_noc2;
	wire[63:0] 	c2b_data_noc3;
	wire		c2b_val_noc1;
	wire		c2b_val_noc2;
	wire		c2b_val_noc3;
	// These are c->b handshake, letting chip
	// know whether bridge can accept data
	wire		c2b_rdy_noc1 = 1'b1;
	reg			c2b_rdy_noc2;
	wire		c2b_rdy_noc3 = 1'b1;


	valrdy_to_credit #(4, 3) b2c_noc1_v2c(
			.clk(clock),
			.reset(reset),
			.data_in(b2c_data_noc1),
			.valid_in(b2c_val_noc1),
			.ready_in(b2c_rdy_noc1),
			.valid_out(b2c_noc1_valid),
			.data_out(b2c_noc1_data),
			.yummy_out(b2c_noc1_yummy)
		);
	valrdy_to_credit #(4, 3) b2c_noc2_v2c(
			.clk(clock),
			.reset(reset),
			.data_in(b2c_data_noc2),
			.valid_in(b2c_val_noc2),
			.ready_in(b2c_rdy_noc2),
			.valid_out(b2c_noc2_valid),
			.data_out(b2c_noc2_data),
			.yummy_out(b2c_noc2_yummy)
		);
	valrdy_to_credit #(4, 3) b2c_noc3_v2c(
			.clk(clock),
			.reset(reset),
			.data_in(b2c_data_noc3),
			.valid_in(b2c_val_noc3),
			.ready_in(b2c_rdy_noc3),
			.valid_out(b2c_noc3_valid),
			.data_out(b2c_noc3_data),
			.yummy_out(b2c_noc3_yummy)
		);
	
	credit_to_valrdy c2b_noc1_c2v(
			.clk(clock),
			.reset(reset),
			.data_in(c2b_noc1_data),
			.valid_in(c2b_noc1_valid),
			.yummy_in(c2b_noc1_yummy),
			.data_out(c2b_data_noc1),
			.valid_out(c2b_val_noc1),
			.ready_out(c2b_rdy_noc1)
		);
	credit_to_valrdy c2b_noc2_c2v(
			.clk(clock),
			.reset(reset),
			.data_in(c2b_noc2_data),
			.valid_in(c2b_noc2_valid),
			.yummy_in(c2b_noc2_yummy),
			.data_out(c2b_data_noc2),
			.valid_out(c2b_val_noc2),
			.ready_out(c2b_rdy_noc2)
		);
	credit_to_valrdy c2b_noc3_c2v(
			.clk(clock),
			.reset(reset),
			.data_in(c2b_noc3_data),
			.valid_in(c2b_noc3_valid),
			.yummy_in(c2b_noc3_yummy),
			.data_out(c2b_data_noc3),
			.valid_out(c2b_val_noc3),
			.ready_out(c2b_rdy_noc3)
		);
			
	reg mem_valid_in;
	reg [3*`NOC_DATA_WIDTH-1:0] mem_header_in;
	reg mem_ready_in;


	//Input buffer

	reg [`NOC_DATA_WIDTH-1:0] buf_in_mem_f [10:0];
	reg [`NOC_DATA_WIDTH-1:0] buf_in_mem_next;
	reg [`MSG_LENGTH_WIDTH-1:0] buf_in_counter_f;
	reg [`MSG_LENGTH_WIDTH-1:0] buf_in_counter_next;
	reg [3:0] buf_in_wr_ptr_f;
	reg [3:0] buf_in_wr_ptr_next;

	always @* begin
		c2b_rdy_noc2 = (buf_in_counter_f == 0) || (buf_in_counter_f < (buf_in_mem_f[0][`MSG_LENGTH]+1));
	end

	always @* begin
		if (c2b_val_noc2 && c2b_rdy_noc2) begin
			buf_in_counter_next = buf_in_counter_f + 1;
		end else if (mem_valid_in && mem_ready_in) begin
			buf_in_counter_next = 0;
		end else begin
			buf_in_counter_next = buf_in_counter_f;
		end
	end


	always @ (posedge clock) begin
		if (reset) begin
			buf_in_counter_f <= 0;
		end else begin
			buf_in_counter_f <= buf_in_counter_next;
		end
	end

	always @* begin
		if (mem_valid_in && mem_ready_in) begin
			buf_in_wr_ptr_next = 0;
		end else if (c2b_val_noc2 && c2b_rdy_noc2) begin
			buf_in_wr_ptr_next = buf_in_wr_ptr_f + 1;
		end else begin
			buf_in_wr_ptr_next = buf_in_wr_ptr_f;
		end
	end

	always @ (posedge clock) begin
		if (reset) begin
			buf_in_wr_ptr_f <= 0;
		end else begin
			buf_in_wr_ptr_f <= buf_in_wr_ptr_next;
		end
	end


	always @* begin
		if (c2b_val_noc2 && c2b_rdy_noc2) begin
			buf_in_mem_next = c2b_data_noc2;
		end else begin
			buf_in_mem_next = buf_in_mem_f[buf_in_wr_ptr_f];
		end
	end

	always @ (posedge clock) begin
		if (reset) begin
			buf_in_mem_f[buf_in_wr_ptr_f] <= 0;
		end else begin
			buf_in_mem_f[buf_in_wr_ptr_f] <= buf_in_mem_next;
		end
	end

	always @* begin
		mem_valid_in = (buf_in_counter_f != 0) && (buf_in_counter_f == (buf_in_mem_f[0][`MSG_LENGTH]+1));
	end

	always @* begin
		mem_header_in = {buf_in_mem_f[2], buf_in_mem_f[1], buf_in_mem_f[0]};
	end

	//Memory read/write

	wire [`MSG_TYPE_WIDTH-1:0] msg_type;
	wire [`MSG_MSHRID_WIDTH-1:0] msg_mshrid;
	wire [`MSG_DATA_SIZE_WIDTH-1:0] msg_data_size;
	wire [`PHY_ADDR_WIDTH-1:0] msg_addr;
	wire [`MSG_SRC_CHIPID_WIDTH-1:0] msg_src_chipid;
	wire [`MSG_SRC_X_WIDTH-1:0] msg_src_x;
	wire [`MSG_SRC_Y_WIDTH-1:0] msg_src_y;
	wire [`MSG_SRC_FBITS_WIDTH-1:0] msg_src_fbits;

	reg [`MSG_TYPE_WIDTH-1:0] msg_send_type;
	reg [`MSG_LENGTH_WIDTH-1:0] msg_send_length;
	reg [`NOC_DATA_WIDTH-1:0] msg_send_data [7:0];
	reg [`NOC_DATA_WIDTH-1:0] mem_temp;
	wire [`NOC_DATA_WIDTH*3-1:0] msg_send_header;




	l2_decoder decoder(
			.msg_header         (mem_header_in),
			.msg_type           (msg_type),
			.msg_length         (),
			.msg_mshrid         (msg_mshrid),
			.msg_data_size      (msg_data_size),
			.msg_cache_type     (),
			.msg_subline_vector (),
			.msg_mesi           (),
			.msg_l2_miss        (),
			.msg_subline_id     (),
			.msg_last_subline   (),
			.msg_addr           (msg_addr),
			.msg_src_chipid     (msg_src_chipid),
			.msg_src_x          (msg_src_x),
			.msg_src_y          (msg_src_y),
			.msg_src_fbits      (msg_src_fbits),
			.msg_sdid           (),
			.msg_lsid           ()
		);

	reg [63:0] write_mask;

	always @ *
	begin
		if (msg_data_size == `MSG_DATA_SIZE_1B)
		begin
			write_mask = 64'hff00000000000000;
			write_mask = write_mask >> (8*msg_addr[2:0]);
		end
		else if (msg_data_size == `MSG_DATA_SIZE_2B)
		begin
			write_mask = 64'hffff000000000000;
			write_mask = write_mask >> (16*msg_addr[2:1]);
		end
		else if (msg_data_size == `MSG_DATA_SIZE_4B)
		begin
			write_mask = 64'hffffffff00000000;
			write_mask = write_mask >> (32*msg_addr[2]);
		end
		else if (msg_data_size == `MSG_DATA_SIZE_8B)
		begin
			write_mask = 64'hffffffffffffffff;
		end
		else
		begin
			write_mask = 64'h0000000000000000;
		end
	end


	always @ *
	begin
		// initialize to get rid of msim warnings
		mem_temp = `NOC_DATA_WIDTH'h0;
		if (mem_valid_in)
		begin
			case (msg_type)
				`MSG_TYPE_LOAD_MEM:
				begin
					_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b000000}, 8, 0);
					_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b001000}, 8, 1);
					_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b010000}, 8, 2);
					_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b011000}, 8, 3);
					_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b100000}, 8, 4);
					_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b101000}, 8, 5);
					_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b110000}, 8, 6);
					_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b111000}, 8, 7);
					msg_send_type = `MSG_TYPE_LOAD_MEM_ACK;
					msg_send_length = 8'd8;
				end
				`MSG_TYPE_STORE_MEM:
				begin
					_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b000000},buf_in_mem_f[3]);
					_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b001000},buf_in_mem_f[4]);
					_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b010000},buf_in_mem_f[5]);
					_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b011000},buf_in_mem_f[6]);
					_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b100000},buf_in_mem_f[7]);
					_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b101000},buf_in_mem_f[8]);
					_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b110000},buf_in_mem_f[9]);
					_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b111000},buf_in_mem_f[10]);
					msg_send_type = `MSG_TYPE_STORE_MEM_ACK;
					msg_send_length = 8'd0;
				end
				`MSG_TYPE_NC_LOAD_REQ:
				begin
					msg_send_type = `MSG_TYPE_NC_LOAD_MEM_ACK;
					case(msg_data_size)
						`MSG_DATA_SIZE_1B: 
						begin
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG], msg_addr[`L2_TAG_INDEX],msg_addr[5:0]}, 1, 0);
							msg_send_length = 8'd1;
						end
						`MSG_DATA_SIZE_2B: 
						begin
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG], msg_addr[`L2_TAG_INDEX],msg_addr[5:0]}, 2, 0);
							msg_send_length = 8'd1;
						end
						`MSG_DATA_SIZE_4B: 
						begin
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG], msg_addr[`L2_TAG_INDEX],msg_addr[5:0]}, 4, 0);
							msg_send_length = 8'd1;
						end
						`MSG_DATA_SIZE_8B: 
						begin
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG], msg_addr[`L2_TAG_INDEX],msg_addr[5:0]}, 8, 0);
							msg_send_length = 8'd1;
						end
						`MSG_DATA_SIZE_16B: 
						begin
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],
										msg_addr[`L2_TAG_INDEX],msg_addr[`L2_DATA_SUBLINE],4'b0000}, 8, 0);
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],
										msg_addr[`L2_TAG_INDEX],msg_addr[`L2_DATA_SUBLINE],4'b1000}, 8, 1);
							msg_send_length = 8'd2;
						end
						`MSG_DATA_SIZE_32B: // L2 currently does not support 32B DATA_ACK  
						begin
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],
										msg_addr[`L2_TAG_INDEX],msg_addr[5],5'b00000}, 8, 0);
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],
										msg_addr[`L2_TAG_INDEX],msg_addr[5],5'b01000}, 8, 1);
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],
										msg_addr[`L2_TAG_INDEX],msg_addr[5],5'b10000}, 8, 2);
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],
										msg_addr[`L2_TAG_INDEX],msg_addr[5],5'b11000}, 8, 3);
							msg_send_length = 8'd4;
						end
						`MSG_DATA_SIZE_64B: 
						begin
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b000000}, 8, 0);
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b001000}, 8, 1);
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b010000}, 8, 2);
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b011000}, 8, 3);
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b100000}, 8, 4);
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b101000}, 8, 5);
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b110000}, 8, 6);
							_read_req({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b111000}, 8, 7);
							msg_send_length = 8'd8;
						end
					endcase
				end
				`MSG_TYPE_NC_STORE_REQ:
				begin
					msg_send_type = `MSG_TYPE_NC_STORE_MEM_ACK;
					msg_send_length = 8'd0;
					case(msg_data_size)
						`MSG_DATA_SIZE_64B:
						begin
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b000000},buf_in_mem_f[3]);
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b001000},buf_in_mem_f[4]);
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b010000},buf_in_mem_f[5]);
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b011000},buf_in_mem_f[6]);
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b100000},buf_in_mem_f[7]);
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b101000},buf_in_mem_f[8]);
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b110000},buf_in_mem_f[9]);
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],6'b111000},buf_in_mem_f[10]);
						end
						`MSG_DATA_SIZE_32B:
						begin
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],msg_addr[5],5'b00000},buf_in_mem_f[3]);
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],msg_addr[5],5'b01000},buf_in_mem_f[4]);
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],msg_addr[5],5'b10000},buf_in_mem_f[5]);
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],msg_addr[5],5'b11000},buf_in_mem_f[6]);
						end
						`MSG_DATA_SIZE_16B:
						begin
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],msg_addr[5:4],4'b0000},buf_in_mem_f[3]);
							_write64({{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG],msg_addr[`L2_TAG_INDEX],msg_addr[5:4],4'b1000},buf_in_mem_f[4]);
						end
						default:
						begin
							case (msg_data_size)
								`MSG_DATA_SIZE_1B: begin
									_write8(
										{{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG], msg_addr[`L2_TAG_INDEX],msg_addr[5:0]},
										(buf_in_mem_f[3] >> (8*msg_addr[2:0])));
								end
								`MSG_DATA_SIZE_2B: begin
									_write16(
										{{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG], msg_addr[`L2_TAG_INDEX],msg_addr[5:1], 1'b0},
										(buf_in_mem_f[3] >> (16*msg_addr[2:1])));
								end
								`MSG_DATA_SIZE_4B: begin
									write32_w(
										{{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG], msg_addr[`L2_TAG_INDEX],msg_addr[5:2], 2'b0},
										(buf_in_mem_f[3] >> (32*msg_addr[2])));
								end
								default: begin
									_write64(
										{{(`MEM_ADDR_WIDTH-`PHY_ADDR_WIDTH){1'b0}}, msg_addr[`L2_TAG], msg_addr[`L2_TAG_INDEX],msg_addr[5:3], 3'b0},
										buf_in_mem_f[3]);
								end
							endcase
						end
					endcase
				end
				default:
				begin
					msg_send_type = `MSG_TYPE_ERROR;
					msg_send_length = 8'd0;
				end
			endcase
		end
	end

	l2_encoder encoder(
			.msg_dst_chipid             (msg_src_chipid),
			.msg_dst_x                  (msg_src_x),
			.msg_dst_y                  (msg_src_y),
			.msg_dst_fbits              (msg_src_fbits),
			.msg_length                 (msg_send_length),
			.msg_type                   (msg_send_type),
			.msg_mshrid                 (msg_mshrid),
			.msg_data_size              ({`MSG_DATA_SIZE_WIDTH{1'b0}}),
			.msg_cache_type             ({`MSG_CACHE_TYPE_WIDTH{1'b0}}),
			.msg_subline_vector         ({`MSG_SUBLINE_VECTOR_WIDTH{1'b0}}),
			.msg_mesi                   ({`MSG_MESI_BITS{1'b0}}),
			.msg_l2_miss                (msg_addr[`PHY_ADDR_WIDTH-1]),
			.msg_subline_id             ({`MSG_SUBLINE_ID_WIDTH{1'b0}}),
			.msg_last_subline           ({`MSG_LAST_SUBLINE_WIDTH{1'b1}}),
			.msg_addr                   (msg_addr),
			.msg_src_chipid             ({`NOC_CHIPID_WIDTH{1'b0}}),
			.msg_src_x                  ({`NOC_X_WIDTH{1'b0}}),
			.msg_src_y                  ({`NOC_Y_WIDTH{1'b0}}),
			.msg_src_fbits              ({`NOC_FBITS_WIDTH{1'b0}}),
			.msg_sdid                   ({`MSG_SDID_WIDTH{1'b0}}),
			.msg_lsid                   ({`MSG_LSID_WIDTH{1'b0}}),
			.msg_header                 (msg_send_header)
		);



	//Output buffer

	reg [`NOC_DATA_WIDTH-1:0] buf_out_mem_f [8:0];
	reg [`NOC_DATA_WIDTH-1:0] buf_out_mem_next [8:0];
	reg [`MSG_LENGTH_WIDTH-1:0] buf_out_counter_f;
	reg [`MSG_LENGTH_WIDTH-1:0] buf_out_counter_next;
	reg [3:0] buf_out_rd_ptr_f;
	reg [3:0] buf_out_rd_ptr_next;
	
	integer i;
	initial begin
		for (i=0; i<9; i=i+1) begin
			buf_out_mem_f[i] = 0;
			buf_out_mem_next[i] = 0;
		end
	end

	always @* begin
		b2c_val_noc3 = (buf_out_counter_f != 0);
	end

	always @* begin
		mem_ready_in = (buf_out_counter_f == 0);
	end


	always @* begin
		if (b2c_val_noc3 && b2c_rdy_noc3) begin
			buf_out_counter_next = buf_out_counter_f - 1;
		end else if (mem_valid_in && mem_ready_in) begin
			buf_out_counter_next = msg_send_length + 1;
		end else begin
			buf_out_counter_next = buf_out_counter_f;
		end
	end

	always @ (posedge clock)
	begin
		if (reset) begin
			buf_out_counter_f <= 0;
		end else begin
			buf_out_counter_f <= buf_out_counter_next;
		end
	end


	always @* begin
		if (mem_valid_in && mem_ready_in) begin
			buf_out_rd_ptr_next = 0;
		end else if (b2c_val_noc3 && b2c_rdy_noc3) begin
			buf_out_rd_ptr_next = buf_out_rd_ptr_f + 1;
		end else begin
			buf_out_rd_ptr_next = buf_out_rd_ptr_f;
		end
	end

	always @ (posedge clock) begin
		if (reset) begin
			buf_out_rd_ptr_f <= 0;
		end else begin
			buf_out_rd_ptr_f <= buf_out_rd_ptr_next;
		end
	end



	always @* begin
		if (mem_valid_in && mem_ready_in) begin
			buf_out_mem_next[0] = msg_send_header[`NOC_DATA_WIDTH-1:0];
			buf_out_mem_next[1] = msg_send_data[0];
			buf_out_mem_next[2] = msg_send_data[1];
			buf_out_mem_next[3] = msg_send_data[2];
			buf_out_mem_next[4] = msg_send_data[3];
			buf_out_mem_next[5] = msg_send_data[4];
			buf_out_mem_next[6] = msg_send_data[5];
			buf_out_mem_next[7] = msg_send_data[6];
			buf_out_mem_next[8] = msg_send_data[7];
		end else begin
			buf_out_mem_next[0] = buf_out_mem_f[0];
			buf_out_mem_next[1] = buf_out_mem_f[1];
			buf_out_mem_next[2] = buf_out_mem_f[2];
			buf_out_mem_next[3] = buf_out_mem_f[3];
			buf_out_mem_next[4] = buf_out_mem_f[4];
			buf_out_mem_next[5] = buf_out_mem_f[5];
			buf_out_mem_next[6] = buf_out_mem_f[6];
			buf_out_mem_next[7] = buf_out_mem_f[7];
			buf_out_mem_next[8] = buf_out_mem_f[8];
		end
	end

	always @ (posedge clock)
	begin
		if (reset) begin
			buf_out_mem_f[0] <= 0;
			buf_out_mem_f[1] <= 0;
			buf_out_mem_f[2] <= 0;
			buf_out_mem_f[3] <= 0;
			buf_out_mem_f[4] <= 0;
			buf_out_mem_f[5] <= 0;
			buf_out_mem_f[6] <= 0;
			buf_out_mem_f[7] <= 0;
			buf_out_mem_f[8] <= 0;
		end else begin
			buf_out_mem_f[0] <= buf_out_mem_next[0];
			buf_out_mem_f[1] <= buf_out_mem_next[1];
			buf_out_mem_f[2] <= buf_out_mem_next[2];
			buf_out_mem_f[3] <= buf_out_mem_next[3];
			buf_out_mem_f[4] <= buf_out_mem_next[4];
			buf_out_mem_f[5] <= buf_out_mem_next[5];
			buf_out_mem_f[6] <= buf_out_mem_next[6];
			buf_out_mem_f[7] <= buf_out_mem_next[7];
			buf_out_mem_f[8] <= buf_out_mem_next[8];
		end
	end


	always @* begin
		b2c_val_noc3 = (buf_out_counter_f != 0);
	end

	always @* begin
		// Tri: another quick fix for x
		b2c_data_noc3 = 0;
		if (buf_out_rd_ptr_f < 9)
			b2c_data_noc3 = buf_out_mem_f[buf_out_rd_ptr_f];
	end
	
	task write32_w(input reg[63:0] addr, input reg[63:0] data);
	begin
		_write32(addr, data);
	end
	endtask

	task init;
		$display("%m: init");
	endtask
	
	task _read_ack(input reg[63:0] data, input reg[7:0] idx);
	begin
		msg_send_data[idx] = data;	
	end
	endtask

	// Auto-generated code to implement the BFM API
`ifdef PYBFMS_GEN
${pybfms_api_impl}
`endif
		
endmodule


