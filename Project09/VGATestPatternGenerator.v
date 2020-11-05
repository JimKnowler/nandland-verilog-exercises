module VGATestPatternGenerator(
  input [2:0] i_pattern,
  input [9:0] i_x,
  input [9:0] i_y,
  output [2:0] o_red,
  output [2:0] o_green,
  output [2:0] o_blue
);
  
  localparam NUM_PATTERNS = 8;

  wire [2:0] pattern_red [NUM_PATTERNS-1:0];
  wire [2:0] pattern_green [NUM_PATTERNS-1:0];
  wire [2:0] pattern_blue [NUM_PATTERNS-1:0];
  
  ////////////////////////////////////////////////////////////////////
  // pattern 0 => BLACK
    
  assign pattern_red[0][2:0] = 0;
  assign pattern_green[0][2:0] = 0;
  assign pattern_blue[0][2:0] = 0;
  
  ////////////////////////////////////////////////////////////////////
  // pattern 1 => RED
  
  assign pattern_red[1][2:0] = 3'b111;
  assign pattern_green[1][2:0] = 0;
  assign pattern_blue[1][2:0] = 0;
  
  ////////////////////////////////////////////////////////////////////
  // pattern 2 => GREEN
  
  assign pattern_red[2][2:0] = 0;
  assign pattern_green[2][2:0] = 3'b111;
  assign pattern_blue[2][2:0] = 0;
  
  ////////////////////////////////////////////////////////////////////
  // pattern 3 => BLUE
  
  assign pattern_red[3][2:0] = 0;
  assign pattern_green[3][2:0] = 0;
  assign pattern_blue[3][2:0] = 3'b111;
  
  ////////////////////////////////////////////////////////////////////
  // pattern 4 => CHECKERBOARD
  
  wire [2:0] pattern_checkerboard;
  assign pattern_checkerboard[2:0] = ((i_x >> 4) != 0) && ((i_y >> 4) != 0) ? 3'b111 : 0;
  assign pattern_red[4][2:0] = pattern_checkerboard;
  assign pattern_green[4][2:0] = pattern_checkerboard;
  assign pattern_blue[4][2:0] = pattern_checkerboard;
  
  ////////////////////////////////////////////////////////////////////
  // pattern 5 => COLUMNS
  
  assign pattern_red[5][2:0] = ((i_x >> 4) != 0) ? 3'b111 : 0;
  assign pattern_green[5][2:0] = ((i_x >> 5) != 0) ? 3'b111 : 0;
  assign pattern_blue[5][2:0] = ((i_x >> 6) != 0) ? 3'b111 : 0;
  
  ////////////////////////////////////////////////////////////////////
  // pattern 6 => ROWS
  
  assign pattern_red[6][2:0] = ((i_y >> 4) != 0) ? 3'b111 : 0;
  assign pattern_green[6][2:0] = ((i_y >> 5) != 0) ? 3'b111 : 0;
  assign pattern_blue[6][2:0] = ((i_y >> 6) != 0) ? 3'b111 : 0;
  
  ////////////////////////////////////////////////////////////////////
  // pattern 7 => WHITE
  
  assign pattern_red[7][2:0] = 3'b111;
  assign pattern_green[7][2:0] = 3'b111;
  assign pattern_blue[7][2:0] = 3'b111;
  
  ////////////////////////////////////////////////////////////////////
  // drive outputs
  
  wire [2:0] w_pattern;
  assign w_pattern = (i_pattern < NUM_PATTERNS) ? i_pattern : 0;
  
  assign o_red[2:0] = pattern_red[w_pattern][2:0];
  assign o_green[2:0] = pattern_green[w_pattern][2:0];
  assign o_blue[2:0] = pattern_blue[w_pattern][2:0];  
  
endmodule