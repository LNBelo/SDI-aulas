// Pedro Sousa Goularte - 16897265
// Lucas Belo - 9896862
// Lana Rodrigues - 17109767

module fd #(parameter n = 8) (
    input wire clk ,
    input wire LOADP , 
    input wire SELP , 
    input wire LOADA , 
    input wire SELA , 
    input wire LOADB , 
    input wire SELB , 
    input wire LOADN , 
    input wire SELN , 
    input wire [n -1:0] A , 
    input wire [n -1:0] B , 
    input wire [n -1:0] N , 
    output wire [2* n -1:0] P , 
    output wire [n -1:0] REGN_out , 
    output wire [n -1:0] REGB_out 
);

    //REGN e S2
    wire [n -1:0] muxn_out;
    wire [n -1:0] subn_out;
    
    mux2 #(.N(n)) mux_REGN (
        .I0(N),           
        .I1(subn_out),    
        .sel(SELN),
        .y(muxn_out)
    );

    wire [n - 1:0] regn_out;
    registrador #(.N(n)) REGN (
        .clk(clk),
        .load(LOADN),
        .d(muxn_out),
        .q(regn_out)
    );
    assign REGN_out = regn_out;

    adder #(.N(n)) S2 (
        .a(regn_out),
        .b({n{1'b1}}),
        .soma(subn_out)
    );

    //REGB 
    wire [n -1:0] shift_r_B;
    wire [n -1:0] regb_out;
    wire [n -1:0] muxb_out;

    mux2 #(.N(n)) mux_REGB (
        .I0(B),           
        .I1(shift_r_B),   
        .sel(SELB),
        .y(muxb_out)
    );

    registrador #(.N(n)) REGB (
        .clk(clk),
        .load(LOADB),
        .d(muxb_out),
        .q(regb_out)
    );
    
    assign shift_r_B = {1'b0, regb_out[n-1:1]}; 
    assign REGB_out = regb_out;


    //REGA
    wire [2*n -1:0] muxa_out;
    wire [2*n -1:0] rega_out;
    wire [2*n -1:0] shift_l_A;

    mux2 #(.N(2*n)) mux_REGA (
        .I0({{n{1'b0}}, A}), 
        .I1(shift_l_A),      
        .sel(SELA),
        .y(muxa_out)
    );

    registrador #(.N(2*n)) REGA (
        .clk(clk),
        .load(LOADA),
        .d(muxa_out),
        .q(rega_out)
    );
    
    assign shift_l_A = {rega_out[2*n-2:0], 1'b0}; 

    //REGP
    wire [2*n -1:0] muxp_out;
    wire [2*n -1:0] regp_out;
    wire [2*n -1:0] adder1_out;

    mux2 #(.N(2*n)) mux_REGP (
        .I0({(2*n){1'b0}}), 
        .I1(adder1_out),    
        .sel(SELP),
        .y(muxp_out)
    );

    registrador #(.N(2*n)) REGP (
        .clk(clk),
        .load(LOADP),
        .d(muxp_out),
        .q(regp_out)
    );
    assign P = regp_out;

    //S1
    adder #(.N(2*n)) S1 (
        .a(regp_out),
        .b(rega_out),
        .soma(adder1_out)
    );

endmodule