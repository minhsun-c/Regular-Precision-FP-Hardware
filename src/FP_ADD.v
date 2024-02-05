`ifndef __FLOATING_POINT_ADDER
`define __FLOATING_POINT_ADDER

/* SUPPOSE SIGN_A == SIGN_B == 0 */

`include "src/CLA.v"
`include "src/ADD_SUB.v"

module FP_ADD32 #(
    parameter EXP_IEEE754 = 8,       // exponent in IEEE-754 standard
    parameter MTS_IEEE754 = 23      // mantissa in IEEE-754 standard
)(
    output  [31 : 0] ans,
    input   [31 : 0] A, B
);
    // ##########################################################
    /* SPECIFY FP COMPONENTS */
    // ##########################################################
    reg    [EXP_IEEE754 - 1 : 0]    exp_X;
    reg    [EXP_IEEE754 - 1 : 0]    exp_Y;
    reg    [MTS_IEEE754 - 1 : 0]    mts_X;
    reg    [MTS_IEEE754 - 1 : 0]    mts_Y;
    reg                             sign_X;
    reg                             sign_Y;
    wire                            isSameExp;

    assign isSameExp = 
        A[EXP_IEEE754 + MTS_IEEE754 - 1 : MTS_IEEE754] == 
        B[EXP_IEEE754 + MTS_IEEE754 - 1 : MTS_IEEE754];

    always @(*) begin
        if ( // A > B
            (A[EXP_IEEE754 + MTS_IEEE754 - 1 : MTS_IEEE754] > 
            B[EXP_IEEE754 + MTS_IEEE754 - 1 : MTS_IEEE754]) ||
            (
                isSameExp == 1'b1 &&
                A[MTS_IEEE754 - 1 : 0] > B[MTS_IEEE754 - 1 : 0]
            )
        ) begin
            mts_X   = A[MTS_IEEE754 - 1 : 0];
            mts_Y   = B[MTS_IEEE754 - 1 : 0];
            exp_X   = A[EXP_IEEE754 + MTS_IEEE754 - 1 : MTS_IEEE754];
            exp_Y   = B[EXP_IEEE754 + MTS_IEEE754 - 1 : MTS_IEEE754];
            sign_X  = A[EXP_IEEE754 + MTS_IEEE754];
            sign_Y  = B[EXP_IEEE754 + MTS_IEEE754];
        end
        else begin // A <= B
            mts_X   = B[MTS_IEEE754 - 1 : 0];
            mts_Y   = A[MTS_IEEE754 - 1 : 0];
            exp_X   = B[EXP_IEEE754 + MTS_IEEE754 - 1 : MTS_IEEE754];
            exp_Y   = A[EXP_IEEE754 + MTS_IEEE754 - 1 : MTS_IEEE754];
            sign_X  = B[EXP_IEEE754 + MTS_IEEE754];
            sign_Y  = A[EXP_IEEE754 + MTS_IEEE754];
        end
    end

    // ##########################################################
    /* EXPONENT DIFFERENCE */
    // ##########################################################
    wire    [EXP_IEEE754 - 1 : 0]   exp_diff;
    Adder_Subtractor8 ADDS(
        .Sum(exp_diff), .e_Sub(1'b1),
        .A(exp_X), .B(exp_Y)
    );

    // ##########################################################
    /* SHIFT RIGHT MANTISSA OF Y */ 
    // ##########################################################
    always @(*) begin
        #1 mts_Y = {1'b1, mts_Y} >> exp_diff;
    end

    // ##########################################################
    /* ADD MANTISSA : 23-BIT ADDITION */
    // ##########################################################
    wire    [MTS_IEEE754 - 1 : 0]   mts_sum;
    wire                            mts_cout;
    CLA #(23) ADDM(
        .Cout(mts_cout), .Sum(mts_sum), 
        .A(mts_X), .B(mts_Y), .Cin(1'b0)
    );

    // ##########################################################
    /* MTS_COUT == 1 : SHIFT RIGHT && ROUNDING && EXPONENT + 1 */
    // 4 cases:
    //  isSameExp == 0 && MTS_COUT == 0:    8.5 + 0.75
    //  isSameExp == 0 && MTS_COUT == 1:    3.5 + 1.5
    //  isSameExp == 1 && MTS_COUT == 0:    1.0 + 1.5
    //  isSameExp == 1 && MTS_COUT == 1:    1.5 + 1.75
    // ##########################################################
    reg     [31:0]                  ans_reg;
    reg     [EXP_IEEE754 - 1 : 0]   exp_p1;
    always @(*) begin
        exp_p1 = exp_X + 1;
        if (isSameExp == 1'b0 && mts_cout == 1'b0) begin
            ans_reg = {sign_X, exp_X, mts_sum};
        end
        else if (isSameExp == 1'b1 && mts_cout == 1'b1) begin
            ans_reg = {sign_X, exp_p1, 1'b1, mts_sum[MTS_IEEE754-1:1]};
        end
        else begin
            ans_reg = {sign_X, exp_p1, 1'b0, mts_sum[MTS_IEEE754-1:1]};
        end
    end
    assign ans = ans_reg;

endmodule

`endif