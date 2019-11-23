//////////////////////////////////////////////////
//设计说明：频率的控制  输出频率控制字 给dds模块  
//          频率的显示  datax     
/////////////////////////////////////////////////
module    freq_control(
input                sys_clk    ,
input                sys_rst_n  ,
input  [2:0]         sw_freq,              //sw4 sw3 sw2
input                key_freq_up_en,       //key4
input                key_freq_down_en,     //key1


output  reg [23:0]   freq,//给dds模块
output      [31:0]    freq_data_bcd//显示用

  );
parameter  CNT_1S=100_000_000;

reg         [2:0]      sw_freq0;
reg    [26:0]          cnt_1s_up;          //频率增加     1秒计数器
reg    [26:0]          cnt_1s_down;        //频率减小     一秒钟频率减少一定数

//频率档位选择
always  @(posedge sys_clk or negedge sys_rst_n)begin
     if(sys_rst_n==1'b0)begin
          sw_freq0<=3'b0;
     end
     else begin
          sw_freq0<=sw_freq;   
     end
end


always  @(posedge sys_clk or negedge sys_rst_n)begin
     if(sys_rst_n==1'b0)begin
          cnt_1s_up<=0;
     end
     else begin
        if((key_freq_up_en)&&(cnt_1s_up<CNT_1S))
          cnt_1s_up<=cnt_1s_up+1;
        else
          cnt_1s_up<=0; 
     end
end
 
always  @(posedge sys_clk or negedge sys_rst_n)begin
   if(sys_rst_n==1'b0)begin
        cnt_1s_down<=27'd0;
   end
   else begin
      if((key_freq_down_en)&&(cnt_1s_down<CNT_1S))
        cnt_1s_down<=cnt_1s_down+1;
      else
        cnt_1s_down<=0; 
   end
end

//频率控制
always  @(posedge sys_clk or negedge sys_rst_n)
begin
     if(sys_rst_n==1'b0)begin
          freq<=24'd0;
     end
     else begin
         case(sw_freq0)
            3'b000:begin 
                      if(key_freq_up_en)                         
                         begin
                            if(cnt_1s_up==CNT_1S)
                                 freq<=freq+1;          
                            else 
                                 freq<=freq;
                         end
                      else if(key_freq_down_en)
                         begin
                            if(cnt_1s_down==CNT_1S)
                                 freq<=freq-1;
                            else 
                                 freq<=freq;
                         end
                      else
                            freq<=freq;
                   end
            3'b001:begin 
                      if(key_freq_up_en)                         
                         begin
                            if(cnt_1s_up==CNT_1S)
                               begin
                                 freq<=freq+10; 
                               end
                            else
                                 freq<=freq; 
                         end
                      else if(key_freq_down_en)
                         begin
                            if(cnt_1s_down==CNT_1S)
                                 freq<=freq-10;
                            else 
                                 freq<=freq;  
                         end
                      else
                           freq<=freq; 
                   end
            3'b010:begin 
                      if(key_freq_up_en)                         
                         begin
                            if(cnt_1s_up==CNT_1S)
                                 freq<=freq+100; 
                            else
                                 freq<=freq; 
                         end
                      else if(key_freq_down_en)
                         begin
                            if(cnt_1s_down==CNT_1S)
                                 freq<=freq-100;
                            else 
                                 freq<=freq;  
                         end
                      else
                            freq<=freq; 
                   end
            3'b011:begin 
                      if(key_freq_up_en)                         
                         begin
                            if(cnt_1s_up==CNT_1S)
                                 freq<=freq+1000; 
                            else
                                 freq<=freq; 
                         end
                      else if(key_freq_down_en)
                         begin
                            if(cnt_1s_down==CNT_1S)
                                 freq<=freq-1000;
                            else 
                                 freq<=freq;  
                         end
                      else
                            freq<=freq; 
                   end
            3'b100:begin 
                      if(key_freq_up_en)                         
                         begin
                            if(cnt_1s_up==CNT_1S)
                                 freq<=freq+10_000; 
                            else
                                 freq<=freq; 
                         end
                      else if(key_freq_down_en)
                         begin
                            if(cnt_1s_down==CNT_1S)
                                 freq<=freq-10_000;
                            else 
                                 freq<=freq;  
                          end
                      else
                            freq<=freq; 
                   end
            3'b101:begin 
                      if(key_freq_up_en)                         
                         begin
                            if(cnt_1s_up==CNT_1S)
                                 freq<=freq+100_000; 
                            else
                                 freq<=freq;
                          end 
                      else if(key_freq_down_en)
                         begin
                            if(cnt_1s_down==CNT_1S)
                                 freq<=freq-100_000;
                            else 
                                 freq<=freq;  
                         end
                      else
                            freq<=freq; 
                   end
            3'b110:begin 
                      if(key_freq_up_en)                         
                         begin
                            if(cnt_1s_up==CNT_1S)
                                 freq<=freq+1_000_000; 
                            else
                                 freq<=freq; 
                         end
                      else if(key_freq_down_en)
                         begin
                            if(cnt_1s_down==CNT_1S)
                                 freq<=freq-1_000_000;
                            else 
                                 freq<=freq;  
                         end
                      else
                            freq<=freq; 
                   end
            3'b111:begin 
                      if(key_freq_up_en)                         
                         begin
                            if(cnt_1s_up==CNT_1S)
                                 freq<=freq+10_000_000; 
                            else
                                 freq<=freq; 
                         end
                      else if(key_freq_down_en)
                         begin
                            if(cnt_1s_down==CNT_1S)
                                 freq<=freq-10_000_000;
                            else 
                                 freq<=freq;  
                         end
                      else
                            freq<=freq; 
                   end
         default: freq<=freq;
         endcase
       end
end

bin_to_bcd   bin_to_bcd_inst
(
   .sys_clk         (sys_clk),
   .sys_rst_n       (sys_rst_n),
   .tran_en         (1'b1),
   .data_in         (freq), 
     
   .tran_done       ()  , 
   .freq_data_bcd   (freq_data_bcd)
);



endmodule











