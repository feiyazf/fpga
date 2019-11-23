module  phase_control(
input                  sys_clk    ,
input                  sys_rst_n  ,
input           [1:0]  sw_phase,
input                  key_phase_up,
input                  key_phase_down,

output    reg   [3:0]  count_phase_ge,
output    reg   [3:0]  count_phase_shi,
output    reg   [3:0]  count_phase_bai,

output    reg   [8:0]  phase
  );

wire          key_phase_up_en;
wire          key_phase_down_en;  
reg  [1:0]    sw_phase0;  

always  @(posedge sys_clk or negedge sys_rst_n)begin
    if(sys_rst_n==1'b0)begin
         sw_phase0<=2'b0;
    end
    else begin
         sw_phase0<=sw_phase;
    end
end


reg    [26:0]  cnt_1s_up0;   //��λ����     1�������
reg    [26:0]  cnt_1s_down0; //��λ��С     һ����Ƶ�ʼ���һ����

 /* reg    [6:0]  cnt_1s_up0;   //������
  reg    [6:0]  cnt_1s_down0;*/
parameter  CNT_1S0=100_000_000;
  
  
always  @(posedge sys_clk or negedge sys_rst_n)begin
     if(sys_rst_n==1'b0)begin
          cnt_1s_up0<=0;
     end
     else begin
        if((key_phase_up_en)&&(cnt_1s_up0<CNT_1S0))
          cnt_1s_up0<=cnt_1s_up0+1;
        else
          cnt_1s_up0<=0; 
     end
end
 
always  @(posedge sys_clk or negedge sys_rst_n)begin
     if(sys_rst_n==1'b0)begin
          cnt_1s_down0<=27'd0;
     end
     else begin
        if((key_phase_down_en)&&(cnt_1s_down0<CNT_1S0))
          cnt_1s_down0<=cnt_1s_down0+1;
        else
          cnt_1s_down0<=0; 
     end
end
 


always  @(posedge sys_clk or negedge sys_rst_n)
begin
     if(sys_rst_n==1'b0)begin
          phase<=9'd0;
          count_phase_ge<=4'd0;
          count_phase_shi<=4'd0;
          count_phase_bai<=4'd0; 
     end
     else begin
         case(sw_phase0)
            2'b00:begin 
                      if(key_phase_up_en)                              
                         begin
                            if(cnt_1s_up0==CNT_1S0)
                               begin
                                 phase<=phase+1;
                                 count_phase_ge<=count_phase_ge+1;
                               end                                 
                            else begin
                                   phase<=phase; 
                                   count_phase_ge<=count_phase_ge;
                                 end                                 
                         end
                      else if(key_phase_down_en)
                         begin
                            if(cnt_1s_down0==CNT_1S0)
                                 begin
                                   phase<=phase-1;
                                   count_phase_ge<=count_phase_ge-1;
                                 end                                   
                            else begin
                                   phase<=phase; 
                                   count_phase_ge<=count_phase_ge;  
                                 end                                 
                         end
                      else begin
                         phase<=phase; 
                         count_phase_ge<=count_phase_ge;
                           end                         
                   end
            2'b01:begin 
                      if(key_phase_up_en)                              
                         begin
                            if(cnt_1s_up0==CNT_1S0)
                               begin
                                 phase<=phase+1;
                                 count_phase_shi<=count_phase_shi+1;
                               end                                 
                            else begin
                                   phase<=phase; 
                                   count_phase_shi<=count_phase_shi;
                                 end                                 
                         end
                      else if(key_phase_down_en)
                         begin
                            if(cnt_1s_down0==CNT_1S0)
                                 begin
                                   phase<=phase-1;
                                   count_phase_shi<=count_phase_shi-1;
                                 end                                   
                            else begin
                                   phase<=phase; 
                                   count_phase_shi<=count_phase_shi;  
                                 end                                 
                         end
                      else begin
                         phase<=phase; 
                         count_phase_shi<=count_phase_shi;
                           end                         
                   end
            2'b10:begin 
                      if(key_phase_up_en)                              
                         begin
                            if(cnt_1s_up0==CNT_1S0)
                               begin
                                 phase<=phase+1;
                                 count_phase_bai<=count_phase_bai+1;
                               end                                 
                            else begin
                                   phase<=phase; 
                                   count_phase_bai<=count_phase_bai;
                                 end                                 
                         end
                      else if(key_phase_down_en)
                         begin
                            if(cnt_1s_down0==CNT_1S0)
                                 begin
                                   phase<=phase-1;
                                   count_phase_bai<=count_phase_bai-1;
                                 end                                   
                            else begin
                                   phase<=phase; 
                                   count_phase_bai<=count_phase_bai;  
                                 end                                 
                         end
                      else begin
                         phase<=phase; 
                         count_phase_bai<=count_phase_bai;
                           end                         
                   end
            default:begin
                       phase<=phase;
                       count_phase_bai<=count_phase_bai;
                       count_phase_ge<=count_phase_ge;
                       count_phase_shi<=count_phase_shi;
                    end                       
        endcase
    end
end



key_debounce   key_phase_up_inst(
    .sys_clk             (sys_clk),                //�ⲿ100Mʱ��
    .sys_rst_n           (sys_rst_n),              //�ⲿ��λ�źţ�����Ч
    .key                 (key_phase_up),            //�ⲿ��������  s3
    
	.key_value           (key_phase_up_en)          //���������������  
    );
    
    
    key_debounce   key_phase_down_inst(
    .sys_clk             (sys_clk),                //�ⲿ100Mʱ��
    .sys_rst_n           (sys_rst_n),              //�ⲿ��λ�źţ�����Ч
    .key                 (key_phase_down),          //�ⲿ��������  s0
    
	.key_value           (key_phase_down_en)        //���������������  
    );  

    

    
  endmodule

