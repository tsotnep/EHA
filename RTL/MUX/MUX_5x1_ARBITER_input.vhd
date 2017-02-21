library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_5x1_Arbiter_input is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(MUX_Arbiter_input_sel_in                                        : in  std_logic_vector(2 downto 0);
         Req_N_out, Req_E_out, Req_W_out, Req_S_out, Req_L_out, DCTS_out : out std_logic;
         DCTS_N, DCTS_E, DCTS_W, DCTS_S, DCTS_L                          : in  std_logic;
         Req_NN, Req_NE, Req_NW, Req_NS, Req_NL                          : in  std_logic;
         Req_EN, Req_EE, Req_EW, Req_ES, Req_EL                          : in  std_logic;
         Req_WN, Req_WE, Req_WW, Req_WS, Req_WL                          : in  std_logic;
         Req_SN, Req_SE, Req_SW, Req_SS, Req_SL                          : in  std_logic;
         Req_LN, Req_LE, Req_LW, Req_LS, Req_LL                          : in  std_logic);
end entity MUX_5x1_Arbiter_input;

architecture RTL of MUX_5x1_Arbiter_input is
begin
    mux : process(DCTS_E, DCTS_L, DCTS_N, DCTS_S, DCTS_W, MUX_Arbiter_input_sel_in, Req_EL, Req_EN, Req_ES, Req_EW, Req_LE, Req_LN, Req_LS, Req_LW, Req_NE, Req_NL, Req_NS, Req_NW, Req_SE, Req_SL, Req_SN, Req_SW, Req_WE, Req_WL, Req_WN, Req_WS)
    begin
        case MUX_Arbiter_input_sel_in is
            when "000" =>
                Req_N_out <= '0';
                Req_E_out <= Req_EN;
                Req_W_out <= Req_WN;
                Req_S_out <= Req_SN;
                Req_L_out <= Req_LN;
                DCTS_out  <= DCTS_N;
            when "001" =>
                Req_N_out <= Req_NE;
                Req_E_out <= '0';
                Req_W_out <= Req_WE;
                Req_S_out <= Req_SE;
                Req_L_out <= Req_LE;
                DCTS_out  <= DCTS_E;
            when "010" =>
                Req_N_out <= Req_NW;
                Req_E_out <= Req_EW;
                Req_W_out <= '0';
                Req_S_out <= Req_SW;
                Req_L_out <= Req_LW;
                DCTS_out  <= DCTS_W;
            when "011" =>
                Req_N_out <= Req_NS;
                Req_E_out <= Req_ES;
                Req_W_out <= Req_WS;
                Req_S_out <= '0';
                Req_L_out <= Req_LS;
                DCTS_out  <= DCTS_S;
            when "100" =>
                Req_N_out <= Req_NL;
                Req_E_out <= Req_EL;
                Req_W_out <= Req_WL;
                Req_S_out <= Req_SL;
                Req_L_out <= '0';
                DCTS_out  <= DCTS_L;
            when others =>
                Req_N_out <= '0';
                Req_E_out <= '0';
                Req_W_out <= '0';
                Req_S_out <= '0';
                Req_L_out <= '0';
                DCTS_out  <= '0';
        end case;
    end process mux;
end architecture RTL;
