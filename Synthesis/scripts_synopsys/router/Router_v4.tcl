#TMR
remove_design -designs
analyze -library WORK -format vhdl {
../../RTL/xbar.vhd
../../RTL/LBDR.vhd
../../RTL/FIFO.vhd
../../RTL/Arbiter.vhd
../../RTL/tmr/tmr_xbar.vhd
../../RTL/tmr/tmr_LBDR.vhd
../../RTL/tmr/tmr_FIFO.vhd
../../RTL/tmr/tmr_Arbiter.vhd
../../RTL/tmr/voter.vhd
../../RTL/Router/Router_v4_syn.vhd}

elaborate ROUTER -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 32, current_address = 0, Rxy_rst = 60, Cx_rst = 10, NoC_size = 4"

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile

uplevel #0 { report_area } > ../reports_synopsys/router/REPORTS_v4.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/router/REPORTS_v4.txt

report_qor >> ../reports_synopsys/router/REPORTS_v4.txt
check_design > ../reports_synopsys/router/WARNINGS/WARNINGS_v4.txt
