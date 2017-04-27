library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PSRM is
    Port ( reset : in  STD_LOGIC;
           operador2 : in  STD_LOGIC;
           registro1 : in  STD_LOGIC;
           nzvc : out  STD_LOGIC_VECTOR (3 downto 0);
           ResultadoAlu : in  STD_LOGIC_VECTOR (31 downto 0);
           AluOpcion : in  STD_LOGIC_VECTOR (5 downto 0));
end PSRM;

architecture Behavioral of PSRM is

begin

process(AluOpcion,registro1,operador2,ResultadoAlu,reset)
	begin
	
	if (reset = '1')then
		nzvc <= (others => '0');
		
	else		
		if(AluOpcion = "001001" or AluOpcion = "001011")then --Addcc - Addxcc	
			nzvc(3) <= ResultadoAlu(31);	
			if(ResultadoAlu = X"00000000")then
				nzvc(2) <= '1';
			else
				nzvc(2) <= '0';
			end if;		--verificar esta linea de abajo mirar si va el not en el or
			nzvc(1) <= (registro1 and operador2 and (not ResultadoAlu(31))) or ((not registro1) and (not operador2) and ResultadoAlu(31));
			nzvc(0) <= (registro1 and operador2) or ((not ResultadoAlu(31)) and (registro1 or operador2));
			
		else
			if(AluOpcion = "001100" or AluOpcion = "001110")then --Subcc - Subxcc
				nzvc(3) <= ResultadoAlu(31);	
				if(ResultadoAlu = X"00000000")then
					nzvc(2) <= '1';
				else
					nzvc(2) <= '0';
				end if;
				nzvc(1) <= ((registro1 and (not operador2) and (not ResultadoAlu(31))) or ((not registro1) and operador2 and ResultadoAlu(31)));
				nzvc(0) <= ((not registro1) and operador2) or (ResultadoAlu(31) and ((not registro1) or operador2));
				
			else
				if(AluOpcion = "001111" or AluOpcion = "010000" or AluOpcion = "010001" or AluOpcion = "010010" or AluOpcion = "010011" or AluOpcion = "010100")then
					nzvc(3) <= ResultadoAlu(31);	
					if(ResultadoAlu = X"00000000")then
						nzvc(2) <= '1';
					else
						nzvc(2) <= '0';
					end if;
					nzvc(1) <= '0';
					nzvc(0) <= '0';
				end if;
			end if;
		end if;
	end if;
	end process;

end Behavioral;

