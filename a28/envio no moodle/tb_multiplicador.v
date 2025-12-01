`timescale 1ns/1ps

module tb_multiplicador;

    // Parâmetros
    parameter n = 8;

    // Sinais de entrada (Regs)
    reg clk;
    reg reset;
    reg init;
    reg [n-1:0] A;
    reg [n-1:0] B;
    reg [n-1:0] N;

    // Sinais de saída (Wires)
    wire [2*n-1:0] P;
    wire finish;

    // Instanciação do Módulo Principal (DUT)
    multiplicador #(.n(n)) dut (
        .clk(clk),
        .reset(reset),
        .init(init),
        .A(A),
        .B(B),
        .N(N),
        .P(P),
        .finish(finish)
    );

    // Geração de Clock (Período = 10ns)
    always #5 clk = ~clk;

    // Configuração do VCD para GTKWave
    initial begin
        // Nome do arquivo de saída
        $dumpfile("sinal.vcd");
        // Nível 0 = Salva todos os sinais hierarquicamente abaixo de tb_multiplicador
        $dumpvars(0, tb_multiplicador);
    end

    // Procedimento de Teste
    initial begin
        // 1. Inicialização
        clk = 0;
        reset = 1;
        init = 0;
        A = 0; B = 0; N = 0;

        // Solta o reset após alguns ciclos
        #15 reset = 0;

        // -------------------------------------------------
        // CASO DE TESTE 1: 6 * 7 = 42 (Pequenos números)
        // -------------------------------------------------
        #20;
        $display("--- Inicio Teste 1: 6 x 7 ---");
        A = 8'd6;
        B = 8'd7;
        N = 8'd8; // Número de iterações (bits)

        // Pulso de INIT (exatamente 1 ciclo de clock)
        @(posedge clk);
        init = 1;
        @(posedge clk);
        init = 0;

        // Aguarda o sinal de finish
        wait(finish == 1);
        
        // Pequeno delay para estabilização visual na onda
        #10; 

        // Verificação automática
        if (P === 42) 
            $display("[SUCESSO] 6 * 7 = %d", P);
        else 
            $display("[ERRO] 6 * 7 = %d (Esperado: 42)", P);


        // -------------------------------------------------
        // CASO DE TESTE 2: 255 * 255 (Limite máximo de 8 bits)
        // -------------------------------------------------
        #20;
        $display("\n--- Inicio Teste 2: 255 x 255 ---");
        A = 8'd255;
        B = 8'd255;
        N = 8'd8;

        // Pulso de INIT
        @(posedge clk);
        init = 1;
        @(posedge clk);
        init = 0;

        wait(finish == 1);
        #10;

        if (P === 65025) 
            $display("[SUCESSO] 255 * 255 = %d", P);
        else 
            $display("[ERRO] 255 * 255 = %d (Esperado: 65025)", P);


        // -------------------------------------------------
        // CASO DE TESTE 3: Multiplicação por Zero (200 * 0 = 0)
        // -------------------------------------------------
        #20;
        $display("\n--- Inicio Teste 3: 200 x 0 ---");
        A = 8'd200;
        B = 8'd0;
        N = 8'd8;

        // Pulso de INIT
        @(posedge clk);
        init = 1;
        @(posedge clk);
        init = 0;

        wait(finish == 1);
        #10;

        if (P === 0) 
            $display("[SUCESSO] 200 * 0 = %d", P);
        else 
            $display("[ERRO] 200 * 0 = %d (Esperado: 0)", P);


        // -------------------------------------------------
        // CASO DE TESTE 4: Multiplicação por Um (1 * 150 = 150)
        // -------------------------------------------------
        #20;
        $display("\n--- Inicio Teste 4: 1 x 150 ---");
        A = 8'd1;
        B = 8'd150;
        N = 8'd8;

        // Pulso de INIT
        @(posedge clk);
        init = 1;
        @(posedge clk);
        init = 0;

        wait(finish == 1);
        #10;

        if (P === 150) 
            $display("[SUCESSO] 1 * 150 = %d", P);
        else 
            $display("[ERRO] 1 * 150 = %d (Esperado: 150)", P);


        // -------------------------------------------------
        // CASO DE TESTE 5: Intermediário (100 * 3 = 300)
        // -------------------------------------------------
        #20;
        $display("\n--- Inicio Teste 5: 100 x 3 ---");
        A = 8'd100;
        B = 8'd3;
        N = 8'd8;

        // Pulso de INIT
        @(posedge clk);
        init = 1;
        @(posedge clk);
        init = 0;

        wait(finish == 1);
        #10;

        if (P === 300) 
            $display("[SUCESSO] 100 * 3 = %d", P);
        else 
            $display("[ERRO] 100 * 3 = %d (Esperado: 300)", P);


        // Finaliza a simulação
        #50;
        $finish;
    end

    // Monitoramento no console (Opcional)
    initial begin
        // Mostra alterações no estado da UC e nos registradores principais
        // Atenção: Esta linha requer que os módulos internos (unidade_controle, fluxo_dados, REGN)
        // existam e que o DUT seja instanciado com o nome 'dut'.
        $monitor("Time=%0t | State=%d | N=%d | P=%d | Finish=%b", 
                  $time, dut.unidade_controle.state, dut.fluxo_dados.REGN.q, P, finish);
    end

endmodule