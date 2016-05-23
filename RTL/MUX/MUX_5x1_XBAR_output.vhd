library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_5x1_XBAR_output is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        MUX_XBAR_output_sel_in : in  std_logic_vector(2 downto 0);
        TX_out                 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        TX_N                   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        TX_E                   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        TX_W                   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        TX_S                   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        TX_L                   : in  std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity MUX_5x1_XBAR_output;

architecture RTL of MUX_5x1_XBAR_output is
begin
    mux : process(MUX_XBAR_output_sel_in, TX_N, TX_E, TX_W, TX_S, TX_L) is
    begin
        case MUX_XBAR_output_sel_in is
            when "000" => TX_out <= TX_N;
            when "001" => TX_out <= TX_E;
            when "010" => TX_out <= TX_W;
            when "011" => TX_out <= TX_S;
            when "100" => TX_out <= TX_L;
            when others => TX_out <= (others => '0');
        end case;
    end process mux;

end architecture RTL;
