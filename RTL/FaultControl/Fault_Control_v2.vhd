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
    --    shared variable Fault_Information_Array : TYPESxUNIT;
    shared variable Unit_Is_Binded   : TYPESxUNIT;
    signal Fault_Information_Array_r : TYPESxUNIT;
    signal Unit_Is_Binded_r          : TYPESxUNIT;

    subtype TYPES is std_logic_vector(3 downto 0);
    type DIRxTYPES is array (4 downto 0) of TYPES;
    shared variable PATH_STATUS : DIRxTYPES;
    signal PATH_STATUS_r        : DIRxTYPES;

    subtype MUX is std_logic_vector(2 downto 0);
    type UNITxMUX is array (5 downto 0) of MUX;
    type DIRxMUX is array (4 downto 0) of MUX;

    type TYPExUNITxMUX is array (3 downto 0) of UNITxMUX;
    shared variable Input_MUX_UNIT : TYPExUNITxMUX;
    signal Input_MUX_UNIT_r        : TYPExUNITxMUX;

    type TYPExDIRxMUX is array (3 downto 0) of DIRxMUX;
    shared variable Output_MUX_UNIT : TYPExDIRxMUX;
    signal Output_MUX_UNIT_r        : TYPExDIRxMUX;

--    procedure find_and_fix(
--        variable dir             : in    integer;
--        variable Unit_Is_Binded  : inout TYPESxUNIT;
--        variable PATH_STATUS     : inout DIRxTYPES;
--        signal Unit_Is_Binded_r  : out   TYPESxUNIT;
--        signal Input_MUX_UNIT_r  : out   TYPExUNITxMUX;
--        signal Output_MUX_UNIT_r : out   TYPExDIRxMUX) is
--    begin
--        for TYPE_INDEX in 0 to 3 loop
--            for UNIT_INDEX in 0 to 5 loop
--                if Fault_Information_Array(TYPE_INDEX)(UNIT_INDEX) /= '1' --
--                AND Unit_Is_Binded(TYPE_INDEX)(UNIT_INDEX) /= '1' --
--                AND PATH_STATUS(dir)(TYPE_INDEX) /= '1' then --
--                    Unit_Is_Binded(TYPE_INDEX)(UNIT_INDEX)   := '1';
--                    PATH_STATUS(dir)(TYPE_INDEX)             := '1';
--                    Input_MUX_UNIT_r(TYPE_INDEX)(UNIT_INDEX) <= STD_LOGIC_VECTOR(TO_UNSIGNED(dir, 3));
--                    Output_MUX_UNIT_r(TYPE_INDEX)(dir)       <= STD_LOGIC_VECTOR(TO_UNSIGNED(UNIT_INDEX, 3));
--
--                    Unit_Is_Binded_r(TYPE_INDEX)(UNIT_INDEX) <= Unit_Is_Binded(TYPE_INDEX)(UNIT_INDEX);
--                    if UNIT_INDEX = 5 and PATH_STATUS(dir)(TYPE_INDEX) = '0' then
--                        Input_MUX_UNIT_r(TYPE_INDEX)(UNIT_INDEX) <= "XXX";
--                        Output_MUX_UNIT_r(TYPE_INDEX)(dir)       <= "XXX";
--                    end if;
--                end if;
--            end loop;
--        end loop;
--    end find_and_fix;


