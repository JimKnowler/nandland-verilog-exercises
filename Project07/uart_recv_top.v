module uart_recv_top(
    input i_Clk,
    input i_UART_RX,

    // segment1 - upper digit
    output o_Segment1_A,
    output o_Segment1_B,
    output o_Segment1_C,
    output o_Segment1_D,
    output o_Segment1_E,
    output o_Segment1_F,
    output o_Segment1_G,

    // segment2 - lower digit
    output o_Segment2_A,
    output o_Segment2_B,
    output o_Segment2_C,
    output o_Segment2_D,
    output o_Segment2_E,
    output o_Segment2_F,
    output o_Segment2_G,

    // LEDs
    output o_LED_1,
    output o_LED_2,
    output o_LED_3,
    output o_LED_4,

    // PMOD
    output o_PMOD_1
);

wire w_RX_DV;
wire [7:0] w_RX_Byte;

// todo: could use posedge of w_RX_DV to
//       drive copying w_RX_Byte to a local register

wire w_Segment1_A;
wire w_Segment1_B;
wire w_Segment1_C;
wire w_Segment1_D;
wire w_Segment1_E;
wire w_Segment1_F;
wire w_Segment1_G;

wire w_Segment2_A;
wire w_Segment2_B;
wire w_Segment2_C;
wire w_Segment2_D;
wire w_Segment2_E;
wire w_Segment2_F;
wire w_Segment2_G;

// UART Receiver
uart_recv uart_recv_inst(
    .i_clk(i_Clk),
    .i_rx_serial(i_UART_RX),
    .o_rx_dv(w_RX_DV),
    .o_rx_byte(w_RX_Byte)
);

// Binary to 7 Segment - upper digit
Binary_To_7Segment sevenSegUpper(
    .i_Clk(i_Clk),
    .i_Binary_Num(w_RX_Byte[7:4]),
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

// Binary to 7 Segment - lower digit
Binary_To_7Segment sevenSegLower(
    .i_Clk(i_Clk),
    .i_Binary_Num(w_RX_Byte[3:0]),
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


// DEBUG - write RX_Byte directly to LED
//         to monitor incoming traffic
assign o_LED_1 = w_RX_Byte[0];
assign o_LED_2 = w_RX_Byte[1];
assign o_LED_3 = w_RX_Byte[2];
assign o_LED_4 = w_RX_Byte[3];

// DEBUG - attach scope to this and debug!
assign o_PMOD_1 = i_UART_RX;

endmodule
