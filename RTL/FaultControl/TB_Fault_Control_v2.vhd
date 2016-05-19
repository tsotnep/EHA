library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end entity tb;

architecture RTL of tb is
    signal Fault_Info_FIFO_in    : std_logic_vector(5 downto 0);
    signal Fault_Info_LBDR_in    : std_logic_vector(5 downto 0);
    signal Fault_Info_Arbiter_in : std_logic_vector(5 downto 0);
    signal Fault_Info_XBAR_in    : std_logic_vector(5 downto 0);
    signal clk                   : std_logic;

    signal MUX_5x1_FIFO_input_select_N_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_FIFO_input_select_E_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_FIFO_input_select_W_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_FIFO_input_select_S_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_FIFO_input_select_L_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_FIFO_input_select_R_out  : std_logic_vector(2 downto 0);
    signal MUX_6x1_FIFO_output_select_N_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_FIFO_output_select_E_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_FIFO_output_select_W_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_FIFO_output_select_S_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_FIFO_output_select_L_out : std_logic_vector(2 downto 0);

    signal MUX_5x1_LBDR_input_select_N_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_LBDR_input_select_E_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_LBDR_input_select_W_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_LBDR_input_select_S_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_LBDR_input_select_L_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_LBDR_input_select_R_out  : std_logic_vector(2 downto 0);
    signal MUX_6x1_LBDR_output_select_N_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_LBDR_output_select_E_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_LBDR_output_select_W_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_LBDR_output_select_S_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_LBDR_output_select_L_out : std_logic_vector(2 downto 0);

    signal MUX_5x1_Arbiter_input_select_N_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_Arbiter_input_select_E_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_Arbiter_input_select_W_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_Arbiter_input_select_S_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_Arbiter_input_select_L_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_Arbiter_input_select_R_out  : std_logic_vector(2 downto 0);
    signal MUX_6x1_Arbiter_output_select_N_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_Arbiter_output_select_E_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_Arbiter_output_select_W_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_Arbiter_output_select_S_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_Arbiter_output_select_L_out : std_logic_vector(2 downto 0);

    signal MUX_5x1_XBAR_input_select_N_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_XBAR_input_select_E_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_XBAR_input_select_W_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_XBAR_input_select_S_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_XBAR_input_select_L_out  : std_logic_vector(2 downto 0);
    signal MUX_5x1_XBAR_input_select_R_out  : std_logic_vector(2 downto 0);
    signal MUX_6x1_XBAR_output_select_N_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_XBAR_output_select_E_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_XBAR_output_select_W_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_XBAR_output_select_S_out : std_logic_vector(2 downto 0);
    signal MUX_6x1_XBAR_output_select_L_out : std_logic_vector(2 downto 0);

