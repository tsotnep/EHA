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

    component Fault_Control
        port(Fault_Info_in                      : in  std_logic_vector(5 downto 0);
             MUX_5x1_module_input_select_N_out  : out std_logic_vector(2 downto 0);
             MUX_5x1_module_input_select_E_out  : out std_logic_vector(2 downto 0);
             MUX_5x1_module_input_select_W_out  : out std_logic_vector(2 downto 0);
             MUX_5x1_module_input_select_S_out  : out std_logic_vector(2 downto 0);
             MUX_5x1_module_input_select_L_out  : out std_logic_vector(2 downto 0);
             MUX_5x1_module_input_select_R_out  : out std_logic_vector(2 downto 0);
             MUX_6x1_module_output_select_N_out : out std_logic_vector(2 downto 0);
             MUX_6x1_module_output_select_E_out : out std_logic_vector(2 downto 0);
             MUX_6x1_module_output_select_W_out : out std_logic_vector(2 downto 0);
             MUX_6x1_module_output_select_S_out : out std_logic_vector(2 downto 0);
             MUX_6x1_module_output_select_L_out : out std_logic_vector(2 downto 0));
    end component Fault_Control;

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

    component MUX_6x1_Arbiter_output
        generic(DATA_WIDTH : integer := 32);
        port(MUX_Arbiter_output_sel_in                                              : in  std_logic_vector(2 downto 0);
             Xbar_sel_out                                                           : out std_logic_vector(4 downto 0);
             RTS_out                                                                : out std_logic;
             Grant_N_out, Grant_E_out, Grant_W_out, Grant_S_out, Grant_L_out        : out std_logic;
             Xbar_sel_N, Xbar_sel_E, Xbar_sel_W, Xbar_sel_S, Xbar_sel_L, Xbar_sel_R : in  std_logic_vector(4 downto 0);
             RTS_N, RTS_E, RTS_W, RTS_S, RTS_L, RTS_R                               : in  std_logic;
             Grant_NN, Grant_NE, Grant_NW, Grant_NS, Grant_NL                       : in  std_logic;
             Grant_EN, Grant_EE, Grant_EW, Grant_ES, Grant_EL                       : in  std_logic;
             Grant_WN, Grant_WE, Grant_WW, Grant_WS, Grant_WL                       : in  std_logic;
             Grant_SN, Grant_SE, Grant_SW, Grant_SS, Grant_SL                       : in  std_logic;
             Grant_LN, Grant_LE, Grant_LW, Grant_LS, Grant_LL                       : in  std_logic;
             Grant_RN, Grant_RE, Grant_RW, Grant_RS, Grant_RL                       : in  std_logic);
    end component MUX_6x1_Arbiter_output;



  	signal FIFO_D_out_N, FIFO_D_out_E, FIFO_D_out_W, FIFO_D_out_S, FIFO_D_out_L: std_logic_vector(DATA_WIDTH-1 downto 0);

    signal empty_N, empty_E, empty_W, empty_S, empty_L: std_logic;



    -----------------------------------------A R B I T E R------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------------

    --those signal go into MUX_5x1_MODULE_input, before it was going straightly in MODULE
    signal Req_NN, Req_EN, Req_WN, Req_SN, Req_LN: std_logic;
    signal Req_NE, Req_EE, Req_WE, Req_SE, Req_LE: std_logic;
    signal Req_NW, Req_EW, Req_WW, Req_SW, Req_LW: std_logic;
    signal Req_NS, Req_ES, Req_WS, Req_SS, Req_LS: std_logic;
    signal Req_NL, Req_EL, Req_WL, Req_SL, Req_LL: std_logic;
    --DCTS_N, DCTS_E, DCTS_w, DCTS_S, DCTS_L --toplevel inputs

    --input signals to MODULE, coming out from MUX_5x1_MODULE_input
    signal Req_NN_valid, Req_EN_valid, Req_WN_valid, Req_SN_valid, Req_LN_valid: std_logic;
    signal Req_NE_valid, Req_EE_valid, Req_WE_valid, Req_SE_valid, Req_LE_valid: std_logic;
    signal Req_NW_valid, Req_EW_valid, Req_WW_valid, Req_SW_valid, Req_LW_valid: std_logic;
    signal Req_NS_valid, Req_ES_valid, Req_WS_valid, Req_SS_valid, Req_LS_valid: std_logic;
    signal Req_NL_valid, Req_EL_valid, Req_WL_valid, Req_SL_valid, Req_LL_valid: std_logic;
    signal DCTS_N_valid, DCTS_E_valid, DCTS_W_valid, DCTS_S_valid, DCTS_L_valid: std_logic;

    --output signals from MODULE, going into MUX_6x1_MODULE_output
    -- Grant_XY : Grant signal generated from Arbiter for output X connected to FIFO of input Y
    signal Grant_NN_temp, Grant_NE_temp, Grant_NW_temp, Grant_NS_temp, Grant_NL_temp: std_logic;
    signal Grant_EN_temp, Grant_EE_temp, Grant_EW_temp, Grant_ES_temp, Grant_EL_temp: std_logic;
    signal Grant_WN_temp, Grant_WE_temp, Grant_WW_temp, Grant_WS_temp, Grant_WL_temp: std_logic;
    signal Grant_SN_temp, Grant_SE_temp, Grant_SW_temp, Grant_SS_temp, Grant_SL_temp: std_logic;
    signal Grant_LN_temp, Grant_LE_temp, Grant_LW_temp, Grant_LS_temp, Grant_LL_temp: std_logic;
    signal Xbar_sel_N_temp, Xbar_sel_E_temp, Xbar_sel_W_temp, Xbar_sel_S_temp, Xbar_sel_L_temp, Xbar_sel_R_temp: std_logic_vector(4 downto 0);
    signal RTS_N_temp, RTS_E_temp, RTS_W_temp, RTS_S_temp, RTS_L_temp: std_logic;

    --outputs of MUX_6x1_MODULE_output goint into somewhere.
    signal Grant_NN, Grant_NE, Grant_NW, Grant_NS, Grant_NL: std_logic;
    signal Grant_EN, Grant_EE, Grant_EW, Grant_ES, Grant_EL: std_logic;
    signal Grant_WN, Grant_WE, Grant_WW, Grant_WS, Grant_WL: std_logic;
    signal Grant_SN, Grant_SE, Grant_SW, Grant_SS, Grant_SL: std_logic;
    signal Grant_LN, Grant_LE, Grant_LW, Grant_LS, Grant_LL: std_logic;

    -- Arbiter Fault control
    signal Fault_Info_Arbiter_in               : std_logic_vector(5 downto 0) := "000000";
    signal MUX_5x1_Arbiter_input_select_N_out  : std_logic_vector(2 downto 0); --not used
    signal MUX_5x1_Arbiter_input_select_E_out  : std_logic_vector(2 downto 0); --not used
    signal MUX_5x1_Arbiter_input_select_W_out  : std_logic_vector(2 downto 0); --not used
    signal MUX_5x1_Arbiter_input_select_S_out  : std_logic_vector(2 downto 0); --not used
    signal MUX_5x1_Arbiter_input_select_L_out  : std_logic_vector(2 downto 0); --not used
    signal MUX_5x1_Arbiter_input_select_R_out  : std_logic_vector(2 downto 0);
    signal MUX_6x1_Arbiter_output_select_N_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_Arbiter_output_select_E_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_Arbiter_output_select_W_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_Arbiter_output_select_S_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_Arbiter_output_select_L_out : std_logic_vector(2 downto 0);


    -----------------------------------X B A R------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------------
    --those signal go into MUX_5x1_MODULE_input, before it was going straightly in MODULE
    signal Xbar_sel_N, Xbar_sel_E, Xbar_sel_W, Xbar_sel_S, Xbar_sel_L, Xbar_sel_R: std_logic_vector(4 downto 0);

    --input signals to MODULE, coming out from MUX_5x1_MODULE_input
    signal Xbar_sel_N_valid, Xbar_sel_E_valid, Xbar_sel_W_valid, Xbar_sel_S_valid, Xbar_sel_L_valid, Xbar_sel_R_valid   : std_logic_vector(4 downto 0);

    --output signals from MODULE, going into MUX_6x1_MODULE_output
    signal TX_N_temp, TX_E_temp, TX_W_temp, TX_S_temp, TX_L_temp, TX_R_temp : std_logic_vector(DATA_WIDTH-1 downto 0);

     --outputs of MUX_6x1_MODULE_output goint into somewhere.
    --TX_N, TX_E, TX_W, TX_S, TX_L --toplevel outputs

    -- Xbar Fault control
    signal Fault_Info_Xbar_in               : std_logic_vector(5 downto 0) := "000000";
    signal MUX_5x1_Xbar_input_select_N_out  : std_logic_vector(2 downto 0); --not used
    signal MUX_5x1_Xbar_input_select_E_out  : std_logic_vector(2 downto 0); --not used
    signal MUX_5x1_Xbar_input_select_W_out  : std_logic_vector(2 downto 0); --not used
    signal MUX_5x1_Xbar_input_select_S_out  : std_logic_vector(2 downto 0); --not used
    signal MUX_5x1_Xbar_input_select_L_out  : std_logic_vector(2 downto 0); --not used
    signal MUX_5x1_Xbar_input_select_R_out  : std_logic_vector(2 downto 0);
    signal MUX_6x1_Xbar_output_select_N_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_Xbar_output_select_E_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_Xbar_output_select_W_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_Xbar_output_select_S_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_Xbar_output_select_L_out : std_logic_vector(2 downto 0);


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
          Xbar_sel => Xbar_sel_N,
          RTS =>  RTS_N
        );

