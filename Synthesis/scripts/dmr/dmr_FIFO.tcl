remove_design -designs
analyze -library WORK -format vhdl {
../../RTL/FIFO.vhd
../../RTL/dmr/dmr_FIFO.vhd}

elaborate dmr_FIFO -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 32"

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile

uplevel #0 { report_area } > ../reports_synopsys/dmr/REPORTS_dmr_FIFO.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/dmr/REPORTS_dmr_FIFO.txt

check_design > ../reports_synopsys/dmr/WARNINGS/WARNINGS_dmr_FIFO.txt
