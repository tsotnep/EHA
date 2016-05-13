--Copyright (C) 2016 Siavoosh Payandeh Azad

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity router is
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
end router;

architecture behavior of router is

  COMPONENT FIFO
 	generic (
        DATA_WIDTH: integer := 32
    );
    port (  reset: in  std_logic;
            clk: in  std_logic;
            RX: in std_logic_vector (DATA_WIDTH-1 downto 0);
            DRTS: in std_logic;
            read_en_N : in std_logic;
            read_en_E : in std_logic;
            read_en_W : in std_logic;
            read_en_S : in std_logic;
            read_en_L : in std_logic;
            CTS: out std_logic;
            empty_out: out std_logic;
            Data_out: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
	end COMPONENT;

    COMPONENT Arbiter

    port (  reset: in  std_logic;
            clk: in  std_logic;
            Req_N, Req_E, Req_W, Req_S, Req_L:in std_logic;
            DCTS: in std_logic;
            Grant_N, Grant_E, Grant_W, Grant_S, Grant_L:out std_logic;
            Xbar_sel : out std_logic_vector(4 downto 0);
            RTS: out std_logic
            );
	end COMPONENT;

	COMPONENT LBDR is
    generic (
        cur_addr_rst: integer := 0;
        Rxy_rst: integer := 60;
        Cx_rst: integer := 8;
        NoC_size: integer := 4
    );
    port (  reset: in  std_logic;
            clk: in  std_logic;
            empty: in  std_logic;
            flit_type: in std_logic_vector(2 downto 0);
            dst_addr: in std_logic_vector(3 downto 0);
            Req_N, Req_E, Req_W, Req_S, Req_L:out std_logic
            );
	end COMPONENT;

 	COMPONENT XBAR is
    generic (
        DATA_WIDTH: integer := 32
    );
    port (
        North_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        East_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        West_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        South_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        Local_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        sel: in std_logic_vector (4 downto 0);
        Data_out: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
	end COMPONENT;

    component MUX_5x1_XBAR_input
        generic(DATA_WIDTH : integer := 32);
        port(MUX_XBAR_input_sel_in : in  std_logic_vector(2 downto 0);
             Xbar_sel_out          : out std_logic_vector(4 downto 0);
             Xbar_sel_N            : in  std_logic_vector(4 downto 0);
             Xbar_sel_E            : in  std_logic_vector(4 downto 0);
             Xbar_sel_W            : in  std_logic_vector(4 downto 0);
             Xbar_sel_S            : in  std_logic_vector(4 downto 0);
             Xbar_sel_L            : in  std_logic_vector(4 downto 0));
    end component MUX_5x1_XBAR_input;

    component MUX_6x1_XBAR_output
        generic(DATA_WIDTH : integer := 32);
        port(MUX_XBAR_output_sel_in : in  std_logic_vector(2 downto 0);
             TX_out                 : out std_logic_vector(DATA_WIDTH-1 downto 0);
             TX_N                   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             TX_E                   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             TX_W                   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             TX_S                   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             TX_L                   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             TX_R                   : in  std_logic_vector(DATA_WIDTH-1 downto 0));
    end component MUX_6x1_XBAR_output;

  	signal FIFO_D_out_N, FIFO_D_out_E, FIFO_D_out_W, FIFO_D_out_S, FIFO_D_out_L: std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Grant_XY : Grant signal generated from Arbiter for output X connected to FIFO of input Y

 	signal Grant_NN, Grant_NE, Grant_NW, Grant_NS, Grant_NL: std_logic;
 	signal Grant_EN, Grant_EE, Grant_EW, Grant_ES, Grant_EL: std_logic;
 	signal Grant_WN, Grant_WE, Grant_WW, Grant_WS, Grant_WL: std_logic;
 	signal Grant_SN, Grant_SE, Grant_SW, Grant_SS, Grant_SL: std_logic;
 	signal Grant_LN, Grant_LE, Grant_LW, Grant_LS, Grant_LL: std_logic;

 	signal Req_NN, Req_EN, Req_WN, Req_SN, Req_LN: std_logic;
 	signal Req_NE, Req_EE, Req_WE, Req_SE, Req_LE: std_logic;
 	signal Req_NW, Req_EW, Req_WW, Req_SW, Req_LW: std_logic;
 	signal Req_NS, Req_ES, Req_WS, Req_SS, Req_LS: std_logic;
 	signal Req_NL, Req_EL, Req_WL, Req_SL, Req_LL: std_logic;

    signal empty_N, empty_E, empty_W, empty_S, empty_L: std_logic;

 	signal Xbar_sel_N_temp, Xbar_sel_E_temp, Xbar_sel_W_temp, Xbar_sel_S_temp, Xbar_sel_L_temp, Xbar_sel_R_temp: std_logic_vector(4 downto 0);
    signal Xbar_sel_N, Xbar_sel_E, Xbar_sel_W, Xbar_sel_S, Xbar_sel_L, Xbar_sel_R: std_logic_vector(4 downto 0);

 	signal TX_N_temp, TX_E_temp, TX_W_temp, TX_S_temp, TX_L_temp, TX_R_temp : std_logic_vector(DATA_WIDTH-1 downto 0);
begin

------------------------------------------------------------------------------------------------------------------------------
--                                      block diagram of one channel
--
--                                     .____________grant_________
--                                     |                          ▲
--                                     |     _______            __|_______
--                                     |    |       |          |          |
--                                     |    | LBDR  |---req--->|  Arbiter | <--handshake-->
--                                     |    |_______|          |__________|     signals
--                                     |       ▲                  |
--                                   __▼___    | flit          ___▼__
--                         RX ----->|      |   | type         |      |
--                     <-handshake->| FIFO |---o------------->|      |-----> TX
--                        signals   |______|           ------>|      |
--                                                     ------>| XBAR |
--                                                     ------>|      |
--                                                     ------>|      |
--                                                            |______|
--
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

-- all the FIFOs
 FIFO_N: FIFO generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (reset => reset, clk => clk, RX => RX_N, DRTS => DRTS_N,
   			read_en_N => '0', read_en_E =>Grant_EN, read_en_W =>Grant_WN, read_en_S =>Grant_SN, read_en_L =>Grant_LN,
   			CTS => CTS_N, empty_out => empty_N, Data_out => FIFO_D_out_N);

 FIFO_E: FIFO generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (reset => reset, clk => clk, RX => RX_E, DRTS => DRTS_E,
   			read_en_N => Grant_NE, read_en_E =>'0', read_en_W =>Grant_WE, read_en_S =>Grant_SE, read_en_L =>Grant_LE,
   			CTS => CTS_E, empty_out => empty_E, Data_out => FIFO_D_out_E);

 FIFO_W: FIFO generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (reset => reset, clk => clk, RX => RX_W, DRTS => DRTS_W,
   			read_en_N => Grant_NW, read_en_E =>Grant_EW, read_en_W =>'0', read_en_S =>Grant_SW, read_en_L =>Grant_LW,
   			CTS => CTS_W, empty_out => empty_W, Data_out => FIFO_D_out_W);

 FIFO_S: FIFO generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (reset => reset, clk => clk, RX => RX_S, DRTS => DRTS_S,
   			read_en_N => Grant_NS, read_en_E =>Grant_ES, read_en_W =>Grant_WS, read_en_S =>'0', read_en_L =>Grant_LS,
   			CTS => CTS_S, empty_out => empty_S, Data_out => FIFO_D_out_S);

 FIFO_L: FIFO generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (reset => reset, clk => clk, RX => RX_L, DRTS => DRTS_L,
   			read_en_N => Grant_NL, read_en_E =>Grant_EL, read_en_W =>Grant_WL, read_en_S => Grant_SL, read_en_L =>'0',
   			CTS => CTS_L, empty_out => empty_L, Data_out => FIFO_D_out_L);
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

-- all the LBDRs
LBDR_N: LBDR generic map (cur_addr_rst => current_address, Rxy_rst => Rxy_rst, Cx_rst => Cx_rst, NoC_size => NoC_size)
	   PORT MAP (reset => reset, clk => clk, empty => empty_N, flit_type => FIFO_D_out_N(DATA_WIDTH-1 downto DATA_WIDTH-3), dst_addr=> FIFO_D_out_N(DATA_WIDTH-19+NoC_size-1 downto DATA_WIDTH-19) ,
   		 	 Req_N=> Req_NN, Req_E=>Req_NE, Req_W=>Req_NW, Req_S=>Req_NS, Req_L=>Req_NL);

LBDR_E: LBDR generic map (cur_addr_rst => current_address, Rxy_rst => Rxy_rst, Cx_rst => Cx_rst, NoC_size => NoC_size)
   PORT MAP (reset =>  reset, clk => clk, empty => empty_E, flit_type => FIFO_D_out_E(DATA_WIDTH-1 downto DATA_WIDTH-3), dst_addr=> FIFO_D_out_E(DATA_WIDTH-19+NoC_size-1 downto DATA_WIDTH-19) ,
   		 	 Req_N=> Req_EN, Req_E=>Req_EE, Req_W=>Req_EW, Req_S=>Req_ES, Req_L=>Req_EL);

LBDR_W: LBDR generic map (cur_addr_rst => current_address, Rxy_rst => Rxy_rst, Cx_rst => Cx_rst, NoC_size => NoC_size)
   PORT MAP (reset =>  reset, clk => clk, empty => empty_W,  flit_type => FIFO_D_out_W(DATA_WIDTH-1 downto DATA_WIDTH-3), dst_addr=> FIFO_D_out_W(DATA_WIDTH-19+NoC_size-1 downto DATA_WIDTH-19) ,
   		 	 Req_N=> Req_WN, Req_E=>Req_WE, Req_W=>Req_WW, Req_S=>Req_WS, Req_L=>Req_WL);

LBDR_S: LBDR generic map (cur_addr_rst => current_address, Rxy_rst => Rxy_rst, Cx_rst => Cx_rst, NoC_size => NoC_size)
   PORT MAP (reset =>  reset, clk => clk, empty => empty_S, flit_type => FIFO_D_out_S(DATA_WIDTH-1 downto DATA_WIDTH-3), dst_addr=> FIFO_D_out_S(DATA_WIDTH-19+NoC_size-1 downto DATA_WIDTH-19) ,
   		 	 Req_N=> Req_SN, Req_E=>Req_SE, Req_W=>Req_SW, Req_S=>Req_SS, Req_L=>Req_SL);

LBDR_L: LBDR generic map (cur_addr_rst => current_address, Rxy_rst => Rxy_rst, Cx_rst => Cx_rst, NoC_size => NoC_size)
   PORT MAP (reset =>  reset, clk => clk, empty => empty_L, flit_type => FIFO_D_out_L(DATA_WIDTH-1 downto DATA_WIDTH-3), dst_addr=> FIFO_D_out_L(DATA_WIDTH-19+NoC_size-1 downto DATA_WIDTH-19) ,
   		 	 Req_N=> Req_LN, Req_E=>Req_LE, Req_W=>Req_LW, Req_S=>Req_LS, Req_L=>Req_LL);

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

-- all the Arbiters
Arbiter_N: Arbiter
   PORT MAP (reset => reset, clk => clk,
          Req_N => '0' , Req_E => Req_EN, Req_W => Req_WN, Req_S => Req_SN, Req_L => Req_LN,
          DCTS => DCTS_N, Grant_N => Grant_NN, Grant_E => Grant_NE, Grant_W => Grant_NW, Grant_S => Grant_NS, Grant_L => Grant_NL,
          Xbar_sel => Xbar_sel_N_temp,
          RTS =>  RTS_N
        );

 Arbiter_E: Arbiter
   PORT MAP (reset => reset, clk => clk,
          Req_N => Req_NE , Req_E => '0', Req_W => Req_WE, Req_S => Req_SE, Req_L => Req_LE,
          DCTS => DCTS_E, Grant_N => Grant_EN, Grant_E => Grant_EE, Grant_W => Grant_EW, Grant_S => Grant_ES, Grant_L => Grant_EL,
          Xbar_sel => Xbar_sel_E_temp,
          RTS =>  RTS_E
        );

  Arbiter_W: Arbiter
   PORT MAP (reset => reset, clk => clk,
          Req_N => Req_NW , Req_E => Req_EW, Req_W => '0', Req_S => Req_SW, Req_L => Req_LW,
          DCTS => DCTS_W, Grant_N => Grant_WN, Grant_E => Grant_WE, Grant_W => Grant_WW, Grant_S => Grant_WS, Grant_L => Grant_WL,
          Xbar_sel => Xbar_sel_W_temp,
          RTS =>  RTS_W
        );

  Arbiter_S: Arbiter
   PORT MAP (reset => reset, clk => clk,
          Req_N => Req_NS , Req_E => Req_ES, Req_W => Req_WS, Req_S => '0', Req_L => Req_LS,
          DCTS => DCTS_S, Grant_N => Grant_SN, Grant_E => Grant_SE, Grant_W => Grant_SW, Grant_S => Grant_SS, Grant_L => Grant_SL,
          Xbar_sel => Xbar_sel_S_temp,
          RTS =>  RTS_S
        );

  Arbiter_L: Arbiter
   PORT MAP (reset => reset, clk => clk,
          Req_N => Req_NL , Req_E => Req_EL, Req_W => Req_WL, Req_S => Req_SL, Req_L => '0',
          DCTS => DCTS_L, Grant_N => Grant_LN, Grant_E => Grant_LE, Grant_W => Grant_LW, Grant_S => Grant_LS, Grant_L => Grant_LL,
          Xbar_sel => Xbar_sel_L_temp,
          RTS =>  RTS_L
        );

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

-- all the Xbars
XBAR_N: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => FIFO_D_out_E, West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_N,  Data_out=> TX_N_temp);
XBAR_E: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => FIFO_D_out_E, West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_E,  Data_out=> TX_E_temp);
XBAR_W: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => FIFO_D_out_E, West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_W,  Data_out=> TX_W_temp);
XBAR_S: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => FIFO_D_out_E, West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_S,  Data_out=> TX_S_temp);
XBAR_L: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => FIFO_D_out_E, West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_L,  Data_out=> TX_L_temp);
XBAR_R: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => FIFO_D_out_E, West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_R,  Data_out=> TX_R_temp);


