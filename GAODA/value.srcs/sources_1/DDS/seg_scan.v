module seg_scan(
	input           sys_clk,
	input           sys_rst_n,
	input[7:0]      seg_data_0,
	input[7:0]      seg_data_1,
	input[7:0]      seg_data_2,
	input[7:0]      seg_data_3,
	input[7:0]      seg_data_4,
	input[7:0]      seg_data_5,
	input[7:0]      seg_data_6,
    input[7:0]      seg_data_7,
    output reg[7:0] seg_sel,      //digital led chip select
    output reg[7:0] seg_data     //eight segment digital tube output,MSB is the decimal point
);

parameter SCAN_FREQ = 200;     //scan frequency
parameter CLK_FREQ = 100_000000; //clock frequency

parameter SCAN_COUNT = CLK_FREQ /(SCAN_FREQ * 8) - 1;

reg[31:0] scan_timer;  //scan time counter
reg[3:0] scan_sel;     //Scan select counter

always@(posedge sys_clk or negedge sys_rst_n)
begin
	if(sys_rst_n == 1'b0)
	begin
		scan_timer <= 32'd0;
		scan_sel <= 4'h0;
	end
	else if(scan_timer >= SCAN_COUNT)
	begin
		scan_timer <= 32'h0;
		if(scan_sel ==4'h7)
			scan_sel <= 4'h0;
		else
			scan_sel <= scan_sel + 4'h1;
	end
	else
		begin
			scan_timer <= scan_timer + 32'h1;
		end
end
always@(posedge sys_clk or negedge sys_rst_n)
begin
	if(sys_rst_n == 1'b0)
	begin
		seg_sel <= 8'h00;
		seg_data <= 8'h00;
	end
	else
	begin
	   seg_sel <= 8'h0;
		case(scan_sel)
			//first digital led
			4'd0:
			begin
				seg_sel <= ~8'b1111_1110;
				seg_data <= seg_data_0;
			end
			//second digital led
			4'd1:
			begin
				seg_sel <= ~8'b1111_1101;
				seg_data <= seg_data_1;
			end
			//...
			4'd2:
			begin
				seg_sel <= ~8'b1111_1011;
				seg_data <= seg_data_2;
			end
			4'd3:
			begin
				seg_sel <= ~8'b1111_0111;
				seg_data <= seg_data_3;
			end
			4'd4:
			begin
				seg_sel <= ~8'b1110_1111;
				seg_data <= seg_data_4;
			end
			4'd5:
			begin
				seg_sel <= ~8'b1101_1111;
				seg_data <= seg_data_5;
			end
			4'd6:
            begin
                 seg_sel <= ~8'b1011_1111;
                 seg_data <= seg_data_6;
            end
            4'd7:
            begin
                 seg_sel <= ~8'b0111_1111;
                 seg_data <= seg_data_7;
            end
			default:
			begin
				seg_sel <= ~8'b1111_1111;
				seg_data <= 8'h00;
			end
		endcase
	end
end

endmodule  