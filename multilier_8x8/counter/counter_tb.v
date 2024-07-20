module counter(
   input clk ,aclr_n,
   output [1:0] count_out 
);
//registers 
reg [1:0] state_reg,state_next;
//reg logic
always@(posedge clk , negedge aclr_n)
  begin 
 state_reg<= 2'b00;
  if(aclr_n==0)
   state_reg<= 2'b00;
  else 
   state_reg<=state_next;
  end
//next state logic
always@*
begin 
 if(aclr_n==0)
   state_next= 2'b00;
 else 
   state_next=state_reg+1;
       
end 

assign count_out = state_reg ;

endmodule


module counter_tb();
   reg clk ,aclr_n;
   wire [1:0] count_out ;

counter dut(clk,aclr_n,count_out);
always 
begin
clk=0;
#50;
clk=1;
#50;
end

initial
begin
aclr_n =0;
#100;
aclr_n =1;
#200;
aclr_n =0;
#200;
aclr_n =1;
#400;
end
endmodule
