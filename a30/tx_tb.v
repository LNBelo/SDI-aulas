`timescale 1ns/1ps

module tb_tx_auto;

    // ----------------------
    // SINAIS DO DUT
    // ----------------------
    reg clk;
    reg rst_n;
    reg start_tx;
    reg [7:0] data_in;
    reg parity_type;
    reg parity_en;
    reg stop_bits;
    reg data_width;

    wire serial_out;
    wire tx_done;

    // ----------------------
    // INSTÂNCIA DO DUT
    // ----------------------
    tx dut (
        .clk(clk),
        .rst_n(rst_n),
        .start_tx(start_tx),
        .data_in(data_in),
        .parity_type(parity_type),
        .parity_en(parity_en),
        .stop_bits(stop_bits),
        .data_width(data_width),
        .serial_out(serial_out),
        .parity_bit(),
        .tx_done(tx_done)
    );

    // ----------------------
    // GERAÇÃO DE CLOCK
    // ----------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // ----------------------
    // VARIÁVEL DE ERROS
    // ----------------------
    integer errors;
    integer k;

    // ----------------------
    // VCD
    // ----------------------
    initial begin
        $dumpfile("tx_tb.vcd");
        $dumpvars(0, tb_tx_auto);
    end


    // =============================================================================
    // TASK: TESTE DE TRANSMISSÃO UART
    // =============================================================================
    task automatic run_test;
        input [7:0] data;
        input width_sel;
        input par_en;
        input par_type;
        input stop_cfg;
        input [48*8:1] case_name;

        reg [11:0] ideal_frame;
        reg [7:0] treated;
        reg par;
        integer length;
        integer b;
        reg fail;

        begin
            // Preparação
            fail = 0;
            ideal_frame = 12'b111111111111;

            // Ajuste de largura
            treated = (width_sel) ? data : {1'b0, data[6:0]};

            // Cálculo da paridade
            par = ^data;
            if (par_type) par = ~par;

            // Montagem do frame
            ideal_frame[0] = 1'b0;
            length = 1;

            if (!width_sel) begin
                for (b = 0; b < 7; b = b + 1)
                    ideal_frame[length + b] = treated[b];
                length = length + 7;
            end else begin
                for (b = 0; b < 8; b = b + 1)
                    ideal_frame[length + b] = treated[b];
                length = length + 8;
            end

            if (par_en) begin
                ideal_frame[length] = par;
                length = length + 1;
            end

            ideal_frame[length] = 1'b1;
            length = length + 1;

            if (stop_cfg) begin
                ideal_frame[length] = 1'b1;
                length = length + 1;
            end


            // CONFIGURA DUT
            @(negedge clk);
            data_in     = data;
            data_width  = width_sel;
            parity_en   = par_en;
            parity_type = par_type;
            stop_bits   = stop_cfg;

            // Pulso start
            start_tx = 1;
            @(negedge clk);
            start_tx = 0;
            @(negedge clk);

            // Impressão inicial
            $display("\n[Test Case] %s", case_name);
            $write("   TX Bits: ");

            // Validação bit a bit
            for (b = 0; b < length; b = b + 1) begin
                if (serial_out !== ideal_frame[b]) begin
                    fail = 1;
                    $write("X");
                    $display("\n      Bit %0d incorreto | Esperado=%b Recebido=%b",
                             b, ideal_frame[b], serial_out);
                end else begin
                    $write("%b", serial_out);
                end
                @(negedge clk);
            end

            // Aguarda finalização
            @(posedge tx_done);

            // Resultado
            if (fail) begin
                $display("   STATUS: ERRO DETECTADO");
                errors = errors + 1;
            end else begin
                $display("   STATUS: OK");
            end

            repeat(2) @(posedge clk);
        end
    endtask


    // =============================================================================
    // BLOCO PRINCIPAL
    // =============================================================================
    initial begin
        // Reset inicial
        errors = 0;
        rst_n = 0;
        start_tx = 0;
        data_in = 0;
        parity_en = 0;
        parity_type = 0;
        stop_bits = 0;
        data_width = 1;

        #15 rst_n = 1;
        #20;

        $display("\n----------------------------------------------");
        $display("       SIMULAÇÃO AUTOMÁTICA UART TX");
        $display("----------------------------------------------");

        // ----------------
        // CENÁRIOS
        // ----------------

        run_test(8'h5A, 1, 0, 0, 0, "A1: 8N1 | 0x5A");
        run_test(8'hF0, 1, 0, 0, 0, "A2: 8N1 | 0xF0");

        run_test(8'h0F, 1, 1, 0, 0, "B1: 8E1 | 0x0F");
        run_test(8'h0F, 1, 1, 1, 0, "B2: 8O1 | 0x0F");

        run_test(8'h2A, 0, 0, 0, 0, "C1: 7N1 | 0x2A");
        run_test(8'h2A, 0, 1, 1, 1, "C2: 7O2 | 0x2A");

        run_test(8'h9E, 1, 0, 0, 1, "D1: 8N2 | 0x9E");
        run_test(8'h01, 1, 1, 1, 1, "D2: 8O2 | 0x01");

        // ----------------
        // FINAL
        // ----------------
        $display("\n----------------------------------------------");
        if (errors == 0)
            $display(" RESULTADO FINAL: SUCESSO TOTAL ✅");
        else
            $display(" RESULTADO FINAL: %0d ERROS ❌", errors);
        $display("----------------------------------------------\n");

        #60 $finish;
    end

endmodule
