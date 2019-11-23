`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/19 21:25:46
// Design Name: 
// Module Name: value_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module value_tb;


reg [11:0]ad_data=12'h080;
reg [2:0] sw;

wire adc_clk;
wire [7:0] seg_data;
wire [7:0] seg_data1;
wire [7:0] seg_sel;

reg clk=0;
reg rst_n=1;


top mytop(
    .clk(clk),
    .rst_n(rst_n),
    .ad_data(ad_data),
    .sw(sw[2:0]),
    .adc_clk(adc_clk),
    .seg_data(seg_data),
    .seg_data1(seg_data1),
    .seg_sel(seg_sel)
    );

initial
fork
    #20 rst_n=0;
    #30 rst_n=1;
    #30 sw=0;
    #30 ad_data=12'h080;
join

reg[10:0] ad_cnt;
always@(posedge clk or negedge rst_n )
begin
    if(~rst_n)
    begin
    ad_cnt<=0;
    ad_data<=0;
    end
    else if(ad_cnt==49)
    begin
    ad_data<=~ad_data;
    ad_cnt<=0;
    end
    else
    ad_cnt<=ad_cnt+1;
end

always#5 clk=~clk;

endmodule
