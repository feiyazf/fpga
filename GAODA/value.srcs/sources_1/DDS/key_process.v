module key_process (
input      sys_clk,
input      sys_rst_n,

input      key_freq_up,       //key4
input      key_freq_down,     //key1

output     key_freq_up_en,
output     key_freq_down_en
);


key_debounce   key_freq_up_inst(
    .sys_clk             (sys_clk),                
    .sys_rst_n           (sys_rst_n),              
    .key                 (key_freq_up),          
    
	.key_value           (key_freq_up_en) 
	);         
    
    
    key_debounce   key_freq_down_inst1(
    .sys_clk             (sys_clk),                
    .sys_rst_n           (sys_rst_n),              
    .key                 (key_freq_down),          
    
	.key_value           (key_freq_down_en)        
    );  
 endmodule