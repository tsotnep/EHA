library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tmr_LBDR is
	generic(
		cur_addr_rst : integer := 8;
		Rxy_rst      : integer := 8;
		Cx_rst       : integer := 8;
		NoC_size     : integer := 4
	);
	port(reset                             : in  std_logic;
		 clk                               : in  std_logic;
		 empty                             : in  std_logic;
		 flit_type                         : in  std_logic_vector(2 downto 0);
		 dst_addr                          : in  std_logic_vector(NoC_size - 1 downto 0);
		 Req_N, Req_E, Req_W, Req_S, Req_L : out std_logic
	);
end entity tmr_LBDR;

architecture BEHAVIOR of tmr_LBDR is
	signal output, input0, input1, input2 : std_logic_vector(4 downto 0);

	signal 
		aReq_N, 
		aReq_E, 
		aReq_W, 
		aReq_S, 
		aReq_L : std_logic;
	signal 
		bReq_N, 
		bReq_E, 
		bReq_W, 
		bReq_S, 
		bReq_L : std_logic;
	signal 
		cReq_N, 
		cReq_E, 
		cReq_W, 
		cReq_S, 
		cReq_L : std_logic;
		
		
begin
	
	
	input0 <= 
		aReq_N &
		aReq_E &
		aReq_W &
		aReq_S &
		aReq_L;	
		
	input1 <= 
		bReq_N &
		bReq_E &
		bReq_W &
		bReq_S &
		bReq_L
		;
	input2 <= 
		cReq_N &
		cReq_E &
		cReq_W &
		cReq_S &
		cReq_L;
				
	
	
	
	
	
	
		Req_N<= output (4); 
		Req_E<= output (3); 
		Req_W<= output (2); 
		Req_S<= output (1); 
		Req_L<= output (0);	
	
		
	
	
	LBDR_inst_a : entity work.LBDR
		generic map(
			cur_addr_rst => cur_addr_rst,
			Rxy_rst      => Rxy_rst,
			Cx_rst       => Cx_rst,
			NoC_size     => NoC_size
		)
		port map(
			reset     => reset,
			clk       => clk,
			empty     => empty,
			flit_type => flit_type,
			dst_addr  => dst_addr,
			Req_N     => aReq_N,
			Req_E     => aReq_E,
			Req_W     => aReq_W,
			Req_S     => aReq_S,
			Req_L     => aReq_L
		);

	LBDR_inst_b : entity work.LBDR
		generic map(
			cur_addr_rst => cur_addr_rst,
			Rxy_rst      => Rxy_rst,
			Cx_rst       => Cx_rst,
			NoC_size     => NoC_size
		)
		port map(
			reset     => reset,
			clk       => clk,
			empty     => empty,
			flit_type => flit_type,
			dst_addr  => dst_addr,
			Req_N     => bReq_N,
			Req_E     => bReq_E,
			Req_W     => bReq_W,
			Req_S     => bReq_S,
			Req_L     => bReq_L
		);

	LBDR_inst_c : entity work.LBDR
		generic map(
			cur_addr_rst => cur_addr_rst,
			Rxy_rst      => Rxy_rst,
			Cx_rst       => Cx_rst,
			NoC_size     => NoC_size
		)
		port map(
			reset     => reset,
			clk       => clk,
			empty     => empty,
			flit_type => flit_type,
			dst_addr  => dst_addr,
			Req_N     => cReq_N,
			Req_E     => cReq_E,
			Req_W     => cReq_W,
			Req_S     => cReq_S,
			Req_L     => cReq_L
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