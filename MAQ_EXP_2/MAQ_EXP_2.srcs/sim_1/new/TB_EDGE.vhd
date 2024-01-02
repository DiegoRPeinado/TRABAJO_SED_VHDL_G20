----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.01.2024 18:27:10
-- Design Name: 
-- Module Name: TB_EDGE - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity EDGE_DETECTOR_tb is
end;

architecture bench of EDGE_DETECTOR_tb is

  component EDGE_DETECTOR
      Generic(
          N_MONEDAS: POSITIVE     
      );
      Port(
          CLK : in STD_LOGIC;
          MONEDAS_IN : in STD_LOGIC_VECTOR(N_MONEDAS - 1 downto 0);
          EDGE_MONEDAS : out STD_LOGIC_VECTOR(N_MONEDAS - 1 downto 0)
      );
  end component;

  signal CLK: STD_LOGIC;
  signal MONEDAS_IN: STD_LOGIC_VECTOR(3 downto 0);
  signal EDGE_MONEDAS: STD_LOGIC_VECTOR(3 downto 0) ;

  constant clock_period: time := 10 ns;

begin

  -- Insert values for generic parameters !!
  uut: EDGE_DETECTOR generic map ( N_MONEDAS    => 4 )
                        port map ( CLK          => CLK,
                                   MONEDAS_IN   => MONEDAS_IN,
                                   EDGE_MONEDAS => EDGE_MONEDAS );
                                   
  CLK_TREATMENT: process
  begin

  CLK <= '0';
  wait for 0.5 * clock_period;

  CLK <= '1';
  wait for 0.5 * clock_period;

  end process;

  stimulus: process
  begin
  
  	MONEDAS_IN <= "0000";
    wait for clock_period * 1;
    
	MONEDAS_IN <= "0100";
    wait for clock_period * 3;
    
    MONEDAS_IN <= "1000";
    wait for clock_period * 3;

    assert false
    report "Success: simulation finished."
    severity failure;

    wait;
  end process;

end;