module   top_key_sw_dds(
input                 sys_clk, 
input                 sys_rst_n,

input   [1:0]         sw_wave,
input   [2:0]         sw_freq, 
input   [2:0]         sw_amp,
input                 key4,
input                 key1,



output [31:0]          freq_data_bcd,//输出给显示用
output [13:0]          dadata_amp,
output                 Da_Clk      

);



wire        [23:0]          freq_0;
wire        [1:0]           sel_wave;
wire                        freq_gen_done;
wire                        key_en0;
wire                        key_en1;

wire         [23:0]         freq_bin;
wire        [7:0]           dadata;

 
/*wire        [8:0]           phase_ctl;*/
 
assign    freq_gen_done=1'b1;

key_process   key_process(
.sys_clk                   (sys_clk),
.sys_rst_n                 (sys_rst_n),
   
.key_freq_up               (key4),                 //key4
.key_freq_down             (key1),                 //key1
  
.key_freq_up_en            (key_en0),
.key_freq_down_en          (key_en1)
);



 freq_control      freq_control(
.sys_clk                   (sys_clk),
.sys_rst_n                 (sys_rst_n),
.sw_freq                   (sw_freq),              //sw4 sw3 sw2
.key_freq_up_en            (key_en0),              //key4
.key_freq_down_en          (key_en1),              //key1

.freq                      (freq_bin),
.freq_data_bcd              (freq_data_bcd)//显示用



  );
  
  
 
wave_sel         wave_sel(
.sys_clk                   (sys_clk),
.sys_rst_n                 (sys_rst_n),
.sw_wave                   (sw_wave),        //sw1 sw2

.wave_sel                  (sel_wave)
  );
  
  
dds       dds(
.sys_clk                   (sys_clk),                           
.sys_rst_n                 (sys_rst_n),                                       
.freq_ctl                  (freq_bin),                           
.wave_sel                  (sel_wave),
 
.dadata                    (dadata),
.da_clk                    (Da_Clk)
);



amp_adj  amp_adj(
.sys_clk       (sys_clk),
.sys_rst_n     (sys_rst_n),
.dadata        (dadata),
.sw_amp        (sw_amp),
              
.dadata_amp    (dadata_amp)
);


endmodule

