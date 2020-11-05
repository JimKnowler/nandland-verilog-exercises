module VGASyncPorch
  #(
    parameter WIDTH = 800,   
    parameter HEIGHT = 525,
    parameter WIDTH_ACTIVE = 640,
    parameter HEIGHT_ACTIVE = 480,
    parameter FRONT_PORCH_X = 18,
    parameter BACK_PORCH_X = 50,
    parameter FRONT_PORCH_Y = 10,
    parameter BACK_PORCH_Y = 33
  )  
  (
    input [2:0] i_red,
    input [2:0] i_green,
    input [2:0] i_blue,
    input i_active,
    input i_hsync,
    input i_vsync,
    input [9:0] i_x,
    input [9:0] i_y,
    output [2:0] o_red,
    output [2:0] o_green,
    output [2:0] o_blue,
    output o_hsync,
    output o_vsync
  );
  
  assign o_hsync = i_hsync || (i_x < (WIDTH_ACTIVE + FRONT_PORCH_X)) || (i_x >= (WIDTH - BACK_PORCH_X));
  assign o_vsync = i_vsync || (i_y < (HEIGHT_ACTIVE + FRONT_PORCH_Y)) || (i_y >= (HEIGHT - BACK_PORCH_Y));
      
  assign o_red[2:0] = i_active ? i_red[2:0] : 0;
  assign o_green[2:0] = i_active ? i_green[2:0] : 0;
  assign o_blue[2:0] = i_active ? i_blue[2:0] : 0;
  
endmodule