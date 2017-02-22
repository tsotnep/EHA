remove_design -designs
analyze -library WORK -format vhdl {
../../RTL/LBDR.vhd
../../RTL/tmr/tmr_LBDR.vhd
../../RTL/tmr/voter.vhd
}

elaborate tmr_LBDR -architecture BEHAVIOR -library DEFAULT -parameters "cur_addr_rst = 0, Rxy_rst = 60, Cx_rst = 10, NoC_size = 4"

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile

uplevel #0 { report_area } > ../reports_synopsys/tmr/REPORTS_tmr_LBDR.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/tmr/REPORTS_tmr_LBDR.txt

check_design > ../reports_synopsys/tmr/WARNINGS/WARNINGS_tmr_LBDR.txt
