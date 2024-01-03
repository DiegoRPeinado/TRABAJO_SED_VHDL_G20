----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2023 15:20:43
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
use IEEE.numeric_std .ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity COUNTER is 
    Generic(
        N_MONEDAS: POSITIVE;
        N_REFRESCOS: POSITIVE;
        SIZE_CUENTA: POSITIVE      
    );
    Port(
        CLK: in std_logic;
        CE: in std_logic;
        RESET: in std_logic;
        MONEDAS: in std_logic_vector(N_MONEDAS - 1 downto 0);
        TIPO_REFRESCO: in std_logic_vector(N_REFRESCOS - 1 downto 0);
        ERROR: out std_logic;
        PAGO_OK: out std_logic;
        CUENTA: out std_logic_vector(SIZE_CUENTA - 1 downto 0);
        PRECIOS: out std_logic_vector(N_REFRESCOS * SIZE_CUENTA - 1 downto 0)
   );
  
end COUNTER;

architecture Behavioral of COUNTER is

    -- SE DEFINE UN SUBTIPO DEL PRECIO DEL REFRESCO
    subtype PRECIO is std_logic_vector(SIZE_CUENTA - 1 downto 0);

    -- SE DEFINE EL ARRAY QUE CONTENDRÁ TODOS LOS PRECIOS DE LOS REFRESCOS 
    type VECTOR_PRECIOS is ARRAY (0 to N_REFRESCOS - 1) of PRECIO;    
    
    signal CUENTA_SIG: std_logic_vector(SIZE_CUENTA - 1 downto 0) := (OTHERS => '0'); -- va sumando las monedas introducidas
    signal ERROR_SIG: std_logic;
    signal PAGO_OK_SIG: std_logic;
    signal LISTA_PRECIOS: VECTOR_PRECIOS := ("01010","01101"); 
    
begin

process(CLK, RESET)
    begin 
    
            if (RESET='0' OR CE='0') then 
            CUENTA_SIG <= (OTHERS => '0');  -- Inicializo la cuenta
           elsif rising_edge(CLK) and CE='1' then
          -- Suma la moneda introducida al contador CUENTA_SIG
            if MONEDAS = "0001" then 
                CUENTA_SIG <= CUENTA_SIG + "00001";  -- +10cents
            elsif MONEDAS = "0010" then
                CUENTA_SIG <= CUENTA_SIG + "00010";  -- +20cents
            elsif MONEDAS = "0100" then
                CUENTA_SIG <= CUENTA_SIG + "00101";  -- +50cents
            elsif MONEDAS = "1000" then
                CUENTA_SIG <= CUENTA_SIG + "01010";  -- +1€
            end if;
        end if;
        
        -- Comprobamos el estado del dinero
        if TIPO_REFRESCO = "01" then
            if CUENTA_SIG > LISTA_PRECIOS(0) then
                ERROR_SIG <= '1';  -- Me he pasado de 1 euro
                PAGO_OK_SIG <= '0';
            elsif CUENTA_SIG = LISTA_PRECIOS(0) then
                PAGO_OK_SIG <= '1'; -- He introducido lo correcto
                ERROR_SIG <= '0';
            elsif CUENTA_SIG < LISTA_PRECIOS(0) then
                PAGO_OK_SIG <= '0';
                ERROR_SIG <= '0'; -- No he metido suficiente 
            end if;
            
         elsif TIPO_REFRESCO = "10" then           
            if CUENTA_SIG > LISTA_PRECIOS(1) then
                ERROR_SIG <= '1';  -- Me he pasado de 1 euro
                PAGO_OK_SIG <= '0';
            elsif CUENTA_SIG = LISTA_PRECIOS(1) then
                PAGO_OK_SIG <= '1'; -- He introducido lo correcto
                ERROR_SIG <= '0';
            elsif CUENTA_SIG < LISTA_PRECIOS(1) then
                PAGO_OK_SIG <= '0';
                ERROR_SIG <= '0'; -- No he metido suficiente 
            end if;
         end if;
        
end process;
 
ERROR <= ERROR_SIG;
PAGO_OK <= PAGO_OK_SIG;
CUENTA <= CUENTA_SIG;
PRECIOS <= LISTA_PRECIOS(1) & LISTA_PRECIOS(0);

end Behavioral;
