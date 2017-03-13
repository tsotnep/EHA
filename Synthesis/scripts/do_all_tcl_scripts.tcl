# HOW TO RUN THIS (ALL scripts) script (takes 70 seconds), from directory EHA/Synthesis/Synopsis :
    # cd EHA/Synthesis/Synopsis
    # cad, cad, 3.1a
    # design_vision -no_gui -f ../scripts/do_all_tcl_scripts.tcl
    # rm -f ../reports_synopsys/FULL_REPORT.txt && design_vision -no_gui -f ../scripts/do_all_tcl_scripts.tcl > ../reports_synopsys/FULL_REPORT.txt


file mkdir ../reports_synopsys/fc/WARNINGS
file mkdir ../reports_synopsys/units/WARNINGS
file mkdir ../reports_synopsys/router/WARNINGS
file mkdir ../reports_synopsys/mux/WARNINGS
file mkdir ../reports_synopsys/tmr/WARNINGS
file mkdir ../reports_synopsys/dmr/WARNINGS


echo ">>>>>UNITS<<<<<"
source -continue_on_error -verbose -echo ../scripts/units/ARBITER.tcl
source -continue_on_error -verbose -echo ../scripts/units/FIFO.tcl
source -continue_on_error -verbose -echo ../scripts/units/LBDR.tcl
source -continue_on_error -verbose -echo ../scripts/units/XBAR.tcl

echo ">>>>>FAULT CONTROLS<<<<<"
source -continue_on_error -verbose -echo ../scripts/fc/fc_v1.tcl
source -continue_on_error -verbose -echo ../scripts/fc/fc_v2.tcl
source -continue_on_error -verbose -echo ../scripts/fc/fc_v3.tcl

echo ">>>>>MUXES<<<<<"
source -continue_on_error -verbose -echo ../scripts/mux/ARBITER_muxes.tcl
source -continue_on_error -verbose -echo ../scripts/mux/FIFO_muxes.tcl
source -continue_on_error -verbose -echo ../scripts/mux/LBDR_muxes.tcl
source -continue_on_error -verbose -echo ../scripts/mux/XBAR_muxes.tcl

echo ">>>>>ROUTERS<<<<<"
source -continue_on_error -verbose -echo ../scripts/router/Router_v0.tcl
source -continue_on_error -verbose -echo ../scripts/router/Router_v1.tcl
source -continue_on_error -verbose -echo ../scripts/router/Router_v2.tcl
source -continue_on_error -verbose -echo ../scripts/router/Router_v3.tcl
source -continue_on_error -verbose -echo ../scripts/router/Router_v4.tcl
source -continue_on_error -verbose -echo ../scripts/router/Router_v5.tcl

echo ">>>>>TMR<<<<<"
source -continue_on_error -verbose -echo ../scripts/tmr/tmr_ARBITER.tcl
source -continue_on_error -verbose -echo ../scripts/tmr/tmr_FIFO.tcl
source -continue_on_error -verbose -echo ../scripts/tmr/tmr_LBDR.tcl
source -continue_on_error -verbose -echo ../scripts/tmr/tmr_XBAR.tcl
source -continue_on_error -verbose -echo ../scripts/tmr/tmr_voter_ARBITER.tcl
source -continue_on_error -verbose -echo ../scripts/tmr/tmr_voter_FIFO.tcl
source -continue_on_error -verbose -echo ../scripts/tmr/tmr_voter_LBDR.tcl
source -continue_on_error -verbose -echo ../scripts/tmr/tmr_voter_XBAR.tcl

echo ">>>>>DMR<<<<<"
source -continue_on_error -verbose -echo ../scripts/dmr/dmr_ARBITER.tcl
source -continue_on_error -verbose -echo ../scripts/dmr/dmr_FIFO.tcl
source -continue_on_error -verbose -echo ../scripts/dmr/dmr_LBDR.tcl
source -continue_on_error -verbose -echo ../scripts/dmr/dmr_XBAR.tcl
source -continue_on_error -verbose -echo ../scripts/dmr/dmr_voter_ARBITER.tcl
source -continue_on_error -verbose -echo ../scripts/dmr/dmr_voter_FIFO.tcl
source -continue_on_error -verbose -echo ../scripts/dmr/dmr_voter_LBDR.tcl
source -continue_on_error -verbose -echo ../scripts/dmr/dmr_voter_XBAR.tcl

exit
