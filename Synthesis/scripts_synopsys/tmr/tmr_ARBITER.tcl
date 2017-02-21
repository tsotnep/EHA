remove_design -designs
analyze -library WORK -format vhdl {
../../RTL/ARBITER.vhd
../../RTL/tmr/tmr_ARBITER.vhd
../../RTL/tmr/voter.vhd
}

elaborate tmr_ARBITER -architecture BEHAVIOR -library DEFAULT

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile -exact_map -area_effort none -power_effort none

uplevel #0 { report_area } > ../reports_synopsys/tmr/REPORTS_tmr_ARBITER.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/tmr/REPORTS_tmr_ARBITER.txt

check_design > ../reports_synopsys/tmr/WARNINGS/WARNINGS_tmr_ARBITER.txt
