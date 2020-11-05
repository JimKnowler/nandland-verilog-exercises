module pong_top(
    input i_Clk,                // 25 Mhz

    input i_UART_RX,
    output o_UART_TX,
    
    input i_Switch_1,
    input i_Switch_2,
    input i_Switch_3,
    input i_Switch_4,

    output o_LED_1,
    output o_LED_2,
    output o_LED_3,
    output o_LED_4,
    
    output o_Segment1_A,
    output o_Segment1_B,
    output o_Segment1_C,
    output o_Segment1_D,
    output o_Segment1_E,
    output o_Segment1_F,
    output o_Segment1_G,

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
    // Paddle positions + Scores

    reg [10:0] r_paddle_y_1;
    reg [3:0] r_score_1;

    reg [10:0] r_paddle_y_2;
    reg [3:0] r_score_2;

    //////////////////////////////////////////////////////////////////
    // debounce switches

    wire w_Switch_1;
    wire w_Switch_2;
    wire w_Switch_3;
    wire w_Switch_4;

    Debounce_Switch debounce_switch_1(
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_1),
        .o_Switch(w_Switch_1)
    );

    Debounce_Switch debounce_switch_2(
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_2),
        .o_Switch(w_Switch_2)
    );

    Debounce_Switch debounce_switch_3(
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_3),
        .o_Switch(w_Switch_3)
    );

    Debounce_Switch debounce_switch_4(
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_4),
        .o_Switch(w_Switch_4)
    );

    assign o_LED_1 = w_Switch_1;
    assign o_LED_2 = w_Switch_2;
    assign o_LED_3 = w_Switch_3;
    assign o_LED_4 = w_Switch_4;

    //////////////////////////////////////////////////////////////////
    // display scores on 7-seg

    wire w_Segment1_A;
    wire w_Segment1_B;
    wire w_Segment1_C;
    wire w_Segment1_D;
    wire w_Segment1_E;
    wire w_Segment1_F;
    wire w_Segment1_G;

    Binary_To_7Segment score_7segment_1(
        .i_Clk(i_Clk),
        .i_Binary_Num(r_score_1),
        .o_Segment_A(w_Segment1_A),
        .o_Segment_B(w_Segment1_B),
        .o_Segment_C(w_Segment1_C),
        .o_Segment_D(w_Segment1_D),
        .o_Segment_E(w_Segment1_E),
        .o_Segment_F(w_Segment1_F),
        .o_Segment_G(w_Segment1_G)
    );

    assign o_Segment1_A = ~w_Segment1_A;
    assign o_Segment1_B = ~w_Segment1_B;
    assign o_Segment1_C = ~w_Segment1_C;
    assign o_Segment1_D = ~w_Segment1_D;
    assign o_Segment1_E = ~w_Segment1_E;
    assign o_Segment1_F = ~w_Segment1_F;
    assign o_Segment1_G = ~w_Segment1_G;

    wire w_Segment2_A;
    wire w_Segment2_B;
    wire w_Segment2_C;
    wire w_Segment2_D;
    wire w_Segment2_E;
    wire w_Segment2_F;
    wire w_Segment2_G;

    Binary_To_7Segment score_7segment_2(
        .i_Clk(i_Clk),
        .i_Binary_Num(r_score_2),
        .o_Segment_A(w_Segment2_A),
        .o_Segment_B(w_Segment2_B),
        .o_Segment_C(w_Segment2_C),
        .o_Segment_D(w_Segment2_D),
        .o_Segment_E(w_Segment2_E),
        .o_Segment_F(w_Segment2_F),
        .o_Segment_G(w_Segment2_G)
    );

    assign o_Segment2_A = ~w_Segment2_A;
    assign o_Segment2_B = ~w_Segment2_B;
    assign o_Segment2_C = ~w_Segment2_C;
    assign o_Segment2_D = ~w_Segment2_D;
    assign o_Segment2_E = ~w_Segment2_E;
    assign o_Segment2_F = ~w_Segment2_F;
    assign o_Segment2_G = ~w_Segment2_G;

    //////////////////////////////////////////////////////////////////
    // UART for restarting game

    wire w_RX_DV;
    wire [7:0] w_RX_Byte;

    wire w_TX_Active;
    wire w_TX_Serial;
    wire w_TX_Done;

    // UART Receiver
    uart_recv uart_recv_inst(
        .i_clk(i_Clk),
        .i_rx_serial(i_UART_RX),
        .o_rx_dv(w_RX_DV),
        .o_rx_byte(w_RX_Byte)
    );

    // UART transmitter
    uart_send uart_send_inst(
        .i_clk(i_Clk),
        .i_tx_dv(w_RX_DV),              // pass RX to TX for loopback
        .i_tx_byte(w_RX_Byte),          // pass RX to TX for loopback
        .o_tx_active(w_TX_Active),
        .o_tx_serial(w_TX_Serial),
        .o_tx_done(w_TX_Done)
    );

    // drive UART line high when transmitter is not active
    assign o_UART_TX = w_TX_Active ? w_TX_Serial : 1'b1;

    //////////////////////////////////////////////////////////////////
    // VGA output

    wire w_hsync;
    wire w_vsync;
    wire [10:0] w_x;
    wire [10:0] w_y;
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

    //////////////////////////////////////////////////////////////////
    // PONG Game

    reg [15:0] clock_divider;

    always @(posedge i_Clk)
    begin
        clock_divider <= clock_divider + 1;

        if (&clock_divider == 1)
        begin
            // todo: limit paddle positions
            if (w_Switch_1)
                r_paddle_y_1 <= r_paddle_y_1 - 1;
            else if (w_Switch_2)
                r_paddle_y_1 <= r_paddle_y_1 + 1;

            if (w_Switch_3)
                r_paddle_y_2 <= r_paddle_y_2 - 1;
            else if (w_Switch_4)
                r_paddle_y_2 <= r_paddle_y_2 + 1;

        end
    end

    wire output_active;
    reg output_active_paddle1;
    reg output_active_paddle2;

    localparam PADDLE_WIDTH = 20;
    localparam PADDLE_HEIGHT = 100;
    localparam PADDLE_HALFHEIGHT = PADDLE_HEIGHT / 2;

    localparam WIDTH_ACTIVE = 640;

    always @*
    begin
        output_active_paddle1 = (w_x < PADDLE_WIDTH) & (w_y > (r_paddle_y_1-PADDLE_HALFHEIGHT)) & (w_y < (r_paddle_y_1+PADDLE_HALFHEIGHT));

        output_active_paddle2 = (w_x > (WIDTH_ACTIVE-PADDLE_WIDTH)) & (w_y > (r_paddle_y_2-PADDLE_HALFHEIGHT)) & (w_y < (r_paddle_y_2+PADDLE_HALFHEIGHT));
        //output_active_paddle2 = 0;
    end

    assign output_active = output_active_paddle1 | output_active_paddle2;
    
    assign w_red = output_active ? 3'b111 : 3'b000;
    assign w_green = output_active ? 3'b111 : 3'b000;
    assign w_blue = output_active ? 3'b111 : 3'b000;

endmodule