module dds(
input                  sys_clk,                            //ʱ���ź�,100MHzϵͳʱ��
input                  sys_rst_n,                          //�͵�ƽ��Ч��λ��?              
input      [23:0]      freq_ctl,                           //Ƶ�ʿ���
//input      [8:0]       phase_ctr,
input      [1:0]       wave_sel,

output reg [7:0]      dadata,
output                 da_clk      
    
);
//*********************************************
//DACʱ��
//********************************************
assign da_clk=~sys_clk;

//*********************************************
//rom��ַ���� freq control
//********************************************
reg    [31:0]       dds1_freq_reg;         //Ƶ�ʼ�?
reg    [34:0]       dds1_phase_add;        //��λ�ۼ�
reg    [8:0]        rom_addr_phase_0;      
 reg   [8:0] rom_addr_phase; 

always @(posedge sys_clk or negedge sys_rst_n)              
    begin
        if(!sys_rst_n)begin
            dds1_freq_reg <=32'd0;
            dds1_phase_add<=0;
            rom_addr_phase_0 <=9'd0;
        end
        else begin
            dds1_freq_reg <= freq_ctl* 344 ;
            dds1_phase_add<=dds1_phase_add + dds1_freq_reg;
            rom_addr_phase_0 <= dds1_phase_add[34:26] ;          
        end
    end    
 
  always@(posedge sys_clk or negedge sys_rst_n)              
     begin
            if(!sys_rst_n)begin
                 rom_addr_phase<=9'b000_000_000;
            end
            else  begin
                 rom_addr_phase <= rom_addr_phase_0; //+ phase_ctr; 
            end      
     end
            
  

//*********************************************
//����ѡ��
//********************************************
wire  [7:0]   sin_data ;             
wire  [7:0]   square_data;
wire  [7:0]   saw_data;             
wire  [7:0]   tri_data;

reg   [7:0]   dadata_reg;

always @ (negedge sys_clk or negedge sys_rst_n) begin
	 if (!sys_rst_n) dadata_reg <= 'd0;
	   else
		 case (wave_sel)                        //���ݲ��ο���ѡ��ͬ�Ĳ���������?
			  2'b00: dadata_reg <= sin_data;    //���Ҳ�
			  2'b01: dadata_reg <= tri_data;    //���ǲ�
			  2'b10: dadata_reg <= saw_data;    //��ݲ�
			  2'b11: dadata_reg <= square_data; //����
			  default: dadata_reg <= sin_data;
		 endcase
	end


//*********************************************
//��λdadata_reg ����DAC9764�ĸ߰�λ
//********************************************
always @(posedge sys_clk)  begin
     if(!sys_rst_n)
          dadata<=8'b0000_0000;
     else
          dadata<=dadata_reg;
     end


//*********************************************
//����rom?
//********************************************
sin_rom  sin_rom_inst (
  .clka(sys_clk),                   // input wire clka
  .addra(rom_addr_phase),           // input wire [8 : 0] addra
  .douta(sin_data)                  // output wire [7 : 0] douta
);

square_rom    square_rom_inst  (
  .clka(sys_clk),                   // input wire clka
  .addra(rom_addr_phase),           // input wire [8 : 0] addra
  .douta(square_data)               // output wire [7 : 0] douta
);
	saw_rom saw_rom_inst(
  .clka(sys_clk),                   // input wire clka
  .addra(rom_addr_phase),           // input wire [8 : 0] addra                          // input wire [7 : 0] dina
  .douta(saw_data)                  // output wire [7 : 0] douta
);
tri_rom  tri_rom_inst (
  .clka(sys_clk),                   // input wire clka
  .addra(rom_addr_phase),           // input wire [8 : 0] addra
  .douta(tri_data)                  // output wire [7 : 0] douta
);



endmodule 











