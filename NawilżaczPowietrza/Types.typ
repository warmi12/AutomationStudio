TYPE
	SystemTyp : STRUCT
		diStart : BOOL;
		diStop : BOOL;
		diEStop : BOOL;
		diKasujAwaria: BOOL;
		doSystemAktywny : BOOL;
		doAwaria : BOOL;
	END_STRUCT;
	
	HeaterTyp : STRUCT
		doGrzalka : ARRAY[0..2] OF BOOL;
		diTemperatura : ARRAY[0..1] OF BOOL;
		doNawilzacz : BOOL;
		diWilgotnosc : BOOL;
	  
	END_STRUCT;
		  
END_TYPE