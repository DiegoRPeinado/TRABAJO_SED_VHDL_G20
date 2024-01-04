library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity PRESCALER_tb is
end;

architecture bench of PRESCALER_tb is

  component PRESCALER
  generic(
      PRESCALER_DIV: POSITIVE      
  );
  Port(
      CLK : in STD_LOGIC;
      CLK_OUT : out STD_LOGIC
  );
  end component;
  constant PRESCALER_DIV: POSITIVE := 2;
  signal CLK: STD_LOGIC;
  signal CLK_OUT: STD_LOGIC ;

  constant clock_period: time := 10 ns;

begin

  uut: PRESCALER generic map ( PRESCALER_DIV => PRESCALER_DIV )
                    port map ( CLK           => CLK,
                               CLK_OUT       => CLK_OUT );
                               
  CLK_TREATMENT: process
  begin

  CLK <= '0';
  wait for 0.5 * clock_period;

  CLK <= '1';
  wait for 0.5 * clock_period;

  end process;

  stimulus: process
  begin
    
    wait for clock_period * 10;

    assert false
    report "Success: simulation finished."
    severity failure;
    
    wait;
    
  end process;
  
end;