remove_design -designs 
analyze -library WORK -format vhdl {
../../RTL/FaultControl/Fault_Control_v3.vhd
}

elaborate Fault_Control_v3 -architecture RTL -library DEFAULT

compile

uplevel #0 { report_area } > ../reports_synopsys/fc/REPORTS_FCv3.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/fc/REPORTS_FCv3.txt

check_design > ../reports_synopsys/fc/WARNINGS/WARNINGS_FCv3.txt
