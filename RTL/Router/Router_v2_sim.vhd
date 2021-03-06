library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity router is
	generic(
		DATA_WIDTH      : integer := 32;
		current_address : integer := 0;
		Rxy_rst         : integer := 60;
		Cx_rst          : integer := 10;
		NoC_size        : integer := 4
	);
	port(
		reset, clk                             : in  std_logic;
		DCTS_N, DCTS_E, DCTS_W, DCTS_S, DCTS_L : in  std_logic;
		DRTS_N, DRTS_E, DRTS_W, DRTS_S, DRTS_L : in  std_logic;
		RX_N, RX_E, RX_W, RX_S, RX_L           : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
		RTS_N, RTS_E, RTS_W, RTS_S, RTS_L      : out std_logic;
		CTS_N, CTS_E, CTS_W, CTS_S, CTS_L      : out std_logic;
		TX_N, TX_E, TX_W, TX_S, TX_L           : out std_logic_vector(DATA_WIDTH - 1 downto 0)
	);
end router;
architecture behavior of router is
	signal Fault_Info_FIFO_in    : std_logic_vector(4 downto 0) := (others => '0');
	signal Fault_Info_LBDR_in    : std_logic_vector(4 downto 0) := (others => '0');
	signal Fault_Info_ARBITER_in : std_logic_vector(4 downto 0) := (others => '0');
	signal Fault_Info_XBAR_in    : std_logic_vector(4 downto 0) := (others => '0');
	COMPONENT FIFO
		generic(
			DATA_WIDTH : integer := 32
		);
		port(reset     : in  std_logic;
			 clk       : in  std_logic;
			 RX        : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			 DRTS      : in  std_logic;
			 read_en_N : in  std_logic;
			 read_en_E : in  std_logic;
			 read_en_W : in  std_logic;
			 read_en_S : in  std_logic;
			 read_en_L : in  std_logic;
			 CTS       : out std_logic;
			 empty_out : out std_logic;
			 Data_out  : out std_logic_vector(DATA_WIDTH - 1 downto 0)
		);
	end COMPONENT;
	COMPONENT ARBITER
		port(reset                                       : in  std_logic;
			 clk                                         : in  std_logic;
			 Req_N, Req_E, Req_W, Req_S, Req_L           : in  std_logic;
			 DCTS                                        : in  std_logic;
			 Grant_N, Grant_E, Grant_W, Grant_S, Grant_L : out std_logic;
			 XBAR_sel                                    : out std_logic_vector(4 downto 0);
			 RTS                                         : out std_logic
		);
	end COMPONENT;
	COMPONENT LBDR is
		generic(
			cur_addr_rst : integer := 0;
			Rxy_rst      : integer := 60;
			Cx_rst       : integer := 8;
			NoC_size     : integer := 4
		);
		port(reset                             : in  std_logic;
			 clk                               : in  std_logic;
			 empty                             : in  std_logic;
			 flit_type                         : in  std_logic_vector(2 downto 0);
			 dst_addr                          : in  std_logic_vector(NoC_size - 1 downto 0);
			 Req_N, Req_E, Req_W, Req_S, Req_L : out std_logic
		);
	end COMPONENT;
	COMPONENT XBAR is
		generic(
			DATA_WIDTH : integer := 32
		);
		port(
			North_in : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			East_in  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			West_in  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			South_in : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			Local_in : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			sel      : in  std_logic_vector(4 downto 0);
			Data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0)
		);
	end COMPONENT;
	component Fault_Control_v2
		port(
			clk                                 : in  std_logic;
			Fault_Info_FIFO_in                  : in  std_logic_vector(4 downto 0);
			Fault_Info_LBDR_in                  : in  std_logic_vector(4 downto 0);
			Fault_Info_ARBITER_in               : in  std_logic_vector(4 downto 0);
			Fault_Info_XBAR_in                  : in  std_logic_vector(4 downto 0);
			MUX_5x1_FIFO_input_select_N_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_FIFO_input_select_E_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_FIFO_input_select_W_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_FIFO_input_select_S_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_FIFO_input_select_L_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_LBDR_input_select_N_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_LBDR_input_select_E_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_LBDR_input_select_W_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_LBDR_input_select_S_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_LBDR_input_select_L_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_ARBITER_input_select_N_out  : out std_logic_vector(2 downto 0);
			MUX_5x1_ARBITER_input_select_E_out  : out std_logic_vector(2 downto 0);
			MUX_5x1_ARBITER_input_select_W_out  : out std_logic_vector(2 downto 0);
			MUX_5x1_ARBITER_input_select_S_out  : out std_logic_vector(2 downto 0);
			MUX_5x1_ARBITER_input_select_L_out  : out std_logic_vector(2 downto 0);
			MUX_5x1_XBAR_input_select_N_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_XBAR_input_select_E_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_XBAR_input_select_W_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_XBAR_input_select_S_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_XBAR_input_select_L_out     : out std_logic_vector(2 downto 0);
			MUX_5x1_FIFO_output_select_N_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_FIFO_output_select_E_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_FIFO_output_select_W_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_FIFO_output_select_S_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_FIFO_output_select_L_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_LBDR_output_select_N_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_LBDR_output_select_E_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_LBDR_output_select_W_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_LBDR_output_select_S_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_LBDR_output_select_L_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_ARBITER_output_select_N_out : out std_logic_vector(2 downto 0);
			MUX_5x1_ARBITER_output_select_E_out : out std_logic_vector(2 downto 0);
			MUX_5x1_ARBITER_output_select_W_out : out std_logic_vector(2 downto 0);
			MUX_5x1_ARBITER_output_select_S_out : out std_logic_vector(2 downto 0);
			MUX_5x1_ARBITER_output_select_L_out : out std_logic_vector(2 downto 0);
			MUX_5x1_XBAR_output_select_N_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_XBAR_output_select_E_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_XBAR_output_select_W_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_XBAR_output_select_S_out    : out std_logic_vector(2 downto 0);
			MUX_5x1_XBAR_output_select_L_out    : out std_logic_vector(2 downto 0)
		);
	end component Fault_Control_v2;
	component MUX_5x1_XBAR_input
		generic(DATA_WIDTH : integer := 32);
		port(MUX_XBAR_input_sel_in : in  std_logic_vector(2 downto 0);
			 XBAR_sel_out          : out std_logic_vector(4 downto 0);
			 XBAR_sel_N            : in  std_logic_vector(4 downto 0);
			 XBAR_sel_E            : in  std_logic_vector(4 downto 0);
			 XBAR_sel_W            : in  std_logic_vector(4 downto 0);
			 XBAR_sel_S            : in  std_logic_vector(4 downto 0);
			 XBAR_sel_L            : in  std_logic_vector(4 downto 0));
	end component MUX_5x1_XBAR_input;
	component MUX_5x1_XBAR_output
		generic(DATA_WIDTH : integer := 32);
		port(MUX_XBAR_output_sel_in : in  std_logic_vector(2 downto 0);
			 TX_out                 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
			 TX_N                   : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			 TX_E                   : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			 TX_W                   : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			 TX_S                   : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			 TX_L                   : in  std_logic_vector(DATA_WIDTH - 1 downto 0));
	end component MUX_5x1_XBAR_output;
	component MUX_5x1_ARBITER_input
		generic(DATA_WIDTH : integer := 32);
		port(MUX_ARBITER_input_sel_in                                        : in  std_logic_vector(2 downto 0);
			 Req_N_out, Req_E_out, Req_W_out, Req_S_out, Req_L_out, DCTS_out : out std_logic;
			 DCTS_N, DCTS_E, DCTS_W, DCTS_S, DCTS_L                          : in  std_logic;
			 Req_NN, Req_NE, Req_NW, Req_NS, Req_NL                          : in  std_logic;
			 Req_EN, Req_EE, Req_EW, Req_ES, Req_EL                          : in  std_logic;
			 Req_WN, Req_WE, Req_WW, Req_WS, Req_WL                          : in  std_logic;
			 Req_SN, Req_SE, Req_SW, Req_SS, Req_SL                          : in  std_logic;
			 Req_LN, Req_LE, Req_LW, Req_LS, Req_LL                          : in  std_logic);
	end component MUX_5x1_ARBITER_input;
	component MUX_5x1_ARBITER_output
		generic(DATA_WIDTH : integer := 32);
		port(MUX_ARBITER_output_sel_in                                       : in  std_logic_vector(2 downto 0);
			 XBAR_sel_out                                                    : out std_logic_vector(4 downto 0);
			 RTS_out                                                         : out std_logic;
			 Grant_N_out, Grant_E_out, Grant_W_out, Grant_S_out, Grant_L_out : out std_logic;
			 XBAR_sel_N, XBAR_sel_E, XBAR_sel_W, XBAR_sel_S, XBAR_sel_L      : in  std_logic_vector(4 downto 0);
			 RTS_N, RTS_E, RTS_W, RTS_S, RTS_L                               : in  std_logic;
			 Grant_NN, Grant_NE, Grant_NW, Grant_NS, Grant_NL                : in  std_logic;
			 Grant_EN, Grant_EE, Grant_EW, Grant_ES, Grant_EL                : in  std_logic;
			 Grant_WN, Grant_WE, Grant_WW, Grant_WS, Grant_WL                : in  std_logic;
			 Grant_SN, Grant_SE, Grant_SW, Grant_SS, Grant_SL                : in  std_logic;
			 Grant_LN, Grant_LE, Grant_LW, Grant_LS, Grant_LL                : in  std_logic);
	end component MUX_5x1_ARBITER_output;
	component MUX_5x1_LBDR_input
		generic(
			cur_addr_rst : integer := 8;
			Rxy_rst      : integer := 8;
			Cx_rst       : integer := 8;
			NoC_size     : integer := 4
		);
		port(MUX_LBDR_input_sel_in                                           : in  std_logic_vector(2 downto 0);
			 empty_out                                                       : out std_logic;
			 flit_type_out                                                   : out std_logic_vector(2 downto 0);
			 dst_addr_out                                                    : out std_logic_vector(NoC_size - 1 downto 0);
			 empty_N, empty_E, empty_W, empty_S, empty_L                     : in  std_logic;
			 flit_type_N, flit_type_E, flit_type_W, flit_type_S, flit_type_L : in  std_logic_vector(2 downto 0);
			 dst_addr_N, dst_addr_E, dst_addr_W, dst_addr_S, dst_addr_L      : in  std_logic_vector(NoC_size - 1 downto 0));
	end component MUX_5x1_LBDR_input;
	component MUX_5x1_LBDR_output
		generic(DATA_WIDTH : integer := 32);
		port(MUX_LBDR_output_sel_in                                : in  std_logic_vector(2 downto 0);
			 Req_N_out, Req_E_out, Req_W_out, Req_S_out, Req_L_out : out std_logic;
			 Req_NN, Req_NE, Req_NW, Req_NS, Req_NL                : in  std_logic;
			 Req_EN, Req_EE, Req_EW, Req_ES, Req_EL                : in  std_logic;
			 Req_WN, Req_WE, Req_WW, Req_WS, Req_WL                : in  std_logic;
			 Req_SN, Req_SE, Req_SW, Req_SS, Req_SL                : in  std_logic;
			 Req_LN, Req_LE, Req_LW, Req_LS, Req_LL                : in  std_logic);
	end component MUX_5x1_LBDR_output;
	component MUX_5x1_FIFO_input
		generic(DATA_WIDTH : integer);
		port(MUX_FIFO_input_sel_in                                           : in  std_logic_vector(2 downto 0);
			 RX_out                                                          : out std_logic_vector(DATA_WIDTH - 1 downto 0);
			 DRTS_out                                                        : out std_logic;
			 Grant_N_out, Grant_E_out, Grant_W_out, Grant_S_out, Grant_L_out : out std_logic;
			 RX_N, RX_E, RX_W, RX_S, RX_L                                    : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			 DRTS_N, DRTS_E, DRTS_W, DRTS_S, DRTS_L                          : in  std_logic;
			 Grant_NN, Grant_EN, Grant_WN, Grant_SN, Grant_LN                : in  std_logic;
			 Grant_NE, Grant_EE, Grant_WE, Grant_SE, Grant_LE                : in  std_logic;
			 Grant_NW, Grant_EW, Grant_WW, Grant_SW, Grant_LW                : in  std_logic;
			 Grant_NS, Grant_ES, Grant_WS, Grant_SS, Grant_LS                : in  std_logic;
			 Grant_NL, Grant_EL, Grant_WL, Grant_SL, Grant_LL                : in  std_logic);
	end component MUX_5x1_FIFO_input;
	component MUX_5x1_FIFO_output
		generic(DATA_WIDTH : integer := 32);
		port(MUX_FIFO_output_sel_in                                               : in  std_logic_vector(2 downto 0);
			 CTS_out                                                              : out std_logic;
			 empty_out                                                            : out std_logic;
			 FIFO_D_out_out                                                       : out std_logic_vector(DATA_WIDTH - 1 downto 0);
			 CTS_N, CTS_E, CTS_W, CTS_S, CTS_L                                    : in  std_logic;
			 empty_N, empty_E, empty_W, empty_S, empty_L                          : in  std_logic;
			 FIFO_D_out_N, FIFO_D_out_E, FIFO_D_out_W, FIFO_D_out_S, FIFO_D_out_L : in  std_logic_vector(DATA_WIDTH - 1 downto 0));
	end component MUX_5x1_FIFO_output;
	signal Grant_NN_valid, Grant_NE_valid, Grant_NW_valid, Grant_NS_valid, Grant_NL_valid                     : std_logic;
	signal Grant_EN_valid, Grant_EE_valid, Grant_EW_valid, Grant_ES_valid, Grant_EL_valid                     : std_logic;
	signal Grant_WN_valid, Grant_WE_valid, Grant_WW_valid, Grant_WS_valid, Grant_WL_valid                     : std_logic;
	signal Grant_SN_valid, Grant_SE_valid, Grant_SW_valid, Grant_SS_valid, Grant_SL_valid                     : std_logic;
	signal Grant_LN_valid, Grant_LE_valid, Grant_LW_valid, Grant_LS_valid, Grant_LL_valid                     : std_logic;
	signal DRTS_N_valid, DRTS_E_valid, DRTS_W_valid, DRTS_S_valid, DRTS_L_valid                               : std_logic;
	signal RX_N_valid, RX_E_valid, RX_W_valid, RX_S_valid, RX_L_valid                                         : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal FIFO_D_out_N_temp, FIFO_D_out_E_temp, FIFO_D_out_W_temp, FIFO_D_out_S_temp, FIFO_D_out_L_temp      : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal empty_N_temp, empty_E_temp, empty_W_temp, empty_S_temp, empty_L_temp                               : std_logic;
	signal CTS_N_temp, CTS_E_temp, CTS_W_temp, CTS_S_temp, CTS_L_temp                                         : std_logic;
	signal FIFO_D_out_N, FIFO_D_out_E, FIFO_D_out_W, FIFO_D_out_S, FIFO_D_out_L                               : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal empty_N, empty_E, empty_W, empty_S, empty_L                                                        : std_logic;
	signal MUX_5x1_FIFO_input_select_N_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_FIFO_input_select_E_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_FIFO_input_select_W_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_FIFO_input_select_S_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_FIFO_input_select_L_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_FIFO_output_select_N_out                                                                   : std_logic_vector(2 downto 0);
	signal MUX_5x1_FIFO_output_select_E_out                                                                   : std_logic_vector(2 downto 0);
	signal MUX_5x1_FIFO_output_select_W_out                                                                   : std_logic_vector(2 downto 0);
	signal MUX_5x1_FIFO_output_select_S_out                                                                   : std_logic_vector(2 downto 0);
	signal MUX_5x1_FIFO_output_select_L_out                                                                   : std_logic_vector(2 downto 0);
	signal FIFO_D_out_N_valid, FIFO_D_out_E_valid, FIFO_D_out_W_valid, FIFO_D_out_S_valid, FIFO_D_out_L_valid : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal empty_N_valid, empty_E_valid, empty_W_valid, empty_S_valid, empty_L_valid                          : std_logic;
	signal Req_NN_temp, Req_EN_temp, Req_WN_temp, Req_SN_temp, Req_LN_temp                                    : std_logic;
	signal Req_NE_temp, Req_EE_temp, Req_WE_temp, Req_SE_temp, Req_LE_temp                                    : std_logic;
	signal Req_NW_temp, Req_EW_temp, Req_WW_temp, Req_SW_temp, Req_LW_temp                                    : std_logic;
	signal Req_NS_temp, Req_ES_temp, Req_WS_temp, Req_SS_temp, Req_LS_temp                                    : std_logic;
	signal Req_NL_temp, Req_EL_temp, Req_WL_temp, Req_SL_temp, Req_LL_temp                                    : std_logic;
	signal Req_NN, Req_EN, Req_WN, Req_SN, Req_LN                                                             : std_logic;
	signal Req_NE, Req_EE, Req_WE, Req_SE, Req_LE                                                             : std_logic;
	signal Req_NW, Req_EW, Req_WW, Req_SW, Req_LW                                                             : std_logic;
	signal Req_NS, Req_ES, Req_WS, Req_SS, Req_LS                                                             : std_logic;
	signal Req_NL, Req_EL, Req_WL, Req_SL, Req_LL                                                             : std_logic;
	signal MUX_5x1_LBDR_input_select_N_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_LBDR_input_select_E_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_LBDR_input_select_W_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_LBDR_input_select_S_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_LBDR_input_select_L_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_LBDR_output_select_N_out                                                                   : std_logic_vector(2 downto 0);
	signal MUX_5x1_LBDR_output_select_E_out                                                                   : std_logic_vector(2 downto 0);
	signal MUX_5x1_LBDR_output_select_W_out                                                                   : std_logic_vector(2 downto 0);
	signal MUX_5x1_LBDR_output_select_S_out                                                                   : std_logic_vector(2 downto 0);
	signal MUX_5x1_LBDR_output_select_L_out                                                                   : std_logic_vector(2 downto 0);
	signal DCTS_N_valid, Req_NN_valid, Req_EN_valid, Req_WN_valid, Req_SN_valid, Req_LN_valid                 : std_logic;
	signal DCTS_E_valid, Req_NE_valid, Req_EE_valid, Req_WE_valid, Req_SE_valid, Req_LE_valid                 : std_logic;
	signal DCTS_W_valid, Req_NW_valid, Req_EW_valid, Req_WW_valid, Req_SW_valid, Req_LW_valid                 : std_logic;
	signal DCTS_S_valid, Req_NS_valid, Req_ES_valid, Req_WS_valid, Req_SS_valid, Req_LS_valid                 : std_logic;
	signal DCTS_L_valid, Req_NL_valid, Req_EL_valid, Req_WL_valid, Req_SL_valid, Req_LL_valid                 : std_logic;
	signal Grant_NN_temp, Grant_NE_temp, Grant_NW_temp, Grant_NS_temp, Grant_NL_temp                          : std_logic;
	signal Grant_EN_temp, Grant_EE_temp, Grant_EW_temp, Grant_ES_temp, Grant_EL_temp                          : std_logic;
	signal Grant_WN_temp, Grant_WE_temp, Grant_WW_temp, Grant_WS_temp, Grant_WL_temp                          : std_logic;
	signal Grant_SN_temp, Grant_SE_temp, Grant_SW_temp, Grant_SS_temp, Grant_SL_temp                          : std_logic;
	signal Grant_LN_temp, Grant_LE_temp, Grant_LW_temp, Grant_LS_temp, Grant_LL_temp                          : std_logic;
	signal RTS_N_temp, RTS_E_temp, RTS_W_temp, RTS_S_temp, RTS_L_temp                                         : std_logic;
	signal XBAR_sel_N_temp, XBAR_sel_E_temp, XBAR_sel_W_temp, XBAR_sel_S_temp, XBAR_sel_L_temp                : std_logic_vector(4 downto 0);
	signal Grant_NN, Grant_NE, Grant_NW, Grant_NS, Grant_NL                                                   : std_logic;
	signal Grant_EN, Grant_EE, Grant_EW, Grant_ES, Grant_EL                                                   : std_logic;
	signal Grant_WN, Grant_WE, Grant_WW, Grant_WS, Grant_WL                                                   : std_logic;
	signal Grant_SN, Grant_SE, Grant_SW, Grant_SS, Grant_SL                                                   : std_logic;
	signal Grant_LN, Grant_LE, Grant_LW, Grant_LS, Grant_LL                                                   : std_logic;
	signal XBAR_sel_N, XBAR_sel_E, XBAR_sel_W, XBAR_sel_S, XBAR_sel_L                                         : std_logic_vector(4 downto 0);
	signal MUX_5x1_ARBITER_input_select_N_out                                                                 : std_logic_vector(2 downto 0);
	signal MUX_5x1_ARBITER_input_select_E_out                                                                 : std_logic_vector(2 downto 0);
	signal MUX_5x1_ARBITER_input_select_W_out                                                                 : std_logic_vector(2 downto 0);
	signal MUX_5x1_ARBITER_input_select_S_out                                                                 : std_logic_vector(2 downto 0);
	signal MUX_5x1_ARBITER_input_select_L_out                                                                 : std_logic_vector(2 downto 0);
	signal MUX_5x1_ARBITER_output_select_N_out                                                                : std_logic_vector(2 downto 0);
	signal MUX_5x1_ARBITER_output_select_E_out                                                                : std_logic_vector(2 downto 0);
	signal MUX_5x1_ARBITER_output_select_W_out                                                                : std_logic_vector(2 downto 0);
	signal MUX_5x1_ARBITER_output_select_S_out                                                                : std_logic_vector(2 downto 0);
	signal MUX_5x1_ARBITER_output_select_L_out                                                                : std_logic_vector(2 downto 0);
	signal XBAR_sel_N_valid, XBAR_sel_E_valid, XBAR_sel_W_valid, XBAR_sel_S_valid, XBAR_sel_L_valid           : std_logic_vector(4 downto 0);
	signal TX_N_temp, TX_E_temp, TX_W_temp, TX_S_temp, TX_L_temp                                              : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal MUX_5x1_XBAR_input_select_N_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_XBAR_input_select_E_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_XBAR_input_select_W_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_XBAR_input_select_S_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_XBAR_input_select_L_out                                                                    : std_logic_vector(2 downto 0);
	signal MUX_5x1_XBAR_output_select_N_out                                                                   : std_logic_vector(2 downto 0);
	signal MUX_5x1_XBAR_output_select_E_out                                                                   : std_logic_vector(2 downto 0);
	signal MUX_5x1_XBAR_output_select_W_out                                                                   : std_logic_vector(2 downto 0);
	signal MUX_5x1_XBAR_output_select_S_out                                                                   : std_logic_vector(2 downto 0);
	signal MUX_5x1_XBAR_output_select_L_out                                                                   : std_logic_vector(2 downto 0);
