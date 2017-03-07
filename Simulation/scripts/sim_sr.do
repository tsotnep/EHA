#########################################
# Copyright (C) 2016 Project Bonfire    #
#                                       #
# This file is automatically generated! #
#             DO NOT EDIT!              #
#########################################

vlib work

# Include files and compile them


vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/gen/TB_Package.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/FIFO.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/LBDR.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/XBAR.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/ARBITER.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/MUX/MUX_2x1_LBDR_output.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/MUX/MUX_2x1_XBAR_output.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/MUX/MUX_2x1_FIFO_output.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/MUX/MUX_2x1_ARBITER_output.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/MUX/MUX_5x1_LBDR_input.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/MUX/MUX_5x1_XBAR_input.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/MUX/MUX_5x1_FIFO_input.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/MUX/MUX_5x1_ARBITER_input.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/MUX/MUX_5x1_LBDR_output.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/MUX/MUX_5x1_XBAR_output.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/MUX/MUX_5x1_FIFO_output.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/MUX/MUX_5x1_ARBITER_output.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/FaultControl/Fault_Control_v1.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/Router/Router_v1_sim.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/gen/network_2x2.vhd"
vcom "/home/tsotne/ownCloud/git/EHA_ft/RTL/gen/tb_network_2x2.vhd"


# Start the simulation
vsim work.tb_network_2x2
run 11000 ns
quit
