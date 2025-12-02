`timescale 1ns/1ps

module tx_uc_tb;

    reg clk;
    reg rst_n;
    reg start_tx;
    reg stop_bit_done;

    wire reset_fd;
    wire load;
    wire shift_en;
    wire tx_done;

    // DUT
    tx_uc dut(
        .clk(clk),
        .rst_n(rst_n),
        .start_tx(start_tx),
        .stop_bit_done(stop_bit_done),
        .reset_fd(reset_fd),
        .load(load),
        .shift_en(shift_en),
        .tx_done(tx_done)
    );

    // Clock (10ns)
    always #5 clk = ~clk;

    initial begin
        $display("=========== TESTE tx_uc ===========");

        clk = 0;
        rst_n = 0;
        start_tx = 0;
        stop_bit_done = 0;

        // Libera reset externo
        #12 rst_n = 1;

        // 1) TESTE: estado inicial após reset
        $display("\n-- Testando estado inicial após reset --");
        #2;

        if (reset_fd !== 0)
            $display("ERRO: reset_fd deveria ser 0 no IDLE após reset.");
        else
            $display("OK: reset_fd = 0 no IDLE após reset.");

        if (load !== 0)
            $display("ERRO: load deveria ser 0 no IDLE.");
        else
            $display("OK: load = 0.");

        if (shift_en !== 0)
            $display("ERRO: shift_en deveria ser 0 no IDLE.");
        else
            $display("OK: shift_en = 0.");

        if (tx_done !== 0)
            $display("ERRO: tx_done deveria ser 0 no IDLE.");
        else
            $display("OK: tx_done = 0.");

        // 2) TESTE: start_tx inicia transmissão
        $display("\n-- Testando start_tx --");

        start_tx = 1; #10; start_tx = 0;

        if (load !== 1)
            $display("ERRO: load não ativou no estado LOAD.");
        else
            $display("OK: load ativado no LOAD.");

        #10;

        if (shift_en !== 1)
            $display("ERRO: shift_en deveria ativar no estado SHIFT.");
        else
            $display("OK: shift_en ativado no SHIFT.");

        // 3) TESTE: stop_bit_done encerra transmissão
        $display("\n-- Testando stop_bit_done --");

        stop_bit_done = 1; #10; stop_bit_done = 0;

        if (tx_done !== 1)
            $display("ERRO: tx_done deveria ser 1 no DONE.");
        else
            $display("OK: tx_done = 1 no DONE.");

        if (shift_en !== 0)
            $display("ERRO: shift_en deveria ser 0 após DONE.");
        else
            $display("OK: shift_en desativado após DONE.");

        #10;

        // 4) TESTE: volta para IDLE corretamente
        $display("\n-- Testando retorno ao IDLE --");

        if (reset_fd !== 0)
            $display("ERRO: reset_fd deveria voltar para 0 no IDLE.");
        else
            $display("OK: reset_fd voltou ao IDLE corretamente.");

        $display("\n=========== TESTE CONCLUÍDO ===========");
        $finish;
    end

endmodule
