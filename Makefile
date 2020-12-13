GUI=-gui

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: ## runs the clean target to remove generated files and logs
	@echo "  clean start"
	@rm -rf \
	*.log \
	.certitudeGUI \
	novas.* \
	vcst_rtdb \
	vcst* \
	vdCovLog \
	verdiLog \
	*~ \
	*\*~ \
	.*~ \
	*.bak \
	*.fsdb \
	AN.DB \
	csrc \
	simv \
	simv.daidir \
	toggle.csv \
	ucli.key \
	work.lib++ \
	default.svf \
	alib-52 \
	netlist.v \
	64 \
	via.rc \
	VAPTC_WORK \
	novas_libs \
	unr.el
	@echo "  clean end"

tinyalu: tinyalu_restore ## runs VC Formal on the tinyalu RTL design
	@vcf -f tinyalu/tinyalu.tcl ${GUI}

tinyalu_netlist: clean ## runs VC Formal on the tinyalu synthesized netlist
	@vcf -f tinyalu/tinyalu_netlist.tcl ${GUI}

tinyalu_vcs: tinyalu_restore ## runs VCS simulation on the tinyalu RTL design
	@vlogan -kdb -sverilog -full64 -l tinyalu_vlogan.log -f tinyalu/tinyalu.filelist
	@vcs -kdb -debug_access+all -top top -full64 -l tinyalu_vcs.log
	@simv -l tinyalu_run.log ${GUI}

tinyalu_synth: tinyalu_restore ## runs Design Compiler synthesis on the tinyalu RTL design
	@dc_shell -f tinyalu/tinyalu_synth.tcl -output_log_file tinyalu_synth.log
	@./tinyalu/tinyalu_synth_summary.sh

tinyalu_synth_ex1: tinyalu_synth_ex1_cp ## runs Design Compiler synthesis on the tinyalu RTL design ex1
	@dc_shell -f tinyalu/tinyalu_synth.tcl -output_log_file tinyalu_synth.log
	@./tinyalu/tinyalu_synth_summary.sh

tinyalu_synth_ex1_cp: clean
	@cp tinyalu/tinyalu.sv.nomult tinyalu/tinyalu.sv

tinyalu_synth_ex2: tinyalu_synth_ex2_cp ## runs Design Compiler synthesis on the tinyalu RTL design ex2
	@dc_shell -f tinyalu/tinyalu_synth.tcl -output_log_file tinyalu_synth.log
	@./tinyalu/tinyalu_synth_summary.sh

tinyalu_synth_ex2_cp: clean
	@cp tinyalu/netlist.v.edit1 tinyalu/tinyalu.sv

tinyalu_restore: clean ## restores the tinyalu design back to default
	@cp tinyalu/tinyalu.sv.orig tinyalu/tinyalu.sv

tinyalu_verdi: clean ## runs Synopsys Verdi with the lsi10k_u symbols loaded
	@. ./novas_libs.sh && echo $$NOVAS_LIBS && verdi

pattern: clean ## runs VC Formal on the pattern RTL design
	@vcf -f pattern/pattern.tcl ${GUI}

pattern_vcs: clean ## runs VCS simulation on the pattern RTL design
	@vlogan -kdb -sverilog -full64 -l pattern_vlogan.log -f pattern/pattern.filelist
	@vcs -kdb -debug_access+all -top top -full64 -l pattern_vcs.log
	@simv -l pattern_run.log ${GUI}

pattern_synth: clean ## runs Design Compiler synthesis on the pattern RTL design
	@echo "  pattern_synth start"
	@dc_shell -f pattern/pattern_synth.tcl -output_log_file pattern_synth.log
	@./pattern/pattern_synth_summary.sh
	@echo "  pattern_synth end"

