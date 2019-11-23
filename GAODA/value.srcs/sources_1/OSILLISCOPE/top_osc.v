module osc(
	input                       clk,
	input                       rst_n,
	input                       adc_clk,
	input                       video_clk,
	input[11:0]                 ad9226_data_ch0,
	input                       yimiao_rst,
	input[26:0]                 freq,
	//vga output
	output                      vga_out_hs, //vga horizontal synchronization
	output                      vga_out_vs, //vga vertical synchronization
	output[3:0]                 vga_out_r,  //vga red
	output[3:0]                 vga_out_g,  //vga green
	output[3:0]                 vga_out_b   //vga blue
);

wire                            video_hs;
wire                            video_vs;
wire                            video_de;
wire[7:0]                       video_r;
wire[7:0]                       video_g;
wire[7:0]                       video_b;

wire                            grid_hs;
wire                            grid_vs;
wire                            grid_de;
wire[7:0]                       grid_r;
wire[7:0]                       grid_g;
wire[7:0]                       grid_b;

wire                            wave0_hs;
wire                            wave0_vs;
wire                            wave0_de;
wire[7:0]                       wave0_r;
wire[7:0]                       wave0_g;
wire[7:0]                       wave0_b;


wire                            adc0_buf_wr;
wire[9:0]                       adc0_buf_addr;
wire[7:0]                       adc0_buf_data;

wire                            adc1_buf_wr;
wire[9:0]                       adc1_buf_addr;
wire[7:0]                       adc1_buf_data;

assign vga_out_hs = wave0_hs;
assign vga_out_vs = wave0_vs;
assign vga_out_r  = wave0_r[7:4]; //discard low bit data
assign vga_out_g  = wave0_g[7:4]; //discard low bit data
assign vga_out_b  = wave0_b[7:4]; //discard low bit data


color_bar color_bar_m0(
	.clk(video_clk),
	.rst(~rst_n),
	.hs(video_hs),
	.vs(video_vs),
	.de(video_de),
	.rgb_r(video_r),
	.rgb_g(video_g),
	.rgb_b(video_b)
);

grid_display  grid_display_m0(
	.rst_n                 (rst_n                      ),
	.pclk                  (video_clk                  ),
	.i_hs                  (video_hs                   ),
	.i_vs                  (video_vs                   ),
	.i_de                  (video_de                   ),
	.i_data                ({video_r,video_g,video_b}  ),
	.o_hs                  (grid_hs                    ),
	.o_vs                  (grid_vs                    ),
	.o_de                  (grid_de                    ),
	.o_data                ({grid_r,grid_g,grid_b}     )
);

ad9226_sample ad9226_sample_m0(
	.adc_clk               (adc_clk                    ),
	.freq				   (freq					   ),
	.rst                   (~rst_n                     ),
	.yimiao_rst			   (yimiao_rst				   ),
	.adc_data              (ad9226_data_ch0            ),
	.adc_buf_wr            (adc0_buf_wr                ),
	.adc_buf_addr          (adc0_buf_addr              ),
	.adc_buf_data          (adc0_buf_data              )
);


wav_display wav_display_m0(
	.rst_n                 (rst_n                      ),
	.pclk                  (video_clk                  ),
	.wave_color            (24'hff0000                 ),
	.adc_clk               (adc_clk                    ),
	.adc_buf_wr            (adc0_buf_wr                ),
	.adc_buf_addr          (adc0_buf_addr              ),
	.adc_buf_data          (adc0_buf_data              ),
	.i_hs                  (grid_hs                    ),
	.i_vs                  (grid_vs                    ),
	.i_de                  (grid_de                    ),
	.i_data                ({grid_r,grid_g,grid_b}     ),
	.o_hs                  (wave0_hs                   ),
	.o_vs                  (wave0_vs                   ),
	.o_de                  (wave0_de                   ),
	.o_data                ({wave0_r,wave0_g,wave0_b}  )
);

endmodule