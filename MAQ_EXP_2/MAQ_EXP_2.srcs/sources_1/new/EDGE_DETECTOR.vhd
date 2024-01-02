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
    Generic(
        N_MONEDAS: POSITIVE      
    );
    Port(
        CLK : in STD_LOGIC;
        MONEDAS_IN : in STD_LOGIC_VECTOR(N_MONEDAS - 1 downto 0); --  Entrada monedas 
        EDGE_MONEDAS : out STD_LOGIC_VECTOR(N_MONEDAS - 1 downto 0) -- Salida de detecci?n de flanco.
    );
end EDGE_DETECTOR;

architecture Behavioral of EDGE_DETECTOR is
    
    signal PREVIOUS_DATA : STD_LOGIC_VECTOR(N_MONEDAS - 1 downto 0) := (OTHERS => '0');
	begin
    process(CLK)
    
    	begin
        if rising_edge (CLK) then
          if MONEDAS_IN /= PREVIOUS_DATA then
              EDGE_MONEDAS <= MONEDAS_IN;
          else
              EDGE_MONEDAS <= (OTHERS => '0');
          end if;
          PREVIOUS_DATA <= MONEDAS_IN;
        end if;
        
    end process;
end Behavioral;



