// Delay em tecnologia de 2nm, em ps
// NOT 0.2
// NAND2 0.5
// NOR2 0.6
// AND2 0.7
// OR2 0.8
// XOR2 1.2
// XNOR2 1.3
// Latch D 
//  - Standard cell, TSMC/Samsung 2nm: 2.1-3.2ps
//  - High Density: 3.5-5.5ps
//  - ts 08-1,5ps, th 0.2-0.5ps
`timescale 1ps/1fs

// ********************************************************
// Latch SR - Structural
module sr_latch_structural_nor (
  input wire s,r,
  output wire q
);
    wire qt, qt_n;
    assign qt = ~(r | qt_n);
    assign qt_n = ~(s | qt);
    assign q = qt;
endmodule
module sr_latch_structural_nand (
  input wire sn,rn,
  output wire q
);
    wire qt, qt_n;
    assign qt = ~(sn & qt_n);
    assign qt_n = ~(rn & qt);
    assign q = qt;
endmodule
module sr_latch_structural_e_nor (
  input wire s,r, e,
  output wire q
);
    wire qt, qt_n;
    assign qt = ~((e & r) | qt_n);
    assign qt_n = ~((e & s) | qt);
    assign q = qt;
endmodule
module sr_latch_structural_e_nand (
  input wire s,r, e,
  output wire q
);
    wire qt, qt_n;
    assign qt = ~(~(e & s) & qt_n);
    assign qt_n = ~(~(e & r) & qt);
    assign q = qt;
endmodule
// Latch SR - Structural with delays
module sr_latch_structural_nor_t (
  input wire s,r,
  output wire q
);
    wire qt, qt_n;
    assign #0.6 qt = ~(r | qt_n);
    assign #0.6 qt_n = ~(s | qt);
    assign q = qt;
endmodule
module sr_latch_structural_nand_t (
  input wire sn,rn,
  output wire q
);
    wire qt, qt_n;
    assign #0.5 qt = ~(sn & qt_n);
    assign #0.5 qt_n = ~(rn & qt);
    assign q = qt;
endmodule
module sr_latch_structural_e_nor_t (
  input wire s,r, e,
  output wire q
);
    wire qt, qt_n;
    assign #1.2 qt = ~((e & r) | qt_n);
    assign #1.2 qt_n = ~((e & s) | qt);
    assign q = qt;
endmodule
module sr_latch_structural_e_nand_t (
  input wire s,r, e,
  output wire q
);
    wire qt, qt_n;
    assign #1 qt = ~(~(e & s) & qt_n);
    assign #1 qt_n = ~(~(e & r) & qt);
    assign q = qt;
endmodule


// ********************************************************
// Latch D
// D Latch - Structural
module d_latch_structural (
  input wire d,
  input wire enable,
  output wire q
);
  wire dn;
  assign dn = ~d;
  sr_latch_structural_e_nand sr_lt(d, dn, enable, q);
endmodule
module d_latch_structural_t (
  input wire d,
  input wire enable,
  output wire q
);
  wire dn;
  assign #0.2 dn = ~d;
  sr_latch_structural_e_nand_t sr_lt (d, dn, enable, q);
endmodule
// D Latch - Behavioral with conditional assignment
module d_latch_behavioral_conditionalAssignment (
  input wire d,
  input wire enable,
  output wire q
);
    assign q = enable ? d : q;
endmodule
module d_latch_behavioral_conditionalAssignment_t (
  input wire d,
  input wire enable,
  output wire q
);
    assign #3 q = enable ? d : q;
endmodule
// D Latch - Behavioral with always
module d_latch_behavioral_always (
  input wire d,
  input wire enable,
  output reg q
);
  always @(d or enable) begin
      if (enable) begin
          q <= d;
      end
  end
endmodule
module d_latch_behavioral_always_t (
  input wire d,
  input wire enable,
  output reg q
);
  specify
    $setuphold(negedge enable, d, 1.2, 0.4);
  endspecify

  always @(d or enable) begin
      if (enable) begin
          #3 q <= d;
      end
  end
endmodule

// ********************************************************
// Flip-Flop D
// D Flip-Flop - Structural
module d_flipflop_structural (
  input wire d,
  input wire clk,
  output wire q
);
  wire d_latch_q;
  d_latch_structural d_ltp (d,  clk, d_latch_q);
  d_latch_structural d_lts (d_latch_q, ~clk, q);
endmodule
module d_flipflop_structural_t (
  input wire d,
  input wire clk,
  output wire q
);
  wire d_latch_q;
  d_latch_structural_t d_ltp (d,  clk, d_latch_q);
  d_latch_structural_t d_lts (d_latch_q, ~clk, q);
endmodule
// D Flip-Flop - Behavioral with always
module d_flipflop_behavioral_always (
  input wire d,
  input wire clk,
  output reg q
);
  always @(posedge clk) begin
      q <= d;
  end
endmodule
module d_flipflop_behavioral_always_t (
  input wire d,
  input wire clk,
  output reg q
);
  specify
    $setuphold(negedge enable, d, 1.2, 0.4);
  endspecify
  always @(posedge clk) begin
      #3 q <= d;
  end
endmodule

// ********************************************************
// JK Flip-Flop - Behavioral with always
module jk_flipflop_behavioral_always (
  input wire j,
  input wire k,
  input wire clk,
  output reg q
);  
  always @(posedge clk) begin
      if (j == 0 && k == 0) begin
          q <= q; // No change
      end else if (j == 0 && k == 1) begin
          q <= 0; // Reset
      end else if (j == 1 && k == 0) begin
          q <= 1; // Set
      end else begin
          q <= ~q; // Toggle
      end
  end
endmodule

// ********************************************************
// T Flip-Flop - Behavioral with always
module t_flipflop_behavioral_always (
  input wire t,
  input wire clk,
  output reg q);
  always @(posedge clk) begin
      if (t == 1) begin
          q <= ~q; // Toggle
      end else begin
          q <= q; // No change
      end
  end
endmodule
