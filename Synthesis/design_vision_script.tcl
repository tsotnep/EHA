analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/xbar.vhd
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/LBDR.vhd
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/FIFO.vhd
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/Arbiter.vhd
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/FaultControl/Fault_Control_v1.vhd
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/Router.vhd}

elaborate ROUTER -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 32, current_address = 0, Rxy_rst = 60, Cx_rst = 10, NoC_size = 4"

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile -exact_map

uplevel #0 { report_area } >> REPORTS.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> REPORTS.txt

check_design >> WARNINGS.txt

cp REPORTS.txt ../../EHA/RTL/reports/
cp WARNINGS.txt ../../EHA/RTL/reports/
