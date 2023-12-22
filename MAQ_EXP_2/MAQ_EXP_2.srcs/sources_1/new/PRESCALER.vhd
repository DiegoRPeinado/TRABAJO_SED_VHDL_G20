----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2023 23:39:18
-- Design Name: 
-- Module Name: PRESCALER - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PRESCALER is
    Port ( CLK : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC);
end PRESCALER;

architecture Behavioral of PRESCALER is
signal CLK_BUFFER: STD_LOGIC_VECTOR (18 downto 0):=(others => '0');
begin

process (CLK)
begin
    if rising_edge (CLK) then
        if CLK_BUFFER(CLK_BUFFER'length - 1) = '1' then
            CLK_BUFFER <= (others => '0');
        else
            CLK_BUFFER <= CLK_BUFFER + 1;
        end if;
     end if;
end process;

CLK_OUT <= CLK_BUFFER(CLK_BUFFER'length - 1);

end Behavioral;
