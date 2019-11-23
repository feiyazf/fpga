`timescale 1ns / 1ps


module top_oscilloscope(
                input clk,
                input rst_n,
                input  [11:0]  ad_data,
                output         adc_clk_out,
                output [3:0]   vga_out_r,  //vga red
                output [3:0]   vga_out_g,  //vga green
                output [3:0]   vga_out_b,   //vga blue
                output         vga_out_hs, //vga horizontal synchronization
                output         vga_out_vs, //vga vertical synchronization
                
                output [31:0]  amp_data,
                output [31:0]  max_data,
                output [31:0]  min_data,
                output [31:0]  pl_segdata
        );
    wire adc_clk;
    assign adc_clk_out=adc_clk;
   
    
    
    wire                        yimiao_rst;
    wire [26:0]                 freq;
    wire                        video_clk;
    
    wire [11:0]                 max_s;
    wire [11:0]                 min_s;
    wire [11:0]                 amp_s;
    
    
    
clk_wiz_0  pll_m0(
		 .clk_out1(adc_clk),
		 .clk_out2(video_clk),
		 .clk_in1(clk),
		 .reset(~rst_n)
         );
    
value    my_value(
		.adc_clk(adc_clk),
		.rst_n(rst_n),
		.yimiao_rst(yimiao_rst),
		.freq(freq),
		.ad_data(ad_data),
		.max_s(max_s),
		.min_s(min_s),
		.amp_s(amp_s)
    );

plj 	my_plj(
		.clk(clk),
		.rst(rst_n),
		.ad1_d(ad_data),
		.freq(freq),
		.yimiao_rst(yimiao_rst),
		.segdata(pl_segdata)
		);
    
conv 	myconv(
        .max(max_s),
        .min(min_s),
        .amp(amp_s),
        .max_data(max_data),
        .min_data(min_data),
        .amp_data(amp_data)
    );
	
	
osc my_osc(
        .clk(clk),
        .rst_n(rst_n),
        .adc_clk(adc_clk),
        .video_clk(video_clk),
        .ad9226_data_ch0(ad_data),
        .yimiao_rst(yimiao_rst),
        .freq(freq),
        .vga_out_hs(vga_out_hs),
        .vga_out_vs(vga_out_vs),
        .vga_out_r(vga_out_r),
        .vga_out_g(vga_out_g),
        .vga_out_b(vga_out_b)
    );
	

    
         
    
endmodule
