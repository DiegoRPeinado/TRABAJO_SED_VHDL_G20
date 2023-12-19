library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
    ASYNC_IN: in STD_LOGIC_VECTOR (5 downto 0); -- JUNTAMOS TOODAS LAS SEÑALES EN UNA
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
signal AUX5: std_logic; --Conecta PAGAR del SYNC con el COUNTER y la FSM
signal AUX6: std_logic; --Conecta TIPO_TEFRSCO del SYNC con el COUNTER y la FSM
begin

SYNC: SYNCHRNZR PORT MAP(
CLK => CLK,
ASYNC_IN(5) => TIPO_REFRESCO,
ASYNC_IN(4) => PAGAR,
ASYNC_IN(3 downto 0) => MONEDAS,
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
ERROR => AUX4);

ESTADOS: FSM PORT MAP(
CLK => CLK,
PAGAR => AUX5,
PAGO_OK => AUX3,
ERROR_COUNTER => AUX4,
TIPO_REFRESCO => AUX6,
RESET => RESET,
ERROR => ERROR,
REFRESCO_OUT => REFRESCO_OUT);

end Estructural;