begin
    --    outputting_MUX_Signals : process is
    --    begin
    MUX_5x1_FIFO_input_select_N_out  <= Input_MUX_UNIT_r(0)(0);
    MUX_5x1_FIFO_input_select_E_out  <= Input_MUX_UNIT_r(0)(1);
    MUX_5x1_FIFO_input_select_W_out  <= Input_MUX_UNIT_r(0)(2);
    MUX_5x1_FIFO_input_select_S_out  <= Input_MUX_UNIT_r(0)(3);
    MUX_5x1_FIFO_input_select_L_out  <= Input_MUX_UNIT_r(0)(4);
    MUX_5x1_FIFO_input_select_R_out  <= Input_MUX_UNIT_r(0)(5);
    MUX_6x1_FIFO_output_select_N_out <= Output_MUX_UNIT_r(0)(0);
    MUX_6x1_FIFO_output_select_E_out <= Output_MUX_UNIT_r(0)(1);
    MUX_6x1_FIFO_output_select_W_out <= Output_MUX_UNIT_r(0)(2);
    MUX_6x1_FIFO_output_select_S_out <= Output_MUX_UNIT_r(0)(3);
    MUX_6x1_FIFO_output_select_L_out <= Output_MUX_UNIT_r(0)(4);

    MUX_5x1_LBDR_input_select_N_out  <= Input_MUX_UNIT_r(0)(0);
    MUX_5x1_LBDR_input_select_E_out  <= Input_MUX_UNIT_r(0)(1);
    MUX_5x1_LBDR_input_select_W_out  <= Input_MUX_UNIT_r(0)(2);
    MUX_5x1_LBDR_input_select_S_out  <= Input_MUX_UNIT_r(0)(3);
    MUX_5x1_LBDR_input_select_L_out  <= Input_MUX_UNIT_r(0)(4);
    MUX_5x1_LBDR_input_select_R_out  <= Input_MUX_UNIT_r(0)(5);
    MUX_6x1_LBDR_output_select_N_out <= Output_MUX_UNIT_r(0)(0);
    MUX_6x1_LBDR_output_select_E_out <= Output_MUX_UNIT_r(0)(1);
    MUX_6x1_LBDR_output_select_W_out <= Output_MUX_UNIT_r(0)(2);
    MUX_6x1_LBDR_output_select_S_out <= Output_MUX_UNIT_r(0)(3);
    MUX_6x1_LBDR_output_select_L_out <= Output_MUX_UNIT_r(0)(4);

    MUX_5x1_Arbiter_input_select_N_out  <= Input_MUX_UNIT_r(0)(0);
    MUX_5x1_Arbiter_input_select_E_out  <= Input_MUX_UNIT_r(0)(1);
    MUX_5x1_Arbiter_input_select_W_out  <= Input_MUX_UNIT_r(0)(2);
    MUX_5x1_Arbiter_input_select_S_out  <= Input_MUX_UNIT_r(0)(3);
    MUX_5x1_Arbiter_input_select_L_out  <= Input_MUX_UNIT_r(0)(4);
    MUX_5x1_Arbiter_input_select_R_out  <= Input_MUX_UNIT_r(0)(5);
    MUX_6x1_Arbiter_output_select_N_out <= Output_MUX_UNIT_r(0)(0);
    MUX_6x1_Arbiter_output_select_E_out <= Output_MUX_UNIT_r(0)(1);
    MUX_6x1_Arbiter_output_select_W_out <= Output_MUX_UNIT_r(0)(2);
    MUX_6x1_Arbiter_output_select_S_out <= Output_MUX_UNIT_r(0)(3);
    MUX_6x1_Arbiter_output_select_L_out <= Output_MUX_UNIT_r(0)(4);

    MUX_5x1_XBAR_input_select_N_out  <= Input_MUX_UNIT_r(0)(0);
    MUX_5x1_XBAR_input_select_E_out  <= Input_MUX_UNIT_r(0)(1);
    MUX_5x1_XBAR_input_select_W_out  <= Input_MUX_UNIT_r(0)(2);
    MUX_5x1_XBAR_input_select_S_out  <= Input_MUX_UNIT_r(0)(3);
    MUX_5x1_XBAR_input_select_L_out  <= Input_MUX_UNIT_r(0)(4);
    MUX_5x1_XBAR_input_select_R_out  <= Input_MUX_UNIT_r(0)(5);
    MUX_6x1_XBAR_output_select_N_out <= Output_MUX_UNIT_r(0)(0);
    MUX_6x1_XBAR_output_select_E_out <= Output_MUX_UNIT_r(0)(1);
    MUX_6x1_XBAR_output_select_W_out <= Output_MUX_UNIT_r(0)(2);
    MUX_6x1_XBAR_output_select_S_out <= Output_MUX_UNIT_r(0)(3);
    MUX_6x1_XBAR_output_select_L_out <= Output_MUX_UNIT_r(0)(4);
    --    end process outputting_MUX_Signals;


    --learn what faults do we have and where.
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

    assigning_UNIT_to_paths : process(clk) is --, Unit_Is_Binded, Fault_Info_FIFO_in, Fault_Info_LBDR_in, Fault_Info_ARBITER_in, Fault_Info_XBAR_in
        variable dir : integer;
    begin
        if rising_edge(clk) then
            --            Input_MUX_UNIT_r  <= Input_MUX_UNIT;
            --            Output_MUX_UNIT_r <= Output_MUX_UNIT;
            PATH_STATUS_r     <= PATH_STATUS;
            Input_MUX_UNIT_r  <= (others => (others => "000"));
            Output_MUX_UNIT_r <= (others => (others => "000"));
            PATH_STATUS       := (others => (others => '0'));
            Unit_Is_Binded    := (others => (others => '0')); --by default all of them are '0'. and on each clock cyle they are updated.

            dir := EAST;
            
            if PATH_STATUS(dir)(0) & PATH_STATUS(dir)(1) & PATH_STATUS(dir)(2) & PATH_STATUS(dir)(3) /= Fully_Functional then
                for TYPE_INDEX in 0 to 3 loop
                    for UNIT_INDEX in 0 to 5 loop
                        if Fault_Information_Array_r(TYPE_INDEX)(UNIT_INDEX) /= '1' --
                        AND Unit_Is_Binded(TYPE_INDEX)(UNIT_INDEX) /= '1' --
                        AND PATH_STATUS(dir)(TYPE_INDEX) /= '1' then --
                            Unit_Is_Binded(TYPE_INDEX)(UNIT_INDEX)   := '1';
                            PATH_STATUS(dir)(TYPE_INDEX)             := '1';
                            Input_MUX_UNIT_r(TYPE_INDEX)(UNIT_INDEX) <= STD_LOGIC_VECTOR(TO_UNSIGNED(dir, 3));
                            Output_MUX_UNIT_r(TYPE_INDEX)(dir)       <= STD_LOGIC_VECTOR(TO_UNSIGNED(UNIT_INDEX, 3));

                            --                            Unit_Is_Binded_r(TYPE_INDEX)(UNIT_INDEX) <= Unit_Is_Binded(TYPE_INDEX)(UNIT_INDEX);
                            if UNIT_INDEX = 5 and PATH_STATUS(dir)(TYPE_INDEX) = '0' then
                                Input_MUX_UNIT_r(TYPE_INDEX)(UNIT_INDEX) <= "XXX";
                                Output_MUX_UNIT_r(TYPE_INDEX)(dir)       <= "XXX";
                            end if;

                        end if;
                    end loop;
                end loop;
                Unit_Is_Binded_r <= Unit_Is_Binded;
            end if;
        end if;
    end process assigning_UNIT_to_paths;

