cd /home/tsotne/ownCloud/git/EHA_ft/Simulation/ && mkdir tmp tmp/or tmp/sr tmp/cp tmp/sa

cd /home/tsotne/ownCloud/git/EHA_ft/Simulation/tmp/or && vsim -do ../../scripts/sim_or.do
cd /home/tsotne/ownCloud/git/EHA_ft/Simulation/tmp/sr && vsim -do ../../scripts/sim_sr.do
cd /home/tsotne/ownCloud/git/EHA_ft/Simulation/tmp/cp && vsim -do ../../scripts/sim_cp.do
cd /home/tsotne/ownCloud/git/EHA_ft/Simulation/tmp/sa && vsim -do ../../scripts/sim_sa.do


cd /home/tsotne/ownCloud/git/EHA_ft/Simulation
rm latency_or.txt latency_sr.txt latency_cp.txt latency_sa.txt -f
python scripts/calculate_latency.py -S tmp/or/sent.txt -R tmp/or/recieved.txt > latency_or.txt
python scripts/calculate_latency.py -S tmp/sr/sent.txt -R tmp/sr/recieved.txt > latency_sr.txt
python scripts/calculate_latency.py -S tmp/cp/sent.txt -R tmp/cp/recieved.txt > latency_cp.txt
python scripts/calculate_latency.py -S tmp/sa/sent.txt -R tmp/sa/recieved.txt > latency_sa.txt


echo "LATENCY_OR:" && cat latency_or.txt
echo "LATENCY_SR:" && cat latency_sr.txt
echo "LATENCY_CP:" && cat latency_cp.txt
echo "LATENCY_SA:" && cat latency_sa.txt

echo
