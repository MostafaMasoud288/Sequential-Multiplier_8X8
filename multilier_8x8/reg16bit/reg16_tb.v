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


module reg16_tb ();
     reg clk,sclr_n,clk_ena;
     reg[15:0] datain ;
     wire [15:0]reg_out;
reg16 dut(clk,sclr_n,clk_ena,datain,reg_out);
always
begin
clk=0;#50;
clk=1;#50;
end

initial 
begin
datain=125;
clk_ena=1 ;sclr_n=0; #100;
clk_ena=1 ;sclr_n=1; #100;
datain=250;
clk_ena=0 ;sclr_n=0; #100;
end
endmodule
