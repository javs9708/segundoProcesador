LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tbPSRM IS
END tbPSRM;
 
ARCHITECTURE behavior OF tbPSRM IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PSRM
    PORT(
         reset : IN  std_logic;
         operador2 : IN  std_logic;
         registro1 : IN  std_logic;
         nzvc : OUT  std_logic_vector(3 downto 0);
         ResultadoAlu : IN  std_logic_vector(31 downto 0);
         AluOpcion : IN  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal operador2 : std_logic := '0';
   signal registro1 : std_logic := '0';
   signal ResultadoAlu : std_logic_vector(31 downto 0) := (others => '0');
   signal AluOpcion : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal nzvc : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PSRM PORT MAP (
          reset => reset,
          operador2 => operador2,
          registro1 => registro1,
          nzvc => nzvc,
          ResultadoAlu => ResultadoAlu,
          AluOpcion => AluOpcion
        );


 

   -- Stimulus process
   stim_proc: process
   begin		
      ResultadoAlu <= x"00000000";
		registro1 <= '1';
 		operador2 <= '1';
		AluOpcion <= "001001";
      wait for 100 ns;	
		ResultadoAlu <= x"0000000F";
		registro1 <= '1';
 		operador2 <= '0';
		AluOpcion <= "001100";
		wait for 100 ns;
		ResultadoAlu <= x"F000010F";
		registro1 <= '0';
 		operador2 <= '1';
		AluOpcion <= "001011";
		wait for 100 ns;
		ResultadoAlu <= x"F0000000";
		registro1 <= '0';
 		operador2 <= '0';
		AluOpcion <= "010001";
      wait;
   end process;

END;