begin
    clock_driver : process
        constant period : time := 10 ns;
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process clock_driver;

    Fault_Control_inst : entity work.Fault_Control_v2
        port map(
            clk                                 => clk,
            Fault_Info_FIFO_in                  => Fault_Info_FIFO_in,
            Fault_Info_LBDR_in                  => Fault_Info_LBDR_in,
            Fault_Info_Arbiter_in               => Fault_Info_Arbiter_in,
            Fault_Info_XBAR_in                  => Fault_Info_XBAR_in,
            MUX_5x1_FIFO_input_select_N_out     => MUX_5x1_FIFO_input_select_N_out,
            MUX_5x1_FIFO_input_select_E_out     => MUX_5x1_FIFO_input_select_E_out,
            MUX_5x1_FIFO_input_select_W_out     => MUX_5x1_FIFO_input_select_W_out,
            MUX_5x1_FIFO_input_select_S_out     => MUX_5x1_FIFO_input_select_S_out,
            MUX_5x1_FIFO_input_select_L_out     => MUX_5x1_FIFO_input_select_L_out,
            MUX_5x1_FIFO_input_select_R_out     => MUX_5x1_FIFO_input_select_R_out,
            MUX_5x1_LBDR_input_select_N_out     => MUX_5x1_LBDR_input_select_N_out,
            MUX_5x1_LBDR_input_select_E_out     => MUX_5x1_LBDR_input_select_E_out,
            MUX_5x1_LBDR_input_select_W_out     => MUX_5x1_LBDR_input_select_W_out,
            MUX_5x1_LBDR_input_select_S_out     => MUX_5x1_LBDR_input_select_S_out,
            MUX_5x1_LBDR_input_select_L_out     => MUX_5x1_LBDR_input_select_L_out,
            MUX_5x1_LBDR_input_select_R_out     => MUX_5x1_LBDR_input_select_R_out,
            MUX_5x1_ARBITER_input_select_N_out  => MUX_5x1_ARBITER_input_select_N_out,
            MUX_5x1_ARBITER_input_select_E_out  => MUX_5x1_ARBITER_input_select_E_out,
            MUX_5x1_ARBITER_input_select_W_out  => MUX_5x1_ARBITER_input_select_W_out,
            MUX_5x1_ARBITER_input_select_S_out  => MUX_5x1_ARBITER_input_select_S_out,
            MUX_5x1_ARBITER_input_select_L_out  => MUX_5x1_ARBITER_input_select_L_out,
            MUX_5x1_ARBITER_input_select_R_out  => MUX_5x1_ARBITER_input_select_R_out,
            MUX_5x1_XBAR_input_select_N_out     => MUX_5x1_XBAR_input_select_N_out,
            MUX_5x1_XBAR_input_select_E_out     => MUX_5x1_XBAR_input_select_E_out,
            MUX_5x1_XBAR_input_select_W_out     => MUX_5x1_XBAR_input_select_W_out,
            MUX_5x1_XBAR_input_select_S_out     => MUX_5x1_XBAR_input_select_S_out,
            MUX_5x1_XBAR_input_select_L_out     => MUX_5x1_XBAR_input_select_L_out,
            MUX_5x1_XBAR_input_select_R_out     => MUX_5x1_XBAR_input_select_R_out,
            MUX_6x1_FIFO_output_select_N_out    => MUX_6x1_FIFO_output_select_N_out,
            MUX_6x1_FIFO_output_select_E_out    => MUX_6x1_FIFO_output_select_E_out,
            MUX_6x1_FIFO_output_select_W_out    => MUX_6x1_FIFO_output_select_W_out,
            MUX_6x1_FIFO_output_select_S_out    => MUX_6x1_FIFO_output_select_S_out,
            MUX_6x1_FIFO_output_select_L_out    => MUX_6x1_FIFO_output_select_L_out,
            MUX_6x1_LBDR_output_select_N_out    => MUX_6x1_LBDR_output_select_N_out,
            MUX_6x1_LBDR_output_select_E_out    => MUX_6x1_LBDR_output_select_E_out,
            MUX_6x1_LBDR_output_select_W_out    => MUX_6x1_LBDR_output_select_W_out,
            MUX_6x1_LBDR_output_select_S_out    => MUX_6x1_LBDR_output_select_S_out,
            MUX_6x1_LBDR_output_select_L_out    => MUX_6x1_LBDR_output_select_L_out,
            MUX_6x1_ARBITER_output_select_N_out => MUX_6x1_ARBITER_output_select_N_out,
            MUX_6x1_ARBITER_output_select_E_out => MUX_6x1_ARBITER_output_select_E_out,
            MUX_6x1_ARBITER_output_select_W_out => MUX_6x1_ARBITER_output_select_W_out,
            MUX_6x1_ARBITER_output_select_S_out => MUX_6x1_ARBITER_output_select_S_out,
            MUX_6x1_ARBITER_output_select_L_out => MUX_6x1_ARBITER_output_select_L_out,
            MUX_6x1_XBAR_output_select_N_out    => MUX_6x1_XBAR_output_select_N_out,
            MUX_6x1_XBAR_output_select_E_out    => MUX_6x1_XBAR_output_select_E_out,
            MUX_6x1_XBAR_output_select_W_out    => MUX_6x1_XBAR_output_select_W_out,
            MUX_6x1_XBAR_output_select_S_out    => MUX_6x1_XBAR_output_select_S_out,
            MUX_6x1_XBAR_output_select_L_out    => MUX_6x1_XBAR_output_select_L_out
        );

    stimul : process is
    begin
        wait for 100 ns;
        Fault_Info_FIFO_in <= "000001";
        wait for 20 ns;
        Fault_Info_LBDR_in <= "000010";

        wait;

    end process stimul;

end architecture RTL;


