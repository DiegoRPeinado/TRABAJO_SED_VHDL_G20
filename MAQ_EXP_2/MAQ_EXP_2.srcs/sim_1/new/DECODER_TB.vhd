library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity DECODER_TB is
end;

architecture bench of DECODER_TB is

  component decoder
  GENERIC(
       SIZE_CODE: POSITIVE;
       N_SEGMENTOS: POSITIVE      
  );
  PORT (
      CODE : IN std_logic_vector(SIZE_CODE - 1 DOWNTO 0);
      SEGMENTOS : OUT std_logic_vector(N_SEGMENTOS - 1 DOWNTO 0)
  );
  end component;
  constant SIZE_CODE: POSITIVE := 5;
  constant N_SEGMENTOS: POSITIVE := 7;
  signal CODE: std_logic_vector(SIZE_CODE - 1 DOWNTO 0);
  signal SEGMENTOS: std_logic_vector(N_SEGMENTOS - 1 DOWNTO 0) ;

begin

  uut: decoder generic map ( SIZE_CODE   => SIZE_CODE,
                             N_SEGMENTOS => N_SEGMENTOS)
                  port map ( CODE        => CODE,
                             SEGMENTOS => SEGMENTOS );

  stimulus: process
  begin
      CODE <= "00000";
      ASSERT SEGMENTOS = "0000001"
        REPORT "SEGMENTOS SHOULD BE 0000001.";
      WAIT FOR 10 ns;
      
      CODE <= "00101";
      ASSERT SEGMENTOS = "0100100"
        REPORT "SEGMENTOS SHOULD BE 0100100.";
      WAIT FOR 10 ns;
      
      CODE <= "10000";
      ASSERT SEGMENTOS = "0001000"
        REPORT "SEGMENTOS SHOULD BE 0001000.";
      WAIT FOR 10 ns;
      
      CODE <= "10011";
      ASSERT SEGMENTOS = "0111000"
        REPORT "SEGMENTOS SHOULD BE 0111000.";
      WAIT FOR 10 ns;
      
      CODE <= "11001";
      ASSERT SEGMENTOS = "1100011"
        REPORT "SEGMENTOS SHOULD BE 1100011.";
      WAIT FOR 10 ns;
      
      assert false
      report "Success: simulation finished."
      severity failure;

    wait;
  end process;


end;