Arbiter_E: Arbiter
   PORT MAP (reset => reset, clk => clk,
          Req_N => Req_NE , Req_E => '0', Req_W => Req_WE, Req_S => Req_SE, Req_L => Req_LE,
          DCTS => DCTS_E, Grant_N => Grant_EN, Grant_E => Grant_EE, Grant_W => Grant_EW, Grant_S => Grant_ES, Grant_L => Grant_EL,
          Xbar_sel => Xbar_sel_E,
          RTS =>  RTS_E
        );

Arbiter_W: Arbiter
   PORT MAP (reset => reset, clk => clk,
          Req_N => Req_NW , Req_E => Req_EW, Req_W => '0', Req_S => Req_SW, Req_L => Req_LW,
          DCTS => DCTS_W, Grant_N => Grant_WN, Grant_E => Grant_WE, Grant_W => Grant_WW, Grant_S => Grant_WS, Grant_L => Grant_WL,
          Xbar_sel => Xbar_sel_W,
          RTS =>  RTS_W
        );

Arbiter_S: Arbiter
   PORT MAP (reset => reset, clk => clk,
          Req_N => Req_NS , Req_E => Req_ES, Req_W => Req_WS, Req_S => '0', Req_L => Req_LS,
          DCTS => DCTS_S, Grant_N => Grant_SN, Grant_E => Grant_SE, Grant_W => Grant_SW, Grant_S => Grant_SS, Grant_L => Grant_SL,
          Xbar_sel => Xbar_sel_S,
          RTS =>  RTS_S
        );

