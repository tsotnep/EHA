remove_design -designs
analyze -library WORK -format vhdl {
../../RTL/FIFO.vhd
../../RTL/tmr/tmr_FIFO.vhd
../../RTL/tmr/voter.vhd}

elaborate TMR_FIFO -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 32"

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile

uplevel #0 { report_area } > ../reports_synopsys/tmr/REPORTS_tmr_FIFO.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/tmr/REPORTS_tmr_FIFO.txt

check_design > ../reports_synopsys/tmr/WARNINGS/WARNINGS_tmr_FIFO.txt
