// Pedro Sousa Goularte - 16897265
// Lucas Belo - 9896862
// Lana Rodrigues - 17109767

/* Flip-flop tipo D com reset e preset assíncronos */
module estado (
    input clk, rst, prt, d,
    output reg q
);
    always @(posedge clk, posedge rst, posedge prt) begin
        if (rst)
            q <= 1'b0;
        else if (prt)
            q <= 1'b1;
        else
            q <= d;
    end
endmodule

/* DEMUX 1 para 2 */
module decisor (
    input ativacao,
    input x,
    output x0, x1
);
    assign x0 = ativacao & ~x;
    assign x1 = ativacao & x;
endmodule

/* OR de N entradas */
module juncao #(
    parameter N = 2
) (
    input [N-1:0] in,
    output out
);
    assign out = |in;
endmodule

module detector_asm (
    input clk, rst, x,
    output detected
);


endmodule

module uc #(
    parameter n = 8
) (
    input wire clk,
    input wire reset,
    input wire init,
    input wire [n-1:0] N, // Contador de iterações
    input wire [n-1:0] B, // Bit menos significativo do multiplicador (B[0])
    output reg SELA, // Seleção de entrada para o registrador A (0: Entrada A; 1: Shift Left)
    output reg SELB, // Seleção de entrada para o registrador B (0: Entrada B; 1: Shift Right)
    output reg SELP, // Seleção de entrada para o registrador P (0: 0; 1: P + A)
    output reg SELN, // Seleção de entrada para o registrador N (0: Entrada N; 1: N - 1)
    output reg LOADA, // Sinal de carga para o registrador A
    output reg LOADB, // Sinal de carga para o registrador B
    output reg LOADP, // Sinal de carga para o registrador P
    output reg LOADN, // Sinal de carga para o registrador N
    output reg finish // Sinal de término da operação
);

    localparam S0 = 3'd0; 
    localparam S1 = 3'd1;
    localparam S2 = 3'd2;
    localparam S3 = 3'd3; 
    localparam S4 = 3'd4; 
    localparam S5 = 3'd5;
    localparam S6 = 3'd6; 

    reg [2:0] state, next_state;

    // Registrador de Estado
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Lógica do Próximo Estado e Saídas 
    always @(*) begin
        next_state = state;
        // Valores padrão 
        SELA = 0; SELB = 0; SELP = 0; SELN = 0;
        LOADA = 0; LOADB = 0; LOADP = 0; LOADN = 0;
        finish = 0;

        case (state)
            S0: begin 
                if (init) next_state = S1;
            end

            S1: begin
                // Carrega entradas e zera P
                LOADA = 1; SELA = 0; 
                LOADB = 1; SELB = 0; 
                LOADN = 1; SELN = 0; 
                LOADP = 1; SELP  = 0; // Seleciona 0 para zerar P

                next_state = S2;
            end

            S2: begin 
                if (N > 0)
                    next_state = S3;
                else
                    next_state = S6; 
            end

            S3: begin 
                if (B[0] == 1'b1)
                    next_state = S4; // Adiciona se B[0] == 1
                else
                    next_state = S5; // Apenas desloca se B[0] == 0
            end

            S4: begin
                LOADP = 1;
                SELP  = 1; // Seleciona P + A
                
                next_state = S5;
            end

            S5: begin
                LOADA = 1; SELA = 1; // A << 1
                LOADB = 1; SELB = 1; // B >> 1
                LOADN = 1; SELN = 1; // N - 1
                
                next_state = S2; 
            end

            S6: begin
                finish = 1;
                next_state = S0; // Volta
            end

            default: next_state = S0;
        endcase
    end

endmodule