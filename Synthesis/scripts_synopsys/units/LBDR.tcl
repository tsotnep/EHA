remove_design -designs 
analyze -library WORK -format vhdl {
../../RTL/LBDR.vhd
}

elaborate LBDR -architecture BEHAVIOR -library DEFAULT -parameters "cur_addr_rst = 0, Rxy_rst = 60, Cx_rst = 10, NoC_size = 4"

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile

uplevel #0 { report_area } > ../reports_synopsys/units/REPORTS_LBDR.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/units/REPORTS_LBDR.txt

check_design > ../reports_synopsys/units/WARNINGS/WARNINGS_LBDR.txt
