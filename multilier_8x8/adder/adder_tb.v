module adder_tb();
     reg  [15:0]dataa,datab;
     wire [15:0]sum;
adder dut(.dataa(dataa),.datab(datab),.sum(sum));

initial 
begin
dataa=10;
datab=10;
#50;

dataa=15;
datab=10;
#50;

dataa=11;
datab=25;
#50;
end
endmodule


module adder(
     input  [15:0]dataa,datab,
     output [15:0]sum
);
assign sum = dataa+datab ;
endmodule
