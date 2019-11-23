module top_seg_bcd(
    input               sys_clk,
    input               sys_rst_n,
    input               tran_en,//����ʼ��Ϊ1
    input       [23:0]  data_in,//����Ķ�������
    
        
        
    output              tran_done, //binתbcd ��ɱ�־ ���Կս�
    output      [7:0]   seg_sel,
    output      [7:0]   seg_data,
	output      [7:0]   seg_data1
	    );
	    
wire   [31:0]  data_bcd;
bin_to_bcd      bin_to_bcd(    
.sys_clk           (sys_clk),
.sys_rst_n         (sys_rst_n),
.tran_en           (tran_en),
.data_in           (data_in), 


.tran_done         (tran_done), 
.data_bcd          (data_bcd)
);
seg_top      seg_top(
 .clk              (sys_clk),
 .rst_n            (sys_rst_n),
 .data             (data_bcd),
 .seg_sel          (seg_sel),
 .seg_data         (seg_data),
 .seg_data1        (seg_data1)
);

	    
	   
endmodule
