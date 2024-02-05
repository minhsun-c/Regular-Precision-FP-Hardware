`ifndef __CARRY_LOOKAHEAD_ADDER
`define __CARRY_LOOKAHEAD_ADDER

`include "src/Full_Adder.v"

module CLA #(
    parameter WIDTH = 32
)(
    output  [WIDTH-1 : 0]   Sum,
    output                  Cout,
    input   [WIDTH-1 : 0]   A, B,
    input                   Cin
);
    wire    [WIDTH:0]       C;
    assign  C[0] = Cin;
    
    genvar i;
    generate for (i=0; i<WIDTH; i=i+1) begin
            Full_ADDER FA(C[i+1], Sum[i], A[i], B[i], C[i]);
        end
    endgenerate

    assign  Cout = C[WIDTH];
endmodule

`endif