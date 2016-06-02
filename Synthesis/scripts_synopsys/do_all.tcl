# HOW TO RUN THIS (ALL scripts) script (takes 70 seconds), from directory EHA/Synthesis/Synopsis :
    # design_vision -no_gui -f ../scripts_synopsys/do_all.tcl
    # design_vision -no_gui -f ../scripts_synopsys/do_all.tcl > REPORT.txt


file mkdir ../reports_synopsys/fc/WARNINGS
file mkdir ../reports_synopsys/units/WARNINGS
file mkdir ../reports_synopsys/router/WARNINGS
file mkdir ../reports_synopsys/mux/WARNINGS

echo ">>>>>UNITS<<<<<"
source -continue_on_error -verbose -echo ../scripts_synopsys/units/ARBITER.tcl
source -continue_on_error -verbose -echo ../scripts_synopsys/units/FIFO.tcl
source -continue_on_error -verbose -echo ../scripts_synopsys/units/LBDR.tcl
source -continue_on_error -verbose -echo ../scripts_synopsys/units/XBAR.tcl

echo ">>>>>FAULT CONTROLS<<<<<"
source -continue_on_error -verbose -echo ../scripts_synopsys/fc/fc_v1.tcl
source -continue_on_error -verbose -echo ../scripts_synopsys/fc/fc_v2.tcl
source -continue_on_error -verbose -echo ../scripts_synopsys/fc/fc_v3.tcl

echo ">>>>>MUXES<<<<<"
source -continue_on_error -verbose -echo ../scripts_synopsys/mux/arbiter_muxes.tcl
source -continue_on_error -verbose -echo ../scripts_synopsys/mux/FIFO_muxes.tcl
source -continue_on_error -verbose -echo ../scripts_synopsys/mux/LBDR_muxes.tcl
source -continue_on_error -verbose -echo ../scripts_synopsys/mux/XBAR_muxes.tcl

echo ">>>>>ROUTERS<<<<<"
source -continue_on_error -verbose -echo ../scripts_synopsys/router/Router_v0.tcl
source -continue_on_error -verbose -echo ../scripts_synopsys/router/Router_v1.tcl
source -continue_on_error -verbose -echo ../scripts_synopsys/router/Router_v2.tcl
source -continue_on_error -verbose -echo ../scripts_synopsys/router/Router_v3.tcl

exit