-- all muxes for redundancy
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--
-- MUX_5x1_XBAR_input_select - decides which input we want to forward to a particular xbar
-- MUX_6x1_XBAR_output_select - decides which output will be redirected to the output port
--
--                                 (( FIFO_D_out_ ))
--                                     N E W S L
--                  MUX_5x1            | | | | |                   MUX_6x1
--                   |\              __|_|_|_|_|__      |---> TX_N--|\
--            sel_N--| \             |            |     ||--> TX_E--| \
--            sel_E--|  | XBAR_SEL_N |   XBAR     |TX_N ||    TX_W--|  |
--            sel_W--|  |----------> |    N       |-----||    TX_S--|  |--TX_N
--            sel_S--|  |            |            |      |    TX_L--|  |
--            sel_L--| /             |____________|      ||-> TX_R--| /
--                   |/|                                 ||         |/|
--                     |                                 ||           |
--                     |                                 ||           |
--         MUX_5x1_XBAR_input_select                     ||  MUX_6x1_XBAR_output_select
--                                                       ||
--                                                       ||
--                                  (( FIFO_D_out_ ))    ||
--                                      N E W S L        ||
--                   MUX_5x1            | | | | |        ||         MUX_6x1
--                    |\              __|_|_|_|_|__      ||    TX_N--|\
--             sel_N--| \             |            |     |+--> TX_E--| \
--             sel_E--|  | XBAR_SEL_E |   XBAR     |TX_E ||    TX_W--|  |
--             sel_W--|  |----------> |    E       |-----||    TX_S--|  |--TX_E
--             sel_S--|  |            |            |      |    TX_L--|  |
--             sel_L--| /             |____________|      |--> TX_R--| /
--                    |/|                                 |          |/|
--                      |                                 |            |
--                      |                                 |            |
--          MUX_5x1_XBAR_input_select                     |   MUX_6x1_XBAR_output_select
--                                                        |
--                                   (( FIFO_D_out_ ))    |
--                                       N E W S L        |
--                    MUX_5x1            | | | | |        |
--                     |\              __|_|_|_|_|__      |
--              sel_N--| \             |            |     |
--              sel_E--|  | XBAR_SEL_R |   XBAR     |TX_R |
--              sel_W--|  |----------> |    R       |-----|
--              sel_S--|  |            |            |
--              sel_L--| /             |____________|
--                     |/|
--                       |
--                       |
--           MUX_5x1_XBAR_input_select


