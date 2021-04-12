
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	
	ZegarTOF[0].IN:=Lazienka[0].Suszarka.diHand;
	ZegarTOF[0].PT:=REAL_TO_TIME(LazienkaPar[0].Suszarka.uiCzasOFF*1000); //GUI -> sekundy ->TIME
	ZegarTOF[0]();
	
	ZegarTON[0].IN:=ZegarTOF[0].Q;;
	ZegarTON[0].PT:=REAL_TO_TIME(LazienkaPar[0].Suszarka.uiCzasON*1000); //GUI -> sekundy ->TIME
	ZegarTON[0](); //Function update Block -> exe
	Lazienka[0].Suszarka.doDmuchawa:=ZegarTON[0].Q AND ZegarTOF[0].Q AND NOT(Lazienka[0].Suszarka.diTermik);
	
	IF EDGEPOS(Lazienka[0].Suszarka.doDmuchawa) THEN (*edgepos zbocza narastaj¹ce*);
		LazienkaPar[0].Suszarka.uiLiczbaOnOff:=LazienkaPar[0].Suszarka.uiLiczbaOnOff+1;
	END_IF
	
	
	ZegarTON[1].IN:=NOT(ZegarTON[1].Q) AND Lazienka[0].Suszarka.doDmuchawa ;
	ZegarTON[1].PT:=T#1s;
	ZegarTON[1](); //generator sekund pierwszy sposób odlicznczania 
	
	IF ZegarTON[1].Q THEN
		LazienkaPar[0].Suszarka.uiCzasPracy.uiSekundy:=LazienkaPar[0].Suszarka.uiCzasPracy.uiSekundy+1;
	END_IF
	
	IF LazienkaPar[0].Suszarka.uiCzasPracy.uiSekundy>=60 THEN
		LazienkaPar[0].Suszarka.uiCzasPracy.uiMinuty:=LazienkaPar[0].Suszarka.uiCzasPracy.uiMinuty+1;
		LazienkaPar[0].Suszarka.uiCzasPracy.uiSekundy:=0;
	END_IF
	
	IF LazienkaPar[0].Suszarka.uiCzasPracy.uiMinuty>=60 THEN
		LazienkaPar[0].Suszarka.uiCzasPracy.uiGodziny:=LazienkaPar[0].Suszarka.uiCzasPracy.uiGodziny+1;
		LazienkaPar[0].Suszarka.uiCzasPracy.uiMinuty:=0;
	END_IF

	IF (((TIME_TO_DINT(ZegarTON[0].ET) MOD 1000)=0) AND (TIME_TO_DINT(ZegarTON[0].ET)>0) AND (Lazienka[0].Suszarka.doDmuchawa)) THEN
		LazienkaPar[1].Suszarka.uiCzasPracy.uiSekundy:=LazienkaPar[1].Suszarka.uiCzasPracy.uiSekundy+1;
	END_IF
	
	IF LazienkaPar[1].Suszarka.uiCzasPracy.uiSekundy>=60 THEN
		LazienkaPar[1].Suszarka.uiCzasPracy.uiMinuty:=LazienkaPar[1].Suszarka.uiCzasPracy.uiMinuty+1;
		LazienkaPar[1].Suszarka.uiCzasPracy.uiSekundy:=0;
	END_IF
	
	IF LazienkaPar[1].Suszarka.uiCzasPracy.uiMinuty>=60 THEN
		LazienkaPar[1].Suszarka.uiCzasPracy.uiGodziny:=LazienkaPar[1].Suszarka.uiCzasPracy.uiGodziny+1;
		LazienkaPar[1].Suszarka.uiCzasPracy.uiMinuty:=0;
	END_IF
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

