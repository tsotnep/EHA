library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fault_Control_v2 is
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
end entity Fault_Control_v2;
architecture RTL of Fault_Control_v2 is
    constant Fully_Functional : std_logic_vector(3 downto 0) := (others => '1');
    constant NORTH            : integer                      := 0;
    constant EAST             : integer                      := 1;
    constant WEST             : integer                      := 2;
    constant SOUTH            : integer                      := 3;
    constant LOCAL            : integer                      := 4;

    --TYPE = what kind of unit are we talking about? : FIFO | LBDR | ARBITER | XBAR
    --UNIT = pool of available number of UNIT for each TYPE, if ther is 1 redundant unit for each type, this number= 5+1;
    --DIR  = NORTH, EAST, WEST, SOUTH, LOCAL

    subtype UNIT is std_logic_vector(5 downto 0);
    type TYPESxUNIT is array (3 downto 0) of UNIT;
    shared variable Final_Status_Of_Units : TYPESxUNIT;
    shared variable Unit_Is_Binded        : TYPESxUNIT;
    signal Final_Status_Of_Units_r_TxU    : TYPESxUNIT;
    signal Unit_Is_Binded_r_TxU           : TYPESxUNIT;

    subtype TYPES is std_logic_vector(3 downto 0);
    type DIRxTYPES is array (4 downto 0) of TYPES;
    shared variable PATH_STATUS : DIRxTYPES;
    signal PATH_STATUS_r_DxT    : DIRxTYPES;

    subtype MUX is std_logic_vector(2 downto 0);
    type UNITxMUX is array (5 downto 0) of MUX;
    type DIRxMUX is array (4 downto 0) of MUX;

    type TYPExUNITxMUX is array (3 downto 0) of UNITxMUX;
    shared variable Input_MUX_UNIT : TYPExUNITxMUX;
    signal Input_MUX_UNIT_r_TxUxM  : TYPExUNITxMUX;

    type TYPExDIRxMUX is array (3 downto 0) of DIRxMUX;
    shared variable Output_MUX_UNIT : TYPExDIRxMUX;
    signal Output_MUX_UNIT_r_TxDxM  : TYPExDIRxMUX;

--    procedure find_and_fix(
--        variable dir            : in    integer;
--        variable Unit_Is_Binded : out   TYPExUNIT;
--        variable PATH_STATUS    : inout DIRxTYPE;
--        signal Input_MUX_UNIT   : out   TYPExUNITxMUX;
--        signal Output_MUX_UNIT  : out   TYPExDIRxMUX) is
--    begin

--    end find_and_fix;

