module mux (
 input [3:0] mux_in_a,mux_in_b,
 input mux_sel,
 output reg [3:0] mux_out
);
   always @*
   begin 
     case(mux_sel)
     1'b0 : mux_out = mux_in_a;
     1'b1 : mux_out = mux_in_b;
     default :mux_out =4'bx;
     endcase
   end
endmodule

module mux_tb();

 reg [3:0] mux_in_a,mux_in_b;
 reg mux_sel;
 wire [3:0] mux_out;
mux dut(mux_in_a,mux_in_b,mux_sel,mux_out);
initial
begin
mux_in_a=8;
mux_in_b=12;
mux_sel=0;
#100;
mux_sel=1;
#100;
mux_sel=1'bz;
#100;


end

endmodule
