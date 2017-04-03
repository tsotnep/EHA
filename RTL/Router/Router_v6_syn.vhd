--Copyright (C) 2016 Siavoosh Payandeh Azad

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity stmr_router is
	generic (
        DATA_WIDTH: integer := 32;
        current_address : integer := 0;
        Rxy_rst : integer := 60;
        Cx_rst : integer := 10;
        NoC_size: integer := 4
    );
    port (
    reset, clk: in std_logic;
    DCTS_N, DCTS_E, DCTS_w, DCTS_S, DCTS_L: in std_logic;
    DRTS_N, DRTS_E, DRTS_W, DRTS_S, DRTS_L: in std_logic;
    RX_N, RX_E, RX_W, RX_S, RX_L : in std_logic_vector (DATA_WIDTH-1 downto 0);
    RTS_N, RTS_E, RTS_W, RTS_S, RTS_L: out std_logic;
    CTS_N, CTS_E, CTS_w, CTS_S, CTS_L: out std_logic;
    TX_N, TX_E, TX_W, TX_S, TX_L: out std_logic_vector (DATA_WIDTH-1 downto 0)
    );
end stmr_router;

architecture behavior of stmr_router is
component router is
 generic (
        DATA_WIDTH: integer := 32;
        current_address : integer := 5;
        Rxy_rst : integer := 60;
        Cx_rst : integer := 15;
        NoC_size : integer := 4
    );
    port (
    reset, clk: in std_logic;
    DCTS_N, DCTS_E, DCTS_w, DCTS_S, DCTS_L: in std_logic;
    DRTS_N, DRTS_E, DRTS_W, DRTS_S, DRTS_L: in std_logic;
    RX_N, RX_E, RX_W, RX_S, RX_L : in std_logic_vector (DATA_WIDTH-1 downto 0);
    RTS_N, RTS_E, RTS_W, RTS_S, RTS_L: out std_logic;
    CTS_N, CTS_E, CTS_w, CTS_S, CTS_L: out std_logic;
    TX_N, TX_E, TX_W, TX_S, TX_L: out std_logic_vector (DATA_WIDTH-1 downto 0));
end component;


-- generating bulk signals. not all of them are used in the design...
	signal DCTS_N_a, DCTS_E_a, DCTS_w_a, DCTS_S_a: std_logic;
	signal DCTS_N_b, DCTS_E_b, DCTS_w_b, DCTS_S_b: std_logic;
	signal DCTS_N_c, DCTS_E_c, DCTS_w_c, DCTS_S_c: std_logic;

	signal DRTS_N_a, DRTS_E_a, DRTS_W_a, DRTS_S_a: std_logic;
	signal DRTS_N_b, DRTS_E_b, DRTS_W_b, DRTS_S_b: std_logic;
	signal DRTS_N_c, DRTS_E_c, DRTS_W_c, DRTS_S_c: std_logic;

	signal RX_N_a, RX_E_a, RX_W_a, RX_S_a : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal RX_N_b, RX_E_b, RX_W_b, RX_S_b : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal RX_N_c, RX_E_c, RX_W_c, RX_S_c : std_logic_vector (DATA_WIDTH-1 downto 0);

	signal CTS_N_a, CTS_E_a, CTS_w_a, CTS_S_a: std_logic;
	signal CTS_N_b, CTS_E_b, CTS_w_b, CTS_S_b: std_logic;
	signal CTS_N_c, CTS_E_c, CTS_w_c, CTS_S_c: std_logic;

	signal RTS_N_a, RTS_E_a, RTS_W_a, RTS_S_a: std_logic;
	signal RTS_N_b, RTS_E_b, RTS_W_b, RTS_S_b: std_logic;
	signal RTS_N_c, RTS_E_c, RTS_W_c, RTS_S_c: std_logic;

	signal TX_N_a, TX_E_a, TX_W_a, TX_S_a : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal TX_N_b, TX_E_b, TX_W_b, TX_S_b : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal TX_N_c, TX_E_c, TX_W_c, TX_S_c : std_logic_vector (DATA_WIDTH-1 downto 0);


  signal  output, input0, input1, input2 : std_logic_vector(5*32+5+5-1 downto 0);

begin

-- instantiating the routers