begin
    --    outputting_MUX_Signals : process is
    --    begin
    MUX_5x1_FIFO_input_select_N_out  <= Input_MUX_UNIT_r_TxUxM(0)(0);
    MUX_5x1_FIFO_input_select_E_out  <= Input_MUX_UNIT_r_TxUxM(0)(1);
    MUX_5x1_FIFO_input_select_W_out  <= Input_MUX_UNIT_r_TxUxM(0)(2);
    MUX_5x1_FIFO_input_select_S_out  <= Input_MUX_UNIT_r_TxUxM(0)(3);
    MUX_5x1_FIFO_input_select_L_out  <= Input_MUX_UNIT_r_TxUxM(0)(4);
    MUX_5x1_FIFO_input_select_R_out  <= Input_MUX_UNIT_r_TxUxM(0)(5);
    MUX_6x1_FIFO_output_select_N_out <= Output_MUX_UNIT_r_TxDxM(0)(0);
    MUX_6x1_FIFO_output_select_E_out <= Output_MUX_UNIT_r_TxDxM(0)(1);
    MUX_6x1_FIFO_output_select_W_out <= Output_MUX_UNIT_r_TxDxM(0)(2);
    MUX_6x1_FIFO_output_select_S_out <= Output_MUX_UNIT_r_TxDxM(0)(3);
    MUX_6x1_FIFO_output_select_L_out <= Output_MUX_UNIT_r_TxDxM(0)(4);

    MUX_5x1_LBDR_input_select_N_out  <= Input_MUX_UNIT_r_TxUxM(0)(0);
    MUX_5x1_LBDR_input_select_E_out  <= Input_MUX_UNIT_r_TxUxM(0)(1);
    MUX_5x1_LBDR_input_select_W_out  <= Input_MUX_UNIT_r_TxUxM(0)(2);
    MUX_5x1_LBDR_input_select_S_out  <= Input_MUX_UNIT_r_TxUxM(0)(3);
    MUX_5x1_LBDR_input_select_L_out  <= Input_MUX_UNIT_r_TxUxM(0)(4);
    MUX_5x1_LBDR_input_select_R_out  <= Input_MUX_UNIT_r_TxUxM(0)(5);
    MUX_6x1_LBDR_output_select_N_out <= Output_MUX_UNIT_r_TxDxM(0)(0);
    MUX_6x1_LBDR_output_select_E_out <= Output_MUX_UNIT_r_TxDxM(0)(1);
    MUX_6x1_LBDR_output_select_W_out <= Output_MUX_UNIT_r_TxDxM(0)(2);
    MUX_6x1_LBDR_output_select_S_out <= Output_MUX_UNIT_r_TxDxM(0)(3);
    MUX_6x1_LBDR_output_select_L_out <= Output_MUX_UNIT_r_TxDxM(0)(4);

    MUX_5x1_Arbiter_input_select_N_out  <= Input_MUX_UNIT_r_TxUxM(0)(0);
    MUX_5x1_Arbiter_input_select_E_out  <= Input_MUX_UNIT_r_TxUxM(0)(1);
    MUX_5x1_Arbiter_input_select_W_out  <= Input_MUX_UNIT_r_TxUxM(0)(2);
    MUX_5x1_Arbiter_input_select_S_out  <= Input_MUX_UNIT_r_TxUxM(0)(3);
    MUX_5x1_Arbiter_input_select_L_out  <= Input_MUX_UNIT_r_TxUxM(0)(4);
    MUX_5x1_Arbiter_input_select_R_out  <= Input_MUX_UNIT_r_TxUxM(0)(5);
    MUX_6x1_Arbiter_output_select_N_out <= Output_MUX_UNIT_r_TxDxM(0)(0);
    MUX_6x1_Arbiter_output_select_E_out <= Output_MUX_UNIT_r_TxDxM(0)(1);
    MUX_6x1_Arbiter_output_select_W_out <= Output_MUX_UNIT_r_TxDxM(0)(2);
    MUX_6x1_Arbiter_output_select_S_out <= Output_MUX_UNIT_r_TxDxM(0)(3);
    MUX_6x1_Arbiter_output_select_L_out <= Output_MUX_UNIT_r_TxDxM(0)(4);

    MUX_5x1_XBAR_input_select_N_out  <= Input_MUX_UNIT_r_TxUxM(0)(0);
    MUX_5x1_XBAR_input_select_E_out  <= Input_MUX_UNIT_r_TxUxM(0)(1);
    MUX_5x1_XBAR_input_select_W_out  <= Input_MUX_UNIT_r_TxUxM(0)(2);
    MUX_5x1_XBAR_input_select_S_out  <= Input_MUX_UNIT_r_TxUxM(0)(3);
    MUX_5x1_XBAR_input_select_L_out  <= Input_MUX_UNIT_r_TxUxM(0)(4);
    MUX_5x1_XBAR_input_select_R_out  <= Input_MUX_UNIT_r_TxUxM(0)(5);
    MUX_6x1_XBAR_output_select_N_out <= Output_MUX_UNIT_r_TxDxM(0)(0);
    MUX_6x1_XBAR_output_select_E_out <= Output_MUX_UNIT_r_TxDxM(0)(1);
    MUX_6x1_XBAR_output_select_W_out <= Output_MUX_UNIT_r_TxDxM(0)(2);
    MUX_6x1_XBAR_output_select_S_out <= Output_MUX_UNIT_r_TxDxM(0)(3);
    MUX_6x1_XBAR_output_select_L_out <= Output_MUX_UNIT_r_TxDxM(0)(4);
    --    end process outputting_MUX_Signals;

    assigning_UNIT_to_paths : process(clk) is --, Unit_Is_Binded, Fault_Info_FIFO_in, Fault_Info_LBDR_in, Fault_Info_ARBITER_in, Fault_Info_XBAR_in
        variable dir : integer;
    begin
        if rising_edge(clk) then

            --learn what faults do we have and where.
            Final_Status_Of_Units(0)(0) := Fault_Info_FIFO_in(0);
            Final_Status_Of_Units(0)(1) := Fault_Info_FIFO_in(1);
            Final_Status_Of_Units(0)(2) := Fault_Info_FIFO_in(2);
            Final_Status_Of_Units(0)(3) := Fault_Info_FIFO_in(3);
            Final_Status_Of_Units(0)(4) := Fault_Info_FIFO_in(4);
            Final_Status_Of_Units(0)(5) := Fault_Info_FIFO_in(5);
            Final_Status_Of_Units(1)(0) := Fault_Info_LBDR_in(0);
            Final_Status_Of_Units(1)(1) := Fault_Info_LBDR_in(1);
            Final_Status_Of_Units(1)(2) := Fault_Info_LBDR_in(2);
            Final_Status_Of_Units(1)(3) := Fault_Info_LBDR_in(3);
            Final_Status_Of_Units(1)(4) := Fault_Info_LBDR_in(4);
            Final_Status_Of_Units(1)(5) := Fault_Info_LBDR_in(5);
            Final_Status_Of_Units(2)(0) := Fault_Info_ARBITER_in(0);
            Final_Status_Of_Units(2)(1) := Fault_Info_ARBITER_in(1);
            Final_Status_Of_Units(2)(2) := Fault_Info_ARBITER_in(2);
            Final_Status_Of_Units(2)(3) := Fault_Info_ARBITER_in(3);
            Final_Status_Of_Units(2)(4) := Fault_Info_ARBITER_in(4);
            Final_Status_Of_Units(2)(5) := Fault_Info_ARBITER_in(5);
            Final_Status_Of_Units(3)(0) := Fault_Info_XBAR_in(0);
            Final_Status_Of_Units(3)(1) := Fault_Info_XBAR_in(1);
            Final_Status_Of_Units(3)(2) := Fault_Info_XBAR_in(2);
            Final_Status_Of_Units(3)(3) := Fault_Info_XBAR_in(3);
            Final_Status_Of_Units(3)(4) := Fault_Info_XBAR_in(4);
            Final_Status_Of_Units(3)(5) := Fault_Info_XBAR_in(5);

