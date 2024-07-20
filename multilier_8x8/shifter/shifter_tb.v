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


module shifter_tb();
    reg [7:0]inp ;
    reg  [1:0]shift_cntrl;
    wire [15:0] shift_out ;
shifter dut(inp,shift_cntrl,shift_out);
initial
begin
inp=1;
shift_cntrl=1;#100;
shift_cntrl=2;#100;
shift_cntrl=3;#100;

end

endmodule