Arbiter_L: Arbiter
   PORT MAP (reset => reset, clk => clk,
          Req_N => Req_NL , Req_E => Req_EL, Req_W => Req_WL, Req_S => Req_SL, Req_L => '0',
          DCTS => DCTS_L, Grant_N => Grant_LN, Grant_E => Grant_LE, Grant_W => Grant_LW, Grant_S => Grant_LS, Grant_L => Grant_LL,
          Xbar_sel => Xbar_sel_L,
          RTS =>  RTS_L
        );

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

-- all the Xbars
XBAR_N: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => FIFO_D_out_E, West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_N_valid,  Data_out=> TX_N_temp);
XBAR_E: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => FIFO_D_out_E, West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_E_valid,  Data_out=> TX_E_temp);
XBAR_W: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => FIFO_D_out_E, West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_W_valid,  Data_out=> TX_W_temp);
XBAR_S: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => FIFO_D_out_E, West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_S_valid,  Data_out=> TX_S_temp);
XBAR_L: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => FIFO_D_out_E, West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_L_valid,  Data_out=> TX_L_temp);
XBAR_R: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => FIFO_D_out_E, West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_R_valid,  Data_out=> TX_R_temp);




--all the processes for fault simulation, those will be deleted later
-- xbar_fault: process begin
--     wait for 50 ns;
--     Fault_Info_Xbar_in <= "000010";
--     wait for 50 ns;
--     Fault_Info_Xbar_in <= "000100";
--     wait for 50 ns;
--     Fault_Info_Xbar_in <= "000001";
--     wait;
-- end process xbar_fault;



