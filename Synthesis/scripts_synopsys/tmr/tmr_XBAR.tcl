remove_design -designs
analyze -library WORK -format vhdl {
../../RTL/xbar.vhd
../../RTL/tmr/tmr_XBAR.vhd
../../RTL/tmr/voter.vhd
}

elaborate tmr_XBAR -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 32"

compile

uplevel #0 { report_area } > ../reports_synopsys/tmr/REPORTS_tmr_XBAR.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/tmr/REPORTS_tmr_XBAR.txt

check_design > ../reports_synopsys/tmr/WARNINGS/WARNINGS_tmr_XBAR.txt
