Authors:

* Siavoosh Payandeh Azad
* Karl Janson
* Behrad Niazmand
* Tsotne Putkaradze

License:  	GNU GENERAL PUBLIC LICENSE Version 3

-------------------------------------------------------------------------------------------------
	Copyright (C) 2016 as collective work done by Siavoosh Payandeh Azad, Karl Janson, Behrad Niazmand and Tsotne Putkaradze
-------------------------------------------------------------------------------------------------

This project implements a simple NoC router which does not use any Virtual Channels (VCs). The router is intended for a 2D Network on-chip and has 5 input and 5 output ports (North-N, East-E, West-W, South-S and Local-L). It is composed of the following components: 

- Input buffer implemented as First-In-First-Out (FIFO) per each input port
- Routing computation unit implemented using Logic-Based Distributed Routing (LBDR) (no need for using routing table) per each input port
- Arbitration unit (Arbiter) implemented using a Finite State Machine (FSM) based on Round-Robin (RR) prioritization, per each output port
- Crossbar Switch (Xbar) implemented as Multiplexers (MUX) per each output port

-------------------------------------------------------------------------------------------------

The folder structure of the project is as follows: 

"RTL" folder : includes the VHDL RTL files for the FIFO, LBDR, Arbiter, Xbar and the Router (as top module).

"scripts" folder : includes scripts in Python:

* network_gen_parameterized.py
	* -D [size]: sets the size of the network
	* -NI: adds Network Interface to the network ports
	* -P: uses router_parity instead of base-router
	* -FI: adds fault injectos
* Customized_network folder contains:
	* customized_router_gen: generates customized routers (base-router) for specific places in the network
	* network_gen_customized: generates a network out of customized routers
		* -D [size]: sets the size of the network 	
 
"TB" folder : includes individual Test-benches for different modules of the router (FIFO, Arbiter and the Router as top module) This folder also includes the "TB_Package.vhd" file which defines the functions and procedures defined in VHDL for generation and reception of packets during simulation (used for implementing traffic patterns)

-------------------------------------------------------------------------------------------------

This part is not valid at this time. It used to work when the T_handshake was 2 clk cycles. now we changed the handshake time to 3 but we have not verified that.


Latency model of the router: (Similar to Dally's theory)

T_total = #hops x T_r + [ L/b x T_handshake ]


where: 
 * T_r: router's delay to transmit one header flit. is always 3
 * #hops: # of links
 * L: packet length
 * b: bandwidth
 * T_handshake: always 3 clk cycles
