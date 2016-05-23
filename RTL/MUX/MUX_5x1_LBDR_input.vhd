library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_5x1_LBDR_input is
    generic(
        cur_addr_rst: integer := 8;
        Rxy_rst: integer := 8;
        Cx_rst: integer := 8;
        NoC_size: integer := 4
    );
    port(MUX_LBDR_input_sel_in                                           : in  std_logic_vector(2 downto 0);
         empty_out                                                       : out std_logic;
         flit_type_out                                                   : out std_logic_vector(2 downto 0);
         dst_addr_out                                                    : out std_logic_vector(NoC_size-1 downto 0);

         empty_N, empty_E, empty_W, empty_S, empty_L                     : in  std_logic;
         flit_type_N, flit_type_E, flit_type_W, flit_type_S, flit_type_L : in  std_logic_vector(2 downto 0);
         dst_addr_N, dst_addr_E, dst_addr_W, dst_addr_S, dst_addr_L      : in  std_logic_vector(NoC_size-1 downto 0));
end entity MUX_5x1_LBDR_input;

architecture RTL of MUX_5x1_LBDR_input is
begin
    mux : process (MUX_LBDR_input_sel_in, dst_addr_E, dst_addr_L, dst_addr_N, dst_addr_S, dst_addr_W, empty_E, empty_L, empty_N, empty_S, empty_W, flit_type_E, flit_type_L, flit_type_N, flit_type_S, flit_type_W)
    begin
        case MUX_LBDR_input_sel_in is
            when "000" =>
                empty_out     <= empty_N;
                flit_type_out <= flit_type_N;
                dst_addr_out  <= dst_addr_N;
            when "001" =>
                empty_out     <= empty_E;
                flit_type_out <= flit_type_E;
                dst_addr_out  <= dst_addr_E;
            when "010" =>
                empty_out     <= empty_W;
                flit_type_out <= flit_type_W;
                dst_addr_out  <= dst_addr_W;
            when "011" =>
                empty_out     <= empty_S;
                flit_type_out <= flit_type_S;
                dst_addr_out  <= dst_addr_S;
            when "100" =>
                empty_out     <= empty_L;
                flit_type_out <= flit_type_L;
                dst_addr_out  <= dst_addr_L;
            when others =>
                empty_out     <= '0';
                flit_type_out <= (others => '0');
                dst_addr_out  <= (others => '0');
        end case;
    end process mux;
end architecture RTL;
