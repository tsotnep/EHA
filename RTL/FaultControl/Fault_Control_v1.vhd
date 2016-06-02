library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fault_Control_v1 is
    port(
        Fault_Info_in                      : in  std_logic_vector(5 downto 0);
        MUX_5x1_module_input_select_N_out  : out std_logic_vector(2 downto 0); --not used
        MUX_5x1_module_input_select_E_out  : out std_logic_vector(2 downto 0); --not used
        MUX_5x1_module_input_select_W_out  : out std_logic_vector(2 downto 0); --not used
        MUX_5x1_module_input_select_S_out  : out std_logic_vector(2 downto 0); --not used
        MUX_5x1_module_input_select_L_out  : out std_logic_vector(2 downto 0); --not used
        MUX_5x1_module_input_select_R_out  : out std_logic_vector(2 downto 0);
        MUX_2x1_module_output_select_N_out : out std_logic_vector(2 downto 0);
        MUX_2x1_module_output_select_E_out : out std_logic_vector(2 downto 0);
        MUX_2x1_module_output_select_W_out : out std_logic_vector(2 downto 0);
        MUX_2x1_module_output_select_S_out : out std_logic_vector(2 downto 0);
        MUX_2x1_module_output_select_L_out : out std_logic_vector(2 downto 0)
    );
end entity Fault_Control_v1;
architecture RTL of Fault_Control_v1 is
begin


    control : process(Fault_Info_in) is
    begin
        MUX_5x1_module_input_select_N_out  <= "000";
        MUX_5x1_module_input_select_E_out  <= "001";
        MUX_5x1_module_input_select_W_out  <= "010";
        MUX_5x1_module_input_select_S_out  <= "011";
        MUX_5x1_module_input_select_L_out  <= "100";
        MUX_5x1_module_input_select_R_out  <= "111";

        MUX_2x1_module_output_select_N_out <= "000";
        MUX_2x1_module_output_select_E_out <= "000";
        MUX_2x1_module_output_select_W_out <= "000";
        MUX_2x1_module_output_select_S_out <= "000";
        MUX_2x1_module_output_select_L_out <= "000";
        case Fault_Info_in is
            when "000001" =>
                MUX_5x1_module_input_select_R_out  <= "000";
                MUX_2x1_module_output_select_N_out <= "101";
            when "000010" =>
                MUX_5x1_module_input_select_R_out  <= "001";
                MUX_2x1_module_output_select_E_out <= "101";
            when "000100" =>
                MUX_5x1_module_input_select_R_out  <= "010";
                MUX_2x1_module_output_select_W_out <= "101";
            when "001000" =>
                MUX_5x1_module_input_select_R_out  <= "011";
                MUX_2x1_module_output_select_S_out <= "101";
            when "010000" =>
                MUX_5x1_module_input_select_R_out  <= "100";
                MUX_2x1_module_output_select_L_out <= "101";
            when others =>
                MUX_5x1_module_input_select_R_out  <= "111";
                MUX_2x1_module_output_select_N_out <= "000";
        end case;

    end process control;

end architecture RTL;
