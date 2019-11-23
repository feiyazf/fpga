
module plj (
	input clk,
	input rst,
	input[11:0] ad1_d,//AD9224��12λAD����
	output reg[26:0] freq,
	output reg  yimiao_rst,
	output reg[31:0] segdata   ); 		 //���������ź� �ߵ�ƽ��Ч
	
//��Ƶ����
parameter[15:0] ad_d_cankao1 =16'b0111111001100111; //16'b0111111001100111;818 /      //����-25mV
parameter[15:0] ad_d_cankao2 =16'b1000000110011001; //16'b1000000110011001;       //����25mV

reg[15:0] ad1_d_r;
reg[30:0] yimiao;                     //��������
reg rukou;                             //���η���

reg[3:0] data7;                         //��¼����
reg[3:0] data6; 
reg[3:0] data5; 
reg[3:0] data4; 
reg[3:0] data3; 
reg[3:0] data2; 
reg[3:0] data1; 
reg[3:0] data0;




   always @(posedge clk)
      begin
         ad1_d_r <= {ad1_d, 4'b0000} ; 
         if (ad1_d_r > ad_d_cankao2)
            rukou <= 1'b1 ;  
         if (ad1_d_r < ad_d_cankao1)
            rukou <= 1'b0 ; 
      end 
//1���Ӳ�Ƶ
  
  

           
always @(posedge clk or negedge rst)                    //ÿ1����ѭ��һ��
begin
	if(!rst)
	begin
		yimiao <= 30'b0;
		yimiao_rst<=0;	
	end
	else
	begin
		if (yimiao == 30'b101111101011110000011111111)//30'b101111101011110000011111111
		begin
		   yimiao <= 30'b0;
		   yimiao_rst<=1;
		end 
		else
		begin
		   yimiao <= yimiao + 1;
		   yimiao_rst<=0;
		end
	end
end

always @(posedge yimiao_rst or negedge rst)
begin
    if (~rst)
    begin
    segdata<=32'b0;
    end
    else if(yimiao_rst)
    begin
        segdata<={data7,data6,data5,data4,data3,data2,data1,data0};			//{data7,data6,data5,data4,data3,data2,data1,data0};
    end
end	
		



//��Ƶ����
always @(posedge rukou or posedge yimiao_rst or negedge rst)
begin
	if (~rst)
	begin
         data0 <= 4'b0000 ; 
         data1 <= 4'b0000 ; 
         data2 <= 4'b0000 ; 
         data3 <= 4'b0000 ; 
         data4 <= 4'b0000 ; 
         data5 <= 4'b0000 ; 
         data6 <= 4'b0000 ; 
         data7 <= 4'b0000 ;
		 freq<=27'd0;
	end
	else if(yimiao_rst)
	begin
	   data0 <= 4'b0000; 
       data1 <= 4'b0000; 
       data2 <= 4'b0000; 
       data3 <= 4'b0000; 
       data4 <= 4'b0000; 
       data5 <= 4'b0000; 
       data6 <= 4'b0000; 
       data7 <= 4'b0000;
       freq<=27'd0; 
	end
	else if(yimiao <30'b101111101011110000011111111)//30'b101111101011110000011111111
    begin
		freq<=freq+1;
		if (data0 == 4'b1001)
		begin
			data0 <= 4'b0000 ; 
            if (data1 == 4'b1001)
            begin
                data1 <= 4'b0000 ; 
                if (data2 == 4'b1001)
                begin
                    data2 <= 4'b0000 ; 
                    if (data3 == 4'b1001)
                    begin
                        data3 <= 4'b0000 ; 
                        if (data4 == 4'b1001)
                        begin
                           data4 <= 4'b0000 ; 
							if (data5 == 4'b1001)
							begin
								data5 <= 4'b0000 ; 
								if (data6 == 4'b1001)
								begin
									data6 <= 4'b0000 ; 
									if (data7 == 4'b1001)
									begin
										data7 <= 4'b0000 ; 
									end
									else
									begin
										data7 <= data7 + 1 ; 
									end 
								end
								else
								begin
									data6 <= data6 + 1 ; 
								end 
							end
							else
							begin
								data5 <= data5 + 1 ; 
							end 
						end
						else
						begin
							data4 <= data4 + 1 ; 
						end	
					end
					else
					begin
                    data3 <= data3 + 1 ; 
					end 
				end
				else
				begin
					data2 <= data2 + 1 ; 
				end 
			end
			else
			begin
                data1 <= data1 + 1 ; 
			end 
        end
        else
        begin
            data0 <= data0 + 1 ; 
        end 
    end 	 
end    
                

        
endmodule