MUX_XBAR_input_N : component MUX_5x1_XBAR_input
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        MUX_XBAR_input_sel_in => "000",
        Xbar_sel_out          => Xbar_sel_N,
        Xbar_sel_N            => Xbar_sel_N_temp,
        Xbar_sel_E            => Xbar_sel_E_temp,
        Xbar_sel_W            => Xbar_sel_W_temp,
        Xbar_sel_S            => Xbar_sel_S_temp,
        Xbar_sel_L            => Xbar_sel_L_temp
    );

MUX_XBAR_input_E : component MUX_5x1_XBAR_input
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        MUX_XBAR_input_sel_in => "001",
        Xbar_sel_out          => Xbar_sel_E,
        Xbar_sel_N            => Xbar_sel_N_temp,
        Xbar_sel_E            => Xbar_sel_E_temp,
        Xbar_sel_W            => Xbar_sel_W_temp,
        Xbar_sel_S            => Xbar_sel_S_temp,
        Xbar_sel_L            => Xbar_sel_L_temp
    );

MUX_XBAR_input_W : component MUX_5x1_XBAR_input
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        MUX_XBAR_input_sel_in => "010",
        Xbar_sel_out          => Xbar_sel_W,
        Xbar_sel_N            => Xbar_sel_N_temp,
        Xbar_sel_E            => Xbar_sel_E_temp,
        Xbar_sel_W            => Xbar_sel_W_temp,
        Xbar_sel_S            => Xbar_sel_S_temp,
        Xbar_sel_L            => Xbar_sel_L_temp
    );

