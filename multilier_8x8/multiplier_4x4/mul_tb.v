module mul_tb();
          reg [3:0] dataa,datab;
          wire [7:0] product;

initial 
begin
dataa=11;
datab=10;
#100;
dataa=0;
datab=8;
#100;
end
mul dut(.dataa(dataa),.datab(datab),.product(product));
endmodule

module mul(
          input [3:0] dataa,datab,
          output[7:0] product

 );
assign product = dataa * datab;
endmodule