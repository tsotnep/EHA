analyze -library WORK -format vhdl {
/home/INTRA/tsotne.putkaradze/P/workspace/EHA/RTL/FIFO.vhd
}

elaborate FIFO -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 32"

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile -exact_map

uplevel #0 { report_area } > ../reports/REPORTS_FIFO.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports/REPORTS_FIFO.txt

check_design > ../reports/WARNINGS_FIFO.txt