--            Unit_Is_Binded := (others => (others => '0')); --by default all of them are '0'. and on each clock cyle they are updated.


            --0 => available
            --1 => not available, because of FAULT or because it is ASSIGNED to somwhere


            dir := NORTH;
            if PATH_STATUS_r_DxT(dir)(0) & PATH_STATUS_r_DxT(dir)(1) & PATH_STATUS_r_DxT(dir)(2) & PATH_STATUS_r_DxT(dir)(3) /= Fully_Functional then

                --to find which part of path is damaged  =>  what TYPE of path is damaged
                for TYPE_INDEX in 0 to 3 loop
                    if PATH_STATUS_r_DxT(dir)(TYPE_INDEX) /= '1' then

                        --to find index of available UNIT of this type
                        for UNIT_INDEX in 0 to 5 loop
                            if Final_Status_Of_Units_r_TxU(TYPE_INDEX)(UNIT_INDEX) /= '1' AND PATH_STATUS(dir)(TYPE_INDEX) = '1' then

                                --mark this UNIT as used
                                Unit_Is_Binded(TYPE_INDEX)(UNIT_INDEX) := '1';

                                --mark this part/type of this path as functional
                                PATH_STATUS(dir)(TYPE_INDEX) := '1';

                                --send out proper select signals for MUXes.
                                Input_MUX_UNIT(TYPE_INDEX)(UNIT_INDEX) := STD_LOGIC_VECTOR(TO_UNSIGNED(dir, 3)); --TYPExUNIT
                                Output_MUX_UNIT(TYPE_INDEX)(dir)       := STD_LOGIC_VECTOR(TO_UNSIGNED(UNIT_INDEX, 3)); --TYPExDIR

