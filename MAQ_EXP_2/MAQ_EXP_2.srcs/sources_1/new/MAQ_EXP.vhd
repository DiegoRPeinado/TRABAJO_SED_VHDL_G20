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
    Generic(
        N_MONEDAS: POSITIVE := 4;
        N_ESTADOS: POSITIVE := 4;
        N_SEGMENTOS: POSITIVE := 7;
        N_DISPLAYS: POSITIVE := 9; -- 8 más el punto decimal
        SIZE_CUENTA: POSITIVE := 5;
        SIZE_CODE: POSITIVE := 4      
    );
    
    Port(
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        PAGAR : in STD_LOGIC;
        MONEDAS : in STD_LOGIC_VECTOR (N_MONEDAS - 1 downto 0);
        TIPO_REFRESCO : in STD_LOGIC;
        ERROR : out STD_LOGIC;
        REFRESCO_OUT : out STD_LOGIC;
        ESTADOS: out STD_LOGIC_VECTOR (N_ESTADOS - 1 downto 0);
        LED_AUX5: out STD_LOGIC;
        LED_RESET: out STD_LOGIC;
        SEGMENTOS: out STD_LOGIC_VECTOR(N_SEGMENTOS - 1 downto 0);
        DIGCTRL: out STD_LOGIC_VECTOR(N_DISPLAYS - 1 downto 0)
     );
     
end MAQ_EXP;

architecture Estructural of MAQ_EXP is

component SYNCHRNZR is
    Generic(
        N_MONEDAS: POSITIVE      
    );
    Port(
        CLK : in STD_LOGIC;
        ASYNC_MONEDAS: in STD_LOGIC_VECTOR (N_MONEDAS - 1 downto 0); 
        ASYNC_PAGAR: in STD_LOGIC;
        ASYNC_TIPO_REFRESCO: in STD_LOGIC;
        SYNCD_MONEDAS: out STD_LOGIC_VECTOR (N_MONEDAS - 1 downto 0);
        SYNCD_PAGAR: out STD_LOGIC;
        SYNCD_TIPO_REFRESCO: out STD_LOGIC
     );
end component;

component EDGE_DETECTOR is
    Generic(
        N_MONEDAS: POSITIVE      
    );
    Port(
        CLK : in STD_LOGIC;
        MONEDAS_IN : in STD_LOGIC_VECTOR(N_MONEDAS - 1 downto 0); -- 6 bits de se?ales de entrada.
        EDGE_MONEDAS : out STD_LOGIC_VECTOR(N_MONEDAS - 1 downto 0) -- Salida de detecci?n de flanco.
    );
end component;

component COUNTER is
    Generic(
        N_MONEDAS: POSITIVE;
        SIZE_CUENTA: POSITIVE      
    );
    Port(
        CLK: in std_logic;
        CE: in std_logic;
        RESET: in std_logic;
        MONEDAS: in std_logic_vector(N_MONEDAS - 1 downto 0);
        TIPO_REFRESCO: in std_logic;
        ERROR: out std_logic;
        PAGO_OK: out std_logic;
        CUENTA: out std_logic_vector(SIZE_CUENTA - 1 downto 0)
   );
end component;

component FSM is
    Generic(
        N_ESTADOS: POSITIVE;
        N_DISPLAYS: POSITIVE      
    );
    Port( 
        CLK : in STD_LOGIC;
        PAGAR : in STD_LOGIC;
        PAGO_OK : in STD_LOGIC;
        ERROR_COUNTER : in STD_LOGIC;
        TIPO_REFRESCO : in STD_LOGIC;
        CONTROL_IN : in STD_LOGIC_VECTOR (N_DISPLAYS - 1 downto 0);
        RESET : in STD_LOGIC;
        ERROR : out STD_LOGIC;
        REFRESCO_OUT : out STD_LOGIC;
        ESTADOS_OUT : out STD_LOGIC_VECTOR(N_ESTADOS - 1 downto 0);
        CONTROL_OUT : out STD_LOGIC_VECTOR (N_DISPLAYS - 1 downto 0)
    );
end component;

component DISPLAY_CONTROL is
    Generic(
        SIZE_CUENTA: POSITIVE;
        SIZE_CODE: POSITIVE;
        N_DISPLAYS: POSITIVE
    );
    Port(
        CUENTA : in STD_LOGIC_VECTOR (SIZE_CUENTA - 1 downto 0);
        CLK : in STD_LOGIC;
        CODE : out STD_LOGIC_VECTOR (SIZE_CODE - 1 downto 0);
        CONTROL : out STD_LOGIC_VECTOR (N_DISPLAYS - 1 downto 0)
    );
