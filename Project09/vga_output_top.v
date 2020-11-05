module vga_output_top(
    input i_Clk,                // 25 Mhz
    
    input i_Switch_1,
    
    output o_Segment2_A,
    output o_Segment2_B,
    output o_Segment2_C,
    output o_Segment2_D,
    output o_Segment2_E,
    output o_Segment2_F,
    output o_Segment2_G,

    output o_VGA_HSync,
    output o_VGA_VSync,
    output o_VGA_Red_0,
    output o_VGA_Red_1,
    output o_VGA_Red_2,
    output o_VGA_Grn_0,
    output o_VGA_Grn_1,
    output o_VGA_Grn_2,
    output o_VGA_Blu_0,
    output o_VGA_Blu_1,
    output o_VGA_Blu_2
);

    //////////////////////////////////////////////////////////////////
    // debounce switch

    wire w_Switch_1;

    Debounce_Switch debounce_switch(
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_1),
        .o_Switch(w_Switch_1)
    );

    reg r_last_switch_1;

    //////////////////////////////////////////////////////////////////
    // use rising edge of debounced switch to increment counter (between 0 and 7)

    reg [3:0] r_test_pattern;

    localparam NUM_TEST_PATTERNS = 8;

    always @(posedge i_Clk) 
    begin
        if (w_Switch_1 && !r_last_switch_1) 
        begin
            if (r_test_pattern < (NUM_TEST_PATTERNS-1))
            begin
                r_test_pattern <= r_test_pattern + 1;
            end
            else
            begin
                r_test_pattern <= 0;
            end
        end

        r_last_switch_1 <= w_Switch_1;
    end

    //////////////////////////////////////////////////////////////////
    // display counter on 7-seg

    wire w_Segment_A;
    wire w_Segment_B;
    wire w_Segment_C;
    wire w_Segment_D;
    wire w_Segment_E;
    wire w_Segment_F;
    wire w_Segment_G;

    Binary_To_7Segment Inst(
        .i_Clk(i_Clk),
        .i_Binary_Num(r_test_pattern),
        .o_Segment_A(w_Segment_A),
        .o_Segment_B(w_Segment_B),
        .o_Segment_C(w_Segment_C),
        .o_Segment_D(w_Segment_D),
        .o_Segment_E(w_Segment_E),
        .o_Segment_F(w_Segment_F),
        .o_Segment_G(w_Segment_G)
    );

    assign o_Segment2_A = ~w_Segment_A;
    assign o_Segment2_B = ~w_Segment_B;
    assign o_Segment2_C = ~w_Segment_C;
    assign o_Segment2_D = ~w_Segment_D;
    assign o_Segment2_E = ~w_Segment_E;
    assign o_Segment2_F = ~w_Segment_F;
    assign o_Segment2_G = ~w_Segment_G;

    //////////////////////////////////////////////////////////////////
    // output test pattern on VGA

    wire w_hsync;
    wire w_vsync;
    wire [9:0] w_x;
    wire [9:0] w_y;
    wire w_active;
    wire [2:0] w_red;
    wire [2:0] w_green;
    wire [2:0] w_blue;
    wire [2:0] w_output_red;
    wire [2:0] w_output_green;
    wire [2:0] w_output_blue;
    wire w_output_hsync;
    wire w_output_vsync;
    
    VGASyncPulseGenerator uut_syncpulse(
        .i_clk(i_Clk),
        .o_hsync(w_hsync),
        .o_vsync(w_vsync),
        .o_x(w_x),
        .o_y(w_y),
        .o_active(w_active)
    );
    
    VGATestPatternGenerator uut_testpattern(
        .i_pattern(r_test_pattern),
        .i_x(w_x),
        .i_y(w_y),
        .o_red(w_red),
        .o_green(w_green),
        .o_blue(w_blue)
    );
  
    VGASyncPorch uut_syncporch(
        .i_red(w_red),
        .i_green(w_green),
        .i_blue(w_blue),
        .i_active(w_active),
        .i_hsync(w_hsync),
        .i_vsync(w_vsync),
        .i_x(w_x),
        .i_y(w_y),
        .o_red(w_output_red),
        .o_green(w_output_green),
        .o_blue(w_output_blue),
        .o_hsync(w_output_hsync),
        .o_vsync(w_output_vsync)
    );

    assign o_VGA_HSync = w_output_hsync;
    assign o_VGA_VSync = w_output_vsync;
    assign o_VGA_Red_0 = w_output_red[0];
    assign o_VGA_Red_1 = w_output_red[1];
    assign o_VGA_Red_2 = w_output_red[2];
    assign o_VGA_Grn_0 = w_output_green[0];
    assign o_VGA_Grn_1 = w_output_green[1];
    assign o_VGA_Grn_2 = w_output_green[2];
    assign o_VGA_Blu_0 = w_output_blue[0];
    assign o_VGA_Blu_1 = w_output_blue[1];
    assign o_VGA_Blu_2 = w_output_blue[2];

endmodule