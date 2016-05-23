library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fault_Control_v3 is
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
end entity Fault_Control_v3;
architecture RTL of Fault_Control_v3 is
    --PATH = packets coming from North, East, West, South, Local ports
    --TYPE = what kind of unit are we talking about? : FIFO | LBDR | ARBITER | XBAR
    --UNIT = pool of available number of UNIT for each TYPE, if ther is 1 redundant unit for each type, this number= 5+1;
    --DIR  = NORTH, EAST, WEST, SOUTH, LOCAL

    subtype UNIT is std_logic_vector(5 downto 0);
    type TYPESxUNIT is array (3 downto 0) of UNIT;
    signal Fault_Information_Array_r : TYPESxUNIT;
    signal Unit_Is_Binded_r          : TYPESxUNIT;

    subtype TYPES is std_logic_vector(3 downto 0);
    type DIRxTYPES is array (4 downto 0) of TYPES;
    signal PATH_STATUS_r        : DIRxTYPES;

    subtype MUX is std_logic_vector(2 downto 0);
    type UNITxMUX is array (5 downto 0) of MUX;
    type DIRxMUX is array (4 downto 0) of MUX;

    type TYPExUNITxMUX is array (3 downto 0) of UNITxMUX;
    signal Input_MUX_UNIT_r        : TYPExUNITxMUX;

    type TYPExDIRxMUX is array (3 downto 0) of DIRxMUX;
    signal Output_MUX_UNIT_r        : TYPExDIRxMUX;

