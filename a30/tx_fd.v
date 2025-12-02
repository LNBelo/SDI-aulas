`timescale 1ns/1ps

module tx_fd(
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [7:0] data_in,
    input wire shift_en,
    input wire parity_type,
    input wire parity_en,
    input wire stop_bits,
    input wire data_width,
    output wire serial_out,
    output wire parity_bit
);

    localparam MAX_FRAME = 12;

    // Payload logic
    wire [7:0] payload = data_width ? data_in : {1'b0, data_in[6:0]};

    // Parity logic (Mantendo sua lógica original baseada no comentário)
    wire xor8_all = ^data_in; 
    wire p_bit = parity_type ? ~xor8_all : xor8_all;
    assign parity_bit = p_bit;

    reg [MAX_FRAME-1:0] frame;
    integer idx; // Declarar integer fora ou dentro depende da versão do Verilog, aqui é seguro.

    always @(*) begin
        frame = {MAX_FRAME{1'b1}}; // Default IDLE (Stop levels)
        idx = 0;

        // 1. Start Bit
        frame[idx] = 1'b0;
        idx = idx + 1;

        // 2. Data
        if (data_width) begin // 8 bits
            frame[idx +: 8] = payload;
            idx = idx + 8;
        end else begin        // 7 bits
            frame[idx +: 7] = payload[6:0];
            idx = idx + 7;
        end

        // 3. Parity
        if (parity_en) begin
            frame[idx] = p_bit;
            idx = idx + 1;
        end

        // 4. Stop Bits (O resto do vetor já foi inicializado com 1, mas explícito ajuda)
        frame[idx] = 1'b1; // Primeiro Stop
        if (stop_bits) begin
            idx = idx + 1;
            frame[idx] = 1'b1; // Segundo Stop
        end
    end

    // Instanciação do Shift Register
    shift_register #(.WIDTH(MAX_FRAME)) sr (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .shift_en(shift_en),
        .parallel_in(frame),
        .serial_in(1'b1), // Preenche com 1 ao deslocar
        .parallel_out(),  // Não conectado
        .serial_out(serial_out)
    );

endmodule