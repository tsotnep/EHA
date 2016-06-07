remove_design -designs 
analyze -library WORK -format vhdl {
../../RTL/XBAR.vhd
}

elaborate XBAR -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 32"

compile -map_effort high -area_effort high -power_effort high -incremental_mapping -ungroup_all -gate_clock

uplevel #0 { report_area } > ../reports_synopsys/units/REPORTS_XBAR.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/units/REPORTS_XBAR.txt

check_design > ../reports_synopsys/units/WARNINGS/WARNINGS_XBAR.txt
