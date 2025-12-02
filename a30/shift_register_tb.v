`timescale 1ns/1ps

module shift_register_tb;

    reg clk;
    reg rst_n;
    reg load;
    reg shift_en;
    reg [7:0] parallel_in;
    reg serial_in;
    wire [7:0] parallel_out;
    wire serial_out;

    // DUT
    shift_register uut (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .shift_en(shift_en),
        .parallel_in(parallel_in),
        .serial_in(serial_in),
        .parallel_out(parallel_out),
        .serial_out(serial_out)
    );

    // Clock: 10 ns
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        load = 0;
        shift_en = 0;
        serial_in = 1; // valor fixo de entrada serial
        parallel_in = 8'b10101010;

        // Reset
        #12;
        rst_n = 1;

        // Carrega valor inicial
        load = 1;
        #10;
        load = 0;

        $display("Carga paralela OK: %b", parallel_out);
        $display("---- Iniciando deslocamento ----");

        // 8 deslocamentos
        repeat (8) begin
            // MOSTRA o serial_out ANTES do shift
            $display("Serial Out (antes shift): %b | Register: %b", serial_out, parallel_out);

            shift_en = 1;
            #10; // Aplica o shift na borda do clock
            shift_en = 0;

            #2; // Espera para o registrador atualizar
        end

        $finish;
    end

endmodule