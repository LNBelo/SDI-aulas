module ff_tb;
    reg d, clk;
    wire q_dff_str, q_dff_str_t, q_dff_alwa, q_dff_alwa_t;

    d_flipflop_structural dff_str (d, clk, q_dff_str);
    d_flipflop_structural_t dff_str_t (d, clk, q_dff_str_t);
    d_flipflop_behavioral_always dff_alwa (d, clk, q_dff_alwa);
    d_flipflop_behavioral_always_t dff_alwa_t (d, clk, q_dff_alwa_t);

    initial begin
        $dumpfile("ff_tb.vcd");
        $dumpvars(0, ff_tb);

        clk = 0; d = 0;
        #5 d = 1;
        #10 clk = 1; #10 clk = 0; // Clock pulse
        #5 d = 0;
        #10 clk = 1; #10 clk = 0; // Clock pulse
        #5 d = 1;
        #10 clk = 1; #10 clk = 0; // Clock pulse
        #5 d = 0;
        #10 clk = 1; #10 clk = 0; // Clock pulse
        #5 $finish;
    end

endmodule