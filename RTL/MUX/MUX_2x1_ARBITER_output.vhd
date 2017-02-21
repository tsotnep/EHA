library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_2x1_Arbiter_output is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(MUX_Arbiter_output_sel_in                                       : in  std_logic_vector(2 downto 0);

         Xbar_sel_out                                                    : out std_logic_vector(4 downto 0);
         RTS_out                                                         : out std_logic;
         Grant_N_out, Grant_E_out, Grant_W_out, Grant_S_out, Grant_L_out : out std_logic;

         Xbar_sel_N, Xbar_sel_R                                          : in  std_logic_vector(4 downto 0);
         RTS_N, RTS_R                                                    : in  std_logic;
         Grant_NN, Grant_NE, Grant_NW, Grant_NS, Grant_NL                : in  std_logic;
         Grant_RN, Grant_RE, Grant_RW, Grant_RS, Grant_RL                : in  std_logic);
end entity MUX_2x1_Arbiter_output;

architecture RTL of MUX_2x1_Arbiter_output is
begin
    mux : process(Grant_NE, Grant_NL, Grant_NN, Grant_NS, Grant_NW, Grant_RE, Grant_RL, Grant_RN, Grant_RS, Grant_RW, MUX_Arbiter_output_sel_in, RTS_N, RTS_R, Xbar_sel_N, Xbar_sel_R)
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
            when "101" =>
                Xbar_sel_out <= Xbar_sel_R;
                RTS_out      <= RTS_R;
                Grant_N_out  <= Grant_RN;
                Grant_E_out  <= Grant_RE;
                Grant_W_out  <= Grant_RW;
                Grant_S_out  <= Grant_RS;
                Grant_L_out  <= Grant_RL;
            when others =>
                Xbar_sel_out <= (others => '0');
                RTS_out      <= '0';
                Grant_N_out  <= '0';
                Grant_E_out  <= '0';
                Grant_W_out  <= '0';
                Grant_S_out  <= '0';
                Grant_L_out  <= '0';
        end case;
    end process mux;
end architecture RTL;