--                                next;   --to exit this loop

                            --TODO: check if it finishes the array without findind free spare unit. what happens then?
                            --TODO: when does Unit_Is_Binded(x,y) becomes 0 ? when unit is Unbinded? or it is unbinded by defualts? 

                            end if;
                        end loop;
--                        next;           --to exit this loop
                    end if;
                end loop;
            end if;

            Final_Status_Of_Units(0)(0) := Unit_Is_Binded(0)(0) or Fault_Info_FIFO_in(0);
            Final_Status_Of_Units(0)(1) := Unit_Is_Binded(0)(1) or Fault_Info_FIFO_in(1);
            Final_Status_Of_Units(0)(2) := Unit_Is_Binded(0)(2) or Fault_Info_FIFO_in(2);
            Final_Status_Of_Units(0)(3) := Unit_Is_Binded(0)(3) or Fault_Info_FIFO_in(3);
            Final_Status_Of_Units(0)(4) := Unit_Is_Binded(0)(4) or Fault_Info_FIFO_in(4);
            Final_Status_Of_Units(0)(5) := Unit_Is_Binded(0)(5) or Fault_Info_FIFO_in(5);
            Final_Status_Of_Units(1)(0) := Unit_Is_Binded(1)(0) or Fault_Info_LBDR_in(0);
            Final_Status_Of_Units(1)(1) := Unit_Is_Binded(1)(1) or Fault_Info_LBDR_in(1);
            Final_Status_Of_Units(1)(2) := Unit_Is_Binded(1)(2) or Fault_Info_LBDR_in(2);
            Final_Status_Of_Units(1)(3) := Unit_Is_Binded(1)(3) or Fault_Info_LBDR_in(3);
            Final_Status_Of_Units(1)(4) := Unit_Is_Binded(1)(4) or Fault_Info_LBDR_in(4);
            Final_Status_Of_Units(1)(5) := Unit_Is_Binded(1)(5) or Fault_Info_LBDR_in(5);
            Final_Status_Of_Units(2)(0) := Unit_Is_Binded(2)(0) or Fault_Info_ARBITER_in(0);
            Final_Status_Of_Units(2)(1) := Unit_Is_Binded(2)(1) or Fault_Info_ARBITER_in(1);
            Final_Status_Of_Units(2)(2) := Unit_Is_Binded(2)(2) or Fault_Info_ARBITER_in(2);
            Final_Status_Of_Units(2)(3) := Unit_Is_Binded(2)(3) or Fault_Info_ARBITER_in(3);
            Final_Status_Of_Units(2)(4) := Unit_Is_Binded(2)(4) or Fault_Info_ARBITER_in(4);
            Final_Status_Of_Units(2)(5) := Unit_Is_Binded(2)(5) or Fault_Info_ARBITER_in(5);
            Final_Status_Of_Units(3)(0) := Unit_Is_Binded(3)(0) or Fault_Info_XBAR_in(0);
            Final_Status_Of_Units(3)(1) := Unit_Is_Binded(3)(1) or Fault_Info_XBAR_in(1);
            Final_Status_Of_Units(3)(2) := Unit_Is_Binded(3)(2) or Fault_Info_XBAR_in(2);
            Final_Status_Of_Units(3)(3) := Unit_Is_Binded(3)(3) or Fault_Info_XBAR_in(3);
            Final_Status_Of_Units(3)(4) := Unit_Is_Binded(3)(4) or Fault_Info_XBAR_in(4);
            Final_Status_Of_Units(3)(5) := Unit_Is_Binded(3)(5) or Fault_Info_XBAR_in(5);

            Final_Status_Of_Units_r_TxU <= Final_Status_Of_Units;
            Unit_Is_Binded_r_TxU        <= Unit_Is_Binded; --no need to have this register
            PATH_STATUS_r_DxT           <= PATH_STATUS;
            Input_MUX_UNIT_r_TxUxM      <= Input_MUX_UNIT;
            Output_MUX_UNIT_r_TxDxM     <= Output_MUX_UNIT;
        end if;
    end process assigning_UNIT_to_paths;

end architecture RTL;
