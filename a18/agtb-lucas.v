// Comparador de 1-bit
module agtb(
    input wire AGTBI,
    input wire AEQBI,
    input wire A,
    input wire B,
    output AGTBO,
    output AEQBO
);
    assign AGTBO = ((A & ~B) & AEQBI) | AGTBI;
    assign AEQBO = ~(A ^ B) & AEQBI;
endmodule

// Comparador de n-bits
module agtb_n #(parameter N = 4) (
    input wire AGTBI, // A Greater Than B Input
    input wire AEQBI, // A Equal to B Input
    input wire [N-1:0] A, // A, n bits number
    input wire [N-1:0] B, // B, n bits number
    output wire AGTBO, // A Greater Than B Output
    output wire AEQBO // A Equal to B Output
);

    genvar i;

    wire [N-1:0] m_int, e_int;

    generate
        for(i = N-1; i>=0; i=i-1) begin
            // Instanciar comparador de 1-bit
            agtb comp(
                .AGTBI((i == N-1) ? 1'b0 : m_int[i+1]),
                .AEQBI((i == N-1) ? 1'b1 : e_int[i+1]),
                .A(A[i]),
                .B(B[i]),
                .AGTBO(m_int[i]),
                .AEQBO(e_int[i])
            );
        end
    endgenerate

    assign AGTBO = m_int[0];
    assign AEQBO = e_int[0];
endmodule

module tb_agtb_n;
    reg [4-1:0] A, B;
    reg AGTBI;
    reg AEQBI;
    reg esperado_AEQBO;
    reg esperado_AGTBO;
    wire AGTBO;
    wire AEQBO;

    // Instanciar o comparador de n-bits
    agtb_n comp(
        .AGTBI(AGTBI),
        .AEQBI(AEQBI),
        .A(A),
        .B(B),
        .AGTBO(AGTBO),
        .AEQBO(AEQBO)
    );

    initial begin
        $dumpfile("comparador.vcd");
        $dumpvars(0, tb_agtb_n);

        // 1) A == B
        A = 4'b0000;
        B = 4'b0000;
        AGTBI = 0;
        AEQBI = 1;
        esperado_AGTBO = 0;
        esperado_AEQBO = 1;
        #1000;

        $display("1) A=%b | B=%b | %s", A, B, (esperado_AEQBO == AEQBO) ? "OK" : "ERRO");
        $display("1) A=%b | B=%b | %s", A, B, (esperado_AGTBO == AGTBO) ? "OK" : "ERRO");
        
        $finish;
    end
endmodule