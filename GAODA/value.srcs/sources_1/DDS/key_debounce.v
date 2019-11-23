//下载时 改delay_cnt的值 以及位宽
module key_debounce(
    input            sys_clk,          //外部100M时钟
    input            sys_rst_n,        //外部复位信号，低有效
    input            key,              //外部按键输入

    
	output reg       key_value         //按键消抖后的数据  
    );


  parameter   CNT=2_000_000;//仿真用  假设60ns以后就稳定
  /*reg    [2:0]  delay_cnt;*/
  reg [20:0] delay_cnt;
  reg        key_reg;


always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (!sys_rst_n) begin 
        key_reg   <= 1'b0;             //默认为低电平 按下为高电平
        delay_cnt <=21'd0;
    end
    else begin
        key_reg <= key;
        if(key_reg != key)             //一旦检测到按键值与所几寸的值不相等 重新开始减数
            delay_cnt <= CNT;          //给延时计数器重新装载初始值
        else if(key_reg == key) begin  //在按键状态稳定时，计数器递减.
                 if(delay_cnt > 21'd0)
                     delay_cnt <= delay_cnt - 1'b1;
                 else
                     delay_cnt <= delay_cnt;
             end           
    end   
end

always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (!sys_rst_n) begin 
        key_value <= 1'b0;          
    end
    else begin
        if(delay_cnt == 21'd1) begin   //当计数器递减0时，说明按键稳定状维持了20ms
            key_value <= key;          //并寄存此时按键的状态
        end
        else begin
            key_value <= key_value; 
        end  
    end   
end
    
endmodule 


