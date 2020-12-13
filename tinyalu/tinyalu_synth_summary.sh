egrep "^Number of cells:|^Number of sequential cells:|^Number of combinational cells:" tinyalu_synth.log > tinyalu_synth_summary.log
egrep "^Combinational area:|^Noncombinational area:|^Total cell area:" tinyalu_synth.log >> tinyalu_synth_summary.log
echo "DONE"

# Number of ports:                          117
# Number of nets:                           663
# Number of cells:                          518
# Number of combinational cells:            437
# Number of sequential cells:                78
# Number of macros/black boxes:               0
# Number of buf/inv:                         36
# Number of references:                       6

# Combinational area:                822.000000
# Buf/Inv area:                       36.000000
# Noncombinational area:             546.000000
# Macro/Black Box area:                0.000000
# Net Interconnect area:      undefined  (No wire load specified)

# Total cell area:                  1368.000000
# Total area:                 undefined

