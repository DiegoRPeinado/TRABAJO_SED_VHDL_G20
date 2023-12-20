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
           ASYNC_MONEDAS: in STD_LOGIC_VECTOR (3 downto 0); 
           ASYNC_PAGAR: in STD_LOGIC;
           ASYNC_TIPO_REFRESCO: in STD_LOGIC;
           SYNCD_MONEDAS: out STD_LOGIC_VECTOR (3 downto 0);
           SYNCD_PAGAR: out STD_LOGIC;
           SYNCD_TIPO_REFRESCO: out STD_LOGIC);
end SYNCHRNZR;

architecture Behavioral of SYNCHRNZR is

    SIGNAL SREG_1_MONEDAS: STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL SREG_1_PAGAR: STD_LOGIC;
    SIGNAL SREG_1_TIPO: STD_LOGIC;
    SIGNAL SREG_2_MONEDAS: STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL SREG_2_PAGAR: STD_LOGIC;
    SIGNAL SREG_2_TIPO: STD_LOGIC;
    
begin

    registro_1:PROCESS(CLK)
    BEGIN
        IF rising_edge(CLK) then
            SREG_1_MONEDAS <= ASYNC_MONEDAS;
            SREG_1_PAGAR <= ASYNC_PAGAR;
            SREG_1_TIPO <= ASYNC_TIPO_REFRESCO;
        END IF;
    END PROCESS;
    
    registro_2:PROCESS(CLK)
    BEGIN
        IF rising_edge(CLK) then
            SREG_2_MONEDAS <= SREG_1_MONEDAS;
            SREG_2_PAGAR <= SREG_1_PAGAR;
            SREG_2_TIPO <= SREG_1_TIPO;
        END IF;
    END PROCESS;
    
    SYNCD_MONEDAS <= SREG_2_MONEDAS;
    SYNCD_PAGAR <= SREG_2_PAGAR;
    SYNCD_TIPO_REFRESCO <= SREG_2_TIPO;
    
end Behavioral;