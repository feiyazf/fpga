
module ad9226_sample(
	input                       adc_clk,
	input[26:0]					freq,
	input                       rst,
	input 						yimiao_rst,
	input[11:0]                 adc_data,
	output reg                  adc_buf_wr,
	output[9:0]                 adc_buf_addr,
	output[7:0]                 adc_buf_data
);


reg[26:0]freq1;
reg start;

reg[7:0] adc_data_narrow;

reg[10:0] sample_cnt;


reg[20:0] cnt;
reg[20:0] wait_cnt;
assign adc_buf_addr = sample_cnt;
assign adc_buf_data = adc_data_narrow;


always@(posedge yimiao_rst or posedge rst)
begin
    if(rst)
    begin
            freq1<=27'd20000;
            cnt<=19530/freq-1;//195312
     end
     else
     begin
                freq1<=freq;
                cnt<=19530/freq-1;//195312
     end
end

always@(posedge adc_clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		adc_data_narrow <= 8'd0;
	end
	else
		adc_data_narrow <= adc_data[11:4];				
end


always@(posedge adc_clk or posedge yimiao_rst or posedge rst)
begin
    if(rst == 1'b1)
	begin
		sample_cnt <= 11'd0;
		adc_buf_wr <= 1'b0;
		wait_cnt<=0;
		start<=0;
	end
	else
	begin 
		if(yimiao_rst)
        begin
            start<=1;
        end
        else
        begin
			if(start)
			begin
				if(freq1>9765)//97656
				begin
					if(sample_cnt == 11'd1023)//11'd1023
					begin
						sample_cnt <= 11'd0;
						adc_buf_wr <= 1'b0;
						start<=0;
					end
					else
					begin
						sample_cnt <= sample_cnt + 11'd1;
						adc_buf_wr <= 1'b1;
					end
				end
				else
				begin
					if(wait_cnt>=cnt)
					begin
						wait_cnt<=0;
						if(sample_cnt == 11'd1023)
						begin
							sample_cnt <= 11'd0;
							adc_buf_wr <= 1'b0;
							start<=0;
						end
						else
						begin
							sample_cnt <= sample_cnt + 11'd1;
							adc_buf_wr <= 1'b1;
						end
					end
					else
					begin
					wait_cnt=wait_cnt+1;
					end
				end
			end//start
        end//yimiao_rst
	end//rst
end//always

endmodule