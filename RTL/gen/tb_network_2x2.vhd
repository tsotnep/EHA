--Copyright (C) 2016 Siavoosh Payandeh Azad
------------------------------------------------------------
-- This file is automatically generated!
-- Here are the parameters:
-- 	 network size x:2
-- 	 network size y:2
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.TB_Package.all;

USE ieee.numeric_std.ALL;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity tb_network_2x2 is
end tb_network_2x2;


architecture behavior of tb_network_2x2 is

-- Declaring network component
component network_2x2 is
 generic (DATA_WIDTH: integer := 32);
port (reset: in  std_logic;
	clk: in  std_logic;
	--------------
	RX_L_0: in std_logic_vector (DATA_WIDTH-1 downto 0);
	RTS_L_0, CTS_L_0: out std_logic;
	DRTS_L_0, DCTS_L_0: in std_logic;
	TX_L_0: out std_logic_vector (DATA_WIDTH-1 downto 0);
	--------------
	RX_L_1: in std_logic_vector (DATA_WIDTH-1 downto 0);
	RTS_L_1, CTS_L_1: out std_logic;
	DRTS_L_1, DCTS_L_1: in std_logic;
	TX_L_1: out std_logic_vector (DATA_WIDTH-1 downto 0);
	--------------
	RX_L_2: in std_logic_vector (DATA_WIDTH-1 downto 0);
	RTS_L_2, CTS_L_2: out std_logic;
	DRTS_L_2, DCTS_L_2: in std_logic;
	TX_L_2: out std_logic_vector (DATA_WIDTH-1 downto 0);
	--------------
	RX_L_3: in std_logic_vector (DATA_WIDTH-1 downto 0);
	RTS_L_3, CTS_L_3: out std_logic;
	DRTS_L_3, DCTS_L_3: in std_logic;
	TX_L_3: out std_logic_vector (DATA_WIDTH-1 downto 0)
            );
end component;

-- generating bulk signals...
	signal RX_L_0, TX_L_0:  std_logic_vector (31 downto 0);
	signal RTS_L_0, DRTS_L_0, CTS_L_0, DCTS_L_0: std_logic;
	--------------
	signal RX_L_1, TX_L_1:  std_logic_vector (31 downto 0);
	signal RTS_L_1, DRTS_L_1, CTS_L_1, DCTS_L_1: std_logic;
	--------------
	signal RX_L_2, TX_L_2:  std_logic_vector (31 downto 0);
	signal RTS_L_2, DRTS_L_2, CTS_L_2, DCTS_L_2: std_logic;
	--------------
	signal RX_L_3, TX_L_3:  std_logic_vector (31 downto 0);
	signal RTS_L_3, DRTS_L_3, CTS_L_3, DCTS_L_3: std_logic;
	--------------

	--fault injector signals
	signal FI_Add_2_0, FI_Add_0_2: std_logic_vector(integer(ceil(log2(real(31))))-1 downto 0) := (others=>'0');
	signal sta0_0_2, sta1_0_2, sta0_2_0, sta1_2_0: std_logic :='0';

	signal FI_Add_3_1, FI_Add_1_3: std_logic_vector(integer(ceil(log2(real(31))))-1 downto 0) := (others=>'0');
	signal sta0_1_3, sta1_1_3, sta0_3_1, sta1_3_1: std_logic :='0';

	signal FI_Add_1_0, FI_Add_0_1: std_logic_vector(integer(ceil(log2(real(31))))-1 downto 0):= (others=>'0');
	signal sta0_0_1, sta1_0_1, sta0_1_0, sta1_1_0: std_logic :='0';

	signal FI_Add_3_2, FI_Add_2_3: std_logic_vector(integer(ceil(log2(real(31))))-1 downto 0):= (others=>'0');
	signal sta0_2_3, sta1_2_3, sta0_3_2, sta1_3_2: std_logic :='0';

 constant clk_period : time := 1 ns;
signal reset,clk: std_logic :='0';

begin

   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;

reset <= '1' after 1 ns;
-- instantiating the network
NoC: network_2x2 generic map (DATA_WIDTH  => 32)
PORT MAP (reset, clk,
	RX_L_0, RTS_L_0, CTS_L_0, DRTS_L_0, DCTS_L_0, TX_L_0,
	RX_L_1, RTS_L_1, CTS_L_1, DRTS_L_1, DCTS_L_1, TX_L_1,
	RX_L_2, RTS_L_2, CTS_L_2, DRTS_L_2, DCTS_L_2, TX_L_2,
	RX_L_3, RTS_L_3, CTS_L_3, DRTS_L_3, DCTS_L_3, TX_L_3);

-- connecting the packet generators
gen_packet(4, 0, 2, 1, 49, 53 ns, clk, CTS_L_0, DRTS_L_0, RX_L_0);
gen_packet(5, 1, 3, 1, 7, 117 ns, clk, CTS_L_1, DRTS_L_1, RX_L_1);
gen_packet(5, 2, 1, 1, 29, 193 ns, clk, CTS_L_2, DRTS_L_2, RX_L_2);
gen_packet(6, 3, 2, 1, 25, 82 ns, clk, CTS_L_3, DRTS_L_3, RX_L_3);

-- connecting the packet receivers
-- Arguments are:
--      data_width, inital delay, node_id, clk, DCTS, RTS, TX
get_packet(32, 5, 0, clk, DCTS_L_0, RTS_L_0, TX_L_0);
get_packet(32, 5, 1, clk, DCTS_L_1, RTS_L_1, TX_L_1);
get_packet(32, 5, 2, clk, DCTS_L_2, RTS_L_2, TX_L_2);
get_packet(32, 5, 3, clk, DCTS_L_3, RTS_L_3, TX_L_3);

end;
