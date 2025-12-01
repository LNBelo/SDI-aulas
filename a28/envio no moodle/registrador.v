module registrador #(
    parameter N = 8
) (
    input  wire clk,
    input  wire load,
    input  wire [N-1:0] d,
    output reg  [N-1:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= d;
        end
    end

endmodule
