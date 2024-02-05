`include "src/FP_ADD.v"

module tb;

    reg     [31:0] A, B;
    wire    [31:0] out;

    FP_ADD32 ADD (
        out, A, B
    );

    initial begin
        $dumpfile("build/FP_ADD.vcd");
        $dumpvars(0, tb);

        #1
        A = 32'h41080000;   // 8.5
        B = 32'h3F400000;   // 0.75
        
        #2 
        A = 32'h3FC00000;   // 1.5
        B = 32'h3FE00000;   // 1.75

        #2 
        A = 32'h40600000;   // 3.5
        B = 32'h3FC00000;   // 1.5

        #2 
        A = 32'h3F800000;   // 1
        B = 32'h3FC00000;   // 1.5
        
        #2 $finish;

    end

endmodule