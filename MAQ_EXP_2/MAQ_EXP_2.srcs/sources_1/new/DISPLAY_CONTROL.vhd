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
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DISPLAY_CONTROL is
    Generic(
        SIZE_CUENTA: POSITIVE;
        SIZE_CODE: POSITIVE;
        N_DISPLAYS: POSITIVE
    );
    Port(
        CUENTA : in STD_LOGIC_VECTOR (SIZE_CUENTA - 1 downto 0);
        CLK : in STD_LOGIC;
        CODE : out STD_LOGIC_VECTOR (SIZE_CODE - 1 downto 0);
        CONTROL : out STD_LOGIC_VECTOR (N_DISPLAYS - 1 downto 0)
    );
end DISPLAY_CONTROL;

architecture Behavioral of DISPLAY_CONTROL is
signal INTERNAL_CONTROL : STD_LOGIC_VECTOR (N_DISPLAYS - 2 downto 0):="11111110";
signal DP : STD_LOGIC := '0';
begin
process(CLK)

begin
    IF rising_edge (CLK) THEN 
        CASE INTERNAL_CONTROL IS 
            WHEN "11111110" =>
                INTERNAL_CONTROL <= "11111101";
                IF CUENTA = "00000" THEN
                    CODE <= "0000";
                ELSE 
                    CODE <= "0101" - CUENTA (3 DOWNTO 0);
                END IF;
                DP <= '1';
            WHEN "11111101" =>
                INTERNAL_CONTROL <= "11111011";
              IF CUENTA = "00000" THEN
                    CODE <= "0001";
                ELSE CODE <= "0000";
                END IF;
                DP <= '0'; 
            WHEN "11111011" =>
                INTERNAL_CONTROL <= "11101111";
                CODE <= "0000"; 
                DP <= '1';
            WHEN "11101111" =>
                INTERNAL_CONTROL <= "11011111";
                CODE <= "0000"; 
                DP <= '1';
            WHEN "11011111" =>
                INTERNAL_CONTROL <= "10111111";
                CODE <= "0001"; 
                DP <= '0';
            WHEN OTHERS =>
                INTERNAL_CONTROL <= "11111110";
                CODE <= "0000";
                DP <= '1';
        END CASE;
    END IF; 
CONTROL <= DP & INTERNAL_CONTROL;                 
end process;
end Behavioral;
