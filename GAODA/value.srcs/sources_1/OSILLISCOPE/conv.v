

module conv(
	input[11:0] max,
	input[11:0] min,
	input[11:0] amp,
	output reg [31:0] max_data,
	output reg [31:0] min_data,
	output reg [31:0] amp_data
);

reg [11:0] max_r;
reg [11:0] min_r;
reg [11:0] amp_r;

reg[10:0] max_r1;
reg[10:0] min_r1;
reg[10:0] amp_r1;

always@(max or min or amp)
begin
    max_r<=max;
    min_r<=min;
    amp_r<=amp;
end


always@(max_r or min_r or amp_r)
begin
	if(max_r<12'b100_000_000_000)
	max_data[31:28]<=4'hf;
	else
	max_data[31:28]<=4'ha;
	
	if(min_r<12'b1000_000_000)
	min_data[31:28]<=4'hf;
	else
	min_data[31:28]<=4'ha;
	
	amp_data[31:28]<=4'ha;	
end



always@(max_r or min_r or amp_r or max_r1)
begin
    max_r1<=~max_r[10:0];
    if(max_r>=12'b100_000_000_000)
    begin
	max_data[27:24]<=max_r[10:0]*10000*4/12'h800/10000;
	max_data[23:20]<=max_r[10:0]*10000*4/12'h800%10000/1000;
	max_data[19:16]<=max_r[10:0]*10000*4/12'h800%1000/100;
	max_data[15:12]<=max_r[10:0]*10000*4/12'h800%100/10;
	max_data[11:8]<=max_r[10:0]*10000*4/12'h800%10;
	end
	else
	begin
    max_data[27:24]<=max_r1[10:0]*10000*4/12'h800/10000;
    max_data[23:20]<=max_r1[10:0]*10000*4/12'h800%10000/1000;
    max_data[19:16]<=max_r1[10:0]*10000*4/12'h800%1000/100;
    max_data[15:12]<=max_r1[10:0]*10000*4/12'h800%100/10;
    max_data[11:8]<=max_r1[10:0]*10000*4/12'h800%10;
	end
	max_data[7:0]<=0;
	
    min_r1<=~min_r[10:0];
    if(min_r>=12'b100_000_000_000)
    begin
    min_data[27:24]<=min_r[10:0]*10000*4/12'h800/10000;
    min_data[23:20]<=min_r[10:0]*10000*4/12'h800%10000/1000;
    min_data[19:16]<=min_r[10:0]*10000*4/12'h800%1000/100;
    min_data[15:12]<=min_r[10:0]*10000*4/12'h800%100/10;
    min_data[11:8]<=min_r[10:0]*10000*4/12'h800%10;
    end
    else
    begin
    min_data[27:24]<=min_r1[10:0]*10000*4/12'h800/10000;
    min_data[23:20]<=min_r1[10:0]*10000*4/12'h800%10000/1000;
    min_data[19:16]<=min_r1[10:0]*10000*4/12'h800%1000/100;
    min_data[15:12]<=min_r1[10:0]*10000*4/12'h800%100/10;
    min_data[11:8]<=min_r1[10:0]*10000*4/12'h800%10;
    end
    min_data[7:0]<=0;
        
    amp_r1<=~amp_r[10:0];
    amp_data[27:24]<=amp_r[11:0]*10000*4/12'h800/10000;
    amp_data[23:20]<=amp_r[11:0]*10000*4/12'h800%10000/1000;
    amp_data[19:16]<=amp_r[11:0]*10000*4/12'h800%1000/100;
    amp_data[15:12]<=amp_r[11:0]*10000*4/12'h800%100/10;
    amp_data[11:8]<=amp_r[11:0]*10000*4/12'h800%10;
    amp_data[7:0]<=0;
end

endmodule


