module VGASyncPulseGenerator
  #(
    parameter WIDTH = 800,   
    parameter HEIGHT = 525,
    parameter WIDTH_ACTIVE = 640,
    parameter HEIGHT_ACTIVE = 480
  )
  (
    input i_clk,
    output o_hsync,
    output o_vsync,
    output [10:0] o_x,
    output [10:0] o_y,
    output o_active
  );
  
  reg [10:0] r_counter_x;
  reg [10:0] r_counter_y;
  
  always @(posedge i_clk)
    begin
      if (r_counter_x < (WIDTH-1))
        begin
          r_counter_x <= r_counter_x + 1;
        end
      else
        begin
          r_counter_x <= 0;
          
          if (r_counter_y < (HEIGHT-1))
            begin
              r_counter_y <= r_counter_y + 1;
            end
          else
            begin
              r_counter_y <= 0;
            end           
        end
    end
  
  assign o_hsync = (r_counter_x < WIDTH_ACTIVE);
  assign o_vsync = (r_counter_y < HEIGHT_ACTIVE);
  assign o_x = r_counter_x;
  assign o_y = r_counter_y;
  assign o_active = (r_counter_x < WIDTH_ACTIVE) && (r_counter_y < HEIGHT_ACTIVE);

endmodule