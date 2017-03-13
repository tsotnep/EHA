remove_design -designs
analyze -library WORK -format vhdl {
../../RTL/ARBITER.vhd
../../RTL/dmr/dmr_ARBITER.vhd
../../RTL/dmr/dmr_voter.vhd
}

elaborate dmr_ARBITER -architecture BEHAVIOR -library DEFAULT

create_clock -name "clk" -period 20 -waveform { 0 10  }  { clk  }

compile

uplevel #0 { report_area } > ../reports_synopsys/dmr/REPORTS_dmr_ARBITER.txt

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> ../reports_synopsys/dmr/REPORTS_dmr_ARBITER.txt

check_design > ../reports_synopsys/dmr/WARNINGS/WARNINGS_dmr_ARBITER.txt