-- all the control units for redundancy
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Fault_Control_inst_Xbar : component Fault_Control
    port map(
        Fault_Info_in                      => Fault_Info_Xbar_in,
        MUX_5x1_module_input_select_N_out  => MUX_5x1_Xbar_input_select_N_out,
        MUX_5x1_module_input_select_E_out  => MUX_5x1_Xbar_input_select_E_out,
        MUX_5x1_module_input_select_W_out  => MUX_5x1_Xbar_input_select_W_out,
        MUX_5x1_module_input_select_S_out  => MUX_5x1_Xbar_input_select_S_out,
        MUX_5x1_module_input_select_L_out  => MUX_5x1_Xbar_input_select_L_out,
        MUX_5x1_module_input_select_R_out  => MUX_5x1_Xbar_input_select_R_out,
        MUX_6x1_module_output_select_N_out => MUX_6x1_Xbar_output_select_N_out,
        MUX_6x1_module_output_select_E_out => MUX_6x1_Xbar_output_select_E_out,
        MUX_6x1_module_output_select_W_out => MUX_6x1_Xbar_output_select_W_out,
        MUX_6x1_module_output_select_S_out => MUX_6x1_Xbar_output_select_S_out,
        MUX_6x1_module_output_select_L_out => MUX_6x1_Xbar_output_select_L_out
    );



-- all the muxes for redundancy
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
-- MUX_5x1_MODULE_input_select - decides which input we want to forward to a particular MODULE
-- MUX_6x1_MODULE_output_select - decides which output will be redirected to the output of MODULE (currently we redirect only Redundant one, if original is damaged)
--
--
--
--                  MUX_5x1                                                       MUX_6x1
--                   |\              _____________              |---> out_N_temp--|\
--             in_N--| \             |  MODULE    |             ||--> out_E_temp--| \
--             in_E--|  | in_N_valid |            |out_N_temp   ||    out_W_temp--|  |
--             in_W--|  |----------> |    N       |----------   ||    out_S_temp--|  |--out_N
--             in_S--|  |            |            |             ||    out_L_temp--|  |
--             in_L--| /             |____________|             |||-> out_R_temp--| /
--                   |/|                                        |||               |/|
--                     |                                        |||                 |
--                     |                                        |||                 |
--     MUX_5x1_MODULE_input_select                              |||        MUX_6x1_MODULE_output_select
--                                                              |||
--                                                              |||
--                                                              |||
--                                                              |||
--                                                              |||
--                                                              |||
--                    MUX_5x1                                   |||                MUX_6x1
--                     |\               _____________           |++--> out_N_temp--|\
--               in_N--| \             |  MODULE    |            |+--> out_E_temp--| \
--               in_E--|  | in_E_valid |            |out_N_temp  ||    out_W_temp--|  |
--               in_W--|  |----------> |    E       |---------   ||    out_S_temp--|  |--out_E
--               in_S--|  |            |            |             |    out_L_temp--|  |
--               in_L--| /             |____________|             |--> out_R_temp--| /
--                     |/|                                        |                |/|
--                       |                                        |                  |
--                       |                                        |                  |
--         MUX_5x1_MODULE_input_select                            |         MUX_6x1_MODULE_output_select
--                                                                |
--                                                                |
--                                                                |
--                    MUX_5x1                                     |
--                     |\               _____________             |
--               in_N--| \             |  MODULE    |             |
--               in_E--|  | in_R_valid |            |out_R_temp   |
--               in_W--|  |----------> |    R       |----------   |
--               in_S--|  |            |            |
--               in_L--| /             |____________|
--                     |/|
--                       |
--                       |
--           MUX_5x1_MODULE_input_select

