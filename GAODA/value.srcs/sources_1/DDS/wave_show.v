module    wave_show(
input                sys_clk    ,
input                sys_rst_n  ,
input  [1:0]         sw_wave,


output               sel_seg_wave,  //数码管位�?
output  reg          segment_wave   //数码管段�?
);


assign  sel_seg_wave=7'b100_0000;

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
always @( posedge sys_clk or negedge sys_rst_n )
begin
	 if( sys_rst_n )
	    segment_wave <=8'hff;
	 else
	    case( sw_wave )
	       4'd0:segment_wave <= ~_0;
	       4'd1:segment_wave <= ~_1;
	       4'd2:segment_wave <= ~_2;
	       4'd3:segment_wave <= ~_3;
	       default:
	            segment_wave <= ~_0;
	    endcase
end
endmodule