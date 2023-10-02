`default_nettype none

module tt_um_rjmorgan11_calculator_chip (
    input  logic [7:0] NumIn,
  	input  logic [1:0] OpIn,
    input  logic       Enter, Reset, clock,
    output logic [7:0] NumOut);
// Wouldn't the buttons be active low on a real design?
    logic [7:0] state;
    logic reset, enter;
    assign reset = Reset;
    assign enter = Enter;
    assign NumOut = state;


  always_ff @(posedge clock, posedge reset) begin
        if (reset) begin
            state <= 8'd0;
        end
        else if (enter) begin
            case(OpIn)
                2'b00: state <= state + NumIn;
                2'b01: state <= state - NumIn;
                2'b10: state <= state | NumIn;
                2'b11: state <= (state == NumIn) ? 1 : 0;
            endcase
        end
    end
    endmodule: calculator_chip
