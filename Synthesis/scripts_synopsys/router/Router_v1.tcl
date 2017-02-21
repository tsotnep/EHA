remove_design -designs
analyze -library WORK -format vhdl {
../../RTL/MUX/MUX_2x1_XBAR_output.vhd
../../RTL/MUX/MUX_2x1_LBDR_output.vhd
../../RTL/MUX/MUX_2x1_FIFO_output.vhd
../../RTL/MUX/MUX_2x1_ARBITER_output.vhd
../../RTL/MUX/MUX_5x1_XBAR_input.vhd
../../RTL/MUX/MUX_5x1_LBDR_input.vhd
../../RTL/MUX/MUX_5x1_FIFO_input.vhd
../../RTL/MUX/MUX_5x1_ARBITER_input.vhd
../../RTL/XBAR.vhd
../../RTL/LBDR.vhd
../../RTL/FIFO.vhd
../../RTL/ARBITER.vhd
../../RTL/FaultControl/Fault_Control_v1.vhd
../../RTL/Router/Router_v1_syn.vhd}

elaborate ROUTER -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 32, current_address = 0, Rxy_rst = 60, Cx_rst = 10, NoC_size = 4"

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile

uplevel #0 { report_area } > ../reports_synopsys/router/REPORTS_v1.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/router/REPORTS_v1.txt
report_qor >> ../reports_synopsys/router/REPORTS_v1.txt
check_design > ../reports_synopsys/router/WARNINGS/WARNINGS_v1.txt
