remove_design -designs
analyze -library WORK -format vhdl {
../../RTL/dmr/voter.vhd}

elaborate voter -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 32"

compile

uplevel #0 { report_area } > ../reports_synopsys/dmr/REPORTS_dmr_voter_XBAR.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/dmr/REPORTS_dmr_voter_XBAR.txt

check_design > ../reports_synopsys/dmr/WARNINGS/WARNINGS_dmr_voter_XBAR.txt
