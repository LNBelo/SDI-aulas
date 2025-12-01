module latches_sr_tb;
    reg s,r,e;
    wire q_sr_lt_st_nor,  q_sr_lt_st_e_nor,  q_sr_lt_st_nor_t,  q_sr_lt_st_e_nor_t,
         q_sr_lt_st_nand, q_sr_lt_st_e_nand, q_sr_lt_st_nand_t, q_sr_lt_st_e_nand_t;

    sr_latch_structural_nor     sr_lt_st_nor     (s,r,q_sr_lt_st_nor);
    sr_latch_structural_e_nor   sr_lt_st_e_nor   (s,r,e,q_sr_lt_st_e_nor);
    sr_latch_structural_nor_t   sr_lt_st_nor_t   (s,r,q_sr_lt_st_nor_t);
    sr_latch_structural_e_nor_t sr_lt_st_e_nor_t (s,r,e,q_sr_lt_st_e_nor_t);

    sr_latch_structural_nand     sr_lt_st_nand     (~s,~r,q_sr_lt_st_nand);
    sr_latch_structural_e_nand   sr_lt_st_e_nand   (s,r,e,q_sr_lt_st_e_nand);
    sr_latch_structural_nand_t   sr_lt_st_nand_t   (~s,~r,q_sr_lt_st_nand_t);
    sr_latch_structural_e_nand_t sr_lt_st_e_nand_t (s,r,e,q_sr_lt_st_e_nand_t);

    initial begin
        $dumpfile("latches_sr_tb.vcd");
        $dumpvars(0, latches_sr_tb);

        e = 1; s = 0; r = 0;
        #5 s = 1; r = 0; // Set
        #5 s = 0; r = 0; // Hold
        #5 s = 0; r = 1; // Reset
        #5 s = 0; r = 0; // Hold
        #5 e = 0; 
        #5 s = 1; r = 0; // Set
        #5 s = 0; r = 0; // Hold
        #5 s = 0; r = 1; // Reset
        #5 s = 0; r = 0; // Hold
        #5 s = 1; r = 1; // Invalid
        #50 $finish;
    end

endmodule