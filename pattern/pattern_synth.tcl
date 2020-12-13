# Specify the libraries
set_app_var search_path "$search_path /global/apps/syn_2020.09/libraries/syn"
set_app_var link_library "* lsi_10k.db" 
set_app_var target_library "lsi_10k.db"
# create_mw_lib -technology $mw_tech_file \
# -mw_reference_library $mw_reference_library $mw_lib_name
# open_mw_lib $mw_lib_name

# Read the design 
# read_verilog rtl.v
read_sverilog pattern/pattern.sv

current_design pattern

# Define the design environment
# set_load 2.2 sout
# set_load 1.5 cout
# set_driving_cell -lib_cell FD1 [all_inputs]

# Set the optimization constraints
create_clock clk -period 100
# set_input_delay -max 1.35 -clock clk {ain bin}
# set_input_delay -max 3.5 -clock clk cin
# set_output_delay -max 2.4 -clock clk cout
# extract_physical_constraints def_file_name 

# Map and optimize the design 
# compile_ultra
compile_ultra -no_autoungroup

change_names -rules verilog -hierarchy 

# Analyze and debug the design
report_timing
report_area
report_por

# Save the design database
# write_file -format ddc -hierarchy -output top_synthesized.ddc
write_file -format verilog -hierarchy -output netlist.v 
# write_sdf sdf_file_name
# write_parasitics -output parasitics_file_name 
# write_sdc sdc_file_name 
# write_floorplan -all phys_cstr_file_name.tcl

quit
