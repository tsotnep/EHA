library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dmr_FIFO is
    generic (
        DATA_WIDTH: integer := 32
    );
    port (  reset: in  std_logic;
            clk: in  std_logic;
            fault_info : in std_logic_vector(1 downto 0);
            RX: in std_logic_vector(DATA_WIDTH-1 downto 0);
            DRTS: in std_logic;
            read_en_N : in std_logic;
            read_en_E : in std_logic;
            read_en_W : in std_logic;
            read_en_S : in std_logic;
            read_en_L : in std_logic;
            CTS: out std_logic;
            empty_out: out std_logic;
            Data_out: out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end entity dmr_FIFO;

architecture BEHAVIOR of dmr_FIFO is


  signal  output, input0, input1: std_logic_vector(1+1+DATA_WIDTH-1 downto 0);
  signal  aCTS, bCTS : std_logic;
  signal  aempty_out, bempty_out : std_logic;
  signal  aData_out, bData_out : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

  input0 <= aData_out & aCTS & aempty_out ;
  input1 <= aData_out & bCTS & bempty_out ;


  empty_out <=output(0);
  CTS <=output(1);
  Data_out <=output(output'length-1 downto 2);





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




  FIFO_inst_a : entity work.FIFO
    generic map(
      DATA_WIDTH => DATA_WIDTH
    )
    port map(
      reset     => reset,
      clk       => clk,
      RX        => RX,
      DRTS      => DRTS,
      read_en_N => read_en_N,
      read_en_E => read_en_E,
      read_en_W => read_en_W,
      read_en_S => read_en_S,
      read_en_L => read_en_L,

      CTS       => aCTS,
      empty_out => aempty_out,
      Data_out  => aData_out
    );

  FIFO_inst_b : entity work.FIFO
    generic map(
      DATA_WIDTH => DATA_WIDTH
    )
    port map(
      reset     => reset,
      clk       => clk,
      RX        => RX,
      DRTS      => DRTS,
      read_en_N => read_en_N,
      read_en_E => read_en_E,
      read_en_W => read_en_W,
      read_en_S => read_en_S,
      read_en_L => read_en_L,

      CTS       => bCTS,
      empty_out => bempty_out,
      Data_out  => bData_out
    );

end architecture BEHAVIOR;
