analyze -library WORK -format vhdl {
../../RTL/FaultControl/Fault_Control_v2.vhd
}

elaborate Fault_Control_v2 -architecture RTL -library DEFAULT

compile -exact_map

uplevel #0 { report_area } > ../reports_synopsys/fc/REPORTS_FCv2.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/fc/REPORTS_FCv2.txt

check_design > ../reports_synopsys/fc/WARNINGS/WARNINGS_FCv2.txt
