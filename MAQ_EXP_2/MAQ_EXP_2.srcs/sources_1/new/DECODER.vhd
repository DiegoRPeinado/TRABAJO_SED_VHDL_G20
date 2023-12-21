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
PORT (
CUENTA_IN : IN std_logic_vector(4 DOWNTO 0);
CUENTA_LEDS : OUT std_logic_vector(6 DOWNTO 0)
);
END ENTITY decoder;


ARCHITECTURE dataflow OF decoder IS
BEGIN
WITH CUENTA_IN SELECT
CUENTA_LEDS <= "0000001" WHEN "00000",
"1001111" WHEN "00001",
"0010010" WHEN "00010",
"0000110" WHEN "00011",
"1001100" WHEN "00100",
"0100100" WHEN "00101",
"0100000" WHEN "00110",
"0001111" WHEN "00111",
"0000000" WHEN "01000",
"0000100" WHEN "01001",
"1111110" WHEN others;
END ARCHITECTURE dataflow;