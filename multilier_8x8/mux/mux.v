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