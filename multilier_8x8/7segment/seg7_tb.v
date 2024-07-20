module seg7 (
    input [2:0] inp,
    output seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g

);
reg [6:0] seg ;
assign {seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g}=seg;
     always@*
         begin
            case(inp)
             3'b000: seg=7'b1111110;
             3'b001: seg=7'b0110000;
             3'b010: seg=7'b1101101;
             3'b011: seg=7'b1111001;
             default: seg=7'b1001111;
             endcase 
         end
endmodule


module seg7_tb ();
    reg [2:0] inp;
   wire seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g;
seg7 dut(inp,seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g);

initial
begin
inp=3'b000; #100;
inp=3'b001; #100;
inp=3'b011; #100;
inp=3'b111; #100;
end

wire[6:0] seg ;
assign seg={seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g};
endmodule
