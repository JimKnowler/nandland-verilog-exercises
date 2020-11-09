module Sprite
    #(
        parameter WIDTH = 3,
        parameter HEIGHT = 5,
        parameter PIXEL_SIZE = 8
    )
    (
        input [WIDTH-1:0] i_data [HEIGHT-1:0],
        input [10:0] i_pos_x,
        input [10:0] i_pos_y,
        input [10:0] i_test_x,
        input [10:0] i_test_y,
        output o_test_result
    );

    reg r_test_result;

    always @*
    begin
        if ((i_test_x < i_pos_x) || (i_test_x >= (i_pos_x + (WIDTH * PIXEL_SIZE)) || (i_test_y < i_pos_y) || (i_test_y >= (i_pos_y + (HEIGHT * PIXEL_SIZE)))))
        begin
            r_test_result <= 0;
        end
        else
        begin
            r_test_result <= i_data[HEIGHT - 1 - ((i_test_y - i_pos_y) / PIXEL_SIZE)][WIDTH - 1 - ((i_test_x - i_pos_x) / PIXEL_SIZE)];
        end
    end

    assign o_test_result = r_test_result;
endmodule