`timescale 1ns/100ps
/*
`ifdef syn
`include "design_W2_syn.v"
`include "tsmc13_neg.v"
`else
`include "design_W2.v"
`endif
*/
`include "cordic.v"
`define CYCLE  10

module cordic_tb;

  reg clk;
  reg rst;
  reg [8:0] theta;
  
  wire [22:0] cos;
  wire [22:0] sin;
  
  reg [4:0] counter;
  
  cordic cordic(.clk_i  (clk),
                .rst_i  (rst),
                .theta_i(theta),
                .cos_o  (cos),
                .sin_o  (sin));
  /*
  `ifdef syn
    initial $sdf_annotate("design_W2_syn.sdf", design_B1);
  `endif
  */
  always #(`CYCLE/2) clk = ~clk;
  
  initial begin
    $dumpfile("cordic.vcd");
    $dumpvars;
  end
  
  initial begin
                 clk = 1'b0;
	               rst = 1'b0;
  #(`CYCLE/4)    rst = 1'b1;
	#(`CYCLE)      rst = 1'b0;  
  #(`CYCLE*40000)   $finish;  
  end
  
  always@(posedge clk)begin
    if(rst)begin
      counter <= 5'd0;
    end else if(counter==5'd17)begin
      counter <= 5'd0;
    end else begin
      counter <= counter + 5'd1;
    end
  end
  
  always@(negedge clk)begin
    if(rst)begin
      theta <= 9'd0;
    end else if(counter==5'd0 && theta==9'd359)begin
      theta <= 9'd0;
    end else if(counter==5'd0)begin
      theta <= theta + 9'd1;
    end
  end
  
endmodule
