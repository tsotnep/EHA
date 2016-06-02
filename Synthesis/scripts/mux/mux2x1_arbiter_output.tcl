analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/MUX/MUX_2x1_Arbiter_output.vhd
}

elaborate MUX_2x1_Arbiter_output -architecture RTL -library DEFAULT

compile -exact_map

uplevel #0 { report_area } > ../reports/REPORTS_MUX_2x1_Arbiter_output.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports/REPORTS_MUX_2x1_Arbiter_output.txt

check_design > ../reports/WARNINGS/WARNINGS_MUX_2x1_Arbiter_output.txt
