library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_5x1_XBAR_input is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(MUX_XBAR_input_sel_in : in  std_logic_vector(2 downto 0);
         Xbar_sel_out          : out std_logic_vector(4 downto 0);
         Xbar_sel_N            : in  std_logic_vector(4 downto 0);
         Xbar_sel_E            : in  std_logic_vector(4 downto 0);
         Xbar_sel_W            : in  std_logic_vector(4 downto 0);
         Xbar_sel_S            : in  std_logic_vector(4 downto 0);
         Xbar_sel_L            : in  std_logic_vector(4 downto 0));
end entity MUX_5x1_XBAR_input;

architecture RTL of MUX_5x1_XBAR_input is
begin
    mux : process(MUX_XBAR_input_sel_in, Xbar_sel_E, Xbar_sel_L, Xbar_sel_N, Xbar_sel_S, Xbar_sel_W) is
    begin
        case MUX_XBAR_input_sel_in is
            when "000" => Xbar_sel_out <= Xbar_sel_N;
            when "001" => Xbar_sel_out <= Xbar_sel_E;
            when "010" => Xbar_sel_out <= Xbar_sel_W;
            when "011" => Xbar_sel_out <= Xbar_sel_S;
            when "100" => Xbar_sel_out <= Xbar_sel_L;
            when others => Xbar_sel_out <= (others => 'Z');
        end case;
    end process mux;
end architecture RTL;
