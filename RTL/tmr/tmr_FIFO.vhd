library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tmr_FIFO is
    generic (
        DATA_WIDTH: integer := 32
    );
    port (  reset: in  std_logic;
            clk: in  std_logic;
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
end entity tmr_FIFO;

architecture BEHAVIOR of tmr_FIFO is
  

  signal  output, input0, input1, input2 : std_logic_vector(1+1+DATA_WIDTH-1 downto 0);
  signal  aCTS, bCTS, cCTS : std_logic;
  signal  aempty_out, bempty_out, cempty_out : std_logic;
  signal  aData_out, bData_out, cData_out : std_logic_vector(DATA_WIDTH-1 downto 0);
  
begin

  
  input0 <= aData_out & aCTS & aempty_out ;
  input1 <= aData_out & bCTS & bempty_out ;
  input2 <= aData_out & cCTS & cempty_out ;
  
  
  empty_out <=output(0);
  CTS <=output(1);
  Data_out <=output(output'length-1 downto 2);
  
  
  
  
  
  
  
  
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
  FIFO_inst_c : entity work.FIFO
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
      
      CTS       => cCTS,
      empty_out => cempty_out,
      Data_out  => cData_out
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

