----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.01.2024 17:35:53
-- Design Name: 
-- Module Name: COUNTER_TB - Behavioral
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

entity COUNTER_tb is
end;

architecture bench of COUNTER_TB is

  component COUNTER 
      Generic(
          N_MONEDAS: POSITIVE;
          N_REFRESCOS: POSITIVE;
          SIZE_CUENTA: POSITIVE      
      );
      Port(
          CLK: in std_logic;
          CE: in std_logic;
          RESET: in std_logic;
          MONEDAS: in std_logic_vector(N_MONEDAS - 1 downto 0);
          TIPO_REFRESCO: in std_logic_vector(N_REFRESCOS - 1 downto 0);
          ERROR: out std_logic;
          PAGO_OK: out std_logic;
          CUENTA: out std_logic_vector(SIZE_CUENTA - 1 downto 0);
          PRECIOS: out std_logic_vector(N_REFRESCOS * SIZE_CUENTA - 1 downto 0);
          REFRESCO_ACTUAL: out std_logic_vector(N_REFRESCOS - 1 downto 0)
     );
  end component;
  
  constant N_MONEDAS: POSITIVE := 4;
  constant N_REFRESCOS: POSITIVE := 2;
  constant SIZE_CUENTA: POSITIVE := 5; 
  signal CLK: std_logic;
  signal CE: std_logic;
  signal RESET: std_logic;
  signal MONEDAS: std_logic_vector(N_MONEDAS - 1 downto 0);
  signal TIPO_REFRESCO: std_logic_vector(N_REFRESCOS - 1 downto 0);
  signal REFRESCO_ACTUAL: std_logic_vector(N_REFRESCOS - 1 downto 0);
  signal ERROR: std_logic;
  signal PAGO_OK: std_logic;
  signal CUENTA: std_logic_vector(SIZE_CUENTA - 1 downto 0);
  signal PRECIOS: std_logic_vector(N_REFRESCOS * SIZE_CUENTA - 1 downto 0);
  constant clock_period: time := 10 ns;

begin

  uut: COUNTER generic map ( N_MONEDAS       => N_MONEDAS,
                             N_REFRESCOS     => N_REFRESCOS,
                             SIZE_CUENTA     => SIZE_CUENTA)
                  port map ( CLK             => CLK,
                             CE              => CE,
                             RESET           => RESET,
                             MONEDAS         => MONEDAS,
                             TIPO_REFRESCO   => TIPO_REFRESCO,
                             ERROR           => ERROR,
                             PAGO_OK         => PAGO_OK,
                             CUENTA          => CUENTA,
                             PRECIOS         => PRECIOS,
                             REFRESCO_ACTUAL => REFRESCO_ACTUAL);
                             
  CLK_TREATMENT: process
  begin

  CLK <= '0';
  wait for 0.5 * clock_period;

  CLK <= '1';
  wait for 0.5 * clock_period;

  end process;
  
  stimulus: process
  begin
  
      RESET <= '0';
      TIPO_REFRESCO <= "01";
      CE <= '1';
      RESET <= '1' after 0.5*clock_period;
    
      wait for 1.5*clock_period;
      MONEDAS <= "0001"; --10cents
      wait for clock_period;
      MONEDAS <= "0010"; --30 cents
      wait for clock_period;
      MONEDAS <= "0100"; -- 80 cents
      wait for clock_period;   
      MONEDAS <= "0010"; -- 1€
      wait for clock_period; 
      MONEDAS <= "0000"; -- Simulamos que la entrada viene del edge detector y que no puede durar más de un ciclo de reloj
      wait for 3*clock_period; 
      
      RESET <= '0';
      TIPO_REFRESCO <= "10";
      wait for clock_period;
      RESET <= '1';
      wait for 2*clock_period;
      
      MONEDAS <= "0100"; --50cents
      wait for clock_period;
      MONEDAS <= "0010"; --70 cents
      wait for clock_period;  
            
      TIPO_REFRESCO <= "01";
      -- DEBERÁ MANTERNER EL PRECIO DEL REFRESCO 10 YA QUE HEMOS EMPEZADO A CONTAR
      
      MONEDAS <= "0100"; -- 1.20 €
      wait for clock_period;   
      MONEDAS <= "0001"; -- 1.30€
      wait for clock_period; 
      MONEDAS <= "0000"; -- Simulamos que la entrada viene del edge detector y que no puede durar más de un ciclo de reloj
      wait for 3*clock_period;
         
      assert false
      report "Success: simulation finished."
      severity failure;

  wait;
  end process;


end;

