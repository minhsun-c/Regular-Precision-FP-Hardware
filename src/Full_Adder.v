`ifndef __FULL_ADDER
`define __FULL_ADDER

module Full_ADDER (
    output Cout, Sum,
    input A, B, Cin
);
    assign Cout = (Cin & (A ^ B)) | (A & B);
    assign Sum  = A ^ B ^ Cin;
endmodule

`endif