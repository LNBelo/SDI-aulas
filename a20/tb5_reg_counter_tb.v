module reg_counters_tb;
    reg clk, rst;
    wire [3:0] q_cnt_dff1, q_cnt_dff2, q_cnt_tff, q_cnt_awl;
    wire [3:0] q_simple_reg;

    cnt_dff1 #(4) counter_dff1 (clk, rst, q_cnt_dff1);
    cnt_dff2 #(4) counter_dff2 (clk, rst, q_cnt_dff2);
    cnt_tff #(4) counter_tff (clk, rst, q_cnt_tff);
    cnt_always #(4) counter_alw (clk, rst, q_cnt_awl);
    simple_reg #(4) simple_register (clk, rst, 4'b1010, q_simple_reg);

    initial begin
        $dumpfile("reg_counter_tb.vcd");
        $dumpvars(0, reg_counters_tb);

        clk = 0; rst = 1;
        #10 rst = 0;
        repeat (16) begin
            #10 clk = 1; #10 clk = 0; // Clock pulse
        end
        #10 $finish;
    end
endmodule