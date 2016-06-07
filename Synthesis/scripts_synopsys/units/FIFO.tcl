remove_design -designs 
analyze -library WORK -format vhdl {
../../RTL/FIFO.vhd
}

elaborate FIFO -architecture BEHAVIOR -library DEFAULT -parameters "DATA_WIDTH = 32"

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile -map_effort high -area_effort high -power_effort high -incremental_mapping -ungroup_all -gate_clock

uplevel #0 { report_area } > ../reports_synopsys/units/REPORTS_FIFO.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/units/REPORTS_FIFO.txt

check_design > ../reports_synopsys/units/WARNINGS/WARNINGS_FIFO.txt
