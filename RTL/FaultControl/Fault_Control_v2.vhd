library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fault_Control is
    port(
        clk                                 : in  std_logic;
        Fault_Info_FIFO_in                  : in  std_logic_vector(5 downto 0);
        Fault_Info_LBDR_in                  : in  std_logic_vector(5 downto 0);
        Fault_Info_Arbiter_in               : in  std_logic_vector(5 downto 0);
        Fault_Info_XBAR_in                  : in  std_logic_vector(5 downto 0);

        MUX_5x1_FIFO_input_select_N_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_FIFO_input_select_E_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_FIFO_input_select_W_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_FIFO_input_select_S_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_FIFO_input_select_L_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_FIFO_input_select_R_out     : out std_logic_vector(2 downto 0);

        MUX_5x1_LBDR_input_select_N_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_LBDR_input_select_E_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_LBDR_input_select_W_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_LBDR_input_select_S_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_LBDR_input_select_L_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_LBDR_input_select_R_out     : out std_logic_vector(2 downto 0);

        MUX_5x1_ARBITER_input_select_N_out  : out std_logic_vector(2 downto 0);
        MUX_5x1_ARBITER_input_select_E_out  : out std_logic_vector(2 downto 0);
        MUX_5x1_ARBITER_input_select_W_out  : out std_logic_vector(2 downto 0);
        MUX_5x1_ARBITER_input_select_S_out  : out std_logic_vector(2 downto 0);
        MUX_5x1_ARBITER_input_select_L_out  : out std_logic_vector(2 downto 0);
        MUX_5x1_ARBITER_input_select_R_out  : out std_logic_vector(2 downto 0);

        MUX_5x1_XBAR_input_select_N_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_XBAR_input_select_E_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_XBAR_input_select_W_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_XBAR_input_select_S_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_XBAR_input_select_L_out     : out std_logic_vector(2 downto 0);
        MUX_5x1_XBAR_input_select_R_out     : out std_logic_vector(2 downto 0);

        MUX_6x1_FIFO_output_select_N_out    : out std_logic_vector(2 downto 0);
        MUX_6x1_FIFO_output_select_E_out    : out std_logic_vector(2 downto 0);
        MUX_6x1_FIFO_output_select_W_out    : out std_logic_vector(2 downto 0);
        MUX_6x1_FIFO_output_select_S_out    : out std_logic_vector(2 downto 0);
        MUX_6x1_FIFO_output_select_L_out    : out std_logic_vector(2 downto 0);

        MUX_6x1_LBDR_output_select_N_out    : out std_logic_vector(2 downto 0);
        MUX_6x1_LBDR_output_select_E_out    : out std_logic_vector(2 downto 0);
        MUX_6x1_LBDR_output_select_W_out    : out std_logic_vector(2 downto 0);
        MUX_6x1_LBDR_output_select_S_out    : out std_logic_vector(2 downto 0);
        MUX_6x1_LBDR_output_select_L_out    : out std_logic_vector(2 downto 0);

        MUX_6x1_ARBITER_output_select_N_out : out std_logic_vector(2 downto 0);
        MUX_6x1_ARBITER_output_select_E_out : out std_logic_vector(2 downto 0);
        MUX_6x1_ARBITER_output_select_W_out : out std_logic_vector(2 downto 0);
        MUX_6x1_ARBITER_output_select_S_out : out std_logic_vector(2 downto 0);
        MUX_6x1_ARBITER_output_select_L_out : out std_logic_vector(2 downto 0);

        MUX_6x1_XBAR_output_select_N_out    : out std_logic_vector(2 downto 0);
        MUX_6x1_XBAR_output_select_E_out    : out std_logic_vector(2 downto 0);
        MUX_6x1_XBAR_output_select_W_out    : out std_logic_vector(2 downto 0);
        MUX_6x1_XBAR_output_select_S_out    : out std_logic_vector(2 downto 0);
        MUX_6x1_XBAR_output_select_L_out    : out std_logic_vector(2 downto 0)
    );
