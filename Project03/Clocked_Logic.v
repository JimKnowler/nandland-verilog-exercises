module Clocked_Logic(
    input i_Clk,
    input i_Switch_1,
    output o_LED_1
);

reg r_LED_1 = 1'b0;
reg r_Switch_1 = 1'b0;

always @(posedge i_Clk) begin
    r_Switch_1 <= i_Switch_1;       // Creates a Register

    if ((i_Switch_1 == 1'b0) && (r_Switch_1 == 1'b1))   // (detect) Falling Edge (of switch)
        begin
            r_LED_1 <= ~r_LED_1;    // Toggles the LED
        end
end

assign o_LED_1 = r_LED_1;

endmodule