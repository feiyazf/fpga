
module seg_decoder
(
	input[3:0]      bin_data,     // bin data input
	output reg[6:0] seg_data      // seven segments LED output
);
parameter _0 = 8'hc0,_1 = 8'hf9,_2 = 8'ha4,_3 = 8'hb0,
	               _4 = 8'h99,_5 = 8'h92,_6 = 8'h82,_7 = 8'hf8,
	               _8 = 8'h80,_9 = 8'h90;
always@(*)
begin
	case(bin_data)
		4'd0:seg_data <= ~_0;
		4'd1:seg_data <= ~_1;
		4'd2:seg_data <= ~_2;
		4'd3:seg_data <= ~_3;
		4'd4:seg_data <= ~_4;
		4'd5:seg_data <= ~_5;
		4'd6:seg_data <= ~_6;
		4'd7:seg_data <= ~_7;
		4'd8:seg_data <= ~_8;
		4'd9:seg_data <= ~_9;
		4'hf:seg_data <= _0;

		default:seg_data <= ~7'b111_1111;
	endcase
end
endmodule