end entity Fault_Control;
architecture RTL of Fault_Control is
    constant Fully_Functional : std_logic_vector(3 downto 0) := (others => '1');
    constant NORTH            : integer                      := 0;
    constant EAST             : integer                      := 1;
    constant WEST             : integer                      := 2;
    constant SOUTH            : integer                      := 3;
    constant LOCAL            : integer                      := 4;

    --TYPE = what kind of unit are we talking about? : FIFO | LBDR | ARBITER | XBAR
    --UNIT = pool of available number of UNIT for each TYPE, if ther is 1 redundant unit for each type, this number= 5+1;
    --DIR  = NORTH, EAST, WEST, SOUTH, LOCAL

    type TYPExUNIT is array (3 downto 0, 5 downto 0) of std_logic;
    type TYPExUNITxMUX is array (3 downto 0, 5 downto 0) of std_logic_vector(2 downto 0);
    type TYPExDIRxMUX is array (3 downto 0, 4 downto 0) of std_logic_vector(2 downto 0);
    type DIRxTYPE is array (4 downto 0, 3 downto 0) of std_logic;

    signal Final_Status_Of_Units, Unit_Is_Binded : TYPExUNIT;
    signal PATH_STATUS                           : DIRxTYPE;

    signal Input_MUX_UNIT  : TYPExUNITxMUX;
    signal Output_MUX_UNIT : TYPExDIRxMUX;

