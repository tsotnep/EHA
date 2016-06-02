library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_2x1_LBDR_output is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        MUX_LBDR_output_sel_in                                : in  std_logic_vector(2 downto 0);
        Req_N_out, Req_E_out, Req_W_out, Req_S_out, Req_L_out : out std_logic;
        Req_NN, Req_NE, Req_NW, Req_NS, Req_NL                : in  std_logic;
        Req_RN, Req_RE, Req_RW, Req_RS, Req_RL                : in  std_logic
    );
end entity MUX_2x1_LBDR_output;

architecture RTL of MUX_2x1_LBDR_output is
begin
    mux : process(MUX_LBDR_output_sel_in, Req_NE, Req_NL, Req_NN, Req_NS, Req_NW, Req_RE, Req_RL, Req_RN, Req_RS, Req_RW)
    begin
        case MUX_LBDR_output_sel_in is
            when "000" =>
                Req_N_out <= Req_NN;
                Req_E_out <= Req_NE;
                Req_W_out <= Req_NW;
                Req_S_out <= Req_NS;
                Req_L_out <= Req_NL;
            when "101" =>
                Req_N_out <= Req_RN;
                Req_E_out <= Req_RE;
                Req_W_out <= Req_RW;
                Req_S_out <= Req_RS;
                Req_L_out <= Req_RL;
            when others =>
                Req_N_out <= '0';
                Req_E_out <= '0';
                Req_W_out <= '0';
                Req_S_out <= '0';
                Req_L_out <= '0';
        end case;
    end process mux;

end architecture RTL;
