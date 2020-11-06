module Rectangle(
    input [10:0] i_left,
    input [10:0] i_top,
    input [10:0] i_right,
    input [10:0] i_bottom,
    input [10:0] i_test_x,
    input [10:0] i_test_y,
    output o_is_xy_inside
);

    reg r_is_xy_inside;

    always @*
    begin
        r_is_xy_inside = (i_test_x >= i_left) & (i_test_x < i_right) & (i_test_y >= i_top) & (i_test_y < i_bottom);
    end

    assign o_is_xy_inside = r_is_xy_inside;

endmodule
