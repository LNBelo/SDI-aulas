// 9896862 Lucas Nascimento Belo
module hex_to_7seg (
    input  [3:0] hex,
    output [6:0] segments  // abcdefg
);

// Sua solucao aqui
wire A, B, C, D;
assign A = hex[3];
assign B = hex[2];
assign C = hex[1];
assign D = hex[0];

wire a, b, c, d, e, f, g;
assign a = (~A & C) | (~A & B & D) | (A & ~B & ~C) | (A & ~D) | (~B & ~D) | (B & C);
assign b = (~A & ~C & ~D) | (~A & C & D) | (A & ~C & D) | (~B & ~D) | (~B & ~C);
assign c = (~A & B) | (A & ~B) | (~B & D) | (~B & ~C) | (~C  & D);
assign d = (~A & ~B &~D) | (A & ~C) | (B & ~C & D) | (~B & C & D) | (B & C & ~D);
assign e = (A & C) | (A & B) | (~B & ~D) | (C & ~D);
assign f = (~A & B & ~C) | (A & ~B) | (A & C) | (B & ~D) | (~C & ~D);
assign g = (A & ~B) | (~A & B & ~C) | (A & D) | (~B & C) | (C & ~D);

assign segments[0] = g;
assign segments[1] = f;
assign segments[2] = e;
assign segments[3] = d;
assign segments[4] = c;
assign segments[5] = b;
assign segments[6] = a;

endmodule