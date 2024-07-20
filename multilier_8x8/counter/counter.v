/*module counter(
   input clk ,aclr_n,
   output reg [1:0] count_out 
);
always@(posedge clk , posedge aclr_n)
  begin 
  count_out<= 2'b00;
  if(aclr_n==0)
   count_out<= 2'b00;
  else 
   count_out<=count_out+1;
  
  end
endmodule*/



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