MUX_XBAR_input_S : component MUX_5x1_XBAR_input
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        MUX_XBAR_input_sel_in => "011",
        Xbar_sel_out          => Xbar_sel_S,
        Xbar_sel_N            => Xbar_sel_N_temp,
        Xbar_sel_E            => Xbar_sel_E_temp,
        Xbar_sel_W            => Xbar_sel_W_temp,
        Xbar_sel_S            => Xbar_sel_S_temp,
        Xbar_sel_L            => Xbar_sel_L_temp
    );

MUX_XBAR_input_L : component MUX_5x1_XBAR_input
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        MUX_XBAR_input_sel_in => "100",
        Xbar_sel_out          => Xbar_sel_L,
        Xbar_sel_N            => Xbar_sel_N_temp,
        Xbar_sel_E            => Xbar_sel_E_temp,
        Xbar_sel_W            => Xbar_sel_W_temp,
        Xbar_sel_S            => Xbar_sel_S_temp,
        Xbar_sel_L            => Xbar_sel_L_temp
    );

MUX_XBAR_input_R : component MUX_5x1_XBAR_input
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        MUX_XBAR_input_sel_in => "111",
        Xbar_sel_out          => Xbar_sel_R,
        Xbar_sel_N            => Xbar_sel_N_temp,
        Xbar_sel_E            => Xbar_sel_E_temp,
        Xbar_sel_W            => Xbar_sel_W_temp,
        Xbar_sel_S            => Xbar_sel_S_temp,
        Xbar_sel_L            => Xbar_sel_L_temp
    );



