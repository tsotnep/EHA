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
    constant works : std_logic_vector(3 downto 0) := (others => '1');
    constant NORTH : integer                      := 0;
    constant EAST  : integer                      := 1;
    constant WEST  : integer                      := 2;
    constant SOUTH : integer                      := 3;
    constant LOCAL : integer                      := 4;

    signal Available_NORTH_PATH, Available_EAST_PATH, Available_WEST_PATH, Available_SOUTH_PATH, Available_LOCA_PATH, Available_REDU_PATH : std_logic_vector(3 downto 0);
    signal Status_NORTH_PATH, Status_EAST_PATH, Status_WEST_PATH, Status_SOUTH_PATH, Status_LOCA_PATH, Status_REDU_PATH                   : std_logic_vector(3 downto 0);
    signal Assigned_NORTH_PATH, Assigned_EAST_PATH, Assigned_WEST_PATH, Assigned_SOUTH_PATH, Assigned_LOCA_PATH, Assigned_REDU_PATH       : std_logic_vector(3 downto 0);

    --TYPE = what kind of unit are we talking about? : FIFO | LBDR | ARBITER | XBAR
    --UNIT = pool of available number of UNIT for each TYPE, if ther is 1 redundant unit for each type, this number= 5+1;
    --DIRECTION = NORTH, EAST, WEST, SOUTH, LOCAL

    type TYPExUNIT is array (3 downto 0, 5 downto 0) of std_logic;
    type TYPExUNITxMUX is array (3 downto 0, 5 downto 0) of std_logic_vector(2 downto 0);
    type TYPExDIRxMUX is array (3 downto 0, 4 downto 0) of std_logic_vector(2 downto 0);
    type DIRxTYPE is array (4 downto 0) of std_logic_vector(3 downto 0);

    signal Final_Status_Of_Units, Unit_Is_Binded : TYPExUNIT;
    signal PATH_STATUS                           : DIRxTYPE;

    signal Input_MUX_UNIT  : TYPExUNITxMUX;
    signal Output_MUX_UNIT : TYPExDIRxMUX;

begin
    outputting_MUX_Signals : process is
    begin
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

    --    Physical_Availability_Of_UNIT : process(Fault_Info_Arbiter_in(0), Fault_Info_Arbiter_in(1), Fault_Info_Arbiter_in(2), Fault_Info_Arbiter_in(3), Fault_Info_Arbiter_in(4), Fault_Info_Arbiter_in(5), Fault_Info_FIFO_in(0), Fault_Info_FIFO_in(1), Fault_Info_FIFO_in(2
    --        ), Fault_Info_FIFO_in(3), Fault_Info_FIFO_in(4), Fault_Info_FIFO_in(5), Fault_Info_LBDR_in(0), Fault_Info_LBDR_in(1), Fault_Info_LBDR_in(2), Fault_Info_LBDR_in(3), Fault_Info_LBDR_in(4), Fault_Info_LBDR_in(5), Fault_Info_XBAR_in(0), Fault_Info_XBAR_in(1
    --        ), Fault_Info_XBAR_in(2), Fault_Info_XBAR_in(3), Fault_Info_XBAR_in(4), Fault_Info_XBAR_in(5)) is
    --    begin
    --        --1 => available
    --        --0 => not available
    --
    --        Available_NORTH_PATH <= not (Fault_Info_FIFO_in(0) & Fault_Info_LBDR_in(0) & Fault_Info_Arbiter_in(0) & Fault_Info_XBAR_in(0));
    --        Available_EAST_PATH  <= not (Fault_Info_FIFO_in(1) & Fault_Info_LBDR_in(1) & Fault_Info_Arbiter_in(1) & Fault_Info_XBAR_in(1));
    --        Available_WEST_PATH  <= not (Fault_Info_FIFO_in(2) & Fault_Info_LBDR_in(2) & Fault_Info_Arbiter_in(2) & Fault_Info_XBAR_in(2));
    --        Available_SOUTH_PATH <= not (Fault_Info_FIFO_in(3) & Fault_Info_LBDR_in(3) & Fault_Info_Arbiter_in(3) & Fault_Info_XBAR_in(3));
    --        Available_LOCA_PATH  <= not (Fault_Info_FIFO_in(4) & Fault_Info_LBDR_in(4) & Fault_Info_Arbiter_in(4) & Fault_Info_XBAR_in(4));
    --        Available_REDU_PATH  <= not (Fault_Info_FIFO_in(5) & Fault_Info_LBDR_in(5) & Fault_Info_Arbiter_in(5) & Fault_Info_XBAR_in(5));
    --    end process Physical_Availability_Of_UNIT;
    --
--    Status_Of_Paths : process(Assigned_EAST_PATH, Assigned_LOCA_PATH, Assigned_NORTH_PATH, Assigned_SOUTH_PATH, Assigned_WEST_PATH, Available_EAST_PATH, Available_LOCA_PATH, Available_NORTH_PATH, Available_SOUTH_PATH, Available_WEST_PATH) is
--    begin
--        PATH_STATUS(0) <= Assigned_NORTH_PATH OR Available_NORTH_PATH;
--        PATH_STATUS(1) <= Assigned_EAST_PATH OR Available_EAST_PATH;
--        PATH_STATUS(2) <= Assigned_WEST_PATH OR Available_WEST_PATH;
--        PATH_STATUS(3) <= Assigned_SOUTH_PATH OR Available_SOUTH_PATH;
--        PATH_STATUS(4) <= Assigned_LOCA_PATH OR Available_LOCA_PATH;
--    end process Status_Of_Paths;

    assigning_UNIT_to_paths : process(clk) is --, Unit_Is_Binded, Fault_Info_FIFO_in, Fault_Info_LBDR_in, Fault_Info_ARBITER_in, Fault_Info_XBAR_in
    begin
        if rising_edge(clk) then
            --learn what faults do we have and where.
            --0 => available
            --1 => not available, because of FAULT or because it is ASSIGNED to somwhere
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

            if Status_NORTH_PATH /= works then

                --to find out which TYPE of unit is damaged
                for TYPE_INDEX in 0 to 3 loop
                    if Status_NORTH_PATH(TYPE_INDEX) = '0' then

                        --to find available UNIT of this type
                        for UNIT_INTEX in 0 to 5 loop
                            if Final_Status_Of_Units(TYPE_INDEX, UNIT_INTEX) = '0' then
                                --
                                Unit_Is_Binded(TYPE_INDEX, UNIT_INTEX) <= '1';
                                Status_NORTH_PATH(TYPE_INDEX)          <= '1';

                                Input_MUX_UNIT(TYPE_INDEX, UNIT_INTEX) <= STD_LOGIC_VECTOR(TO_UNSIGNED(NORTH, 3)); --TYPExUNIT
                                Output_MUX_UNIT(TYPE_INDEX, NORTH)     <= STD_LOGIC_VECTOR(TO_UNSIGNED(UNIT_INTEX, 3)); --TYPExDIR

                            --TODO: check if it finishes the array without findind free spare.
                            --TODO: when Unit_Is_Binded(x,y) becomes 0 ?
                            end if;
                        end loop;
                    end if;
                end loop;
            end if;

        --TODO: check for other pathes as well, EAST. . . .
        end if;
    end process assigning_UNIT_to_paths;

--TODO: first, we should try to utilize Spare UNIT, instead of combining different paths to get one.
--TODO: second, we after spare UNIT are filled up, we should combine two damaged paths, to get one working path.


end architecture RTL;
