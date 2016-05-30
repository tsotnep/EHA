analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/XBAR.vhd
}

elaborate XBAR -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 32"

compile -exact_map

uplevel #0 { report_area } > ../reports/REPORTS_XBAR.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports/REPORTS_XBAR.txt

check_design > ../reports/WARNINGS_XBAR.txt