begin
    outputting_MUX_Signals : process(Input_MUX_UNIT, Output_MUX_UNIT) is
    begin
        --TODO: finish this part
        MUX_5x1_FIFO_input_select_N_out  <= Input_MUX_UNIT(0, 0);
        MUX_5x1_FIFO_input_select_E_out  <= Input_MUX_UNIT(0, 1);
        MUX_5x1_FIFO_input_select_W_out  <= Input_MUX_UNIT(0, 2);
        MUX_5x1_FIFO_input_select_S_out  <= Input_MUX_UNIT(0, 3);
        MUX_5x1_FIFO_input_select_L_out  <= Input_MUX_UNIT(0, 4);
        MUX_5x1_FIFO_input_select_R_out  <= Input_MUX_UNIT(0, 5);
        MUX_6x1_FIFO_output_select_N_out <= Output_MUX_UNIT(0, 0);
        MUX_6x1_FIFO_output_select_E_out <= Output_MUX_UNIT(0, 1);
        MUX_6x1_FIFO_output_select_W_out <= Output_MUX_UNIT(0, 2);
        MUX_6x1_FIFO_output_select_S_out <= Output_MUX_UNIT(0, 3);
        MUX_6x1_FIFO_output_select_L_out <= Output_MUX_UNIT(0, 4);
    end process outputting_MUX_Signals;

    assigning_UNIT_to_paths : process(clk) is --, Unit_Is_Binded, Fault_Info_FIFO_in, Fault_Info_LBDR_in, Fault_Info_ARBITER_in, Fault_Info_XBAR_in
        variable dir : integer;
    begin
        --TODO: maybe i should reset all Unit_Is_Binded, in this part of code.
        Unit_Is_Binded <= (others => (others => '0')); --by default all of them are '0'. and on each clock cyle they are updated.
        if rising_edge(clk) then
            --learn what faults do we have and where.
            --0 => available
            --1 => not available, because of FAULT or because it is ASSIGNED to somwhere
            --TODO: should this part be clocked?
            Final_Status_Of_Units(0, 0) <= Unit_Is_Binded(0, 0) or Fault_Info_FIFO_in(0);
            Final_Status_Of_Units(0, 1) <= Unit_Is_Binded(0, 1) or Fault_Info_FIFO_in(1);
            Final_Status_Of_Units(0, 2) <= Unit_Is_Binded(0, 2) or Fault_Info_FIFO_in(2);
            Final_Status_Of_Units(0, 3) <= Unit_Is_Binded(0, 3) or Fault_Info_FIFO_in(3);
            Final_Status_Of_Units(0, 4) <= Unit_Is_Binded(0, 4) or Fault_Info_FIFO_in(4);
            Final_Status_Of_Units(0, 5) <= Unit_Is_Binded(0, 5) or Fault_Info_FIFO_in(5);

            Final_Status_Of_Units(1, 0) <= Unit_Is_Binded(1, 0) or Fault_Info_LBDR_in(0);
            Final_Status_Of_Units(1, 1) <= Unit_Is_Binded(1, 1) or Fault_Info_LBDR_in(1);
            Final_Status_Of_Units(1, 2) <= Unit_Is_Binded(1, 2) or Fault_Info_LBDR_in(2);
            Final_Status_Of_Units(1, 3) <= Unit_Is_Binded(1, 3) or Fault_Info_LBDR_in(3);
            Final_Status_Of_Units(1, 4) <= Unit_Is_Binded(1, 4) or Fault_Info_LBDR_in(4);
            Final_Status_Of_Units(1, 5) <= Unit_Is_Binded(1, 5) or Fault_Info_LBDR_in(5);

            Final_Status_Of_Units(2, 0) <= Unit_Is_Binded(2, 0) or Fault_Info_ARBITER_in(0);
            Final_Status_Of_Units(2, 1) <= Unit_Is_Binded(2, 1) or Fault_Info_ARBITER_in(1);
            Final_Status_Of_Units(2, 2) <= Unit_Is_Binded(2, 2) or Fault_Info_ARBITER_in(2);
            Final_Status_Of_Units(2, 3) <= Unit_Is_Binded(2, 3) or Fault_Info_ARBITER_in(3);
            Final_Status_Of_Units(2, 4) <= Unit_Is_Binded(2, 4) or Fault_Info_ARBITER_in(4);
            Final_Status_Of_Units(2, 5) <= Unit_Is_Binded(2, 5) or Fault_Info_ARBITER_in(5);

            Final_Status_Of_Units(3, 0) <= Unit_Is_Binded(3, 0) or Fault_Info_XBAR_in(0);
            Final_Status_Of_Units(3, 1) <= Unit_Is_Binded(3, 1) or Fault_Info_XBAR_in(1);
            Final_Status_Of_Units(3, 2) <= Unit_Is_Binded(3, 2) or Fault_Info_XBAR_in(2);
            Final_Status_Of_Units(3, 3) <= Unit_Is_Binded(3, 3) or Fault_Info_XBAR_in(3);
            Final_Status_Of_Units(3, 4) <= Unit_Is_Binded(3, 4) or Fault_Info_XBAR_in(4);
            Final_Status_Of_Units(3, 5) <= Unit_Is_Binded(3, 5) or Fault_Info_XBAR_in(5);

            dir := NORTH;
            --check wherher PATH is fully functional
            if PATH_STATUS(dir, 0) & PATH_STATUS(dir, 1) & PATH_STATUS(dir, 2) & PATH_STATUS(dir, 3) /= Fully_Functional then

                --find out which TYPE of unit is missing in this PATH
                for TYPE_INDEX in 0 to 3 loop
                    if PATH_STATUS(dir, TYPE_INDEX) = '0' then

                        --find available UNIT of this type
                        for UNIT_INTEX in 0 to 5 loop
                            if Final_Status_Of_Units(TYPE_INDEX, UNIT_INTEX) = '0' then
                                --mark this UNIT as used
                                Unit_Is_Binded(TYPE_INDEX, UNIT_INTEX) <= '1';

                                --mark this part of this path as functional
                                PATH_STATUS(dir, TYPE_INDEX) <= '1';

                                --send out proper select signals for MUXes.
                                Input_MUX_UNIT(TYPE_INDEX, UNIT_INTEX) <= STD_LOGIC_VECTOR(TO_UNSIGNED(dir, 3)); --TYPExUNIT
                                Output_MUX_UNIT(TYPE_INDEX, dir)       <= STD_LOGIC_VECTOR(TO_UNSIGNED(UNIT_INTEX, 3)); --TYPExDIR

                            --TODO: check if it finishes the array without findind free spare unit. what happens then?
                            --TODO: when does Unit_Is_Binded(x,y) becomes 0 ? when unit is Unbinded?

                            end if;
                        end loop;
                    end if;
                end loop;
            --else
                --dir := EAST;
                --if PATH_STATUS(dir, 0) & PATH_STATUS(dir, 1) & PATH_STATUS(dir, 2) & PATH_STATUS(dir, 3) /= Fully_Functional then
                    --same code as above.
                    --TODO: try to do that with Functions.
                --else
                    --.....
            end if;

        --TODO: check for other pathes as well, EAST. . . .
        end if;
    end process assigning_UNIT_to_paths;

end architecture RTL;
