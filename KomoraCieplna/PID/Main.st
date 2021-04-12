
PROGRAM _INIT
END_PROGRAM

PROGRAM _CYCLIC
	cPID[0].ActValue:= gPID.TemperaturePV; (* Pobranie wartoœci temperatury w KomCont *)
	gPID.HeaterCV:= cPID[0].Out; (* Wys³anie sygna³u steruj¹cego grza³k¹ do KomCont *)
	cPID[0].SetValue:= gKomoraPar[0].TemperatureSP; (* Pobranie wartoœci zadanej z GUI *)
	cPID[0].Enable:= gPID.Enable; (* Aktywacja bêdzie z poziomu KomCont Start-Stop*)
	
	IF gAutoTuningOnOff=FALSE THEN (* Pobranie odpowiednich parametrów do regulatora*)
		cPID[0].PIDParameters.Gain:=cPIDPar[0].Kp;
		cPID[0].PIDParameters.IntegrationTime:=cPIDPar[0].Ti;
		cPID[0].PIDParameters.DerivativeTime:=cPIDPar[0].Td;
	ELSE
		cPID[0].PIDParameters.Gain:=gKp;
		cPID[0].PIDParameters.IntegrationTime:=gTi;
		cPID[0].PIDParameters.DerivativeTime:=gTd;
	END_IF;
	
	cPID[0].PIDParameters.FilterTime:=cPIDPar[0].Tf;
	cPID[0].MaxOut:=cPIDPar[0].CVmax;
	cPID[0].MinOut:=cPIDPar[0].CVmin;
	cPID[0](); //FUB - function update block
	
	IF EDGEPOS(gPID.Enable) THEN		(* Przygotowanie zmiennych (program móg³ byæ ju¿ wczeœniej uruchomiony) *)
		SampleTON[0].IN:=TRUE;  		(* Uruchomienie zegarka próbkuj¹cego *)
		SampleTON[0].PT:=T#1h;
		
		SampleTON[1].IN:=TRUE;			(* Uruchomienie zegara wykorzystywanego do wskaŸników ca³kowych*)
		SampleTON[1].PT:=T#1h;
		
		i:=0;							(* Zmienna pozwalaj¹ca na przypisanie maxPv w innym indexie *)
		f:=FALSE;						(* flaga mówi¹ca czy maksimum zosta³o osi¹gniête *)
		PvMax[0]:=0;
		PvMax[1]:=0;
		PvMax[2]:=0;
		
		Samples[0]:=0;					(* Wyzerowanie próbek sprawdzaj¹cych w jakim stanie jest proces *)
		Samples[1]:=0;

		Statystyka.KryteriaOdcinkowe.Mp:=0;		(* Wyzerowanie wskaŸników jakoœci *)
		Statystyka.KryteriaOdcinkowe.Mpp:=0;
		Statystyka.KryteriaOdcinkowe.Osc:=0;
		Statystyka.KryteriaOdcinkowe.Tn:=0;
		Statystyka.KryteriaOdcinkowe.Tr:=0;
		
		Statystyka.KryteriaCalkowe.IAE:=0;
		Statystyka.KryteriaCalkowe.ISE:=0;
		Statystyka.KryteriaCalkowe.ITAE:=0;
		Statystyka.KryteriaCalkowe.ITSE:=0;
	END_IF;

	IF cPID[0].Enable = TRUE THEN
		IF (PvMax[2]< gPID.TemperaturePV) AND (gPID.TemperaturePV>gKomoraPar[0].TemperatureSP) THEN
			PvMax[2]:=gPID.TemperaturePV;
			Statystyka.KryteriaOdcinkowe.Mp:=PvMax[2]-gKomoraPar[0].TemperatureSP;
			Statystyka.KryteriaOdcinkowe.Mpp:=(Statystyka.KryteriaOdcinkowe.Mp/gKomoraPar[0].TemperatureSP)*100;
			
		END_IF;
		
		
		IF (((TIME_TO_DINT(SampleTON[0].ET) MOD k)=0) AND ((TIME_TO_DINT(SampleTON[0].ET)>0))) THEN	(* Wyliczanie Czasu trwania procesu przejsciowego*)
			Samples[sampleCounter MOD 2]:=gPID.TemperaturePV; (* Przypisywanie danych do konkretnej próbki *)
			sampleCounter:=sampleCounter+1;
			
			IF ((ABS(Samples[1]-Samples[0]) < TOL) AND ((Samples[0] > 0) AND (Samples[1]>0))) THEN (* Sprawdzenie czy ró¿nica z próbek jest < 0 *)
				SampleTON[0].IN:=FALSE;
				Statystyka.KryteriaOdcinkowe.Tr:=TIME_TO_REAL(SampleTON[0].ET)/1000;
			END_IF;
		END_IF;
		
		IF REAL_TO_INT(cPID[0].ActValue)=(REAL_TO_INT(0.1*cPID[0].SetValue))  THEN (* Wyliczanie Czasu narastania *)
			timeTMP:=TIME_TO_REAL(SampleTON[0].ET)/1000; (* U¿ycie zegarka wykorzystywanego do wyznaczania czasu przejœcia procesu do stanu stabilnego *)
		END_IF;
		
		IF REAL_TO_INT(cPID[0].ActValue)=(REAL_TO_INT(0.9*cPID[0].SetValue)) THEN (* Wyliczanie Czasu narastania *)
			Statystyka.KryteriaOdcinkowe.Tn:=(TIME_TO_REAL(SampleTON[0].ET)/1000)-timeTMP;
		END_IF;
		
		IF cPID[0].ActValue>cPID[0].SetValue THEN (*Wy³apanie pierwszego oraz drugiego MaxPV *)
			IF PvMax[i] < cPID[0].ActValue THEN
				PvMax[i]:=cPID[0].ActValue;
			ELSE
				f:=TRUE;	(* flaga mówi¹ca czy maksimum zosta³o osi¹gniête *)
			END_IF;
		END_IF;
				
		IF cPID[0].ActValue<=cPID[0].SetValue AND f=TRUE THEN (* Wykrycie oscylacji - Po wartoœci MaxPv nasta³o minimum - czyli musimy znaleŸæ kolejne maksimum *)
			i:=1; (* zmienna, pozwalaj¹ca na przypisanie kolejnego MaxPv w innym indexie *)
		END_IF;
		
		IF (PvMax[0] > 0) AND (PvMax[1] > 0) THEN		(* Wyliczenie oscylacji  *)
	  		Statystyka.KryteriaOdcinkowe.Osc:=(PvMax[1]/PvMax[0])*100;
		END_IF;
		
		
		IF ((TIME_TO_DINT(SampleTON[1].ET) MOD PB)=0) AND ((TIME_TO_DINT(SampleTON[1].ET)>0)) AND ((TIME_TO_DINT(SampleTON[1].ET)<l*1000)) THEN (* Wyliczanie wskaŸników ca³kowych *)
			Statystyka.KryteriaCalkowe.IAE:=Statystyka.KryteriaCalkowe.IAE+ABS(cPID[0].SetValue-cPID[0].ActValue);
			Statystyka.KryteriaCalkowe.ISE:=Statystyka.KryteriaCalkowe.ISE+((cPID[0].SetValue-cPID[0].ActValue)*(cPID[0].SetValue-cPID[0].ActValue));
			Statystyka.KryteriaCalkowe.ITAE:=Statystyka.KryteriaCalkowe.ITAE+(ABS(cPID[0].SetValue-cPID[0].ActValue)*(TIME_TO_REAL(SampleTON[1].ET)/1000));
			Statystyka.KryteriaCalkowe.ITSE:=Statystyka.KryteriaCalkowe.ITSE+(((cPID[0].SetValue-cPID[0].ActValue)*(cPID[0].SetValue-cPID[0].ActValue))*(TIME_TO_REAL(SampleTON[1].ET)/1000));
		END_IF;
		
	ELSE
		gPID.HeaterCV:= 0; (* Zatrzymanie procesu sterowania - wciœniêcie Stop b¹dŸ E-Stop *)
	END_IF;
	
	IF EDGENEG(gPID.Enable) THEN
		SampleTON[0].IN:=FALSE;
		SampleTON[1].IN:=FALSE;
	END_IF;
	 
	SampleTON[0]();
	SampleTON[1]();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
END_PROGRAM

