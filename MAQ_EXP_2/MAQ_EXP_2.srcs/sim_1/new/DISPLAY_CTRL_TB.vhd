library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use ieee.std_logic_unsigned.ALL;

entity DISPLAY_CONTROL_tb is
end;

architecture bench of DISPLAY_CONTROL_tb is

  component DISPLAY_CONTROL
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
  end component; 
  constant SIZE_CUENTA: POSITIVE := 5;
  constant N_REFRESCOS: POSITIVE := 2;
  constant SIZE_CODE: POSITIVE := 5;
  constant N_ESTADOS: POSITIVE := 4;
  constant N_DISPLAYS: POSITIVE := 9;
  signal CUENTA: STD_LOGIC_VECTOR (SIZE_CUENTA - 1 downto 0);
  signal TIPO_REFRESCO: STD_LOGIC_VECTOR (N_REFRESCOS - 1 downto 0);
  signal PRECIOS: std_logic_vector(N_REFRESCOS * SIZE_CUENTA - 1 downto 0);
  signal CLK: STD_LOGIC;
  signal CODE: STD_LOGIC_VECTOR (SIZE_CODE * N_ESTADOS - 1 downto 0);
  signal CONTROL: STD_LOGIC_VECTOR (N_DISPLAYS * N_ESTADOS - 1 downto 0) ;

  constant clock_period: time := 10 ns;

begin

  uut: DISPLAY_CONTROL generic map ( SIZE_CUENTA   => SIZE_CUENTA,
                                     N_REFRESCOS   => N_REFRESCOS,
                                     SIZE_CODE     => SIZE_CODE,
                                     N_ESTADOS     => N_ESTADOS,
                                     N_DISPLAYS    => N_DISPLAYS)
                          port map ( CUENTA        => CUENTA,
                                     TIPO_REFRESCO => TIPO_REFRESCO,
                                     PRECIOS       => PRECIOS,
                                     CLK           => CLK,
                                     CODE          => CODE,
                                     CONTROL       => CONTROL );

  CLK_TREATMENT: process
  begin

  CLK <= '0';
  wait for 0.5 * clock_period;

  CLK <= '1';
  wait for 0.5 * clock_period;

  end process;

  stimulus: process
  begin
  
    PRECIOS <= "01101"&"01010"; -- 1.30€ PARA EL REF. 2 Y 1.00€ PARA EL REDRESCO 1
    TIPO_REFRESCO <= "01"; -- EMPEZAMOS CON EL REFRESCO 1
    CUENTA <= "00000";
    WAIT FOR CLOCK_PERIOD * 5;
    
    -- VAMOS INCREMENTANDO CUENTA HASTA LLEGAR AL PRECIO
    CUENTA <= CUENTA + "00010";
    WAIT FOR CLOCK_PERIOD * 5;
    
    CUENTA <= CUENTA + "00100";
    WAIT FOR CLOCK_PERIOD * 5;
    
    CUENTA <= CUENTA + "00100";
    WAIT FOR CLOCK_PERIOD * 5;
    
    -- AHORA HACEMOS LO MISMO PARA EL OTRO REFRESCO 
    TIPO_REFRESCO <= "10"; -- EMPEZAMOS CON EL REFRESCO 2
    CUENTA <= "00000";
    WAIT FOR CLOCK_PERIOD * 5;
    
    -- VAMOS INCREMENTANDO CUENTA HASTA LLEGAR AL PRECIO
    CUENTA <= CUENTA + "00010";
    WAIT FOR CLOCK_PERIOD * 5;
    
    CUENTA <= CUENTA + "00100";
    WAIT FOR CLOCK_PERIOD * 5;
    
    CUENTA <= CUENTA + "00101";
    WAIT FOR CLOCK_PERIOD * 5;
    
    CUENTA <= CUENTA + "00010";
    WAIT FOR CLOCK_PERIOD * 5;
    
    assert false
    report "Success: simulation finished."
    severity failure;

    wait;
  end process;

end;