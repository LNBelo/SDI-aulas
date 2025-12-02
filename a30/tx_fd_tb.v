`timescale 1ns/1ps

module tx_fd_tb;

    reg clk;
    reg rst_n;
    reg load;
    reg shift_en;
    reg parity_type;
    reg parity_en;
    reg stop_bits;
    reg data_width;       // 0 = 7 bits, 1 = 8 bits
    reg [7:0] data_in;

    wire serial_out;
    wire parity_bit;

    // DUT
    tx_fd dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .load(load),
        .shift_en(shift_en),
        .parity_type(parity_type),
        .parity_en(parity_en),
        .stop_bits(stop_bits),
        .data_width(data_width),
        .serial_out(serial_out),
        .parity_bit(parity_bit)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        load = 0;
        shift_en = 0;
        parity_type = 0;
        parity_en = 0;
        stop_bits = 0;
        data_width = 1;     // começa transmitindo 8 bits
        data_in = 8'b10101010;

        #12 rst_n = 1;

        $display("=========== TESTE tx_fd ===========");

        // 1) TESTE DO LOAD
        $display("\n-- Testando LOAD --");

        load = 1;
        #10;
        load = 0;
        #2;
        $display("FRAME interno  = %b", dut.frame);
        $display("shift_reg      = %b", dut.sr.shift_reg);

        if (dut.sr.shift_reg !== dut.frame)
            $display("ERRO: shift_reg != frame após LOAD.");
        else
            $display("OK: Load correto (shift_reg = frame).");


        // 2) TESTE PARIDADE
        $display("\n-- Testando PARIDADE --");

        parity_en = 1;
        parity_type = 0; #2;
        if (parity_bit !== (^data_in))
            $display("ERRO: Paridade PAR incorreta.");
        else
            $display("OK: Paridade PAR correta (%b).", parity_bit);

        parity_type = 1; #2;
        if (parity_bit !== ~(^data_in))
            $display("ERRO: Paridade ÍMPAR incorreta.");
        else
            $display("OK: Paridade ÍMPAR correta (%b).", parity_bit);


        // 3) TESTE DO SHIFT
        $display("\n-- Testando SHIFT --");

        repeat (4) begin
            $display("Antes shift: serial_out=%b, shift_reg=%b",
                     serial_out, dut.sr.shift_reg);

            shift_en = 1;
            #10;
            shift_en = 0;
            #2;
        end


        // 4) TESTE data_width = 7 bits (correto!)
        $display("\n-- Testando data_width = 7 bits --");

        data_width = 0;      // Modo 7 bits
        data_in = 8'b11110000;

        load = 1; #10; load = 0; #2;

        $display("FRAME (7 bits) = %b", dut.frame);
        $display("shift_reg      = %b", dut.sr.shift_reg);

        
        // Dados ficam nas posições frame[7:1] (D0 = 1, D6 = 7)
        if (dut.frame[7:1] !== data_in[6:0])
            $display("ERRO: data_width=7 não ignorou data_in[7].");
        else
            $display("OK: data_width=7 aplicou correto (bit extra ignorado).");

        $display("\n=========== TESTE CONCLUÍDO ===========");

        $finish;
    end

endmodule
