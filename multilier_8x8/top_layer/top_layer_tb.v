module top_layer_tb
(
);
reg [7:0] dataa;
reg [7:0] datab;
reg start;
reg reset_a;
reg clk;
wire done_flag;
wire [15:0] product8x8_out;
wire seg_a;
wire seg_b;
wire seg_c;
wire seg_d;
wire seg_e;
wire seg_f;
wire seg_g;
localparam T=100;

top_layer multiplier(.dataa(dataa),.datab(datab),.start(start),.reset_a(reset_a),.clk(clk),
       .done_flag(done_flag),.product8x8_out(product8x8_out),
      .seg_a(seg_a),.seg_b(seg_b),.seg_c(seg_c),.seg_d(seg_d),
      .seg_e(seg_e),.seg_f(seg_f),.seg_g(seg_g));

always
begin
clk=1'b1;
#(T/2);
clk=1'b0;
#(T/2);
end

initial 
begin
reset_a=1'b0;
start=1'b0;
dataa=8'b11111111;//255
datab=8'b11111110;//254
#(100);
reset_a=1'b1;
start=1'b1;
#(100);
start=1'b0;
#(400)
reset_a=1'b0;
start=1'b0;
dataa=8'b00001010;//10
datab=8'b00101000;//40
#(100);
reset_a=1'b1;
start=1'b1;
#(100);
start=1'b0;

end
endmodule



//////
module top_layer(
    input [7:0] dataa,datab,
    input start ,reset_a,clk,
    output done_flag,
    output seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,
    output [15:0] product8x8_out
);
///needed wires
wire sclr_n,clk_ena;
wire [1:0] sel,shift,count;
wire [2:0] state_out;
wire [3:0] aout,bout;
wire [7:0] product;
wire [15:0] sum,shift_out;


/////instantiation//////
mux dut1(.mux_in_a(dataa[3:0]),.mux_in_b(dataa[7:4]),.mux_sel(sel[1]),.mux_out(aout[3:0]));
mux dut2(.mux_in_a(datab[3:0]),.mux_in_b(datab[7:4]),.mux_sel(sel[0]),.mux_out(bout[3:0]));

mul dut3(.dataa(aout),.datab(bout),.product(product));

shifter dut4(.inp(product),.shift_cntrl(shift),.shift_out(shift_out));

adder dut5(.dataa(shift_out),.datab(product8x8_out),.sum(sum));

counter dut6(.clk(clk),.aclr_n(~start),.count_out(count));

reg16 dut7(.clk(clk),.sclr_n(sclr_n),.clk_ena(clk_ena),.datain(sum),.reg_out(product8x8_out));

multiplier_control dut8(.clk(clk),
    .reset_a(reset_a),
    .start(start),
    .count(count),
    .input_sel(sel),
    .shift_sel(shift),
    .state_out(state_out),
    .done(done_flag),
    .clk_ena(clk_ena),
    .sclr_n(sclr_n));

seg7 dut9(state_out,seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g);

endmodule

////mux////
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

////mult4x4////
module mul(
          input [3:0] dataa,datab,
          output[7:0] product

 );
assign product = dataa * datab;
endmodule

////shifter////
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

///adder///
module adder(
     input  [15:0]dataa,datab,
     output [15:0]sum
);
assign sum = dataa+datab ;
endmodule

////counter///
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

/////register////
module reg16 (
     input clk,sclr_n,clk_ena,
     input[15:0] datain ,
     output reg [15:0]reg_out);

     always@(posedge clk)
       begin
         if (clk_ena==1 &sclr_n==0)
                reg_out=16'b0 ;
         else if (clk_ena==1 &sclr_n==1)
                reg_out=datain ;
         else 
                reg_out=reg_out;
       end
endmodule


////fsm///
module  multiplier_control (
        
          input clk ,start ,reset_a,
          input [1:0] count ,
          output reg done , clk_ena ,sclr_n,
          output reg [1:0] input_sel ,shift_sel,
          output  reg [2:0] state_out
);
//states.........
reg [2:0] state_reg,next_state;

localparam idle = 3'b000;
localparam lsb = 3'b001;
localparam mid = 3'b010;
localparam msb = 3'b011;
localparam calc_done = 3'b100;
localparam eer = 3'b101;

always@(posedge clk , negedge reset_a)
begin
    if(!reset_a)
        state_reg<=idle;
    else
        state_reg<=next_state;
end
/// next state logic 
always@*
begin
  state_out=idle;
  done =0;
  clk_ena=0;
  sclr_n=0;
  input_sel=0;
  shift_sel=0;
  case(state_reg)
  idle:
  begin
  state_out=0;
    if(start==0)
    begin
    next_state=idle;
    input_sel=2'bxx;
    shift_sel=2'bxx;
    done =0;
    clk_ena=0;
    sclr_n=1;
    end
    else
    begin
    next_state=lsb;
    input_sel=2'bxx;
    shift_sel=2'bxx;
    done =0;
    clk_ena=1;
    sclr_n=0;
    end
  end

 lsb:
  begin
  state_out=1;
    if(start==0&&count==2'b00)
    begin
    next_state=mid;
    input_sel=2'b00;
    shift_sel=2'b00;
    done =0;
    clk_ena=1;
    sclr_n=1;
    end
    else
    begin
    next_state=eer;
    input_sel=2'bxx;
    shift_sel=2'bxx;
    done =0;
    clk_ena=0;
    sclr_n=1;
    end
  end

mid:
  begin
  state_out=2;
    if(start==0&&count==2'b01)
    begin
    next_state=mid;
    input_sel=2'b01;
    shift_sel=2'b01;
    done =0;
    clk_ena=1;
    sclr_n=1;
    end
    else if(start==0&&count==2'b10)
    begin
    next_state=msb;
    input_sel=2'b10;
    shift_sel=2'b01;
    done =0;
    clk_ena=1;
    sclr_n=1;
    end
    else
    begin
    next_state=eer;
    input_sel=2'bxx;
    shift_sel=2'bxx;
    done =0;
    clk_ena=0;
    sclr_n=1;
    end
  end

msb:
  begin
  state_out=3;
    if(start==0&&count==2'b11)
    begin
    next_state=calc_done;
    input_sel=2'b11;
    shift_sel=2'b10;
    done =0;
    clk_ena=1;
    sclr_n=1;
    end
    else
    begin
    next_state=eer;
    input_sel=2'bxx;
    shift_sel=2'bxx;
    done =0;
    clk_ena=0;
    sclr_n=1;
    end
  end

calc_done:
  begin
  state_out=4;
    if(start==0)
    begin
    next_state=idle;
    input_sel=2'bxx;
    shift_sel=2'bxx;
    done =1;
    clk_ena=0;
    sclr_n=1;
    end
    else
    begin
    next_state=eer;
    input_sel=2'bxx;
    shift_sel=2'bxx;
    done =0;
    clk_ena=0;
    sclr_n=1;
    end
  end

eer:
  begin
  state_out=5;
    if(start==0)
    begin
    next_state=eer;
    input_sel=2'bxx;
    shift_sel=2'bxx;
    done =0;
    clk_ena=0;
    sclr_n=1;
    end
    else
    begin
    next_state=lsb;
    input_sel=2'bxx;
    shift_sel=2'bxx;
    done =0;
    clk_ena=1;
    sclr_n=0;
    end
  end

default:
begin
next_state=state_reg;
state_out=0;
end


endcase


end

endmodule

///seven segment///
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