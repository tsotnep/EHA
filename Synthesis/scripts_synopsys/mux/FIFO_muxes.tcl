remove_design -designs 
analyze -library WORK -format vhdl {
../../RTL/MUX/MUX_2x1_FIFO_output.vhd
}
elaborate MUX_2x1_FIFO_output -architecture RTL -library DEFAULT -parameters "DATA_WIDTH = 32"
compile -exact_map -ungroup_all
check_design > ../reports_synopsys/mux/WARNINGS/WARNINGS_MUX_FIFO.txt
uplevel #0 { report_area } > ../reports_synopsys/mux/area_FIFO.txt
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/mux/timing_FIFO.txt



remove_design -designs 
analyze -library WORK -format vhdl {
../../RTL/MUX/MUX_5x1_FIFO_input.vhd
}
elaborate MUX_5x1_FIFO_input -architecture RTL -library DEFAULT -parameters "DATA_WIDTH = 32"
compile -exact_map -ungroup_all
check_design >> ../reports_synopsys/mux/WARNINGS/WARNINGS_MUX_FIFO.txt
uplevel #0 { report_area } >> ../reports_synopsys/mux/area_FIFO.txt
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/mux/timing_FIFO.txt



remove_design -designs 
analyze -library WORK -format vhdl {
../../RTL/MUX/MUX_6x1_FIFO_output.vhd
}
elaborate MUX_6x1_FIFO_output -architecture RTL -library DEFAULT -parameters "DATA_WIDTH = 32"
compile -exact_map -ungroup_all
check_design >> ../reports_synopsys/mux/WARNINGS/WARNINGS_MUX_FIFO.txt
uplevel #0 { report_area } >> ../reports_synopsys/mux/area_FIFO.txt
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/mux/timing_FIFO.txt