end architecture RTL;

--    procedure find_and_fix(
--        variable dir             : in    integer;
--        variable Unit_Is_Binded  : inout TYPESxUNIT;
--        variable PATH_STATUS     : inout DIRxTYPES;
--        signal Unit_Is_Binded_r  : out   TYPESxUNIT;
--        signal Input_MUX_UNIT_r  : out   TYPExUNITxMUX;
--        signal Output_MUX_UNIT_r : out   TYPExDIRxMUX) is
--    begin
--        for TYPE_INDEX in 0 to 3 loop
--            for UNIT_INDEX in 0 to 5 loop
--                if Fault_Information_Array(TYPE_INDEX)(UNIT_INDEX) /= '1' --
--                AND Unit_Is_Binded(TYPE_INDEX)(UNIT_INDEX) /= '1' --
--                AND PATH_STATUS(dir)(TYPE_INDEX) /= '1' then --
--                    Unit_Is_Binded(TYPE_INDEX)(UNIT_INDEX)   := '1';
--                    PATH_STATUS(dir)(TYPE_INDEX)             := '1';
--                    Input_MUX_UNIT_r(TYPE_INDEX)(UNIT_INDEX) <= STD_LOGIC_VECTOR(TO_UNSIGNED(dir, 3));
--                    Output_MUX_UNIT_r(TYPE_INDEX)(dir)       <= STD_LOGIC_VECTOR(TO_UNSIGNED(UNIT_INDEX, 3));
--
--                    Unit_Is_Binded_r(TYPE_INDEX)(UNIT_INDEX) <= Unit_Is_Binded(TYPE_INDEX)(UNIT_INDEX);
--                    if UNIT_INDEX = 5 and PATH_STATUS(dir)(TYPE_INDEX) = '0' then
--                        Input_MUX_UNIT_r(TYPE_INDEX)(UNIT_INDEX) <= "XXX";
--                        Output_MUX_UNIT_r(TYPE_INDEX)(dir)       <= "XXX";
--                    end if;
--                end if;
--            end loop;
--        end loop;
--    end find_and_fix;


