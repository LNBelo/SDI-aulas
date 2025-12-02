 `timescale 1ns/1ps

module tb_parity_generator;

    parameter WIDTH = 8;

    reg  [WIDTH-1:0] data_in;
    reg  parity_type;
    wire parity_out;

    parity_generator #(
        .WIDTH(WIDTH)
    ) dut (
        .data_in(data_in),
        .parity_type(parity_type),
        .parity_out(parity_out)
    );

    initial begin
        $display("--- Teste Gerador de Paridade ---");

        // Par e par
        data_in = 8'b10101010;
        parity_type = 0;
        #5;
        if (parity_out !== 0) $display("ERRO Caso 1");
        else $display("Caso 1 OK");

        // Par e ímpar
        parity_type = 1;
        #5;
        if (parity_out !== 1) $display("ERRO Caso 2");
        else $display("Caso 2 OK");

        // Ímpar e par
        data_in = 8'b11100000;
        parity_type = 0;
        #5;
        if (parity_out !== 1) $display("ERRO Caso 3");
        else $display("Caso 3 OK");

        // Ímpar e ímpar
        parity_type = 1;
        #5;
        if (parity_out !== 0) $display("ERRO Caso 4");
        else $display("Caso 4 OK");

        $finish;
    end

endmodule