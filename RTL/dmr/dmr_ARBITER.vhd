library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dmr_ARBITER is
    port (  reset: in  std_logic;
            clk: in  std_logic;
            fault_info : in std_logic_vector(1 downto 0);
            Req_N, Req_E, Req_W, Req_S, Req_L:in std_logic; -- From LBDR modules
            DCTS: in std_logic; -- Getting the CTS signal from the input FIFO of the next router/NI (for hand-shaking)

            Grant_N, Grant_E, Grant_W, Grant_S, Grant_L:out std_logic; -- Grants given to LBDR requests (encoded as one-hot)
            Xbar_sel : out std_logic_vector(4 downto 0); -- select lines for XBAR
            RTS: out std_logic -- Valid output which is sent to the next router/NI to specify that the data on the output port is valid
  );
end entity dmr_ARBITER;

architecture BEHAVIOR of dmr_ARBITER is


  signal  output, input0, input1: std_logic_vector(4+1+5 downto 0);


  signal
	  aGrant_N,
	  aGrant_E,
	  aGrant_W,
	  aGrant_S,
	  aGrant_L,
	  aRTS : std_logic;

  signal
	  bGrant_N,
	  bGrant_E,
	  bGrant_W,
	  bGrant_S,
	  bGrant_L,
	  bRTS : std_logic;

	signal aXbar_sel, bXbar_sel : std_logic_vector(4 downto 0);
begin

  input0 <=
  			aXbar_sel&
  			aGrant_N &
  			aGrant_E &
  			aGrant_W &
  			aGrant_S &
  			aGrant_L &
  			aRTS ;

  input1 <=
  			bXbar_sel&
  			bGrant_N &
  			bGrant_E &
  			bGrant_W &
  			bGrant_S &
  			bGrant_L &
  			bRTS ;




RTS        <= output(0);
Grant_L    <= output(1);
Grant_S    <= output(2);
Grant_W    <= output(3);
Grant_E    <= output(4);
Grant_N    <= output(5);
Xbar_sel   <= output(output'length-1 downto 6);




voter_inst : entity work.voter
  generic map(
    DATA_WIDTH => output'length
  )
  port map(
  fault_info => fault_info,
    input0       => input0,
    input1       => input1,
    voted_output => output
  );


	Arbiter_inst_a : entity work.Arbiter
		port map(
			reset    => reset,
			clk      => clk,
			Req_N    => Req_N,
			Req_E    => Req_E,
			Req_W    => Req_W,
			Req_S    => Req_S,
			Req_L    => Req_L,
			DCTS     => DCTS,
			Grant_N  => aGrant_N,
			Grant_E  => aGrant_E,
			Grant_W  => aGrant_W,
			Grant_S  => aGrant_S,
			Grant_L  => aGrant_L,
			Xbar_sel => aXbar_sel,
			RTS      => aRTS
		);


	Arbiter_inst_b : entity work.Arbiter
		port map(
			reset    => reset,
			clk      => clk,
			Req_N    => Req_N,
			Req_E    => Req_E,
			Req_W    => Req_W,
			Req_S    => Req_S,
			Req_L    => Req_L,
			DCTS     => DCTS,
			Grant_N  => bGrant_N,
			Grant_E  => bGrant_E,
			Grant_W  => bGrant_W,
			Grant_S  => bGrant_S,
			Grant_L  => bGrant_L,
			Xbar_sel => bXbar_sel,
			RTS      => bRTS
		);


end architecture BEHAVIOR;