MUX_XBAR_output_N : component MUX_6x1_XBAR_output
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            MUX_XBAR_output_sel_in => "000",
            TX_out                 => TX_N,
            TX_N                   => TX_N_temp,
            TX_E                   => TX_E_temp,
            TX_W                   => TX_W_temp,
            TX_S                   => TX_S_temp,
            TX_L                   => TX_L_temp,
            TX_R                   => TX_R_temp
        );

MUX_XBAR_output_E : component MUX_6x1_XBAR_output
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            MUX_XBAR_output_sel_in => "001",
            TX_out                 => TX_E,
            TX_N                   => TX_N_temp,
            TX_E                   => TX_E_temp,
            TX_W                   => TX_W_temp,
            TX_S                   => TX_S_temp,
            TX_L                   => TX_L_temp,
            TX_R                   => TX_R_temp
        );

MUX_XBAR_output_W : component MUX_6x1_XBAR_output
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            MUX_XBAR_output_sel_in => "010",
            TX_out                 => TX_W,
            TX_N                   => TX_N_temp,
            TX_E                   => TX_E_temp,
            TX_W                   => TX_W_temp,
            TX_S                   => TX_S_temp,
            TX_L                   => TX_L_temp,
            TX_R                   => TX_R_temp
        );

MUX_XBAR_output_S : component MUX_6x1_XBAR_output
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            MUX_XBAR_output_sel_in => "011",
            TX_out                 => TX_S,
            TX_N                   => TX_N_temp,
            TX_E                   => TX_E_temp,
            TX_W                   => TX_W_temp,
            TX_S                   => TX_S_temp,
            TX_L                   => TX_L_temp,
            TX_R                   => TX_R_temp
        );