R_a: router generic map (DATA_WIDTH  => DATA_WIDTH, current_address=>0, Rxy_rst => 60, Cx_rst => 10, NoC_size=>2)
PORT MAP (reset, clk,
    DCTS_N, DCTS_E, DCTS_w, DCTS_S, DCTS_L,
    DRTS_N, DRTS_E, DRTS_W, DRTS_S, DRTS_L,
    RX_N, RX_E, RX_W, RX_S, RX_L,

  RTS_N_a,
  RTS_E_a,
  RTS_W_a,
  RTS_S_a,
  RTS_L,

  CTS_N_a,
  CTS_E_a,
  CTS_w_a,
  CTS_S_a,
  CTS_L,

  TX_N_a,
  TX_E_a,
  TX_W_a,
  TX_S_a,
  TX_L
  );

R_b: router generic map (DATA_WIDTH  => DATA_WIDTH, current_address=>0, Rxy_rst => 60, Cx_rst => 10, NoC_size=>2)
PORT MAP (reset, clk,
    DCTS_N, DCTS_E, DCTS_w, DCTS_S, DCTS_L,
    DRTS_N, DRTS_E, DRTS_W, DRTS_S, DRTS_L,
    RX_N, RX_E, RX_W, RX_S, RX_L,

  RTS_N_b,
  RTS_E_b,
  RTS_W_b,
  RTS_S_b,
  RTS_L,

  CTS_N_b,
  CTS_E_b,
  CTS_w_b,
  CTS_S_b,
  CTS_L,

  TX_N_b,
  TX_E_b,
  TX_W_b,
  TX_S_b,
  TX_L
  );

R_c: router generic map (DATA_WIDTH  => DATA_WIDTH, current_address=>0, Rxy_rst => 60, Cx_rst => 10, NoC_size=>2)
PORT MAP (reset, clk,
    DCTS_N, DCTS_E, DCTS_w, DCTS_S, DCTS_L,
    DRTS_N, DRTS_E, DRTS_W, DRTS_S, DRTS_L,
    RX_N, RX_E, RX_W, RX_S, RX_L,

  RTS_N_c,
  RTS_E_c,
  RTS_W_c,
  RTS_S_c,
  RTS_L,

  CTS_N_c,
  CTS_E_c,
  CTS_w_c,
  CTS_S_c,
  CTS_L,

  TX_N_c,
  TX_E_c,
  TX_W_c,
  TX_S_c,
  TX_L
  );


-- router outputs go to inputs of voter
input0 <= DRTS_N_a & DRTS_E_a & DRTS_W_a & DRTS_S_a & DRTS_L &
          DCTS_N_a & DCTS_E_a & DCTS_w_a & DCTS_S_a & DCTS_L &
          RX_N_a  & RX_E_a  & RX_W_a  & RX_S_a  & RX_L;


input1 <= DRTS_N_b & DRTS_E_b & DRTS_W_b & DRTS_S_b & DRTS_L &
          DCTS_N_b & DCTS_E_b & DCTS_w_b & DCTS_S_b & DCTS_L &
          RX_N_b  & RX_E_b  & RX_W_b  & RX_S_b  & RX_L;


input2 <= DRTS_N_c & DRTS_E_c & DRTS_W_c & DRTS_S_c & DRTS_L &
          DCTS_N_c & DCTS_E_c & DCTS_w_c & DCTS_S_c & DCTS_L &
          RX_N_c  & RX_E_c  & RX_W_c  & RX_S_c  & RX_L;


--voter output goes to output of this router
  RTS_N <= output(DATA_WIDTH*5 + 9);
RTS_E <= output(DATA_WIDTH*5 + 8);
RTS_W <= output(DATA_WIDTH*5 + 7);
RTS_S <= output(DATA_WIDTH*5 + 6);
RTS_L <= output(DATA_WIDTH*5 + 5);

CTS_N <= output(DATA_WIDTH*5 + 4);
CTS_E <= output(DATA_WIDTH*5 + 3);
CTS_w <= output(DATA_WIDTH*5 + 2);
CTS_S <= output(DATA_WIDTH*5 + 1);
CTS_L <= output(DATA_WIDTH*5 + 0);

TX_N <= output(DATA_WIDTH*5 -1 downto DATA_WIDTH*4);
TX_E <= output(DATA_WIDTH*4 -1 downto DATA_WIDTH*3);
TX_W <= output(DATA_WIDTH*3 -1 downto DATA_WIDTH*2);
TX_S <= output(DATA_WIDTH*2 -1 downto DATA_WIDTH*1);
TX_L <= output(DATA_WIDTH*1 -1 downto DATA_WIDTH*0);

  voter_inst : entity work.voter
    generic map(
      DATA_WIDTH => output'length
    )
    port map(
      input0       => input0,
      input1       => input1,
      input2       => input2,
      voted_output => output
    );

end;