--        if rising_edge(clk) then
--            --            Input_MUX_UNIT_r  <= Input_MUX_UNIT;
--            --            Output_MUX_UNIT_r <= Output_MUX_UNIT;
--            PATH_STATUS_r <= PATH_STATUS;
--
--            Unit_Is_Binded := (others => (others => '0')); --by default all of them are '0'. and on each clock cyle they are updated.
--
--            dir := NORTH;
--            if PATH_STATUS(dir)(0) & PATH_STATUS(dir)(1) & PATH_STATUS(dir)(2) & PATH_STATUS(dir)(3) /= Fully_Functional then
--                find_and_fix(dir, Unit_Is_Binded, PATH_STATUS, Unit_Is_Binded_r, Input_MUX_UNIT_r, Output_MUX_UNIT_r);
--            else
--                dir := EAST;
--                if PATH_STATUS(dir)(0) & PATH_STATUS(dir)(1) & PATH_STATUS(dir)(2) & PATH_STATUS(dir)(3) /= Fully_Functional then
--                    find_and_fix(dir, Unit_Is_Binded, PATH_STATUS, Unit_Is_Binded_r, Input_MUX_UNIT_r, Output_MUX_UNIT_r);
--                else
--                    dir := WEST;
--                    if PATH_STATUS(dir)(0) & PATH_STATUS(dir)(1) & PATH_STATUS(dir)(2) & PATH_STATUS(dir)(3) /= Fully_Functional then
--                        find_and_fix(dir, Unit_Is_Binded, PATH_STATUS, Unit_Is_Binded_r, Input_MUX_UNIT_r, Output_MUX_UNIT_r);
--                    else
--                        dir := SOUTH;
--                        if PATH_STATUS(dir)(0) & PATH_STATUS(dir)(1) & PATH_STATUS(dir)(2) & PATH_STATUS(dir)(3) /= Fully_Functional then
--                            find_and_fix(dir, Unit_Is_Binded, PATH_STATUS, Unit_Is_Binded_r, Input_MUX_UNIT_r, Output_MUX_UNIT_r);
--                        else
--                            dir := LOCAL;
--                            if PATH_STATUS(dir)(0) & PATH_STATUS(dir)(1) & PATH_STATUS(dir)(2) & PATH_STATUS(dir)(3) /= Fully_Functional then
--                                find_and_fix(dir, Unit_Is_Binded, PATH_STATUS, Unit_Is_Binded_r, Input_MUX_UNIT_r, Output_MUX_UNIT_r);
--                            end if;
--                        end if;
--                    end if;
--                end if;
--            end if;
--        end if;
