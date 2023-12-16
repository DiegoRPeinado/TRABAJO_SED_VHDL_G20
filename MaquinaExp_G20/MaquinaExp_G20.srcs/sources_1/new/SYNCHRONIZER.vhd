----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2023 14:35:00
-- Design Name: 
-- Module Name: SYNCHRONIZER - Behavioral
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

entity SYNCHRNZR is
    Port ( CLK : in STD_LOGIC;
           ASYNC_IN: in STD_LOGIC_VECTOR (5 downto 0); -- JUNTAMOS TOODAS LAS SEÑALES EN UNA
           SYNCD_MONEDAS: out STD_LOGIC_VECTOR (3 downto 0);
           SYNCD_PAGAR: out STD_LOGIC;
           SYNCD_TIPO_REFRESCO: out STD_LOGIC);
end SYNCHRNZR;

architecture Behavioral of SYNCHRNZR is

    SIGNAL SREG_1: STD_LOGIC_VECTOR(5 downto 0);
    SIGNAL SREG_2: STD_LOGIC_VECTOR(5 downto 0);
    
begin

    registro_1:PROCESS(CLK)
    BEGIN
        IF rising_edge(CLK) then
            SREG_1 <= ASYNC_IN;
        END IF;
    END PROCESS;
    
    registro_2:PROCESS(CLK)
    BEGIN
        IF rising_edge(CLK) then
            SREG_2 <= SREG_1;
        END IF;
    END PROCESS;
    
    SYNCD_MONEDAS <= SREG_2(3 downto 0);
    SYNCD_PAGAR <= SREG_2(4);
    SYNCD_TIPO_REFRESCO <= SREG_2(5);
    
end Behavioral;