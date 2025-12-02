`timescale 1ns/1ps

module tx (
    input wire clk,
    input wire rst_n,
    input wire start_tx,
    input wire [7:0] data_in,
    input wire parity_type,
    input wire parity_en,
    input wire stop_bits,
    input wire data_width,
    output wire serial_out,
    output wire parity_bit,
    output wire tx_done
);

    wire load_w;
    wire shift_en_w;
    wire reset_fd_w;
    wire stop_bit_done_w;

    reg [3:0] bit_counter;
    reg [3:0] total_bits;

    // Calcula o número total de bits do frame
    always @(*) begin
        total_bits = 1 + (data_width ? 8 : 7) + (parity_en ? 1 : 0) + (stop_bits ? 2 : 1);
    end

    // Conta pulsos de shift_en. Reseta quando load está ativo.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_counter <= 0;
        end else begin
            if (load_w) begin
                bit_counter <= 0;
            end else if (shift_en_w) begin
                bit_counter <= bit_counter + 1;
            end
        end
    end

    // Gera o sinal de parada quando o contador atinge o total de bits
    assign stop_bit_done_w = (bit_counter >= total_bits);

    tx_uc u_control_unit (
        .clk(clk),
        .rst_n(rst_n),
        .start_tx(start_tx),
        .stop_bit_done(stop_bit_done_w),
        .reset_fd(reset_fd_w), 
        .load(load_w),
        .shift_en(shift_en_w),
        .tx_done(tx_done)
    );

    tx_fd u_data_flow (
        .clk(clk),
        .rst_n(rst_n), 
        .load(load_w),
        .data_in(data_in),
        .shift_en(shift_en_w),
        .parity_type(parity_type),
        .parity_en(parity_en),
        .stop_bits(stop_bits),
        .data_width(data_width),
        .serial_out(serial_out),
        .parity_bit(parity_bit)
    );

endmodule
