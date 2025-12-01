module mux2 #(
    parameter N = 8
) (
    input  wire [N-1:0] I0,
    input  wire [N-1:0] I1,
    input  wire sel,
    output wire [N-1:0] y
);

    assign y = sel ? I1 : I0;

endmodule
