remove_design -designs
analyze -library WORK -format vhdl {
../../RTL/tmr/voter.vhd}

elaborate voter -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 34"

compile

uplevel #0 { report_area } > ../reports_synopsys/tmr/REPORTS_tmr_voter_FIFO.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/tmr/REPORTS_tmr_voter_FIFO.txt

check_design > ../reports_synopsys/tmr/WARNINGS/WARNINGS_tmr_voter_FIFO.txt