end component;

component DECODER is
    Generic(
         SIZE_CODE: POSITIVE;
         N_SEGMENTOS: POSITIVE      
    );
    Port(
        CODE : IN std_logic_vector(SIZE_CODE - 1 DOWNTO 0);
        CUENTA_LEDS : OUT std_logic_vector(N_SEGMENTOS - 1 DOWNTO 0)
    );
end component;

component PRESCALER is
    Port (
    CLK : in STD_LOGIC;
    CLK_OUT : out STD_LOGIC);
end component;

signal AUX1: std_logic_vector (N_MONEDAS - 1 DOWNTO 0); --Conecta MONEDAS[] de SYNC con el EDGE_DETECTOR
signal AUX2: std_logic_vector (N_MONEDAS - 1 DOWNTO 0); --Conecta MONEDAS[] de EDGE_DET con el COUNTER
signal AUX3: std_logic; --Conecta PAGO_OK del COUNTER con la FSM
signal AUX4: std_logic; --Conec0ta ERROR del COUNTER con la FSM
signal AUX5: std_logic; --Conecta PAGAR del SYNC con el COUNTER y la FSM
signal AUX6: std_logic; --Conecta TIPO_TEFRSCO del SYNC con el COUNTER y la FSM
signal AUX7: std_logic_vector (SIZE_CUENTA - 1 downto 0); --Conecta CUENTA del counter con CUENTA del DISPLAY_CONTROL
signal AUX8: std_logic_vector (SIZE_CODE - 1 downto 0); --Conecta CODE del DISPLAY_CONTROL con CODE del DECODIFICADOR
signal AUX9: std_logic_vector (N_DISPLAYS - 1 downto 0); --Conecta CONTROL del DISPLAY_CONTROL con CONTROL de la FSM
signal AUX_CLK: std_logic; --Conecta CLK_OUT del prescaler con la entrada CLK de DISPLAY_CONTROL
--signal SEGMENTOS: std_logic_vector(6 downto 0); --Salida del DECODER que le llega al display)
--signal DIGCTRL:  std_logic_vector(8 downto 0); --Salida de la FSM que controla que display se ha encendido y el punto decimal
begin 

SYNC: SYNCHRNZR 
GENERIC MAP(
    N_MONEDAS => N_MONEDAS
    )
PORT MAP(
    CLK => CLK,
    ASYNC_TIPO_REFRESCO => TIPO_REFRESCO,
    ASYNC_PAGAR => PAGAR,
    ASYNC_MONEDAS => MONEDAS,
    SYNCD_MONEDAS => AUX1,
    SYNCD_PAGAR => AUX5,
    SYNCD_TIPO_REFRESCO => AUX6
    );

EDGE: EDGE_DETECTOR 
GENERIC MAP(
    N_MONEDAS => N_MONEDAS
    )
PORT MAP(
    CLK => CLK,
    MONEDAS_IN => AUX1,
    EDGE_MONEDAS => AUX2
    );

CTR: COUNTER 
GENERIC MAP(
    N_MONEDAS => N_MONEDAS,
    SIZE_CUENTA => SIZE_CUENTA
    )
PORT MAP(
    CLK => CLK,
    CE => AUX5,
    RESET => RESET,
    TIPO_REFRESCO => AUX6,
    MONEDAS => AUX2,
    PAGO_OK => AUX3,
    ERROR => AUX4,
    CUENTA => AUX7
    );

MAQ_ESTADOS: FSM
GENERIC MAP(
    N_ESTADOS => N_ESTADOS,
    N_DISPLAYS => N_DISPLAYS
    )
PORT MAP(
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
    CONTROL_OUT => DIGCTRL
);

CONTROL: DISPLAY_CONTROL 
GENERIC MAP(
    SIZE_CUENTA => SIZE_CUENTA,
    SIZE_CODE => SIZE_CODE,
    N_DISPLAYS => N_DISPLAYS
)
PORT MAP(
    CUENTA => AUX7,
    CLK => AUX_CLK,
    CODE => AUX8,
    CONTROL => AUX9
);

DECODE: DECODER 
GENERIC MAP(
    SIZE_CODE => SIZE_CODE,
    N_SEGMENTOS => N_SEGMENTOS
)
PORT MAP(
    CODE => AUX8,
    CUENTA_LEDS => SEGMENTOS
);

LED_AUX5 <= PAGAR;
LED_RESET <= RESET;

CLK_DIV: PRESCALER PORT MAP(
CLK => CLK,
CLK_OUT => AUX_CLK);

end Estructural;
