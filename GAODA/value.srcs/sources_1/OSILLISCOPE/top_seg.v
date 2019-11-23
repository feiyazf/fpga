
module seg_top(
    input clk,
    input rst,
    input[31:0]data,
    output[7:0] seg_sel,
    output[7:0] seg_data,
	output[7:0] seg_data1,
	input idot
);


wire[6:0] seg_data_0;
seg_decoder seg_decoder_m0(
    .bin_data  (data[31:28]),
    .seg_data  (seg_data_0)
);
wire[6:0] seg_data_1;
seg_decoder seg_decoder_m1(
    .bin_data  (data[27:24]),
    .seg_data  (seg_data_1)
);
wire[6:0] seg_data_2;
seg_decoder seg_decoder_m2(
    .bin_data  (data[23:20]),
    .seg_data  (seg_data_2)
);
wire[6:0] seg_data_3;
seg_decoder seg_decoder_m3(
    .bin_data  (data[19:16]),
    .seg_data  (seg_data_3)
);

wire[6:0] seg_data_4;
seg_decoder seg_decoder_m4(
    .bin_data  (data[15:12]),
    .seg_data  (seg_data_4)
);

wire[6:0] seg_data_5;
seg_decoder seg_decoder_m5(
    .bin_data  (data[11:8]),
    .seg_data  (seg_data_5)
);

wire[6:0] seg_data_6;
seg_decoder seg_decoder_m6(
    .bin_data  (data[7:4]),
    .seg_data  (seg_data_6)
);

wire[6:0] seg_data_7;
seg_decoder seg_decoder_m7(
    .bin_data  (data[3:0]),
    .seg_data  (seg_data_7)
);
assign seg_data1=seg_data;

seg_scan seg_scan_m0(
    .clk        (clk),
    .rst_n      (rst),
    .seg_data_0 ({1'b0,seg_data_0}),      //The  decimal point at the highest bit,and low level effecitve
    .seg_data_1 ({idot,seg_data_1}), 
    .seg_data_2 ({1'b0,seg_data_2}),
    .seg_data_3 ({1'b0,seg_data_3}),
    .seg_data_4 ({1'b0,seg_data_4}), 
    .seg_data_5 ({1'b0,seg_data_5}),
    .seg_data_6 ({1'b0,seg_data_6}),
    .seg_data_7 ({1'b0,seg_data_7}), 
    .seg_sel    (seg_sel),
    .seg_data   (seg_data)
);

endmodule