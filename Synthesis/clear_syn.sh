rm -rf Synopsys
mkdir Synopsys
cd Synopsys
wget http://ati.ttu.ee/IAY0340/labs/general/Design_Vision_Guide_Files/.synopsys_dc.setup
mkdir WORK.syn


###sed -i -- 's/analyze -library WORK -format vhdl/remove_design -designs '\\n'analyze -library WORK -format vhdl/g' *
###sed -i -- 's/compile -exact_map/compile -exact_map -ungroup_all/g' *
