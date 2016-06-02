analyze -library WORK -format vhdl {
../../RTL/MUX/MUX_2x1_Arbiter_output.vhd
}
elaborate MUX_2x1_Arbiter_output -architecture RTL -library DEFAULT
compile -exact_map
check_design > ../reports_synopsys/mux/WARNINGS/WARNINGS_MUX_Arbiter.txt
uplevel #0 { report_area } > ../reports_synopsys/mux/area_Arbiter.txt
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/mux/timing_Arbiter.txt



analyze -library WORK -format vhdl {
../../RTL/MUX/MUX_5x1_Arbiter_input.vhd
}
elaborate MUX_5x1_Arbiter_input -architecture RTL -library DEFAULT
compile -exact_map
check_design >> ../reports_synopsys/mux/WARNINGS/WARNINGS_MUX_Arbiter.txt
uplevel #0 { report_area } >> ../reports_synopsys/mux/area_Arbiter.txt
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/mux/timing_Arbiter.txt



analyze -library WORK -format vhdl {
../../RTL/MUX/MUX_6x1_Arbiter_output.vhd
}
elaborate MUX_6x1_Arbiter_output -architecture RTL -library DEFAULT
compile -exact_map
check_design >> ../reports_synopsys/mux/WARNINGS/WARNINGS_MUX_Arbiter.txt
uplevel #0 { report_area } >> ../reports_synopsys/mux/area_Arbiter.txt
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/mux/timing_Arbiter.txt
