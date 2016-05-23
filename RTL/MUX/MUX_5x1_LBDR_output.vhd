library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_5x1_LBDR_output is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        MUX_LBDR_output_sel_in                                : in  std_logic_vector(2 downto 0);
        Req_N_out, Req_E_out, Req_W_out, Req_S_out, Req_L_out : out std_logic;
        Req_NN, Req_NE, Req_NW, Req_NS, Req_NL                : in  std_logic;
        Req_EN, Req_EE, Req_EW, Req_ES, Req_EL                : in  std_logic;
        Req_WN, Req_WE, Req_WW, Req_WS, Req_WL                : in  std_logic;
        Req_SN, Req_SE, Req_SW, Req_SS, Req_SL                : in  std_logic;
        Req_LN, Req_LE, Req_LW, Req_LS, Req_LL                : in  std_logic
    );
end entity MUX_5x1_LBDR_output;

architecture RTL of MUX_5x1_LBDR_output is
begin
    mux : process (MUX_LBDR_output_sel_in, Req_EE, Req_EL, Req_EN, Req_ES, Req_EW, Req_LE, Req_LL, Req_LN, Req_LS, Req_LW, Req_NE, Req_NL, Req_NN, Req_NS, Req_NW, Req_SE, Req_SL, Req_SN, Req_SS, Req_SW, Req_WE, Req_WL, Req_WN, Req_WS, Req_WW) is
    begin
        case MUX_LBDR_output_sel_in is
            when "000" =>
                Req_N_out <= Req_NN;
                Req_E_out <= Req_NE;
                Req_W_out <= Req_NW;
                Req_S_out <= Req_NS;
                Req_L_out <= Req_NL;
            when "001" =>
                Req_N_out <= Req_EN;
                Req_E_out <= Req_EE;
                Req_W_out <= Req_EW;
                Req_S_out <= Req_ES;
                Req_L_out <= Req_EL;
            when "010" =>
                Req_N_out <= Req_WN;
                Req_E_out <= Req_WE;
                Req_W_out <= Req_WW;
                Req_S_out <= Req_WS;
                Req_L_out <= Req_WL;
            when "011" =>
                Req_N_out <= Req_SN;
                Req_E_out <= Req_SE;
                Req_W_out <= Req_SW;
                Req_S_out <= Req_SS;
                Req_L_out <= Req_SL;
            when "100" =>
                Req_N_out <= Req_LN;
                Req_E_out <= Req_LE;
                Req_W_out <= Req_LW;
                Req_S_out <= Req_LS;
                Req_L_out <= Req_LL;
            when others =>
                Req_N_out <= '0';
                Req_E_out <= '0';
                Req_W_out <= '0';
                Req_S_out <= '0';
                Req_L_out <= '0';
        end case;
    end process mux;

end architecture RTL;
