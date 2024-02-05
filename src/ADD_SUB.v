`ifndef __INTEGER_ADDER_SUBTRACTOR
`define __INTEGER_ADDER_SUBTRACTOR
`include "src/Full_Adder.v"

module Adder_Subtractor (
    output  Cout, Sum,
    input   A, B, Cin, e_Sub
);
    wire post_B;
    assign post_B = e_Sub ^ B;
    Full_ADDER FA(
        .Cout(Cout), .Sum(Sum),
        .A(A), .B(post_B), .Cin(Cin)
    );
endmodule

module Adder_Subtractor8 (
    output  [7:0]   Sum,
    output          Cout,
    input           e_Sub,
    input   [7:0]   A, B
);
    wire C1, C2, C3, C4, C5, C6, C7;
    Adder_Subtractor AS0(.Cout(C1),      .Sum(Sum[0]), .A(A[0]), .B(B[0]), .Cin(e_Sub),  .e_Sub(e_Sub));
    Adder_Subtractor AS1(.Cout(C2),      .Sum(Sum[1]), .A(A[1]), .B(B[1]), .Cin(C1),     .e_Sub(e_Sub));
    Adder_Subtractor AS2(.Cout(C3),      .Sum(Sum[2]), .A(A[2]), .B(B[2]), .Cin(C2),     .e_Sub(e_Sub));
    Adder_Subtractor AS3(.Cout(C4),      .Sum(Sum[3]), .A(A[3]), .B(B[3]), .Cin(C3),     .e_Sub(e_Sub));
    Adder_Subtractor AS4(.Cout(C5),      .Sum(Sum[4]), .A(A[4]), .B(B[4]), .Cin(C4),     .e_Sub(e_Sub));
    Adder_Subtractor AS5(.Cout(C6),      .Sum(Sum[5]), .A(A[5]), .B(B[5]), .Cin(C5),     .e_Sub(e_Sub));
    Adder_Subtractor AS6(.Cout(C7),      .Sum(Sum[6]), .A(A[6]), .B(B[6]), .Cin(C6),     .e_Sub(e_Sub));
    Adder_Subtractor AS7(.Cout(Cout),    .Sum(Sum[7]), .A(A[7]), .B(B[7]), .Cin(C7),     .e_Sub(e_Sub));
endmodule

`endif