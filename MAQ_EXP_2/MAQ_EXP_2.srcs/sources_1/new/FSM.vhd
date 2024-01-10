library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
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
end FSM;

architecture Behavioral of FSM is

type STATES is (S0,S1,S2,S3);
signal CURRENT_STATE: STATES := S0;
signal NEXT_STATE: STATES;

begin

    state_register: process(RESET, CLK)
    begin
        if RESET = '0' then
            CURRENT_STATE <= S0;
        elsif rising_edge(CLK) then
            CURRENT_STATE <= NEXT_STATE;
        end if;
    end process;
    
    nextstate: process(CLK) --, PAGAR, PAGO_OK, ERROR_COUNTER, CURRENT_STATE)
    begin
        NEXT_STATE <= CURRENT_STATE;
        case CURRENT_STATE is 
            when S0 =>
                if PAGAR = '1' AND TIPO_REFRESCO /= "00" then
                    NEXT_STATE <= S1;
                end if;                
            when S1 =>
                if PAGO_OK = '1' then
                    NEXT_STATE <= S2;
                elsif ERROR_COUNTER = '1' then
                    NEXT_STATE <= S3;
                end if;                
            when S2 =>
                if PAGAR = '0' then
                    NEXT_STATE <= S0;
                end if;           
            when S3 =>
                if RESET = '0' then
                    NEXT_STATE <= S0;
                end if;            
        end case;
    end process;
    
    output_control: process(CLK, CURRENT_STATE)
    begin
        case CURRENT_STATE is 
            when S0 =>
                ERROR <= '0';
                REFRESCO_OUT <= '0';
                ESTADOS_OUT <= "0001";
                CONTROL_OUT <= CONTROL_IN(N_DISPLAYS - 1 DOWNTO 0);
                CODE_OUT <= CODE_IN(SIZE_CODE - 1 DOWNTO 0);
                
            when S1 =>
                ERROR <= '0';
                REFRESCO_OUT <= '0';
                ESTADOS_OUT  <= "0010";
                CONTROL_OUT <= CONTROL_IN((N_DISPLAYS * 2) - 1 DOWNTO N_DISPLAYS);
                CODE_OUT <= CODE_IN((SIZE_CODE * 2) - 1 DOWNTO SIZE_CODE);
            when S2 =>
                ERROR <= '0';
                REFRESCO_OUT <= '1';
                ESTADOS_OUT <= "0100";
                CONTROL_OUT <= CONTROL_IN((N_DISPLAYS * 3) - 1 DOWNTO N_DISPLAYS * 2);
                CODE_OUT <= CODE_IN((SIZE_CODE * 3) - 1 DOWNTO SIZE_CODE * 2);
            when S3 =>
                ERROR <= '1';
                REFRESCO_OUT <= '0';
                ESTADOS_OUT <= "1000";
                CONTROL_OUT <= CONTROL_IN((N_DISPLAYS * 4) - 1 DOWNTO N_DISPLAYS * 3);
                CODE_OUT <= CODE_IN((SIZE_CODE * 4) - 1 DOWNTO SIZE_CODE * 3);
        end case;
    end process;

end Behavioral;