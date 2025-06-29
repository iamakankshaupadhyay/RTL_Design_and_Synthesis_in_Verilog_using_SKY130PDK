/* Generated by Yosys 0.47+121 (git sha1 98b4affc4, g++ 13.2.0-23ubuntu4 -fPIC -O3) */

module fa(a, b, c, co, sum);
  wire _0_;
  wire _1_;
  wire _2_;
  wire _3_;
  wire _4_;
  wire _5_;
  wire _6_;
  wire _7_;
  input a;
  wire a;
  input b;
  wire b;
  input c;
  wire c;
  output co;
  wire co;
  output sum;
  wire sum;
  sky130_fd_sc_hd__maj3_1 _8_ (
    .A(_5_),
    .B(_3_),
    .C(_4_),
    .X(_6_)
  );
  sky130_fd_sc_hd__xor3_1 _9_ (
    .A(_5_),
    .B(_3_),
    .C(_4_),
    .X(_7_)
  );
  assign _5_ = c;
  assign _3_ = a;
  assign _4_ = b;
  assign co = _6_;
  assign sum = _7_;
endmodule

module rca(num1, num2, sum);
  wire [7:0] int_co;
  wire [7:0] int_sum;
  input [7:0] num1;
  wire [7:0] num1;
  input [7:0] num2;
  wire [7:0] num2;
  output [8:0] sum;
  wire [8:0] sum;
  fa \genblk1[1].u_fa_1  (
    .a(num1[1]),
    .b(num2[1]),
    .c(int_co[0]),
    .co(int_co[1]),
    .sum(int_sum[1])
  );
  fa \genblk1[2].u_fa_1  (
    .a(num1[2]),
    .b(num2[2]),
    .c(int_co[1]),
    .co(int_co[2]),
    .sum(int_sum[2])
  );
  fa \genblk1[3].u_fa_1  (
    .a(num1[3]),
    .b(num2[3]),
    .c(int_co[2]),
    .co(int_co[3]),
    .sum(int_sum[3])
  );
  fa \genblk1[4].u_fa_1  (
    .a(num1[4]),
    .b(num2[4]),
    .c(int_co[3]),
    .co(int_co[4]),
    .sum(int_sum[4])
  );
  fa \genblk1[5].u_fa_1  (
    .a(num1[5]),
    .b(num2[5]),
    .c(int_co[4]),
    .co(int_co[5]),
    .sum(int_sum[5])
  );
  fa \genblk1[6].u_fa_1  (
    .a(num1[6]),
    .b(num2[6]),
    .c(int_co[5]),
    .co(int_co[6]),
    .sum(int_sum[6])
  );
  fa \genblk1[7].u_fa_1  (
    .a(num1[7]),
    .b(num2[7]),
    .c(int_co[6]),
    .co(int_co[7]),
    .sum(int_sum[7])
  );
  fa u_fa_0 (
    .a(num1[0]),
    .b(num2[0]),
    .c(1'h0),
    .co(int_co[0]),
    .sum(int_sum[0])
  );
  assign sum = { int_co[7], int_sum };
endmodule
