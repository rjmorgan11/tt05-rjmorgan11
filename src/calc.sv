//`default_nettype none

module tt_um_rjmorgan11_calculator_chip #( parameter MAX_COUNT = 24'd10_000_000 )(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    logic [7:0] state, last_state, tmp;
    logic [2:0] flags;
    logic overflow, neg, zero, enabled_once;
    assign uo_out = (ena) ? state : 8'h00;
    assign uio_out[7:5] = flags;
    assign uio_out[4:0] = 0;
    assign uio_oe = 8'hE0;
    assign flags = {overflow, neg, zero};

    always_ff @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            state <= 8'd0;
            overflow <= 0;
            neg <= 0;
            zero <= 0;
            enabled_once <= 0;
    
        end
        else if (uio_in[0] && enabled_once != 1) begin
            enabled_once <= 1;
            last_state <= state;
            overflow <= 0;
            neg <= 0;
            zero <= 0;
    
            case(uio_in[4:1])
                4'h0: begin
                    state <= state + ui_in; // add
                    zero <= (state + ui_in) == 8'h00;
                    tmp = state + ui_in;
                    overflow <= tmp[7] != last_state[7];
                    neg <= tmp[7];
                end
                4'h1: begin
                    state <= state - ui_in; // subtract
                    zero <= (state - ui_in) == 8'h00;
                    tmp = state - ui_in;
                    overflow <= tmp[7] != last_state[7];
                    neg <= tmp[7];
                end
                4'h2: begin
                    state <= state | ui_in; // or
                    zero <= (state | ui_in) == 8'h00;
            
                end
                4'h3: begin
                    state <= state & ui_in; // and
                    zero <= (state & ui_in) == 8'h00;
            
                end
                4'h4: begin
                    state <= state ^ ui_in; // xor
                    zero <= (state ^ ui_in) == 8'h00;
            
                end
                4'h5: begin
                    state <= state << 1;    // left shift 1
                    zero <= (state << 1) == 8'h00;
            
                end
                4'h6: begin
                    state <= state >> 1;    // right shift 1 logically
                    zero <= (state >> ui_in) == 8'h00;
            
                end
                4'h7: begin
                    state <= state[7] | (state >> 1); // right shift 1 artithmetically
                    zero <= (state[7] | (state >> 1)) == 8'h00;
                    neg <= state[7];
                end
                4'h8: begin
                    state <= ~state + 8'h01; // negate
                    zero <= (~state + 8'h01) == 8'h00;
                    tmp = ~state + 8'h01;
                    overflow <= tmp[7] != last_state[7];
                    neg <= tmp[7];
                end
                4'h9: begin
                    state <= ~state;        // invert
                    zero <= (~state) == 8'h00;
            
                end
                4'ha: begin
                    state <= {state[0], state[1],
                              state[2], state[3],
                              state[4], state[5],
                              state[6], state[7]}; // reverse bit pattern
            
                end
                // 4'hb: // not used
                // 4'hc: // not used
                4'hd: begin
                    state <= state > ui_in; // input less than (unsigned)
                end
                4'he: begin
                    state <= state < ui_in; // input greater than (unsigned)
                end
                4'hf: begin
                    state <= (state == ui_in); // equal to (active low)
                    zero <= state == ui_in;
                end
            endcase
        end
        else if (!uio_in[0]) begin
            enabled_once <= 0;
        end
    end
    endmodule: tt_um_rjmorgan11_calculator_chip