--this MUXes control the inputs of XBARs, currently, for example, if XBAR_N is damaged, *_N inputs will be sent to Redundant Xbar. in later versions, control unit, will be able to control all other XBAR inputs.
--in other words, _N, _E, _W, _S, _L instantiations are static, static (static means that, output of this instantiation can be only ONE input). and _R is not static: any of the inputs _N, _E, _W, _S, _L can go into this mux.
MUX_XBAR_input_N : component MUX_5x1_XBAR_input
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        MUX_XBAR_input_sel_in => "000",
        Xbar_sel_out          => Xbar_sel_N_valid,
        Xbar_sel_N            => Xbar_sel_N,
        Xbar_sel_E            => Xbar_sel_E,
        Xbar_sel_W            => Xbar_sel_W,
        Xbar_sel_S            => Xbar_sel_S,
        Xbar_sel_L            => Xbar_sel_L
    );
MUX_XBAR_input_E : component MUX_5x1_XBAR_input
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        MUX_XBAR_input_sel_in => "001",
        Xbar_sel_out          => Xbar_sel_E_valid,
        Xbar_sel_N            => Xbar_sel_N,
        Xbar_sel_E            => Xbar_sel_E,
        Xbar_sel_W            => Xbar_sel_W,
        Xbar_sel_S            => Xbar_sel_S,
        Xbar_sel_L            => Xbar_sel_L
    );
MUX_XBAR_input_W : component MUX_5x1_XBAR_input
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        MUX_XBAR_input_sel_in => "010",
        Xbar_sel_out          => Xbar_sel_W_valid,
        Xbar_sel_N            => Xbar_sel_N,
        Xbar_sel_E            => Xbar_sel_E,
        Xbar_sel_W            => Xbar_sel_W,
        Xbar_sel_S            => Xbar_sel_S,
        Xbar_sel_L            => Xbar_sel_L
    );
MUX_XBAR_input_S : component MUX_5x1_XBAR_input
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        MUX_XBAR_input_sel_in => "011",
        Xbar_sel_out          => Xbar_sel_S_valid,
        Xbar_sel_N            => Xbar_sel_N,
        Xbar_sel_E            => Xbar_sel_E,
        Xbar_sel_W            => Xbar_sel_W,
        Xbar_sel_S            => Xbar_sel_S,
        Xbar_sel_L            => Xbar_sel_L
    );
MUX_XBAR_input_L : component MUX_5x1_XBAR_input
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        MUX_XBAR_input_sel_in => "100",
        Xbar_sel_out          => Xbar_sel_L_valid,
        Xbar_sel_N            => Xbar_sel_N,
        Xbar_sel_E            => Xbar_sel_E,
        Xbar_sel_W            => Xbar_sel_W,
        Xbar_sel_S            => Xbar_sel_S,
        Xbar_sel_L            => Xbar_sel_L
    );
MUX_XBAR_input_R : component MUX_5x1_XBAR_input
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        MUX_XBAR_input_sel_in => MUX_5x1_Xbar_input_select_R_out,
        Xbar_sel_out          => Xbar_sel_R_valid,
        Xbar_sel_N            => Xbar_sel_N,
        Xbar_sel_E            => Xbar_sel_E,
        Xbar_sel_W            => Xbar_sel_W,
        Xbar_sel_S            => Xbar_sel_S,
        Xbar_sel_L            => Xbar_sel_L
    );


