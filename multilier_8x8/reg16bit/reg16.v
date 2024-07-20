module reg16 (
     input clk,sclr_n,clk_ena,
     input[15:0] datain ,
     output reg [15:0]reg_out);

     always@(posedge clk)
       begin
         if (clk_ena==1 &sclr_n==0)
                reg_out=16'b0 ;
         else if (clk_ena==1 &sclr_n==1)
                reg_out=datain ;
         else 
                reg_out=reg_out;
       end
endmodule
