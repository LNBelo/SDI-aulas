`timescale 1ns/1ps

module parity_generator #(parameter WIDTH = 8) (
    input wire [WIDTH-1:0] data_in,
    input wire parity_type, // 0 = par, 1 = ímpar
    output wire parity_out
);

    wire parity;
    assign parity = ^data_in;

    assign parity_out = parity_type ? ~parity : parity;

endmodule