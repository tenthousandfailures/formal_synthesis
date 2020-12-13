# initial setup
set_app_var fml_mode_on true
set_fml_appmode COV

set_app_var define_synthesis_macro false



set search_path "$search_path /global/apps/syn_2020.09/libraries/syn"

set_app_var link_library "* lsi_10k.db" 
set_app_var target_library "lsi_10k.db"

set design tinyalu
set filelist "tinyalu/tinyalu_netlist.filelist"

set covopt "line+tgl"
# set covopt "line"

set define "+define+op2_only +define+even"

# allow for property density report
set_fml_var fml_enable_prop_density_cov_map true

# allow for generation of "witness trace"
set_fml_var fml_cov_gen_trace on

# code coverage during reset
set_fml_var fml_reset_property_check true

# enable intentionally uncoverable
set_app_var fml_cov_enable_int_unr true

# read in the design with code coverage
analyze -format vhdl {/global/apps/syn_2020.09/libraries/syn/lsi_10k_components.vhd}
analyze -format sverilog -vcs "-f tinyalu/tinyalu_netlist.filelist ${define} "
elaborate $design -sva -cov ${covopt} -vcs "-cm_tgl mda "

# -netlist

# setup initial conditions
create_clock clk -period 100
create_reset reset_n -low

sim_run -stable
sim_save_reset

# extra save session
# save_session

# block doesn't allow interative use
check_fv -block

# REPORTS

# report_fv -list > results.txt
# report_fv -status uncoverable > results_uncoverable.txt

# save_covdb -name cov -status covered
# save_cov_exclusion -file unr.el

# saving for later - then do vcf -restore
# save_session
# quit
