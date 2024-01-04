library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity FSM_tb is
end;

architecture bench of FSM_tb is

  component FSM
      Generic(
          N_REFRESCOS: POSITIVE;
          N_ESTADOS: POSITIVE;
          N_DISPLAYS: POSITIVE;
          SIZE_CODE: POSITIVE           
      );
      Port( 
          CLK : in STD_LOGIC;
          PAGAR : in STD_LOGIC;
          PAGO_OK : in STD_LOGIC;
          TIPO_REFRESCO: in STD_LOGIC_VECTOR (N_REFRESCOS - 1 downto 0);
          ERROR_COUNTER : in STD_LOGIC;
          CONTROL_IN : in STD_LOGIC_VECTOR (N_DISPLAYS * N_ESTADOS - 1 downto 0);
          CODE_IN:in STD_LOGIC_VECTOR (SIZE_CODE * N_ESTADOS - 1 downto 0);
          RESET : in STD_LOGIC;
          ERROR : out STD_LOGIC;
          REFRESCO_OUT : out STD_LOGIC;
          ESTADOS_OUT : out STD_LOGIC_VECTOR(N_ESTADOS - 1 downto 0);
          CONTROL_OUT : out STD_LOGIC_VECTOR (N_DISPLAYS - 1 downto 0);
          CODE_OUT: out STD_LOGIC_VECTOR (SIZE_CODE - 1 downto 0)
      );
  end component;

  constant N_REFRESCOS: POSITIVE := 2;
  constant N_ESTADOS: POSITIVE := 4;
  constant N_DISPLAYS: POSITIVE := 9;
  constant SIZE_CODE: POSITIVE := 5;
  signal CLK: STD_LOGIC;
  signal PAGAR: STD_LOGIC;
  signal PAGO_OK: STD_LOGIC;
  signal TIPO_REFRESCO: STD_LOGIC_VECTOR (N_REFRESCOS - 1 downto 0);
  signal ERROR_COUNTER: STD_LOGIC;
  signal CONTROL_IN: STD_LOGIC_VECTOR (N_DISPLAYS * N_ESTADOS - 1 downto 0);
  signal CODE_IN: STD_LOGIC_VECTOR (SIZE_CODE * N_ESTADOS - 1 downto 0);
  signal RESET: STD_LOGIC;
  signal ERROR: STD_LOGIC;
  signal REFRESCO_OUT: STD_LOGIC;
  signal ESTADOS_OUT: STD_LOGIC_VECTOR(N_ESTADOS - 1 downto 0);
  signal CONTROL_OUT: STD_LOGIC_VECTOR (N_DISPLAYS - 1 downto 0);
  signal CODE_OUT: STD_LOGIC_VECTOR (SIZE_CODE - 1 downto 0) ;

  constant clock_period: time := 10 ns;

begin

  uut: FSM generic map ( N_REFRESCOS   => N_REFRESCOS,
                         N_ESTADOS     => N_ESTADOS,
                         N_DISPLAYS    => N_DISPLAYS,
                         SIZE_CODE     => SIZE_CODE)
              port map ( CLK           => CLK,
                         PAGAR         => PAGAR,
                         PAGO_OK       => PAGO_OK,
                         TIPO_REFRESCO => TIPO_REFRESCO,
                         ERROR_COUNTER => ERROR_COUNTER,
                         CONTROL_IN    => CONTROL_IN,
                         CODE_IN       => CODE_IN,
                         RESET         => RESET,
                         ERROR         => ERROR,
                         REFRESCO_OUT  => REFRESCO_OUT,
                         ESTADOS_OUT   => ESTADOS_OUT,
                         CONTROL_OUT   => CONTROL_OUT,
                         CODE_OUT      => CODE_OUT );

   CLK_TREATMENT: process
   begin

    CLK <= '0';
    wait for 0.5 * clock_period;

    CLK <= '1';
    wait for 0.5 * clock_period;

   end process;

  stimulus: process
  begin
  
    -- INICIALIZAMOS LAS ENTRADAS
    PAGAR <= '0';
    ERROR_COUNTER <= '0';
    PAGO_OK <= '0';
    TIPO_REFRESCO <= (OTHERS => '0');
    RESET <= '0'; --RESET PULSADO
    CODE_IN <= (OTHERS => '0');
    CONTROL_IN <= (OTHERS => '0');
    WAIT FOR CLOCK_PERIOD;
    
    RESET <= '1';
    PAGAR <= '1';
    ASSERT ESTADOS_OUT <= "0001"
        REPORT "ESTADOS SHOULD BE 0001";
    WAIT FOR CLOCK_PERIOD;
    
    --PASAMOS AL ESTADO DE PAGO UNA VEZ HEMOS SELECCIONADO UN REFRESCO Y PAGAR ESTÁ A 1
    TIPO_REFRESCO <= "01";
    WAIT FOR CLOCK_PERIOD;
    ASSERT ESTADOS_OUT <= "0010"
        REPORT "ESTADO SHOULD BE 0010";
    
    --EL CONTADOR DA LA ORDEN DE QUE SE HA COMPLETADO EL PAGO Y PASAMOS AL ESTADO 3    
    PAGO_OK <= '1';
    WAIT FOR CLOCK_PERIOD;
    ASSERT ESTADOS_OUT <= "0100" AND REFRESCO_OUT <= '1'
        REPORT "ESTADOS SHOULD BE 0100 AND REFRESCO_OUT 1";
        
    --PASAMOS AL ESTADO REPOSO PONIENDO PAGAR A 0
     PAGAR <= '0'; -- ESTO TAMBIEN RESETEA EL CONTADOR
     PAGO_OK <= '0';
     WAIT FOR CLOCK_PERIOD;
     
     PAGAR <= '1';
     WAIT FOR CLOCK_PERIOD;
     
     ERROR_COUNTER <= '1';
     WAIT FOR CLOCK_PERIOD;
     ASSERT ESTADOS_OUT <= "1000" AND ERROR <='1'
        REPORT "ESTADOS SHOULD BE 1000 AND ERROR 1";
    
    assert false
    report "Success: simulation finished."
    severity failure;

    wait;
  end process;


end;
