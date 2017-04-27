LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tbPSR IS
END tbPSR;
 
ARCHITECTURE behavior OF tbPSR IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PSR
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         salidaPSR : OUT  std_logic;
         nzvc : IN  std_logic_vector(3 downto 0);
         ncwp : IN  std_logic;
         cwp : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal nzvc : std_logic_vector(3 downto 0) := (others => '0');
   signal ncwp : std_logic := '0';

 	--Outputs
   signal salidaPSR : std_logic;
   signal cwp : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PSR PORT MAP (
          reset => reset,
          clk => clk,
          salidaPSR => salidaPSR,
          nzvc => nzvc,
          ncwp => ncwp,
          cwp => cwp
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      reset<='1';
		ncwp<='0';
		nzvc<="0101";
      wait for 100 ns;	
		reset<='0';
		ncwp<='1';
      wait;
   end process;

END;
