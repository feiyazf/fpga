//����ʱ ��delay_cnt��ֵ �Լ�λ��
module key_debounce(
    input            sys_clk,          //�ⲿ100Mʱ��
    input            sys_rst_n,        //�ⲿ��λ�źţ�����Ч
    input            key,              //�ⲿ��������

    
	output reg       key_value         //���������������  
    );


  parameter   CNT=2_000_000;//������  ����60ns�Ժ���ȶ�
  /*reg    [2:0]  delay_cnt;*/
  reg [20:0] delay_cnt;
  reg        key_reg;


always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (!sys_rst_n) begin 
        key_reg   <= 1'b0;             //Ĭ��Ϊ�͵�ƽ ����Ϊ�ߵ�ƽ
        delay_cnt <=21'd0;
    end
    else begin
        key_reg <= key;
        if(key_reg != key)             //һ����⵽����ֵ���������ֵ����� ���¿�ʼ����
            delay_cnt <= CNT;          //����ʱ����������װ�س�ʼֵ
        else if(key_reg == key) begin  //�ڰ���״̬�ȶ�ʱ���������ݼ�.
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
        if(delay_cnt == 21'd1) begin   //���������ݼ�0ʱ��˵�������ȶ�״ά����20ms
            key_value <= key;          //���Ĵ��ʱ������״̬
        end
        else begin
            key_value <= key_value; 
        end  
    end   
end
    
endmodule 


