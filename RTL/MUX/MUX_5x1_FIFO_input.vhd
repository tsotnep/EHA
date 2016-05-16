library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_5x1_FIFO_input is
    generic(
        DATA_WIDTH : integer
    );
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
         Grant_NL, Grant_EL, Grant_WL, Grant_SL, Grant_LL                : in  std_logic
    );
end entity MUX_5x1_FIFO_input;
architecture RTL of MUX_5x1_FIFO_input is
begin
    mux : process(DRTS_E, DRTS_L, DRTS_N, DRTS_S, DRTS_W, Grant_EL, Grant_EN, Grant_ES, Grant_EW, Grant_LE, Grant_LN, Grant_LS, Grant_LW, Grant_NE, Grant_NL, Grant_NS, Grant_NW, Grant_SE, Grant_SL, Grant_SN, Grant_SW, Grant_WE, Grant_WL, Grant_WN, Grant_WS, MUX_FIFO_input_sel_in, RX_E, RX_L, RX_N, RX_S, RX_W)
    begin
        case MUX_FIFO_input_sel_in is
            when "000" =>
                RX_out      <= RX_N;
                DRTS_out    <= DRTS_N;
                Grant_N_out <= '0';
                Grant_E_out <= Grant_EN;
                Grant_W_out <= Grant_WN;
                Grant_S_out <= Grant_SN;
                Grant_L_out <= Grant_LN;
            when "001" =>
                RX_out      <= RX_E;
                DRTS_out    <= DRTS_E;
                Grant_N_out <= Grant_NE;
                Grant_E_out <= '0';
                Grant_W_out <= Grant_WE;
                Grant_S_out <= Grant_SE;
                Grant_L_out <= Grant_LE;
            when "010" =>
                RX_out      <= RX_W;
                DRTS_out    <= DRTS_W;
                Grant_N_out <= Grant_NW;
                Grant_E_out <= Grant_EW;
                Grant_W_out <= '0';
                Grant_S_out <= Grant_SW;
                Grant_L_out <= Grant_LW;
            when "011" =>
                RX_out      <= RX_S;
                DRTS_out    <= DRTS_S;
                Grant_N_out <= Grant_NS;
                Grant_E_out <= Grant_ES;
                Grant_W_out <= Grant_WS;
                Grant_S_out <= '0';
                Grant_L_out <= Grant_LS;
            when "100" =>
                RX_out      <= RX_L;
                DRTS_out    <= DRTS_L;
                Grant_N_out <= Grant_NL;
                Grant_E_out <= Grant_EL;
                Grant_W_out <= Grant_WL;
                Grant_S_out <= Grant_SL;
                Grant_L_out <= '0';
            when others =>
                RX_out      <= (others => '0');
                DRTS_out    <= '0';
                Grant_N_out <= '0';
                Grant_E_out <= '0';
                Grant_W_out <= '0';
                Grant_S_out <= '0';
                Grant_L_out <= '0';
        end case;
    end process mux;
end architecture RTL;
