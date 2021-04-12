
PROGRAM _INIT
	AutoTuning.Amax:=gKomoraPar[0].TemperatureSP;
	AutoTuning.Amin:=gKomoraPar[0].TemperatureSP;
END_PROGRAM

PROGRAM _CYCLIC
	//AutoTuning.Amin:=gKomoraPar[0].TemperatureSP;
	cOnOff[0].ActValue:= gOnOff.TemperaturePV; (* Pobranie wartoœci temperatury w KomCont *)
	gOnOff.HeaterCV:= cOnOff[0].Out; (* Wys³anie sygna³u steruj¹cego grza³k¹ do KomCont *)
	gAutoTuningOnOff:=cOnOffPar[0].uiAutoTuningOnOff;
	cOnOff[0].SetValue:= gKomoraPar[0].TemperatureSP; (* Pobranie wartoœci zadanej z GUI *)
	cOnOff[0].Enable:= gOnOff.Enable; (* Aktywacja bêdzie z poziomu KomCont Start-Stop*)
	cOnOff[0].uiError:= cOnOff[0].SetValue - cOnOff[0].ActValue; (* SP-PV -> wêze³ sumacyjny -> Schemat *)
	
	IF EDGEPOS(cOnOff[0].Enable) THEN 					(* Przystosowanie parametrów do startu algorytmu *)
		AutoTuning.flag:=FALSE;  						(* flaga do startu/stopu zegarka *)
		AutoTuning.P:=0;								(* Zmienna przechowywuj¹ca okres od CVpos do CVpos *)
		AutoTuning.Amax:=gKomoraPar[0].TemperatureSP;   (* Przypisanie wartoœci Max (poniewa¿ program móg³ byæ wczeœniej uruchomiony - i mog³a zostaæ tam poprzednia wartoœæ ) *)
		AutoTuning.Amin:=gKomoraPar[0].TemperatureSP;	(* Przypisanie wartoœci Min (poniewa¿ program móg³ byæ wczeœniej uruchomiony - i mog³a zostaæ tam poprzednia wartoœæ ) *)
	END_IF;
	
	IF cOnOff[0].Enable = TRUE THEN
		IF cOnOff[0].uiError >= cOnOffPar[0].uiEmax THEN
			cOnOff[0].Out:= cOnOffPar[0].uiCVmax;
			AutoTuning.fTempOnOff:=TRUE;				(* flaga wskazuj¹ca czy CV uleg³o zmianie *)
		ELSIF cOnOff[0].uiError <= cOnOffPar[0].uiEmin THEN
			cOnOff[0].Out:= cOnOffPar[0].uiCVmin;
			AutoTuning.fTempOnOff:=FALSE;				(* flaga wskazuj¹ca czy CV uleg³o zmianie *)
		END_IF;	
	ELSE
		cOnOff[0].Out:= 0; (* Zatrzymanie procesu sterowania - wciœniêcie Stop b¹dŸ E-Stop *)
	END_IF;
	
	(* G³ówna czêœæ eksperymentu przekaŸnikowego *) 
	IF (cOnOff[0].Enable AND cOnOffPar[0].uiAutoTuningOnOff) AND (AutoTuning.fLicznik >cOnOffPar[0].uiLicznik) THEN (* Licznik po to aby sprawdziæ czy proces jest w stanie quasi-stabilnym *)
		(* Szukanie max i min amplitudy *)
		IF gOnOff.TemperaturePV>AutoTuning.Amax THEN
			AutoTuning.Amax:=gOnOff.TemperaturePV;
		ELSIF gOnOff.TemperaturePV<AutoTuning.Amin THEN
			AutoTuning.Amin:=gOnOff.TemperaturePV;
		END_IF;
			
		(* Odmierzenie okresu od za³¹czonego CV do za³¹czonego CV *)
		IF EDGEPOS(AutoTuning.fTempOnOff) THEN 
			AutoTuning.flag:=NOT(AutoTuning.flag);
			DelayTON[1].IN:=AutoTuning.flag;
			DelayTON[1].PT:=T#1h;
			IF AutoTuning.flag=FALSE THEN
	 			 AutoTuning.P:=(TIME_TO_REAL(DelayTON[1].ET)/1000);
			END_IF;
		END_IF;
	END_IF;
	
	IF EDGENEG(AutoTuning.fTempOnOff) AND cOnOffPar[0].uiAutoTuningOnOff THEN (* Dodawanie do licznika (wartoœæ SP+Emin przekroczona) *)
		AutoTuning.fLicznik:=AutoTuning.fLicznik+1;
	END_IF;
	
	(* Wyliczenie wartoœci Kp,Ti,Td oraz przekazanie ich do globalnych zmiennych *)
	IF EDGENEG(cOnOff[0].Enable) AND cOnOffPar[0].uiAutoTuningOnOff THEN
		AutoTuning.H:=(cOnOffPar[0].uiCVmax-cOnOffPar[0].uiCVmin)/2;
		AutoTuning.Amplituda:=(AutoTuning.Amax-AutoTuning.Amin)/2;
		AutoTuning.K:=(4*AutoTuning.H)/(3.14159265359*AutoTuning.Amplituda);
		gKp:=0.6*AutoTuning.K;
		gTi:=AutoTuning.P/2;
		gTd:=AutoTuning.P/8;
		AutoTuning.fLicznik:=0;		(* Przygotowanie zmiennych do ponownego uruchomienia *)
		AutoTuning.flag:=FALSE;
	END_IF;
		
	
	DelayTON[1]();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

