library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_5x1_FIFO_output is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        MUX_FIFO_output_sel_in                                                             : in  std_logic_vector(2 downto 0);

        CTS_out                                                                            : out std_logic;
        empty_out                                                                          : out std_logic;
        FIFO_D_out_out                                                                     : out std_logic_vector(DATA_WIDTH - 1 downto 0);

        CTS_N, CTS_E, CTS_w, CTS_S, CTS_L                                           : in  std_logic;
        empty_N, empty_E, empty_W, empty_S, empty_L                               : in  std_logic;
        FIFO_D_out_N, FIFO_D_out_E, FIFO_D_out_W, FIFO_D_out_S, FIFO_D_out_L : in  std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end entity MUX_5x1_FIFO_output;

architecture RTL of MUX_5x1_FIFO_output is
begin
    mux : process(CTS_E, CTS_L, CTS_N, CTS_S, CTS_w, FIFO_D_out_E, FIFO_D_out_L, FIFO_D_out_N, FIFO_D_out_S, FIFO_D_out_W, MUX_FIFO_output_sel_in, empty_E, empty_L, empty_N, empty_S, empty_W)
    begin
        case MUX_FIFO_output_sel_in is
            when "000" =>
                CTS_out        <= CTS_N;
                empty_out      <= empty_N;
                FIFO_D_out_out <= FIFO_D_out_N;
            when "001" =>
                CTS_out        <= CTS_E;
                empty_out      <= empty_E;
                FIFO_D_out_out <= FIFO_D_out_E;
            when "010" =>
                CTS_out        <= CTS_W;
                empty_out      <= empty_W;
                FIFO_D_out_out <= FIFO_D_out_W;
            when "011" =>
                CTS_out        <= CTS_S;
                empty_out      <= empty_S;
                FIFO_D_out_out <= FIFO_D_out_S;
            when "100" =>
                CTS_out        <= CTS_L;
                empty_out      <= empty_L;
                FIFO_D_out_out <= FIFO_D_out_L;
            when others =>
                CTS_out        <= '0';
                empty_out      <= '0';
                FIFO_D_out_out <= (others => '0');

        end case;
    end process mux;

end architecture RTL;
