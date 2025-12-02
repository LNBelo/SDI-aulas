`timescale 1ns/1ps

module shift_register #(parameter WIDTH = 8) (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire shift_en,
    input wire [WIDTH-1:0] parallel_in,
    input wire serial_in,
    output wire [WIDTH-1:0] parallel_out,
    output wire serial_out
);

    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= {WIDTH{1'b1}}; // Reset para 1 (Idle state da UART)
        end else if (load) begin
            shift_reg <= parallel_in;
        end else if (shift_en) begin
            // Deslocamento para a direita (LSB sai primeiro)
            shift_reg <= {serial_in, shift_reg[WIDTH-1:1]};
        end
    end

    assign parallel_out = shift_reg;
    assign serial_out = shift_reg[0]; // LSB é a saída serial

endmodule
