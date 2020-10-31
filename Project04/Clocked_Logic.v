module Clocked_Logic
    (input i_Clk,
    input i_Switch_1,
    output o_LED_1,
    output o_LED_2);

    reg r_LED_1 = 1'b0;         // can give initial conditions to reg
    reg r_Switch_1 = 1'b0;

    wire w_Switch_1;            // can not give initial conditions to wire

    // instantiate Debounce Filter
    Debounce_Switch Instance(
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_1),
        .o_Switch(w_Switch_1)
    );

    always @(posedge i_Clk) begin
        r_Switch_1 <= w_Switch_1;       // Creates a Register

        if ((w_Switch_1 == 1'b0) && (r_Switch_1 == 1'b1))   // (detect) Falling Edge (of switch)
            begin
                r_LED_1 <= ~r_LED_1;    // Toggles the LED
            end
    end

    assign o_LED_1 = r_LED_1;

    assign o_LED_2 = 1;

endmodule