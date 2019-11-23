module   GAODA(
input                 sys_clk, 
input                 sys_rst_n,

//dds模块
input   [1:0]         sw_wave, //p5 p4 
input   [2:0]         sw_freq, //p3 p2 r2 
input   [2:0]         sw_amp,  //m4  n4 r1 
input   [2:0]         sw,      //u3 u2 v2 从高到低 dip开关 选择显数据
input                 key4,
input                 key1,

output [13:0]         dadata_amp,
output                Da_Clk,

//示波器模块

input  [11:0]  ad_data,
output adc_clk_out,                                           


output                      vga_out_hs, //vga horizontal synchronization
output                      vga_out_vs, //vga vertical synchronization
output[3:0]                 vga_out_r,  //vga red
output[3:0]                 vga_out_g,  //vga green
output[3:0]                 vga_out_b,   //vga blue

//数码管显示模块
output [7:0]          seg_sel,
output [7:0]          seg_data,
output [7:0]          seg_data1
 

);


reg  idot;

reg  [31:0]                 segdata ;
wire [31:0]                 amp_data;
wire [31:0]                 max_data;
wire [31:0]                 min_data;

wire [31:0]                 pl_segdata;

wire   [31:0]    freq_data_bcd;

top_key_sw_dds       top_key_sw_dds(
.sys_clk       (sys_clk) , 
.sys_rst_n     (sys_rst_n) ,           
.sw_wave       (sw_wave) ,
.sw_freq       (sw_freq) , 
.sw_amp        (sw_amp) ,
.key4          (key4) ,
.key1          (key1) ,            
.freq_data_bcd      (freq_data_bcd),
.dadata_amp     (dadata_amp)  ,
.Da_Clk        (Da_Clk)

);

top_oscilloscope    top_oscilloscope(
.clk                (sys_clk) ,
.rst_n              (sys_rst_n),
.adc_clk_out         (adc_clk_out),
.ad_data             (ad_data),       
.vga_out_hs          (vga_out_hs), 
.vga_out_vs          (vga_out_vs), 
.vga_out_r           (vga_out_r),  
.vga_out_g           (vga_out_g),  
.vga_out_b           (vga_out_b),

.min_data            (min_data),
.pl_segdata          (pl_segdata),  
.max_data            (max_data),
.amp_data            (amp_data)

);


seg_top     seg_top(
   .clk     (sys_clk),
   .rst   (sys_rst_n),
   .data    (segdata),    //输入的二进制数
   .idot     (idot),          
  .seg_sel   (seg_sel),
  .seg_data  (seg_data),
  .seg_data1 (seg_data1)
 );


//要显示的值输出  用开关选择数据输出
always@(posedge sys_clk or negedge sys_rst_n)
    begin
        if(~sys_rst_n)
        begin
            segdata<=32'b0;
        end
        else
        begin
            case(sw[2:0])
            0: segdata<=pl_segdata;
            1: segdata<=max_data;
            2: segdata<=min_data;
            3: segdata<=amp_data;
            4: segdata<=freq_data_bcd;
            default:segdata<=32'b0;
            endcase
			if(|sw[2:0])
			idot<=1;
			else
			idot<=0;
        end
    end

endmodule 





