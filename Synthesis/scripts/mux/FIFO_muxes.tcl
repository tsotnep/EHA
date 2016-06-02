analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/MUX/MUX_2x1_FIFO_output.vhd
}
elaborate MUX_2x1_FIFO_output -architecture RTL -library DEFAULT
compile -exact_map
check_design > ../reports/WARNINGS/WARNINGS_MUX_FIFO.txt
uplevel #0 { report_area } > ../reports/MUX/area_FIFO.txt
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports/MUX/timing_FIFO.txt



analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/MUX/MUX_5x1_FIFO_input.vhd
}
elaborate MUX_5x1_FIFO_input -architecture RTL -library DEFAULT
compile -exact_map
check_design >> ../reports/WARNINGS/WARNINGS_MUX_FIFO.txt
uplevel #0 { report_area } >> ../reports/MUX/area_FIFO.txt
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports/MUX/timing_FIFO.txt



analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/MUX/MUX_6x1_FIFO_output.vhd
}
elaborate MUX_6x1_FIFO_output -architecture RTL -library DEFAULT
compile -exact_map
check_design >> ../reports/WARNINGS/WARNINGS_MUX_FIFO.txt
uplevel #0 { report_area } >> ../reports/MUX/area_FIFO.txt
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports/MUX/timing_FIFO.txt
