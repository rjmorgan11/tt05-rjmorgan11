
module calc_tb;
    logic [7:0] ui_in;    // Dedicated inputs
    logic [7:0] uo_out;   // Dedicated outputs
    logic [7:0] uio_in;   // IOs: Input path
    logic [7:0] uio_out;  // IOs: output path
    logic [7:0] uio_oe;   // IOs: Enable path (active high: 0=input, 1=output)
    logic       ena;      // will go high when the design is enabled
    logic       clk;      // clock
    logic       rst_n;     // reset_n - low to reset

    tt_um_rjmorgan11_calculator_chip DUT (.*);
    initial begin
        clk = 0;
        #5 clk = 1;
        forever #5 clk = ~clk;
    end
    task do_reset;
        rst_n = 0;
        @(posedge clk);
        rst_n <= 1;
        @(posedge clk);
    endtask: do_reset

    task send_add(logic [7:0] uin);
        ui_in <= uin;
        uio_in[4:1] <= 8'h00;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);

        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_add

    task send_sub(logic [7:0] uin);
        ui_in <= uin;
        uio_in[4:1] <= 8'h01;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_sub

    task send_or(logic [7:0] uin);
        ui_in <= uin;
        uio_in[4:1] <= 8'h02;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_or

    task send_and(logic [7:0] uin);
        ui_in <= uin;
        uio_in[4:1] <= 8'h03;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_and

    task send_xor(logic [7:0] uin);
        ui_in <= uin;
        uio_in[4:1] <= 8'h04;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_xor

    task send_lft_shft;
        uio_in[4:1] <= 8'h05;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_lft_shft

    task send_rt_shft;
        uio_in[4:1] <= 8'h06;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_rt_shft

    task send_rt_arith_shft;
        uio_in[4:1] <= 8'h07;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_rt_arith_shft

    task send_neg;
        uio_in[4:1] <= 8'h08;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_neg

    task send_inv;
        uio_in[4:1] <= 8'h09;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_inv

    task send_rev;
        uio_in[4:1] <= 8'h0a;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_rev

    task send_lsthn(logic [7:0] uin);
        ui_in <= uin;
        uio_in[4:1] <= 8'h0d;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_lsthn

    task send_grtthn(logic [7:0] uin);
        ui_in <= uin;
        uio_in[4:1] <= 8'h0e;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_grtthn

    task send_equ(logic [7:0] uin);
        ui_in <= uin;
        uio_in[4:1] <= 8'h0f;
        @(posedge clk);
        uio_in[0] <= 1;
        @(posedge clk);
        
        uio_in[0] <= 0;
        @(posedge clk);
    endtask: send_equ

    initial begin
        $monitor("op = 0x%x, in = 0x%x (0b%b), out = 0x%x(0b%b), flags = %b", uio_in[4:1], ui_in, ui_in, uo_out, uo_out, uio_out[7:5]);
        ena = 1;
        do_reset();
        send_add(8'h01);
        send_sub(8'h0f);
        send_or(8'h01);
        send_and(8'h00);
        send_xor(8'h55);
        send_lft_shft();
        send_rt_shft();
        send_rt_arith_shft();
        send_neg();
        send_inv();
        send_rev();
        send_lsthn(8'h7f);
        send_lsthn(8'hff);
        send_grtthn(8'hff);
        send_grtthn(8'h7f);
        send_equ(8'h00);
        $finish;
    end



endmodule: calc_tb