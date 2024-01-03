----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2023 15:48:58
-- Design Name: 
-- Module Name: TESTBENCH - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

entity TESTBENCH is
end;

architecture bench of TESTBENCH is

  component MAQ_EXP
    Generic(
        N_MONEDAS: POSITIVE;
        N_REFRESCOS: POSITIVE;
        N_ESTADOS: POSITIVE;
        N_SEGMENTOS: POSITIVE;
        N_DISPLAYS: POSITIVE; -- 8 más el punto decimal
        SIZE_CUENTA: POSITIVE;
        SIZE_CODE: POSITIVE     
    );
    
    Port(
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        PAGAR : in STD_LOGIC;
        MONEDAS : in STD_LOGIC_VECTOR (N_MONEDAS - 1 downto 0);
        TIPO_REFRESCO : in STD_LOGIC_VECTOR (N_REFRESCOS - 1 downto 0);
        ERROR : out STD_LOGIC;
        REFRESCO_OUT : out STD_LOGIC;
        ESTADOS: out STD_LOGIC_VECTOR (N_ESTADOS - 1 downto 0);
        LED_AUX5: out STD_LOGIC;
        LED_RESET: out STD_LOGIC;
        SEGMENTOS: out STD_LOGIC_VECTOR(N_SEGMENTOS - 1 downto 0);
        DIGCTRL: out STD_LOGIC_VECTOR(N_DISPLAYS - 1 downto 0)
     );
  end component;

  signal CLK: STD_LOGIC;
  signal RESET: STD_LOGIC;
  signal PAGAR: STD_LOGIC;
  signal MONEDAS: STD_LOGIC_VECTOR (3 downto 0);
  signal TIPO_REFRESCO: STD_LOGIC_VECTOR (2 - 1 downto 0);
  signal ERROR: STD_LOGIC;
  signal REFRESCO_OUT: STD_LOGIC;
  signal ESTADOS: std_logic_vector (3 downto 0);
  signal LED_AUX5: STD_LOGIC;
  signal LED_RESET: STD_LOGIC;
  signal SEGMENTOS: STD_LOGIC_VECTOR(6 downto 0);
  signal DIGCTRL: STD_LOGIC_VECTOR(8 downto 0);

  
  constant clock_period: time := 10 ns;

begin

  uut: MAQ_EXP
                          GENERIC map ( 
                          N_MONEDAS           => 4,
                          N_ESTADOS           => 4,
                          N_REFRESCOS         => 2,
                          N_SEGMENTOS         => 7,                          
                          N_DISPLAYS          => 9, 
                          SIZE_CUENTA         => 5, 
                          SIZE_CODE           => 5
                          )  
                                                  
                          port map ( CLK           => CLK,
                          RESET         => RESET,
                          PAGAR         => PAGAR,
                          MONEDAS       => MONEDAS,
                          TIPO_REFRESCO => TIPO_REFRESCO,
                          ERROR         => ERROR,
                          REFRESCO_OUT  => REFRESCO_OUT,
                          ESTADOS       => ESTADOS,
                          LED_AUX5      => LED_AUX5,
                          LED_RESET     => LED_RESET,
                          SEGMENTOS     => SEGMENTOS,
                          DIGCTRL       => DIGCTRL
                          );         
                                        
   CLK_TREATMENT: process
   begin

   CLK <= '0';
   wait for 0.5 * clock_period;

   CLK <= '1';
   wait for 0.5 * clock_period;

   end process;

  stimulus: process
  begin
  
    -- Put initialisation code here
	RESET <= '0';
    wait for 5 ns;
    RESET <= '1';
    wait for 5 ns;
    
	PAGAR <= '1';
    TIPO_REFRESCO <= "01";
    wait for clock_period;
    
    MONEDAS <= "0010";
    wait for clock_period*2;
    MONEDAS <= "0100";
    wait for clock_period*2;
    MONEDAS <= "0010";
    wait for clock_period*2;
    MONEDAS <= "0001";
    wait for clock_period*2;
    MONEDAS <= "0100";
    wait for clock_period*2;
    PAGAR <= '0';
    
    wait for clock_period * 8;

    -- Put test bench stimulus code here
    
    assert false
    report "Success: simulation finished."
    severity failure;

    wait;
  end process;


end;

