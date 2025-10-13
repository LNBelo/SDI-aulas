// NOT: 2
// XOR2: 12
// XOR3: 20
// FI AND OR
// 2  7   8
// 3  10  12
// 4  13  16
// 5  16  20
// 6  19  24
// 7  22 
// 8  25

module cla8t (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Sinais internos para generate (G) e propagate (P)
    wire [7:0] g, p;
    wire [7:0] c;
    
    // Calcular Generate (G) e Propagate (P) para cada bit
    assign #7 g = a & b;  // G = A AND B
    assign #8 p = a | b;  // P = A OR B
    
    // Cálculo dos carries usando lookahead
    assign #0 c[0] = cin;
    assign #(8+7) c[1] = 
        g[0] | (p[0] & c[0]);
    assign #(12+10) c[2] = 
        g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign #(16+13) c[3] = 
        g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign #(20+16) c[4] = 
        g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
        (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);
    assign #(24+19) c[5] = 
        g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | 
        (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & g[0]) |
        (p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    assign #(24+8+22) c[6] = 
        g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | 
        (p[5] & p[4] & p[3] & g[2]) | (p[5] & p[4] & p[3] & p[2] & g[1]) |
        (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
        (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    assign #(24+12+25) c[7] = 
        g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | 
        (p[6] & p[5] & p[4] & g[3]) | (p[6] & p[5] & p[4] & p[3] & g[2]) |
        (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) |
        (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
        (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    
    // Carry de saída
    assign #(8+7) cout = g[7] | (p[7] & c[7]);
    
    // Cálculo da soma
    assign #(20) sum = a ^ b ^ c[7:0];

endmodule



module tb_carry_lookahead_adder;
    reg [7:0] a, b;
    reg cin;
    wire [7:0] sum;
    wire cout;
    reg [7:0] esperado_sum;
    reg esperado_cout;
    
    // Instanciar o somador
    cla8t dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
    
    initial begin
        $dumpfile("somador.vcd");
        $dumpvars(0,tb_carry_lookahead_adder);

        // 1) Inicializar entradas
        a = 8'b0;
        b = 8'b0;
        cin = 0;
        esperado_sum = 8'b00000000;
        esperado_cout = 0;
        #1000;

        $display("1) esperado_sum=%b | obtido_soma=%b | %s", esperado_sum, sum, (sum == esperado_sum) ? "OK" : "ERRO");
        $display("1) esperado_cout=%b | obtido_cout=%b | %s", esperado_cout, cout, (cout == esperado_cout) ? "OK" : "ERRO");

        // 2) Overflow a
        a = 8'b11111111;
        b = 8'b0;
        cin = 1;
        esperado_sum = 8'b00000000;
        esperado_cout = 1;
        #1000;

        $display("2) esperado_sum=%b | obtido_soma=%b | %s", esperado_sum, sum, (sum == esperado_sum) ? "OK" : "ERRO");
        $display("2) esperado_cout=%b | obtido_cout=%b | %s", esperado_cout, cout, (cout == esperado_cout) ? "OK" : "ERRO");

        // 3) Overflow b
        a = 8'b0;
        b = 8'b11111111;
        cin = 1;
        esperado_sum = 8'b00000000;
        esperado_cout = 1;
        #1000;

        $display("3) esperado_sum=%b | obtido_soma=%b | %s", esperado_sum, sum, (sum == esperado_sum) ? "OK" : "ERRO");
        $display("3) esperado_cout=%b | obtido_cout=%b | %s", esperado_cout, cout, (cout == esperado_cout) ? "OK" : "ERRO");

        // 4) Overflow
        a = 8'b11111111;
        b = 8'b11111111;
        cin = 0;
        esperado_sum = 8'b11111110;
        esperado_cout = 1;
        #1000;

        $display("4) esperado_sum=%b | obtido_soma=%b | %s", esperado_sum, sum, (sum == esperado_sum) ? "OK" : "ERRO");
        $display("4) esperado_cout=%b | obtido_cout=%b | %s", esperado_cout, cout, (cout == esperado_cout) ? "OK" : "ERRO");

        // 5) Overflow
        a = 8'b11111111;
        b = 8'b11111111;
        cin = 1;
        esperado_sum = 8'b11111111;
        esperado_cout = 1;
        #1000;

        $display("5) esperado_sum=%b | obtido_soma=%b | %s", esperado_sum, sum, (sum == esperado_sum) ? "OK" : "ERRO");
        $display("5) esperado_cout=%b | obtido_cout=%b | %s", esperado_cout, cout, (cout == esperado_cout) ? "OK" : "ERRO");

        // 6) soma sem overflow e sem cin
        a = 8'b00000011;
        b = 8'b00000001;
        cin = 0;
        esperado_sum = 8'b00000100;
        esperado_cout = 0;
        #1000;

        $display("6) esperado_sum=%b | obtido_soma=%b | %s", esperado_sum, sum, (sum == esperado_sum) ? "OK" : "ERRO");
        $display("6) esperado_cout=%b | obtido_cout=%b | %s", esperado_cout, cout, (cout == esperado_cout) ? "OK" : "ERRO");

        // 7) soma sem overflow e com cin
        a = 8'b00000011;
        b = 8'b00000001;
        cin = 1;
        esperado_sum = 8'b00000101;
        esperado_cout = 0;
        #1000;

        $display("7) esperado_sum=%b | obtido_soma=%b | %s", esperado_sum, sum, (sum == esperado_sum) ? "OK" : "ERRO");
        $display("7) esperado_cout=%b | obtido_cout=%b | %s", esperado_cout, cout, (cout == esperado_cout) ? "OK" : "ERRO");
        

        $finish;
    end
    
    // Monitor para ver os resultados
    initial begin
        $monitor("Tempo: %0t, A=%d, B=%d, Cin=%b, Sum=%d, Cout=%b", 
                 $time, a, b, cin, sum, cout);
    end

endmodule