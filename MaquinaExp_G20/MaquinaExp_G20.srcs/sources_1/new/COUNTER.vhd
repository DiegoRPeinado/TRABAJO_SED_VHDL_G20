library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity COUNTER is
  Port (
  CLK: in std_logic;
  CE: in std_logic;
  RESET: in std_logic;
  MONEDAS: in std_logic_vector(3 downto 0);
  TIPO_REFRESCO: in std_logic;
  ERROR: out std_logic;
  PAGO_OK: out std_logic
  );
  
end COUNTER;

architecture Behavioral of COUNTER is
    
    signal CUENTA_SIG: std_logic_vector(4 downto 0) :="00000"; -- va sumando las monedas introducidas
    signal ERROR_SIG: std_logic :='0';
    signal PAGO_OK_SIG: std_logic;
    
begin
process(CLK, RESET)
    --variable CUENTA: std_logic_vector(3 downto 0) := "00000";
    begin 
        if (RESET='1') then 
            CUENTA_SIG <="00000";  -- Inicializo la cuenta
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
        if CUENTA_SIG > "01010" then
            ERROR_SIG <= '1';  -- Me he pasado de 1 euro
            PAGO_OK_SIG <= '0';
        elsif CUENTA_SIG = "01010" then
            PAGO_OK_SIG <= '1'; -- He introducido lo correcto
        elsif CUENTA_SIG < "01010" then
            PAGO_OK_SIG <= '0'; -- No he metido suficiente 
        end if;   
        
end process;
 
ERROR <= ERROR_SIG;
PAGO_OK <= PAGO_OK_SIG;

end Behavioral;
