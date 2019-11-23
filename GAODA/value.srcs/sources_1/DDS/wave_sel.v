module    wave_sel(
      input                sys_clk    ,
      input                sys_rst_n  ,
      input       [1:0]    sw_wave,

      output reg  [1:0]    wave_sel   
  );

  always  @(posedge sys_clk or negedge sys_rst_n)begin
      if(sys_rst_n==1'b0)begin
           wave_sel<=2'b0;
      end
      else begin
           wave_sel<=sw_wave;
      end
  end

  endmodule

