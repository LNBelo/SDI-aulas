`timescale 1ns/1ps

module tx_uc(
    input wire clk,
    input wire rst_n,
    input wire start_tx,
    input wire stop_bit_done,
    output reg reset_fd,
    output reg load,
    output reg shift_en,
    output reg tx_done
);

    // Codificação dos Estados
    localparam IDLE  = 2'b00;
    localparam LOAD  = 2'b01;
    localparam SHIFT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state, next_state;

    // Lógica Sequencial
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        // Valores padrão
        reset_fd = 1'b1; // Reset ativo baixo (1 = inativo)
        load = 1'b0;
        shift_en = 1'b0;
        tx_done = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                reset_fd = 1'b0; // Reseta o datapath no idle
                if (start_tx) begin
                    reset_fd = 1'b1; // Libera reset
                    next_state = LOAD;
                end
            end

            LOAD: begin
                load = 1'b1; // Carrega o registrador de deslocamento
                next_state = SHIFT;
            end

            SHIFT: begin
                shift_en = 1'b1; // Habilita deslocamento
                if (stop_bit_done) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                tx_done = 1'b1; // Pulso de conclusão
                next_state = IDLE;
            end
        endcase
    end

endmodule