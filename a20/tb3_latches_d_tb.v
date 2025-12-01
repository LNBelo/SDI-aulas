module latches_d_tb;
    reg d, e;
    wire q_d_lt_str, q_d_lt_str_t, 
         q_d_lt_cond, q_d_lt_cond_t,
         q_d_lt_alwa, q_d_lt_alwa_t; 

    d_latch_structural d_lt_structural (d, e, q_d_lt_str);
    d_latch_structural_t d_lt_structural_t (d, e, q_d_lt_str_t);
    d_latch_behavioral_conditionalAssignment d_lt_behavioral_cond (d, e, q_d_lt_cond);
    d_latch_behavioral_conditionalAssignment_t d_lt_behavioral_cond_t (d, e, q_d_lt_cond_t);
    d_latch_behavioral_always d_lt_behavioral_always (d, e, q_d_lt_alwa);
    d_latch_behavioral_always_t d_lt_behavioral_always_t (d, e, q_d_lt_alwa_t);

    initial begin
        $dumpfile("latches_d_tb.vcd");
        $dumpvars(0, latches_d_tb);

        e = 1; d = 0;
        #5 d = 1; // Set
        #5 d = 0; // Reset
        #5 d = 1; // Set
        #5 d = 0; // Reset
        #5 e = 0; d = 0;
        #5 d = 1; // Set (enable=0)
        #5 d = 0; // Reset (enable=0)
        #5 $finish;
    end

endmodule