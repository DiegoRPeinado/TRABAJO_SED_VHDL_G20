----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2023 14:25:16
-- Design Name: 
-- Module Name: MAQ_EXP - Behavioral
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

entity MAQ_EXP is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           PAGAR : in STD_LOGIC;
           MONEDAS : in STD_LOGIC_VECTOR (3 downto 0);
           TIPO_REFRESCO : in STD_LOGIC;
           ERROR : out STD_LOGIC;
           REFRESCO_OUT : out STD_LOGIC);
end MAQ_EXP;

architecture Estructural of MAQ_EXP is

component SYNCHRNZR is
    Port (
    CLK : in STD_LOGIC;
    MONEDAS_IN : in STD_LOGIC_VECTOR (3 downto 0);
    MONEDAS_OUT : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component EDGE_DETECTOR is
    Port ( 
    CLK : in STD_LOGIC;
    MONEDAS_IN : in STD_LOGIC_VECTOR (3 downto 0);
    EDGE : out STD_LOGIC_VECTOR (3 downto 0));   
end component;

component COUNTER is
    Port ( 
    CLK : in STD_LOGIC;
    CE : in STD_LOGIC;
    RESET : in STD_LOGIC;
    TIPO_REFRESCO : in std_logic;
    MONEDAS : in STD_LOGIC_VECTOR (3 downto 0);
    PAGO_OK : out STD_LOGIC;
    ERROR : out STD_LOGIC);
end component;

component FSM is
    Port ( 
    CLK : in STD_LOGIC;
    PAGAR : in STD_LOGIC;
    PAGO_OK : in STD_LOGIC;
    ERROR_COUNTER : in STD_LOGIC;
    TIPO_REFRESCO : in STD_LOGIC;
    RESET : in STD_LOGIC;
    ERROR : out STD_LOGIC;
    REFRESCO_OUT : out STD_LOGIC);
end component;

signal AUX1: std_logic_vector (3 DOWNTO 0); --Conecta MONEDAS[] de SYNC con el EDGE_DETECTOR
signal AUX2: std_logic_vector (3 DOWNTO 0); --Conecta MONEDAS[] de EDGE_DET con el COUNTER
signal AUX3: std_logiC; --Conecta PAGO_OK del COUNTER con la FSM
signal AUX4: std_logiC; --Conecta ERROR del COUNTER con la FSM

begin

SYNC: SYNCHRNZR PORT MAP(
CLK => CLK,
MONEDAS_IN => MONEDAS,
MONEDAS_OUT => AUX1);

EDGE: EDGE_DETECTOR PORT MAP(
CLK => CLK,
MONEDAS_IN => AUX1,
EDGE => AUX2);

CTR: COUNTER PORT MAP(
CLK => CLK,
CE => PAGAR,
RESET => RESET,
TIPO_REFRESCO => TIPO_REFRESCO,
MONEDAS => AUX2,
PAGO_OK => AUX3,
ERROR => AUX4);

ESTADOS: FSM PORT MAP(
CLK => CLK,
PAGAR => PAGAR,
PAGO_OK => AUX3,
ERROR_COUNTER => AUX4,
TIPO_REFRESCO => TIPO_REFRESCO,
RESET => RESET,
ERROR => ERROR,
REFRESCO_OUT => REFRESCO_OUT);

end Estructural;
