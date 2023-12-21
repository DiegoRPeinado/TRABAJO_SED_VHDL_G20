----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2023 17:51:11
-- Design Name: 
-- Module Name: DISPLAY_CONTROL - Behavioral
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

entity DISPLAY_CONTROL is
    Port ( CUENTA : in STD_LOGIC_VECTOR (4 downto 0);
           CLK : in STD_LOGIC;
           CODE : out STD_LOGIC_VECTOR (3 downto 0);
           CONTROL : out STD_LOGIC_VECTOR (7 downto 0));
end DISPLAY_CONTROL;

architecture Behavioral of DISPLAY_CONTROL is
signal INTERNAL_CONTROL : STD_LOGIC_VECTOR (7 downto 0):="11111110";
begin
process(CLK)

begin
    IF rising_edge (CLK) THEN 
        CASE INTERNAL_CONTROL IS 
            WHEN "11111110" =>
                INTERNAL_CONTROL <= "11111101";
                CODE <= "0000"; -- SIEMPRE VALE 0 EL PRIMER SEGMENTO (A LA DERECHA)
            WHEN "11111101" =>
                INTERNAL_CONTROL <= "11111011";
                IF CUENTA > "01001" THEN
                    CODE <= "0000";
                ELSE CODE <= CUENTA (3 DOWNTO 0);
                END IF;
            WHEN "11111011" =>
                INTERNAL_CONTROL <= "11110111";
                IF CUENTA > "01001" THEN
                    CODE <= "0001";
                ELSE CODE <= "0000";
                END IF;
            WHEN OTHERS =>
                INTERNAL_CONTROL <= "11111110";
                CODE <= "0000";
        END CASE;
    END IF; 
CONTROL <= INTERNAL_CONTROL;                 
end process;
end Behavioral;
