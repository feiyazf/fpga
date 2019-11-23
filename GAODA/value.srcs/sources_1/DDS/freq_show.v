module freq_show(
input                 sys_clk    ,
input                 sys_rst_n  ,

//数码的数�?
input        [3:0]    count_1hz,
input        [3:0]    count_10hz,
input        [3:0]    count_100hz,
input        [3:0]    count_1khz,
input        [3:0]    count_10khz,
input        [3:0]    count_100khz,
input        [3:0]    count_1mhz,   


//显示freq信息的时�?  数码管段选和位�??
output  reg  [6:0]    sel_seg_freq,  
output  reg  [7:0]    segment_freq

);
     
      
parameter     _0 = 8'hc0;
parameter     _1 = 8'hf9;
parameter     _2 = 8'ha4;
parameter     _3 = 8'hb0;
parameter     _4 = 8'h99;
parameter     _5 = 8'h92;
parameter     _6 = 8'h82;
parameter     _7 = 8'hf8;
parameter     _8 = 8'h80;
parameter     _9 = 8'h90;
parameter     Time_20us=2_000;

//显示频率�?
reg  [2:0]         sel_cnt;  
reg  [3:0]         seg_result;
reg  [9:0]         count_20us; 


always @(posedge sys_clk or negedge sys_rst_n)
begin
    if (!sys_rst_n)
        count_20us <= 0;
    else if(count_20us==Time_20us-1)
        count_20us <= 0;
    else
        count_20us <= count_20us + 1;
end
 
always  @(posedge sys_clk or negedge sys_rst_n)
begin
    if(sys_rst_n==1'b0)begin
        sel_cnt<=0;
    end
    else if(count_20us==Time_20us-1)         //加一条件
       begin
          if(sel_cnt==7-1)                     //结束条件
               sel_cnt<=0;
          else
               sel_cnt<=sel_cnt+1;           //计数条件
       end
end

//频率的显�?
//�? 第二个dip �?关打�?的时，数码管进行20ms的�?�度刷新 
//如果 的没有打�? 始终位�?�第�?个数码管
always  @(posedge sys_clk or negedge sys_rst_n)   //数码管位动�??
begin
    if(sys_rst_n==1'b0)
        sel_seg_freq<=7'b1000_000;
    else begin 
          case(sel_cnt)
              3'd0:  sel_seg_freq<=7'b0000001;
              3'd1:  sel_seg_freq<=7'b0000010;
              3'd2:  sel_seg_freq<=7'b0000100;
              3'd3:  sel_seg_freq<=7'b0001000;
              3'd4:  sel_seg_freq<=7'b0010000;
              3'd5:  sel_seg_freq<=7'b0100000;
              3'd6:  sel_seg_freq<=7'b1000000;
              default:sel_seg_freq<=7'b1000000; 
             endcase
       end   
end


always  @(posedge sys_clk or negedge sys_rst_n)   
begin
    if(sys_rst_n==1'b0)
        seg_result<=4'd0;
    else  
        case(sel_cnt)
              3'd0:  seg_result<=count_1hz;
              3'd1:  seg_result<=count_10hz;
              3'd2:  seg_result<=count_100hz;
              3'd3:  seg_result<=count_1khz;
              3'd4:  seg_result<=count_10khz;
              3'd5:  seg_result<=count_100khz;
              3'd6:  seg_result<=count_1mhz;
              default:seg_result<=4'd0;
 endcase
end
  
always @( posedge sys_clk or negedge sys_rst_n )
begin
	 if( sys_rst_n )
	    segment_freq <= 8'hff;
	 else
	    case( seg_result )
	       4'd0:segment_freq <= ~_0;
	       4'd1:segment_freq <= ~_1;
	       4'd2:segment_freq <= ~_2;
	       4'd3:segment_freq <= ~_3;
	       4'd4:segment_freq <= ~_4;
	       4'd5:segment_freq <= ~_5;
	       4'd6:segment_freq <= ~_6;
	       4'd7:segment_freq <= ~_7;
	       4'd8:segment_freq <= ~_8;
	       4'd9:segment_freq <= ~_9;
	       default:
	            segment_freq <= ~_0;
	    endcase
end
endmodule 