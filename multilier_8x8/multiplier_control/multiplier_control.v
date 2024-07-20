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
