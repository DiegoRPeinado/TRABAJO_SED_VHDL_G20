----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2023 16:13:40
-- Design Name: 
-- Module Name: DECODER - Behavioral
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


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;


ENTITY decoder IS
GENERIC(
     SIZE_CODE: POSITIVE;
     N_SEGMENTOS: POSITIVE      
);
PORT (
    CODE : IN std_logic_vector(SIZE_CODE - 1 DOWNTO 0);
    SEGMENTOS : OUT std_logic_vector(N_SEGMENTOS - 1 DOWNTO 0)
);
END ENTITY decoder;


ARCHITECTURE dataflow OF decoder IS
BEGIN
WITH CODE SELECT
SEGMENTOS <= "0000001" WHEN "00000",
"1001111" WHEN "00001",
"0010010" WHEN "00010",
"0000110" WHEN "00011",
"1001100" WHEN "00100",
"0100100" WHEN "00101",
"0100000" WHEN "00110",
"0001111" WHEN "00111",
"0000000" WHEN "01000",
"0000100" WHEN "01001",
"0001000" WHEN "10000", -- LETRA A
"1000010" WHEN "10001", -- LETRA D
"0110000" WHEN "10010", -- LETRA E
"0111000" WHEN "10011", -- LETRA F
"1110001" WHEN "10100", -- LETRA L
"1100010" WHEN "10101", -- LETRA O
"0011000" WHEN "10110", -- LETRA P
"1111010" WHEN "10111", -- LETRA R
"1110000" WHEN "11000", -- LETRA T
"1100011" WHEN "11001", -- LETRA U
"1111110" WHEN others;

END ARCHITECTURE dataflow;