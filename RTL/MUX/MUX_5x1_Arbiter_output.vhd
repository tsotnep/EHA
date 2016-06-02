library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_5x1_Arbiter_output is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(MUX_Arbiter_output_sel_in                                              : in  std_logic_vector(2 downto 0);

         Xbar_sel_out                                                           : out std_logic_vector(4 downto 0);
         RTS_out                                                                : out std_logic;
         Grant_N_out, Grant_E_out, Grant_W_out, Grant_S_out, Grant_L_out        : out std_logic;

         Xbar_sel_N, Xbar_sel_E, Xbar_sel_W, Xbar_sel_S, Xbar_sel_L  : in  std_logic_vector(4 downto 0);
         RTS_N, RTS_E, RTS_W, RTS_S, RTS_L                                : in  std_logic;
         Grant_NN, Grant_NE, Grant_NW, Grant_NS, Grant_NL                       : in  std_logic;
         Grant_EN, Grant_EE, Grant_EW, Grant_ES, Grant_EL                       : in  std_logic;
         Grant_WN, Grant_WE, Grant_WW, Grant_WS, Grant_WL                       : in  std_logic;
         Grant_SN, Grant_SE, Grant_SW, Grant_SS, Grant_SL                       : in  std_logic;
         Grant_LN, Grant_LE, Grant_LW, Grant_LS, Grant_LL                       : in  std_logic);
end entity MUX_5x1_Arbiter_output;

architecture RTL of MUX_5x1_Arbiter_output is
begin
    mux : process (Grant_EE, Grant_EL, Grant_EN, Grant_ES, Grant_EW, Grant_LE, Grant_LL, Grant_LN, Grant_LS, Grant_LW, Grant_NE, Grant_NL, Grant_NN, Grant_NS, Grant_NW,  Grant_SE, Grant_SL, Grant_SN, Grant_SS, Grant_SW, Grant_WE, Grant_WL, Grant_WN, Grant_WS, Grant_WW, MUX_Arbiter_output_sel_in, RTS_E, RTS_L, RTS_N, RTS_S, RTS_W, Xbar_sel_E, Xbar_sel_L, Xbar_sel_N, Xbar_sel_S, Xbar_sel_W)
    begin
        case MUX_Arbiter_output_sel_in is
            when "000" =>
                Xbar_sel_out <= Xbar_sel_N;
                RTS_out      <= RTS_N;
                Grant_N_out  <= Grant_NN;
                Grant_E_out  <= Grant_NE;
                Grant_W_out  <= Grant_NW;
                Grant_S_out  <= Grant_NS;
                Grant_L_out  <= Grant_NL;
            when "001" =>
                Xbar_sel_out <= Xbar_sel_E;
                RTS_out      <= RTS_E;
                Grant_N_out  <= Grant_EN;
                Grant_E_out  <= Grant_EE;
                Grant_W_out  <= Grant_EW;
                Grant_S_out  <= Grant_ES;
                Grant_L_out  <= Grant_EL;
            when "010" =>
                Xbar_sel_out <= Xbar_sel_W;
                RTS_out      <= RTS_W;
                Grant_N_out  <= Grant_WN;
                Grant_E_out  <= Grant_WE;
                Grant_W_out  <= Grant_WW;
                Grant_S_out  <= Grant_WS;
                Grant_L_out  <= Grant_WL;
            when "011" =>
                Xbar_sel_out <= Xbar_sel_S;
                RTS_out      <= RTS_S;
                Grant_N_out  <= Grant_SN;
                Grant_E_out  <= Grant_SE;
                Grant_W_out  <= Grant_SW;
                Grant_S_out  <= Grant_SS;
                Grant_L_out  <= Grant_SL;
            when "100" =>
                Xbar_sel_out <= Xbar_sel_L;
                RTS_out      <= RTS_L;
                Grant_N_out  <= Grant_LN;
                Grant_E_out  <= Grant_LE;
                Grant_W_out  <= Grant_LW;
                Grant_S_out  <= Grant_LS;
                Grant_L_out  <= Grant_LL;
            when others =>
                Xbar_sel_out <= (others => '0');
                RTS_out     <= '0';
                Grant_N_out <= '0';
                Grant_E_out <= '0';
                Grant_W_out <= '0';
                Grant_S_out <= '0';
                Grant_L_out <= '0';
        end case;
    end process mux;
end architecture RTL;
