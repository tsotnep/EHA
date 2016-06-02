analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/MUX/MUX_2x1_XBAR_output.vhd
}
elaborate MUX_2x1_XBAR_output -architecture RTL -library DEFAULT
compile -exact_map
check_design > ../reports_synopsys/WARNINGS/WARNINGS_MUX_XBAR.txt
uplevel #0 { report_area } > ../reports_synopsys/mux/area_XBAR.txt
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/mux/timing_XBAR.txt



analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/MUX/MUX_5x1_XBAR_input.vhd
}
elaborate MUX_5x1_XBAR_input -architecture RTL -library DEFAULT
compile -exact_map
check_design >> ../reports_synopsys/WARNINGS/WARNINGS_MUX_XBAR.txt
uplevel #0 { report_area } >> ../reports_synopsys/mux/area_XBAR.txt
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/mux/timing_XBAR.txt



analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/MUX/MUX_6x1_XBAR_output.vhd
}
elaborate MUX_6x1_XBAR_output -architecture RTL -library DEFAULT
compile -exact_map
check_design >> ../reports_synopsys/WARNINGS/WARNINGS_MUX_XBAR.txt
uplevel #0 { report_area } >> ../reports_synopsys/mux/area_XBAR.txt
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/mux/timing_XBAR.txt
