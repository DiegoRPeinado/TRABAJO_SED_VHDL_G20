----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2023 14:35:01
-- Design Name: 
-- Module Name: EDGE_DETECTOR - Behavioral
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

entity EDGE_DETECTOR is
    Port (
      CLK : in STD_LOGIC;
      MONEDAS_IN : in STD_LOGIC_VECTOR(3 downto 0); -- 6 bits de señales de entrada.
      EDGE_MONEDAS : out STD_LOGIC_VECTOR(3 downto 0) -- Salida de detección de flanco.
    );
end EDGE_DETECTOR;

architecture Behavioral of EDGE_DETECTOR is
    
    signal previous_data : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	begin
    process(CLK)
    
    	begin
        if rising_edge (CLK) then
          if MONEDAS_IN /= previous_data then
              EDGE_MONEDAS <= MONEDAS_IN;
          else
              EDGE_MONEDAS <= "0000";
          end if;
          previous_data <= MONEDAS_IN;
        end if;
        
    end process;
end Behavioral;




