analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/Arbiter.vhd
}

elaborate Arbiter -architecture BEHAVIOR -library DEFAULT

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile -exact_map

uplevel #0 { report_area } > ../reports_synopsys/units/REPORTS_ARBITER.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/units/REPORTS_ARBITER.txt

check_design > ../reports_synopsys/units/WARNINGS/WARNINGS_ARBITER.txt
