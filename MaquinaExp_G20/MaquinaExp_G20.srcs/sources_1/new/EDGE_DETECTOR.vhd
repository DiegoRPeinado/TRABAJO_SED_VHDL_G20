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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EDGE_DETECTOR is
    Port (
        CLK : in STD_LOGIC;
        ASYNC_IN : in STD_LOGIC_VECTOR(5 downto 0); -- 6 bits de señales de entrada.
        EDGE_DETECTED : out STD_LOGIC_VECTOR(5 downto 0) -- Salida de detección de flanco.
    );
end EDGE_DETECTOR;

architecture Behavioral of EDGE_DETECTOR is
    
    signal prev_async_in : STD_LOGIC_VECTOR(5 downto 0);
begin
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            -- Detecta el flanco comparando la entrada actual con el estado anterior.
            EDGE_DETECTED <= ASYNC_IN and not prev_async_in;
            -- Actualiza el estado anterior con el estado actual.
            prev_async_in <= ASYNC_IN;
        end if;
    end process;
end Behavioral;




