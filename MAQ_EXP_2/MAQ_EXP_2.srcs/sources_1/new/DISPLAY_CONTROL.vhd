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

entity DISPLAY_CONTROL is
    Generic(
        SIZE_CUENTA: POSITIVE;
        N_REFRESCOS: POSITIVE;
        SIZE_CODE: POSITIVE;
        N_ESTADOS: POSITIVE;
        N_DISPLAYS: POSITIVE
    );
    Port(
        CUENTA : in STD_LOGIC_VECTOR (SIZE_CUENTA - 1 downto 0);
        TIPO_REFRESCO: in STD_LOGIC_VECTOR (N_REFRESCOS - 1 downto 0);
        PRECIOS: in std_logic_vector(N_REFRESCOS * SIZE_CUENTA - 1 downto 0);
        CLK : in STD_LOGIC;
        CODE : out STD_LOGIC_VECTOR (SIZE_CODE * N_ESTADOS - 1 downto 0);
        CONTROL : out STD_LOGIC_VECTOR (N_DISPLAYS * N_ESTADOS - 1 downto 0)
    );
end DISPLAY_CONTROL;

architecture Behavioral of DISPLAY_CONTROL is

-- SE DEFINEN VECTORES DE CODIGO Y CONTROL DE SEGMENTOS PARA CADA ESTADO
subtype CONTROL_ESTADO is STD_LOGIC_VECTOR(N_DISPLAYS - 1 downto 0);
subtype CODE_ESTADO is STD_LOGIC_VECTOR(SIZE_CODE - 1 downto 0);

-- SE DEFINE EL ARRAY QUE CONTENDRÁ TODOS LOS CONTROLES Y CODES DE LOS ESTADOS 
type CONTROL_TOTAL is ARRAY (0 to N_ESTADOS - 1) of CONTROL_ESTADO;
type CODE_TOTAL is ARRAY (0 to N_ESTADOS - 1) of CODE_ESTADO;

-- CREAMOS LAS SEÑALES 
signal CONTROL_SIG : CONTROL_TOTAL;
signal CODE_SIG : CODE_TOTAL;

begin

