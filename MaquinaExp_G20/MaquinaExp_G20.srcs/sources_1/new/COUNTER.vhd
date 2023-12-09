----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2023 14:50:24
-- Design Name: 
-- Module Name: COUNTER - Behavioral
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

entity COUNTER is
    Port ( CLK : in STD_LOGIC;
           CE : in STD_LOGIC;
           RESET : in STD_LOGIC;
           TIPO_REFRESCO : IN std_logic;
           MONEDAS : in STD_LOGIC_VECTOR (3 downto 0);
           PAGO_OK : out STD_LOGIC;
           ERROR : out STD_LOGIC);
end COUNTER;

architecture Behavioral of COUNTER is

begin


end Behavioral;
