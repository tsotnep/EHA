import fileinput

def REPLACE_WITH_NEW_COMMAND (filename):
    for line in fileinput.input(filename, inplace=True):
        if line.strip().startswith(CHANGE_LINE_STARTING_WITH):
            print WITH_THIS_NEW_COMMAND
        else:
            line = line.rstrip('\n')
            print line

CHANGE_LINE_STARTING_WITH='compile'
WITH_THIS_NEW_COMMAND='compile'

for v in range(7):
    REPLACE_WITH_NEW_COMMAND("router/Router_v"+`v`+".tcl")

for v in ["ARBITER", "FIFO", "LBDR", "XBAR"]:
    REPLACE_WITH_NEW_COMMAND("units/"+v+".tcl")

for v in ["v1", "v2", "v3"]:
    REPLACE_WITH_NEW_COMMAND("fc/fc_"+v+".tcl")

for v in ["ARBITER", "FIFO", "LBDR", "XBAR"]:
    REPLACE_WITH_NEW_COMMAND("mux/"+v+"_muxes.tcl")

for v in ["ARBITER", "FIFO", "LBDR", "XBAR"]:
    REPLACE_WITH_NEW_COMMAND("tmr/tmr_"+v+".tcl")

for v in ["ARBITER", "FIFO", "LBDR", "XBAR"]:
    REPLACE_WITH_NEW_COMMAND("tmr/tmr_voter_"+v+".tcl")

for v in ["ARBITER", "FIFO", "LBDR", "XBAR"]:
    REPLACE_WITH_NEW_COMMAND("dmr/dmr_"+v+".tcl")
