library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_2x1_XBAR_output is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        MUX_XBAR_output_sel_in : in  std_logic_vector(2 downto 0);
        TX_out                 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        TX_N                   : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        TX_R                   : in  std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end entity MUX_2x1_XBAR_output;

architecture RTL of MUX_2x1_XBAR_output is
begin
    mux : process(MUX_XBAR_output_sel_in, TX_R, TX_N) is
    begin
        case MUX_XBAR_output_sel_in is
            when "000"  => TX_out <= TX_N;
            when "101"  => TX_out <= TX_R;
            when others => TX_out <= (others => '0');
        end case;
    end process mux;

end architecture RTL;
