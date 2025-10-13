// NOT: 2
// XOR2: 12
// XOR3: 20
// FI aND OR
// 2  7   8
// 3  10  12
// 4  13  16
// 5  16  20
// 6  19  24
// 7  22 
// 8  25

module cla8t (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    
    wire [8:0] c;  // c[0] = cin, c[8] = carry final
    assign #0 c[0] = cin;

    // bit 0
    assign #(12+12) sum[0] = a[0] ^ b[0] ^ c[0];
    assign #(7+12) c[1]   = (a[0] & b[0]) | (a[0] & c[0]) | (b[0] & c[0]);

    // bit 1
    assign #(12) sum[1] = a[1] ^ b[1] ^ c[1];
    assign #(7+12) c[2] = (a[1] & b[1]) | (a[1] & c[1]) | (b[1] & c[1]);

    // bit 2
    assign #(12) sum[2] = a[2] ^ b[2] ^ c[2];
    assign #(7+12) c[3]   = (a[2] & b[2]) | (a[2] & c[2]) | (b[2] & c[2]);

    // bit 3
    assign #(12) sum[3] = a[3] ^ b[3] ^ c[3];
    assign #(7+12) c[4]   = (a[3] & b[3]) | (a[3] & c[3]) | (b[3] & c[3]);

    // bit 4
    assign #(12) sum[4] = a[4] ^ b[4] ^ c[4];
    assign #(7+12) c[5]   = (a[4] & b[4]) | (a[4] & c[4]) | (b[4] & c[4]);

    // bit 5
    assign #(12) sum[5] = a[5] ^ b[5] ^ c[5];
    assign #(7+12) c[6]   = (a[5] & b[5]) | (a[5] & c[5]) | (b[5] & c[5]);

    // bit 6
    assign #(12) sum[6] = a[6] ^ b[6] ^ c[6];
    assign #(7+12) c[7]   = (a[6] & b[6]) | (a[6] & c[6]) | (b[6] & c[6]);

    // bit 7
    assign #(12) sum[7] = a[7] ^ b[7] ^ c[7];
    assign #(7+12) c[8]   = (a[7] & b[7]) | (a[7] & c[7]) | (b[7] & c[7]);

    assign cout = c[8];

endmodule