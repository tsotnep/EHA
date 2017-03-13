--Copyright (C) 2016 Behrad Niazmand

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.ALL;

entity dmr_voter is
    generic (
        DATA_WIDTH: integer := 9
    );
    port (
    fault_info : in std_logic_vector(1 downto 0);
        input0: in std_logic_vector(DATA_WIDTH-1 downto 0);
        input1: in std_logic_vector(DATA_WIDTH-1 downto 0);

        voted_output: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end;

architecture behavior of dmr_voter is

signal S0, S1, S2: std_logic_vector(DATA_WIDTH-1 downto 0);

begin



	voted_output <= input0 when fault_info = "00" else
	          input0 when fault_info = "01" else
	          input1 when fault_info = "10" else
	          input1 when fault_info = "11";

end;
