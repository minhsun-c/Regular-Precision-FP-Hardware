FILE=FP_ADD
iverilog -o build/$FILE test/tb_$FILE.v
vvp build/$FILE
# open $GTKWAVE build/$FILE.vcd
