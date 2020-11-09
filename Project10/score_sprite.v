module ScoreSprite
    #(
        parameter WIDTH = 3,
        parameter HEIGHT = 5,
        parameter PIXEL_SIZE = 8
    )
    (
        input [3:0] i_score,
        input [10:0] i_pos_x,
        input [10:0] i_pos_y,
        input [10:0] i_test_x,
        input [10:0] i_test_y,
        output o_test_result
    );

    wire w_output_active_sprite;

    wire w_output_active_sprite_0;
    wire w_output_active_sprite_1;
    wire w_output_active_sprite_2;
    wire w_output_active_sprite_3;
    wire w_output_active_sprite_4;
    wire w_output_active_sprite_5;
    wire w_output_active_sprite_6;
    wire w_output_active_sprite_7;
    wire w_output_active_sprite_8;
    wire w_output_active_sprite_9;

    Sprite #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .PIXEL_SIZE(PIXEL_SIZE)) sprite_0(
        .i_data( { 3'b111, 3'b101, 3'b101, 3'b101, 3'b111 } ),
        .i_pos_x( i_pos_x ),
        .i_pos_y( i_pos_y ),
        .i_test_x( i_test_x ),
        .i_test_y( i_test_y ),
        .o_test_result( w_output_active_sprite_0 )
    );

    Sprite #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .PIXEL_SIZE(PIXEL_SIZE)) sprite_1(
        .i_data( { 3'b010, 3'b010, 3'b010, 3'b010, 3'b010 } ),
        .i_pos_x( i_pos_x ),
        .i_pos_y( i_pos_y ),
        .i_test_x( i_test_x ),
        .i_test_y( i_test_y ),
        .o_test_result( w_output_active_sprite_1 )
    );

    Sprite #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .PIXEL_SIZE(PIXEL_SIZE)) sprite_2(
        .i_data( { 3'b111, 3'b001, 3'b111, 3'b100, 3'b111 } ),
        .i_pos_x( i_pos_x ),
        .i_pos_y( i_pos_y ),
        .i_test_x( i_test_x ),
        .i_test_y( i_test_y ),
        .o_test_result( w_output_active_sprite_2 )
    );

    Sprite #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .PIXEL_SIZE(PIXEL_SIZE)) sprite_3(
        .i_data( { 3'b111, 3'b001, 3'b111, 3'b001, 3'b111 } ),
        .i_pos_x( i_pos_x ),
        .i_pos_y( i_pos_y ),
        .i_test_x( i_test_x ),
        .i_test_y( i_test_y ),
        .o_test_result( w_output_active_sprite_3 )
    );

    Sprite #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .PIXEL_SIZE(PIXEL_SIZE)) sprite_4(
        .i_data( { 3'b101, 3'b101, 3'b111, 3'b001, 3'b001 } ),
        .i_pos_x( i_pos_x ),
        .i_pos_y( i_pos_y ),
        .i_test_x( i_test_x ),
        .i_test_y( i_test_y ),
        .o_test_result( w_output_active_sprite_4 )
    );

    Sprite #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .PIXEL_SIZE(PIXEL_SIZE)) sprite_5(
        .i_data( { 3'b111, 3'b100, 3'b111, 3'b001, 3'b111 } ),
        .i_pos_x( i_pos_x ),
        .i_pos_y( i_pos_y ),
        .i_test_x( i_test_x ),
        .i_test_y( i_test_y ),
        .o_test_result( w_output_active_sprite_5 )
    );

    Sprite #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .PIXEL_SIZE(PIXEL_SIZE)) sprite_6(
        .i_data( { 3'b111, 3'b100, 3'b111, 3'b101, 3'b111 } ),
        .i_pos_x( i_pos_x ),
        .i_pos_y( i_pos_y ),
        .i_test_x( i_test_x ),
        .i_test_y( i_test_y ),
        .o_test_result( w_output_active_sprite_6 )
    );

    Sprite #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .PIXEL_SIZE(PIXEL_SIZE)) sprite_7(
        .i_data( { 3'b111, 3'b001, 3'b001, 3'b001, 3'b001 } ),
        .i_pos_x( i_pos_x ),
        .i_pos_y( i_pos_y ),
        .i_test_x( i_test_x ),
        .i_test_y( i_test_y ),
        .o_test_result( w_output_active_sprite_7 )
    );

    Sprite #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .PIXEL_SIZE(PIXEL_SIZE)) sprite_8(
        .i_data( { 3'b111, 3'b101, 3'b111, 3'b101, 3'b111 } ),
        .i_pos_x( i_pos_x ),
        .i_pos_y( i_pos_y ),
        .i_test_x( i_test_x ),
        .i_test_y( i_test_y ),
        .o_test_result( w_output_active_sprite_8 )
    );

    Sprite #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .PIXEL_SIZE(PIXEL_SIZE)) sprite_9(
        .i_data( { 3'b111, 3'b101, 3'b111, 3'b001, 3'b001 } ),
        .i_pos_x( i_pos_x ),
        .i_pos_y( i_pos_y ),
        .i_test_x( i_test_x ),
        .i_test_y( i_test_y ),
        .o_test_result( w_output_active_sprite_9 )
    );

    reg r_output_active;
    
    always @*
    begin
        case (i_score)
            0: r_output_active = w_output_active_sprite_0;
            1: r_output_active = w_output_active_sprite_1;
            2: r_output_active = w_output_active_sprite_2;
            3: r_output_active = w_output_active_sprite_3;
            4: r_output_active = w_output_active_sprite_4;
            5: r_output_active = w_output_active_sprite_5;
            6: r_output_active = w_output_active_sprite_6;
            7: r_output_active = w_output_active_sprite_7;
            8: r_output_active = w_output_active_sprite_8;
            9: r_output_active = w_output_active_sprite_9;
        endcase
    end

    assign o_test_result = r_output_active;
endmodule
