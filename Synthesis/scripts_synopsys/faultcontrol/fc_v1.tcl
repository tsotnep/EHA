analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/FaultControl/Fault_Control_v1.vhd
}

elaborate Fault_Control_v1 -architecture RTL -library DEFAULT

compile -exact_map

uplevel #0 { report_area } > ../reports_synopsys/REPORTS_FC1.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/REPORTS_FC1.txt

check_design > ../reports_synopsys/WARNINGS/WARNINGS_FC1.txt
