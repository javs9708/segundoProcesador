library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PSR is
    Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           salidaPSR : out  STD_LOGIC;
           nzvc : in  STD_LOGIC_VECTOR (3 downto 0);
			  ncwp : in  STD_LOGIC;
           cwp : out  STD_LOGIC
			  );
end PSR;

architecture Behavioral of PSR is
signal PSRegister: STD_LOGIC_VECTOR (31 DOWNTO 0):= (others=>'0');

begin

process(clk,reset)
	begin
		if(reset = '1') then
				cwp<= '0';
				salidaPSR <= '0';
		else
			if(rising_edge(clk))then
				PSRegister(23 downto 20) <= nzvc;
				PSRegister(0) <= ncwp;
				salidaPSR <= PSRegister(20);
				cwp <= ncwp;
			end if;
		end if;
	end process;
end Behavioral;

