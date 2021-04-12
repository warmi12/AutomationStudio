TYPE
	OperatorTyp : STRUCT
		diStart : BOOL;
		diStop : BOOL:= TRUE;
		diEStop : BOOL := TRUE;
		diKasujAwaria: BOOL; (*Przycisk kasowania awarii*)
		doSystemAktywny: BOOL; (*Lampka systemu aktywny*)
		doAwaria : BOOL; (*Lampka Awaria*)
		diGateOpen : BOOL;
		diGateClose : BOOL;	
		Pilot : PilotTyp;
	END_STRUCT;
	
	PilotTyp : STRUCT
		diGateOpen : BOOL;
		diGateClose : BOOL;
		diEStop : BOOL := TRUE;
	END_STRUCT;

	GateTyp : STRUCT
		diSafetySensor : BOOL := TRUE;
		diGateClosed : BOOL:= TRUE;
		diGateOpened : BOOL:= TRUE;
		diTemperature : BOOL := TRUE;
		doOpenGate : BOOL;
		doCloseGate : BOOL;
		doLampa : BOOL;
	END_STRUCT;
	
	SystemTyp : STRUCT
		Operator : OperatorTyp;
		Gate : GateTyp;
	END_STRUCT;
		  
END_TYPE

