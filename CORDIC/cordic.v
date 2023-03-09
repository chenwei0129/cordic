module cordic(clk_i, rst_i, theta_i, cos_o, sin_o);

  input clk_i;
  input rst_i;
  input [8:0] theta_i;
  
  output reg signed [22:0] cos_o;
  output reg signed [22:0] sin_o;
  
  reg [21:0] ANGLE [0:15];
  reg signed [23:0] theta_reg;
  reg signed [22:0] x;
  reg signed [22:0] y;
  reg x_minus;
  reg y_minus;
  reg signed [23:0] current_theta;
  
  reg [4:0] counter;
  
  always@(posedge clk_i)begin
    if(counter==5'd17)begin
      cos_o <= (x_minus)?-x:x;
      sin_o <= (y_minus)?-y:y;
    end
  end
  
  always@(posedge clk_i or posedge rst_i)begin
    if(rst_i)begin
      ANGLE[0] <= 22'd2949120;
      ANGLE[1] <= 22'd1740992;
      ANGLE[2] <= 22'd919872;
      ANGLE[3] <= 22'd466944;
      ANGLE[4] <= 22'd234368;
      ANGLE[5] <= 22'd117312;
      ANGLE[6] <= 22'd58688;
      ANGLE[7] <= 22'd29312;
      ANGLE[8] <= 22'd14656;
      ANGLE[9] <= 22'd7360;
      ANGLE[10] <= 22'd3648;
      ANGLE[11] <= 22'd1856;
      ANGLE[12] <= 22'd896;
      ANGLE[13] <= 22'd448;
      ANGLE[14] <= 22'd256;
      ANGLE[15] <= 22'd128;
    end
  end
  
  always@(posedge clk_i)begin
    if(counter==5'd0)begin
      if(theta_i>=9'd270) theta_reg <= (9'd360-theta_i)<<<16;//+x, -y
      else if(theta_i>=9'd180) theta_reg <= (theta_i-9'd180)<<<16;//-x, -y
      else if(theta_i>=9'd90) theta_reg <= (9'd180-theta_i)<<<16;//-x, +y
      else theta_reg <= theta_i<<<16;
    end
  end
  
  always@(posedge clk_i)begin
    if(counter==5'd0)begin
      if(theta_i>=9'd270)begin
        x_minus <= 1'b0;
        y_minus <= 1'b1;
      end else if(theta_i>=9'd180)begin
        x_minus <= 1'b1;
        y_minus <= 1'b1;
      end else if(theta_i>=9'd90)begin
        x_minus <= 1'b1;
        y_minus <= 1'b0;
      end else begin
        x_minus <= 1'b0;
        y_minus <= 1'b0;
      end
    end
  end
  
  always@(posedge clk_i or posedge rst_i)begin
    if(rst_i)begin
      counter <= 5'd0;
    end else if(counter==5'd17)begin
      counter <= 5'd0;
    end else begin
      counter <= counter + 5'd1;
    end
  end
  
  always@(posedge clk_i)begin
    if(counter==5'd0)begin
      current_theta <= 24'd0;
      x <= 22'h09b74;
      y <= 22'h0;
    end else if(current_theta<=theta_reg)begin
      current_theta <= current_theta + ANGLE[counter-5'd1];
      x <= x - (y>>>(counter-5'd1));
      y <= y + (x>>>(counter-5'd1));
    end else begin
      current_theta <= current_theta - ANGLE[counter-5'd1];
      x <= x + (y>>>(counter-5'd1));
      y <= y - (x>>>(counter-5'd1));
    end
  end
  
endmodule