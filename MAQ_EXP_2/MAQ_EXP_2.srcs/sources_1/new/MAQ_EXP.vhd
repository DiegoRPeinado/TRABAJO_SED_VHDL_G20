----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2023 15:20:43
-- Design Name: 
-- Module Name: MAQ_EXP - Structural
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

entity MAQ_EXP is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           PAGAR : in STD_LOGIC;
           MONEDAS : in STD_LOGIC_VECTOR (3 downto 0);
           TIPO_REFRESCO : in STD_LOGIC;
           ERROR : out STD_LOGIC;
           REFRESCO_OUT : out STD_LOGIC;
           ESTADOS: out std_logic_vector (3 downto 0);
           LED_AUX5: out STD_LOGIC;
           LED_RESET: out STD_LOGIC;
           SEGMENTOS: out STD_LOGIC_VECTOR(6 downto 0);
           DIGCTRL: out STD_LOGIC_VECTOR(7 downto 0));
end MAQ_EXP;

architecture Estructural of MAQ_EXP is

component SYNCHRNZR is
    Port (
    CLK : in STD_LOGIC;
    ASYNC_MONEDAS: in STD_LOGIC_VECTOR (3 downto 0); 
    ASYNC_PAGAR: in STD_LOGIC;
    ASYNC_TIPO_REFRESCO: in STD_LOGIC;
    SYNCD_MONEDAS: out STD_LOGIC_VECTOR (3 downto 0);
    SYNCD_PAGAR: out STD_LOGIC;     
    SYNCD_TIPO_REFRESCO: out STD_LOGIC);
end component;

component EDGE_DETECTOR is
    Port ( 
    CLK : in STD_LOGIC;
    MONEDAS_IN : in STD_LOGIC_VECTOR (3 downto 0);
    EDGE_MONEDAS : out STD_LOGIC_VECTOR (3 downto 0));   
end component;

component COUNTER is
    Port ( 
    CLK : in STD_LOGIC;
    CE : in STD_LOGIC;
    RESET : in STD_LOGIC;
    TIPO_REFRESCO : in std_logic;
    MONEDAS : in STD_LOGIC_VECTOR (3 downto 0);
    PAGO_OK : out STD_LOGIC;
    ERROR : out STD_LOGIC;
    CUENTA: out STD_LOGIC_VECTOR (4 downto 0));
end component;

component FSM is
    Port ( 
    CLK : in STD_LOGIC;
    PAGAR : in STD_LOGIC;
    PAGO_OK : in STD_LOGIC;
    ERROR_COUNTER : in STD_LOGIC;
    TIPO_REFRESCO : in STD_LOGIC;
    CONTROL_IN : in STD_LOGIC_VECTOR (7 downto 0);
    RESET : in STD_LOGIC;
    ERROR : out STD_LOGIC;
    REFRESCO_OUT : out STD_LOGIC;
    ESTADOS_OUT : out STD_LOGIC_VECTOR(3 downto 0);
    CONTROL_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component DISPLAY_CONTROL is
    Port( 
    CUENTA : in STD_LOGIC_VECTOR (4 downto 0);
    CLK : in STD_LOGIC;
    CODE : out STD_LOGIC_VECTOR (3 downto 0);
    CONTROL : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component DECODER is
   Port (
   CODE : IN std_logic_vector(3 DOWNTO 0);
   CUENTA_LEDS : OUT std_logic_vector(6 DOWNTO 0)
);
end component;

component PRESCALER is
    Port (
    CLK : in STD_LOGIC;
    CLK_OUT : out STD_LOGIC);
end component;

signal AUX1: std_logic_vector (3 DOWNTO 0); --Conecta MONEDAS[] de SYNC con el EDGE_DETECTOR
signal AUX2: std_logic_vector (3 DOWNTO 0); --Conecta MONEDAS[] de EDGE_DET con el COUNTER
signal AUX3: std_logic; --Conecta PAGO_OK del COUNTER con la FSM
signal AUX4: std_logic; --Conec0ta ERROR del COUNTER con la FSM
signal AUX5: std_logic; --Conecta PAGAR del SYNC con el COUNTER y la FSM
signal AUX6: std_logic; --Conecta TIPO_TEFRSCO del SYNC con el COUNTER y la FSM
signal AUX7: std_logic_vector (4 downto 0); --Conecta CUENTA del counter con CUENTA del DISPLAY_CONTROL
signal AUX8: std_logic_vector (3 downto 0); --Conecta CODE del DISPLAY_CONTROL con CODE del DECODIFICADOR
signal AUX9: std_logic_vector (7 downto 0); --Conecta CONTROL del DISPLAY_CONTROL con CONTROL de la FSM
signal AUX_CLK: std_logic; --Conecta CLK_OUT del prescaler con la entrada CLK de DISPLAY_CONTROL
begin 

SYNC: SYNCHRNZR PORT MAP(
CLK => CLK,
ASYNC_TIPO_REFRESCO => TIPO_REFRESCO,
ASYNC_PAGAR => PAGAR,
ASYNC_MONEDAS => MONEDAS,
SYNCD_MONEDAS => AUX1,
SYNCD_PAGAR => AUX5,
SYNCD_TIPO_REFRESCO => AUX6);

EDGE: EDGE_DETECTOR PORT MAP(
CLK => CLK,
MONEDAS_IN => AUX1,
EDGE_MONEDAS => AUX2);

CTR: COUNTER PORT MAP(
CLK => CLK,
CE => AUX5,
RESET => RESET,
TIPO_REFRESCO => AUX6,
MONEDAS => AUX2,
PAGO_OK => AUX3,
ERROR => AUX4,
CUENTA => AUX7);

MAQ_ESTADOS: FSM PORT MAP(
CLK => CLK,
PAGAR => AUX5, 
PAGO_OK => AUX3,
ERROR_COUNTER => AUX4,
TIPO_REFRESCO => AUX6,
CONTROL_IN => AUX9,
RESET => RESET,
ERROR => ERROR,
REFRESCO_OUT => REFRESCO_OUT,
ESTADOS_OUT => ESTADOS,
CONTROL_OUT => DIGCTRL);

CONTROL: DISPLAY_CONTROL PORT MAP(
CUENTA => AUX7,
CLK => AUX_CLK,
CODE => AUX8,
CONTROL => AUX9);

DECODE: DECODER PORT MAP(
CODE => AUX8,
CUENTA_LEDS => SEGMENTOS);

LED_AUX5 <= PAGAR;
LED_RESET <= RESET;

CLK_DIV: PRESCALER PORT MAP(
CLK => CLK,
CLK_OUT => AUX_CLK);

end Estructural;
