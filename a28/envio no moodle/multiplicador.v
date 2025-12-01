// Pedro Sousa Goularte - 16897265
// Lucas Belo - 9896862
// Lana Rodrigues - 17109767

module multiplicador #(parameter n = 8) (
    input wire clk ,
    input wire reset ,
    input wire init ,
    input wire [n -1:0] A ,
    input wire [n -1:0] B ,
    input wire [n -1:0] N ,
    output wire [2* n -1:0] P ,
    output wire finish
);
    wire loadp;
    wire selp;
    wire loada;
    wire sela;
    wire loadb;
    wire selb;
    wire loadn;
    wire seln;

    wire [n -1:0] reg_b;
    wire [n -1:0] reg_n;

    uc #(.n(n)) unidade_controle (
        .clk(clk),
        .reset(reset), 
        .init(init),       
        .N(reg_n), 
        .B(reg_b), 

        .SELA(sela),
        .SELB(selb),
        .SELP(selp),
        .SELN(seln),
        .LOADA(loada),
        .LOADB(loadb),
        .LOADP(loadp),
        .LOADN(loadn),
        .finish(finish)
    );

    fd #(.n(n)) fluxo_dados (
        .clk(clk),
        .LOADP(loadp),
        .SELP(selp),
        .LOADA(loada),
        .SELA(sela),
        .LOADB(loadb),
        .SELB(selb),
        .LOADN(loadn),
        .SELN(seln),
        .A(A),
        .B(B),
        .N(N),

        .P(P),
        .REGN_out(reg_n),
        .REGB_out(reg_b)
    );

endmodule