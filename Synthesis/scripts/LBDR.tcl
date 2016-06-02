analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/LBDR.vhd
}

elaborate LBDR -architecture BEHAVIOR -library DEFAULT -parameters "cur_addr_rst = 0, Rxy_rst = 60, Cx_rst = 10, NoC_size = 4"

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile -exact_map

uplevel #0 { report_area } > ../reports/REPORTS_LBDR.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports/REPORTS_LBDR.txt

check_design > ../reports/WARNINGS/WARNINGS_LBDR.txt
