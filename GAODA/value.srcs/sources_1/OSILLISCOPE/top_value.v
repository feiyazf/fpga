
module value(
    input adc_clk,
	input rst_n,
	input yimiao_rst,
	input [26:0] freq,
    input [11:0] ad_data,
    output reg [11:0] max_s,
	output reg [11:0] min_s,
	output reg [11:0] amp_s
);


reg[11:0] ad_data_r;
reg begin_flag;

reg[11:0] max;
reg[11:0] min;

reg[31:0] max_total;
reg[31:0] min_total;

reg[26:0] freq_r;

reg[20:0] cnt_pfreq;
reg[10:0] cnt_times;

reg[20:0] cnt1;
reg[20:0] cnt2;

always@(posedge yimiao_rst or negedge rst_n)
begin
	if(~rst_n)
	begin
		freq_r<=32'd200_000;
		cnt_pfreq<=10_000_000/32'd200_000;
		cnt_times<=10;
	end
	else
	begin
		freq_r<=freq;
		cnt_pfreq<=10_000_000/freq;
	end
end

always@(posedge adc_clk)
begin
	ad_data_r<=ad_data;
end

always@(posedge adc_clk or posedge yimiao_rst or negedge rst_n)
begin
	if(~rst_n)
	begin
        max<=12'd0;
        min<=12'hfff;
	    cnt1<=0;
	end
	else if(yimiao_rst)
	begin
        max<=12'd0;
        min<=12'hfff;
	    cnt1<=0;
	end
	else
	begin
		if(begin_flag)
		begin
            if(cnt1<cnt_pfreq)
            begin
                if(ad_data_r>max)
                max<=ad_data_r;
                if(ad_data_r<min)
                min<=ad_data_r;
                cnt1<=cnt1+1;
            end
            else
            begin
                cnt1<=20'd0;
            end
	    end
    end
end

always@(posedge adc_clk or posedge yimiao_rst or negedge rst_n)
begin
    if(~rst_n)
    begin
        cnt2<=20'd0;
        max_total<=12'd0;
        min_total<=12'd0;
        max_s<=12'd0;
        min_s<=12'd0;
        amp_s<=12'd0;
    end
    else if(yimiao_rst)
    begin
        cnt2<=20'd0;
        max_total<=12'd0;
        min_total<=12'd0;
        max_s<=12'd0;
        min_s<=12'd0;
        amp_s<=12'd0;
        begin_flag<=1;
    end
    else
    if (begin_flag)
    begin
        if(cnt2<cnt_times)
        begin
            if(cnt1==cnt_pfreq)
            begin
                cnt2<=cnt2+1;
                max_total<=max_total+max;
                min_total<=min_total+min;
            end
        end
        else
        begin
            cnt2<=0;
            begin_flag<=0;
            max_s<=max_total/cnt_times;
            min_s<=min_total/cnt_times;
            amp_s<=max_total/cnt_times-min_total/cnt_times;
        end
     end
end

endmodule