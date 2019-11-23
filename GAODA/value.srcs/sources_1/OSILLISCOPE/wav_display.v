
module wav_display(
	input                       rst_n, //  
	input                       pclk,
	input[23:0]                 wave_color,
	input                       adc_clk,
	input                       adc_buf_wr,
	input[9:0]                  adc_buf_addr,
	input[7:0]                  adc_buf_data,
	input                       i_hs,    
	input                       i_vs,    
	input                       i_de,	
	input[23:0]                 i_data,  
	output                      o_hs,    
	output                      o_vs,    
	output                      o_de,    
	output[23:0]                o_data
);
wire[11:0] pos_x;
wire[11:0] pos_y;
wire       pos_hs;
wire       pos_vs;
wire       pos_de;
wire[23:0] pos_data;
reg[23:0]  v_data;
reg[9:0]   rdaddress;
wire[7:0]  q;
reg        region_active;

assign o_data = v_data;
assign o_hs = pos_hs;
assign o_vs = pos_vs;
assign o_de = pos_de;
always@(posedge pclk)
begin
	if(pos_y >= 12'd9 && pos_y <= 12'd308 && pos_x >= 12'd9 && pos_x  <= 12'd1018)
		region_active <= 1'b1;
	else
		region_active <= 1'b0;
end

always@(posedge pclk)
begin
	if(region_active == 1'b1 && pos_de == 1'b1)
		rdaddress <= rdaddress + 10'd1;
	else
		rdaddress <= 10'd0;
end

always@(posedge pclk)
begin
	if(region_active == 1'b1)
		if(12'd287 - pos_y == {4'd0,q})
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else
		v_data <= pos_data;
end

/*dpram1024x8 buffer
(
	.data(adc_buf_data),
	.rdaddress(rdaddress),
	.rdclock(pclk),
	.wraddress(adc_buf_addr[9:0]),
	.wrclock(adc_clk),
	.wren(adc_buf_wr),
	.q(q)
);*/

blk_mem_gen_0 uut_ram(
        .clka(adc_clk),
        .ena(1),
        .wea(adc_buf_wr),
        .addra(adc_buf_addr),
        .dina(adc_buf_data),
        .douta(),
        .clkb(pclk),
        .enb(1),
        .web(0),
        .addrb(rdaddress),
        .dinb(0),
        .doutb(q)
    );
    

timing_gen_xy timing_gen_xy_m0(
	.rst_n    (rst_n    ),
	.clk      (pclk     ),
	.i_hs     (i_hs     ),
	.i_vs     (i_vs     ),
	.i_de     (i_de     ),
	.i_data   (i_data   ),
	.o_hs     (pos_hs   ),
	.o_vs     (pos_vs   ),
	.o_de     (pos_de   ),
	.o_data   (pos_data ),
	.x        (pos_x    ),
	.y        (pos_y    )
);
endmodule