MUX_XBAR_output_L : component MUX_6x1_XBAR_output
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            MUX_XBAR_output_sel_in => "100",
            TX_out                 => TX_L,
            TX_N                   => TX_N_temp,
            TX_E                   => TX_E_temp,
            TX_W                   => TX_W_temp,
            TX_S                   => TX_S_temp,
            TX_L                   => TX_L_temp,
            TX_R                   => TX_R_temp
    );

    -- Fault_Control_XBAR_inst : component Fault_Control_XBAR
    --     port map(
    --         Fault_Info_IN                    => Fault_Info_XBAR,
    --         MUX_5x1_XBAR_input_select_0_out  => MUX_5x1_XBAR_input_select_0,
    --         MUX_5x1_XBAR_input_select_1_out  => MUX_5x1_XBAR_input_select_1,
    --         MUX_5x1_XBAR_input_select_2_out  => MUX_5x1_XBAR_input_select_2,
    --         MUX_5x1_XBAR_input_select_3_out  => MUX_5x1_XBAR_input_select_3,
    --         MUX_5x1_XBAR_input_select_4_out  => MUX_5x1_XBAR_input_select_4,
    --         MUX_5x1_XBAR_input_select_5_out  => MUX_5x1_XBAR_input_select_5,
    --         MUX_5x1_XBAR_input_select_6_out  => MUX_5x1_XBAR_input_select_6,
    --         MUX_6x1_XBAR_output_select_N_out => MUX_6x1_XBAR_output_select_N,
    --         MUX_6x1_XBAR_output_select_E_out => MUX_6x1_XBAR_output_select_E,
    --         MUX_6x1_XBAR_output_select_W_out => MUX_6x1_XBAR_output_select_W,
    --         MUX_6x1_XBAR_output_select_S_out => MUX_6x1_XBAR_output_select_S,
    --         MUX_6x1_XBAR_output_select_L_out => MUX_6x1_XBAR_output_select_L
    --     );

end;
