module shifter(
    input [7:0]inp ,
    input  [1:0]shift_cntrl,
    output reg [15:0] shift_out 

);
    always@*
      begin 
      case(shift_cntrl)
      2'b01:shift_out = inp <<4;
      2'b10:shift_out = inp <<8;
      default:shift_out = inp;
      endcase
      end
endmodule