module detector_moore (
    input wire clk,          // Sinal de clock
    input wire rst,          // Reset síncrono ativo em alto
    input wire x,            // Sequência de bits de entrada
    output wire detected     // Saída: 1 quando no estado DETECTED
);

    // Codificação dos estados
    localparam [2:0] A = 3'b000;  // IDLE: Estado inicial
    localparam [2:0] B = 3'b001;  // ONE1: Um '1' consecutivo
    localparam [2:0] C = 3'b010;  // ONE2: Dois '1's consecutivos
    localparam [2:0] D = 3'b011;  // THREE_OR_MORE: Três ou mais '1's consecutivos
    localparam [2:0] E = 3'b100;  // DETECTED: Estado de padrão detectado

    // Registradores de estado
    reg [2:0] current_state;
    wire [2:0] next_state;
    
    // Aliases para os bits do estado atual (saídas dos flip-flops)
    wire Q2, Q1, Q0;
    assign Q2 = current_state[2];
    assign Q1 = current_state[1];
    assign Q0 = current_state[0];
    
    // Aliases para os bits do próximo estado (entradas dos flip-flops)
    wire D2, D1, D0;
    assign next_state[2] = D2;
    assign next_state[1] = D1;
    assign next_state[0] = D0;

    // Registrador de estado - Lógica sequencial
    always @(posedge clk) begin
        if (rst) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Lógica de próximo estado - Expressões lógicas para cada bit
    // D2, D1, D0 são as entradas dos flip-flops (próximo estado)
    // Tabela de transição de estados:
    // Estado Atual | x | Próximo Estado
    // A(000)       | 0 | A(000)
    // A(000)       | 1 | B(001)
    // B(001)       | 0 | A(000)
    // B(001)       | 1 | C(010)
    // C(010)       | 0 | A(000)
    // C(010)       | 1 | D(011)
    // D(011)       | 0 | E(100)
    // D(011)       | 1 | D(011)
    // E(100)       | 0 | A(000)
    // E(100)       | 1 | B(001)
    
    assign D2 = (~Q2 & Q1 & Q0 & ~x);  // D2: apenas D(011) com x=0 -> E(100)
    
    assign D1 = (~Q2 & ~Q1 & Q0 & x) |   // B(001) com x=1 -> C(010)
                (~Q2 & Q1 & ~Q0 & x) |    // C(010) com x=1 -> D(011)
                (~Q2 & Q1 & Q0 & x);      // D(011) com x=1 -> D(011)
    
    assign D0 = (~Q2 & ~Q1 & ~Q0 & x) |  // A(000) com x=1 -> B(001)
                (~Q2 & Q1 & ~Q0 & x) |    // C(010) com x=1 -> D(011)
                (~Q2 & Q1 & Q0 & x) |     // D(011) com x=1 -> D(011)
                (Q2 & ~Q1 & ~Q0 & x);     // E(100) com x=1 -> B(001)

    // Lógica de saída - Fluxo de dados (atribuição contínua, máquina de Moore)
    // Saída depende apenas das saídas dos flip-flops do estado atual
    // Estado E = 100 (Q2=1, Q1=0, Q0=0)
    assign detected = Q2 & ~Q1 & ~Q0;
   
endmodule
