library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Procesador is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           salidaAlu : out  STD_LOGIC_VECTOR (31 downto 0)
			  );
end Procesador;

architecture Behavioral of Procesador is

COMPONENT PSRM 
    Port ( reset : in  STD_LOGIC;
           operador2 : in  STD_LOGIC;
           registro1 : in  STD_LOGIC;
           nzvc : out  STD_LOGIC_VECTOR (3 downto 0);
           ResultadoAlu : in  STD_LOGIC_VECTOR (31 downto 0);
           AluOpcion : in  STD_LOGIC_VECTOR (5 downto 0));
end COMPONENT;

COMPONENT PSR 
    Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           salidaPSR : out  STD_LOGIC;
           nzvc : in  STD_LOGIC_VECTOR (3 downto 0);
			  ncwp : in  STD_LOGIC;
           cwp : out  STD_LOGIC
			  );
end COMPONENT;

COMPONENT WindowsManager
    Port ( rs1 : in  STD_LOGIC_VECTOR (4 downto 0);
           rs2 : in  STD_LOGIC_VECTOR (4 downto 0);
           rd : in  STD_LOGIC_VECTOR (4 downto 0);
           op : in  STD_LOGIC_VECTOR (1 downto 0);
           op3 : in  STD_LOGIC_VECTOR (5 downto 0);
           nrs1 : out  STD_LOGIC_VECTOR (5 downto 0);
           nrs2 : out  STD_LOGIC_VECTOR (5 downto 0);
           nrd : out  STD_LOGIC_VECTOR (5 downto 0);
           ncwp : out  STD_LOGIC;
           cwp : in  STD_LOGIC);
end COMPONENT;


COMPONENT NProgramCounter
	PORT(
		clk : in  STD_LOGIC;
      reset : in  STD_LOGIC;
      entradaNProgramCounter : in  STD_LOGIC_VECTOR (31 downto 0);
      salidaNProgramCounter : out  STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT ProgramCounter
	PORT(
		clk : in  STD_LOGIC;
      pc_entrada : in  STD_LOGIC_VECTOR (31 downto 0);
      pc_salida : out  STD_LOGIC_VECTOR (31 downto 0);
      reset : in  STD_LOGIC
		);
	END COMPONENT;

	COMPONENT sumador32
	PORT(
		a : in  STD_LOGIC_VECTOR (31 downto 0);
      b : in  STD_LOGIC_VECTOR (31 downto 0);
      salidaSumador : out  STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT InstructionMemory
	PORT(
		address : in  STD_LOGIC_VECTOR (31 downto 0);
      reset : in  STD_LOGIC;
      outInstruction : out  STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT UnidadControl
	PORT(
		op : in  STD_LOGIC_VECTOR (1 downto 0);
      op3 : in  STD_LOGIC_VECTOR (5 downto 0);
      salidaUnidadControl : out  STD_LOGIC_VECTOR (5 downto 0)
		);
	END COMPONENT;
	
	COMPONENT RegisterFile
	PORT(
		nrs1 : in  STD_LOGIC_VECTOR (5 downto 0);
      nrs2 : in  STD_LOGIC_VECTOR (5 downto 0);
      nrd : in  STD_LOGIC_VECTOR (5 downto 0);
      datoEscribir : in  STD_LOGIC_VECTOR (31 downto 0);
      reset : in  STD_LOGIC;
      crs1 : out  STD_LOGIC_VECTOR (31 downto 0);
      crs2 : out  STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT ALU
	PORT(
		dato1Alu : in  STD_LOGIC_VECTOR (31 downto 0);
      dato2Alu : in  STD_LOGIC_VECTOR (31 downto 0);
      operacionAlu : in  STD_LOGIC_VECTOR (5 downto 0);
      salidaAlu : out  STD_LOGIC_VECTOR (31 downto 0);
		carry : in  STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT extensionSigno
	PORT(
		inmediato : in  STD_LOGIC_VECTOR (12 downto 0);
      salida_ext : out  STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT multiplexor32
	PORT(
		entrada1 : in  STD_LOGIC_VECTOR (31 downto 0);
      entrada2 : in  STD_LOGIC_VECTOR (31 downto 0);
      senalControl : in  STD_LOGIC;
      salida_mux : out  STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;
	
	signal suma_out, nPC_out, PC_out, IM_out, CRs1, CRs2, ALUResult, SEU_out, MUX_out : std_logic_vector(31 downto 0);
	signal nzvcSalidaPSRM : std_logic_vector(3 downto 0);
	signal CU_out,Senalnrs1,Senalnrs2,Senalnrd : std_logic_vector(5 downto 0);
	signal carryAlu,ncwpSalidaWM,cwpSalidaPSR: STD_LOGIC;

begin

    Inst_PSRM: PSRM Port Map( 
		reset =>reset,
      operador2 =>MUX_out(31),
      registro1 =>CRs1(31),
      nzvc =>nzvcSalidaPSRM,
      ResultadoAlu =>ALUResult, 
      AluOpcion =>CU_out
	);
	
	Inst_PSR: PSR Port Map( 
		reset =>reset,
		clk =>clk,
      SalidaPSR =>carryAlu,
      nzvc =>nzvcSalidaPSRM,
      ncwp =>ncwpSalidaWM, 
      cwp =>cwpSalidaPSR
	);
	
	
	Inst_WM: WindowsManager Port Map( 
		rs1 =>IM_out(18 downto 14),
		rs2 =>IM_out(4 downto 0),
      rd =>IM_out(29 downto 25),
      op =>IM_out(31 downto 30),
		op3 =>IM_out(24 downto 19),
		nrs1 =>Senalnrs1,
      nrs2 =>Senalnrs2,
      nrd =>Senalnrd,
      ncwp =>ncwpSalidaWM, 
      cwp =>cwpSalidaPSR
	);

	Inst_nPC: NProgramCounter PORT MAP(
		entradaNProgramCounter => suma_out,
		reset => reset,
		clk => clk,
		salidaNProgramCounter => nPC_out
	);
	
	Inst_PC: ProgramCounter PORT MAP(
		pc_entrada => nPC_out,
		reset => reset,
		clk => clk,
		pc_salida => PC_out 
	);
	
	Inst_suma: sumador32 PORT MAP(
		a => x"00000001",
		b => nPC_out,
		salidaSumador => suma_out
	);
	
	Inst_IM: InstructionMemory PORT MAP(
		address => PC_out,
		reset => reset,
		outInstruction => IM_out
	);
	
	Inst_CU: UnidadControl PORT MAP(
		op => IM_out(31 downto 30),
		op3 => IM_out(24 downto 19),
		salidaUnidadControl => CU_out
	);
	
	Inst_RF: RegisterFile PORT MAP(
		reset => reset,
		nrs1 => Senalnrs1,
		nrs2 => Senalnrs2,
		nrd => Senalnrd,
		datoEscribir => ALUResult,
		crs1 => CRs1,
		crs2 => CRs2
	);
	
	Inst_SEU: extensionSigno PORT MAP(
		inmediato => IM_out(12 downto 0),
		salida_ext => SEU_out
	);
	
	Inst_MUX: multiplexor32 PORT MAP(
		entrada1 => CRs2,
		entrada2 => SEU_out,
		salida_mux => MUX_out,
		senalControl => IM_out(13) 
	);	
	
	Inst_ALU: ALU PORT MAP(
		dato1Alu => CRs1,
		dato2Alu => MUX_out,
		operacionAlu => CU_out,
		salidaAlu => ALUResult,
		carry =>carryAlu
	);
	
	salidaAlu <= ALUResult;


end Behavioral;

