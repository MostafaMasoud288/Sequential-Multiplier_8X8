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