begin
	FIFO_N : FIFO generic map(DATA_WIDTH => DATA_WIDTH)
		PORT MAP(reset     => reset,
			     clk       => clk,
			     RX        => RX_N_valid,
			     DRTS      => DRTS_N_valid,
			     read_en_N => Grant_NN_valid,
			     read_en_E => Grant_EN_valid,
			     read_en_W => Grant_WN_valid,
			     read_en_S => Grant_SN_valid,
			     read_en_L => Grant_LN_valid,
			     CTS       => CTS_N_temp,
			     empty_out => empty_N_temp,
			     Data_out  => FIFO_D_out_N_temp);
	FIFO_E : FIFO generic map(DATA_WIDTH => DATA_WIDTH)
		PORT MAP(reset     => reset,
			     clk       => clk,
			     RX        => RX_E_valid,
			     DRTS      => DRTS_E_valid,
			     read_en_N => Grant_NE_valid,
			     read_en_E => Grant_EE_valid,
			     read_en_W => Grant_WE_valid,
			     read_en_S => Grant_SE_valid,
			     read_en_L => Grant_LE_valid,
			     CTS       => CTS_E_temp,
			     empty_out => empty_E_temp,
			     Data_out  => FIFO_D_out_E_temp);
	FIFO_W : FIFO generic map(DATA_WIDTH => DATA_WIDTH)
		PORT MAP(reset     => reset,
			     clk       => clk,
			     RX        => RX_W_valid,
			     DRTS      => DRTS_W_valid,
			     read_en_N => Grant_NW_valid,
			     read_en_E => Grant_EW_valid,
			     read_en_W => Grant_WW_valid,
			     read_en_S => Grant_SW_valid,
			     read_en_L => Grant_LW_valid,
			     CTS       => CTS_W_temp,
			     empty_out => empty_W_temp,
			     Data_out  => FIFO_D_out_W_temp);
	FIFO_S : FIFO generic map(DATA_WIDTH => DATA_WIDTH)
		PORT MAP(reset     => reset,
			     clk       => clk,
			     RX        => RX_S_valid,
			     DRTS      => DRTS_S_valid,
			     read_en_N => Grant_NS_valid,
			     read_en_E => Grant_ES_valid,
			     read_en_W => Grant_WS_valid,
			     read_en_S => Grant_SS_valid,
			     read_en_L => Grant_LS_valid,
			     CTS       => CTS_S_temp,
			     empty_out => empty_S_temp,
			     Data_out  => FIFO_D_out_S_temp);
	FIFO_L : FIFO generic map(DATA_WIDTH => DATA_WIDTH)
		PORT MAP(reset     => reset,
			     clk       => clk,
			     RX        => RX_L_valid,
			     DRTS      => DRTS_L_valid,
			     read_en_N => Grant_NL_valid,
			     read_en_E => Grant_EL_valid,
			     read_en_W => Grant_WL_valid,
			     read_en_S => Grant_SL_valid,
			     read_en_L => Grant_LL_valid,
			     CTS       => CTS_L_temp,
			     empty_out => empty_L_temp,
			     Data_out  => FIFO_D_out_L_temp);
	LBDR_N : LBDR generic map(cur_addr_rst => current_address,
			                  Rxy_rst      => Rxy_rst,
			                  Cx_rst       => Cx_rst,
			                  NoC_size     => NoC_size)
		PORT MAP(reset     => reset,
			     clk       => clk,
			     empty     => empty_N_valid,
			     flit_type => FIFO_D_out_N_valid(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			     dst_addr  => FIFO_D_out_N_valid(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			     Req_N     => Req_NN_temp,
			     Req_E     => Req_NE_temp,
			     Req_W     => Req_NW_temp,
			     Req_S     => Req_NS_temp,
			     Req_L     => Req_NL_temp);
	LBDR_E : LBDR generic map(cur_addr_rst => current_address,
			                  Rxy_rst      => Rxy_rst,
			                  Cx_rst       => Cx_rst,
			                  NoC_size     => NoC_size)
		PORT MAP(reset     => reset,
			     clk       => clk,
			     empty     => empty_E_valid,
			     flit_type => FIFO_D_out_E_valid(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			     dst_addr  => FIFO_D_out_E_valid(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			     Req_N     => Req_EN_temp,
			     Req_E     => Req_EE_temp,
			     Req_W     => Req_EW_temp,
			     Req_S     => Req_ES_temp,
			     Req_L     => Req_EL_temp);
	LBDR_W : LBDR generic map(cur_addr_rst => current_address,
			                  Rxy_rst      => Rxy_rst,
			                  Cx_rst       => Cx_rst,
			                  NoC_size     => NoC_size)
		PORT MAP(reset     => reset,
			     clk       => clk,
			     empty     => empty_W_valid,
			     flit_type => FIFO_D_out_W_valid(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			     dst_addr  => FIFO_D_out_W_valid(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			     Req_N     => Req_WN_temp,
			     Req_E     => Req_WE_temp,
			     Req_W     => Req_WW_temp,
			     Req_S     => Req_WS_temp,
			     Req_L     => Req_WL_temp);
	LBDR_S : LBDR generic map(cur_addr_rst => current_address,
			                  Rxy_rst      => Rxy_rst,
			                  Cx_rst       => Cx_rst,
			                  NoC_size     => NoC_size)
		PORT MAP(reset     => reset,
			     clk       => clk,
			     empty     => empty_S_valid,
			     flit_type => FIFO_D_out_S_valid(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			     dst_addr  => FIFO_D_out_S_valid(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			     Req_N     => Req_SN_temp,
			     Req_E     => Req_SE_temp,
			     Req_W     => Req_SW_temp,
			     Req_S     => Req_SS_temp,
			     Req_L     => Req_SL_temp);
	LBDR_L : LBDR generic map(cur_addr_rst => current_address,
			                  Rxy_rst      => Rxy_rst,
			                  Cx_rst       => Cx_rst,
			                  NoC_size     => NoC_size)
		PORT MAP(reset     => reset,
			     clk       => clk,
			     empty     => empty_L_valid,
			     flit_type => FIFO_D_out_L_valid(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			     dst_addr  => FIFO_D_out_L_valid(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			     Req_N     => Req_LN_temp,
			     Req_E     => Req_LE_temp,
			     Req_W     => Req_LW_temp,
			     Req_S     => Req_LS_temp,
			     Req_L     => Req_LL_temp);
	ARBITER_N : ARBITER
		PORT MAP(reset    => reset,
			     clk      => clk,
			     Req_N    => Req_NN_valid,
			     Req_E    => Req_EN_valid,
			     Req_W    => Req_WN_valid,
			     Req_S    => Req_SN_valid,
			     Req_L    => Req_LN_valid,
			     DCTS     => DCTS_N_valid,
			     Grant_N  => Grant_NN_temp,
			     Grant_E  => Grant_NE_temp,
			     Grant_W  => Grant_NW_temp,
			     Grant_S  => Grant_NS_temp,
			     Grant_L  => Grant_NL_temp,
			     XBAR_sel => XBAR_sel_N_temp,
			     RTS      => RTS_N_temp
		);
	ARBITER_E : ARBITER
		PORT MAP(reset    => reset,
			     clk      => clk,
			     Req_N    => Req_NE_valid,
			     Req_E    => Req_EE_valid,
			     Req_W    => Req_WE_valid,
			     Req_S    => Req_SE_valid,
			     Req_L    => Req_LE_valid,
			     DCTS     => DCTS_E_valid,
			     Grant_N  => Grant_EN_temp,
			     Grant_E  => Grant_EE_temp,
			     Grant_W  => Grant_EW_temp,
			     Grant_S  => Grant_ES_temp,
			     Grant_L  => Grant_EL_temp,
			     XBAR_sel => XBAR_sel_E_temp,
			     RTS      => RTS_E_temp
		);
	ARBITER_W : ARBITER
		PORT MAP(reset    => reset,
			     clk      => clk,
			     Req_N    => Req_NW_valid,
			     Req_E    => Req_EW_valid,
			     Req_W    => Req_WW_valid,
			     Req_S    => Req_SW_valid,
			     Req_L    => Req_LW_valid,
			     DCTS     => DCTS_W_valid,
			     Grant_N  => Grant_WN_temp,
			     Grant_E  => Grant_WE_temp,
			     Grant_W  => Grant_WW_temp,
			     Grant_S  => Grant_WS_temp,
			     Grant_L  => Grant_WL_temp,
			     XBAR_sel => XBAR_sel_W_temp,
			     RTS      => RTS_W_temp
		);
	ARBITER_S : ARBITER
		PORT MAP(reset    => reset,
			     clk      => clk,
			     Req_N    => Req_NS_valid,
			     Req_E    => Req_ES_valid,
			     Req_W    => Req_WS_valid,
			     Req_S    => Req_SS_valid,
			     Req_L    => Req_LS_valid,
			     DCTS     => DCTS_S_valid,
			     Grant_N  => Grant_SN_temp,
			     Grant_E  => Grant_SE_temp,
			     Grant_W  => Grant_SW_temp,
			     Grant_S  => Grant_SS_temp,
			     Grant_L  => Grant_SL_temp,
			     XBAR_sel => XBAR_sel_S_temp,
			     RTS      => RTS_S_temp
		);
	ARBITER_L : ARBITER
		PORT MAP(reset    => reset,
			     clk      => clk,
			     Req_N    => Req_NL_valid,
			     Req_E    => Req_EL_valid,
			     Req_W    => Req_WL_valid,
			     Req_S    => Req_SL_valid,
			     Req_L    => Req_LL_valid,
			     DCTS     => DCTS_L_valid,
			     Grant_N  => Grant_LN_temp,
			     Grant_E  => Grant_LE_temp,
			     Grant_W  => Grant_LW_temp,
			     Grant_S  => Grant_LS_temp,
			     Grant_L  => Grant_LL_temp,
			     XBAR_sel => XBAR_sel_L_temp,
			     RTS      => RTS_L_temp
		);
	XBAR_N : XBAR generic map(DATA_WIDTH => DATA_WIDTH)
		PORT MAP(North_in => FIFO_D_out_N,
			     East_in  => FIFO_D_out_E,
			     West_in  => FIFO_D_out_W,
			     South_in => FIFO_D_out_S,
			     Local_in => FIFO_D_out_L,
			     sel      => XBAR_sel_N_valid,
			     Data_out => TX_N_temp);
	XBAR_E : XBAR generic map(DATA_WIDTH => DATA_WIDTH)
		PORT MAP(North_in => FIFO_D_out_N,
			     East_in  => FIFO_D_out_E,
			     West_in  => FIFO_D_out_W,
			     South_in => FIFO_D_out_S,
			     Local_in => FIFO_D_out_L,
			     sel      => XBAR_sel_E_valid,
			     Data_out => TX_E_temp);
	XBAR_W : XBAR generic map(DATA_WIDTH => DATA_WIDTH)
		PORT MAP(North_in => FIFO_D_out_N,
			     East_in  => FIFO_D_out_E,
			     West_in  => FIFO_D_out_W,
			     South_in => FIFO_D_out_S,
			     Local_in => FIFO_D_out_L,
			     sel      => XBAR_sel_W_valid,
			     Data_out => TX_W_temp);
	XBAR_S : XBAR generic map(DATA_WIDTH => DATA_WIDTH)
		PORT MAP(North_in => FIFO_D_out_N,
			     East_in  => FIFO_D_out_E,
			     West_in  => FIFO_D_out_W,
			     South_in => FIFO_D_out_S,
			     Local_in => FIFO_D_out_L,
			     sel      => XBAR_sel_S_valid,
			     Data_out => TX_S_temp);
	XBAR_L : XBAR generic map(DATA_WIDTH => DATA_WIDTH)
		PORT MAP(North_in => FIFO_D_out_N,
			     East_in  => FIFO_D_out_E,
			     West_in  => FIFO_D_out_W,
			     South_in => FIFO_D_out_S,
			     Local_in => FIFO_D_out_L,
			     sel      => XBAR_sel_L_valid,
			     Data_out => TX_L_temp);
	Fault_Control_v2_inst : component Fault_Control_v2
		port map(
			clk                                 => clk,
			Fault_Info_FIFO_in                  => Fault_Info_FIFO_in,
			Fault_Info_LBDR_in                  => Fault_Info_LBDR_in,
			Fault_Info_ARBITER_in               => Fault_Info_ARBITER_in,
			Fault_Info_XBAR_in                  => Fault_Info_XBAR_in,
			MUX_5x1_FIFO_input_select_N_out     => MUX_5x1_FIFO_input_select_N_out,
			MUX_5x1_FIFO_input_select_E_out     => MUX_5x1_FIFO_input_select_E_out,
			MUX_5x1_FIFO_input_select_W_out     => MUX_5x1_FIFO_input_select_W_out,
			MUX_5x1_FIFO_input_select_S_out     => MUX_5x1_FIFO_input_select_S_out,
			MUX_5x1_FIFO_input_select_L_out     => MUX_5x1_FIFO_input_select_L_out,
			MUX_5x1_LBDR_input_select_N_out     => MUX_5x1_LBDR_input_select_N_out,
			MUX_5x1_LBDR_input_select_E_out     => MUX_5x1_LBDR_input_select_E_out,
			MUX_5x1_LBDR_input_select_W_out     => MUX_5x1_LBDR_input_select_W_out,
			MUX_5x1_LBDR_input_select_S_out     => MUX_5x1_LBDR_input_select_S_out,
			MUX_5x1_LBDR_input_select_L_out     => MUX_5x1_LBDR_input_select_L_out,
			MUX_5x1_ARBITER_input_select_N_out  => MUX_5x1_ARBITER_input_select_N_out,
			MUX_5x1_ARBITER_input_select_E_out  => MUX_5x1_ARBITER_input_select_E_out,
			MUX_5x1_ARBITER_input_select_W_out  => MUX_5x1_ARBITER_input_select_W_out,
			MUX_5x1_ARBITER_input_select_S_out  => MUX_5x1_ARBITER_input_select_S_out,
			MUX_5x1_ARBITER_input_select_L_out  => MUX_5x1_ARBITER_input_select_L_out,
			MUX_5x1_XBAR_input_select_N_out     => MUX_5x1_XBAR_input_select_N_out,
			MUX_5x1_XBAR_input_select_E_out     => MUX_5x1_XBAR_input_select_E_out,
			MUX_5x1_XBAR_input_select_W_out     => MUX_5x1_XBAR_input_select_W_out,
			MUX_5x1_XBAR_input_select_S_out     => MUX_5x1_XBAR_input_select_S_out,
			MUX_5x1_XBAR_input_select_L_out     => MUX_5x1_XBAR_input_select_L_out,
			MUX_5x1_FIFO_output_select_N_out    => MUX_5x1_FIFO_output_select_N_out,
			MUX_5x1_FIFO_output_select_E_out    => MUX_5x1_FIFO_output_select_E_out,
			MUX_5x1_FIFO_output_select_W_out    => MUX_5x1_FIFO_output_select_W_out,
			MUX_5x1_FIFO_output_select_S_out    => MUX_5x1_FIFO_output_select_S_out,
			MUX_5x1_FIFO_output_select_L_out    => MUX_5x1_FIFO_output_select_L_out,
			MUX_5x1_LBDR_output_select_N_out    => MUX_5x1_LBDR_output_select_N_out,
			MUX_5x1_LBDR_output_select_E_out    => MUX_5x1_LBDR_output_select_E_out,
			MUX_5x1_LBDR_output_select_W_out    => MUX_5x1_LBDR_output_select_W_out,
			MUX_5x1_LBDR_output_select_S_out    => MUX_5x1_LBDR_output_select_S_out,
			MUX_5x1_LBDR_output_select_L_out    => MUX_5x1_LBDR_output_select_L_out,
			MUX_5x1_ARBITER_output_select_N_out => MUX_5x1_ARBITER_output_select_N_out,
			MUX_5x1_ARBITER_output_select_E_out => MUX_5x1_ARBITER_output_select_E_out,
			MUX_5x1_ARBITER_output_select_W_out => MUX_5x1_ARBITER_output_select_W_out,
			MUX_5x1_ARBITER_output_select_S_out => MUX_5x1_ARBITER_output_select_S_out,
			MUX_5x1_ARBITER_output_select_L_out => MUX_5x1_ARBITER_output_select_L_out,
			MUX_5x1_XBAR_output_select_N_out    => MUX_5x1_XBAR_output_select_N_out,
			MUX_5x1_XBAR_output_select_E_out    => MUX_5x1_XBAR_output_select_E_out,
			MUX_5x1_XBAR_output_select_W_out    => MUX_5x1_XBAR_output_select_W_out,
			MUX_5x1_XBAR_output_select_S_out    => MUX_5x1_XBAR_output_select_S_out,
			MUX_5x1_XBAR_output_select_L_out    => MUX_5x1_XBAR_output_select_L_out
		);
	MUX_5x1_XBAR_input_N : component MUX_5x1_XBAR_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_XBAR_input_sel_in => MUX_5x1_XBAR_input_select_N_out,
			XBAR_sel_out          => XBAR_sel_N_valid,
			XBAR_sel_N            => XBAR_sel_N,
			XBAR_sel_E            => XBAR_sel_E,
			XBAR_sel_W            => XBAR_sel_W,
			XBAR_sel_S            => XBAR_sel_S,
			XBAR_sel_L            => XBAR_sel_L
		);
	MUX_5x1_XBAR_input_E : component MUX_5x1_XBAR_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_XBAR_input_sel_in => MUX_5x1_XBAR_input_select_E_out,
			XBAR_sel_out          => XBAR_sel_E_valid,
			XBAR_sel_N            => XBAR_sel_N,
			XBAR_sel_E            => XBAR_sel_E,
			XBAR_sel_W            => XBAR_sel_W,
			XBAR_sel_S            => XBAR_sel_S,
			XBAR_sel_L            => XBAR_sel_L
		);
	MUX_5x1_XBAR_input_W : component MUX_5x1_XBAR_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_XBAR_input_sel_in => MUX_5x1_XBAR_input_select_W_out,
			XBAR_sel_out          => XBAR_sel_W_valid,
			XBAR_sel_N            => XBAR_sel_N,
			XBAR_sel_E            => XBAR_sel_E,
			XBAR_sel_W            => XBAR_sel_W,
			XBAR_sel_S            => XBAR_sel_S,
			XBAR_sel_L            => XBAR_sel_L
		);
	MUX_5x1_XBAR_input_S : component MUX_5x1_XBAR_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_XBAR_input_sel_in => MUX_5x1_XBAR_input_select_S_out,
			XBAR_sel_out          => XBAR_sel_S_valid,
			XBAR_sel_N            => XBAR_sel_N,
			XBAR_sel_E            => XBAR_sel_E,
			XBAR_sel_W            => XBAR_sel_W,
			XBAR_sel_S            => XBAR_sel_S,
			XBAR_sel_L            => XBAR_sel_L
		);
	MUX_5x1_XBAR_input_L : component MUX_5x1_XBAR_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_XBAR_input_sel_in => MUX_5x1_XBAR_input_select_L_out,
			XBAR_sel_out          => XBAR_sel_L_valid,
			XBAR_sel_N            => XBAR_sel_N,
			XBAR_sel_E            => XBAR_sel_E,
			XBAR_sel_W            => XBAR_sel_W,
			XBAR_sel_S            => XBAR_sel_S,
			XBAR_sel_L            => XBAR_sel_L
		);
	MUX_5x1_XBAR_output_N : component MUX_5x1_XBAR_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_XBAR_output_sel_in => MUX_5x1_XBAR_output_select_N_out,
			TX_out                 => TX_N,
			TX_N                   => TX_N_temp,
			TX_E                   => TX_E_temp,
			TX_W                   => TX_W_temp,
			TX_S                   => TX_S_temp,
			TX_L                   => TX_L_temp
		);
	MUX_5x1_XBAR_output_E : component MUX_5x1_XBAR_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_XBAR_output_sel_in => MUX_5x1_XBAR_output_select_E_out,
			TX_out                 => TX_E,
			TX_N                   => TX_N_temp,
			TX_E                   => TX_E_temp,
			TX_W                   => TX_W_temp,
			TX_S                   => TX_S_temp,
			TX_L                   => TX_L_temp
		);
	MUX_5x1_XBAR_output_W : component MUX_5x1_XBAR_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_XBAR_output_sel_in => MUX_5x1_XBAR_output_select_W_out,
			TX_out                 => TX_W,
			TX_N                   => TX_N_temp,
			TX_E                   => TX_E_temp,
			TX_W                   => TX_W_temp,
			TX_S                   => TX_S_temp,
			TX_L                   => TX_L_temp
		);
	MUX_5x1_XBAR_output_S : component MUX_5x1_XBAR_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_XBAR_output_sel_in => MUX_5x1_XBAR_output_select_S_out,
			TX_out                 => TX_S,
			TX_N                   => TX_N_temp,
			TX_E                   => TX_E_temp,
			TX_W                   => TX_W_temp,
			TX_S                   => TX_S_temp,
			TX_L                   => TX_L_temp
		);
	MUX_5x1_XBAR_output_L : component MUX_5x1_XBAR_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_XBAR_output_sel_in => MUX_5x1_XBAR_output_select_L_out,
			TX_out                 => TX_L,
			TX_N                   => TX_N_temp,
			TX_E                   => TX_E_temp,
			TX_W                   => TX_W_temp,
			TX_S                   => TX_S_temp,
			TX_L                   => TX_L_temp
		);
	MUX_5x1_ARBITER_input_N : component MUX_5x1_ARBITER_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_ARBITER_input_sel_in => MUX_5x1_ARBITER_input_select_N_out,
			Req_N_out                => Req_NN_valid,
			Req_E_out                => Req_EN_valid,
			Req_W_out                => Req_WN_valid,
			Req_S_out                => Req_SN_valid,
			Req_L_out                => Req_LN_valid,
			DCTS_out                 => DCTS_N_valid,
			DCTS_N                   => DCTS_N,
			DCTS_E                   => DCTS_E,
			DCTS_W                   => DCTS_W,
			DCTS_S                   => DCTS_S,
			DCTS_L                   => DCTS_L,
			Req_NN                   => Req_NN,
			Req_NE                   => Req_NE,
			Req_NW                   => Req_NW,
			Req_NS                   => Req_NS,
			Req_NL                   => Req_NL,
			Req_EN                   => Req_EN,
			Req_EE                   => Req_EE,
			Req_EW                   => Req_EW,
			Req_ES                   => Req_ES,
			Req_EL                   => Req_EL,
			Req_WN                   => Req_WN,
			Req_WE                   => Req_WE,
			Req_WW                   => Req_WW,
			Req_WS                   => Req_WS,
			Req_WL                   => Req_WL,
			Req_SN                   => Req_SN,
			Req_SE                   => Req_SE,
			Req_SW                   => Req_SW,
			Req_SS                   => Req_SS,
			Req_SL                   => Req_SL,
			Req_LN                   => Req_LN,
			Req_LE                   => Req_LE,
			Req_LW                   => Req_LW,
			Req_LS                   => Req_LS,
			Req_LL                   => Req_LL);
	MUX_5x1_ARBITER_input_E : component MUX_5x1_ARBITER_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_ARBITER_input_sel_in => MUX_5x1_ARBITER_input_select_E_out,
			Req_N_out                => Req_NE_valid,
			Req_E_out                => Req_EE_valid,
			Req_W_out                => Req_WE_valid,
			Req_S_out                => Req_SE_valid,
			Req_L_out                => Req_LE_valid,
			DCTS_out                 => DCTS_E_valid,
			DCTS_N                   => DCTS_N,
			DCTS_E                   => DCTS_E,
			DCTS_W                   => DCTS_W,
			DCTS_S                   => DCTS_S,
			DCTS_L                   => DCTS_L,
			Req_NN                   => Req_NN,
			Req_NE                   => Req_NE,
			Req_NW                   => Req_NW,
			Req_NS                   => Req_NS,
			Req_NL                   => Req_NL,
			Req_EN                   => Req_EN,
			Req_EE                   => Req_EE,
			Req_EW                   => Req_EW,
			Req_ES                   => Req_ES,
			Req_EL                   => Req_EL,
			Req_WN                   => Req_WN,
			Req_WE                   => Req_WE,
			Req_WW                   => Req_WW,
			Req_WS                   => Req_WS,
			Req_WL                   => Req_WL,
			Req_SN                   => Req_SN,
			Req_SE                   => Req_SE,
			Req_SW                   => Req_SW,
			Req_SS                   => Req_SS,
			Req_SL                   => Req_SL,
			Req_LN                   => Req_LN,
			Req_LE                   => Req_LE,
			Req_LW                   => Req_LW,
			Req_LS                   => Req_LS,
			Req_LL                   => Req_LL);
	MUX_5x1_ARBITER_input_W : component MUX_5x1_ARBITER_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_ARBITER_input_sel_in => MUX_5x1_ARBITER_input_select_W_out,
			Req_N_out                => Req_NW_valid,
			Req_E_out                => Req_EW_valid,
			Req_W_out                => Req_WW_valid,
			Req_S_out                => Req_SW_valid,
			Req_L_out                => Req_LW_valid,
			DCTS_out                 => DCTS_W_valid,
			DCTS_N                   => DCTS_N,
			DCTS_E                   => DCTS_E,
			DCTS_W                   => DCTS_W,
			DCTS_S                   => DCTS_S,
			DCTS_L                   => DCTS_L,
			Req_NN                   => Req_NN,
			Req_NE                   => Req_NE,
			Req_NW                   => Req_NW,
			Req_NS                   => Req_NS,
			Req_NL                   => Req_NL,
			Req_EN                   => Req_EN,
			Req_EE                   => Req_EE,
			Req_EW                   => Req_EW,
			Req_ES                   => Req_ES,
			Req_EL                   => Req_EL,
			Req_WN                   => Req_WN,
			Req_WE                   => Req_WE,
			Req_WW                   => Req_WW,
			Req_WS                   => Req_WS,
			Req_WL                   => Req_WL,
			Req_SN                   => Req_SN,
			Req_SE                   => Req_SE,
			Req_SW                   => Req_SW,
			Req_SS                   => Req_SS,
			Req_SL                   => Req_SL,
			Req_LN                   => Req_LN,
			Req_LE                   => Req_LE,
			Req_LW                   => Req_LW,
			Req_LS                   => Req_LS,
			Req_LL                   => Req_LL);
	MUX_5x1_ARBITER_input_S : component MUX_5x1_ARBITER_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_ARBITER_input_sel_in => MUX_5x1_ARBITER_input_select_S_out,
			Req_N_out                => Req_NS_valid,
			Req_E_out                => Req_ES_valid,
			Req_W_out                => Req_WS_valid,
			Req_S_out                => Req_SS_valid,
			Req_L_out                => Req_LS_valid,
			DCTS_out                 => DCTS_S_valid,
			DCTS_N                   => DCTS_N,
			DCTS_E                   => DCTS_E,
			DCTS_W                   => DCTS_W,
			DCTS_S                   => DCTS_S,
			DCTS_L                   => DCTS_L,
			Req_NN                   => Req_NN,
			Req_NE                   => Req_NE,
			Req_NW                   => Req_NW,
			Req_NS                   => Req_NS,
			Req_NL                   => Req_NL,
			Req_EN                   => Req_EN,
			Req_EE                   => Req_EE,
			Req_EW                   => Req_EW,
			Req_ES                   => Req_ES,
			Req_EL                   => Req_EL,
			Req_WN                   => Req_WN,
			Req_WE                   => Req_WE,
			Req_WW                   => Req_WW,
			Req_WS                   => Req_WS,
			Req_WL                   => Req_WL,
			Req_SN                   => Req_SN,
			Req_SE                   => Req_SE,
			Req_SW                   => Req_SW,
			Req_SS                   => Req_SS,
			Req_SL                   => Req_SL,
			Req_LN                   => Req_LN,
			Req_LE                   => Req_LE,
			Req_LW                   => Req_LW,
			Req_LS                   => Req_LS,
			Req_LL                   => Req_LL);
	MUX_5x1_ARBITER_input_L : component MUX_5x1_ARBITER_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_ARBITER_input_sel_in => MUX_5x1_ARBITER_input_select_L_out,
			Req_N_out                => Req_NL_valid,
			Req_E_out                => Req_EL_valid,
			Req_W_out                => Req_WL_valid,
			Req_S_out                => Req_SL_valid,
			Req_L_out                => Req_LL_valid,
			DCTS_out                 => DCTS_L_valid,
			DCTS_N                   => DCTS_N,
			DCTS_E                   => DCTS_E,
			DCTS_W                   => DCTS_W,
			DCTS_S                   => DCTS_S,
			DCTS_L                   => DCTS_L,
			Req_NN                   => Req_NN,
			Req_NE                   => Req_NE,
			Req_NW                   => Req_NW,
			Req_NS                   => Req_NS,
			Req_NL                   => Req_NL,
			Req_EN                   => Req_EN,
			Req_EE                   => Req_EE,
			Req_EW                   => Req_EW,
			Req_ES                   => Req_ES,
			Req_EL                   => Req_EL,
			Req_WN                   => Req_WN,
			Req_WE                   => Req_WE,
			Req_WW                   => Req_WW,
			Req_WS                   => Req_WS,
			Req_WL                   => Req_WL,
			Req_SN                   => Req_SN,
			Req_SE                   => Req_SE,
			Req_SW                   => Req_SW,
			Req_SS                   => Req_SS,
			Req_SL                   => Req_SL,
			Req_LN                   => Req_LN,
			Req_LE                   => Req_LE,
			Req_LW                   => Req_LW,
			Req_LS                   => Req_LS,
			Req_LL                   => Req_LL);
	MUX_5x1_ARBITER_output_N : component MUX_5x1_ARBITER_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_ARBITER_output_sel_in => MUX_5x1_ARBITER_output_select_N_out,
			XBAR_sel_out              => XBAR_sel_N,
			RTS_out                   => RTS_N,
			Grant_N_out               => Grant_NN,
			Grant_E_out               => Grant_NE,
			Grant_W_out               => Grant_NW,
			Grant_S_out               => Grant_NS,
			Grant_L_out               => Grant_NL,
			XBAR_sel_N                => XBAR_sel_N_temp,
			XBAR_sel_E                => XBAR_sel_E_temp,
			XBAR_sel_W                => XBAR_sel_W_temp,
			XBAR_sel_S                => XBAR_sel_S_temp,
			XBAR_sel_L                => XBAR_sel_L_temp,
			RTS_N                     => RTS_N_temp,
			RTS_E                     => RTS_E_temp,
			RTS_W                     => RTS_W_temp,
			RTS_S                     => RTS_S_temp,
			RTS_L                     => RTS_L_temp,
			Grant_NN                  => Grant_NN_temp,
			Grant_NE                  => Grant_NE_temp,
			Grant_NW                  => Grant_NW_temp,
			Grant_NS                  => Grant_NS_temp,
			Grant_NL                  => Grant_NL_temp,
			Grant_EN                  => Grant_EN_temp,
			Grant_EE                  => Grant_EE_temp,
			Grant_EW                  => Grant_EW_temp,
			Grant_ES                  => Grant_ES_temp,
			Grant_EL                  => Grant_EL_temp,
			Grant_WN                  => Grant_WN_temp,
			Grant_WE                  => Grant_WE_temp,
			Grant_WW                  => Grant_WW_temp,
			Grant_WS                  => Grant_WS_temp,
			Grant_WL                  => Grant_WL_temp,
			Grant_SN                  => Grant_SN_temp,
			Grant_SE                  => Grant_SE_temp,
			Grant_SW                  => Grant_SW_temp,
			Grant_SS                  => Grant_SS_temp,
			Grant_SL                  => Grant_SL_temp,
			Grant_LN                  => Grant_LN_temp,
			Grant_LE                  => Grant_LE_temp,
			Grant_LW                  => Grant_LW_temp,
			Grant_LS                  => Grant_LS_temp,
			Grant_LL                  => Grant_LL_temp);
	MUX_5x1_ARBITER_output_E : component MUX_5x1_ARBITER_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_ARBITER_output_sel_in => MUX_5x1_ARBITER_output_select_E_out,
			XBAR_sel_out              => XBAR_sel_E,
			RTS_out                   => RTS_E,
			Grant_N_out               => Grant_EN,
			Grant_E_out               => Grant_EE,
			Grant_W_out               => Grant_EW,
			Grant_S_out               => Grant_ES,
			Grant_L_out               => Grant_EL,
			XBAR_sel_N                => XBAR_sel_N_temp,
			XBAR_sel_E                => XBAR_sel_E_temp,
			XBAR_sel_W                => XBAR_sel_W_temp,
			XBAR_sel_S                => XBAR_sel_S_temp,
			XBAR_sel_L                => XBAR_sel_L_temp,
			RTS_N                     => RTS_N_temp,
			RTS_E                     => RTS_E_temp,
			RTS_W                     => RTS_W_temp,
			RTS_S                     => RTS_S_temp,
			RTS_L                     => RTS_L_temp,
			Grant_NN                  => Grant_NN_temp,
			Grant_NE                  => Grant_NE_temp,
			Grant_NW                  => Grant_NW_temp,
			Grant_NS                  => Grant_NS_temp,
			Grant_NL                  => Grant_NL_temp,
			Grant_EN                  => Grant_EN_temp,
			Grant_EE                  => Grant_EE_temp,
			Grant_EW                  => Grant_EW_temp,
			Grant_ES                  => Grant_ES_temp,
			Grant_EL                  => Grant_EL_temp,
			Grant_WN                  => Grant_WN_temp,
			Grant_WE                  => Grant_WE_temp,
			Grant_WW                  => Grant_WW_temp,
			Grant_WS                  => Grant_WS_temp,
			Grant_WL                  => Grant_WL_temp,
			Grant_SN                  => Grant_SN_temp,
			Grant_SE                  => Grant_SE_temp,
			Grant_SW                  => Grant_SW_temp,
			Grant_SS                  => Grant_SS_temp,
			Grant_SL                  => Grant_SL_temp,
			Grant_LN                  => Grant_LN_temp,
			Grant_LE                  => Grant_LE_temp,
			Grant_LW                  => Grant_LW_temp,
			Grant_LS                  => Grant_LS_temp,
			Grant_LL                  => Grant_LL_temp);
	MUX_5x1_ARBITER_output_W : component MUX_5x1_ARBITER_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_ARBITER_output_sel_in => MUX_5x1_ARBITER_output_select_W_out,
			XBAR_sel_out              => XBAR_sel_W,
			RTS_out                   => RTS_W,
			Grant_N_out               => Grant_WN,
			Grant_E_out               => Grant_WE,
			Grant_W_out               => Grant_WW,
			Grant_S_out               => Grant_WS,
			Grant_L_out               => Grant_WL,
			XBAR_sel_N                => XBAR_sel_N_temp,
			XBAR_sel_E                => XBAR_sel_E_temp,
			XBAR_sel_W                => XBAR_sel_W_temp,
			XBAR_sel_S                => XBAR_sel_S_temp,
			XBAR_sel_L                => XBAR_sel_L_temp,
			RTS_N                     => RTS_N_temp,
			RTS_E                     => RTS_E_temp,
			RTS_W                     => RTS_W_temp,
			RTS_S                     => RTS_S_temp,
			RTS_L                     => RTS_L_temp,
			Grant_NN                  => Grant_NN_temp,
			Grant_NE                  => Grant_NE_temp,
			Grant_NW                  => Grant_NW_temp,
			Grant_NS                  => Grant_NS_temp,
			Grant_NL                  => Grant_NL_temp,
			Grant_EN                  => Grant_EN_temp,
			Grant_EE                  => Grant_EE_temp,
			Grant_EW                  => Grant_EW_temp,
			Grant_ES                  => Grant_ES_temp,
			Grant_EL                  => Grant_EL_temp,
			Grant_WN                  => Grant_WN_temp,
			Grant_WE                  => Grant_WE_temp,
			Grant_WW                  => Grant_WW_temp,
			Grant_WS                  => Grant_WS_temp,
			Grant_WL                  => Grant_WL_temp,
			Grant_SN                  => Grant_SN_temp,
			Grant_SE                  => Grant_SE_temp,
			Grant_SW                  => Grant_SW_temp,
			Grant_SS                  => Grant_SS_temp,
			Grant_SL                  => Grant_SL_temp,
			Grant_LN                  => Grant_LN_temp,
			Grant_LE                  => Grant_LE_temp,
			Grant_LW                  => Grant_LW_temp,
			Grant_LS                  => Grant_LS_temp,
			Grant_LL                  => Grant_LL_temp);
	MUX_5x1_ARBITER_output_S : component MUX_5x1_ARBITER_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_ARBITER_output_sel_in => MUX_5x1_ARBITER_output_select_S_out,
			XBAR_sel_out              => XBAR_sel_S,
			RTS_out                   => RTS_S,
			Grant_N_out               => Grant_SN,
			Grant_E_out               => Grant_SE,
			Grant_W_out               => Grant_SW,
			Grant_S_out               => Grant_SS,
			Grant_L_out               => Grant_SL,
			XBAR_sel_N                => XBAR_sel_N_temp,
			XBAR_sel_E                => XBAR_sel_E_temp,
			XBAR_sel_W                => XBAR_sel_W_temp,
			XBAR_sel_S                => XBAR_sel_S_temp,
			XBAR_sel_L                => XBAR_sel_L_temp,
			RTS_N                     => RTS_N_temp,
			RTS_E                     => RTS_E_temp,
			RTS_W                     => RTS_W_temp,
			RTS_S                     => RTS_S_temp,
			RTS_L                     => RTS_L_temp,
			Grant_NN                  => Grant_NN_temp,
			Grant_NE                  => Grant_NE_temp,
			Grant_NW                  => Grant_NW_temp,
			Grant_NS                  => Grant_NS_temp,
			Grant_NL                  => Grant_NL_temp,
			Grant_EN                  => Grant_EN_temp,
			Grant_EE                  => Grant_EE_temp,
			Grant_EW                  => Grant_EW_temp,
			Grant_ES                  => Grant_ES_temp,
			Grant_EL                  => Grant_EL_temp,
			Grant_WN                  => Grant_WN_temp,
			Grant_WE                  => Grant_WE_temp,
			Grant_WW                  => Grant_WW_temp,
			Grant_WS                  => Grant_WS_temp,
			Grant_WL                  => Grant_WL_temp,
			Grant_SN                  => Grant_SN_temp,
			Grant_SE                  => Grant_SE_temp,
			Grant_SW                  => Grant_SW_temp,
			Grant_SS                  => Grant_SS_temp,
			Grant_SL                  => Grant_SL_temp,
			Grant_LN                  => Grant_LN_temp,
			Grant_LE                  => Grant_LE_temp,
			Grant_LW                  => Grant_LW_temp,
			Grant_LS                  => Grant_LS_temp,
			Grant_LL                  => Grant_LL_temp);
	MUX_5x1_ARBITER_output_L : component MUX_5x1_ARBITER_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_ARBITER_output_sel_in => MUX_5x1_ARBITER_output_select_L_out,
			XBAR_sel_out              => XBAR_sel_L,
			RTS_out                   => RTS_L,
			Grant_N_out               => Grant_LN,
			Grant_E_out               => Grant_LE,
			Grant_W_out               => Grant_LW,
			Grant_S_out               => Grant_LS,
			Grant_L_out               => Grant_LL,
			XBAR_sel_N                => XBAR_sel_N_temp,
			XBAR_sel_E                => XBAR_sel_E_temp,
			XBAR_sel_W                => XBAR_sel_W_temp,
			XBAR_sel_S                => XBAR_sel_S_temp,
			XBAR_sel_L                => XBAR_sel_L_temp,
			RTS_N                     => RTS_N_temp,
			RTS_E                     => RTS_E_temp,
			RTS_W                     => RTS_W_temp,
			RTS_S                     => RTS_S_temp,
			RTS_L                     => RTS_L_temp,
			Grant_NN                  => Grant_NN_temp,
			Grant_NE                  => Grant_NE_temp,
			Grant_NW                  => Grant_NW_temp,
			Grant_NS                  => Grant_NS_temp,
			Grant_NL                  => Grant_NL_temp,
			Grant_EN                  => Grant_EN_temp,
			Grant_EE                  => Grant_EE_temp,
			Grant_EW                  => Grant_EW_temp,
			Grant_ES                  => Grant_ES_temp,
			Grant_EL                  => Grant_EL_temp,
			Grant_WN                  => Grant_WN_temp,
			Grant_WE                  => Grant_WE_temp,
			Grant_WW                  => Grant_WW_temp,
			Grant_WS                  => Grant_WS_temp,
			Grant_WL                  => Grant_WL_temp,
			Grant_SN                  => Grant_SN_temp,
			Grant_SE                  => Grant_SE_temp,
			Grant_SW                  => Grant_SW_temp,
			Grant_SS                  => Grant_SS_temp,
			Grant_SL                  => Grant_SL_temp,
			Grant_LN                  => Grant_LN_temp,
			Grant_LE                  => Grant_LE_temp,
			Grant_LW                  => Grant_LW_temp,
			Grant_LS                  => Grant_LS_temp,
			Grant_LL                  => Grant_LL_temp);
	MUX_5x1_LBDR_input_N : component MUX_5x1_LBDR_input
		generic map(cur_addr_rst => current_address,
			        Rxy_rst      => Rxy_rst,
			        Cx_rst       => Cx_rst,
			        NoC_size     => NoC_size)
		port map(
			MUX_LBDR_input_sel_in => MUX_5x1_LBDR_input_select_N_out,
			empty_out             => empty_N_valid,
			flit_type_out         => FIFO_D_out_N_valid(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			dst_addr_out          => FIFO_D_out_N_valid(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			empty_N               => empty_N,
			empty_E               => empty_E,
			empty_W               => empty_W,
			empty_S               => empty_S,
			empty_L               => empty_L,
			flit_type_N           => FIFO_D_out_N(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_E           => FIFO_D_out_E(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_W           => FIFO_D_out_W(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_S           => FIFO_D_out_S(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_L           => FIFO_D_out_L(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			dst_addr_N            => FIFO_D_out_N(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_E            => FIFO_D_out_E(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_W            => FIFO_D_out_W(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_S            => FIFO_D_out_S(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_L            => FIFO_D_out_L(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19));
	MUX_5x1_LBDR_input_E : component MUX_5x1_LBDR_input
		generic map(cur_addr_rst => current_address,
			        Rxy_rst      => Rxy_rst,
			        Cx_rst       => Cx_rst,
			        NoC_size     => NoC_size)
		port map(
			MUX_LBDR_input_sel_in => MUX_5x1_LBDR_input_select_E_out,
			empty_out             => empty_E_valid,
			flit_type_out         => FIFO_D_out_E_valid(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			dst_addr_out          => FIFO_D_out_E_valid(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			empty_N               => empty_N,
			empty_E               => empty_E,
			empty_W               => empty_W,
			empty_S               => empty_S,
			empty_L               => empty_L,
			flit_type_N           => FIFO_D_out_N(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_E           => FIFO_D_out_E(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_W           => FIFO_D_out_W(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_S           => FIFO_D_out_S(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_L           => FIFO_D_out_L(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			dst_addr_N            => FIFO_D_out_N(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_E            => FIFO_D_out_E(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_W            => FIFO_D_out_W(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_S            => FIFO_D_out_S(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_L            => FIFO_D_out_L(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19));
	MUX_5x1_LBDR_input_W : component MUX_5x1_LBDR_input
		generic map(cur_addr_rst => current_address,
			        Rxy_rst      => Rxy_rst,
			        Cx_rst       => Cx_rst,
			        NoC_size     => NoC_size)
		port map(
			MUX_LBDR_input_sel_in => MUX_5x1_LBDR_input_select_W_out,
			empty_out             => empty_W_valid,
			flit_type_out         => FIFO_D_out_W_valid(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			dst_addr_out          => FIFO_D_out_W_valid(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			empty_N               => empty_N,
			empty_E               => empty_E,
			empty_W               => empty_W,
			empty_S               => empty_S,
			empty_L               => empty_L,
			flit_type_N           => FIFO_D_out_N(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_E           => FIFO_D_out_E(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_W           => FIFO_D_out_W(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_S           => FIFO_D_out_S(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_L           => FIFO_D_out_L(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			dst_addr_N            => FIFO_D_out_N(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_E            => FIFO_D_out_E(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_W            => FIFO_D_out_W(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_S            => FIFO_D_out_S(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_L            => FIFO_D_out_L(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19));
	MUX_5x1_LBDR_input_S : component MUX_5x1_LBDR_input
		generic map(cur_addr_rst => current_address,
			        Rxy_rst      => Rxy_rst,
			        Cx_rst       => Cx_rst,
			        NoC_size     => NoC_size)
		port map(
			MUX_LBDR_input_sel_in => MUX_5x1_LBDR_input_select_S_out,
			empty_out             => empty_S_valid,
			flit_type_out         => FIFO_D_out_S_valid(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			dst_addr_out          => FIFO_D_out_S_valid(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			empty_N               => empty_N,
			empty_E               => empty_E,
			empty_W               => empty_W,
			empty_S               => empty_S,
			empty_L               => empty_L,
			flit_type_N           => FIFO_D_out_N(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_E           => FIFO_D_out_E(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_W           => FIFO_D_out_W(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_S           => FIFO_D_out_S(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_L           => FIFO_D_out_L(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			dst_addr_N            => FIFO_D_out_N(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_E            => FIFO_D_out_E(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_W            => FIFO_D_out_W(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_S            => FIFO_D_out_S(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_L            => FIFO_D_out_L(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19));
	MUX_5x1_LBDR_input_L : component MUX_5x1_LBDR_input
		generic map(cur_addr_rst => current_address,
			        Rxy_rst      => Rxy_rst,
			        Cx_rst       => Cx_rst,
			        NoC_size     => NoC_size)
		port map(
			MUX_LBDR_input_sel_in => MUX_5x1_LBDR_input_select_L_out,
			empty_out             => empty_L_valid,
			flit_type_out         => FIFO_D_out_L_valid(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			dst_addr_out          => FIFO_D_out_L_valid(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			empty_N               => empty_N,
			empty_E               => empty_E,
			empty_W               => empty_W,
			empty_S               => empty_S,
			empty_L               => empty_L,
			flit_type_N           => FIFO_D_out_N(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_E           => FIFO_D_out_E(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_W           => FIFO_D_out_W(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_S           => FIFO_D_out_S(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			flit_type_L           => FIFO_D_out_L(DATA_WIDTH - 1 downto DATA_WIDTH - 3),
			dst_addr_N            => FIFO_D_out_N(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_E            => FIFO_D_out_E(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_W            => FIFO_D_out_W(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_S            => FIFO_D_out_S(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19),
			dst_addr_L            => FIFO_D_out_L(DATA_WIDTH - 19 + NoC_size - 1 downto DATA_WIDTH - 19));
	MUX_5x1_LBDR_output_N : component MUX_5x1_LBDR_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_LBDR_output_sel_in => MUX_5x1_LBDR_output_select_N_out,
			Req_N_out              => Req_NN,
			Req_E_out              => Req_NE,
			Req_W_out              => Req_NW,
			Req_S_out              => Req_NS,
			Req_L_out              => Req_NL,
			Req_NN                 => Req_NN_temp,
			Req_NE                 => Req_NE_temp,
			Req_NW                 => Req_NW_temp,
			Req_NS                 => Req_NS_temp,
			Req_NL                 => Req_NL_temp,
			Req_EN                 => Req_EN_temp,
			Req_EE                 => Req_EE_temp,
			Req_EW                 => Req_EW_temp,
			Req_ES                 => Req_ES_temp,
			Req_EL                 => Req_EL_temp,
			Req_WN                 => Req_WN_temp,
			Req_WE                 => Req_WE_temp,
			Req_WW                 => Req_WW_temp,
			Req_WS                 => Req_WS_temp,
			Req_WL                 => Req_WL_temp,
			Req_SN                 => Req_SN_temp,
			Req_SE                 => Req_SE_temp,
			Req_SW                 => Req_SW_temp,
			Req_SS                 => Req_SS_temp,
			Req_SL                 => Req_SL_temp,
			Req_LN                 => Req_LN_temp,
			Req_LE                 => Req_LE_temp,
			Req_LW                 => Req_LW_temp,
			Req_LS                 => Req_LS_temp,
			Req_LL                 => Req_LL_temp);
	MUX_5x1_LBDR_output_E : component MUX_5x1_LBDR_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_LBDR_output_sel_in => MUX_5x1_LBDR_output_select_E_out,
			Req_N_out              => Req_EN,
			Req_E_out              => Req_EE,
			Req_W_out              => Req_EW,
			Req_S_out              => Req_ES,
			Req_L_out              => Req_EL,
			Req_NN                 => Req_NN_temp,
			Req_NE                 => Req_NE_temp,
			Req_NW                 => Req_NW_temp,
			Req_NS                 => Req_NS_temp,
			Req_NL                 => Req_NL_temp,
			Req_EN                 => Req_EN_temp,
			Req_EE                 => Req_EE_temp,
			Req_EW                 => Req_EW_temp,
			Req_ES                 => Req_ES_temp,
			Req_EL                 => Req_EL_temp,
			Req_WN                 => Req_WN_temp,
			Req_WE                 => Req_WE_temp,
			Req_WW                 => Req_WW_temp,
			Req_WS                 => Req_WS_temp,
			Req_WL                 => Req_WL_temp,
			Req_SN                 => Req_SN_temp,
			Req_SE                 => Req_SE_temp,
			Req_SW                 => Req_SW_temp,
			Req_SS                 => Req_SS_temp,
			Req_SL                 => Req_SL_temp,
			Req_LN                 => Req_LN_temp,
			Req_LE                 => Req_LE_temp,
			Req_LW                 => Req_LW_temp,
			Req_LS                 => Req_LS_temp,
			Req_LL                 => Req_LL_temp);
	MUX_5x1_LBDR_output_W : component MUX_5x1_LBDR_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_LBDR_output_sel_in => MUX_5x1_LBDR_output_select_W_out,
			Req_N_out              => Req_WN,
			Req_E_out              => Req_WE,
			Req_W_out              => Req_WW,
			Req_S_out              => Req_WS,
			Req_L_out              => Req_WL,
			Req_NN                 => Req_NN_temp,
			Req_NE                 => Req_NE_temp,
			Req_NW                 => Req_NW_temp,
			Req_NS                 => Req_NS_temp,
			Req_NL                 => Req_NL_temp,
			Req_EN                 => Req_EN_temp,
			Req_EE                 => Req_EE_temp,
			Req_EW                 => Req_EW_temp,
			Req_ES                 => Req_ES_temp,
			Req_EL                 => Req_EL_temp,
			Req_WN                 => Req_WN_temp,
			Req_WE                 => Req_WE_temp,
			Req_WW                 => Req_WW_temp,
			Req_WS                 => Req_WS_temp,
			Req_WL                 => Req_WL_temp,
			Req_SN                 => Req_SN_temp,
			Req_SE                 => Req_SE_temp,
			Req_SW                 => Req_SW_temp,
			Req_SS                 => Req_SS_temp,
			Req_SL                 => Req_SL_temp,
			Req_LN                 => Req_LN_temp,
			Req_LE                 => Req_LE_temp,
			Req_LW                 => Req_LW_temp,
			Req_LS                 => Req_LS_temp,
			Req_LL                 => Req_LL_temp);
	MUX_5x1_LBDR_output_S : component MUX_5x1_LBDR_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_LBDR_output_sel_in => MUX_5x1_LBDR_output_select_S_out,
			Req_N_out              => Req_SN,
			Req_E_out              => Req_SE,
			Req_W_out              => Req_SW,
			Req_S_out              => Req_SS,
			Req_L_out              => Req_SL,
			Req_NN                 => Req_NN_temp,
			Req_NE                 => Req_NE_temp,
			Req_NW                 => Req_NW_temp,
			Req_NS                 => Req_NS_temp,
			Req_NL                 => Req_NL_temp,
			Req_EN                 => Req_EN_temp,
			Req_EE                 => Req_EE_temp,
			Req_EW                 => Req_EW_temp,
			Req_ES                 => Req_ES_temp,
			Req_EL                 => Req_EL_temp,
			Req_WN                 => Req_WN_temp,
			Req_WE                 => Req_WE_temp,
			Req_WW                 => Req_WW_temp,
			Req_WS                 => Req_WS_temp,
			Req_WL                 => Req_WL_temp,
			Req_SN                 => Req_SN_temp,
			Req_SE                 => Req_SE_temp,
			Req_SW                 => Req_SW_temp,
			Req_SS                 => Req_SS_temp,
			Req_SL                 => Req_SL_temp,
			Req_LN                 => Req_LN_temp,
			Req_LE                 => Req_LE_temp,
			Req_LW                 => Req_LW_temp,
			Req_LS                 => Req_LS_temp,
			Req_LL                 => Req_LL_temp);
	MUX_5x1_LBDR_output_L : component MUX_5x1_LBDR_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_LBDR_output_sel_in => MUX_5x1_LBDR_output_select_L_out,
			Req_N_out              => Req_LN,
			Req_E_out              => Req_LE,
			Req_W_out              => Req_LW,
			Req_S_out              => Req_LS,
			Req_L_out              => Req_LL,
			Req_NN                 => Req_NN_temp,
			Req_NE                 => Req_NE_temp,
			Req_NW                 => Req_NW_temp,
			Req_NS                 => Req_NS_temp,
			Req_NL                 => Req_NL_temp,
			Req_EN                 => Req_EN_temp,
			Req_EE                 => Req_EE_temp,
			Req_EW                 => Req_EW_temp,
			Req_ES                 => Req_ES_temp,
			Req_EL                 => Req_EL_temp,
			Req_WN                 => Req_WN_temp,
			Req_WE                 => Req_WE_temp,
			Req_WW                 => Req_WW_temp,
			Req_WS                 => Req_WS_temp,
			Req_WL                 => Req_WL_temp,
			Req_SN                 => Req_SN_temp,
			Req_SE                 => Req_SE_temp,
			Req_SW                 => Req_SW_temp,
			Req_SS                 => Req_SS_temp,
			Req_SL                 => Req_SL_temp,
			Req_LN                 => Req_LN_temp,
			Req_LE                 => Req_LE_temp,
			Req_LW                 => Req_LW_temp,
			Req_LS                 => Req_LS_temp,
			Req_LL                 => Req_LL_temp);
	MUX_5x1_FIFO_input_N : component MUX_5x1_FIFO_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_FIFO_input_sel_in => MUX_5x1_FIFO_input_select_N_out,
			RX_out                => RX_N_valid,
			DRTS_out              => DRTS_N_valid,
			Grant_N_out           => Grant_NN_valid,
			Grant_E_out           => Grant_EN_valid,
			Grant_W_out           => Grant_WN_valid,
			Grant_S_out           => Grant_SN_valid,
			Grant_L_out           => Grant_LN_valid,
			RX_N                  => RX_N,
			RX_E                  => RX_E,
			RX_W                  => RX_W,
			RX_S                  => RX_S,
			RX_L                  => RX_L,
			DRTS_N                => DRTS_N,
			DRTS_E                => DRTS_E,
			DRTS_W                => DRTS_W,
			DRTS_S                => DRTS_S,
			DRTS_L                => DRTS_L,
			Grant_NN              => Grant_NN,
			Grant_EN              => Grant_EN,
			Grant_WN              => Grant_WN,
			Grant_SN              => Grant_SN,
			Grant_LN              => Grant_LN,
			Grant_NE              => Grant_NE,
			Grant_EE              => Grant_EE,
			Grant_WE              => Grant_WE,
			Grant_SE              => Grant_SE,
			Grant_LE              => Grant_LE,
			Grant_NW              => Grant_NW,
			Grant_EW              => Grant_EW,
			Grant_WW              => Grant_WW,
			Grant_SW              => Grant_SW,
			Grant_LW              => Grant_LW,
			Grant_NS              => Grant_NS,
			Grant_ES              => Grant_ES,
			Grant_WS              => Grant_WS,
			Grant_SS              => Grant_SS,
			Grant_LS              => Grant_LS,
			Grant_NL              => Grant_NL,
			Grant_EL              => Grant_EL,
			Grant_WL              => Grant_WL,
			Grant_SL              => Grant_SL,
			Grant_LL              => Grant_LL);
	MUX_5x1_FIFO_input_E : component MUX_5x1_FIFO_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_FIFO_input_sel_in => MUX_5x1_FIFO_input_select_E_out,
			RX_out                => RX_E_valid,
			DRTS_out              => DRTS_E_valid,
			Grant_N_out           => Grant_NE_valid,
			Grant_E_out           => Grant_EE_valid,
			Grant_W_out           => Grant_WE_valid,
			Grant_S_out           => Grant_SE_valid,
			Grant_L_out           => Grant_LE_valid,
			RX_N                  => RX_N,
			RX_E                  => RX_E,
			RX_W                  => RX_W,
			RX_S                  => RX_S,
			RX_L                  => RX_L,
			DRTS_N                => DRTS_N,
			DRTS_E                => DRTS_E,
			DRTS_W                => DRTS_W,
			DRTS_S                => DRTS_S,
			DRTS_L                => DRTS_L,
			Grant_NN              => Grant_NN,
			Grant_EN              => Grant_EN,
			Grant_WN              => Grant_WN,
			Grant_SN              => Grant_SN,
			Grant_LN              => Grant_LN,
			Grant_NE              => Grant_NE,
			Grant_EE              => Grant_EE,
			Grant_WE              => Grant_WE,
			Grant_SE              => Grant_SE,
			Grant_LE              => Grant_LE,
			Grant_NW              => Grant_NW,
			Grant_EW              => Grant_EW,
			Grant_WW              => Grant_WW,
			Grant_SW              => Grant_SW,
			Grant_LW              => Grant_LW,
			Grant_NS              => Grant_NS,
			Grant_ES              => Grant_ES,
			Grant_WS              => Grant_WS,
			Grant_SS              => Grant_SS,
			Grant_LS              => Grant_LS,
			Grant_NL              => Grant_NL,
			Grant_EL              => Grant_EL,
			Grant_WL              => Grant_WL,
			Grant_SL              => Grant_SL,
			Grant_LL              => Grant_LL);
	MUX_5x1_FIFO_input_W : component MUX_5x1_FIFO_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_FIFO_input_sel_in => MUX_5x1_FIFO_input_select_W_out,
			RX_out                => RX_W_valid,
			DRTS_out              => DRTS_W_valid,
			Grant_N_out           => Grant_NW_valid,
			Grant_E_out           => Grant_EW_valid,
			Grant_W_out           => Grant_WW_valid,
			Grant_S_out           => Grant_SW_valid,
			Grant_L_out           => Grant_LW_valid,
			RX_N                  => RX_N,
			RX_E                  => RX_E,
			RX_W                  => RX_W,
			RX_S                  => RX_S,
			RX_L                  => RX_L,
			DRTS_N                => DRTS_N,
			DRTS_E                => DRTS_E,
			DRTS_W                => DRTS_W,
			DRTS_S                => DRTS_S,
			DRTS_L                => DRTS_L,
			Grant_NN              => Grant_NN,
			Grant_EN              => Grant_EN,
			Grant_WN              => Grant_WN,
			Grant_SN              => Grant_SN,
			Grant_LN              => Grant_LN,
			Grant_NE              => Grant_NE,
			Grant_EE              => Grant_EE,
			Grant_WE              => Grant_WE,
			Grant_SE              => Grant_SE,
			Grant_LE              => Grant_LE,
			Grant_NW              => Grant_NW,
			Grant_EW              => Grant_EW,
			Grant_WW              => Grant_WW,
			Grant_SW              => Grant_SW,
			Grant_LW              => Grant_LW,
			Grant_NS              => Grant_NS,
			Grant_ES              => Grant_ES,
			Grant_WS              => Grant_WS,
			Grant_SS              => Grant_SS,
			Grant_LS              => Grant_LS,
			Grant_NL              => Grant_NL,
			Grant_EL              => Grant_EL,
			Grant_WL              => Grant_WL,
			Grant_SL              => Grant_SL,
			Grant_LL              => Grant_LL);
	MUX_5x1_FIFO_input_S : component MUX_5x1_FIFO_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_FIFO_input_sel_in => MUX_5x1_FIFO_input_select_S_out,
			RX_out                => RX_S_valid,
			DRTS_out              => DRTS_S_valid,
			Grant_N_out           => Grant_NS_valid,
			Grant_E_out           => Grant_ES_valid,
			Grant_W_out           => Grant_WS_valid,
			Grant_S_out           => Grant_SS_valid,
			Grant_L_out           => Grant_LS_valid,
			RX_N                  => RX_N,
			RX_E                  => RX_E,
			RX_W                  => RX_W,
			RX_S                  => RX_S,
			RX_L                  => RX_L,
			DRTS_N                => DRTS_N,
			DRTS_E                => DRTS_E,
			DRTS_W                => DRTS_W,
			DRTS_S                => DRTS_S,
			DRTS_L                => DRTS_L,
			Grant_NN              => Grant_NN,
			Grant_EN              => Grant_EN,
			Grant_WN              => Grant_WN,
			Grant_SN              => Grant_SN,
			Grant_LN              => Grant_LN,
			Grant_NE              => Grant_NE,
			Grant_EE              => Grant_EE,
			Grant_WE              => Grant_WE,
			Grant_SE              => Grant_SE,
			Grant_LE              => Grant_LE,
			Grant_NW              => Grant_NW,
			Grant_EW              => Grant_EW,
			Grant_WW              => Grant_WW,
			Grant_SW              => Grant_SW,
			Grant_LW              => Grant_LW,
			Grant_NS              => Grant_NS,
			Grant_ES              => Grant_ES,
			Grant_WS              => Grant_WS,
			Grant_SS              => Grant_SS,
			Grant_LS              => Grant_LS,
			Grant_NL              => Grant_NL,
			Grant_EL              => Grant_EL,
			Grant_WL              => Grant_WL,
			Grant_SL              => Grant_SL,
			Grant_LL              => Grant_LL);
	MUX_5x1_FIFO_input_L : component MUX_5x1_FIFO_input
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_FIFO_input_sel_in => MUX_5x1_FIFO_input_select_L_out,
			RX_out                => RX_L_valid,
			DRTS_out              => DRTS_L_valid,
			Grant_N_out           => Grant_NL_valid,
			Grant_E_out           => Grant_EL_valid,
			Grant_W_out           => Grant_WL_valid,
			Grant_S_out           => Grant_SL_valid,
			Grant_L_out           => Grant_LL_valid,
			RX_N                  => RX_N,
			RX_E                  => RX_E,
			RX_W                  => RX_W,
			RX_S                  => RX_S,
			RX_L                  => RX_L,
			DRTS_N                => DRTS_N,
			DRTS_E                => DRTS_E,
			DRTS_W                => DRTS_W,
			DRTS_S                => DRTS_S,
			DRTS_L                => DRTS_L,
			Grant_NN              => Grant_NN,
			Grant_EN              => Grant_EN,
			Grant_WN              => Grant_WN,
			Grant_SN              => Grant_SN,
			Grant_LN              => Grant_LN,
			Grant_NE              => Grant_NE,
			Grant_EE              => Grant_EE,
			Grant_WE              => Grant_WE,
			Grant_SE              => Grant_SE,
			Grant_LE              => Grant_LE,
			Grant_NW              => Grant_NW,
			Grant_EW              => Grant_EW,
			Grant_WW              => Grant_WW,
			Grant_SW              => Grant_SW,
			Grant_LW              => Grant_LW,
			Grant_NS              => Grant_NS,
			Grant_ES              => Grant_ES,
			Grant_WS              => Grant_WS,
			Grant_SS              => Grant_SS,
			Grant_LS              => Grant_LS,
			Grant_NL              => Grant_NL,
			Grant_EL              => Grant_EL,
			Grant_WL              => Grant_WL,
			Grant_SL              => Grant_SL,
			Grant_LL              => Grant_LL);
	MUX_5x1_FIFO_output_N : component MUX_5x1_FIFO_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_FIFO_output_sel_in => MUX_5x1_FIFO_output_select_N_out,
			CTS_out                => CTS_N,
			empty_out              => empty_N,
			FIFO_D_out_out         => FIFO_D_out_N,
			CTS_N                  => CTS_N_temp,
			CTS_E                  => CTS_E_temp,
			CTS_W                  => CTS_W_temp,
			CTS_S                  => CTS_S_temp,
			CTS_L                  => CTS_L_temp,
			empty_N                => empty_N_temp,
			empty_E                => empty_E_temp,
			empty_W                => empty_W_temp,
			empty_S                => empty_S_temp,
			empty_L                => empty_L_temp,
			FIFO_D_out_N           => FIFO_D_out_N_temp,
			FIFO_D_out_E           => FIFO_D_out_E_temp,
			FIFO_D_out_W           => FIFO_D_out_W_temp,
			FIFO_D_out_S           => FIFO_D_out_S_temp,
			FIFO_D_out_L           => FIFO_D_out_L_temp);
	MUX_5x1_FIFO_output_E : component MUX_5x1_FIFO_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_FIFO_output_sel_in => MUX_5x1_FIFO_output_select_E_out,
			CTS_out                => CTS_E,
			empty_out              => empty_E,
			FIFO_D_out_out         => FIFO_D_out_E,
			CTS_N                  => CTS_N_temp,
			CTS_E                  => CTS_E_temp,
			CTS_W                  => CTS_W_temp,
			CTS_S                  => CTS_S_temp,
			CTS_L                  => CTS_L_temp,
			empty_N                => empty_N_temp,
			empty_E                => empty_E_temp,
			empty_W                => empty_W_temp,
			empty_S                => empty_S_temp,
			empty_L                => empty_L_temp,
			FIFO_D_out_N           => FIFO_D_out_N_temp,
			FIFO_D_out_E           => FIFO_D_out_E_temp,
			FIFO_D_out_W           => FIFO_D_out_W_temp,
			FIFO_D_out_S           => FIFO_D_out_S_temp,
			FIFO_D_out_L           => FIFO_D_out_L_temp);
	MUX_5x1_FIFO_output_W : component MUX_5x1_FIFO_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_FIFO_output_sel_in => MUX_5x1_FIFO_output_select_W_out,
			CTS_out                => CTS_W,
			empty_out              => empty_W,
			FIFO_D_out_out         => FIFO_D_out_W,
			CTS_N                  => CTS_N_temp,
			CTS_E                  => CTS_E_temp,
			CTS_W                  => CTS_W_temp,
			CTS_S                  => CTS_S_temp,
			CTS_L                  => CTS_L_temp,
			empty_N                => empty_N_temp,
			empty_E                => empty_E_temp,
			empty_W                => empty_W_temp,
			empty_S                => empty_S_temp,
			empty_L                => empty_L_temp,
			FIFO_D_out_N           => FIFO_D_out_N_temp,
			FIFO_D_out_E           => FIFO_D_out_E_temp,
			FIFO_D_out_W           => FIFO_D_out_W_temp,
			FIFO_D_out_S           => FIFO_D_out_S_temp,
			FIFO_D_out_L           => FIFO_D_out_L_temp);
	MUX_5x1_FIFO_output_S : component MUX_5x1_FIFO_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_FIFO_output_sel_in => MUX_5x1_FIFO_output_select_S_out,
			CTS_out                => CTS_S,
			empty_out              => empty_S,
			FIFO_D_out_out         => FIFO_D_out_S,
			CTS_N                  => CTS_N_temp,
			CTS_E                  => CTS_E_temp,
			CTS_W                  => CTS_W_temp,
			CTS_S                  => CTS_S_temp,
			CTS_L                  => CTS_L_temp,
			empty_N                => empty_N_temp,
			empty_E                => empty_E_temp,
			empty_W                => empty_W_temp,
			empty_S                => empty_S_temp,
			empty_L                => empty_L_temp,
			FIFO_D_out_N           => FIFO_D_out_N_temp,
			FIFO_D_out_E           => FIFO_D_out_E_temp,
			FIFO_D_out_W           => FIFO_D_out_W_temp,
			FIFO_D_out_S           => FIFO_D_out_S_temp,
			FIFO_D_out_L           => FIFO_D_out_L_temp);
	MUX_5x1_FIFO_output_L : component MUX_5x1_FIFO_output
		generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			MUX_FIFO_output_sel_in => MUX_5x1_FIFO_output_select_L_out,
			CTS_out                => CTS_L,
			empty_out              => empty_L,
			FIFO_D_out_out         => FIFO_D_out_L,
			CTS_N                  => CTS_N_temp,
			CTS_E                  => CTS_E_temp,
			CTS_W                  => CTS_W_temp,
			CTS_S                  => CTS_S_temp,
			CTS_L                  => CTS_L_temp,
			empty_N                => empty_N_temp,
			empty_E                => empty_E_temp,
			empty_W                => empty_W_temp,
			empty_S                => empty_S_temp,
			empty_L                => empty_L_temp,
			FIFO_D_out_N           => FIFO_D_out_N_temp,
			FIFO_D_out_E           => FIFO_D_out_E_temp,
			FIFO_D_out_W           => FIFO_D_out_W_temp,
			FIFO_D_out_S           => FIFO_D_out_S_temp,
			FIFO_D_out_L           => FIFO_D_out_L_temp);
end;