begin
    assigning_UNIT_to_paths : process(clk) is
        variable Unit_Is_Binded   : TYPESxUNIT;
        variable PATH_STATUS : DIRxTYPES;
        variable Input_MUX_UNIT : TYPExUNITxMUX;
        variable Output_MUX_UNIT : TYPExDIRxMUX;
    begin
        if rising_edge(clk) then
            PATH_STATUS_r     <= PATH_STATUS;
            Input_MUX_UNIT_r  <= (others => (others => "000"));
            Output_MUX_UNIT_r <= (others => (others => "000"));
            PATH_STATUS       := (others => (others => '0'));
            Unit_Is_Binded    := (others => (others => '0')); --by default all of them are '0'. and on each clock cyle they are updated.

            for PATH_INDEX in 0 to 4 loop --check for all pathes
                for TYPE_INDEX in 0 to 3 loop --find out which part is not functional
                    for UNIT_INDEX in 0 to 5 loop --take pool of this parts/units and find which one is not used of this.
                        if Fault_Information_Array_r(TYPE_INDEX)(UNIT_INDEX) /= '1' --if this uint is not fauly
                        AND Unit_Is_Binded(TYPE_INDEX)(UNIT_INDEX) /= '1' --and not used in other path before
                        AND PATH_STATUS(PATH_INDEX)(TYPE_INDEX) /= '1' --and we have not yet binded any unit to this part, yet
                        then
                            Unit_Is_Binded(TYPE_INDEX)(UNIT_INDEX)    := '1'; --mark this unit as used, during THIS clk cycle
                            PATH_STATUS(PATH_INDEX)(TYPE_INDEX)       := '1'; --this is only to notify later, which path is alive
                            Input_MUX_UNIT_r(TYPE_INDEX)(UNIT_INDEX)  <= STD_LOGIC_VECTOR(TO_UNSIGNED(PATH_INDEX, 3));
                            Output_MUX_UNIT_r(TYPE_INDEX)(PATH_INDEX) <= STD_LOGIC_VECTOR(TO_UNSIGNED(UNIT_INDEX, 3));
                            if UNIT_INDEX = 5 and PATH_STATUS(PATH_INDEX)(TYPE_INDEX) = '0' then
                                Input_MUX_UNIT_r(TYPE_INDEX)(UNIT_INDEX)  <= "XXX";
                                Output_MUX_UNIT_r(TYPE_INDEX)(PATH_INDEX) <= "XXX";
                            end if;
                        end if;
                    end loop;
                end loop;
                Unit_Is_Binded_r <= Unit_Is_Binded;
            end loop;
        end if;
    end process assigning_UNIT_to_paths;

    outputting_MUX_Signals : process(Input_MUX_UNIT_r, Output_MUX_UNIT_r) is
    begin
        MUX_5x1_FIFO_input_select_N_out  <=  Input_MUX_UNIT_r(0)(0);
        MUX_5x1_FIFO_input_select_E_out  <=  Input_MUX_UNIT_r(0)(1);
        MUX_5x1_FIFO_input_select_W_out  <=  Input_MUX_UNIT_r(0)(2);
        MUX_5x1_FIFO_input_select_S_out  <=  Input_MUX_UNIT_r(0)(3);
        MUX_5x1_FIFO_input_select_L_out  <=  Input_MUX_UNIT_r(0)(4);
        MUX_5x1_FIFO_input_select_R_out  <=  Input_MUX_UNIT_r(0)(5);
        MUX_6x1_FIFO_output_select_N_out <= Output_MUX_UNIT_r(0)(0);
        MUX_6x1_FIFO_output_select_E_out <= Output_MUX_UNIT_r(0)(1);
        MUX_6x1_FIFO_output_select_W_out <= Output_MUX_UNIT_r(0)(2);
        MUX_6x1_FIFO_output_select_S_out <= Output_MUX_UNIT_r(0)(3);
        MUX_6x1_FIFO_output_select_L_out <= Output_MUX_UNIT_r(0)(4);

        MUX_5x1_LBDR_input_select_N_out  <=  Input_MUX_UNIT_r(1)(0);
        MUX_5x1_LBDR_input_select_E_out  <=  Input_MUX_UNIT_r(1)(1);
        MUX_5x1_LBDR_input_select_W_out  <=  Input_MUX_UNIT_r(1)(2);
        MUX_5x1_LBDR_input_select_S_out  <=  Input_MUX_UNIT_r(1)(3);
        MUX_5x1_LBDR_input_select_L_out  <=  Input_MUX_UNIT_r(1)(4);
        MUX_5x1_LBDR_input_select_R_out  <=  Input_MUX_UNIT_r(1)(5);
        MUX_6x1_LBDR_output_select_N_out <= Output_MUX_UNIT_r(1)(0);
        MUX_6x1_LBDR_output_select_E_out <= Output_MUX_UNIT_r(1)(1);
        MUX_6x1_LBDR_output_select_W_out <= Output_MUX_UNIT_r(1)(2);
        MUX_6x1_LBDR_output_select_S_out <= Output_MUX_UNIT_r(1)(3);
        MUX_6x1_LBDR_output_select_L_out <= Output_MUX_UNIT_r(1)(4);

        MUX_5x1_Arbiter_input_select_N_out  <=  Input_MUX_UNIT_r(2)(0);
        MUX_5x1_Arbiter_input_select_E_out  <=  Input_MUX_UNIT_r(2)(1);
        MUX_5x1_Arbiter_input_select_W_out  <=  Input_MUX_UNIT_r(2)(2);
        MUX_5x1_Arbiter_input_select_S_out  <=  Input_MUX_UNIT_r(2)(3);
        MUX_5x1_Arbiter_input_select_L_out  <=  Input_MUX_UNIT_r(2)(4);
        MUX_5x1_Arbiter_input_select_R_out  <=  Input_MUX_UNIT_r(2)(5);
        MUX_6x1_Arbiter_output_select_N_out <= Output_MUX_UNIT_r(2)(0);
        MUX_6x1_Arbiter_output_select_E_out <= Output_MUX_UNIT_r(2)(1);
        MUX_6x1_Arbiter_output_select_W_out <= Output_MUX_UNIT_r(2)(2);
        MUX_6x1_Arbiter_output_select_S_out <= Output_MUX_UNIT_r(2)(3);
        MUX_6x1_Arbiter_output_select_L_out <= Output_MUX_UNIT_r(2)(4);

        MUX_5x1_XBAR_input_select_N_out  <=  Input_MUX_UNIT_r(3)(0);
        MUX_5x1_XBAR_input_select_E_out  <=  Input_MUX_UNIT_r(3)(1);
        MUX_5x1_XBAR_input_select_W_out  <=  Input_MUX_UNIT_r(3)(2);
        MUX_5x1_XBAR_input_select_S_out  <=  Input_MUX_UNIT_r(3)(3);
        MUX_5x1_XBAR_input_select_L_out  <=  Input_MUX_UNIT_r(3)(4);
        MUX_5x1_XBAR_input_select_R_out  <=  Input_MUX_UNIT_r(3)(5);
        MUX_6x1_XBAR_output_select_N_out <= Output_MUX_UNIT_r(3)(0);
        MUX_6x1_XBAR_output_select_E_out <= Output_MUX_UNIT_r(3)(1);
        MUX_6x1_XBAR_output_select_W_out <= Output_MUX_UNIT_r(3)(2);
        MUX_6x1_XBAR_output_select_S_out <= Output_MUX_UNIT_r(3)(3);
        MUX_6x1_XBAR_output_select_L_out <= Output_MUX_UNIT_r(3)(4);
    end process outputting_MUX_Signals;

    --    learn what faults do we have and where. this process can be removed, by simply using Fault_Information_Array_r as an entity inputs
    writing_Fault_info_into_Array : process(Fault_Info_FIFO_in, Fault_Info_LBDR_in, Fault_Info_ARBITER_in, Fault_Info_XBAR_in) is
    begin
        Fault_Information_Array_r(0)(0) <= Fault_Info_FIFO_in(0);
        Fault_Information_Array_r(0)(1) <= Fault_Info_FIFO_in(1);
        Fault_Information_Array_r(0)(2) <= Fault_Info_FIFO_in(2);
        Fault_Information_Array_r(0)(3) <= Fault_Info_FIFO_in(3);
        Fault_Information_Array_r(0)(4) <= Fault_Info_FIFO_in(4);
        Fault_Information_Array_r(0)(5) <= Fault_Info_FIFO_in(5);
        Fault_Information_Array_r(1)(0) <= Fault_Info_LBDR_in(0);
        Fault_Information_Array_r(1)(1) <= Fault_Info_LBDR_in(1);
        Fault_Information_Array_r(1)(2) <= Fault_Info_LBDR_in(2);
        Fault_Information_Array_r(1)(3) <= Fault_Info_LBDR_in(3);
        Fault_Information_Array_r(1)(4) <= Fault_Info_LBDR_in(4);
        Fault_Information_Array_r(1)(5) <= Fault_Info_LBDR_in(5);
        Fault_Information_Array_r(2)(0) <= Fault_Info_ARBITER_in(0);
        Fault_Information_Array_r(2)(1) <= Fault_Info_ARBITER_in(1);
        Fault_Information_Array_r(2)(2) <= Fault_Info_ARBITER_in(2);
        Fault_Information_Array_r(2)(3) <= Fault_Info_ARBITER_in(3);
        Fault_Information_Array_r(2)(4) <= Fault_Info_ARBITER_in(4);
        Fault_Information_Array_r(2)(5) <= Fault_Info_ARBITER_in(5);
        Fault_Information_Array_r(3)(0) <= Fault_Info_XBAR_in(0);
        Fault_Information_Array_r(3)(1) <= Fault_Info_XBAR_in(1);
        Fault_Information_Array_r(3)(2) <= Fault_Info_XBAR_in(2);
        Fault_Information_Array_r(3)(3) <= Fault_Info_XBAR_in(3);
        Fault_Information_Array_r(3)(4) <= Fault_Info_XBAR_in(4);
        Fault_Information_Array_r(3)(5) <= Fault_Info_XBAR_in(5);
    end process writing_Fault_info_into_Array;

end architecture RTL;
