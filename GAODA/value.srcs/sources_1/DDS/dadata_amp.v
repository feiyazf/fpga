module  amp_adj (
input                   sys_clk,
input                   sys_rst_n,
input         [7:0]     dadata,
input         [2:0]     sw_amp,

output  reg   [13:0]    dadata_amp    

);

always @(posedge sys_clk or negedge sys_rst_n )  begin
     if(!sys_rst_n)
          dadata_amp<=14'b0000000_0000000;
     else begin
        case(sw_amp)
            3'b000:   dadata_amp<={6'b000000,dadata}; 
            3'b001:   dadata_amp<={5'b00000,dadata,1'b0};
            3'b010:   dadata_amp<={4'b0000,dadata,2'b00};
            3'b011:   dadata_amp<={3'b000,dadata,3'b000};
            3'b100:   dadata_amp<={2'b00,dadata,4'b0000};
            3'b101:   dadata_amp<={1'b0,dadata,5'b00000};
            3'b110:   dadata_amp<={dadata,6'b000_000};
            default : dadata_amp<={6'b000000,dadata}; 
        endcase
     end  
end
endmodule