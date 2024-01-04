----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.01.2024 14:41:21
-- Design Name: 
-- Module Name: SYNCHRNZR_TB - Behavioral
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

entity SYNCHRNZR_tb is
end;

architecture bench of SYNCHRNZR_tb is

  component SYNCHRNZR
      Generic(
          N_MONEDAS: POSITIVE; 
          N_REFRESCOS: POSITIVE    
      );
      Port(
          CLK : in STD_LOGIC;
          ASYNC_MONEDAS: in STD_LOGIC_VECTOR (N_MONEDAS - 1 downto 0); 
          ASYNC_PAGAR: in STD_LOGIC;
          ASYNC_TIPO_REFRESCO: in STD_LOGIC_VECTOR (N_REFRESCOS - 1 downto 0);
          SYNCD_MONEDAS: out STD_LOGIC_VECTOR (N_MONEDAS - 1 downto 0);
          SYNCD_PAGAR: out STD_LOGIC;
          SYNCD_TIPO_REFRESCO: out STD_LOGIC_VECTOR (N_REFRESCOS - 1 downto 0)
       );
  end component;
  constant N_MONEDAS : POSITIVE := 4;
  constant N_REFRESCOS : POSITIVE := 2;
  signal CLK: STD_LOGIC;
  signal ASYNC_MONEDAS: STD_LOGIC_VECTOR (N_MONEDAS - 1 downto 0);
  signal ASYNC_PAGAR: STD_LOGIC;
  signal ASYNC_TIPO_REFRESCO: STD_LOGIC_VECTOR (N_REFRESCOS - 1 downto 0);
  signal SYNCD_MONEDAS: STD_LOGIC_VECTOR (N_MONEDAS - 1 downto 0);
  signal SYNCD_PAGAR: STD_LOGIC;
  signal SYNCD_TIPO_REFRESCO: STD_LOGIC_VECTOR (N_REFRESCOS - 1 downto 0);

  constant clock_period: time := 10 ns;

begin

  -- Insert values for generic parameters !!
  uut: SYNCHRNZR generic map ( N_REFRESCOS         => N_REFRESCOS,
                               N_MONEDAS           => N_MONEDAS )
                    port map ( CLK                 => CLK,
                               ASYNC_MONEDAS       => ASYNC_MONEDAS,
                               ASYNC_PAGAR         => ASYNC_PAGAR,
                               ASYNC_TIPO_REFRESCO => ASYNC_TIPO_REFRESCO,
                               SYNCD_MONEDAS       => SYNCD_MONEDAS,
                               SYNCD_PAGAR         => SYNCD_PAGAR,
                               SYNCD_TIPO_REFRESCO => SYNCD_TIPO_REFRESCO );

CLK_TREATMENT: process
  begin

  CLK <= '0';
  wait for 0.5 * clock_period;

  CLK <= '1';
  wait for 0.5 * clock_period;

end process;

stimulus: process
  begin
  
	ASYNC_MONEDAS <= "0000";
	ASYNC_PAGAR <= '0';
	ASYNC_TIPO_REFRESCO <= "00";
    wait for clock_period * 1.25;
    
    ASYNC_MONEDAS <= "0100";
	ASYNC_PAGAR <= '1';
	ASYNC_TIPO_REFRESCO <= "10";
    wait for clock_period * 2.25; 
    
    assert SYNCD_MONEDAS = "0100"
    	report "SYNCD_MONEDAS should be 0100.";
    assert SYNCD_PAGAR = '1'
    	report "SYNCD_PAGAR should be '1'.";
    assert SYNCD_TIPO_REFRESCO = "10"
    	report "SYNCD_TIPO_REFRESCO should be '10'.";
    
    ASYNC_MONEDAS <= "0001";
    ASYNC_PAGAR <= '0';
    ASYNC_TIPO_REFRESCO <= "01";
    wait for clock_period * 2.25;
   
    assert SYNCD_MONEDAS = "0001"
    	report "SYNCD_MONEDAS should be 0001.";
    assert SYNCD_PAGAR = '0'
    	report "SYNCD_PAGAR should be '0'.";
    assert SYNCD_TIPO_REFRESCO = "01"
    	report "SYNCD_TIPO_REFRESCO should be '01'.";
    
    wait for clock_period*2;
    
   assert false
   report "Success: simulation finished."
   severity failure;
   wait;
    
end process;

end;
