def parseNeededInfo( f, mux=0):
    firstonly=1
    for line in f:
        line = line.rstrip('\n')
        if "Combinational area:" in line:
            print >> out, line
        if "Noncombinational area:" in line:
            print >> out, line
        if "Total area:" in line:
            print >> out, line
        if "Critical Path Length" in line:
            print >> out, line
        if firstonly==1 and "Design :" in line:
            print >> out, line
            if mux==0:
                firstonly = 0


out = open('../reports_synopsys/parsed_reports.txt', 'w')

# print >> out, "compilation: compile -exact_map -ungroup_all"

for v in range(5):
    with open("../reports_synopsys/router/REPORTS_v"+`v`+".txt") as f:
        print >> out, "\n\nversion >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ROUTER REPORTS_v"+`v`
        parseNeededInfo(f)
print >> out, "XXXXXXXXXXXXXXXXXXX"
print >> out, "XXXXXXXXXXXXXXXXXXX"
print >> out, "XXXXXXXXXXXXXXXXXXX"

for v in ["ARBITER", "FIFO", "LBDR", "XBAR"]:
    with open("../reports_synopsys/units/REPORTS_"+v+".txt") as f:
        print >> out, "\n\nversion >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> UNITS REPORTS_"+v
        parseNeededInfo(f)
print >> out, "XXXXXXXXXXXXXXXXXXX"
print >> out, "XXXXXXXXXXXXXXXXXXX"
print >> out, "XXXXXXXXXXXXXXXXXXX"


for v in ["FC1", "FCv2", "FCv3"]:
    with open("../reports_synopsys/fc/REPORTS_"+v+".txt") as f:
        print >> out, "\n\nversion >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FC REPORTS_"+v
        parseNeededInfo(f)
print >> out, "XXXXXXXXXXXXXXXXXXX"
print >> out, "XXXXXXXXXXXXXXXXXXX"
print >> out, "XXXXXXXXXXXXXXXXXXX"


for v in ["ARBITER", "FIFO", "LBDR", "XBAR"]:
    with open("../reports_synopsys/mux/area_"+v+".txt") as f:
        print >> out, "\n\nversion >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> mux REPORTS, area_"+v
        parseNeededInfo(f,1)
print >> out, "XXXXXXXXXXXXXXXXXXX"
print >> out, "XXXXXXXXXXXXXXXXXXX"
print >> out, "XXXXXXXXXXXXXXXXXXX"


for v in ["ARBITER", "FIFO", "LBDR", "XBAR"]:
    with open("../reports_synopsys/tmr/REPORTS_tmr_"+v+".txt") as f:
        print >> out, "\n\nversion >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> tmr REPORTS_"+v
        parseNeededInfo(f)
print >> out, "XXXXXXXXXXXXXXXXXXX"
print >> out, "XXXXXXXXXXXXXXXXXXX"
print >> out, "XXXXXXXXXXXXXXXXXXX"

print "Parsing is Done, results are in : ../reports_synopsys/parsed_reports.txt"


f.close()
