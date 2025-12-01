/*
 * Testbench Parametrizado para Detector de Sequência FSM de Moore
 * Usa um parâmetro de sequência e aplica cada bit por múltiplos ciclos de clock
 */

`timescale 1ns/1ps

module detector_moore_tb;

    // Sinais do testbench
    reg clk;
    reg rst;
    reg x;
    wire detected;

    // Parâmetros de teste
    parameter CLK_PERIOD = 10;           // Período do clock em ns
    parameter CLOCKS_PER_BIT = 1;        // Quantos ciclos de clock por bit de entrada
    
    // NOTA: Este testbench demonstra teste parametrizado onde cada bit de
    // entrada é mantido por múltiplos ciclos de clock. Isso é útil para testar
    // com mudanças de entrada mais lentas ou observar transições de estado mais claramente.
    
    // Sequências de teste
    parameter TEST1_SEQ = 5'b11110;      // Deve detectar
    parameter TEST1_LEN = 5;
    parameter TEST2_SEQ = 3'b110;        // NÃO deve detectar
    parameter TEST2_LEN = 3;
    parameter TEST3_SEQ = 6'b111110;     // Deve detectar
    parameter TEST3_LEN = 6;
    parameter TEST4_SEQ = 5'b11011;      // NÃO deve detectar
    parameter TEST4_LEN = 5;
    parameter TEST5_SEQ = 9'b111011110;  // Deve detectar duas vezes
    parameter TEST5_LEN = 9;

    // Variáveis de avaliação dos testes
    integer test_count;
    integer pass_count;
    integer fail_count;
    integer expected_detections;
    integer actual_detections;
    integer i, j;

    // Instancia a Unidade Sob Teste (UUT)
    detector_moore uut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .detected(detected)
    );

    // Geração do clock
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Tarefa para aplicar uma sequência de bits com múltiplos clocks por bit
    task apply_sequence;
        input [31:0] sequence;    // Sequência de entrada (até 32 bits)
        input integer length;      // Número de bits na sequência
        integer bit_idx, clk_idx;
        begin
            for (bit_idx = length - 1; bit_idx >= 0; bit_idx = bit_idx - 1) begin
                x = sequence[bit_idx];
                $display("  Tempo %0t: x=%b (bit %0d/%0d)", $time, x, length-bit_idx, length);
                
                // Mantém este valor de bit por CLOCKS_PER_BIT ciclos de clock
                for (clk_idx = 0; clk_idx < CLOCKS_PER_BIT; clk_idx = clk_idx + 1) begin
                    @(posedge clk);
                    #1; // Pequeno atraso para amostragem
                    if (detected) actual_detections = actual_detections + 1;
                end
            end
        end
    endtask

    // Estímulo principal de teste
    initial begin
        // Inicializa dump de forma de onda para GTKWave
        $dumpfile("detector_moore.vcd");
        $dumpvars(0, detector_moore_tb);

        // Inicializa contadores de teste
        test_count = 0;
        pass_count = 0;
        fail_count = 0;

        // Exibe cabeçalho
        $display("\n================================================================================");
        $display("     DETECTOR DE SEQUÊNCIA FSM DE MOORE - SUITE DE TESTES PARAMETRIZADA");
        $display("================================================================================");
        $display("Configuração:");
        $display("  Período do Clock: %0d ns", CLK_PERIOD);
        $display("  Clocks por Bit: %0d", CLOCKS_PER_BIT);
        $display("================================================================================\n");
        
        // Inicializa entradas
        rst = 1;
        x = 0;
        
        // Pulso de reset
        repeat(3) @(posedge clk);
        rst = 0;
        @(posedge clk);
        
        // Caso de Teste 1: Sequência 11110 (deve detectar)
        $display("--- Teste 1: Sequência 11110 (deve detectar) ---");
        test_count = test_count + 1;
        expected_detections = 1;
        actual_detections = 0;
        apply_sequence(TEST1_SEQ, TEST1_LEN);
        
        // Adiciona clocks extras para observar saída de Moore
        x = 0;
        repeat(CLOCKS_PER_BIT) begin
            @(posedge clk);
            #1;
            if (detected) actual_detections = actual_detections + 1;
        end
        
        if (actual_detections == expected_detections) begin
            $display("*** TESTE 1 APROVADO *** (Esperado: %0d, Obtido: %0d)\n", expected_detections, actual_detections);
            pass_count = pass_count + 1;
        end else begin
            $display("*** TESTE 1 REPROVADO *** (Esperado: %0d, Obtido: %0d)\n", expected_detections, actual_detections);
            fail_count = fail_count + 1;
        end
        
        // Caso de Teste 2: Sequência 110 (NÃO deve detectar)
        $display("--- Teste 2: Sequência 110 (NÃO deve detectar) ---");
        test_count = test_count + 1;
        expected_detections = 0;
        actual_detections = 0;
        // Reseta FSM antes do próximo teste
        rst = 1; @(posedge clk); rst = 0; 
        x = 0; repeat(2) @(posedge clk); // Limpa qualquer estado remanescente
        apply_sequence(TEST2_SEQ, TEST2_LEN);
        
        x = 0;
        repeat(CLOCKS_PER_BIT) begin
            @(posedge clk);
            #1;
            if (detected) actual_detections = actual_detections + 1;
        end
        
        if (actual_detections == expected_detections) begin
            $display("*** TESTE 2 APROVADO *** (Esperado: %0d, Obtido: %0d)\n", expected_detections, actual_detections);
            pass_count = pass_count + 1;
        end else begin
            $display("*** TESTE 2 REPROVADO *** (Esperado: %0d, Obtido: %0d)\n", expected_detections, actual_detections);
            fail_count = fail_count + 1;
        end
        
        // Caso de Teste 3: Sequência 111110 (deve detectar)
        $display("--- Teste 3: Sequência 111110 (deve detectar) ---");
        test_count = test_count + 1;
        expected_detections = 1;
        actual_detections = 0;
        // Reseta FSM antes do próximo teste
        rst = 1; @(posedge clk); rst = 0;
        x = 0; repeat(2) @(posedge clk); // Limpa qualquer estado remanescente
        apply_sequence(TEST3_SEQ, TEST3_LEN);
        
        x = 0;
        repeat(CLOCKS_PER_BIT) begin
            @(posedge clk);
            #1;
            if (detected) actual_detections = actual_detections + 1;
        end
        
        if (actual_detections == expected_detections) begin
            $display("*** TESTE 3 APROVADO *** (Esperado: %0d, Obtido: %0d)\n", expected_detections, actual_detections);
            pass_count = pass_count + 1;
        end else begin
            $display("*** TESTE 3 REPROVADO *** (Esperado: %0d, Obtido: %0d)\n", expected_detections, actual_detections);
            fail_count = fail_count + 1;
        end
        
        // Caso de Teste 4: Sequência 11011 (NÃO deve detectar)
        $display("--- Teste 4: Sequência 11011 (NÃO deve detectar) ---");
        test_count = test_count + 1;
        expected_detections = 0;
        actual_detections = 0;
        // Reseta FSM antes do próximo teste
        rst = 1; @(posedge clk); rst = 0;
        x = 0; repeat(2) @(posedge clk); // Limpa qualquer estado remanescente
        apply_sequence(TEST4_SEQ, TEST4_LEN);
        
        x = 0;
        repeat(CLOCKS_PER_BIT) begin
            @(posedge clk);
            #1;
            if (detected) actual_detections = actual_detections + 1;
        end
        
        if (actual_detections == expected_detections) begin
            $display("*** TESTE 4 APROVADO *** (Esperado: %0d, Obtido: %0d)\n", expected_detections, actual_detections);
            pass_count = pass_count + 1;
        end else begin
            $display("*** TESTE 4 REPROVADO *** (Esperado: %0d, Obtido: %0d)\n", expected_detections, actual_detections);
            fail_count = fail_count + 1;
        end
        
        // Caso de Teste 5: Sequência 111011110 (deve detectar duas vezes)
        $display("--- Teste 5: Sequência 111011110 (deve detectar duas vezes) ---");
        test_count = test_count + 1;
        expected_detections = 2;
        actual_detections = 0;
        // Reseta FSM antes do próximo teste
        rst = 1; @(posedge clk); rst = 0;
        x = 0; repeat(2) @(posedge clk); // Limpa qualquer estado remanescente
        apply_sequence(TEST5_SEQ, TEST5_LEN);
        
        x = 0;
        repeat(CLOCKS_PER_BIT) begin
            @(posedge clk);
            #1;
            if (detected) actual_detections = actual_detections + 1;
        end
        
        if (actual_detections == expected_detections) begin
            $display("*** TESTE 5 APROVADO *** (Esperado: %0d, Obtido: %0d)\n", expected_detections, actual_detections);
            pass_count = pass_count + 1;
        end else begin
            $display("*** TESTE 5 REPROVADO *** (Esperado: %0d, Obtido: %0d)\n", expected_detections, actual_detections);
            fail_count = fail_count + 1;
        end
        
        // Exibe resultados finais dos testes e nota
        $display("================================================================================");
        $display("                        RESUMO DOS RESULTADOS DOS TESTES");
        $display("================================================================================");
        $display("Total de Testes:  %0d", test_count);
        $display("Testes Aprovados: %0d", pass_count);
        $display("Testes Reprovados: %0d", fail_count);
        $display("Taxa de Aprovação: %0d%%", (pass_count * 100) / test_count);
        $display("--------------------------------------------------------------------------------");
        
        if (fail_count == 0) begin
            $display("STATUS: TODOS OS TESTES APROVADOS! ✓");
            $display("NOTA:   100/100 - EXCELENTE!");
        end else if (pass_count >= 4) begin
            $display("STATUS: MAIORIA APROVADA");
            $display("NOTA:   %0d/100 - BOM", (pass_count * 100) / test_count);
        end else if (pass_count >= 3) begin
            $display("STATUS: APROVAÇÃO PARCIAL");
            $display("NOTA:   %0d/100 - PRECISA MELHORAR", (pass_count * 100) / test_count);
        end else begin
            $display("STATUS: REPROVADO");
            $display("NOTA:   %0d/100 - REVISAR IMPLEMENTAÇÃO", (pass_count * 100) / test_count);
        end
        
        $display("================================================================================\n");
        
        #100;
        $finish;
    end

    // Monitor para eventos de detecção
    always @(posedge detected) begin
        $display("  >>> PADRÃO DETECTADO no tempo %0t <<<", $time);
    end

endmodule
