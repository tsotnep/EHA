library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_2x1_FIFO_output is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        MUX_FIFO_output_sel_in     : in  std_logic_vector(2 downto 0);

        CTS_out                    : out std_logic;
        empty_out                  : out std_logic;
        FIFO_D_out_out             : out std_logic_vector(DATA_WIDTH - 1 downto 0);

        CTS_N, CTS_R               : in  std_logic;
        empty_N, empty_R           : in  std_logic;
        FIFO_D_out_N, FIFO_D_out_R : in  std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end entity MUX_2x1_FIFO_output;

architecture RTL of MUX_2x1_FIFO_output is
begin
    mux : process(CTS_N, CTS_R, FIFO_D_out_N, FIFO_D_out_R, MUX_FIFO_output_sel_in, empty_N, empty_R)
    begin
        case MUX_FIFO_output_sel_in is
            when "000" =>
                CTS_out        <= CTS_N;
                empty_out      <= empty_N;
                FIFO_D_out_out <= FIFO_D_out_N;
            when "101" =>
                CTS_out        <= CTS_R;
                empty_out      <= empty_R;
                FIFO_D_out_out <= FIFO_D_out_R;
            when others =>
                CTS_out        <= '0';
                empty_out      <= '0';
                FIFO_D_out_out <= (others => '0');

        end case;
    end process mux;

end architecture RTL;
