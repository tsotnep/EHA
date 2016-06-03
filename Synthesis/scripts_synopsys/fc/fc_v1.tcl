remove_design -designs 
analyze -library WORK -format vhdl {
../../RTL/FaultControl/Fault_Control_v1.vhd
}

elaborate Fault_Control_v1 -architecture RTL -library DEFAULT

compile -exact_map -ungroup_all

uplevel #0 { report_area } > ../reports_synopsys/fc/REPORTS_FC1.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/fc/REPORTS_FC1.txt

check_design > ../reports_synopsys/fc/WARNINGS/WARNINGS_FC1.txt
