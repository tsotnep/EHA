library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tmr_XBAR is
    generic (
        DATA_WIDTH: integer := 8
    );
    port (
        North_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        East_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        West_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        South_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        Local_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        sel: in std_logic_vector (4 downto 0);
        Data_out: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity tmr_XBAR;

architecture BEHAVIOR of tmr_XBAR is
  

  signal  output, input0, input1, input2 : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal aData_out, bData_out, cData_out: std_logic_vector(DATA_WIDTH-1 downto 0);
begin
	
	
	input0 <= aData_out;
	input1 <= bData_out;
	input2 <= cData_out;
	Data_out <=output; 
	
	
	
	
	

XBAR_insta : entity work.XBAR
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map(
		North_in => North_in,
		East_in  => East_in,
		West_in  => West_in,
		South_in => South_in,
		Local_in => Local_in,
		sel      => sel,
		Data_out => aData_out
	);
	
	

XBAR_instb : entity work.XBAR
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map(
		North_in => North_in,
		East_in  => East_in,
		West_in  => West_in,
		South_in => South_in,
		Local_in => Local_in,
		sel      => sel,
		Data_out => bData_out
	);
	

XBAR_instc : entity work.XBAR
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map(
		North_in => North_in,
		East_in  => East_in,
		West_in  => West_in,
		South_in => South_in,
		Local_in => Local_in,
		sel      => sel,
		Data_out => cData_out
	);
  voter_inst : entity work.voter
    generic map(
      DATA_WIDTH => output'length
    )
    port map(
      input0       => input0,
      input1       => input1,
      input2       => input2,
      voted_output => output
    );
end architecture BEHAVIOR;