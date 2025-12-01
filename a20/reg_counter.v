// ********************************************************
// D Flip-Flop - Behavioral with always
module d_ff (
  input wire d,
  input wire clk, rst,
  output reg q
);
  always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
  end
endmodule

module t_ff (
  input wire t,
  input wire clk, rst,
  output reg q);
  always @(posedge clk or posedge rst) begin
      if (rst) begin
          q <= 1'b0;
      end else begin
          if (t == 1) begin
              q <= ~q; // Toggle
          end else begin
              q <= q; // No change
          end
      end
  end
endmodule


// ********************************************************
// Registers
module simple_reg_structural #(
    parameter WIDTH = 4
) (
    input wire clk,
    input wire rst,
    input wire [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            d_ff dff_inst (
                .d(d[i]),
                .clk(clk),
                .rst(rst),
                .q(q[i])
            );
        end
    endgenerate
endmodule
module simple_reg #(
    parameter WIDTH = 4
) (
    input wire clk,
    input wire rst,
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= {WIDTH{1'b0}};
        end else begin
            q <= d;
        end
    end    
endmodule

// ********************************************************
// Counters
module cnt_dff1 #(
    parameter WIDTH = 4
) (
    input wire clk,
    input wire rst,
    output [WIDTH-1:0] q
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (i == 0) begin
                d_ff dff_inst (
                    .d(~q[i]),
                    .clk(clk),
                    .rst(rst),
                    .q(q[i])
                );
            end
            else begin d_ff dff_inst (
                .d(q[i] ^ (&q[i-1:0])),
                .clk(clk),
                .rst(rst),
                .q(q[i])
            );
            end
        end
    endgenerate
endmodule
module cnt_dff2 #(
    parameter WIDTH = 4
) (
    input wire clk,
    input wire rst,
    output [WIDTH-1:0] q
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (i == 0) begin
                d_ff dff_inst (
                    .d(~q[i]),
                    .clk(clk),
                    .rst(rst),
                    .q(q[i])
                );
            end
            else d_ff dff_inst (
                .d(~q[i]),
                .clk(~q[i-1]),
                .rst(rst),
                .q(q[i])
            );
        end
    endgenerate
endmodule
module cnt_tff #(
    parameter WIDTH = 4
) (
    input wire clk,
    input wire rst,
    output [WIDTH-1:0] q
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (i == 0) begin
                t_ff tff_inst (
                    .t(1'b1),
                    .clk(clk), .rst(rst),
                    .q(q[i])
                );
            end
            else begin
            t_ff tff_inst (
                .t((i == 0) ? 1'b1 : &q[i-1:0]),
                .clk(clk), .rst(rst),
                .q(q[i])
            );
            end
        end
    endgenerate
endmodule
module cnt_always #(
    parameter WIDTH = 4
) (
    input wire clk,
    input wire rst,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= {WIDTH{1'b0}};
        end else begin
            q <= q + 1;
        end
    end
endmodule