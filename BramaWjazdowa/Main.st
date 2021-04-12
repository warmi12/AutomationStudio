
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(*Rozruch systemu*)
	Mechanizm[0].Operator.doSystemAktywny:=(Mechanizm[0].Operator.diStart OR Mechanizm[0].Operator.doSystemAktywny) AND
	Mechanizm[0].Operator.diStop AND Mechanizm[0].Operator.diEStop AND NOT(Mechanizm[0].Operator.doAwaria); 
	
	(*Mechanizm otwierania bramy*)

	Mechanizm[0].Gate.doOpenGate := (Mechanizm[0].Operator.diGateOpen OR Mechanizm[0].Operator.Pilot.diGateOpen) 
	AND NOT(Mechanizm[0].Operator.doAwaria) AND Mechanizm[0].Gate.diTemperature
	AND Mechanizm[0].Gate.diGateOpened;

//	Mechanizm[0].Operator.diGateOpen:=Mechanizm[0].Gate.doOpenGate;
	
	(*Mechanizm zamykania bramy*)
	
	Mechanizm[0].Gate.doCloseGate := (Mechanizm[0].Operator.diGateClose OR Mechanizm[0].Operator.Pilot.diGateClose) 
	AND NOT(Mechanizm[0].Operator.doAwaria) AND Mechanizm[0].Gate.diTemperature AND Mechanizm[0].Gate.diSafetySensor
	AND Mechanizm[0].Gate.diGateClosed;

//	Mechanizm[0].Operator.diGateClose:=Mechanizm[0].Gate.doCloseGate;
	
	
	(*Diagnostyka*)
	Mechanizm[0].Operator.doAwaria := NOT(Mechanizm[0].Gate.diTemperature AND Mechanizm[0].Gate.diSafetySensor) 
	OR (Mechanizm[0].Operator.doAwaria AND NOT(Mechanizm[0].Operator.diKasujAwaria))
	OR NOT(Mechanizm[0].Gate.diGateClosed OR Mechanizm[0].Gate.diGateOpened);

	ZegarTON[0].IN:=ZegarTOF[0].Q;
	ZegarTON[0].PT:= T#1000ms;
	ZegarTON[0]();

	ZegarTOF[0].IN:= NOT(ZegarTON[0].Q);
	ZegarTOF[0].PT:= T#1000ms;
	ZegarTOF[0]();	

	Mechanizm[0].Gate.doLampa:= (Mechanizm[0].Operator.diGateOpen OR Mechanizm[0].Operator.diGateClose) AND ZegarTON[0].Q; 
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

