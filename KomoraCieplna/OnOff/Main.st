
PROGRAM _INIT
	AutoTuning.Amax:=gKomoraPar[0].TemperatureSP;
	AutoTuning.Amin:=gKomoraPar[0].TemperatureSP;
END_PROGRAM

PROGRAM _CYCLIC
	//AutoTuning.Amin:=gKomoraPar[0].TemperatureSP;
	cOnOff[0].ActValue:= gOnOff.TemperaturePV; (* Pobranie warto�ci temperatury w KomCont *)
	gOnOff.HeaterCV:= cOnOff[0].Out; (* Wys�anie sygna�u steruj�cego grza�k� do KomCont *)
	gAutoTuningOnOff:=cOnOffPar[0].uiAutoTuningOnOff;
	cOnOff[0].SetValue:= gKomoraPar[0].TemperatureSP; (* Pobranie warto�ci zadanej z GUI *)
	cOnOff[0].Enable:= gOnOff.Enable; (* Aktywacja b�dzie z poziomu KomCont Start-Stop*)
	cOnOff[0].uiError:= cOnOff[0].SetValue - cOnOff[0].ActValue; (* SP-PV -> w�ze� sumacyjny -> Schemat *)
	
	IF EDGEPOS(cOnOff[0].Enable) THEN 					(* Przystosowanie parametr�w do startu algorytmu *)
		AutoTuning.flag:=FALSE;  						(* flaga do startu/stopu zegarka *)
		AutoTuning.P:=0;								(* Zmienna przechowywuj�ca okres od CVpos do CVpos *)
		AutoTuning.Amax:=gKomoraPar[0].TemperatureSP;   (* Przypisanie warto�ci Max (poniewa� program m�g� by� wcze�niej uruchomiony - i mog�a zosta� tam poprzednia warto�� ) *)
		AutoTuning.Amin:=gKomoraPar[0].TemperatureSP;	(* Przypisanie warto�ci Min (poniewa� program m�g� by� wcze�niej uruchomiony - i mog�a zosta� tam poprzednia warto�� ) *)
	END_IF;
	
	IF cOnOff[0].Enable = TRUE THEN
		IF cOnOff[0].uiError >= cOnOffPar[0].uiEmax THEN
			cOnOff[0].Out:= cOnOffPar[0].uiCVmax;
			AutoTuning.fTempOnOff:=TRUE;				(* flaga wskazuj�ca czy CV uleg�o zmianie *)
		ELSIF cOnOff[0].uiError <= cOnOffPar[0].uiEmin THEN
			cOnOff[0].Out:= cOnOffPar[0].uiCVmin;
			AutoTuning.fTempOnOff:=FALSE;				(* flaga wskazuj�ca czy CV uleg�o zmianie *)
		END_IF;	
	ELSE
		cOnOff[0].Out:= 0; (* Zatrzymanie procesu sterowania - wci�ni�cie Stop b�d� E-Stop *)
	END_IF;
	
	(* G��wna cz�� eksperymentu przeka�nikowego *) 
	IF (cOnOff[0].Enable AND cOnOffPar[0].uiAutoTuningOnOff) AND (AutoTuning.fLicznik >cOnOffPar[0].uiLicznik) THEN (* Licznik po to aby sprawdzi� czy proces jest w stanie quasi-stabilnym *)
		(* Szukanie max i min amplitudy *)
		IF gOnOff.TemperaturePV>AutoTuning.Amax THEN
			AutoTuning.Amax:=gOnOff.TemperaturePV;
		ELSIF gOnOff.TemperaturePV<AutoTuning.Amin THEN
			AutoTuning.Amin:=gOnOff.TemperaturePV;
		END_IF;
			
		(* Odmierzenie okresu od za��czonego CV do za��czonego CV *)
		IF EDGEPOS(AutoTuning.fTempOnOff) THEN 
			AutoTuning.flag:=NOT(AutoTuning.flag);
			DelayTON[1].IN:=AutoTuning.flag;
			DelayTON[1].PT:=T#1h;
			IF AutoTuning.flag=FALSE THEN
	 			 AutoTuning.P:=(TIME_TO_REAL(DelayTON[1].ET)/1000);
			END_IF;
		END_IF;
	END_IF;
	
	IF EDGENEG(AutoTuning.fTempOnOff) AND cOnOffPar[0].uiAutoTuningOnOff THEN (* Dodawanie do licznika (warto�� SP+Emin przekroczona) *)
		AutoTuning.fLicznik:=AutoTuning.fLicznik+1;
	END_IF;
	
	(* Wyliczenie warto�ci Kp,Ti,Td oraz przekazanie ich do globalnych zmiennych *)
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

