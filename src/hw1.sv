//`default_nettype none

module tt_um_rjmorgan11_calculator_chip #( parameter MAX_COUNT = 24'd10_000_000 )(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    //input  wire [7:0] uio_in,   // IOs: Input path
    //output wire [7:0] uio_out,  // IOs: Output path
    //output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    //input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
// Wouldn't the buttons be active low on a real design?
    logic [7:0] state;
    assign uo_out = state;


  always_ff @(posedge clk, posedge rst_n) begin
        if (rst_n) begin
            state <= 8'd0;
        end
        else if (uio_in[0]) begin
            case(uio_in[2:1])
                2'b00: state <= state + ui_in;
                2'b01: state <= state - ui_in;
                2'b10: state <= state | ui_in;
                2'b11: state <= (state == ui_in) ? 1 : 0;
            endcase
        end
    end
    endmodule: tt_um_rjmorgan11_calculator_chip