--this MUXes choose from which XBAR they will allow the outputs. currently if any'one' XBAR is damaged, control unit will redirect outputs of Redundant module, instead of faulty one.
MUX_XBAR_output_N : component MUX_6x1_XBAR_output
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            MUX_XBAR_output_sel_in => MUX_6x1_Xbar_output_select_N_out,
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
            MUX_XBAR_output_sel_in => MUX_6x1_Xbar_output_select_E_out,
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
            MUX_XBAR_output_sel_in => MUX_6x1_Xbar_output_select_W_out,
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
            MUX_XBAR_output_sel_in => MUX_6x1_Xbar_output_select_S_out,
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
            MUX_XBAR_output_sel_in => MUX_6x1_Xbar_output_select_L_out,
            TX_out                 => TX_L,
            TX_N                   => TX_N_temp,
            TX_E                   => TX_E_temp,
            TX_W                   => TX_W_temp,
            TX_S                   => TX_S_temp,
            TX_L                   => TX_L_temp,
            TX_R                   => TX_R_temp
    );


    MUX_6x1_Arbiter_output_N : component MUX_6x1_Arbiter_output
            generic map(
                DATA_WIDTH => DATA_WIDTH
            )
            port map(
                MUX_Arbiter_output_sel_in => "000",
                Xbar_sel_out              => Xbar_sel_N,
                RTS_out                   => RTS_N,
                Xbar_sel_N                => Xbar_sel_N_temp, Xbar_sel_E => Xbar_sel_E_temp, Xbar_sel_W => Xbar_sel_W_temp, Xbar_sel_S => Xbar_sel_S_temp, Xbar_sel_L => Xbar_sel_L_temp, Xbar_sel_R => Xbar_sel_R_temp,
                RTS_N                     => RTS_N_temp, RTS_E => RTS_E_temp, RTS_W => RTS_W_temp, RTS_S => RTS_S_temp, RTS_L => RTS_L_temp, RTS_R => RTS_R_temp,
                Grant_NN                  => Grant_NN_temp, Grant_NE => Grant_NE_temp, Grant_NW => Grant_NW_temp, Grant_NS => Grant_NS_temp, Grant_NL => Grant_NL_temp,
                Grant_EN                  => Grant_EN_temp, Grant_EE => Grant_EE_temp, Grant_EW => Grant_EW_temp, Grant_ES => Grant_ES_temp, Grant_EL => Grant_EL_temp,
                Grant_WN                  => Grant_WN_temp, Grant_WE => Grant_WE_temp, Grant_WW => Grant_WW_temp, Grant_WS => Grant_WS_temp, Grant_WL => Grant_WL_temp,
                Grant_SN                  => Grant_SN_temp, Grant_SE => Grant_SE_temp, Grant_SW => Grant_SW_temp, Grant_SS => Grant_SS_temp, Grant_SL => Grant_SL_temp,
                Grant_LN                  => Grant_LN_temp, Grant_LE => Grant_LE_temp, Grant_LW => Grant_LW_temp, Grant_LS => Grant_LS_temp, Grant_LL => Grant_LL_temp,
                Grant_RN                  => Grant_RN_temp, Grant_RE => Grant_RE_temp, Grant_RW => Grant_RW_temp, Grant_RS => Grant_RS_temp, Grant_RL => Grant_RL_temp
            );
    MUX_6x1_Arbiter_output_E : component MUX_6x1_Arbiter_output
            generic map(
                DATA_WIDTH => DATA_WIDTH
            )
            port map(
                MUX_Arbiter_output_sel_in => "001",
                Xbar_sel_out              => Xbar_sel_E,
                RTS_out                   => RTS_E,
                Xbar_sel_N                => Xbar_sel_N_temp, Xbar_sel_E => Xbar_sel_E_temp, Xbar_sel_W => Xbar_sel_W_temp, Xbar_sel_S => Xbar_sel_S_temp, Xbar_sel_L => Xbar_sel_L_temp, Xbar_sel_R => Xbar_sel_R_temp,
                RTS_N                     => RTS_N_temp, RTS_E => RTS_E_temp, RTS_W => RTS_W_temp, RTS_S => RTS_S_temp, RTS_L => RTS_L_temp, RTS_R => RTS_R_temp,
                Grant_NN                  => Grant_NN_temp, Grant_NE => Grant_NE_temp, Grant_NW => Grant_NW_temp, Grant_NS => Grant_NS_temp, Grant_NL => Grant_NL_temp,
                Grant_EN                  => Grant_EN_temp, Grant_EE => Grant_EE_temp, Grant_EW => Grant_EW_temp, Grant_ES => Grant_ES_temp, Grant_EL => Grant_EL_temp,
                Grant_WN                  => Grant_WN_temp, Grant_WE => Grant_WE_temp, Grant_WW => Grant_WW_temp, Grant_WS => Grant_WS_temp, Grant_WL => Grant_WL_temp,
                Grant_SN                  => Grant_SN_temp, Grant_SE => Grant_SE_temp, Grant_SW => Grant_SW_temp, Grant_SS => Grant_SS_temp, Grant_SL => Grant_SL_temp,
                Grant_LN                  => Grant_LN_temp, Grant_LE => Grant_LE_temp, Grant_LW => Grant_LW_temp, Grant_LS => Grant_LS_temp, Grant_LL => Grant_LL_temp,
                Grant_RN                  => Grant_RN_temp, Grant_RE => Grant_RE_temp, Grant_RW => Grant_RW_temp, Grant_RS => Grant_RS_temp, Grant_RL => Grant_RL_temp
            );
    MUX_6x1_Arbiter_output_W : component MUX_6x1_Arbiter_output
            generic map(
                DATA_WIDTH => DATA_WIDTH
            )
            port map(
                MUX_Arbiter_output_sel_in => "010",
                Xbar_sel_out              => Xbar_sel_W,
                RTS_out                   => RTS_W,
                Xbar_sel_N                => Xbar_sel_N_temp, Xbar_sel_E => Xbar_sel_E_temp, Xbar_sel_W => Xbar_sel_W_temp, Xbar_sel_S => Xbar_sel_S_temp, Xbar_sel_L => Xbar_sel_L_temp, Xbar_sel_R => Xbar_sel_R_temp,
                RTS_N                     => RTS_N_temp, RTS_E => RTS_E_temp, RTS_W => RTS_W_temp, RTS_S => RTS_S_temp, RTS_L => RTS_L_temp, RTS_R => RTS_R_temp,
                Grant_NN                  => Grant_NN_temp, Grant_NE => Grant_NE_temp, Grant_NW => Grant_NW_temp, Grant_NS => Grant_NS_temp, Grant_NL => Grant_NL_temp,
                Grant_EN                  => Grant_EN_temp, Grant_EE => Grant_EE_temp, Grant_EW => Grant_EW_temp, Grant_ES => Grant_ES_temp, Grant_EL => Grant_EL_temp,
                Grant_WN                  => Grant_WN_temp, Grant_WE => Grant_WE_temp, Grant_WW => Grant_WW_temp, Grant_WS => Grant_WS_temp, Grant_WL => Grant_WL_temp,
                Grant_SN                  => Grant_SN_temp, Grant_SE => Grant_SE_temp, Grant_SW => Grant_SW_temp, Grant_SS => Grant_SS_temp, Grant_SL => Grant_SL_temp,
                Grant_LN                  => Grant_LN_temp, Grant_LE => Grant_LE_temp, Grant_LW => Grant_LW_temp, Grant_LS => Grant_LS_temp, Grant_LL => Grant_LL_temp,
                Grant_RN                  => Grant_RN_temp, Grant_RE => Grant_RE_temp, Grant_RW => Grant_RW_temp, Grant_RS => Grant_RS_temp, Grant_RL => Grant_RL_temp
            );
    MUX_6x1_Arbiter_output_S : component MUX_6x1_Arbiter_output
            generic map(
                DATA_WIDTH => DATA_WIDTH
            )
            port map(
                MUX_Arbiter_output_sel_in => "011",
                Xbar_sel_out              => Xbar_sel_S,
                RTS_out                   => RTS_S,
                Xbar_sel_N                => Xbar_sel_N_temp, Xbar_sel_E => Xbar_sel_E_temp, Xbar_sel_W => Xbar_sel_W_temp, Xbar_sel_S => Xbar_sel_S_temp, Xbar_sel_L => Xbar_sel_L_temp, Xbar_sel_R => Xbar_sel_R_temp,
                RTS_N                     => RTS_N_temp, RTS_E => RTS_E_temp, RTS_W => RTS_W_temp, RTS_S => RTS_S_temp, RTS_L => RTS_L_temp, RTS_R => RTS_R_temp,
                Grant_NN                  => Grant_NN_temp, Grant_NE => Grant_NE_temp, Grant_NW => Grant_NW_temp, Grant_NS => Grant_NS_temp, Grant_NL => Grant_NL_temp,
                Grant_EN                  => Grant_EN_temp, Grant_EE => Grant_EE_temp, Grant_EW => Grant_EW_temp, Grant_ES => Grant_ES_temp, Grant_EL => Grant_EL_temp,
                Grant_WN                  => Grant_WN_temp, Grant_WE => Grant_WE_temp, Grant_WW => Grant_WW_temp, Grant_WS => Grant_WS_temp, Grant_WL => Grant_WL_temp,
                Grant_SN                  => Grant_SN_temp, Grant_SE => Grant_SE_temp, Grant_SW => Grant_SW_temp, Grant_SS => Grant_SS_temp, Grant_SL => Grant_SL_temp,
                Grant_LN                  => Grant_LN_temp, Grant_LE => Grant_LE_temp, Grant_LW => Grant_LW_temp, Grant_LS => Grant_LS_temp, Grant_LL => Grant_LL_temp,
                Grant_RN                  => Grant_RN_temp, Grant_RE => Grant_RE_temp, Grant_RW => Grant_RW_temp, Grant_RS => Grant_RS_temp, Grant_RL => Grant_RL_temp
            );
    MUX_6x1_Arbiter_output_L : component MUX_6x1_Arbiter_output
            generic map(
                DATA_WIDTH => DATA_WIDTH
            )
            port map(
                MUX_Arbiter_output_sel_in => "100",
                Xbar_sel_out              => Xbar_sel_L,
                RTS_out                   => RTS_L,
                Xbar_sel_N                => Xbar_sel_N_temp, Xbar_sel_E => Xbar_sel_E_temp, Xbar_sel_W => Xbar_sel_W_temp, Xbar_sel_S => Xbar_sel_S_temp, Xbar_sel_L => Xbar_sel_L_temp, Xbar_sel_R => Xbar_sel_R_temp,
                RTS_N                     => RTS_N_temp, RTS_E => RTS_E_temp, RTS_W => RTS_W_temp, RTS_S => RTS_S_temp, RTS_L => RTS_L_temp, RTS_R => RTS_R_temp,
                Grant_NN                  => Grant_NN_temp, Grant_NE => Grant_NE_temp, Grant_NW => Grant_NW_temp, Grant_NS => Grant_NS_temp, Grant_NL => Grant_NL_temp,
                Grant_EN                  => Grant_EN_temp, Grant_EE => Grant_EE_temp, Grant_EW => Grant_EW_temp, Grant_ES => Grant_ES_temp, Grant_EL => Grant_EL_temp,
                Grant_WN                  => Grant_WN_temp, Grant_WE => Grant_WE_temp, Grant_WW => Grant_WW_temp, Grant_WS => Grant_WS_temp, Grant_WL => Grant_WL_temp,
                Grant_SN                  => Grant_SN_temp, Grant_SE => Grant_SE_temp, Grant_SW => Grant_SW_temp, Grant_SS => Grant_SS_temp, Grant_SL => Grant_SL_temp,
                Grant_LN                  => Grant_LN_temp, Grant_LE => Grant_LE_temp, Grant_LW => Grant_LW_temp, Grant_LS => Grant_LS_temp, Grant_LL => Grant_LL_temp,
                Grant_RN                  => Grant_RN_temp, Grant_RE => Grant_RE_temp, Grant_RW => Grant_RW_temp, Grant_RS => Grant_RS_temp, Grant_RL => Grant_RL_temp
            );

end;
