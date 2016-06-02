analyze -library WORK -format vhdl {
../../RTL/MUX/MUX_5x1_XBAR_output.vhd
../../RTL/MUX/MUX_5x1_LBDR_output.vhd
../../RTL/MUX/MUX_5x1_FIFO_output.vhd
../../RTL/MUX/MUX_5x1_Arbiter_output.vhd
../../RTL/MUX/MUX_5x1_XBAR_input.vhd
../../RTL/MUX/MUX_5x1_LBDR_input.vhd
../../RTL/MUX/MUX_5x1_FIFO_input.vhd
../../RTL/MUX/MUX_5x1_Arbiter_input.vhd
../../RTL/xbar.vhd
../../RTL/LBDR.vhd
../../RTL/FIFO.vhd
../../RTL/Arbiter.vhd
../../RTL/FaultControl/Fault_Control_v2.vhd
../../RTL/Router/Router_v2_syn.vhd}

elaborate ROUTER -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 32, current_address = 0, Rxy_rst = 60, Cx_rst = 10, NoC_size = 4"

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile -exact_map

uplevel #0 { report_area } > ../reports_synopsys/router/REPORTS_v2.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/router/REPORTS_v2.txt

check_design > ../reports_synopsys/router/WARNINGS/WARNINGS_v2.txt