process(CLK)
begin
    IF rising_edge (CLK) THEN 
    
        CASE CONTROL_SIG(0) IS -- PROD 1 / PROD 2
            WHEN "111101111" =>
                CONTROL_SIG(0) <= "111011111";
                CODE_SIG(0) <= "10001"; -- LETRA D
            WHEN "111011111" =>
                CONTROL_SIG(0) <= "110111111";
                CODE_SIG(0) <= "10101"; -- LETRA O
            WHEN "110111111" =>
                CONTROL_SIG(0) <= "101111111";
                CODE_SIG(0) <= "10111"; -- LETRA R
            WHEN "101111111" =>
                CONTROL_SIG(0) <= "011111111";
                CODE_SIG(0) <= "10110"; -- LETRA P
            WHEN OTHERS =>
                CONTROL_SIG(0) <= "111101111";
                IF TIPO_REFRESCO = "01" THEN
                    CODE_SIG(0) <= "00001"; -- NUMERO DEL PRODUCTO
                ELSIF TIPO_REFRESCO = "10" THEN
                    CODE_SIG(0) <= "00010"; -- NUMERO DEL PRODUCTO
                ELSE CODE_SIG(0) <= "00000";
                END IF;          
        END CASE;
        
        CASE CONTROL_SIG(1) IS -- MUESTRA EL PRECIO DEL REFRESCO Y LO QUE FALTA PARA PAGAR
            WHEN "111111101" =>
                CONTROL_SIG(1) <= "111111011";
                -- MOSTRAMOS EL PRIMER DECIMAL DEL PRECIO QUE FALTA PARA PAGAR
                -- SI FALTA POR PAGAR 90C, SACARÁ POR PANTALLA UN 9
                IF TIPO_REFRESCO = "01" THEN
                    IF PRECIOS(SIZE_CUENTA - 1 downto 0) - CUENTA >= "01010" THEN
                        CODE_SIG(1) <= PRECIOS(SIZE_CUENTA - 1 downto 0) - "01010" - CUENTA;
                    ELSE 
                        CODE_SIG(1) <= PRECIOS(SIZE_CUENTA - 1 downto 0) - CUENTA;
                    END IF;
                 ELSIF TIPO_REFRESCO = "10" THEN
                    IF PRECIOS((SIZE_CUENTA*2) - 1 downto SIZE_CUENTA - 1) - CUENTA >= "01010" THEN
                        CODE_SIG(1) <= PRECIOS((SIZE_CUENTA*2) - 1 downto SIZE_CUENTA) - "01010" - CUENTA;
                    ELSE 
                        CODE_SIG(1) <= PRECIOS((SIZE_CUENTA*2) - 1 downto SIZE_CUENTA) - CUENTA;
                    END IF;
                END IF;                      
                --DP <= '1';
            WHEN "111111011" =>
                CONTROL_SIG(1) <= "111110110";
                -- MOSTRAMOS LA UNIDAD DEL PRECIO (EN EUROS) QUE FALTA POR PAGAR 
                -- SI TENEMOS QUE PAGAR MENOS DE UN EURO, SERÁ 0
                IF TIPO_REFRESCO = "01" THEN
                    IF PRECIOS(SIZE_CUENTA - 1 downto 0) - CUENTA >= "01010" THEN
                        CODE_SIG(1) <= "00001";
                    ELSE CODE_SIG(1) <= "00000";
                    END IF;
                ELSIF TIPO_REFRESCO = "10" THEN
                    IF PRECIOS((SIZE_CUENTA*2) - 1 downto SIZE_CUENTA - 1) - CUENTA >= "01010" THEN
                        CODE_SIG(1) <= "00001";
                    ELSE CODE_SIG(1) <= "00000";
                    END IF;
                END IF;
                --DP <= '0'; 
            WHEN "111110110" =>
                CONTROL_SIG(1) <= "111011111";
                 -- Sacamos por pantalla el segundo decimal del precio del refresco: 0 siempre
                CODE_SIG(1) <= "00000"; 
                --DP <= '1';
            WHEN "111011111" =>
                CONTROL_SIG(1) <= "110111111";
                IF TIPO_REFRESCO = "01" THEN
                    -- Sacamos por pantalla el primer decimal del precio de 1.00€ (10 - 10)
                    CODE_SIG(1) <= PRECIOS(SIZE_CUENTA - 1 downto 0) - "01010"; 
                ELSIF TIPO_REFRESCO = "10" THEN
                    -- Sacamos por pantalla el primer decimal del precio de 1.30€ (13 - 10)
                    CODE_SIG(1) <= PRECIOS((SIZE_CUENTA*2) - 1 downto SIZE_CUENTA)- "01010";
                END IF;
                --DP <= '1';
            WHEN "110111111" =>
                CONTROL_SIG(1) <= "101111110";
                -- Sacamos por pantalla la unidad del precio del refresco: 1€ siempre
                CODE_SIG(1) <= "00001"; 
                --DP <= '0';
            WHEN OTHERS =>
                CONTROL_SIG(1) <= "111111101";
                CODE_SIG(1) <= "00000";
                --DP <= '1';
        END CASE;
        
        CASE CONTROL_SIG(2) IS -- EL REFRESCO HA SALIDO: OUT 1 / OUT 2
            WHEN "111011111" =>
                CONTROL_SIG(2) <= "110111111";
                CODE_SIG(2) <= "11000"; -- LETRA T
            WHEN "110111111" =>
                CONTROL_SIG(2) <= "101111111";
                CODE_SIG(2) <= "11001"; -- LETRA U
            WHEN "101111111" =>
                CONTROL_SIG(2) <= "011111111";
                CODE_SIG(2) <= "10101"; -- LETRA O
            WHEN OTHERS =>
                CONTROL_SIG(2) <= "111011111";
                IF TIPO_REFRESCO = "01" THEN
                    CODE_SIG(2) <= "00001"; -- NUMERO DEL REFRESCO (1)      
                ELSIF TIPO_REFRESCO = "10" THEN
                    CODE_SIG(2) <= "00010"; -- NUMERO DEL REFRESCO (1) 
                END IF; 
        END CASE;
        
        CASE CONTROL_SIG(3) IS -- SE HA SOBREPASADO EL PRECIO DEL REFRESCO
            WHEN "11101111"&'1' =>
                CONTROL_SIG(3) <= "11011111"&'1';
                CODE_SIG(3) <= "00001"; -- LETRA I/1
            WHEN "11011111"&'1' =>
                CONTROL_SIG(3) <= "10111111"&'1';
                CODE_SIG(3) <= "10000"; -- LETRA A
            WHEN "10111111"&'1' =>
                CONTROL_SIG(3) <= "01111111"&'1';
                CODE_SIG(3) <= "10011"; -- LETRA F
            WHEN OTHERS =>
                CONTROL_SIG(3) <= "11101111"&'1';
                CODE_SIG(3) <= "10100"; -- LETRA L
        END CASE;
        
    END IF; 
    
CONTROL <= CONTROL_SIG(3)&CONTROL_SIG(2)&CONTROL_SIG(1)&CONTROL_SIG(0);  
CODE <= CODE_SIG(3)&CODE_SIG(2)&CODE_SIG(1)&CODE_SIG(0);   
            
end process;
end Behavioral;
