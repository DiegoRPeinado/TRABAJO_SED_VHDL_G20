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
        N_ESTADOS: POSITIVE;
        N_DISPLAYS: POSITIVE
    );
    Port(
        CUENTA : in STD_LOGIC_VECTOR (SIZE_CUENTA - 1 downto 0);
        CLK : in STD_LOGIC;
        CODE : out STD_LOGIC_VECTOR (SIZE_CODE - 1 downto 0);
        CONTROL : out STD_LOGIC_VECTOR (N_DISPLAYS * N_ESTADOS - 1 downto 0)
    );
end DISPLAY_CONTROL;

architecture Behavioral of DISPLAY_CONTROL is

-- SE DEFINE UN VECTOR DE CONTROL DE SEGMENTOS PARA CADA ESTADO
subtype CONTROL_ESTADO is STD_LOGIC_VECTOR(N_DISPLAYS - 1 downto 0);

-- SE DEFINE EL ARRAY QUE CONTENDRÁ TODOS LOS CONTROLES DE ESTADO 
type CONTROL_TOTAL is ARRAY (0 to N_ESTADOS - 1) of CONTROL_ESTADO;

-- CREAMOS LAS SEÑALES 
signal CONTROL_SIG : CONTROL_TOTAL;
signal CODE_SIG : STD_LOGIC_VECTOR (SIZE_CODE - 1 downto 0);

begin

process(CLK)
begin
    IF rising_edge (CLK) THEN 
    
        CASE CONTROL_SIG(0) IS
            WHEN "111011111" =>
                CONTROL_SIG(0) <= "110111111";
                CODE_SIG <= "10100"; -- LETRA L
            WHEN "110111111" =>
                CONTROL_SIG(0) <= "101111111";
                CODE_SIG <= "10001"; -- LETRA d
            WHEN "101111111" =>
                CONTROL_SIG(0) <= "011111111";
                CODE_SIG <= "00001"; -- LETRA I/1
            WHEN OTHERS =>
                CONTROL_SIG(0) <= "111011111";
                CODE_SIG <= "10010"; -- LETRA E           
        END CASE;
        
        CASE CONTROL_SIG(1) IS 
            WHEN "111111101" =>
                CONTROL_SIG(1) <= "111111011";
                IF CUENTA = "00000" THEN
                    CODE_SIG <= "00000";
                ELSE 
                    CODE_SIG <= "01010" - CUENTA (3 DOWNTO 0);
                END IF;
                --DP <= '1';
            WHEN "111111011" =>
                CONTROL_SIG(1) <= "111110110";
                IF CUENTA = "00000" THEN
                    CODE_SIG <= "00001";
                ELSE CODE_SIG <= "00000";
                END IF;
                --DP <= '0'; 
            WHEN "111110110" =>
                CONTROL_SIG(1) <= "111011111";
                CODE_SIG <= "00000"; 
                --DP <= '1';
            WHEN "111011111" =>
                CONTROL_SIG(1) <= "110111111";
                CODE_SIG <= "00000"; 
                --DP <= '1';
            WHEN "110111111" =>
                CONTROL_SIG(1) <= "101111110";
                CODE_SIG <= "00001"; 
                --DP <= '0';
            WHEN OTHERS =>
                CONTROL_SIG(1) <= "111111101";
                CODE_SIG <= "00000";
                --DP <= '1';
        END CASE;
        
        CASE CONTROL_SIG(2) IS
            WHEN "111011111" =>
                CONTROL_SIG(2) <= "110111111";
                CODE_SIG <= "11000"; -- LETRA T
            WHEN "110111111" =>
                CONTROL_SIG(2) <= "101111111";
                CODE_SIG <= "11001"; -- LETRA U
            WHEN "101111111" =>
                CONTROL_SIG(2) <= "011111111";
                CODE_SIG <= "10101"; -- LETRA O
            WHEN OTHERS =>
                CONTROL_SIG(2) <= "111011111";
                CODE_SIG <= "00001"; -- NUMERO DEL REFRESCO (1)        
        END CASE;
        
        CASE CONTROL_SIG(3) IS
            WHEN "11101111"&'1' =>
                CONTROL_SIG(3) <= "11011111"&'1';
                CODE_SIG <= "00001"; -- LETRA I/1
            WHEN "11011111"&'1' =>
                CONTROL_SIG(3) <= "10111111"&'1';
                CODE_SIG <= "10000"; -- LETRA A
            WHEN "10111111"&'1' =>
                CONTROL_SIG(3) <= "01111111"&'1';
                CODE_SIG <= "10011"; -- LETRA F
            WHEN OTHERS =>
                CONTROL_SIG(3) <= "11101111"&'1';
                CODE_SIG <= "10100"; -- LETRA L
        END CASE;
        
    END IF; 
    
CONTROL <= CONTROL_SIG(3)&CONTROL_SIG(2)&CONTROL_SIG(1)&CONTROL_SIG(0);  
CODE <= CODE_SIG;   
            
end process;
end Behavioral;
