----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2023 15:47:37
-- Design Name: 
-- Module Name: FSM - Behavioral
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

entity FSM is
    Port ( CLK : in STD_LOGIC;
           PAGAR : in STD_LOGIC;
           PAGO_OK : in STD_LOGIC;
           ERROR_COUNTER : in STD_LOGIC;
           TIPO_REFRESCO : in STD_LOGIC;
           RESET : in STD_LOGIC;
           ERROR : out STD_LOGIC;
           REFRESCO_OUT : out STD_LOGIC);
end FSM;

architecture Behavioral of FSM is

begin


end Behavioral;
