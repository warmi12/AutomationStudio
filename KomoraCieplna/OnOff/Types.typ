TYPE
	cOnOffTyp : STRUCT 
		Out : REAL; (* Zmienna steruj�ca CV - Output *)
		ActValue : REAL; (* Zmienna pomierzona PV - Input*)
		SetValue : REAL; (* Zmienna zadana SP - Input*)
		uiError : REAL; (* B��d regulacji SP-PV - Calc*)
		Enable : BOOL; (* Aktywacja algorytmu - wysterowanie z poziomu KomCont*)
	END_STRUCT;
	cOnOffParTyp : STRUCT
		uiCVmax : REAL; (* Amplituda max sygna�u CV *)
		uiCVmin : REAL; (* Ampliuda min sygna�u CV *)
		uiEmax : REAL; (* Maksymalne odchylenie PV od SP *)
		uiEmin : REAL; (* Minimalne ochylenie PV od SP *)
		uiPVmax : REAL; (* Maksymalna warto�� PV *)
		uiPVmin : REAL; (* Minimalna warto�� PV *)
		uiLicznik : INT; (* Zmienna decyduj�ca po ilu przejsciach proces mo�e by� w stanie ustalonym *)
		uiAutoTuningOnOff : BOOL:=TRUE; (* Zmienna w��czaj�ca lub wy��czaj�ca auto strojenie *)
	END_STRUCT;
	
	AutoTuningTyp : STRUCT
		fTempOnOff : BOOL; (* flaga do wyznaczenia wykresuy PU *)
		flag : BOOL:=FALSE; (* flaga do sprawdzenia czy przy edgepos wystartowa�, czy zako�czyc zegar *)
		P : REAL; (* zmienna mierz�ca okres *)
		Amplituda : REAL; (* Zmienna przechowuj�ca Amax-Amin *)
		Amax : REAL; (* Zmienna przechowuj�ca maksymalne odchylenie aplitudy  *)
		Amin : REAL; (* Zmienna przechowuj�ca minimalne odchylenie aplitudy  *)
		K : REAL; (* Zmienna K wyliczona ze wzoru *)
		fLicznik : INT; (* Licznik, kt�ry kontroluje przejscie procesu w stan ustalony *)
		H : REAL;
	END_STRUCT;
	
	
END_TYPE