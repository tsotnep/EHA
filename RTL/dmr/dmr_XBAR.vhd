library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dmr_XBAR is
    generic (
        DATA_WIDTH: integer := 8
    );
    port (
    fault_info : in std_logic_vector(1 downto 0);
        North_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        East_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        West_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        South_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        Local_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        sel: in std_logic_vector (4 downto 0);
        Data_out: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity dmr_XBAR;

architecture BEHAVIOR of dmr_XBAR is


  signal  output, input0, input1  : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal aData_out, bData_out: std_logic_vector(DATA_WIDTH-1 downto 0);
begin


	input0 <= aData_out;
	input1 <= bData_out;

	Data_out <=output;




voter_inst : entity work.dmr_voter
  generic map(
    DATA_WIDTH => output'length
  )
  port map(
  fault_info => fault_info,
    input0       => input0,
    input1       => input1,
    voted_output => output
  );


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



end architecture BEHAVIOR;
